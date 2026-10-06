import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/models/current_user.dart';
import '../../shared/models/user_role.dart';
import '../performance/open_vts_perf.dart';
import 'storage_keys.dart';

class RoleSession {
  const RoleSession({
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final UserRole role;
  final String accessToken;
  final String refreshToken;
  final CurrentUser user;
}

class TokenStorage {
  TokenStorage(this._storage);

  static const List<UserRole> _rolePriority = <UserRole>[
    UserRole.subuser,
    UserRole.driver,
    UserRole.user,
    UserRole.team,
    UserRole.admin,
    UserRole.superadmin,
  ];

  final FlutterSecureStorage _storage;
  bool _cacheHydrated = false;
  final Map<UserRole, RoleSession?> _roleSessionCache =
      <UserRole, RoleSession?>{};
  final List<UserRole> _sessionRoleStack = <UserRole>[];
  RoleSession? _activeSessionCache;
  Future<void>? _cacheHydration;
  bool _didCheckLegacyMigration = false;
  int _sessionGeneration = 0;
  Future<void> _mutations = Future<void>.value();
  CurrentUser? _verifiedActiveUser;
  final Set<void Function()> _sessionListeners = {};

  /// Changes for explicit login/logout/security replacement, never token rotation.
  int get sessionGeneration => _sessionGeneration;

  /// Role services must not read the auth controller that constructs ApiClient.
  /// Permissions stay in memory and are never trusted from persisted JSON.
  CurrentUser? get cachedActiveUser {
    final stored = cachedActiveSession?.user;
    final verified = _verifiedActiveUser;
    return stored?.id == verified?.id && stored?.role == verified?.role
        ? verified ?? stored
        : stored;
  }

  void publishVerifiedUser(CurrentUser? user) {
    final active = cachedActiveSession;
    _verifiedActiveUser =
        user != null && active?.user.id == user.id && active?.role == user.role
        ? user
        : null;
  }

  void Function() listenToSession(void Function() listener) {
    _sessionListeners.add(listener);
    return () => _sessionListeners.remove(listener);
  }

  void _notifySessionChanged() {
    for (final listener in _sessionListeners.toList(growable: false)) {
      listener();
    }
  }

  Future<T> _mutate<T>(Future<T> Function() action) {
    final result = _mutations.then((_) => action());
    _mutations = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return result;
  }

  bool _matchesSession(RoleSession expected, int generation) {
    final active = cachedActiveSession;
    return generation == _sessionGeneration &&
        active != null &&
        active.role == expected.role &&
        active.user.id == expected.user.id &&
        active.accessToken == expected.accessToken &&
        active.refreshToken == expected.refreshToken;
  }

  /// Compare and commit under the same lock as logout; a late refresh cannot
  /// recreate removed credentials or overwrite a newer login of the same user.
  Future<bool> rotateTokensIfCurrent({
    required RoleSession expected,
    required int generation,
    required String accessToken,
    required String refreshToken,
    required CurrentUser user,
  }) async {
    await hydrateCache();
    return _mutate(() async {
      if (!_matchesSession(expected, generation) ||
          user.id != expected.user.id ||
          user.role != expected.role) {
        return false;
      }
      final verified = _verifiedActiveUser;
      await _writeSession(
        role: expected.role,
        accessToken: accessToken,
        refreshToken: refreshToken,
        currentUserJson: jsonEncode(user.toJson()),
      );
      _verifiedActiveUser = verified;
      _notifySessionChanged();
      return true;
    });
  }

  Future<bool> updateProfileIfCurrent(
    RoleSession expected,
    CurrentUser user,
  ) async {
    final generation = _sessionGeneration;
    return _mutate(() async {
      if (!_matchesSession(expected, generation) ||
          user.id != expected.user.id ||
          user.role != expected.role) {
        return false;
      }
      await _writeSession(
        role: expected.role,
        accessToken: expected.accessToken,
        refreshToken: expected.refreshToken,
        currentUserJson: jsonEncode(user.toJson()),
      );
      publishVerifiedUser(user);
      return true;
    });
  }

  Future<bool> clearSessionIfCurrent(
    RoleSession expected,
    int generation,
  ) async {
    await hydrateCache();
    return _mutate(() async {
      if (!_matchesSession(expected, generation)) return false;
      _sessionGeneration++;
      await _clearSession(expected.role);
      _notifySessionChanged();
      return true;
    });
  }

  bool get isCacheHydrated => _cacheHydrated;

  String? get cachedActiveAccessToken {
    if (!_cacheHydrated) return null;
    final token = _activeSessionCache?.accessToken.trim();
    return token == null || token.isEmpty ? null : token;
  }

  RoleSession? get cachedActiveSession {
    if (!_cacheHydrated) return null;
    return _activeSessionCache;
  }

  Future<void> hydrateCache() {
    if (_cacheHydrated) return Future<void>.value();

    final hydration = _cacheHydration;
    if (hydration != null) return hydration;

    final future =
        OpenVtsPerf.traceAsync('token.hydrateCache', () async {
          await _hydrateCacheInternal();
        }).whenComplete(() {
          _cacheHydration = null;
        });
    _cacheHydration = future;
    return future;
  }

  void invalidateCache() {
    _cacheHydration = null;
    _cacheHydrated = false;
    _roleSessionCache.clear();
    _sessionRoleStack.clear();
    _activeSessionCache = null;
    _verifiedActiveUser = null;
    _sessionGeneration++;
    _notifySessionChanged();
  }

  Future<void> _hydrateCacheInternal() async {
    if (_cacheHydrated) return;

    await _migrateLegacySessionIfNeeded();

    final preferredRole = await _readStoredActiveRole();
    final storedRoleStack = await _readStoredRoleStack();
    _roleSessionCache.clear();
    for (final role in UserRole.values) {
      _roleSessionCache[role] = await _readRoleSession(role);
    }
    _sessionRoleStack
      ..clear()
      ..addAll(
        storedRoleStack.where((role) => _roleSessionCache[role] != null),
      );
    if (preferredRole != null && _roleSessionCache[preferredRole] != null) {
      _recordActiveRole(preferredRole);
    }
    _activeSessionCache = _resolveActiveSessionFromCache(
      preferredRole: preferredRole,
    );
    _cacheHydrated = true;
    await _persistRoleStack();
    await _syncActiveRoleKeyFromCache();
  }

  Future<void> saveSessionForRole({
    required UserRole role,
    required String accessToken,
    required String refreshToken,
    required String currentUserJson,
  }) async {
    final generation = ++_sessionGeneration;
    await hydrateCache();
    await _mutate(() async {
      if (generation != _sessionGeneration) return;
      _verifiedActiveUser = null;
      await _writeSession(
        role: role,
        accessToken: accessToken,
        refreshToken: refreshToken,
        currentUserJson: currentUserJson,
      );
      _notifySessionChanged();
    });
  }

  Future<void> _writeSession({
    required UserRole role,
    required String accessToken,
    required String refreshToken,
    required String currentUserJson,
  }) async {
    final normalizedAccessToken = accessToken.trim();
    final normalizedRefreshToken = refreshToken.trim();
    final normalizedCurrentUserJson = _normalizedCurrentUserJson(
      currentUserJson,
      role,
    );

    await _storage.write(
      key: StorageKeys.accessTokenForRole(role.apiValue),
      value: normalizedAccessToken,
    );
    await _storage.write(
      key: StorageKeys.refreshTokenForRole(role.apiValue),
      value: normalizedRefreshToken,
    );
    await _storage.write(
      key: StorageKeys.currentUserForRole(role.apiValue),
      value: normalizedCurrentUserJson,
    );
    await _storage.write(key: StorageKeys.activeRole, value: role.apiValue);

    final savedSession = RoleSession(
      role: role,
      accessToken: normalizedAccessToken,
      refreshToken: normalizedRefreshToken,
      user: _parseStoredUser(normalizedCurrentUserJson, role),
    );
    _roleSessionCache[role] = savedSession;
    // A successful login or role switch is authoritative. Do not let a
    // previously saved lower-priority role silently replace the new session.
    _activeSessionCache = savedSession;
    _recordActiveRole(role);
    _cacheHydrated = true;
    await _persistRoleStack();
    await _syncActiveRoleKeyFromCache();
  }

  Future<String?> getAccessTokenForRole(UserRole role) async {
    if (_cacheHydrated) {
      return _roleSessionCache[role]?.accessToken;
    }

    await _migrateLegacySessionIfNeeded();
    return _readNonEmpty(StorageKeys.accessTokenForRole(role.apiValue));
  }

  Future<String?> getRefreshTokenForRole(UserRole role) async {
    if (_cacheHydrated) {
      return _roleSessionCache[role]?.refreshToken;
    }

    await _migrateLegacySessionIfNeeded();
    return _readNonEmpty(StorageKeys.refreshTokenForRole(role.apiValue));
  }

  Future<String?> getCurrentUserJsonForRole(UserRole role) async {
    if (_cacheHydrated) {
      final session = _roleSessionCache[role];
      if (session == null) return null;
      return jsonEncode(session.user.toJson());
    }

    await _migrateLegacySessionIfNeeded();
    return _readNonEmpty(StorageKeys.currentUserForRole(role.apiValue));
  }

  Future<void> clearSessionForRole(UserRole role) async {
    ++_sessionGeneration;
    await hydrateCache();
    await _mutate(() async {
      await _clearSession(role);
      _notifySessionChanged();
    });
  }

  Future<void> _clearSession(UserRole role) async {
    _verifiedActiveUser = null;
    await _storage.delete(key: StorageKeys.accessTokenForRole(role.apiValue));
    await _storage.delete(key: StorageKeys.refreshTokenForRole(role.apiValue));
    await _storage.delete(key: StorageKeys.currentUserForRole(role.apiValue));
    _roleSessionCache[role] = null;
    _sessionRoleStack.removeWhere((storedRole) => storedRole == role);
    if (_activeSessionCache?.role == role) {
      _activeSessionCache = _resolveActiveSessionFromCache();
    }
    _cacheHydrated = true;
    await _persistRoleStack();
    await _syncActiveRoleKeyFromCache();
  }

  Future<void> clearAllSessions() async {
    ++_sessionGeneration;
    await hydrateCache();
    await _mutate(() async {
      await _clearAllSessions();
      _notifySessionChanged();
    });
  }

  Future<void> _clearAllSessions() async {
    _verifiedActiveUser = null;
    for (final role in UserRole.values) {
      await _storage.delete(key: StorageKeys.accessTokenForRole(role.apiValue));
      await _storage.delete(
        key: StorageKeys.refreshTokenForRole(role.apiValue),
      );
      await _storage.delete(key: StorageKeys.currentUserForRole(role.apiValue));
    }
    await _storage.delete(key: StorageKeys.activeRole);
    await _storage.delete(key: StorageKeys.sessionRoleStack);
    await _deleteLegacyKeys();
    _cacheHydration = null;
    _roleSessionCache.clear();
    for (final role in UserRole.values) {
      _roleSessionCache[role] = null;
    }
    _sessionRoleStack.clear();
    _activeSessionCache = null;
    _cacheHydrated = true;
  }

  Future<UserRole?> getActiveRoleByPriority() async {
    if (!_cacheHydrated) {
      await hydrateCache();
    }

    return _activeSessionCache?.role;
  }

  Future<RoleSession?> getActiveSession() {
    return OpenVtsPerf.traceAsync('token.getActiveSession', () async {
      if (!_cacheHydrated) {
        await hydrateCache();
      }

      return cachedActiveSession;
    });
  }

  Future<bool> hasSessionForRole(UserRole role) async {
    if (!_cacheHydrated) {
      await hydrateCache();
    }

    return _roleSessionCache[role] != null;
  }

  Future<String?> getActiveAccessToken() {
    return OpenVtsPerf.traceAsync('token.getActiveAccessToken', () async {
      if (!_cacheHydrated) {
        await hydrateCache();
      }

      return cachedActiveAccessToken;
    });
  }

  Future<void> migrateLegacySessionIfNeeded() {
    return _migrateLegacySessionIfNeeded();
  }

  @Deprecated('Use saveSessionForRole instead.')
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final activeRole = await getActiveRoleByPriority() ?? UserRole.user;
    final currentUserJson =
        await getCurrentUserJsonForRole(activeRole) ??
        _fallbackUserJson(activeRole);
    await saveSessionForRole(
      role: activeRole,
      accessToken: accessToken,
      refreshToken: refreshToken,
      currentUserJson: currentUserJson,
    );
  }

  @Deprecated('Use getAccessTokenForRole or getActiveAccessToken instead.')
  Future<String?> getAccessToken() {
    return getActiveAccessToken();
  }

  @Deprecated('Use getRefreshTokenForRole instead.')
  Future<String?> getRefreshToken() {
    return _getRefreshTokenForRoleRawByPriority();
  }

  @Deprecated('Use role-scoped session methods instead.')
  Future<void> saveRole(String role) async {
    await _storage.write(key: StorageKeys.activeRole, value: role);
    invalidateCache();
  }

  @Deprecated('Use getActiveRoleByPriority instead.')
  Future<String?> getRole() async {
    if (_cacheHydrated) {
      return _activeSessionCache?.role.apiValue;
    }

    return _storage.read(key: StorageKeys.activeRole);
  }

  @Deprecated('Use saveSessionForRole instead.')
  Future<void> saveCurrentUserJson(String value) {
    return _saveCurrentUserForActiveRole(value);
  }

  @Deprecated('Use getCurrentUserJsonForRole instead.')
  Future<String?> getCurrentUserJson() {
    return _getCurrentUserForActiveRoleByPriority();
  }

  @Deprecated('Use clearSessionForRole or clearAllSessions instead.')
  Future<void> clear() async {
    await clearAllSessions();
  }

  Future<void> _migrateLegacySessionIfNeeded() async {
    if (_didCheckLegacyMigration) {
      return;
    }

    _didCheckLegacyMigration = true;

    if (await _hasAnyRoleSessionRaw()) {
      await _syncActiveRoleKey();
      return;
    }

    final legacyAccessToken = await _readNonEmpty(StorageKeys.accessToken);
    final legacyRoleValue = await _readNonEmpty(StorageKeys.userRole);

    if (legacyAccessToken == null || legacyRoleValue == null) {
      return;
    }

    final role = UserRole.fromString(legacyRoleValue);
    final legacyRefreshToken =
        (await _storage.read(key: StorageKeys.refreshToken))?.trim() ?? '';
    final legacyCurrentUserJson = await _storage.read(
      key: StorageKeys.currentUser,
    );

    await _writeSession(
      role: role,
      accessToken: legacyAccessToken,
      refreshToken: legacyRefreshToken,
      currentUserJson: _normalizedCurrentUserJson(
        legacyCurrentUserJson ?? '',
        role,
      ),
    );

    await _deleteLegacyKeys();
    await _syncActiveRoleKey();
  }

  Future<RoleSession?> _readRoleSession(UserRole role) async {
    final accessToken = await _readNonEmpty(
      StorageKeys.accessTokenForRole(role.apiValue),
    );
    if (accessToken == null) {
      return null;
    }

    final refreshToken =
        (await _storage.read(
          key: StorageKeys.refreshTokenForRole(role.apiValue),
        ))?.trim() ??
        '';
    final currentUserJson = await _storage.read(
      key: StorageKeys.currentUserForRole(role.apiValue),
    );

    return RoleSession(
      role: role,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: _parseStoredUser(currentUserJson, role),
    );
  }

  CurrentUser _parseStoredUser(String? currentUserJson, UserRole role) {
    final normalizedJson = currentUserJson?.trim();
    if (normalizedJson != null && normalizedJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(normalizedJson);
        if (decoded is Map<String, dynamic>) {
          return CurrentUser.fromJson(decoded).copyWith(role: role);
        }
      } catch (_) {
        // Ignore malformed json and fallback to a generated user.
      }
    }

    return _fallbackUser(role);
  }

  RoleSession? _resolveActiveSessionFromCache({UserRole? preferredRole}) {
    if (preferredRole != null) {
      final preferred = _roleSessionCache[preferredRole];
      if (preferred != null) {
        return preferred;
      }
    }

    for (final role in _sessionRoleStack.reversed) {
      final session = _roleSessionCache[role];
      if (session != null) {
        return session;
      }
    }

    for (final role in _rolePriority) {
      final session = _roleSessionCache[role];
      if (session != null) {
        return session;
      }
    }

    return null;
  }

  Future<void> _syncActiveRoleKeyFromCache() async {
    final activeRole = _activeSessionCache?.role;
    if (activeRole == null) {
      await _storage.delete(key: StorageKeys.activeRole);
      return;
    }

    await _storage.write(
      key: StorageKeys.activeRole,
      value: activeRole.apiValue,
    );
  }

  Future<bool> _hasAnyRoleSessionRaw() async {
    for (final role in UserRole.values) {
      if (await _hasSessionForRoleRaw(role)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> _hasSessionForRoleRaw(UserRole role) async {
    final token = await _readNonEmpty(
      StorageKeys.accessTokenForRole(role.apiValue),
    );
    return token != null;
  }

  Future<void> _syncActiveRoleKey() async {
    final preferredRole = await _readStoredActiveRole();
    if (preferredRole != null && await _hasSessionForRoleRaw(preferredRole)) {
      return;
    }

    final roleStack = await _readStoredRoleStack();
    for (final role in roleStack.reversed) {
      if (await _hasSessionForRoleRaw(role)) {
        await _storage.write(key: StorageKeys.activeRole, value: role.apiValue);
        return;
      }
    }

    for (final role in _rolePriority) {
      if (await _hasSessionForRoleRaw(role)) {
        await _storage.write(key: StorageKeys.activeRole, value: role.apiValue);
        return;
      }
    }

    await _storage.delete(key: StorageKeys.activeRole);
  }

  void _recordActiveRole(UserRole role) {
    if (role == UserRole.unknown) return;
    _sessionRoleStack.removeWhere((storedRole) => storedRole == role);
    _sessionRoleStack.add(role);
  }

  Future<List<UserRole>> _readStoredRoleStack() async {
    final raw = await _readNonEmpty(StorageKeys.sessionRoleStack);
    if (raw == null) return const <UserRole>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <UserRole>[];
      final roles = <UserRole>[];
      for (final item in decoded) {
        final role = UserRole.fromString(item?.toString());
        if (role == UserRole.unknown || roles.contains(role)) continue;
        roles.add(role);
      }
      return roles;
    } catch (_) {
      return const <UserRole>[];
    }
  }

  Future<void> _persistRoleStack() async {
    final roles = _sessionRoleStack
        .where((role) => role != UserRole.unknown)
        .map((role) => role.apiValue)
        .toList(growable: false);
    if (roles.isEmpty) {
      await _storage.delete(key: StorageKeys.sessionRoleStack);
      return;
    }
    await _storage.write(
      key: StorageKeys.sessionRoleStack,
      value: jsonEncode(roles),
    );
  }

  Future<UserRole?> _readStoredActiveRole() async {
    final raw = (await _storage.read(
      key: StorageKeys.activeRole,
    ))?.trim().toLowerCase();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    for (final role in UserRole.values) {
      if (raw == role.apiValue) {
        return role;
      }
    }

    return null;
  }

  Future<String?> _readNonEmpty(String key) async {
    final raw = await _storage.read(key: key);
    final normalized = raw?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  String _normalizedCurrentUserJson(String rawJson, UserRole role) {
    final normalized = rawJson.trim();
    if (normalized.isEmpty) {
      return _fallbackUserJson(role);
    }

    try {
      final decoded = jsonDecode(normalized);
      if (decoded is Map<String, dynamic>) {
        final normalizedUser = CurrentUser.fromJson(
          decoded,
        ).copyWith(role: role);
        return jsonEncode(normalizedUser.toJson());
      }
    } catch (_) {
      return _fallbackUserJson(role);
    }

    return _fallbackUserJson(role);
  }

  String _fallbackUserJson(UserRole role) {
    return jsonEncode(_fallbackUser(role).toJson());
  }

  CurrentUser _fallbackUser(UserRole role) {
    return CurrentUser(
      id: 'restored',
      name: role == UserRole.superadmin
          ? 'Super Admin'
          : role == UserRole.admin
          ? 'Admin'
          : 'User',
      email: '',
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

  Future<void> _deleteLegacyKeys() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userRole);
    await _storage.delete(key: StorageKeys.currentUser);
  }

  Future<void> _saveCurrentUserForActiveRole(String value) async {
    final activeSession = await getActiveSession();
    if (activeSession == null) {
      return;
    }

    await saveSessionForRole(
      role: activeSession.role,
      accessToken: activeSession.accessToken,
      refreshToken: activeSession.refreshToken,
      currentUserJson: value,
    );
  }

  Future<String?> _getCurrentUserForActiveRoleByPriority() async {
    final activeSession = await getActiveSession();
    if (activeSession == null) {
      return null;
    }

    return jsonEncode(activeSession.user.toJson());
  }

  Future<String?> _getRefreshTokenForRoleRawByPriority() async {
    final activeSession = await getActiveSession();
    if (activeSession == null) {
      return null;
    }

    return activeSession.refreshToken;
  }
}
