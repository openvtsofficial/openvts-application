import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../features/auth/models/login_response.dart';
import '../../config/app_config.dart';
import '../../storage/token_storage.dart';
import '../api_endpoints.dart';
import '../api_client.dart';

/// Refreshes an expired session once and shares that refresh across requests.
/// A normal interceptor avoids deadlocking when a retried request also fails.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({required Dio dio, required TokenStorage tokenStorage,
      Dio Function(BaseOptions)? refreshClientFactory})
      : _dio = dio, _tokenStorage = tokenStorage,
        _refreshClientFactory = refreshClientFactory ?? ((options) => Dio(options));

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final Dio Function(BaseOptions) _refreshClientFactory;
  final Map<String, Future<String?>> _refreshes = {};

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final path = Uri.tryParse(request.path)?.path ?? request.path.split('?').first;
    final base = Uri.tryParse(request.baseUrl);
    final sameOrigin = base != null && base.hasAuthority &&
        base.scheme == request.uri.scheme && base.host == request.uri.host &&
        base.port == request.uri.port;
    if (!sameOrigin || request.extra['skipAuthRefresh'] == true ||
        err.response?.statusCode != 401 || request.extra['retried'] == true ||
        path == '/demo' || path.startsWith('/demo/') ||
        const ['/auth/login', '/auth/mfa/verify-login', '/auth/refresh-token',
          '/auth/forgot-password', '/auth/reset-password'].any(path.endsWith)) {
      handler.next(err);
      return;
    }

    final session = await _tokenStorage.getActiveSession();
    if (session == null ||
        (request.extra['authSessionRevision'] != null &&
            request.extra['authSessionRevision'] != _tokenStorage.sessionRevision) ||
        (request.extra['authSessionRole'] != null &&
            request.extra['authSessionRole'] != session.role.apiValue) ||
        (request.extra['authSessionUserId'] != null &&
            request.extra['authSessionUserId'] != session.user.id)) {
      handler.next(err);
      return;
    }

    try {
      // Another simultaneous response may already have refreshed this session.
      final sentToken = request.extra['authSessionToken']?.toString();
      String? token;
      if (sentToken != null && sentToken != session.accessToken) {
        token = session.accessToken;
      } else {
        final key = session.refreshToken;
        var refresh = _refreshes[key];
        if (refresh == null) {
          refresh = _refreshSession(session, request.baseUrl);
          _refreshes[key] = refresh;
        }
        try {
          token = await refresh;
        } finally {
          if (identical(_refreshes[key], refresh)) _refreshes.remove(key);
        }
      }
      if (token == null) { handler.next(err); return; }
      final current = await _tokenStorage.getActiveSession();
      if (current == null || current.user.id != session.user.id ||
          current.role != session.role || current.accessToken != token ||
          (request.extra['authSessionRevision'] != null &&
              request.extra['authSessionRevision'] != _tokenStorage.sessionRevision)) {
        handler.next(err);
        return;
      }
      request.extra['retried'] = true;
      request.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<String?> _refreshSession(RoleSession session, String baseUrl) async {
    final revision = _tokenStorage.sessionRevision;
    if (session.refreshToken.trim().isEmpty) return null;
    final client = _refreshClientFactory(BaseOptions(
      baseUrl: baseUrl.trim().isNotEmpty ? baseUrl : _dio.options.baseUrl,
      connectTimeout: const Duration(seconds: AppConfig.connectTimeoutSeconds),
      receiveTimeout: const Duration(seconds: AppConfig.receiveTimeoutSeconds),
    ));
    try {
      final response = await ApiClient(client).post<Map<String, dynamic>>(
        ApiEndpoints.auth.refreshToken,
        data: {'refresh_token': session.refreshToken},
        parser: (json) => json as Map<String, dynamic>,
      );
      final payload = response.data;
      final login = LoginResponse.fromJson(payload);
      if (login.accessToken.isEmpty || login.refreshToken.isEmpty ||
          login.user.id != session.user.id || login.user.role != session.role) return null;
      final current = await _tokenStorage.getActiveSession();
      // Never revive a session that was signed out or switched during refresh.
      if (current == null || current.refreshToken != session.refreshToken ||
          current.user.id != session.user.id || current.role != session.role) return null;
      final saved = await _tokenStorage.saveRefreshedSession(
          expectedSession: session,
          accessToken: login.accessToken, refreshToken: login.refreshToken,
          currentUserJson: jsonEncode(login.user.toJson()));
      return saved ? login.accessToken : null;
    } on DioException catch (error) {
      // An unavailable server is not proof of an invalid session.
      if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
        await _tokenStorage.clearSessionIfCurrent(
            expectedSession: session, expectedRevision: revision);
      }
      rethrow;
    } finally {
      client.close();
    }
  }
}
