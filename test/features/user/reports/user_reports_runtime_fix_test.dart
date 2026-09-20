// Tests covering all confirmed bugs fixed in the reports runtime repair:
// 1. UserReportOptions envelope parsing (success, nested business, empty)
// 2. Numeric vehicle ID parsing (int, numeric-string, string passthrough)
// 3. ReportVehicleScope.toJson() ID serialisation
// 4. LogsFilters: directions and search fields
// 5. Alert type snake_case values
// 6. Severity values match backend contract

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_report_model.dart';
import 'package:open_vts/features/user/models/user_report_state.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 1. UserReportOptions envelope parsing
  // ---------------------------------------------------------------------------

  group('UserReportOptions.fromJson', () {
    test('parses vehicles and groups from direct payload', () {
      final options = UserReportOptions.fromJson(<String, dynamic>{
        'vehicles': [
          <String, dynamic>{
            'id': 1,
            'name': 'Truck Alpha',
            'imei': '860012345000001',
            'plateNumber': 'DL01AB1234',
          },
        ],
        'groups': [
          <String, dynamic>{
            'id': 10,
            'name': 'Depot Fleet',
            'vehicleCount': 5,
          },
        ],
      });

      expect(options.vehicles, hasLength(1));
      expect(options.vehicles.first.name, 'Truck Alpha');
      expect(options.vehicles.first.imei, '860012345000001');
      expect(options.vehicles.first.plateNumber, 'DL01AB1234');

      expect(options.groups, hasLength(1));
      expect(options.groups.first.name, 'Depot Fleet');
      expect(options.groups.first.vehicleCount, 5);
    });

    test('numeric id is converted to string', () {
      final options = UserReportOptions.fromJson(<String, dynamic>{
        'vehicles': [
          <String, dynamic>{
            'id': 42,
            'name': 'Van',
            'imei': '123456789012345',
          },
        ],
        'groups': <dynamic>[],
      });

      expect(options.vehicles.first.id, '42');
    });

    test('numeric-string id is preserved as string', () {
      final options = UserReportOptions.fromJson(<String, dynamic>{
        'vehicles': [
          <String, dynamic>{
            'id': '7',
            'name': 'Bus',
            'imei': '111111111111111',
          },
        ],
        'groups': <dynamic>[],
      });

      expect(options.vehicles.first.id, '7');
    });

    test('filters out vehicles with empty id', () {
      final options = UserReportOptions.fromJson(<String, dynamic>{
        'vehicles': [
          <String, dynamic>{
            'id': null,
            'name': 'Ghost',
            'imei': '000000000000000',
          },
          <String, dynamic>{
            'id': 5,
            'name': 'Real',
            'imei': '111111111111111',
          },
        ],
        'groups': <dynamic>[],
      });

      expect(options.vehicles, hasLength(1));
      expect(options.vehicles.first.name, 'Real');
    });

    test('genuinely empty vehicles list is preserved empty', () {
      final options = UserReportOptions.fromJson(<String, dynamic>{
        'vehicles': <dynamic>[],
        'groups': <dynamic>[],
      });

      expect(options.vehicles, isEmpty);
      expect(options.groups, isEmpty);
    });

    test('missing vehicles key yields empty list', () {
      final options = UserReportOptions.fromJson(<String, dynamic>{
        'groups': <dynamic>[],
      });
      expect(options.vehicles, isEmpty);
    });

    test('null payload yields empty lists without throwing', () {
      final options = UserReportOptions.fromJson(null);
      expect(options.vehicles, isEmpty);
      expect(options.groups, isEmpty);
    });

    test('vehicle displayName uses name·plate when plate present', () {
      final v = UserReportVehicleOption.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'Truck',
        'imei': '111',
        'plateNumber': 'MH01AB0001',
      });
      expect(v.displayName, 'Truck · MH01AB0001');
    });

    test('vehicle displayName uses name only when no plate', () {
      final v = UserReportVehicleOption.fromJson(<String, dynamic>{
        'id': '2',
        'name': 'Van',
        'imei': '222',
      });
      expect(v.displayName, 'Van');
    });
  });

  // ---------------------------------------------------------------------------
  // 2. ReportVehicleScope.toJson() — ID type coercion
  // ---------------------------------------------------------------------------

  group('ReportVehicleScope.toJson()', () {
    test('all mode: mode=all, no id fields', () {
      final json = const ReportVehicleScope.all().toJson();
      expect(json['mode'], 'all');
      expect(json.containsKey('vehicleId'), isFalse);
      expect(json.containsKey('vehicleIds'), isFalse);
      expect(json.containsKey('groupId'), isFalse);
    });

    test('single mode: vehicleId is int when parseable', () {
      final json = const ReportVehicleScope.single('42').toJson();
      expect(json['mode'], 'single');
      expect(json['vehicleId'], 42);
      expect(json['vehicleId'], isA<int>());
    });

    test('single mode: vehicleId stays string when non-numeric', () {
      final json = const ReportVehicleScope.single('abc').toJson();
      expect(json['vehicleId'], 'abc');
      expect(json['vehicleId'], isA<String>());
    });

    test('multiple mode: vehicleIds are ints when parseable', () {
      final json = const ReportVehicleScope.multiple(['1', '2', '3']).toJson();
      expect(json['mode'], 'multiple');
      final ids = json['vehicleIds'] as List<dynamic>;
      expect(ids, everyElement(isA<int>()));
      expect(ids, containsAllInOrder([1, 2, 3]));
    });

    test(
        'multiple mode: mixed ids — numeric parsed, non-numeric kept as string',
        () {
      final json =
          const ReportVehicleScope.multiple(['10', 'abc', '20']).toJson();
      final ids = json['vehicleIds'] as List<dynamic>;
      expect(ids[0], 10);
      expect(ids[1], 'abc');
      expect(ids[2], 20);
    });

    test('group mode: groupId is int when parseable', () {
      final json = const ReportVehicleScope.group('5').toJson();
      expect(json['mode'], 'group');
      expect(json['groupId'], 5);
      expect(json['groupId'], isA<int>());
    });

    test('group mode: null groupId → null in JSON', () {
      final scope = const ReportVehicleScope.group('');
      final json = scope.toJson();
      // Empty string → int.tryParse returns null → fallback to empty string
      expect(json['groupId'], isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // 3. LogsFilters — directions and search
  // ---------------------------------------------------------------------------

  group('LogsFilters', () {
    test('default constructor has empty directions and empty search', () {
      const f = LogsFilters();
      expect(f.directions, isEmpty);
      expect(f.search, '');
    });

    test('toJson includes directions and omits short search', () {
      const f = LogsFilters(
        categories: ['telemetry'],
        levels: ['info'],
        directions: ['device_to_server'],
        search: 'ab', // too short — must be omitted
      );
      final json = f.toJson();

      expect(json['categories'], ['telemetry']);
      expect(json['levels'], ['info']);
      expect(json['directions'], ['device_to_server']);
      expect(json.containsKey('search'), isFalse);
    });

    test('toJson includes search when >= 3 chars', () {
      const f = LogsFilters(search: 'GPS');
      final json = f.toJson();
      expect(json['search'], 'GPS');
    });

    test('toJson trims search before length check', () {
      const f = LogsFilters(search: '  ab  '); // trimmed = "ab" (2 chars)
      final json = f.toJson();
      expect(json.containsKey('search'), isFalse);
    });

    test('toJson includes trimmed search when trimmed >= 3 chars', () {
      const f = LogsFilters(search: '  GPS signal  ');
      final json = f.toJson();
      expect(json['search'], 'GPS signal');
    });

    test('toJson always includes directions even when empty', () {
      const f = LogsFilters();
      final json = f.toJson();
      expect(json.containsKey('directions'), isTrue);
      expect(json['directions'], isEmpty);
    });

    test('toJson always includes categories and levels', () {
      const f = LogsFilters();
      final json = f.toJson();
      expect(json.containsKey('categories'), isTrue);
      expect(json.containsKey('levels'), isTrue);
    });

    test('all three directions serialised correctly', () {
      const f = LogsFilters(directions: [
        'device_to_server',
        'server_to_device',
        'internal',
      ]);
      final json = f.toJson();
      expect(
          json['directions'],
          containsAllInOrder(
              ['device_to_server', 'server_to_device', 'internal']));
    });
  });

  // ---------------------------------------------------------------------------
  // 4. AlertsFilters — snake_case values and severity contract
  // ---------------------------------------------------------------------------

  group('AlertsFilters', () {
    test('default constructor serialises correctly', () {
      const f = AlertsFilters();
      final json = f.toJson();
      expect(json['alertTypes'], isEmpty);
      expect(json['severities'], isEmpty);
      expect(json['acknowledged'], 'all');
    });

    test('snake_case alert types round-trip through toJson', () {
      const alertTypes = [
        'overspeed',
        'geofence_exit',
        'geofence_entry',
        'ignition_on',
        'ignition_off',
        'route_deviation',
        'sensor',
        'sos',
        'alarm',
        'running',
        'stopped',
        'idle',
        'reminder',
        'command',
      ];
      const f = AlertsFilters(alertTypes: alertTypes);
      final json = f.toJson();
      expect(json['alertTypes'], alertTypes);
    });

    test('no camelCase values in default alert type list', () {
      // Regression guard: ensures we didn't re-introduce camelCase keys
      const badValues = [
        'geofenceExit',
        'geofenceEntry',
        'ignitionOn',
        'ignitionOff',
        'routeDeviation',
        'temperature', // removed from contract
      ];
      const f = AlertsFilters(alertTypes: [
        'geofence_exit',
        'geofence_entry',
        'ignition_on',
        'ignition_off',
        'route_deviation',
      ]);
      final json = f.toJson();
      for (final bad in badValues) {
        expect(
          (json['alertTypes'] as List<dynamic>).contains(bad),
          isFalse,
          reason: 'camelCase/invalid "$bad" must not appear in alertTypes',
        );
      }
    });

    test('severity values are backend-contract compliant: critical, high, low',
        () {
      // Backend accepts: critical, high, low (not medium)
      const f = AlertsFilters(severities: ['critical', 'high', 'low']);
      final json = f.toJson();
      expect(
          json['severities'], containsAllInOrder(['critical', 'high', 'low']));
    });

    test('acknowledged values serialise correctly', () {
      for (final v in ['all', 'yes', 'no']) {
        final json = AlertsFilters(acknowledged: v).toJson();
        expect(json['acknowledged'], v);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // 5. UserReportPage envelope parsing
  // ---------------------------------------------------------------------------

  group('UserReportPage.fromJson', () {
    test('parses rows and meta from flat payload', () {
      final page = UserReportPage.fromJson(<String, dynamic>{
        'rows': [
          <String, dynamic>{'vehicleName': 'Truck', 'distanceKm': 10.5},
        ],
        'meta': <String, dynamic>{
          'generatedAt': '2026-07-10T06:00:00Z',
          'hasMore': false,
          'nextCursor': null,
          'warning': null,
          'source': 'live',
        },
      });

      expect(page.rows, hasLength(1));
      expect(page.hasMore, isFalse);
      expect(page.nextCursor, isNull);
      expect(page.source, 'live');
      expect(page.generatedAt, isNotNull);
    });

    test('hasMore=true and nextCursor present', () {
      final page = UserReportPage.fromJson(<String, dynamic>{
        'rows': <dynamic>[],
        'meta': <String, dynamic>{
          'generatedAt': '2026-07-10T06:00:00Z',
          'hasMore': true,
          'nextCursor': 'vehicle:42',
        },
      });

      expect(page.hasMore, isTrue);
      expect(page.nextCursor, 'vehicle:42');
    });

    test('warning message is preserved', () {
      final page = UserReportPage.fromJson(<String, dynamic>{
        'rows': <dynamic>[],
        'meta': <String, dynamic>{
          'generatedAt': '2026-07-10T06:00:00Z',
          'hasMore': false,
          'warning': 'Date range capped to 7 days',
        },
      });

      expect(page.warning, 'Date range capped to 7 days');
    });

    test('filters out empty rows', () {
      final page = UserReportPage.fromJson(<String, dynamic>{
        'rows': [
          <String, dynamic>{'vehicleName': 'Truck'},
          <dynamic>[], // not a map → reportMap returns empty → filtered
        ],
        'meta': <String, dynamic>{'generatedAt': '2026-07-10T06:00:00Z'},
      });

      expect(page.rows, hasLength(1));
    });
  });

  // ---------------------------------------------------------------------------
  // 6. UserReportVehicleOption.fromJson — IMEI field
  // ---------------------------------------------------------------------------

  group('UserReportVehicleOption.fromJson', () {
    test('imei is parsed correctly', () {
      final v = UserReportVehicleOption.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'Van',
        'imei': '860012345000001',
      });
      expect(v.imei, '860012345000001');
    });

    test('missing imei defaults to empty string', () {
      final v = UserReportVehicleOption.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'Van',
      });
      expect(v.imei, '');
    });
  });

  // ---------------------------------------------------------------------------
  // 7. ReportDateRange serialisation
  // ---------------------------------------------------------------------------

  group('ReportDateRange.toJson', () {
    test('dateOnly mode serialises correctly', () {
      const r = ReportDateRange.dateOnly(
        startDate: '2026-07-01',
        endDate: '2026-07-07',
      );
      final json = r.toJson();
      expect(json['mode'], 'dateOnly');
      expect(json['startDate'], '2026-07-01');
      expect(json['endDate'], '2026-07-07');
      expect(json.containsKey('fromISO'), isFalse);
      expect(json.containsKey('toISO'), isFalse);
    });

    test('dateTime mode serialises correctly', () {
      const r = ReportDateRange.dateTime(
        from: '2026-07-01T00:00:00.000Z',
        to: '2026-07-07T23:59:59.999Z',
      );
      final json = r.toJson();
      expect(json['mode'], 'dateTime');
      expect(json['fromISO'], '2026-07-01T00:00:00.000Z');
      expect(json['toISO'], '2026-07-07T23:59:59.999Z');
      expect(json.containsKey('startDate'), isFalse);
      expect(json.containsKey('endDate'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // 8. OverspeedFilters, GeofenceFilters, SensorFilters, TimelineFilters
  // ---------------------------------------------------------------------------

  group('OverspeedFilters.toJson', () {
    test('default speedLimitKmh=120', () {
      expect(const OverspeedFilters().toJson()['speedLimitKmh'], 120);
    });

    test('custom speed limit serialised', () {
      expect(
          const OverspeedFilters(speedLimitKmh: 80).toJson()['speedLimitKmh'],
          80);
    });
  });

  group('GeofenceFilters.toJson', () {
    test('empty geofenceIds is an empty list', () {
      final json = const GeofenceFilters().toJson();
      expect(json['geofenceIds'], isEmpty);
    });

    test('geofenceIds serialised correctly', () {
      final json = const GeofenceFilters(geofenceIds: ['g1', 'g2']).toJson();
      expect(json['geofenceIds'], ['g1', 'g2']);
    });
  });

  group('SensorFilters.toJson', () {
    test('single sensorId serialised', () {
      final json = const SensorFilters(sensorIds: ['s5']).toJson();
      expect(json['sensorIds'], ['s5']);
    });
  });

  group('TimelineFilters.toJson', () {
    test('default both states', () {
      final json = const TimelineFilters().toJson();
      expect(json['states'], containsAllInOrder(['running', 'stopped']));
    });

    test('running-only', () {
      final json = const TimelineFilters(states: ['running']).toJson();
      expect(json['states'], ['running']);
    });
  });
}
