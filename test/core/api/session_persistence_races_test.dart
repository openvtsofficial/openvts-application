import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/auth_api_error.dart';
import 'package:open_vts/core/api/interceptors/auth_interceptor.dart';
import 'package:open_vts/core/api/interceptors/refresh_token_interceptor.dart';
import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TokenStorage storage;
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage(const FlutterSecureStorage());
    await _save(storage, 'old');
  });

  Dio client(
    void Function(RequestOptions, RequestInterceptorHandler) refresh, {
    int featureStatus = 401,
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
    dio.interceptors.add(AuthInterceptor(storage));
    dio.interceptors.add(
      RefreshTokenInterceptor(
        dio: dio,
        tokenStorage: storage,
        refreshDioFactory: (options) {
          final refreshDio = Dio(options);
          refreshDio.interceptors.add(InterceptorsWrapper(onRequest: refresh));
          return refreshDio;
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          if (request.extra['retried'] == true) {
            handler.resolve(
              Response(requestOptions: request, statusCode: 200, data: {}),
            );
          } else {
            handler.reject(_reject(request, featureStatus), true);
          }
        },
      ),
    );
    addTearDown(() => dio.close(force: true));
    return dio;
  }

  test(
    'Logout serialized during secure token write always wins durably',
    () async {
      final secure = _BlockingStorage();
      storage = TokenStorage(secure);
      await _save(storage, 'old');
      final session = (await storage.getActiveSession())!;
      secure.blockNextAccessWrite = true;
      final rotating = storage.rotateTokensIfCurrent(
        expected: session,
        generation: storage.sessionGeneration,
        accessToken: 'rotated-access',
        refreshToken: 'rotated-refresh',
        user: session.user,
      );
      await secure.started.future;
      final logout = storage.clearAllSessions();
      secure.release.complete();
      await Future.wait([rotating, logout]);
      expect(await storage.getActiveSession(), isNull);
      final restored = TokenStorage(secure);
      expect(
        await restored.getActiveSession(),
        isNull,
        reason:
            'Partial async secure writes must not resurrect a logged-out session',
      );
    },
  );

  test(
    'successful late refresh after Logout cannot recreate credentials',
    () async {
      final started = Completer<void>(), release = Completer<void>();
      final dio = client((request, handler) async {
        started.complete();
        await release.future;
        handler.resolve(
          Response(
            requestOptions: request,
            statusCode: 200,
            data: _response('rotated'),
          ),
        );
      });
      final request = dio.get('/api/user/profile');
      final assertion = expectLater(request, throwsA(isA<DioException>()));
      await started.future;
      await storage.clearAllSessions();
      release.complete();
      await assertion;
      expect(await storage.getActiveSession(), isNull);
    },
  );

  test(
    'a late revoked refresh never clears a newer login of the same account',
    () async {
      final started = Completer<void>(), release = Completer<void>();
      final dio = client((request, handler) async {
        started.complete();
        await release.future;
        handler.reject(_reject(request, 401));
      });
      final request = dio.get('/api/user/profile');
      final assertion = expectLater(request, throwsA(isA<DioException>()));
      await started.future;
      await _save(storage, 'new-login');
      release.complete();
      await assertion;
      expect(
        (await storage.getActiveSession())?.accessToken,
        'new-login-access',
      );
    },
  );

  test('confirmed refresh rejection clears only the revoked login', () async {
    final dio = client(
      (request, handler) => handler.reject(_reject(request, 401)),
    );
    await expectLater(
      dio.get('/api/user/profile'),
      throwsA(
        isA<DioException>().having(
          AuthApiError.isSessionInvalidated,
          'confirmed invalidation',
          true,
        ),
      ),
    );
    expect(await storage.getActiveSession(), isNull);
  });

  test(
    'a feature permission denial never refreshes or removes credentials',
    () async {
      var refreshes = 0;
      final dio = client((request, handler) {
        refreshes++;
      }, featureStatus: 403);
      await expectLater(
        dio.get('/api/user/vehicles'),
        throwsA(isA<DioException>()),
      );
      expect(refreshes, 0);
      expect((await storage.getActiveSession())?.accessToken, 'old-access');
    },
  );

  test(
    'malformed refresh response keeps saved login instead of signing out',
    () async {
      final dio = client(
        (request, handler) => handler.resolve(
          Response(
            requestOptions: request,
            statusCode: 200,
            data: {'gateway': 'temporarily unavailable'},
          ),
        ),
      );
      await expectLater(
        dio.get('/api/user/profile'),
        throwsA(
          isA<DioException>().having(
            AuthApiError.isSessionInvalidated,
            'confirmed invalidation',
            false,
          ),
        ),
      );
      expect((await storage.getActiveSession())?.refreshToken, 'old-refresh');
    },
  );

  test(
    'profile saves retain a login generation and token rotation does not switch roles',
    () async {
      final session = (await storage.getActiveSession())!;
      final generation = storage.sessionGeneration;
      expect(
        await storage.updateProfileIfCurrent(
          session,
          session.user.copyWith(name: 'Renamed'),
        ),
        true,
      );
      expect(storage.sessionGeneration, generation);
      final current = (await storage.getActiveSession())!;
      expect(
        await storage.rotateTokensIfCurrent(
          expected: current,
          generation: generation,
          accessToken: 'rotated-access',
          refreshToken: 'rotated-refresh',
          user: current.user,
        ),
        true,
      );
      expect(storage.sessionGeneration, generation);
      expect((await storage.getActiveSession())?.user.name, 'Renamed');
      await _save(storage, 'new-login');
      expect(
        await storage.rotateTokensIfCurrent(
          expected: current,
          generation: generation,
          accessToken: 'stale-access',
          refreshToken: 'stale-refresh',
          user: current.user,
        ),
        false,
      );
    },
  );
}

Future<void> _save(TokenStorage storage, String prefix) =>
    storage.saveSessionForRole(
      role: UserRole.user,
      accessToken: '$prefix-access',
      refreshToken: '$prefix-refresh',
      currentUserJson: jsonEncode({'id': '7', 'name': 'User', 'role': 'USER'}),
    );
Map<String, dynamic> _response(String prefix) => {
  'action': true,
  'data': {
    'token': '$prefix-access',
    'refresh_token': '$prefix-refresh',
    'user': {'id': '7', 'name': 'User', 'role': 'USER'},
  },
};
DioException _reject(RequestOptions request, int status) => DioException(
  requestOptions: request,
  type: DioExceptionType.badResponse,
  response: Response(requestOptions: request, statusCode: status),
);

class _BlockingStorage extends FlutterSecureStorage {
  bool blockNextAccessWrite = false;
  final started = Completer<void>();
  final release = Completer<void>();

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (blockNextAccessWrite && key == StorageKeys.accessTokenForRole('user')) {
      blockNextAccessWrite = false;
      started.complete();
      await release.future;
    }
    await super.write(
      key: key,
      value: value,
      iOptions: iOptions,
      aOptions: aOptions,
      lOptions: lOptions,
      webOptions: webOptions,
      mOptions: mOptions,
      wOptions: wOptions,
    );
  }
}
