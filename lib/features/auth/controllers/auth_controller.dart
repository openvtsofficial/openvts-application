import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/notifications/mobile_push_controller.dart';
import '../../../core/notifications/mobile_push_perf.dart';
import '../../../core/performance/open_vts_perf.dart';
import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/demo/demo_mode_store.dart';
import '../../../core/storage/token_storage.dart';
import '../../../shared/models/user_role.dart';
import '../models/current_user.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/mfa_login_challenge.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(apiClientProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    authService: ref.watch(authServiceProvider),
    mobilePushController: ref.watch(mobilePushControllerProvider.notifier),
    tokenStorage: ref.watch(tokenStorageProvider),
    demoModeStore: ref.watch(demoModeStoreProvider),
    appPreferencesCtrl: ref.watch(appLocalizationPreferencesProvider.notifier),
  );
});

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthService authService,
    required MobilePushController mobilePushController,
    required TokenStorage tokenStorage,
    required DemoModeStore demoModeStore,
    required AppLocalizationPreferencesController appPreferencesCtrl,
  })  : _authService = authService,
        _mobilePushController = mobilePushController,
        _tokenStorage = tokenStorage,
        _demoModeStore = demoModeStore,
        _appPreferencesCtrl = appPreferencesCtrl,
        super(const AuthState.initial());

  final AuthService _authService;
  final MobilePushController _mobilePushController;
  final TokenStorage _tokenStorage;
  final DemoModeStore _demoModeStore;
  final AppLocalizationPreferencesController _appPreferencesCtrl;

  CurrentUser? get currentUser => state.user;

  Future<void> restoreSession() {
    return OpenVtsPerf.traceAsync('auth.restore', () async {
      state = const AuthState.loading();
      final stopwatch =
          (kDebugMode || kProfileMode) ? (Stopwatch()..start()) : null;
      mobilePushPerfLog('auth_restore start');
      await _setStateFromActiveSession();
      if (stopwatch != null) {
        mobilePushPerfLog(
          'auth_restore end (${stopwatch.elapsedMilliseconds}ms)',
        );
      }
    });
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) {
    return OpenVtsPerf.traceAsync('auth.login', () async {
      state = const AuthState.loading();

      try {
        final response = await _authService.login(
          LoginRequest(identifier: identifier, password: password),
        );
        if (!mounted) return;
        await setSession(response);
      } on MfaLoginChallenge catch (challenge) {
        if (!mounted) return;
        state = AuthState(status: AuthStatus.unauthenticated, mfaChallenge: challenge);
      } catch (error) {
        if (!mounted) return;
        _setUnauthenticated(errorMessage: _friendlyLoginError(error));
      }
    });
  }

  static String _friendlyLoginError(Object error) {
    if (error is ApiException) return error.message;
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.trim().isNotEmpty &&
            (error.response?.statusCode ?? 500) < 500) return message;
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown) {
        final msg = error.message ?? '';
        if (msg.contains('XMLHttpRequest') ||
            msg.contains('connection error') ||
            msg.toLowerCase().contains('cors') ||
            msg.contains('Failed to fetch')) {
          return 'Cannot reach the server. '
              'If you are using the web app, the server must allow cross-origin '
              'requests (CORS). Check the Server URL in settings and ensure '
              'the server is reachable from this device.';
        }
        return 'Could not connect to the server. '
            'Check the Server URL in settings and your network connection.';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Connection timed out. '
            'Check the Server URL in settings and your network connection.';
      }
      if (error.type == DioExceptionType.badResponse) {
        final status = error.response?.statusCode;
        if (status == 401 || status == 403) {
          return 'Incorrect username or password.';
        }
        if (status != null && status >= 500) {
          return 'The server returned an error ($status). '
              'Try again or contact your administrator.';
        }
      }
    }
    final raw = error.toString();
    final cleaned = raw.replaceFirst(
        RegExp(r'^(ApiException\(\d+\)|DioException[^:]*): '), '');
    return cleaned.isNotEmpty ? cleaned : raw;
  }

  Future<void> verifyMfaLogin(String code) async {
    final challenge = state.mfaChallenge;
    if (challenge == null || state.isVerifyingMfa) return;
    if (challenge.isExpired) {
      _setUnauthenticated(errorMessage: 'Verification expired. Please sign in again.');
      return;
    }
    state = AuthState(status: AuthStatus.unauthenticated,
        mfaChallenge: challenge, isVerifyingMfa: true);
    try {
      final response = await _authService.verifyMfaLogin(
        challengeToken: challenge.token, code: code,
      );
      if (!mounted) return;
      await setSession(response);
    } catch (error) {
      if (!mounted) return;
      state = AuthState(status: AuthStatus.unauthenticated,
          mfaChallenge: challenge, errorMessage: _friendlyLoginError(error));
    }
  }

  void cancelMfaLogin() {
    if (!state.isVerifyingMfa) _setUnauthenticated();
  }

  Future<void> closeAccount({required String currentPassword, String? code}) async {
    if (state.isDemo || state.user?.canCloseAccount != true) {
      throw const ApiException(message: 'Account closure is unavailable for this account.');
    }
    final closingUser = state.user!;
    final closingRevision = _tokenStorage.sessionRevision;
    await _authService.closeAccount(currentPassword: currentPassword, code: code);
    if (!mounted || _tokenStorage.sessionRevision != closingRevision ||
        state.user?.id != closingUser.id ||
        state.user?.effectiveBackendRole != closingUser.effectiveBackendRole) return;
    // Also clear this device's push token and notifications. The service cleans
    // up locally even though account closure already revoked the server token.
    await _deregisterPushForCurrentSession();
    if (!mounted || _tokenStorage.sessionRevision != closingRevision ||
        state.user?.id != closingUser.id ||
        state.user?.effectiveBackendRole != closingUser.effectiveBackendRole) return;
    // Server revokes every session. Remove saved roles too, so the app cannot
    // silently return to an earlier account after this deliberate exit.
    await _demoModeStore.clear();
    if (!mounted || _tokenStorage.sessionRevision != closingRevision) return;
    final expectedClearedRevision = closingRevision + 1;
    await _tokenStorage.clearAllSessions();
    if (mounted && _tokenStorage.sessionRevision == expectedClearedRevision) {
      _setUnauthenticated();
    }
  }

  Future<String> requestPasswordReset(String identifier) {
    return _authService.requestPasswordReset(identifier);
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) {
    return _authService.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  Future<void> setSession(LoginResponse response) {
    return OpenVtsPerf.traceAsync('auth.setSession', () async {
      if (!mounted) return;
      await _demoModeStore.clear();
      if (!mounted) return;
      await _tokenStorage.saveSessionForRole(
        role: response.user.role,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        currentUserJson: jsonEncode(response.user.toJson()),
      );
      await _setStateFromActiveSession();
    });
  }

  Future<void> replaceCurrentUser(CurrentUser user) async {
    if (state.isDemo) {
      state = AuthState.authenticated(
        user.copyWith(role: UserRole.user),
        isDemo: true,
      );
      return;
    }

    final activeSession = await _tokenStorage.getActiveSession();
    if (activeSession == null) {
      _setUnauthenticated();
      return;
    }

    // A late profile response must never overwrite a different signed-in user.
    if (activeSession.user.id != user.id) return;
    final role = activeSession.role;
    final saved = await _tokenStorage.saveRefreshedSession(
      expectedSession: activeSession,
      accessToken: activeSession.accessToken,
      refreshToken: activeSession.refreshToken,
      currentUserJson: jsonEncode(user.copyWith(role: role).toJson()),
    );
    if (saved && mounted) await _setStateFromActiveSession();
  }

  Future<UserRole?> logout() async {
    return logoutActiveRole();
  }

  Future<UserRole?> logoutActiveRole() async {
    if (state.isDemo) {
      state = const AuthState.loading();
      await _demoModeStore.clear();
      await _setStateFromActiveSession();
      return UserRole.user;
    }

    final activeRole =
        state.user?.role ?? await _tokenStorage.getActiveRoleByPriority();
    if (activeRole == null) {
      _setUnauthenticated();
      return null;
    }

    await _deregisterPushForCurrentSession();

    state = const AuthState.loading();

    try {
      await _authService.logout();
    } finally {
      await _tokenStorage.clearSessionForRole(activeRole);
    }

    await _setStateFromActiveSession();
    return activeRole;
  }

  Future<void> logoutAllRoles() async {
    await _deregisterPushForCurrentSession();

    state = const AuthState.loading();
    await _demoModeStore.clear();
    await _tokenStorage.clearAllSessions();
    _setUnauthenticated();
  }

  Future<void> _setStateFromActiveSession() async {
    // Demo access is disabled, including persisted sessions from older builds.
    if (_demoModeStore.isEnabled || _demoModeStore.cachedSession != null) {
      await _demoModeStore.clear();
    }

    final session = await _tokenStorage.getActiveSession();
    if (session == null) {
      _setUnauthenticated();
      return;
    }

    state = AuthState.authenticated(session.user);
    _mobilePushController.updateAuthenticationState(isAuthenticated: true);

    // Rehydrate localization preferences from LocalCache on session restore
    _appPreferencesCtrl.rehydrate();
  }

  void _setUnauthenticated({String? errorMessage}) {
    state = AuthState.unauthenticated(errorMessage: errorMessage);
    _mobilePushController.updateAuthenticationState(isAuthenticated: false);
  }

  Future<void> _deregisterPushForCurrentSession() async {
    if (state.isDemo) {
      _mobilePushController.updateAuthenticationState(isAuthenticated: false);
      return;
    }

    try {
      final session = await _tokenStorage.getActiveSession();
      if (session == null) {
        _mobilePushController.updateAuthenticationState(
          isAuthenticated: false,
        );
        return;
      }

      _mobilePushController.updateAuthenticationState(isAuthenticated: true);
      await _ignorePushFailure(_mobilePushController.deregisterCurrentToken);
    } catch (_) {
      // Push deregistration must never block logout.
    }
  }

  Future<void> _ignorePushFailure(Future<dynamic> Function() operation) async {
    try {
      await operation();
    } catch (_) {
      // Push token sync must not change auth outcomes.
    }
  }
}
