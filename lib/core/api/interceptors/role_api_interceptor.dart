import 'package:dio/dio.dart';
import '../../../shared/models/user_role.dart';
import '../../storage/token_storage.dart';
import '../api_exception.dart';
import '../team_api_policy.dart';

class RoleApiInterceptor extends Interceptor {
  RoleApiInterceptor(this._storage);
  final TokenStorage _storage;
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _storage.hydrateCache();
    if (_storage.cachedActiveSession?.role != UserRole.team) {
      handler.next(options);
      return;
    }
    final uri = options.uri;
    final base = Uri.parse(options.baseUrl);
    if (!uri.hasAuthority || !base.hasAuthority || uri.origin != base.origin) {
      handler.next(options);
      return;
    }
    final prefix = base.path.replaceAll(RegExp(r'/+$'), '');
    final path = prefix.isNotEmpty && uri.path.startsWith('$prefix/')
        ? uri.path.substring(prefix.length)
        : uri.path;
    try {
      final resolved = TeamApiPolicy.resolve(options.method, path);
      if (resolved != path) {
        options.path = uri.replace(path: '$prefix$resolved').toString();
      }
      handler.next(options);
    } on ApiException catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: options,
            statusCode: 403,
            data: {'message': error.message},
          ),
          error: error,
          message: error.message,
        ),
      );
    }
  }
}
