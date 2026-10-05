import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';

// No initializeDateFormatting here: profile providers and standalone widgets
// can format values before Material's locale delegate has loaded symbol data.
void main() {
  test(
    'display formatting has a safe built-in locale before delegates load',
    () {
      final date = DateTime(2026, 10, 5, 15, 45);
      updateGlobalDateFormatConfig(
        datePattern: 'DD MMM YYYY',
        use24Hour: false,
        locale: 'xx',
      );
      addTearDown(
        () => updateGlobalDateFormatConfig(
          datePattern: 'DD MMM YYYY',
          use24Hour: false,
        ),
      );
      const legacy = DateTimeFormatter();
      const scoped = AppDateFormatter(
        datePattern: 'DD MMM YYYY',
        use24Hour: false,
        locale: 'xx',
      );
      expect(legacy.formatDate(date), '05 Oct 2026');
      expect(legacy.formatDateTime(date), '05 Oct 2026, 03:45 PM');
      expect(legacy.formatTime(date), '03:45 PM');
      expect(scoped.formatDate(date), '05 Oct 2026');
      expect(scoped.formatDateTime(date), '05 Oct 2026, 03:45 PM');
      expect(scoped.formatTime(date), '03:45 PM');
    },
  );
}
