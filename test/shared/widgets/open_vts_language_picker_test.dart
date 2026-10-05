import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/providers/app_preferences_provider.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/providers/shared_preferences_provider.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_language_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'device language changes immediately, persists, and survives server hydration',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cache = LocalCache(prefs);
      final theme = ThemeModeController(cache);
      final controller = AppLocalizationPreferencesController(cache, theme);
      addTearDown(controller.dispose);
      addTearDown(theme.dispose);

      final pending = controller.selectLanguage('ar');
      expect(controller.state.languageCode, 'ar');
      expect(controller.state.textDirection, TextDirection.rtl);
      await pending;
      expect(prefs.getString(StorageKeys.appLanguageOverride), 'ar');

      await controller.applyFromUserSettings(
        languageCode: 'en',
        dateFormat: 'YYYY-MM-DD',
        timeFormat: '24H',
        theme: 'DARK',
        timezone: '+05:30',
        preserveAppLanguage: true,
      );
      expect(controller.state.languageCode, 'ar');
      expect(controller.state.textDirection, TextDirection.rtl);
      expect(controller.state.dateFormat, 'YYYY-MM-DD');
      expect(controller.state.themeMode, ThemeMode.dark);
      final restored = AppLocalizationPreferencesController(cache, theme);
      addTearDown(restored.dispose);
      expect(restored.state.languageCode, 'ar');
      expect(restored.state.textDirection, TextDirection.rtl);

      await controller.selectLanguage('fr');
      expect(controller.state.textDirection, TextDirection.ltr);
      expect(prefs.getString(StorageKeys.appLanguageCode), 'fr');
    },
  );

  test(
    'explicit Settings save updates an existing device language override',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cache = LocalCache(prefs);
      final theme = ThemeModeController(cache);
      final controller = AppLocalizationPreferencesController(cache, theme);
      addTearDown(controller.dispose);
      addTearDown(theme.dispose);
      await controller.selectLanguage('ar');
      await controller.applyFromAdminSettings(
        language: 'French',
        dateFormat: 'DD/MM/YYYY',
        use24Hour: true,
        theme: 'SYSTEM',
        timezoneOffset: '+00:00',
      );
      expect(controller.state.languageCode, 'fr');
      expect(prefs.getString(StorageKeys.appLanguageOverride), 'fr');
      expect(controller.state.textDirection, TextDirection.ltr);
      await controller.resetToDefaults();
      expect(prefs.getString(StorageKeys.appLanguageOverride), isNull);
    },
  );

  testWidgets(
    'picker offers every supported locale and updates app labels without APIs',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(appLocalizationPreferencesProvider);
              return MaterialApp(
                locale: Locale(state.languageCode),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) => Directionality(
                  textDirection: state.textDirection,
                  child: child!,
                ),
                home: Builder(
                  builder: (context) => Scaffold(
                    body: TextButton(
                      key: const ValueKey('open-languages'),
                      onPressed: () => showOpenVtsLanguagePicker(context),
                      child: Text(AppLocalizations.of(context).settings),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.tap(find.byKey(const ValueKey('open-languages')));
        await tester.pumpAndSettle();
        final choice = find.byKey(ValueKey('language-${locale.languageCode}'));
        await tester.ensureVisible(choice);
        expect(find.text(appLanguageNativeName(locale)), findsOneWidget);
        await tester.tap(choice);
        await tester.pumpAndSettle();
        expect(
          container.read(appLocalizationPreferencesProvider).languageCode,
          locale.languageCode,
        );
        expect(
          prefs.getString(StorageKeys.appLanguageCode),
          locale.languageCode,
        );
        final context = tester.element(
          find.byKey(const ValueKey('open-languages')),
        );
        expect(
          Directionality.of(context),
          locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(
          find.text(AppLocalizations.of(context).settings),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }
    },
  );
}
