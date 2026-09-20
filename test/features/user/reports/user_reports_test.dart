// Comprehensive unit tests for the Reports feature.
// Covers: user_report_format.dart, user_report_validation.dart,
//         user_report_model.dart, user_report_state.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_report_model.dart';
import 'package:open_vts/features/user/models/user_report_state.dart';
import 'package:open_vts/features/user/services/user_report_export_service.dart';
import 'package:open_vts/features/user/utils/user_report_format.dart';
import 'package:open_vts/features/user/utils/user_report_validation.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 1. formatDurationSeconds
  // ---------------------------------------------------------------------------

  group('formatDurationSeconds', () {
    test('returns 0m for 0 seconds', () {
      expect(formatDurationSeconds(0), '0m');
    });

    test('returns 0m for negative values', () {
      expect(formatDurationSeconds(-100), '0m');
    });

    test('minutes only: 300s → 5m', () {
      expect(formatDurationSeconds(300), '5m');
    });

    test('hours and minutes: 3660s → 1h 1m', () {
      expect(formatDurationSeconds(3660), '1h 1m');
    });

    test('days hours minutes: 90060s → 1d 1h 1m', () {
      // 1d = 86400, 1h = 3600, 1m = 60  → 90060
      expect(formatDurationSeconds(90060), '1d 1h 1m');
    });

    test('exactly one hour with no trailing 0m: 7200s → 2h', () {
      expect(formatDurationSeconds(7200), '2h');
    });

    test('exactly one day: 86400s → 1d', () {
      expect(formatDurationSeconds(86400), '1d');
    });

    test('large value: 3d 5h 22m', () {
      // 3d*86400 + 5h*3600 + 22m*60 = 259200 + 18000 + 1320 = 278520
      expect(formatDurationSeconds(278520), '3d 5h 22m');
    });

    test('returns 0m for NaN', () {
      expect(formatDurationSeconds(double.nan), '0m');
    });

    test('returns 0m for positive infinity', () {
      expect(formatDurationSeconds(double.infinity), '0m');
    });
  });

  // ---------------------------------------------------------------------------
  // 2. formatCoordinate
  // ---------------------------------------------------------------------------

  group('formatCoordinate', () {
    test('formats to 5 decimal places', () {
      expect(formatCoordinate(28.6139, 77.209), '28.61390, 77.20900');
    });

    test('handles negative coordinates', () {
      expect(formatCoordinate(-33.8688, 151.2093), '-33.86880, 151.20930');
    });

    test('returns em-dash for null lat', () {
      expect(formatCoordinate(null, 77.2), '—');
    });

    test('returns em-dash for null lon', () {
      expect(formatCoordinate(28.61, null), '—');
    });

    test('returns em-dash for both null', () {
      expect(formatCoordinate(null, null), '—');
    });
  });

  group('resolveOverspeedLocation', () {
    test('prefers and trims an API-provided address', () {
      expect(resolveOverspeedLocation('  Highway 1  ', 28.6139, 77.209),
          'Highway 1');
    });

    test('uses formatted coordinates for empty and whitespace addresses', () {
      expect(
          resolveOverspeedLocation('', 28.6139, 77.209), '28.61390, 77.20900');
      expect(resolveOverspeedLocation('   ', 28.6139, 77.209),
          '28.61390, 77.20900');
    });

    test('uses a dash when no complete coordinates are available', () {
      expect(resolveOverspeedLocation(null, null, 77.209), '-');
      expect(resolveOverspeedLocation(null, 28.6139, null), '-');
    });
  });

  group('overspeed export location normalization', () {
    test('uses one address value for CSV, XLSX, JSON, PDF, and HTML inputs',
        () {
      final rows = normalizeUserReportRowsForExport(
        UserReportKey.overspeed,
        <Map<String, dynamic>>[
          {'address': 'Ring Road', 'lat': 1.0, 'lon': 2.0},
          {'address': '', 'lat': 28.6139, 'lon': 77.209},
          {'address': '   ', 'lat': 12.3, 'lon': 45.6},
          {'address': null, 'lat': null, 'lon': null},
        ],
      );

      expect(rows.map((row) => row['address']), <String>[
        'Ring Road',
        '28.61390, 77.20900',
        '12.30000, 45.60000',
        '-',
      ]);
      expect(rows[1]['lat'], 28.6139);
      expect(rows[1]['lon'], 77.209);
    });
  });

  // ---------------------------------------------------------------------------
  // 3. getDateRangeDays
  // ---------------------------------------------------------------------------

  group('getDateRangeDays', () {
    test('single day returns list with one entry', () {
      final days = getDateRangeDays('2026-07-10', '2026-07-10');
      expect(days, ['2026-07-10']);
    });

    test('inclusive 3-day range', () {
      final days = getDateRangeDays('2026-07-10', '2026-07-12');
      expect(days.length, 3);
      expect(days.first, '2026-07-10');
      expect(days.last, '2026-07-12');
    });

    test('month boundary: 2026-07-30 to 2026-08-02 → 4 days', () {
      final days = getDateRangeDays('2026-07-30', '2026-08-02');
      expect(days.length, 4);
      expect(
          days,
          containsAllInOrder(
              ['2026-07-30', '2026-07-31', '2026-08-01', '2026-08-02']));
    });

    test('year boundary: 2025-12-30 to 2026-01-02 → 4 days', () {
      final days = getDateRangeDays('2025-12-30', '2026-01-02');
      expect(days.length, 4);
      expect(days.first, '2025-12-30');
      expect(days.last, '2026-01-02');
    });

    test('start after end returns empty list', () {
      final days = getDateRangeDays('2026-07-15', '2026-07-10');
      expect(days, isEmpty);
    });

    test('Feb non-leap: 2025-02-26 to 2025-03-02 → 5 days', () {
      final days = getDateRangeDays('2025-02-26', '2025-03-02');
      expect(days.length, 5);
    });

    test('Feb leap: 2028-02-28 to 2028-03-01 → 3 days (includes Feb 29)', () {
      final days = getDateRangeDays('2028-02-28', '2028-03-01');
      expect(days.length, 3);
      expect(
          days, containsAllInOrder(['2028-02-28', '2028-02-29', '2028-03-01']));
    });
  });

  // ---------------------------------------------------------------------------
  // 4. getOverspeedSeverity
  // ---------------------------------------------------------------------------

  group('getOverspeedSeverity', () {
    test('excessKmh=30 → critical', () {
      expect(getOverspeedSeverity(30), OverspeedSeverity.critical);
    });

    test('excessKmh=50 → critical', () {
      expect(getOverspeedSeverity(50), OverspeedSeverity.critical);
    });

    test('excessKmh=20 → high', () {
      expect(getOverspeedSeverity(20), OverspeedSeverity.high);
    });

    test('excessKmh=25 → high', () {
      expect(getOverspeedSeverity(25), OverspeedSeverity.high);
    });

    test('excessKmh=10 → medium', () {
      expect(getOverspeedSeverity(10), OverspeedSeverity.medium);
    });

    test('excessKmh=9.9 → low', () {
      expect(getOverspeedSeverity(9.9), OverspeedSeverity.low);
    });

    test('excessKmh=0 → low', () {
      expect(getOverspeedSeverity(0), OverspeedSeverity.low);
    });
  });

  // ---------------------------------------------------------------------------
  // 5. validateSpeedLimit
  // ---------------------------------------------------------------------------

  group('validateSpeedLimit', () {
    test('"120" → 120', () {
      expect(validateSpeedLimit('120'), 120);
    });

    test('"  80  " → 80 (trims whitespace)', () {
      expect(validateSpeedLimit('  80  '), 80);
    });

    test('empty string → null', () {
      expect(validateSpeedLimit(''), isNull);
    });

    test('"abc" → null', () {
      expect(validateSpeedLimit('abc'), isNull);
    });

    test('"9" → null (below min 10)', () {
      expect(validateSpeedLimit('9'), isNull);
    });

    test('"301" → null (above max 300)', () {
      expect(validateSpeedLimit('301'), isNull);
    });

    test('"10" → 10 (exactly at min)', () {
      expect(validateSpeedLimit('10'), 10);
    });

    test('"300" → 300 (exactly at max)', () {
      expect(validateSpeedLimit('300'), 300);
    });
  });

  // ---------------------------------------------------------------------------
  // 6. truncatePayload
  // ---------------------------------------------------------------------------

  group('truncatePayload', () {
    test('short payload returned unchanged, truncated=false', () {
      final result = truncatePayload('hello world');
      expect(result.text, 'hello world');
      expect(result.truncated, isFalse);
    });

    test('long payload is cut to maxLength, truncated=true', () {
      final longPayload = 'x' * 3000;
      final result = truncatePayload(longPayload, maxLength: 2000);
      expect(result.text.length, 2000);
      expect(result.truncated, isTrue);
    });

    test('null payload → empty string, truncated=false', () {
      final result = truncatePayload(null);
      expect(result.text, '');
      expect(result.truncated, isFalse);
    });

    test('empty string → empty string, truncated=false', () {
      final result = truncatePayload('');
      expect(result.text, '');
      expect(result.truncated, isFalse);
    });

    test('payload exactly at maxLength → not truncated', () {
      final payload = 'a' * 100;
      final result = truncatePayload(payload, maxLength: 100);
      expect(result.truncated, isFalse);
      expect(result.text.length, 100);
    });

    test('payload one over maxLength → truncated', () {
      final payload = 'a' * 101;
      final result = truncatePayload(payload, maxLength: 100);
      expect(result.truncated, isTrue);
      expect(result.text.length, 100);
    });
  });

  // ---------------------------------------------------------------------------
  // 7. downsampleLTTB
  // ---------------------------------------------------------------------------

  group('downsampleLTTB', () {
    List<_Point> makePoints(int n) => [
          for (var i = 0; i < n; i++) _Point(i.toDouble(), (i % 10).toDouble()),
        ];

    test('input ≤ maxPoints returns the same list', () {
      final data = makePoints(5);
      final result = downsampleLTTB(
        data: data,
        maxPoints: 10,
        getX: (p) => p.x,
        getY: (p) => p.y,
      );
      expect(result, same(data));
    });

    test('large list returns exactly maxPoints points', () {
      final data = makePoints(500);
      final result = downsampleLTTB(
        data: data,
        maxPoints: 50,
        getX: (p) => p.x,
        getY: (p) => p.y,
      );
      expect(result.length, 50);
    });

    test('always includes first and last points', () {
      final data = makePoints(200);
      final result = downsampleLTTB(
        data: data,
        maxPoints: 20,
        getX: (p) => p.x,
        getY: (p) => p.y,
      );
      expect(result.first, data.first);
      expect(result.last, data.last);
    });

    test('returns original list when maxPoints < 3', () {
      final data = makePoints(100);
      final result = downsampleLTTB(
        data: data,
        maxPoints: 2,
        getX: (p) => p.x,
        getY: (p) => p.y,
      );
      expect(result, same(data));
    });
  });

  // ---------------------------------------------------------------------------
  // 8. validateReportQuery
  // ---------------------------------------------------------------------------

  group('validateReportQuery', () {
    const validDateRange = ReportDateRange.dateOnly(
      startDate: '2026-07-01',
      endDate: '2026-07-05',
    );

    test('all scope valid → no errors', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.distance,
        scope: const ReportVehicleScope.all(),
        dateRange: validDateRange,
        overspeedFilters: const OverspeedFilters(speedLimitKmh: 80),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, isEmpty);
    });

    test('single-vehicle report (sensor) with multi scope → error on vehicle',
        () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.sensor,
        scope: const ReportVehicleScope.all(),
        dateRange: validDateRange,
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(sensorIds: ['s1']),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('sensorVehicle', isNotEmpty));
    });

    test('single-vehicle report with correct single scope → no vehicle error',
        () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.sensor,
        scope: const ReportVehicleScope.single('v1'),
        dateRange: validDateRange,
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(sensorIds: ['s1']),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors.containsKey('sensorVehicle'), isFalse);
    });

    test('sensor report with empty sensorIds → error on sensor', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.sensor,
        scope: const ReportVehicleScope.single('v1'),
        dateRange: validDateRange,
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(sensorIds: []),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('sensorSensor', isNotEmpty));
    });

    test('empty start date → error on startDate', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.distance,
        scope: const ReportVehicleScope.all(),
        dateRange: const ReportDateRange.dateOnly(
            startDate: '', endDate: '2026-07-05'),
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('startDate', isNotEmpty));
    });

    test('start > end date → error on startDate', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.distance,
        scope: const ReportVehicleScope.all(),
        dateRange: const ReportDateRange.dateOnly(
          startDate: '2026-07-10',
          endDate: '2026-07-05',
        ),
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('startDate', isNotEmpty));
    });

    test('range too long for distance (>31 days) → error on dateRange', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.distance,
        scope: const ReportVehicleScope.all(),
        dateRange: const ReportDateRange.dateOnly(
          startDate: '2026-06-01',
          endDate: '2026-07-15', // 45 days
        ),
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('dateRange', isNotEmpty));
    });

    test('range too long for overspeed (>7 days) → error on dateRange', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.overspeed,
        scope: const ReportVehicleScope.all(),
        dateRange: const ReportDateRange.dateOnly(
          startDate: '2026-07-01',
          endDate: '2026-07-10', // 10 days
        ),
        overspeedFilters: const OverspeedFilters(speedLimitKmh: 80),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('dateRange', isNotEmpty));
    });

    test('timeline with empty states → error on timelineState', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.timeline,
        scope: const ReportVehicleScope.single('v1'),
        dateRange: const ReportDateRange.dateOnly(
          startDate: '2026-07-01',
          endDate: '2026-07-03',
        ),
        overspeedFilters: const OverspeedFilters(),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: []),
      );
      expect(errors, containsPair('timelineState', isNotEmpty));
    });

    test('overspeed with speed limit < 10 → error on speedLimit', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.overspeed,
        scope: const ReportVehicleScope.all(),
        dateRange: const ReportDateRange.dateOnly(
          startDate: '2026-07-01',
          endDate: '2026-07-05',
        ),
        overspeedFilters: const OverspeedFilters(speedLimitKmh: 5),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, containsPair('speedLimit', isNotEmpty));
    });

    test('valid full query → empty errors map', () {
      final errors = validateReportQuery(
        reportKey: UserReportKey.overspeed,
        scope: const ReportVehicleScope.all(),
        dateRange: const ReportDateRange.dateOnly(
          startDate: '2026-07-01',
          endDate: '2026-07-05',
        ),
        overspeedFilters: const OverspeedFilters(speedLimitKmh: 80),
        sensorFilters: const SensorFilters(),
        timelineFilters: const TimelineFilters(states: ['running']),
      );
      expect(errors, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // 9. buildDefaultDateRange
  // ---------------------------------------------------------------------------

  group('buildDefaultDateRange', () {
    test(
        'dateOnly key → mode == dateOnly, startDate and endDate are YYYY-MM-DD',
        () {
      final range = buildDefaultDateRange(UserReportKey.distance);
      expect(range.mode, 'dateOnly');
      expect(range.startDate, matches(r'^\d{4}-\d{2}-\d{2}$'));
      expect(range.endDate, matches(r'^\d{4}-\d{2}-\d{2}$'));
    });

    test('dateTime key → mode == dateTime, fromISO and toISO contain T', () {
      final range = buildDefaultDateRange(UserReportKey.driven);
      expect(range.mode, 'dateTime');
      expect(range.fromISO, contains('T'));
      expect(range.toISO, contains('T'));
    });

    test('default dateOnly → startDate equals today', () {
      final now = DateTime.now();
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final range = buildDefaultDateRange(UserReportKey.distance);
      expect(range.startDate, today);
      expect(range.endDate, today);
    });

    test('timeline key uses dateOnly mode', () {
      final range = buildDefaultDateRange(UserReportKey.timeline);
      expect(range.mode, 'dateOnly');
    });

    test('overspeed key uses dateTime mode', () {
      final range = buildDefaultDateRange(UserReportKey.overspeed);
      expect(range.mode, 'dateTime');
    });
  });

  // ---------------------------------------------------------------------------
  // 10. UserReportKey metadata
  // ---------------------------------------------------------------------------

  group('UserReportKey metadata', () {
    test('sensor.requiresSingleVehicle == true', () {
      expect(UserReportKey.sensor.requiresSingleVehicle, isTrue);
    });

    test('logs.requiresSingleVehicle == true', () {
      expect(UserReportKey.logs.requiresSingleVehicle, isTrue);
    });

    test('distance.requiresSingleVehicle == false', () {
      expect(UserReportKey.distance.requiresSingleVehicle, isFalse);
    });

    test('distance.usesDateOnly == true', () {
      expect(UserReportKey.distance.usesDateOnly, isTrue);
    });

    test('driven.usesDateOnly == false', () {
      expect(UserReportKey.driven.usesDateOnly, isFalse);
    });

    test('distance.maxDays == 31', () {
      expect(UserReportKey.distance.maxDays, 31);
    });

    test('overspeed.maxDays == 7', () {
      expect(UserReportKey.overspeed.maxDays, 7);
    });

    test('logs.maxDays == 7', () {
      expect(UserReportKey.logs.maxDays, 7);
    });

    test('geofence.maxDays == 90', () {
      expect(UserReportKey.geofence.maxDays, 90);
    });

    test('alerts.maxDays == 90', () {
      expect(UserReportKey.alerts.maxDays, 90);
    });

    test('timeline.usesDateOnly == true', () {
      expect(UserReportKey.timeline.usesDateOnly, isTrue);
    });

    test('details.usesDateOnly == true', () {
      expect(UserReportKey.details.usesDateOnly, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // 11. Row fromMap parsing
  // ---------------------------------------------------------------------------

  group('DistanceRow.fromMap', () {
    test('parses all fields correctly', () {
      final m = <String, dynamic>{
        'vehicleName': 'Truck Alpha',
        'vehicleNumber': 'VH001',
        'date': '2026-07-10',
        'distanceKm': 123.45,
        'engineHoursSeconds': 7200.0,
        'firstMovement': '2026-07-10T06:00:00Z',
        'lastMovement': '2026-07-10T18:00:00Z',
        'startAddress': '123 Main St',
        'endAddress': '456 Park Ave',
        'startLat': 28.6139,
        'startLon': 77.209,
        'endLat': 28.7041,
        'endLon': 77.1025,
        'odometerStartKm': 50000.0,
        'odometerEndKm': 50123.45,
      };
      final row = DistanceRow.fromMap(m);

      expect(row.vehicleName, 'Truck Alpha');
      expect(row.vehicleNumber, 'VH001');
      expect(row.date, '2026-07-10');
      expect(row.distanceKm, closeTo(123.45, 0.001));
      expect(row.engineHoursSeconds, closeTo(7200.0, 0.001));
      expect(row.firstMovement, '2026-07-10T06:00:00Z');
      expect(row.startAddress, '123 Main St');
      expect(row.endAddress, '456 Park Ave');
      expect(row.startLat, closeTo(28.6139, 0.0001));
      expect(row.endLat, closeTo(28.7041, 0.0001));
      expect(row.odometerStartKm, closeTo(50000.0, 0.001));
    });

    test('falls back to Vehicle when vehicleName missing', () {
      final row = DistanceRow.fromMap(<String, dynamic>{
        'date': '2026-07-10',
        'distanceKm': 0,
        'engineHoursSeconds': 0,
      });
      expect(row.vehicleName, 'Vehicle');
    });

    test('optional nullable fields are null when absent', () {
      final row = DistanceRow.fromMap(<String, dynamic>{
        'vehicleName': 'Bus',
        'date': '2026-07-10',
        'distanceKm': 10.0,
        'engineHoursSeconds': 3600.0,
      });
      expect(row.startLat, isNull);
      expect(row.startAddress, isNull);
      expect(row.odometerStartKm, isNull);
    });
  });

  group('OverspeedRow.fromMap', () {
    test('parses all fields correctly', () {
      final m = <String, dynamic>{
        'vehicleName': 'Van Beta',
        'startedAt': '2026-07-10T08:30:00Z',
        'endedAt': '2026-07-10T08:35:00Z',
        'durationSeconds': 300.0,
        'maxSpeedKmh': 95.0,
        'configuredLimitKmh': 80.0,
        'excessKmh': 15.0,
        'date': '2026-07-10',
        'address': 'Highway 1',
        'lat': 28.6139,
        'lon': 77.209,
      };
      final row = OverspeedRow.fromMap(m);

      expect(row.vehicleName, 'Van Beta');
      expect(row.startedAt, '2026-07-10T08:30:00Z');
      expect(row.endedAt, '2026-07-10T08:35:00Z');
      expect(row.durationSeconds, closeTo(300.0, 0.001));
      expect(row.maxSpeedKmh, closeTo(95.0, 0.001));
      expect(row.configuredLimitKmh, closeTo(80.0, 0.001));
      expect(row.excessKmh, closeTo(15.0, 0.001));
      expect(row.address, 'Highway 1');
      expect(row.lat, closeTo(28.6139, 0.0001));
    });

    test('severity derived from excessKmh', () {
      final row = OverspeedRow.fromMap(<String, dynamic>{
        'vehicleName': 'Car',
        'startedAt': '2026-07-10T08:30:00Z',
        'durationSeconds': 60.0,
        'maxSpeedKmh': 110.0,
        'configuredLimitKmh': 80.0,
        'excessKmh': 30.0,
      });
      expect(getOverspeedSeverity(row.excessKmh), OverspeedSeverity.critical);
    });
  });

  group('AlertRow.fromMap', () {
    test('parses all fields correctly (legacy eventTime field)', () {
      final m = <String, dynamic>{
        'id': 'a1',
        'vehicleId': 'v1',
        'vehicleName': 'Lorry C',
        'alertType': 'overspeed',
        'severity': 'high',
        'eventTime': '2026-07-10T09:00:00Z',
        'acknowledged': true,
        'message': 'Speed exceeded',
        'speedKmh': 95.5,
        'address': 'Ring Road',
        'lat': 28.61,
        'lon': 77.2,
      };
      final row = AlertRow.fromMap(m);

      expect(row.id, 'a1');
      expect(row.vehicleId, 'v1');
      expect(row.vehicleName, 'Lorry C');
      expect(row.alertType, 'overspeed');
      expect(row.severity, 'high');
      expect(row.eventTime, '2026-07-10T09:00:00Z');
      expect(row.acknowledged, isTrue);
      expect(row.message, 'Speed exceeded');
      expect(row.speedKmh, closeTo(95.5, 0.001));
    });

    test('parses timestamp field (web/fixture API)', () {
      final row = AlertRow.fromMap(<String, dynamic>{
        'id': 'a2',
        'vehicleId': 'v2',
        'vehicleName': 'Truck',
        'alertType': 'geofence_exit',
        'severity': 'medium',
        'timestamp': '2026-07-10T10:00:00Z',
        'acknowledged': false,
      });
      // 'timestamp' wins over absent 'eventTime'
      expect(row.eventTime, '2026-07-10T10:00:00Z');
      expect(row.vehicleId, 'v2');
    });

    test('timestamp takes precedence over eventTime when both present', () {
      final row = AlertRow.fromMap(<String, dynamic>{
        'vehicleName': 'Truck',
        'alertType': 'alert',
        'severity': 'low',
        'timestamp': '2026-07-10T11:00:00Z',
        'eventTime': '2026-07-10T09:00:00Z',
        'acknowledged': false,
      });
      expect(row.eventTime, '2026-07-10T11:00:00Z');
    });

    test('acknowledged parses string "true"', () {
      final row = AlertRow.fromMap(<String, dynamic>{
        'vehicleName': 'Car',
        'alertType': 'alert',
        'severity': 'low',
        'eventTime': '2026-07-10T09:00:00Z',
        'acknowledged': 'true',
      });
      expect(row.acknowledged, isTrue);
    });

    test('acknowledged defaults false for missing', () {
      final row = AlertRow.fromMap(<String, dynamic>{
        'vehicleName': 'Car',
        'alertType': 'alert',
        'severity': 'low',
        'eventTime': '2026-07-10T09:00:00Z',
      });
      expect(row.acknowledged, isFalse);
    });

    test('id and vehicleId empty string when missing', () {
      final row = AlertRow.fromMap(<String, dynamic>{
        'vehicleName': 'Car',
        'alertType': 'alert',
        'severity': 'low',
        'eventTime': '2026-07-10T09:00:00Z',
      });
      expect(row.id, isEmpty);
      expect(row.vehicleId, isEmpty);
    });
  });

  group('GeofenceRow.fromMap', () {
    test('parses all fields correctly', () {
      final m = <String, dynamic>{
        'vehicleName': 'Truck D',
        'event': 'entry',
        'geofenceName': 'Depot Zone',
        'timestamp': '2026-07-10T07:00:00Z',
        'durationSeconds': 1800.0,
        'address': 'Industrial Area',
        'lat': 28.62,
        'lon': 77.21,
      };
      final row = GeofenceRow.fromMap(m);

      expect(row.vehicleName, 'Truck D');
      expect(row.event, 'entry');
      expect(row.geofenceName, 'Depot Zone');
      expect(row.timestamp, '2026-07-10T07:00:00Z');
      expect(row.durationSeconds, closeTo(1800.0, 0.001));
      expect(row.address, 'Industrial Area');
    });

    test('defaults to entry event when missing', () {
      final row = GeofenceRow.fromMap(<String, dynamic>{
        'vehicleName': 'Bus',
        'geofenceName': 'Zone',
        'timestamp': '2026-07-10T07:00:00Z',
      });
      expect(row.event, 'entry');
    });
  });

  group('SensorRow.fromMap', () {
    test('boolean sensor: isBoolean == true', () {
      final m = <String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Door sensor',
        'timestamp': '2026-07-10T10:00:00Z',
        'value': true,
        'unit': null,
      };
      final row = SensorRow.fromMap(m);
      expect(row.isBoolean, isTrue);
    });

    test('numeric sensor: isBoolean == false, numericValue returns double', () {
      final m = <String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Temperature',
        'timestamp': '2026-07-10T10:00:00Z',
        'value': 36.6,
        'unit': '°C',
      };
      final row = SensorRow.fromMap(m);
      // 36.6 is not bool and not 0 or 1, so isBoolean == false
      expect(row.isBoolean, isFalse);
      expect(row.numericValue, closeTo(36.6, 0.001));
      expect(row.unit, '°C');
    });

    test('value=0 is treated as boolean', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Switch',
        'timestamp': '2026-07-10T10:00:00Z',
        'value': 0,
      });
      expect(row.isBoolean, isTrue);
    });

    test('value=1 is treated as boolean', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Switch',
        'timestamp': '2026-07-10T10:00:00Z',
        'value': 1,
      });
      expect(row.isBoolean, isTrue);
    });

    test('timestampMs parses ISO timestamp to ms-since-epoch', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Fuel',
        'timestamp': '2026-07-10T06:00:00Z',
        'value': 55.0,
      });
      expect(row.timestampMs, isNotNull);
      final expected =
          DateTime.utc(2026, 7, 10, 6, 0, 0).millisecondsSinceEpoch.toDouble();
      expect(row.timestampMs, closeTo(expected, 1.0));
    });

    test('timestampMs returns null for empty timestamp', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Sensor',
        'timestamp': '',
        'value': 1.0,
      });
      expect(row.timestampMs, isNull);
    });

    test('sensorId and valueMode parsed correctly', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'sensorId': 's5',
        'vehicleName': 'Van',
        'sensorLabel': 'Rear Door',
        'timestamp': '2026-07-10T06:00:00Z',
        'value': 0,
        'valueMode': 'boolean',
      });
      expect(row.sensorId, 's5');
      expect(row.valueMode, 'boolean');
      expect(row.isBoolean, isTrue);
    });

    test('valueMode=numeric overrides raw-value heuristic for value 0', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'sensorId': 's1',
        'vehicleName': 'Van',
        'sensorLabel': 'Fuel',
        'timestamp': '2026-07-10T06:00:00Z',
        'value': 0,
        'valueMode': 'numeric',
      });
      // valueMode explicitly numeric → isBoolean should be false
      expect(row.valueMode, 'numeric');
      expect(row.isBoolean, isFalse);
    });

    test('sensorId empty string when missing', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Sensor',
        'timestamp': '2026-07-10T06:00:00Z',
        'value': 1.5,
      });
      expect(row.sensorId, isEmpty);
    });

    test('timestampMs returns null for invalid timestamp string', () {
      final row = SensorRow.fromMap(<String, dynamic>{
        'vehicleName': 'Van',
        'sensorLabel': 'Sensor',
        'timestamp': 'not-a-date',
        'value': 1.0,
      });
      expect(row.timestampMs, isNull);
    });
  });

  group('TimelineRow.fromMap', () {
    test('running state: isRunning == true', () {
      final m = <String, dynamic>{
        'vehicleId': 'v1',
        'vehicleName': 'Car E',
        'state': 'running',
        'startedAt': '2026-07-10T06:00:00Z',
        'endedAt': '2026-07-10T07:00:00Z',
        'durationSeconds': 3600.0,
        'distanceKm': 50.0,
        'maxSpeedKmh': 80.0,
        'avgSpeedKmh': 55.0,
      };
      final row = TimelineRow.fromMap(m);
      expect(row.isRunning, isTrue);
      expect(row.vehicleId, 'v1');
      expect(row.durationSeconds, closeTo(3600.0, 0.001));
      expect(row.distanceKm, closeTo(50.0, 0.001));
    });

    test('stopped state: isRunning == false', () {
      final m = <String, dynamic>{
        'vehicleId': 'v2',
        'vehicleName': 'Car E',
        'state': 'stopped',
        'startedAt': '2026-07-10T07:00:00Z',
        'endedAt': '2026-07-10T07:30:00Z',
        'durationSeconds': 1800.0,
      };
      final row = TimelineRow.fromMap(m);
      expect(row.isRunning, isFalse);
      expect(row.vehicleId, 'v2');
    });

    test('defaults to stopped when state missing', () {
      final row = TimelineRow.fromMap(<String, dynamic>{
        'vehicleId': 'v3',
        'vehicleName': 'Car',
        'startedAt': '2026-07-10T06:00:00Z',
        'durationSeconds': 600.0,
      });
      expect(row.state, 'stopped');
      expect(row.isRunning, isFalse);
    });

    test('vehicleId is empty string when missing from map', () {
      final row = TimelineRow.fromMap(<String, dynamic>{
        'vehicleName': 'Car',
        'startedAt': '2026-07-10T06:00:00Z',
        'durationSeconds': 600.0,
      });
      expect(row.vehicleId, isEmpty);
    });
  });

  group('LogRow.fromMap', () {
    test('parses all fields correctly', () {
      final m = <String, dynamic>{
        'timestamp': '2026-07-10T05:00:00Z',
        'category': 'device',
        'level': 'warning',
        'event': 'gps_lost',
        'direction': 'in',
        'message': 'GPS signal lost',
        'protocol': 'TCP',
        'rawPayload': '{"raw":"data"}',
      };
      final row = LogRow.fromMap(m);

      expect(row.timestamp, '2026-07-10T05:00:00Z');
      expect(row.category, 'device');
      expect(row.level, 'warning');
      expect(row.event, 'gps_lost');
      expect(row.direction, 'in');
      expect(row.message, 'GPS signal lost');
      expect(row.protocol, 'TCP');
      expect(row.payload, '{"raw":"data"}');
    });

    test('falls back to system/info defaults', () {
      final row = LogRow.fromMap(<String, dynamic>{
        'timestamp': '2026-07-10T05:00:00Z',
        'event': 'heartbeat',
      });
      expect(row.category, 'system');
      expect(row.level, 'info');
    });

    test('uses payload field when rawPayload absent', () {
      final m = <String, dynamic>{
        'timestamp': '2026-07-10T05:00:00Z',
        'category': 'device',
        'level': 'info',
        'event': 'connect',
        'payload': 'raw-body',
      };
      final row = LogRow.fromMap(m);
      expect(row.payload, 'raw-body');
    });
  });

  // ---------------------------------------------------------------------------
  // 12. reportMap / reportList / reportText helpers
  // ---------------------------------------------------------------------------

  group('reportMap', () {
    test('Map<String,dynamic> → same map', () {
      final m = <String, dynamic>{'a': 1};
      expect(reportMap(m), same(m));
    });

    test('non-map → empty map', () {
      expect(reportMap('not a map'), isEmpty);
      expect(reportMap(null), isEmpty);
      expect(reportMap(42), isEmpty);
    });

    test('Map with non-string keys → converts keys to strings', () {
      final m = {1: 'one', 2: 'two'};
      final result = reportMap(m);
      expect(result, containsPair('1', 'one'));
      expect(result, containsPair('2', 'two'));
    });
  });

  group('reportList', () {
    test('list input → returns same list', () {
      final list = [1, 2, 3];
      expect(reportList(list), same(list));
    });

    test('non-list → empty list', () {
      expect(reportList('not a list'), isEmpty);
      expect(reportList(null), isEmpty);
      expect(reportList(42), isEmpty);
    });
  });

  group('reportText', () {
    test('string → trims and returns', () {
      expect(reportText('  hello  '), 'hello');
    });

    test('null → fallback', () {
      expect(reportText(null, fallback: 'default'), 'default');
    });

    test('empty string → fallback', () {
      expect(reportText('', fallback: 'fallback'), 'fallback');
    });

    test('default fallback is empty string', () {
      expect(reportText(null), '');
    });
  });

  group('reportInt', () {
    test('int → int', () {
      expect(reportInt(42), 42);
    });

    test('double → truncated int', () {
      expect(reportInt(3.9), 3);
    });

    test('string number → parsed int', () {
      expect(reportInt('100'), 100);
    });

    test('invalid string → 0', () {
      expect(reportInt('abc'), 0);
    });

    test('null → 0', () {
      expect(reportInt(null), 0);
    });
  });

  group('reportDouble', () {
    test('double → double', () {
      expect(reportDouble(3.14), closeTo(3.14, 0.001));
    });

    test('int → double', () {
      expect(reportDouble(42), closeTo(42.0, 0.001));
    });

    test('numeric string → parsed double', () {
      expect(reportDouble('99.9'), closeTo(99.9, 0.001));
    });

    test('invalid string → 0.0', () {
      expect(reportDouble('xyz'), closeTo(0.0, 0.001));
    });

    test('null → 0.0', () {
      expect(reportDouble(null), closeTo(0.0, 0.001));
    });
  });

  group('reportBool', () {
    test('true → true', () {
      expect(reportBool(true), isTrue);
    });

    test('"true" → true', () {
      expect(reportBool('true'), isTrue);
    });

    test('"1" → true', () {
      expect(reportBool('1'), isTrue);
    });

    test('"yes" → true', () {
      expect(reportBool('yes'), isTrue);
    });

    test('false → false', () {
      expect(reportBool(false), isFalse);
    });

    test('null → false', () {
      expect(reportBool(null), isFalse);
    });

    test('"false" → false', () {
      expect(reportBool('false'), isFalse);
    });

    test('0 → false (not "true"/"1"/"yes")', () {
      expect(reportBool(0), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // 13. countDateRangeDays reconciliation
  // ---------------------------------------------------------------------------

  group('countDateRangeDays reconciliation', () {
    test('per-vehicle totals: sum of daily rows matches aggregate', () {
      // Simulate multiple DistanceRow entries for the same vehicle across days
      final rows = [
        DistanceRow.fromMap(<String, dynamic>{
          'vehicleName': 'Truck X',
          'vehicleNumber': 'VH001',
          'date': '2026-07-01',
          'distanceKm': 50.0,
          'engineHoursSeconds': 3600.0,
        }),
        DistanceRow.fromMap(<String, dynamic>{
          'vehicleName': 'Truck X',
          'vehicleNumber': 'VH001',
          'date': '2026-07-02',
          'distanceKm': 75.0,
          'engineHoursSeconds': 5400.0,
        }),
        DistanceRow.fromMap(<String, dynamic>{
          'vehicleName': 'Truck X',
          'vehicleNumber': 'VH001',
          'date': '2026-07-03',
          'distanceKm': 30.0,
          'engineHoursSeconds': 1800.0,
        }),
      ];

      final totalDistance = rows.fold(0.0, (sum, r) => sum + r.distanceKm);
      final dayRange = countDateRangeDays('2026-07-01', '2026-07-03');

      expect(rows.length, dayRange);
      expect(totalDistance, closeTo(155.0, 0.001));
    });

    test('day + night distance reconciliation: sum ≈ total distanceKm', () {
      final row = DetailsRow.fromMap(<String, dynamic>{
        'vehicleName': 'Bus Y',
        'date': '2026-07-05',
        'distanceKm': 100.0,
        'engineHoursSeconds': 7200.0,
        'dayDistanceKm': 65.0,
        'nightDistanceKm': 35.0,
        'dayEngineHoursSeconds': 4320.0,
        'nightEngineHoursSeconds': 2880.0,
        'maxSpeedKmh': 90.0,
        'avgSpeedKmh': 55.0,
        'totalTrips': 3,
      });

      final partialSum = row.dayDistanceKm + row.nightDistanceKm;
      // Allow small floating-point tolerance
      expect(partialSum, closeTo(row.distanceKm, 0.01));
    });

    test('countDateRangeDays matches getDateRangeDays list length', () {
      const start = '2026-07-10';
      const end = '2026-07-20';
      expect(
          countDateRangeDays(start, end), getDateRangeDays(start, end).length);
    });

    test('zero-day range returns 0 for reversed dates', () {
      expect(countDateRangeDays('2026-07-15', '2026-07-10'), 0);
    });
  });

  // ---------------------------------------------------------------------------
  // 14. columnLabels getter
  // ---------------------------------------------------------------------------

  group('UserReportKeyMetadata.columnLabels', () {
    test('vehicleName maps to "Vehicle" across all reports', () {
      for (final key in UserReportKey.values) {
        expect(key.columnLabels['vehicleName'], 'Vehicle',
            reason: '${key.name} should label vehicleName as Vehicle');
      }
    });

    test('distance report has distanceKm label', () {
      expect(
          UserReportKey.distance.columnLabels['distanceKm'], 'Distance (km)');
    });

    test('alerts report has alertType and severity labels', () {
      final labels = UserReportKey.alerts.columnLabels;
      expect(labels['alertType'], 'Alert Type');
      expect(labels['severity'], 'Severity');
      expect(labels['acknowledged'], 'Acknowledged');
    });

    test('sensor report has sensorLabel and value labels', () {
      final labels = UserReportKey.sensor.columnLabels;
      expect(labels['sensorLabel'], 'Sensor');
      expect(labels['value'], 'Value');
      expect(labels['unit'], 'Unit');
    });

    test('details report has day/night distance labels', () {
      final labels = UserReportKey.details.columnLabels;
      expect(labels['dayDistanceKm'], 'Day Distance (km)');
      expect(labels['nightDistanceKm'], 'Night Distance (km)');
      expect(labels['totalTrips'], 'Trips');
    });

    test('preferredColumns are all present in columnLabels', () {
      for (final key in UserReportKey.values) {
        final missing = key.preferredColumns
            .where((col) => !key.columnLabels.containsKey(col))
            .toList();
        expect(missing, isEmpty,
            reason:
                '${key.name}: preferredColumns $missing missing from columnLabels');
      }
    });
  });
}

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

class _Point {
  const _Point(this.x, this.y);
  final double x;
  final double y;
}
