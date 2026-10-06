import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  test(
    'tracking display uses device timezone and ignores saved scheduling offset',
    () {
      final instant = DateTime.parse('2026-01-01T23:45:06Z');
      final expected = DateFormat(
        'yyyy-MM-dd, HH:mm',
        'en',
      ).format(instant.toLocal());
      for (final savedTimezone in [
        '',
        '+05:30',
        '-08:00',
        'America/New_York',
      ]) {
        final formatter = AppDateFormatter(
          datePattern: 'YYYY-MM-DD',
          use24Hour: true,
          timezone: savedTimezone,
        );
        expect(formatter.formatDateTime(instant), expected);
        expect(formatter.formatDateTime(instant.toLocal()), expected);
        expect(
          formatter.formatTimeWithSeconds(instant),
          DateFormat('HH:mm:ss', 'en').format(instant.toLocal()),
        );
      }
      expect(instant.toIso8601String(), '2026-01-01T23:45:06.000Z');
    },
  );

  test(
    '12/24h log seconds retain selected language and safe null behavior',
    () {
      final instant = DateTime(2026, 10, 6, 15, 12, 37);
      const twelve = AppDateFormatter(
        datePattern: 'DD MMM YYYY',
        use24Hour: false,
      );
      const twentyFour = AppDateFormatter(
        datePattern: 'DD MMM YYYY',
        use24Hour: true,
        locale: 'fr',
      );
      expect(twelve.formatTimeWithSeconds(instant), '03:12:37 PM');
      expect(twentyFour.formatTimeWithSeconds(instant), '15:12:37');
      expect(
        twentyFour.formatDateTimeWithSeconds(instant),
        '06 oct. 2026, 15:12:37',
      );
      expect(twentyFour.formatTimeWithSeconds(null), isEmpty);
      expect(twentyFour.formatDateTimeWithSeconds(null), isEmpty);
    },
  );

  test('web date aliases and weekday tokens format consistently', () {
    final instant = DateTime(2026, 10, 6, 15, 12, 37);
    expect(
      const AppDateFormatter(
        datePattern: 'YYYY_MM_DD',
        use24Hour: true,
      ).formatDate(instant),
      '2026-10-06',
    );
    expect(
      const AppDateFormatter(
        datePattern: 'DD_MMM_YYYY',
        use24Hour: true,
      ).formatDate(instant),
      '06 Oct 2026',
    );
    expect(
      const AppDateFormatter(
        datePattern: 'dddd, DD MMM YYYY',
        use24Hour: true,
      ).formatDate(instant),
      'Tuesday, 06 Oct 2026',
    );
  });
}
