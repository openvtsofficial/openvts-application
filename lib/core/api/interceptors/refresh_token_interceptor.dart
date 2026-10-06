import 'package:dio/dio.dart';

import '../../../features/auth/models/login_response.dart';
import '../../config/app_config.dart';
import '../../storage/token_storage.dart';
import '../api_endpoints.dart';

/// Single-flight refresh, bound to the issuer and login generation of a request.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    Dio Function(BaseOptions)? refreshDioFactory,
    Dio Function(BaseOptions)? refreshClientFactory,
  }) : _dio = dio,
       _storage = tokenStorage,
       _refreshDioFactory =
           refreshDioFactory ?? refreshClientFactory ?? Dio.new;

  final Dio _dio;
  final TokenStorage _storage;
  final Dio Function(BaseOptions) _refreshDioFactory;
  final Map<String, Future<String?>> _refreshing = {};

  static bool isPublicAuthRequest(String value) =>
      AuthSecurityEndpoints.isPublicAuthenticationRequest(value);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        request.extra['authRole'] == null ||
        isPublicAuthRequest(request.path)) {
      handler.next(err);
      return;
    }
    try {
      final generation = request.extra['authSessionGeneration'];
      final session = await _storage.getActiveSession();
      if (session == null ||
          generation != _storage.sessionGeneration ||
          request.extra['authRole'] != session.role.apiValue ||
          request.extra['authUserId'] != session.user.id) {
        handler.next(err);
        return;
      }
      // The Open VTS backend intentionally answers 401 for both an expired
      // token and a role mismatch. After a successful refresh, a repeated 401
      // from the original feature endpoint therefore is NOT proof that the
      // freshly issued session is invalid (for example an Admin token hitting
      // a stale Superadmin request during Login-as navigation).
      //
      // Only the refresh endpoint itself is authoritative for revocation.
      // `_refresh` clears this role session when /auth/refresh-token rejects
      // the refresh token with 401/403. Never destroy a valid child session
      // merely because the retried business request is still unauthorized.
      if (request.extra['retried'] == true) {
        handler.next(err);
        return;
      }
      String? token;
      if (request.headers['Authorization']?.toString() !=
          'Bearer ${session.accessToken}') {
        // A parallel refresh already renewed the same login generation.
        token = session.accessToken;
      } else {
        final base = request.baseUrl.trim().isNotEmpty
            ? request.baseUrl
            : _dio.options.baseUrl;
        final key = '$generation:$base';
        final existing = _refreshing[key];
        if (existing != null) {
          token = await existing;
        } else {
          final refresh = _refresh(session, generation as int, request);
          _refreshing[key] = refresh;
          try {
            token = await refresh;
          } finally {
            if (identical(_refreshing[key], refresh)) _refreshing.remove(key);
          }
        }
      }
      final active = await _storage.getActiveSession();
      if (token == null ||
          generation != _storage.sessionGeneration ||
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

  Future<String?> _refresh(
    RoleSession session,
    int generation,
    RequestOptions request,
  ) async {
    final refreshToken = session.refreshToken.trim();
    if (refreshToken.isEmpty) {
      request.extra['sessionInvalidated'] = await _storage
          .clearSessionIfCurrent(session, generation);
      return null;
    }
    final base = request.baseUrl.trim().isNotEmpty
        ? request.baseUrl
        : _dio.options.baseUrl;
    final client = _refreshDioFactory(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(
          seconds: AppConfig.connectTimeoutSeconds,
        ),
        receiveTimeout: const Duration(
          seconds: AppConfig.receiveTimeoutSeconds,
        ),
      ),
    );
    try {
      final url =
          '${base.replaceAll(RegExp(r'/+$'), '')}${ApiEndpoints.auth.refreshToken}';
      final response = await client.post<dynamic>(
        url,
        data: {'refresh_token': refreshToken},
      );
      dynamic payload = response.data;
      for (
        var depth = 0;
        depth < 3 && payload is Map && payload['data'] is Map;
        depth++
      ) {
        payload = payload['data'];
      }
      if (payload is! Map) throw _invalidRefresh(response);
      final login = LoginResponse.fromJson(Map<String, dynamic>.from(payload));
      if (login.accessToken.isEmpty ||
          login.refreshToken.isEmpty ||
          login.user.role != session.role ||
          login.user.id != session.user.id) {
        // A malformed gateway response is not evidence of session revocation.
        throw _invalidRefresh(response);
      }
      final saved = await _storage.rotateTokensIfCurrent(
        expected: session,
        generation: generation,
        accessToken: login.accessToken,
        refreshToken: login.refreshToken,
        user: login.user,
      );
      return saved ? login.accessToken : null;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        error.requestOptions.extra['sessionInvalidated'] = await _storage
            .clearSessionIfCurrent(session, generation);
      }
      rethrow;
    } finally {
      client.close();
    }
  }

  DioException _invalidRefresh(Response<dynamic> response) => DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
    message: 'The server returned an invalid account session.',
  );
}
