import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../services/auth_service.dart';
import '../services/driver_settings_service.dart';
import 'auth_controller.dart';
import 'security_controller.dart';

final driverSettingsControllerProvider =
    StateNotifierProvider.autoDispose<
      DriverSettingsController,
      DriverSettingsState
    >((ref) {
      ref.watch(workspaceDataScopeProvider);
      return DriverSettingsController(
        DriverSettingsService(ref.watch(apiClientProvider)),
        ref.watch(authServiceProvider),
        ref.watch(authControllerProvider.notifier),
        ref.watch(appLocalizationPreferencesProvider.notifier),
      );
    });

class DriverSettingsState {
  const DriverSettingsState({
    this.profile,
    this.settings,
    this.loading = false,
    this.error,
  });
  final Map<String, dynamic>? profile, settings;
  final bool loading;
  final String? error;
}

class DriverSettingsController extends StateNotifier<DriverSettingsState> {
  DriverSettingsController(
    this._service,
    this._profiles,
    this._auth,
    this._preferences,
  ) : super(const DriverSettingsState());
  final DriverSettingsService _service;
  final AuthService _profiles;
  final AuthController _auth;
  final AppLocalizationPreferencesController _preferences;
  Future<void> load() async {
    state = const DriverSettingsState(loading: true);
    try {
      final results = await Future.wait([
        _service.profile(),
        _service.settings(),
      ]);
      if (mounted) {
        state = DriverSettingsState(profile: results[0], settings: results[1]);
      }
    } catch (error) {
      if (mounted) {
        state = DriverSettingsState(
          error: SecurityController.errorMessage(error),
        );
      }
    }
  }

  Future<void> saveProfile(Map<String, dynamic> values) async {
    await _service.saveProfile(values);
    final user = _auth.currentUser;
    if (user != null) {
      await _auth.replaceCurrentUser(await _profiles.getProfile(user));
    }
  }

  Future<void> saveSettings(Map<String, dynamic> values) async {
    await _service.saveSettings(values);
    await _preferences.applyFromUserSettings(
      languageCode: values['languageCode'] as String,
      dateFormat: values['dateFormat'] as String,
      timeFormat: values['timeFormat'] as String,
      theme: values['theme'] as String,
      timezone: values['timezone'] as String,
      layoutDirection: values['direction'] as String,
      units: values['distanceUnit'] as String,
    );
  }

  Future<void> changePassword(Map<String, String> values) async {
    await _service.changePassword(values);
    await _auth.logoutActiveRole();
  }
}
