import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/interceptors/auth_interceptor.dart';
import 'package:open_vts/core/api/interceptors/refresh_token_interceptor.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TokenStorage storage;
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage(const FlutterSecureStorage());
    await storage.saveSessionForRole(
      role: UserRole.user,
      accessToken: 'old-access',
      refreshToken: 'old-refresh',
      currentUserJson: jsonEncode({'id': '7', 'name': 'User', 'role': 'USER'}),
    );
  });

  test(
    'bearer sent only to configured origin and not public authentication',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/v1/api'));
      final headers = <String, dynamic>{};
      dio.interceptors.add(AuthInterceptor(storage));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            headers[options.uri.toString()] = options.headers['Authorization'];
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {},
              ),
            );
          },
        ),
      );
      for (final endpoint in [
        '/user/profile',
        '/auth/login',
        'https://files.other.test/export.csv',
        'http://example.test/export.csv',
        'https://example.test:9443/export.csv',
      ]) {
        await ApiClient(dio).get<Map<String, dynamic>>(
          endpoint,
          parser: (json) => Map<String, dynamic>.from(json as Map),
        );
      }
      expect(
        headers['https://example.test/v1/api/user/profile'],
        'Bearer old-access',
      );
      expect(headers['https://example.test/v1/api/auth/login'], isNull);
      expect(headers['https://files.other.test/export.csv'], isNull);
      expect(headers['http://example.test/export.csv'], isNull);
      expect(headers['https://example.test:9443/export.csv'], isNull);
    },
  );

  test(
    'concurrent failures share refresh, retain API prefix, retry once',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/v1/api'));
      var refreshes = 0;
      final releaseRefresh = Completer<void>();
      String? refreshPath;
      dio.interceptors.add(AuthInterceptor(storage));
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio: dio,
          tokenStorage: storage,
          refreshClientFactory: (options) {
            final client = Dio(options);
            client.interceptors.add(
              InterceptorsWrapper(
                onRequest: (request, handler) async {
                  refreshes++;
                  refreshPath = request.uri.path;
                  await releaseRefresh.future;
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: request,
                      statusCode: 200,
                      data: _loginResponse(),
                    ),
                  );
                },
              ),
            );
            return client;
          },
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.headers['Authorization'] == 'Bearer new-access') {
              handler.resolve(
                Response<dynamic>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {},
                ),
              );
            } else {
              handler.reject(_unauthorized(options), true);
            }
          },
        ),
      );
      final first = dio.get<dynamic>(
        'https://example.test/v1/api/user/profile',
      );
      final second = dio.get<dynamic>(
        'https://example.test/v1/api/user/vehicles',
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      releaseRefresh.complete();
      await Future.wait([first, second]).timeout(const Duration(seconds: 3));
      expect(refreshes, 1);
      expect(refreshPath, '/v1/api/auth/refresh-token');
      expect((await storage.getActiveSession())!.accessToken, 'new-access');
    },
  );

  test('late 401 from an earlier login never uses a newer session', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
    final requestStarted = Completer<void>();
    final releaseResponse = Completer<void>();
    var refreshes = 0;
    dio.interceptors.add(AuthInterceptor(storage));
    dio.interceptors.add(
      RefreshTokenInterceptor(
        dio: dio,
        tokenStorage: storage,
        refreshClientFactory: (options) {
          refreshes++;
          return Dio(options);
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          requestStarted.complete();
          await releaseResponse.future;
          handler.reject(_unauthorized(options), true);
        },
      ),
    );
    final request = dio.get<dynamic>('https://example.test/api/user/profile');
    final assertion = expectLater(request, throwsA(isA<DioException>()));
    await requestStarted.future;
    await storage.saveSessionForRole(
      role: UserRole.user,
      accessToken: 'new-login-access',
      refreshToken: 'new-login-refresh',
      currentUserJson: jsonEncode({'id': '7', 'role': 'USER'}),
    );
    releaseResponse.complete();
    await assertion;
    expect(refreshes, 0);
    expect((await storage.getActiveSession())!.accessToken, 'new-login-access');
  });

  test('transient refresh failure does not delete a saved session', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
    dio.interceptors.add(AuthInterceptor(storage));
    dio.interceptors.add(
      RefreshTokenInterceptor(
        dio: dio,
        tokenStorage: storage,
        refreshClientFactory: (options) {
          final client = Dio(options);
          client.interceptors.add(
            InterceptorsWrapper(
              onRequest: (request, handler) {
                handler.reject(
                  DioException(
                    requestOptions: request,
                    type: DioExceptionType.connectionTimeout,
                  ),
                );
              },
            ),
          );
          return client;
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(_unauthorized(options), true);
        },
      ),
    );
    await expectLater(
      dio.get<dynamic>('https://example.test/api/user/profile'),
      throwsA(isA<DioException>()),
    );
    expect((await storage.getActiveSession())!.refreshToken, 'old-refresh');
  });

  test(
    'a failed retry terminates without queued interceptor deadlock',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
      var refreshes = 0;
      dio.interceptors.add(AuthInterceptor(storage));
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio: dio,
          tokenStorage: storage,
          refreshClientFactory: (options) {
            final client = Dio(options);
            client.interceptors.add(
              InterceptorsWrapper(
                onRequest: (request, handler) {
                  refreshes++;
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: request,
                      statusCode: 200,
                      data: _loginResponse(),
                    ),
                  );
                },
              ),
            );
            return client;
          },
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(_unauthorized(options), true);
          },
        ),
      );
      await expectLater(
        dio
            .get<dynamic>('https://example.test/api/user/profile')
            .timeout(const Duration(seconds: 3)),
        throwsA(isA<DioException>()),
      );
      expect(refreshes, 1);
      final active = await storage.getActiveSession();
      expect(active, isNotNull);
      expect(active!.role, UserRole.user);
      expect(active.user.id, '7');
      expect(active.accessToken, 'new-access');
      expect(active.refreshToken, 'new-refresh');
    },
  );

  test(
    'role-mismatch 401 after successful refresh preserves child session',
    () async {
      // This reproduces Login-as navigation: after switching accounts, an old
      // screen can still issue one request to a parent-role endpoint. The
      // backend intentionally reports role mismatches as 401. The child refresh
      // token is valid, so the retried parent request is still 401 and MUST NOT
      // erase the valid child login.
      await storage.clearAllSessions();
      await storage.saveSessionForRole(
        role: UserRole.superadmin,
        accessToken: 'superadmin-access',
        refreshToken: 'superadmin-refresh',
        currentUserJson: jsonEncode({
          'id': '1',
          'name': 'Superadmin',
          'role': 'SUPERADMIN',
        }),
      );
      await storage.saveSessionForRole(
        role: UserRole.admin,
        accessToken: 'admin-access',
        refreshToken: 'admin-refresh',
        currentUserJson: jsonEncode({
          'id': '22',
          'name': 'Admin',
          'role': 'ADMIN',
        }),
      );

      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
      var refreshes = 0;
      dio.interceptors.add(AuthInterceptor(storage));
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio: dio,
          tokenStorage: storage,
          refreshClientFactory: (options) {
            final client = Dio(options);
            client.interceptors.add(
              InterceptorsWrapper(
                onRequest: (request, handler) {
                  refreshes++;
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: request,
                      statusCode: 200,
                      data: {
                        'action': true,
                        'data': {
                          'token': 'admin-access-rotated',
                          'refresh_token': 'admin-refresh-rotated',
                          'user': {
                            'id': '22',
                            'role': 'ADMIN',
                            'name': 'Admin',
                          },
                        },
                      },
                    ),
                  );
                },
              ),
            );
            return client;
          },
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Represents a stale Superadmin-only request after Admin became
            // active. It stays unauthorized even with the rotated Admin token.
            handler.reject(_unauthorized(options), true);
          },
        ),
      );

      await expectLater(
        dio.get<dynamic>('https://example.test/api/superadmin/profile'),
        throwsA(isA<DioException>()),
      );

      expect(refreshes, 1);
      final active = await storage.getActiveSession();
      expect(active, isNotNull);
      expect(active!.role, UserRole.admin);
      expect(active.user.id, '22');
      expect(active.accessToken, 'admin-access-rotated');
      expect(active.refreshToken, 'admin-refresh-rotated');
      expect(await storage.hasSessionForRole(UserRole.superadmin), isTrue);

      // Normal child logout must still reveal the retained parent login.
      await storage.clearSessionForRole(UserRole.admin);
      final parent = await storage.getActiveSession();
      expect(parent, isNotNull);
      expect(parent!.role, UserRole.superadmin);
      expect(parent.user.id, '1');
      expect(parent.accessToken, 'superadmin-access');
    },
  );
}

DioException _unauthorized(RequestOptions options) => DioException(
  requestOptions: options,
  type: DioExceptionType.badResponse,
  response: Response<dynamic>(requestOptions: options, statusCode: 401),
);

Map<String, dynamic> _loginResponse() => {
  'action': true,
  'data': {
    'token': 'new-access',
    'refresh_token': 'new-refresh',
    'user': {'id': '7', 'role': 'USER', 'name': 'User'},
  },
};
