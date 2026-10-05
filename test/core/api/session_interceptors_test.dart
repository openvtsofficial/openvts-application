import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/interceptors/auth_interceptor.dart';
import 'package:open_vts/core/api/interceptors/refresh_token_interceptor.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TokenStorage storage;
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage(const FlutterSecureStorage());
    await storage.saveSessionForRole(
        role: UserRole.driver,
        accessToken: 'old-access',
        refreshToken: 'old-refresh',
        currentUserJson: jsonEncode(const CurrentUser(
                id: '7', name: 'Driver', email: '', role: UserRole.driver)
            .toJson()));
  });
  test('public, cross-origin and non-API URLs never carry bearer', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
    dio.interceptors.add(AuthInterceptor(storage));
    final headers = <dynamic>[];
    dio.interceptors.add(InterceptorsWrapper(onRequest: (r, h) {
      headers.add(r.headers['Authorization']);
      h.resolve(Response(requestOptions: r, statusCode: 200, data: {}));
    }));
    for (final path in [
      '/api/auth/login',
      '/api/auth/mfa/verify-login',
      'https://other.example/file',
      'https://server.example/uploads/photo'
    ]) {
      await dio.get(path,
          options: Options(headers: {'Authorization': 'Bearer must-remove'}));
    }
    expect(headers, everyElement(isNull));
  });
  test('concurrent 401s share refresh, preserve API path, rotate both tokens',
      () async {
    var count = 0;
    final release = Completer<void>();
    final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
    dio.interceptors.add(AuthInterceptor(storage));
    dio.interceptors.add(RefreshTokenInterceptor(
        dio: dio,
        tokenStorage: storage,
        refreshDioFactory: (o) {
          final refresh = Dio(o);
          refresh.interceptors.add(InterceptorsWrapper(onRequest: (r, h) async {
            count++;
            expect(r.uri.toString(),
                'https://server.example/api/auth/refresh-token');
            await release.future;
            h.resolve(Response(requestOptions: r, statusCode: 200, data: {
              'action': true,
              'data': {
                'token': 'new-access',
                'refresh_token': 'new-refresh',
                'user': {'id': '7', 'role': 'DRIVER', 'name': 'Driver'}
              }
            }));
          }));
          return refresh;
        }));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (r, h) {
      if (r.extra['retried'] == true) {
        expect(r.headers['Authorization'], 'Bearer new-access');
        h.resolve(Response(requestOptions: r, statusCode: 200, data: {}));
      } else {
        h.reject(
            DioException(
                requestOptions: r,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: r, statusCode: 401)),
            true);
      }
    }));
    final requests = [
      dio.get('/api/driver/profile'),
      dio.get('/api/driver/settings')
    ];
    await Future<void>.delayed(const Duration(milliseconds: 10));
    release.complete();
    await Future.wait(requests);
    expect(count, 1);
    expect(storage.cachedActiveSession?.accessToken, 'new-access');
    expect(storage.cachedActiveSession?.refreshToken, 'new-refresh');
  });
  test('old identity cannot refresh a different active account', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
    var count = 0;
    dio.interceptors.add(RefreshTokenInterceptor(
        dio: dio,
        tokenStorage: storage,
        refreshDioFactory: (o) {
          count++;
          return Dio(o);
        }));
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (r, h) => h.reject(
            DioException(
                requestOptions: r,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: r, statusCode: 401)),
            true)));
    await expectLater(
        dio.get('/api/driver/profile',
            options: Options(extra: {'authRole': 'user', 'authUserId': '7'})),
        throwsA(isA<DioException>()));
    expect(count, 0);
    expect(storage.cachedActiveSession?.role, UserRole.driver);
  });
  test('transient refresh failure keeps saved tokens', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
    dio.interceptors.add(AuthInterceptor(storage));
    dio.interceptors.add(RefreshTokenInterceptor(
        dio: dio,
        tokenStorage: storage,
        refreshDioFactory: (o) {
          final refresh = Dio(o);
          refresh.interceptors.add(InterceptorsWrapper(
              onRequest: (r, h) => h.reject(DioException(
                  requestOptions: r,
                  type: DioExceptionType.connectionTimeout))));
          return refresh;
        }));
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (r, h) => h.reject(
            DioException(
                requestOptions: r,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: r, statusCode: 401)),
            true)));
    await expectLater(
        dio.get('/api/driver/profile'), throwsA(isA<DioException>()));
    expect(storage.cachedActiveSession?.refreshToken, 'old-refresh');
  });
}
