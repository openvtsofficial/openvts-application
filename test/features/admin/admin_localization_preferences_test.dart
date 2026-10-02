import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/providers/app_preferences_provider.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('admin localization applies canonical values and persists them',
      () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final cache = LocalCache(preferences);
    final controller = AppLocalizationPreferencesController(
      cache,
      ThemeModeController(cache),
    );

    await controller.applyFromAdminSettings(
      language: 'Arabic',
      dateFormat: 'DD/MM/YYYY',
      use24Hour: true,
      theme: 'DARK',
      timezoneOffset: '+04:00',
      layoutDirection: 'RTL',
      units: 'MILES',
    );

    expect(controller.state.languageCode, 'ar');
    expect(controller.state.textDirection, TextDirection.rtl);
    expect(controller.state.themeMode, ThemeMode.dark);
    expect(preferences.getString(StorageKeys.appLanguageCode), 'ar');
    expect(preferences.getString(StorageKeys.appLayoutDirection), 'RTL');

    final rehydrated = AppLocalizationPreferencesController(
      cache,
      ThemeModeController(cache),
    );
    expect(rehydrated.state.languageCode, 'ar');
    expect(rehydrated.state.textDirection, TextDirection.rtl);
  });

  testWidgets('all supported locales switch labels and Arabic is RTL',
      (tester) async {
    for (final code in const ['en', 'hi', 'ar', 'es', 'fr', 'pt']) {
      late AppLocalizations strings;
      late TextDirection direction;
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              strings = AppLocalizations.of(context);
              direction = Directionality.of(context);
              return Text(strings.settings);
            },
          ),
        ),
      );

      expect(find.text(strings.settings), findsOneWidget);
      expect(direction, code == 'ar' ? TextDirection.rtl : TextDirection.ltr);
      if (code != 'en') expect(strings.settings, isNot('Settings'));
    }
  });
}
