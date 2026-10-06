import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/access/mobile_access_service.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/core/demo/demo_mode_store.dart';
import 'package:open_vts/core/demo/demo_session.dart';
import 'package:open_vts/core/demo/demo_session_service.dart';
import 'package:open_vts/core/notifications/mobile_push_controller.dart';
import 'package:open_vts/core/providers/app_preferences_provider.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/auth/models/login_request.dart';
import 'package:open_vts/features/auth/models/login_response.dart';
import 'package:open_vts/features/auth/models/mfa_challenge.dart';
import 'package:open_vts/features/auth/services/auth_service.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TokenStorage storage;
  late _AuthService service;
  late _Push push;
  late AuthController controller;
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage(const FlutterSecureStorage());
    service = _AuthService();
    push = _Push();
    controller = AuthController(
      authService: service,
      accessService: _Access(),
      tokenStorage: storage,
      mobilePushController: push,
      demoModeStore: _DemoStore(),
      demoSessionService: _DemoService(),
      appPreferencesCtrl: _Preferences(),
    );
  });
  tearDown(() => controller.dispose());
  test(
    'logout during profile bootstrap cannot resurrect the prior account',
    () async {
      service.profile = Completer<CurrentUser>();
      final session = controller.setSession(_login);
      await service.profileStarted.future;
      await controller.logoutAllRoles(deregisterPush: false);
      service.profile!.complete(_user);
      await session;
      expect(controller.state.status, AuthStatus.unauthenticated);
      expect(await storage.getActiveSession(), isNull);
    },
  );
  test(
    'MFA challenge remains unauthenticated and stores no password session',
    () async {
      service.needsMfa = true;
      await controller.login(identifier: 'driver', password: 'example');
      expect(controller.state.status, AuthStatus.mfaRequired);
      expect(controller.state.isAuthenticated, false);
      expect(await storage.getActiveSession(), isNull);
      await controller.verifyMfa('123456');
      expect(controller.state.role, UserRole.driver);
      expect(controller.state.user?.accessLoaded, true);
      expect((await storage.getActiveSession())?.accessToken, 'access');
      expect(
        push.authenticated,
        false,
        reason: 'Driver IDs are not User push-token owners',
      );
    },
  );
  for (final role in UserRole.values.where((r) => r != UserRole.unknown)) {
    test(
      'offline startup preserves the $role login and retries verification',
      () async {
        final user = _user.copyWith(role: role);
        await storage.saveSessionForRole(
          role: role,
          accessToken: 'saved-access',
          refreshToken: 'saved-refresh',
          currentUserJson: jsonEncode(user.toJson()),
        );
        service.profileError = DioException(
          requestOptions: RequestOptions(path: '/profile'),
          type: DioExceptionType.connectionTimeout,
        );
        await controller.restoreSession();
        expect(controller.state.isRealSession, true);
        expect(controller.state.role, role);
        expect(controller.state.user?.accessLoaded, false);
        expect(
          (await storage.getActiveSession())?.refreshToken,
          'saved-refresh',
        );
        service.profileError = null;
        await controller.refreshAccess();
        expect(controller.state.role, role);
        expect(controller.state.user?.accessLoaded, true);
        expect(storage.cachedActiveUser?.accessLoaded, true);
      },
    );
  }

  test(
    'nested impersonation logout restores admin then superadmin',
    () async {
      await controller.setSession(_loginForRole(UserRole.superadmin));
      await controller.switchToChildSession(_loginForRole(UserRole.admin));
      await controller.switchToChildSession(_loginForRole(UserRole.user));

      expect(controller.state.role, UserRole.user);
      expect((await storage.getActiveSession())?.role, UserRole.user);

      await controller.logoutActiveRole();
      expect(controller.state.role, UserRole.admin);
      expect((await storage.getActiveSession())?.role, UserRole.admin);

      await controller.logoutActiveRole();
      expect(controller.state.role, UserRole.superadmin);
      expect((await storage.getActiveSession())?.role, UserRole.superadmin);
    },
  );

  test('declared account hierarchy can traverse every supported role', () async {
    await controller.setSession(_loginForRole(UserRole.superadmin));
    await controller.switchToChildSession(_loginForRole(UserRole.admin));
    await controller.switchToChildSession(_loginForRole(UserRole.team));
    await controller.switchToChildSession(_loginForRole(UserRole.user));
    await controller.switchToChildSession(_loginForRole(UserRole.subuser));

    expect(controller.state.role, UserRole.subuser);
    await controller.logoutActiveRole();
    expect(controller.state.role, UserRole.user);

    await controller.switchToChildSession(_loginForRole(UserRole.driver));
    expect(controller.state.role, UserRole.driver);
    await controller.logoutActiveRole();
    expect(controller.state.role, UserRole.user);
    await controller.logoutActiveRole();
    expect(controller.state.role, UserRole.team);
    await controller.logoutActiveRole();
    expect(controller.state.role, UserRole.admin);
    await controller.logoutActiveRole();
    expect(controller.state.role, UserRole.superadmin);
  });

  test(
    'revoked child during account switch restores the parent session',
    () async {
      await controller.setSession(_loginForRole(UserRole.superadmin));
      service.invalidatedRoles.add(UserRole.admin);

      await expectLater(
        controller.switchToChildSession(_loginForRole(UserRole.admin)),
        throwsA(isA<ApiException>()),
      );

      expect(controller.state.isRealSession, true);
      expect(controller.state.role, UserRole.superadmin);
      expect((await storage.getActiveSession())?.role, UserRole.superadmin);
    },
  );

  test(
    'external child invalidation automatically resumes the stored parent',
    () async {
      await controller.setSession(_loginForRole(UserRole.superadmin));
      await controller.switchToChildSession(_loginForRole(UserRole.admin));
      final child = (await storage.getActiveSession())!;

      await storage.clearSessionIfCurrent(child, storage.sessionGeneration);
      await pumpEventQueue(times: 10);

      expect(controller.state.isRealSession, true);
      expect(controller.state.role, UserRole.superadmin);
      expect((await storage.getActiveSession())?.role, UserRole.superadmin);
    },
  );

  test(
    'temporary profile permission denial retains login and fails closed',
    () async {
      await controller.setSession(_login);
      service.profileError = DioException(
        requestOptions: RequestOptions(path: '/profile'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/profile'),
          statusCode: 403,
        ),
      );
      await controller.refreshAccess();
      expect(controller.state.isAuthenticated, true);
      expect(controller.state.user?.accessLoaded, false);
      expect(await storage.getActiveSession(), isNotNull);
    },
  );

  test(
    'confirmed server revocation returns to Login without recreating a session',
    () async {
      await controller.setSession(_login);
      final session = (await storage.getActiveSession())!;
      await storage.clearSessionIfCurrent(session, storage.sessionGeneration);
      service.profileError = DioException(
        requestOptions: RequestOptions(
          path: '/auth/refresh-token',
          extra: {'sessionInvalidated': true},
        ),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/auth/refresh-token'),
          statusCode: 401,
        ),
      );
      await controller.refreshAccess();
      expect(controller.state.status, AuthStatus.unauthenticated);
      expect(await storage.getActiveSession(), isNull);
    },
  );

  test('cancel MFA clears the in-memory challenge', () async {
    service.needsMfa = true;
    await controller.login(identifier: 'driver', password: 'example');
    controller.cancelMfa();
    expect(controller.state.mfaChallenge, isNull);
    expect(controller.state.status, AuthStatus.unauthenticated);
  });
}

LoginResponse _loginForRole(UserRole role) {
  return LoginResponse(
    accessToken: 'access-${role.apiValue}',
    refreshToken: 'refresh-${role.apiValue}',
    user: CurrentUser(
      id: '${role.apiValue}-id',
      name: role.displayLabel,
      email: '${role.apiValue}@openvts.local',
      role: role,
    ),
  );
}

const _user = CurrentUser(
  id: '7',
  name: 'Driver',
  email: '',
  role: UserRole.driver,
);
const _login = LoginResponse(
  accessToken: 'access',
  refreshToken: 'refresh',
  user: _user,
);

class _AuthService extends AuthService {
  _AuthService() : super(ApiClient(Dio()));
  bool needsMfa = false;
  Object? profileError;
  final Set<UserRole> invalidatedRoles = <UserRole>{};
  Completer<CurrentUser>? profile;
  final profileStarted = Completer<void>();
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    if (needsMfa) {
      throw MfaRequiredException(
        MfaChallenge(
          token: 'a' * 64,
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
        ),
      );
    }
    return _login;
  }

  @override
  Future<LoginResponse> verifyMfaLogin(
    MfaChallenge challenge,
    String code,
  ) async => _login;
  @override
  Future<CurrentUser> getProfile(CurrentUser user) {
    if (!profileStarted.isCompleted) profileStarted.complete();
    if (invalidatedRoles.remove(user.role)) {
      return Future.error(
        DioException(
          requestOptions: RequestOptions(
            path: '/auth/refresh-token',
            extra: const <String, dynamic>{'sessionInvalidated': true},
          ),
          type: DioExceptionType.badResponse,
          response: Response<void>(
            requestOptions: RequestOptions(path: '/auth/refresh-token'),
            statusCode: 401,
          ),
        ),
      );
    }
    if (profileError != null) return Future.error(profileError!);
    return profile?.future ?? Future.value(user);
  }
}

class _Access extends MobileAccessService {
  _Access() : super(ApiClient(Dio()));
  @override
  Future<CurrentUser> loadAccess(CurrentUser user) async =>
      user.copyWith(access: const MobileAccess.account());
}

class _Push extends Fake implements MobilePushController {
  bool authenticated = false;
  @override
  void updateAuthenticationState({required bool isAuthenticated}) {
    authenticated = isAuthenticated;
  }

  @override
  Future<bool> deregisterCurrentToken() async => true;
}

class _DemoStore extends Fake implements DemoModeStore {
  @override
  bool get isEnabled => false;
  @override
  DemoSession? get cachedSession => null;
  @override
  Future<void> clear() async {}
}

class _DemoService extends Fake implements DemoSessionService {}

class _Preferences extends Fake
    implements AppLocalizationPreferencesController {
  @override
  void rehydrate() {}
}
