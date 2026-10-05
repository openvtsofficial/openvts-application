import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../admin/models/admin_settings_model.dart';
import '../../user/models/user_settings_model.dart';
import '../../user/services/user_settings_service.dart';
import '../services/team_settings_service.dart';
import 'auth_controller.dart';
import 'security_controller.dart';

final teamSettingsControllerProvider = Provider<TeamSettingsController>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return TeamSettingsController(
    ref,
    ref.watch(teamSettingsServiceProvider),
    UserSettingsService(ref.watch(apiClientProvider)),
  );
});

class TeamSettingsData {
  const TeamSettingsData({
    this.profile,
    this.preferences,
    this.countries,
    this.dateFormats,
    this.timezones,
    this.errors = const [],
  });

  final Map<String, dynamic>? profile;
  final AdminLocalizationSettings? preferences;
  final List<UserCountryOption>? countries;
  final List<UserDateFormatOption>? dateFormats;
  final List<String>? timezones;
  final List<String> errors;
}

/// Network actions for Team's personal Settings; forms retain their draft state.
class TeamSettingsController {
  TeamSettingsController(this._ref, this._service, this._references);

  final Ref _ref;
  final TeamSettingsService _service;
  final UserSettingsService _references;

  Future<TeamSettingsData> load() async {
    final errors = <String>[];
    Future<T?> attempt<T>(Future<T> request) async {
      try {
        return await request;
      } catch (error) {
        errors.add(SecurityController.errorMessage(error));
        return null;
      }
    }

    // A public catalog outage must not clear valid account data, and an
    // unavailable profile must never become an editable empty replacement.
    final result = await Future.wait<Object?>([
      attempt(_service.profile()),
      attempt(_service.localization()),
      attempt(_references.getCountries()),
      attempt(_references.getDateFormats()),
      attempt(_references.getTimezones()),
    ]);
    return TeamSettingsData(
      profile: result[0] as Map<String, dynamic>?,
      preferences: result[1] == null
          ? null
          : AdminLocalizationSettings.fromJson(result[1]),
      countries: result[2] as List<UserCountryOption>?,
      dateFormats: result[3] as List<UserDateFormatOption>?,
      timezones: result[4] as List<String>?,
      errors: errors,
    );
  }

  Future<({List<UserStateOption> states, List<UserCityOption> cities})>
  loadAddress(String country, String state) async {
    final states = await _references.getStates(country);
    final cities = await _references.getCities(country, state);
    return (states: states, cities: cities);
  }

  Future<void> saveProfile(Map<String, dynamic> values) async {
    await _service.saveProfile(values);
    final user = _ref.read(authControllerProvider).user;
    if (user != null) {
      final refreshed = await _ref.read(authServiceProvider).getProfile(user);
      await _ref
          .read(authControllerProvider.notifier)
          .replaceCurrentUser(refreshed);
    }
  }

  Future<void> savePreferences(AdminLocalizationSettings preferences) async {
    await _service.saveLocalization({
      'language': preferences.language,
      'layoutDirection': preferences.layoutDirection.apiValue,
      'dateFormat': preferences.dateFormat,
      'use24Hour': preferences.use24Hour,
      'theme': preferences.theme.apiValue,
      'timezoneOffset': preferences.timezoneOffset,
      'units': preferences.units.apiValue,
    });
    await _ref
        .read(appLocalizationPreferencesProvider.notifier)
        .applyFromUserSettings(
          languageCode: preferences.language,
          dateFormat: preferences.dateFormat,
          timeFormat: preferences.use24Hour ? '24H' : '12H',
          theme: preferences.theme.apiValue,
          timezone: preferences.timezoneOffset,
          layoutDirection: preferences.layoutDirection.apiValue,
          units: preferences.units.apiValue,
        );
  }

  Future<void> changePassword(Map<String, String> values) async {
    await _service.changePassword(values);
    await _ref.read(authControllerProvider.notifier).logoutActiveRole();
  }
}
