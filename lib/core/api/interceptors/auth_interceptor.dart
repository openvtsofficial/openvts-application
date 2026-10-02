import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final base = Uri.tryParse(options.baseUrl);
    final destination = options.uri;
    final sameOrigin = base != null && base.hasAuthority &&
        base.scheme == destination.scheme && base.host == destination.host &&
        base.port == destination.port;
    if (!sameOrigin || _isPublicRequest(options.path)) {
      options.extra['skipAuthRefresh'] = true;
      options.headers.removeWhere((name, _) => name.toLowerCase() == 'authorization');
      handler.next(options);
      return;
    }

    var token = _tokenStorage.cachedActiveAccessToken;
    if (token == null && !_tokenStorage.isCacheHydrated) {
      await _tokenStorage.hydrateCache();
      token = _tokenStorage.cachedActiveAccessToken;
    }

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      final session = _tokenStorage.cachedActiveSession;
      options.extra['authSessionRole'] = session?.role.apiValue;
      options.extra['authSessionUserId'] = session?.user.id;
      options.extra['authSessionToken'] = token;
      options.extra['authSessionRevision'] = _tokenStorage.sessionRevision;
    }
    handler.next(options);
  }

  bool _isPublicRequest(String value) {
    final path = Uri.tryParse(value)?.path ?? value.split('?').first;
    return path == '/demo' || path.startsWith('/demo/') ||
        const ['/auth/login', '/auth/mfa/verify-login', '/auth/refresh-token',
          '/auth/forgot-password', '/auth/reset-password'].any(path.endsWith);
  }
}
