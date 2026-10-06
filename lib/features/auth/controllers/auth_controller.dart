import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/mobile_access.dart';
import '../../../core/access/mobile_access_service.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/auth_api_error.dart';
import '../../../core/demo/demo_mode_store.dart';
import '../../../core/demo/demo_session.dart';
import '../../../core/demo/demo_session_service.dart';
import '../../../core/notifications/mobile_push_controller.dart';
import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/token_storage.dart';
import '../../../shared/models/user_role.dart';
import '../models/current_user.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/mfa_challenge.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

final Provider<AuthService> authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(apiClientProvider)),
);
final StateNotifierProvider<AuthController, AuthState> authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(
        authService: ref.watch(authServiceProvider),
        accessService: MobileAccessService(ref.watch(apiClientProvider)),
        mobilePushController: ref.watch(mobilePushControllerProvider.notifier),
        tokenStorage: ref.watch(tokenStorageProvider),
        demoModeStore: ref.watch(demoModeStoreProvider),
        demoSessionService: ref.watch(demoSessionServiceProvider),
        appPreferencesCtrl: ref.watch(
          appLocalizationPreferencesProvider.notifier,
        ),
      ),
    );

class AuthController extends StateNotifier<AuthState>
    with WidgetsBindingObserver {
  AuthController({
    required AuthService authService,
    MobileAccessService? accessService,
    required MobilePushController mobilePushController,
    required TokenStorage tokenStorage,
    required DemoModeStore demoModeStore,
    required DemoSessionService demoSessionService,
    required AppLocalizationPreferencesController appPreferencesCtrl,
  }) : _authService = authService,
       _accessService = accessService,
       _mobilePushController = mobilePushController,
       _tokenStorage = tokenStorage,
       _demoModeStore = demoModeStore,
       _demoSessionService = demoSessionService,
       _appPreferencesCtrl = appPreferencesCtrl,
       super(const AuthState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _removeSessionListener = _tokenStorage.listenToSession(
      _handleStoredSessionChanged,
    );
    _accessTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => refreshAccess(),
    );
  }
  final AuthService _authService;
  final MobileAccessService? _accessService;
  final MobilePushController _mobilePushController;
  final TokenStorage _tokenStorage;
  final DemoModeStore _demoModeStore;
  final DemoSessionService _demoSessionService;
  final AppLocalizationPreferencesController _appPreferencesCtrl;
  Timer? _accessTimer;
  void Function()? _removeSessionListener;
  bool _refreshingAccess = false;
  bool _reconcilingStoredSession = false;
  int _generation = 0;
  bool _valid(int generation) => mounted && generation == _generation;
  CurrentUser? get currentUser => state.user;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refreshAccess();
  }

  @override
  void dispose() {
    _generation++;
    _accessTimer?.cancel();
    _removeSessionListener?.call();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> refreshAccess() async {
    final user = state.user;
    if (!state.isRealSession ||
        user == null ||
        _accessService == null ||
        _refreshingAccess) {
      return;
    }
    final generation = _generation;
    _refreshingAccess = true;
    try {
      final verified = await _authService.getProfile(user);
      if (!_valid(generation)) return;
      final updated = await _accessService.loadAccess(verified);
      if (_valid(generation)) _setAuthenticated(updated);
    } catch (error) {
      if (!_valid(generation)) return;
      if (AuthApiError.isSessionInvalidated(error)) {
        final session = await _tokenStorage.getActiveSession();
        if (!_valid(generation)) return;
        if (session != null &&
            session.user.id == user.id &&
            session.role == user.role) {
          await _tokenStorage.clearSessionIfCurrent(
            session,
            _tokenStorage.sessionGeneration,
          );
        }
        if (_valid(generation)) {
          await _restoreAfterSessionInvalidation(generation);
        }
      } else {
        // Authentication survives transport outages. Permission data must still
        // fail closed until the next foreground/periodic verification succeeds.
        _setAuthenticated(
          user.copyWith(access: const MobileAccess.unavailable()),
        );
      }
    } finally {
      _refreshingAccess = false;
    }
  }

  Future<void> restoreSession() async {
    final generation = ++_generation;
    state = const AuthState.loading();
    await _restore(generation);
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final generation = ++_generation;
    state = const AuthState.loading();
    try {
      final response = await _authService.login(
        LoginRequest(identifier: identifier, password: password),
      );
      if (_valid(generation)) await setSession(response);
    } on MfaRequiredException catch (required) {
      if (_valid(generation)) state = AuthState.mfaRequired(required.challenge);
    } catch (error) {
      if (_valid(generation)) {
        _setUnauthenticated(errorMessage: _friendlyLoginError(error));
      }
    }
  }

  Future<void> verifyMfa(String code) async {
    final challenge = state.mfaChallenge;
    if (challenge == null || state.isVerifyingMfa) return;
    if (challenge.isExpired) {
      _setUnauthenticated(
        errorMessage: 'Sign-in expired. Enter your password again.',
      );
      return;
    }
    final generation = ++_generation;
    state = AuthState.mfaRequired(challenge, isVerifying: true);
    try {
      final response = await _authService.verifyMfaLogin(challenge, code);
      if (_valid(generation)) await setSession(response);
    } catch (error) {
      if (_valid(generation)) {
        state = AuthState.mfaRequired(
          challenge,
          errorMessage: _friendlyLoginError(error),
        );
      }
    }
  }

  void cancelMfa() {
    if (!state.isVerifyingMfa) {
      _generation++;
      _setUnauthenticated();
    }
  }

  Future<void> setSession(LoginResponse response) async {
    if (response.accessToken.trim().isEmpty ||
        response.refreshToken.trim().isEmpty ||
        response.user.id.isEmpty ||
        response.user.role == UserRole.unknown) {
      throw const ApiException(
        message: 'The server returned an invalid account session.',
      );
    }
    final generation = ++_generation;
    state = const AuthState.loading();
    try {
      await _demoModeStore.clear();
      if (!_valid(generation)) return;
      await _tokenStorage.saveSessionForRole(
        role: response.user.role,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        currentUserJson: jsonEncode(response.user.toJson()),
      );
      if (!_valid(generation)) {
        final current = await _tokenStorage.getActiveSession();
        if (current?.accessToken == response.accessToken) {
          await _tokenStorage.clearSessionIfCurrent(
            current!,
            _tokenStorage.sessionGeneration,
          );
        }
        return;
      }
      if (response.settings.isNotEmpty) {
        final settings = response.settings;
        try {
          await _appPreferencesCtrl.applyFromUserSettings(
            preserveAppLanguage: true,
            languageCode: settings['languageCode']?.toString() ?? 'en',
            dateFormat: settings['dateFormat']?.toString() ?? 'DD MMM YYYY',
            timeFormat: settings['timeFormat']?.toString() ?? '12H',
            theme: settings['theme']?.toString() ?? 'SYSTEM',
            timezone: settings['timezone']?.toString() ?? '+00:00',
            layoutDirection: settings['direction']?.toString() ?? 'LTR',
            units: settings['distanceUnit']?.toString() ?? 'KM',
          );
        } catch (_) {
          // Preferences are not authentication state. A local preferences
          // write failure must never discard a freshly issued session.
        }
      }
      await _restore(generation);
    } catch (error) {
      if (!_valid(generation)) return;
      final active = await _tokenStorage.getActiveSession();
      if (!_valid(generation)) return;
      if (active != null) {
        await _restore(generation);
      } else {
        _setUnauthenticated(errorMessage: _friendlyLoginError(error));
      }
    }
  }

  /// Switches from the currently authenticated parent account to a child
  /// account without discarding the parent session. The stored role stack then
  /// provides deterministic back-navigation when the child logs out or expires.
  Future<void> switchToChildSession(LoginResponse response) async {
    final parentUser = state.user;
    final parentSession = await _tokenStorage.getActiveSession();
    if (!state.isRealSession ||
        parentUser == null ||
        parentSession == null ||
        parentSession.user.id != parentUser.id ||
        parentSession.role != parentUser.role) {
      throw const ApiException(
        message: 'Your current account session is no longer available.',
      );
    }
    if (!_canSwitchToChild(parentSession.role, response.user.role)) {
      throw ApiException(
        message:
            'The ${response.user.role.displayLabel} account is not a child of '
            'the current ${parentSession.role.displayLabel} session.',
      );
    }

    await setSession(response);

    final active = await _tokenStorage.getActiveSession();
    final switched = state.isRealSession &&
        active != null &&
        active.role == response.user.role &&
        active.user.id == response.user.id &&
        state.role == response.user.role &&
        state.user?.id == response.user.id;
    if (switched) return;

    // If bootstrap failed after the child credentials were stored, remove only
    // that child and recover the exact parent path. Never clear all roles.
    if (active != null &&
        active.role == response.user.role &&
        active.user.id == response.user.id) {
      await _tokenStorage.clearSessionIfCurrent(
        active,
        _tokenStorage.sessionGeneration,
      );
    }
    final restored = await _tokenStorage.getActiveSession();
    if (restored != null &&
        (!state.isRealSession ||
            state.role != restored.role ||
            state.user?.id != restored.user.id)) {
      final generation = ++_generation;
      state = const AuthState.loading();
      await _restore(generation);
    }

    throw const ApiException(
      message: 'Unable to switch accounts. Your previous session was restored.',
    );
  }

  Future<void> _restore(int generation) async {
    if (!_valid(generation)) return;
    final demo = _demoModeStore.cachedSession;
    if (_demoModeStore.isEnabled && demo != null) {
      _setDemoSession(demo);
      return;
    }
    if (_demoModeStore.isEnabled || demo != null) await _demoModeStore.clear();
    final session = await _tokenStorage.getActiveSession();
    if (!_valid(generation)) return;
    if (session == null) {
      _setUnauthenticated();
      return;
    }
    try {
      final profile = await _authService.getProfile(session.user);
      if (!_valid(generation)) return;
      final user = await _accessService?.loadAccess(profile) ?? profile;
      if (!_valid(generation)) return;
      _setAuthenticated(user);
      // The current backend push-token table references User IDs, not Driver IDs.
      _mobilePushController.updateAuthenticationState(
        isAuthenticated: user.role != UserRole.driver,
      );
      _appPreferencesCtrl.rehydrate();
    } catch (error) {
      if (!_valid(generation)) return;
      if (AuthApiError.isSessionInvalidated(error)) {
        final active = await _tokenStorage.getActiveSession();
        if (!_valid(generation)) return;
        if (_sameSession(active, session)) {
          await _tokenStorage.clearSessionIfCurrent(
            session,
            _tokenStorage.sessionGeneration,
          );
        }
        if (_valid(generation)) {
          await _restoreAfterSessionInvalidation(generation);
        }
      } else {
        // A server timeout or a temporary permission error must not send a
        // returning mobile user to Login. Cached authorization is not trusted.
        _setAuthenticated(
          session.user.copyWith(access: const MobileAccess.unavailable()),
        );
        _mobilePushController.updateAuthenticationState(
          isAuthenticated: session.role != UserRole.driver,
        );
        _appPreferencesCtrl.rehydrate();
      }
    }
  }

  void _handleStoredSessionChanged() {
    if (!state.isRealSession || _reconcilingStoredSession) return;
    final active = _tokenStorage.cachedActiveSession;
    if (active != null &&
        active.user.id == state.user?.id &&
        active.role == state.role) {
      return;
    }

    if (active == null) {
      _generation++;
      _setUnauthenticated(
        errorMessage: 'Your session expired. Sign in again.',
      );
      return;
    }

    unawaited(_restoreStoredActiveSession());
  }

  Future<void> _restoreStoredActiveSession() async {
    if (_reconcilingStoredSession || !mounted) return;
    _reconcilingStoredSession = true;
    final generation = ++_generation;
    state = const AuthState.loading();
    try {
      await _restore(generation);
    } finally {
      _reconcilingStoredSession = false;
    }
  }

  Future<void> _restoreAfterSessionInvalidation(int generation) async {
    if (!_valid(generation)) return;
    final fallback = await _tokenStorage.getActiveSession();
    if (!_valid(generation)) return;
    if (fallback == null) {
      _setUnauthenticated(
        errorMessage: 'Your session expired. Sign in again.',
      );
      return;
    }
    await _restore(generation);
  }

  static bool _sameSession(RoleSession? left, RoleSession right) =>
      left != null &&
      left.role == right.role &&
      left.user.id == right.user.id &&
      left.accessToken == right.accessToken &&
      left.refreshToken == right.refreshToken;

  static bool _canSwitchToChild(UserRole parent, UserRole child) {
    return switch (parent) {
      UserRole.superadmin => child == UserRole.admin,
      UserRole.admin => child == UserRole.team || child == UserRole.user,
      UserRole.team => child == UserRole.user,
      UserRole.user =>
        child == UserRole.subuser || child == UserRole.driver,
      UserRole.subuser => false,
      UserRole.driver => false,
      UserRole.unknown => false,
    };
  }

  Future<void> replaceCurrentUser(CurrentUser user) async {
    final generation = _generation;
    if (state.isDemo) {
      state = AuthState.authenticated(
        user.copyWith(role: UserRole.user),
        isDemo: true,
      );
      return;
    }
    final session = await _tokenStorage.getActiveSession();
    if (!_valid(generation) ||
        session == null ||
        session.user.id != user.id ||
        session.role != user.role) {
      return;
    }
    final updated = await _tokenStorage.updateProfileIfCurrent(session, user);
    if (updated && _valid(generation)) _setAuthenticated(user);
  }

  /// The backend invalidates the old auth version on every MFA security change.
  Future<void> applySecuritySession(Map<String, dynamic> replacement) async {
    final generation = ++_generation;
    final user = state.user;
    final session = await _tokenStorage.getActiveSession();
    final token = replacement['token']?.toString() ?? '',
        refresh = replacement['refresh_token']?.toString() ?? '';
    if (!_valid(generation)) return;
    if (session == null ||
        user == null ||
        session.user.id != user.id ||
        session.role != user.role ||
        token.isEmpty ||
        refresh.isEmpty) {
      throw const ApiException(
        message:
            'The server did not return the replacement session. Sign in again.',
      );
    }
    await _tokenStorage.saveSessionForRole(
      role: session.role,
      accessToken: token,
      refreshToken: refresh,
      currentUserJson: jsonEncode(user.toJson()),
    );
    if (_valid(generation)) _setAuthenticated(user);
  }

  Future<UserRole?> logout() => logoutActiveRole();
  Future<UserRole?> logoutActiveRole() async {
    final generation = ++_generation;
    if (state.isDemo) {
      state = const AuthState.loading();
      await _demoModeStore.clear();
      await _restore(generation);
      return UserRole.user;
    }
    final role = state.role ?? await _tokenStorage.getActiveRoleByPriority();
    if (!_valid(generation)) return role;
    if (role == null) {
      _setUnauthenticated();
      return null;
    }
    await _deregisterPushForCurrentSession();
    if (!_valid(generation)) return role;
    state = const AuthState.loading();
    await _tokenStorage.clearSessionForRole(role);
    await _restore(generation);
    return role;
  }

  Future<void> logoutAllRoles({
    bool deregisterPush = true,
    bool showLoading = true,
  }) async {
    final generation = ++_generation;
    if (deregisterPush) await _deregisterPushForCurrentSession();
    if (!_valid(generation)) return;
    if (showLoading) state = const AuthState.loading();
    await _demoModeStore.clear();
    await _tokenStorage.clearAllSessions();
    if (_valid(generation)) _setUnauthenticated();
  }

  Future<String> requestPasswordReset(String identifier) =>
      _authService.requestPasswordReset(identifier);
  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) => _authService.resetPassword(token: token, newPassword: newPassword);
  Future<void> enterDemo() async {
    final generation = ++_generation;
    state = const AuthState.loading();
    try {
      final session = await _demoSessionService.openSession();
      if (!session.permissions.readOnly) {
        throw const FormatException(
          'The server did not return a read-only demo session.',
        );
      }
      if (!_valid(generation)) return;
      await _demoModeStore.enable(session);
      if (_valid(generation)) _setDemoSession(session);
    } catch (error) {
      if (_valid(generation)) {
        _setUnauthenticated(errorMessage: _friendlyLoginError(error));
      }
    }
  }

  void _setDemoSession(DemoSession session) {
    state = AuthState.authenticated(
      CurrentUser(
        id: session.user.id,
        name: session.user.name,
        email: session.user.email,
        role: UserRole.user,
        username: 'demo.fleet',
        accountStatus: 'active',
        isVerified: true,
      ),
      isDemo: true,
    );
    _mobilePushController.updateAuthenticationState(isAuthenticated: false);
    _appPreferencesCtrl.rehydrate();
  }

  void _setAuthenticated(CurrentUser user) {
    final active = _tokenStorage.cachedActiveSession;
    if (active == null ||
        active.user.id != user.id ||
        active.role != user.role) {
      _setUnauthenticated(errorMessage: 'Your session expired. Sign in again.');
      return;
    }
    _tokenStorage.publishVerifiedUser(user);
    state = AuthState.authenticated(user);
  }

  void _setUnauthenticated({String? errorMessage}) {
    if (!mounted) return;
    _tokenStorage.publishVerifiedUser(null);
    state = AuthState.unauthenticated(errorMessage: errorMessage);
    _mobilePushController.updateAuthenticationState(isAuthenticated: false);
  }

  Future<void> _deregisterPushForCurrentSession() async {
    try {
      final session = await _tokenStorage.getActiveSession();
      if (state.isDemo || session == null || session.role == UserRole.driver) {
        _mobilePushController.updateAuthenticationState(isAuthenticated: false);
        return;
      }
      await _mobilePushController.deregisterCurrentToken();
    } catch (_) {
      /* Push cleanup must not prevent signing out. */
    }
  }

  static String _friendlyLoginError(Object error) =>
      AuthApiError.message(error);
}
