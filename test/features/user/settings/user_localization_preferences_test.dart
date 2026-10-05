import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/providers/app_preferences_provider.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/features/user/controllers/user_settings_controller.dart';
import 'package:open_vts/features/user/models/user_settings_model.dart';
import 'package:open_vts/features/user/services/user_settings_service.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _LanguageSettingsService implements UserSettingsService {
  @override
  Future<UserLocalizationSettings> getLocalization() async =>
      const UserLocalizationSettings(language: 'en', timezoneOffset: '+05:30');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'localization form preserves the language chosen from the home header',
    () async {
      final controller = UserSettingsController(
        service: _LanguageSettingsService(),
        languageOverride: () => const AppLocalizationPreferences(
          languageCode: 'ar',
          layoutDirection: 'RTL',
        ),
      );
      addTearDown(controller.dispose);
      await controller.loadLocalization();
      expect(controller.state.localization!.language, 'ar');
      expect(controller.state.draftLocalization!.language, 'ar');
      expect(
        controller.state.draftLocalization!.layoutDirection,
        UserLayoutDirection.rtl,
      );
      expect(controller.state.draftLocalization!.timezoneOffset, '+05:30');
      expect(controller.state.isLocalizationDirty, isFalse);
    },
  );

  test('Flutter locale catalog is the authoritative supported set', () {
    expect(
      flutterSupportedLanguageCodes,
      AppLocalizations.supportedLocales
          .map((locale) => locale.languageCode)
          .toSet(),
    );
    for (final code in const ['en', 'hi', 'ar', 'es', 'fr', 'pt']) {
      expect(isFlutterLanguageSupported(code), isTrue);
    }
    expect(isFlutterLanguageSupported('de'), isFalse);
    expect(isFlutterLanguageSupported('ru'), isFalse);
  });

  test('regional codes resolve for Flutter without changing backend value', () {
    expect(flutterLanguageCodeFor('pt-BR'), 'pt');
    expect(flutterLanguageCodeFor('pt_PT'), 'pt');
    expect(flutterLanguageCodeFor('de-DE'), 'en');
  });

  test('user locale applies, persists, and rehydrates canonically', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final cache = LocalCache(preferences);
    final controller = AppLocalizationPreferencesController(
      cache,
      ThemeModeController(cache),
    );

    await controller.applyFromUserSettings(
      languageCode: 'pt-BR',
      dateFormat: 'DD/MM/YYYY',
      timeFormat: '24H',
      theme: 'SYSTEM',
      timezone: '-03:00',
    );

    expect(controller.state.languageCode, 'pt');
    expect(preferences.getString(StorageKeys.appLanguageCode), 'pt');

    final rehydrated = AppLocalizationPreferencesController(
      cache,
      ThemeModeController(cache),
    );
    expect(rehydrated.state.languageCode, 'pt');
  });

  test('unsupported cached locale cannot silently remain selected', () async {
    SharedPreferences.setMockInitialValues({StorageKeys.appLanguageCode: 'ru'});
    final preferences = await SharedPreferences.getInstance();
    final cache = LocalCache(preferences);

    final controller = AppLocalizationPreferencesController(
      cache,
      ThemeModeController(cache),
    );

    expect(controller.state.languageCode, 'en');
  });
}
