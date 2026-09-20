import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FlutterSecureStorage secureStorage;
  late TokenStorage tokenStorage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
    secureStorage = const FlutterSecureStorage();
    tokenStorage = TokenStorage(secureStorage);
  });

  Future<void> saveSession(UserRole role) {
    final user = _userForRole(role);
    return tokenStorage.saveSessionForRole(
      role: role,
      accessToken: 'access-${role.apiValue}',
      refreshToken: 'refresh-${role.apiValue}',
      currentUserJson: jsonEncode(user.toJson()),
    );
  }

  test('activates the most recently authenticated role', () async {
    await saveSession(UserRole.superadmin);
    await saveSession(UserRole.admin);

    expect(await tokenStorage.getActiveRoleByPriority(), UserRole.admin);

    await saveSession(UserRole.user);

    expect(await tokenStorage.getActiveRoleByPriority(), UserRole.user);

    final activeSession = await tokenStorage.getActiveSession();
    expect(activeSession, isNotNull);
    expect(activeSession?.role, UserRole.user);
    expect(activeSession?.accessToken, 'access-user');
  });

  test('a newly authenticated role remains active when older roles exist',
      () async {
    await saveSession(UserRole.user);
    await saveSession(UserRole.superadmin);

    expect(await tokenStorage.getActiveRoleByPriority(), UserRole.superadmin);
    expect(
      await secureStorage.read(key: StorageKeys.activeRole),
      UserRole.superadmin.apiValue,
    );

    final restoredStorage = TokenStorage(secureStorage);
    expect(
      (await restoredStorage.getActiveSession())?.role,
      UserRole.superadmin,
    );
  });

  test('clears only the selected role session and falls back by priority',
      () async {
    await saveSession(UserRole.superadmin);
    await saveSession(UserRole.admin);

    expect(await tokenStorage.getActiveRoleByPriority(), UserRole.admin);

    await tokenStorage.clearSessionForRole(UserRole.admin);

    final fallbackSession = await tokenStorage.getActiveSession();
    expect(fallbackSession, isNotNull);
    expect(fallbackSession?.role, UserRole.superadmin);

    await tokenStorage.clearSessionForRole(UserRole.superadmin);
    expect(await tokenStorage.getActiveSession(), isNull);
  });

  test('serves repeated active token reads from hydrated cache', () async {
    await saveSession(UserRole.user);

    expect(await tokenStorage.getActiveAccessToken(), 'access-user');
    expect(tokenStorage.cachedActiveAccessToken, 'access-user');

    await secureStorage.write(
      key: StorageKeys.accessTokenForRole(UserRole.user.apiValue),
      value: 'changed-in-secure-storage',
    );

    expect(await tokenStorage.getActiveAccessToken(), 'access-user');
    expect(tokenStorage.cachedActiveAccessToken, 'access-user');
  });

  test('migrates legacy global session when scoped sessions do not exist',
      () async {
    final legacyUser = _userForRole(UserRole.superadmin);

    FlutterSecureStorage.setMockInitialValues(<String, String>{
      StorageKeys.accessToken: 'legacy-access',
      StorageKeys.refreshToken: 'legacy-refresh',
      StorageKeys.userRole: 'superadmin',
      StorageKeys.currentUser: jsonEncode(legacyUser.toJson()),
    });

    secureStorage = const FlutterSecureStorage();
    tokenStorage = TokenStorage(secureStorage);

    final migrated = await tokenStorage.getActiveSession();
    expect(migrated, isNotNull);
    expect(migrated?.role, UserRole.superadmin);
    expect(migrated?.accessToken, 'legacy-access');
    expect(migrated?.refreshToken, 'legacy-refresh');

    expect(
      await secureStorage.read(
        key: StorageKeys.accessTokenForRole(UserRole.superadmin.apiValue),
      ),
      'legacy-access',
    );
    expect(await secureStorage.read(key: StorageKeys.accessToken), isNull);
    expect(await secureStorage.read(key: StorageKeys.refreshToken), isNull);
    expect(await secureStorage.read(key: StorageKeys.userRole), isNull);
    expect(await secureStorage.read(key: StorageKeys.currentUser), isNull);
  });

  test('does not migrate legacy session when scoped session already exists',
      () async {
    final adminUser = _userForRole(UserRole.admin);

    FlutterSecureStorage.setMockInitialValues(<String, String>{
      StorageKeys.accessTokenForRole(UserRole.admin.apiValue): 'admin-access',
      StorageKeys.refreshTokenForRole(UserRole.admin.apiValue): 'admin-refresh',
      StorageKeys.currentUserForRole(UserRole.admin.apiValue):
          jsonEncode(adminUser.toJson()),
      StorageKeys.accessToken: 'legacy-access',
      StorageKeys.userRole: 'superadmin',
    });

    secureStorage = const FlutterSecureStorage();
    tokenStorage = TokenStorage(secureStorage);

    final activeSession = await tokenStorage.getActiveSession();
    expect(activeSession, isNotNull);
    expect(activeSession?.role, UserRole.admin);
    expect(activeSession?.accessToken, 'admin-access');

    expect(
      await secureStorage.read(
        key: StorageKeys.accessTokenForRole(UserRole.superadmin.apiValue),
      ),
      isNull,
    );
  });

  test('clearAllSessions removes scoped and legacy keys', () async {
    await saveSession(UserRole.user);

    await secureStorage.write(key: StorageKeys.accessToken, value: 'legacy');
    await secureStorage.write(key: StorageKeys.refreshToken, value: 'legacy-r');
    await secureStorage.write(key: StorageKeys.userRole, value: 'admin');
    await secureStorage.write(key: StorageKeys.currentUser, value: '{}');

    await tokenStorage.clearAllSessions();

    expect(
      await secureStorage.read(
        key: StorageKeys.accessTokenForRole(UserRole.user.apiValue),
      ),
      isNull,
    );
    expect(
      await secureStorage.read(
        key: StorageKeys.refreshTokenForRole(UserRole.user.apiValue),
      ),
      isNull,
    );
    expect(
      await secureStorage.read(
        key: StorageKeys.currentUserForRole(UserRole.user.apiValue),
      ),
      isNull,
    );
    expect(await secureStorage.read(key: StorageKeys.activeRole), isNull);
    expect(await secureStorage.read(key: StorageKeys.accessToken), isNull);
    expect(await secureStorage.read(key: StorageKeys.refreshToken), isNull);
    expect(await secureStorage.read(key: StorageKeys.userRole), isNull);
    expect(await secureStorage.read(key: StorageKeys.currentUser), isNull);
  });

  test('logout during a pending refresh write wins in cache and durable storage',
      () async {
    final delayedStorage = _DelayedSecureStorage();
    tokenStorage = TokenStorage(delayedStorage);
    await saveSession(UserRole.user);
    final original = (await tokenStorage.getActiveSession())!;
    final generation = tokenStorage.sessionRevision;
    delayedStorage.pauseNextWrite = true;

    final refreshed = tokenStorage.saveRefreshedSession(
      expectedSession: original,
      accessToken: 'rotated-access',
      refreshToken: 'rotated-refresh',
      currentUserJson: jsonEncode(original.user.toJson()),
    );
    await delayedStorage.writeStarted.future.timeout(const Duration(seconds: 2));
    final logout = tokenStorage.clearAllSessions();
    expect(tokenStorage.sessionRevision, greaterThan(generation));
    delayedStorage.resumeWrite.complete();

    expect(await refreshed.timeout(const Duration(seconds: 2)), isFalse);
    await logout.timeout(const Duration(seconds: 2));
    expect(await tokenStorage.getActiveSession(), isNull);
    expect(await TokenStorage(delayedStorage).getActiveSession(), isNull);
  });

  test('normal token rotation persists without changing the account revision',
      () async {
    await saveSession(UserRole.user);
    final original = (await tokenStorage.getActiveSession())!;
    final revision = tokenStorage.sessionRevision;
    expect(await tokenStorage.saveRefreshedSession(
      expectedSession: original,
      accessToken: 'rotated-access',
      refreshToken: 'rotated-refresh',
      currentUserJson: jsonEncode(original.user.toJson()),
    ), isTrue);
    expect(tokenStorage.sessionRevision, revision);
    final restored = await TokenStorage(secureStorage).getActiveSession();
    expect(restored?.accessToken, 'rotated-access');
    expect(restored?.refreshToken, 'rotated-refresh');
  });

  test('new login during a pending refresh write remains the durable session',
      () async {
    final delayedStorage = _DelayedSecureStorage();
    tokenStorage = TokenStorage(delayedStorage);
    await saveSession(UserRole.user);
    final original = (await tokenStorage.getActiveSession())!;
    delayedStorage.pauseNextWrite = true;
    final refreshed = tokenStorage.saveRefreshedSession(
      expectedSession: original,
      accessToken: 'rotated-access',
      refreshToken: 'rotated-refresh',
      currentUserJson: jsonEncode(original.user.toJson()),
    );
    await delayedStorage.writeStarted.future.timeout(const Duration(seconds: 2));
    final login = tokenStorage.saveSessionForRole(
      role: UserRole.user,
      accessToken: 'new-account-access',
      refreshToken: 'new-account-refresh',
      currentUserJson: jsonEncode(original.user.copyWith(id: 'new-account').toJson()),
    );
    delayedStorage.resumeWrite.complete();

    expect(await refreshed.timeout(const Duration(seconds: 2)), isFalse);
    await login.timeout(const Duration(seconds: 2));
    expect((await tokenStorage.getActiveSession())?.user.id, 'new-account');
    final restored = await TokenStorage(delayedStorage).getActiveSession();
    expect(restored?.user.id, 'new-account');
    expect(restored?.accessToken, 'new-account-access');
    expect(restored?.refreshToken, 'new-account-refresh');
  });

  test('a stale refresh cannot overwrite an already completed login', () async {
    await saveSession(UserRole.user);
    final original = (await tokenStorage.getActiveSession())!;
    await tokenStorage.saveSessionForRole(
      role: UserRole.user,
      accessToken: 'new-login-access',
      refreshToken: 'new-login-refresh',
      currentUserJson: jsonEncode(original.user.toJson()),
    );
    final saved = await tokenStorage.saveRefreshedSession(
      expectedSession: original,
      accessToken: 'stale-refresh-access',
      refreshToken: 'stale-refresh-token',
      currentUserJson: jsonEncode(original.user.toJson()),
    );
    expect(saved, isFalse);
    expect((await tokenStorage.getActiveSession())?.accessToken, 'new-login-access');
  });

  test('an invalid-refresh clear cannot delete a queued newer login', () async {
    await saveSession(UserRole.user);
    final original = (await tokenStorage.getActiveSession())!;
    final revision = tokenStorage.sessionRevision;
    final invalidRefreshClear = tokenStorage.clearSessionIfCurrent(
      expectedSession: original,
      expectedRevision: revision,
    );
    // Both actions are enqueued in the same event turn. The explicit login
    // invalidates the old response immediately, before storage processing.
    final login = tokenStorage.saveSessionForRole(
      role: UserRole.user,
      accessToken: 'new-login-access',
      refreshToken: 'new-login-refresh',
      currentUserJson: jsonEncode(original.user.toJson()),
    );
    expect(await invalidRefreshClear, isFalse);
    await login;
    expect((await TokenStorage(secureStorage).getActiveSession())?.accessToken,
        'new-login-access');
  });
}

/// Implements only the storage operations TokenStorage uses. The test holds a
/// real async write boundary instead of depending on timers to cause a race.
class _DelayedSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _values = {};
  bool pauseNextWrite = false;
  final writeStarted = Completer<void>();
  final resumeWrite = Completer<void>();

  Future<void> _write(String key, String? value) async {
    if (pauseNextWrite) {
      pauseNextWrite = false;
      writeStarted.complete();
      await resumeWrite.future;
    }
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final key = invocation.namedArguments[#key] as String?;
    if (invocation.memberName == #read && key != null) {
      return Future<String?>.value(_values[key]);
    }
    if (invocation.memberName == #write && key != null) {
      return _write(key, invocation.namedArguments[#value] as String?);
    }
    if (invocation.memberName == #delete && key != null) {
      _values.remove(key);
      return Future<void>.value();
    }
    return super.noSuchMethod(invocation);
  }
}

CurrentUser _userForRole(UserRole role) {
  return CurrentUser(
    id: '${role.apiValue}-id',
    name: '${role.apiValue}-name',
    email: '${role.apiValue}@openvts.local',
    role: role,
    username: role.apiValue,
    mobilePrefix: '+1',
    mobileNumber: '5559876543',
    phoneNumber: '+1 5559876543',
    accountStatus: 'active',
    isVerified: true,
    addressLine: '221 Fleet Street',
    countryCode: 'US',
    stateCode: 'CA',
    cityName: 'San Francisco',
    pincode: '94107',
  );
}
