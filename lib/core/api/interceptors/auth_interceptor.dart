import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';
import 'refresh_token_interceptor.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);
  final TokenStorage _storage;
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isApiRequest(options) ||
        RefreshTokenInterceptor.isPublicAuthRequest(options.path)) {
      _removeBearer(options);
      handler.next(options);
      return;
    }
    if (!_storage.isCacheHydrated) await _storage.hydrateCache();
    final session = _storage.cachedActiveSession;
    if (session != null && session.accessToken.isNotEmpty) {
      if ((options.extra['authRole'] != null &&
              options.extra['authRole'] != session.role.apiValue) ||
          (options.extra['authUserId'] != null &&
              options.extra['authUserId'] != session.user.id) ||
          (options.extra['authSessionGeneration'] != null &&
              options.extra['authSessionGeneration'] !=
                  _storage.sessionGeneration)) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            message: 'Account session changed.',
          ),
        );
        return;
      }
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      options.extra['authRole'] = session.role.apiValue;
      options.extra['authUserId'] = session.user.id;
      options.extra['authSessionGeneration'] = _storage.sessionGeneration;
    } else {
      _removeBearer(options);
    }
    handler.next(options);
  }

  void _removeBearer(RequestOptions options) {
    for (final key in options.headers.keys.toList(growable: false)) {
      if (key.toLowerCase() == 'authorization') options.headers.remove(key);
    }
  }

  bool _isApiRequest(RequestOptions options) {
    final base = Uri.tryParse(options.baseUrl), target = options.uri;
    if (base == null ||
        !base.hasAuthority ||
        !target.hasAuthority ||
        target.origin != base.origin) {
      return false;
    }
    final prefix = base.path.replaceAll(RegExp(r'/+$'), '');
    return prefix.isEmpty ||
        target.path == prefix ||
        target.path.startsWith('$prefix/');
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final extra = response.requestOptions.extra;
    if (extra['authRole'] != null) {
      final active = _storage.cachedActiveSession;
      if (active == null ||
          active.role.apiValue != extra['authRole'] ||
          active.user.id != extra['authUserId'] ||
          extra['authSessionGeneration'] != _storage.sessionGeneration) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.cancel,
            message: 'Account session changed.',
          ),
        );
        return;
      }
    }
    handler.next(response);
  }
}
