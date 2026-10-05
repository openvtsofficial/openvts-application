import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_vts/core/providers/app_preferences_provider.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => initializeDateFormatting());
  tearDown(
    () => updateGlobalDateFormatConfig(
      datePattern: 'DD MMM YYYY',
      use24Hour: false,
    ),
  );

  test(
    'existing display formatter follows language selection without changing wire-format locale',
    () async {
      SharedPreferences.setMockInitialValues({});
      final cache = LocalCache(await SharedPreferences.getInstance());
      final theme = ThemeModeController(cache);
      final preferences = AppLocalizationPreferencesController(cache, theme);
      addTearDown(preferences.dispose);
      addTearDown(theme.dispose);
      final previousIntlLocale = Intl.defaultLocale;
      const formatter = DateTimeFormatter();
      final date = DateTime(2026, 10, 5, 15, 45);
      await preferences.apply(dateFormat: 'DD MMMM YYYY');
      expect(formatter.formatDate(date), '05 October 2026');
      await preferences.selectLanguage('fr');
      expect(formatter.formatDate(date), '05 octobre 2026');
      await preferences.selectLanguage('pt');
      expect(formatter.formatDate(date), '05 outubro 2026');
      await preferences.selectLanguage('ar');
      expect(formatter.formatDate(date), contains('أكتوبر'));
      expect(Intl.defaultLocale, previousIntlLocale);
      expect(DateFormat('yyyy-MM-dd', 'en').format(date), '2026-10-05');
      await preferences.resetToDefaults();
      expect(formatter.formatDate(date), '05 Oct 2026');
    },
  );

  test(
    'provider-aware display dates and relative times use their explicit locale',
    () {
      const french = AppDateFormatter(
        datePattern: 'DD MMMM YYYY',
        use24Hour: true,
        locale: 'fr',
      );
      const portuguese = AppDateFormatter(
        datePattern: 'DD MMMM YYYY',
        use24Hour: true,
        locale: 'pt',
      );
      final date = DateTime(2026, 10, 5, 15, 45);
      expect(french.formatDateTime(date), '05 octobre 2026, 15:45');
      expect(portuguese.formatDate(date), '05 outubro 2026');
      expect(french.formatRelativeOrDate(DateTime.now()), isNot('just now'));
      expect(
        portuguese.formatRelativeOrDate(
          DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        contains('2'),
      );
      expect(
        portuguese.formatRelativeOrDate(
          DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        isNot(contains('ago')),
      );
    },
  );
}
