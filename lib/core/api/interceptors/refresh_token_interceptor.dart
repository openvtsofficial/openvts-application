import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../features/auth/models/login_response.dart';
import '../../config/app_config.dart';
import '../../storage/token_storage.dart';
import '../api_endpoints.dart';

/// Single-flight refresh, bound to the identity of the failed request.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
      {required Dio dio,
      required TokenStorage tokenStorage,
      Dio Function(BaseOptions)? refreshDioFactory})
      : _dio = dio,
        _storage = tokenStorage,
        _refreshDioFactory = refreshDioFactory ?? Dio.new;
  final Dio _dio;
  final TokenStorage _storage;
  final Dio Function(BaseOptions) _refreshDioFactory;
  Future<String?>? _refreshing;
  static bool isPublicAuthRequest(String value) =>
      AuthSecurityEndpoints.isPublicAuthenticationRequest(value);
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        request.extra['retried'] == true ||
        request.extra['authRole'] == null ||
        isPublicAuthRequest(request.path)) {
      handler.next(err);
      return;
    }
    try {
      final session = await _storage.getActiveSession();
      if (session == null ||
          request.extra['authRole'] != session.role.apiValue ||
          request.extra['authUserId'] != session.user.id) {
        handler.next(err);
        return;
      }
      String? token;
      if (request.headers['Authorization']?.toString() !=
          'Bearer ${session.accessToken}') {
        token = session.accessToken;
      } else {
        _refreshing ??=
            _refresh(session, request).whenComplete(() => _refreshing = null);
        token = await _refreshing;
      }
      final active = await _storage.getActiveSession();
      if (token == null ||
          active == null ||
          active.role != session.role ||
          active.user.id != session.user.id) {
        handler.next(err);
        return;
      }
      request.extra['retried'] = true;
      request.headers['Authorization'] = 'Bearer $token';
      handler.resolve(await _dio.fetch<dynamic>(request));
    } on DioException catch (error) {
      handler.next(error);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<String?> _refresh(RoleSession session, RequestOptions request) async {
    final refreshToken = session.refreshToken.trim();
    if (refreshToken.isEmpty) return null;
    final base = request.baseUrl.trim().isNotEmpty
        ? request.baseUrl
        : _dio.options.baseUrl;
    final client = _refreshDioFactory(BaseOptions(
        baseUrl: base,
        connectTimeout:
            const Duration(seconds: AppConfig.connectTimeoutSeconds),
        receiveTimeout:
            const Duration(seconds: AppConfig.receiveTimeoutSeconds)));
    try {
      final url =
          '${base.replaceAll(RegExp(r'/+$'), '')}${ApiEndpoints.auth.refreshToken}';
      final response = await client
          .post<dynamic>(url, data: {'refresh_token': refreshToken});
      dynamic payload = response.data;
      for (var depth = 0;
          depth < 3 && payload is Map && payload['data'] is Map;
          depth++) {
        payload = payload['data'];
      }
      if (payload is! Map) return null;
      final login = LoginResponse.fromJson(Map<String, dynamic>.from(payload));
      if (login.accessToken.isEmpty ||
          login.refreshToken.isEmpty ||
          login.user.role != session.role ||
          login.user.id != session.user.id) {
        return null;
      }
      final current = await _storage.getActiveSession();
      if (current?.role != session.role ||
          current?.user.id != session.user.id ||
          current?.refreshToken != refreshToken) {
        return null;
      }
      await _storage.saveSessionForRole(
          role: session.role,
          accessToken: login.accessToken,
          refreshToken: login.refreshToken,
          currentUserJson: jsonEncode(login.user.toJson()));
      return login.accessToken;
    } on DioException catch (error) {
      // A temporary outage must not remove a usable saved session.
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        final current = await _storage.getActiveSession();
        if (current?.role == session.role &&
            current?.user.id == session.user.id &&
            current?.refreshToken == refreshToken) {
          await _storage.clearSessionForRole(session.role);
        }
      }
      rethrow;
    } finally {
      client.close();
    }
  }
}
