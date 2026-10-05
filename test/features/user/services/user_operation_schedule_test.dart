import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_operation_schedule.dart';

void main() {
  Map<String, dynamic> plan({
    String type = 'DATE_ONLY',
    bool recurring = false,
    DateTime? end,
    List<String> skips = const [],
    int? version,
    Set<int> weekdays = const {1, 3, 5},
    String start = '09:00',
    String finish = '17:00',
  }) => operationSchedulePayload(
    title: ' Morning delivery ',
    remark: 'Driver note',
    vehicleId: 4,
    routeId: 52,
    recurring: recurring,
    scheduleType: type,
    date: DateTime(2026, 10, 12),
    endDate: end,
    startTime: start,
    endTime: finish,
    weekdays: weekdays,
    exceptionDates: skips,
    version: version,
  );

  test(
    'One-day payload drops hidden times and end date after mode changes',
    () {
      final payload = plan(end: DateTime(2026, 10, 15));
      expect(payload, {
        'title': 'Morning delivery',
        'remark': 'Driver note',
        'vehicleId': 4,
        'routeId': 52,
        'scheduleType': 'DATE_ONLY',
        'date': '2026-10-12',
      });
      final fixed = plan(type: 'FIXED_TIME', end: DateTime(2026, 10, 15));
      expect(fixed['startTime'], '09:00');
      expect(fixed.containsKey('endDate'), false);
      expect(fixed.containsKey('endTime'), false);
    },
  );
  test('Time windows and multi-day completion enforce strict ordering', () {
    expect(
      () => plan(type: 'TIME_SLOT', finish: '08:59'),
      throwsFormatException,
    );
    expect(
      () => plan(type: 'TIME_SLOT', finish: '09:00'),
      throwsFormatException,
    );
    expect(() => plan(type: 'MULTI_DAY'), throwsFormatException);
    expect(
      () =>
          plan(type: 'MULTI_DAY', end: DateTime(2026, 10, 12), finish: '08:00'),
      throwsFormatException,
    );
    expect(
      plan(
        type: 'MULTI_DAY',
        end: DateTime(2026, 10, 13),
        finish: '08:00',
      )['endDate'],
      '2026-10-13',
    );
  });
  test(
    'Recurring edits preserve revision, clear end date, reject invalid skip dates',
    () {
      final result = plan(
        type: 'FIXED_TIME',
        recurring: true,
        version: 7,
        skips: ['2026-10-19', '2026-10-12', '2026-10-19'],
      );
      expect(result['version'], 7);
      expect(result['endDate'], isNull);
      expect(result.containsKey('endDate'), true);
      expect(result['exceptionDates'], ['2026-10-12', '2026-10-19']);
      expect(
        () => plan(type: 'FIXED_TIME', recurring: true, skips: ['2026-10-11']),
        throwsFormatException,
      );
      expect(
        () => plan(
          type: 'FIXED_TIME',
          recurring: true,
          end: DateTime(2026, 10, 20),
          skips: ['2026-10-21'],
        ),
        throwsFormatException,
      );
      expect(
        () => plan(type: 'FIXED_TIME', recurring: true, skips: ['2026-02-31']),
        throwsFormatException,
      );
      expect(
        () => plan(type: 'FIXED_TIME', recurring: true, weekdays: {}),
        throwsFormatException,
      );
    },
  );
  test(
    'Account date follows server timezone across midnight and daylight saving',
    () {
      final instant = DateTime.utc(2026, 10, 5, 0, 15);
      expect(
        operationIsoDay(
          operationAccountNow('America/Los_Angeles', instant: instant),
        ),
        '2026-10-04',
      );
      expect(
        operationIsoDay(operationAccountNow('Asia/Kolkata', instant: instant)),
        '2026-10-05',
      );
      expect(
        operationAccountNow(
          'America/New_York',
          instant: DateTime.utc(2026, 11, 1, 5, 30),
        ).hour,
        1,
      );
      expect(
        operationAccountNow(
          'America/New_York',
          instant: DateTime.utc(2026, 11, 1, 6, 30),
        ).hour,
        1,
      );
      expect(
        operationAccountNow('invalid/server-zone', instant: instant).isUtc,
        true,
      );
    },
  );
}
