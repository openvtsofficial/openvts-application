import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/notifications/mobile_push_controller.dart';
import 'package:open_vts/core/notifications/mobile_push_platform.dart';
import 'package:open_vts/core/notifications/mobile_push_service.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _PushService service;
  late MobilePushController controller;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false');
    SharedPreferences.setMockInitialValues(<String, Object>{
      StorageKeys.mobilePushLastPermissionStatus: 'authorized',
      StorageKeys.mobilePushFirebaseConfigVersion: '1',
      StorageKeys.mobilePushFirebaseConfigJson: '{}',
    });
    final cache = LocalCache(await SharedPreferences.getInstance());
    final storage = _SessionStorage();
    service = _PushService(cache, storage);
    controller = MobilePushController(
      service: service,
      localCache: cache,
      tokenStorage: storage,
    )..updateAuthenticationState(isAuthenticated: true);
  });

  tearDown(() async {
    controller.dispose();
    await service.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test('cached authorization cannot register after OS permission is revoked', () async {
    service.authorizationStatus = AuthorizationStatus.denied;
    expect(controller.shouldAttemptBackgroundRegistration, isTrue);
    expect(await controller.registerTokenForCurrentSession(), isFalse);
    expect(controller.state.isPermissionGranted, isFalse);
    expect(service.getTokenCalls, 0);
    expect(service.registrationCalls, 0);
    expect(service.permissionRequests, 0);
    expect(service.deregistrationCalls, 1);
  });

  test('authorized silent registration does not display a permission prompt', () async {
    expect(await controller.registerTokenForCurrentSession(), isTrue);
    expect(service.getTokenCalls, 1);
    expect(service.registrationCalls, 1);
    expect(service.permissionRequests, 0);
  });

  test('background registration errors do not escape into app lifecycle', () async {
    service.throwPermissionError = true;
    expect(await controller.registerTokenForCurrentSession(), isFalse);
    expect(service.registrationCalls, 0);
    expect(controller.state.lastError, isNotNull);
  });
}

class _SessionStorage extends TokenStorage {
  _SessionStorage() : super(const FlutterSecureStorage());

  @override
  Future<RoleSession?> getActiveSession() async => const RoleSession(
        role: UserRole.user,
        accessToken: 'access',
        refreshToken: 'refresh',
        user: CurrentUser(
          id: '17',
          name: 'Test User',
          email: '',
          role: UserRole.user,
        ),
      );
}

class _PushService extends MobilePushService {
  _PushService(LocalCache cache, TokenStorage storage)
      : super(
          apiClient: ApiClient(Dio()),
          localCache: cache,
          tokenStorage: storage,
          secureStorage: const FlutterSecureStorage(),
        );

  AuthorizationStatus authorizationStatus = AuthorizationStatus.authorized;
  bool throwPermissionError = false;
  int getTokenCalls = 0;
  int registrationCalls = 0;
  int permissionRequests = 0;
  int deregistrationCalls = 0;

  @override
  bool get hasFirebaseApp => true;

  @override
  Future<MobilePushInitResult> initialize() async =>
      MobilePushInitResult.initialized(platform: MobilePushPlatform.ios);

  @override
  Future<NotificationSettings?> getNotificationSettings() async {
    if (throwPermissionError) throw StateError('Permission service unavailable');
    return _Settings(authorizationStatus);
  }

  @override
  Future<NotificationSettings?> requestNotificationPermission() async {
    permissionRequests++;
    return _Settings(authorizationStatus);
  }

  @override
  Future<String?> getCurrentToken() async {
    getTokenCalls++;
    return 'test-token';
  }

  @override
  Future<bool> registerCurrentToken({String? token}) async {
    registrationCalls++;
    return true;
  }

  @override
  Future<bool> deregisterToken({String? token}) async {
    deregistrationCalls++;
    return true;
  }
}

class _Settings implements NotificationSettings {
  _Settings(this.authorizationStatus);

  @override
  final AuthorizationStatus authorizationStatus;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
