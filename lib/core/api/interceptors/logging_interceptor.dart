import 'package:dio/dio.dart';

class SafeLoggingInterceptor extends Interceptor {
  String _safeUrl(RequestOptions options) {
    final uri = options.uri;
    final port = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$port${uri.path}';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert(() {
      // Keep logging minimal. Never print tokens or passwords.
      // ignore: avoid_print
      print('[API] ${options.method} ${_safeUrl(options)}');
      return true;
    }());
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[API] ${response.statusCode} ${_safeUrl(response.requestOptions)}');
      return true;
    }());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    assert(() {
      final statusCode = err.response?.statusCode;
      final prefix = statusCode == null ? '[API] ERROR' : '[API] $statusCode';
      // ignore: avoid_print
      print('$prefix ${_safeUrl(err.requestOptions)} (${err.type.name})');
      return true;
    }());
    handler.next(err);
  }
}
