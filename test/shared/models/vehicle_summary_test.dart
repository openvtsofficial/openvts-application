// Tests for VehicleSummary.fromJson device-type ID extraction.
//
// Covers every source-backed shape confirmed by the backend and web reference,
// including the device.type.id shape that the web telemetry adapter uses.

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/models/vehicle_summary.dart';

void main() {
  group('VehicleSummary.fromJson deviceTypeId parsing', () {
    test('root deviceTypeId (camelCase)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'deviceTypeId': 7,
      });
      expect(v.deviceTypeId, 7);
    });

    test('snake-case device_type_id', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device_type_id': 8,
      });
      expect(v.deviceTypeId, 8);
    });

    test('deviceType.id (camelCase nested object)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'deviceType': <String, dynamic>{'id': 9, 'name': 'GPS'},
      });
      expect(v.deviceTypeId, 9);
    });

    test('device_type.id (snake-case nested object)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device_type': <String, dynamic>{'id': 10},
      });
      expect(v.deviceTypeId, 10);
    });

    test('device.deviceTypeId (device wrapper with flat id field)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device': <String, dynamic>{'deviceTypeId': 11},
      });
      expect(v.deviceTypeId, 11);
    });

    test('device.device_type_id (device wrapper snake-case flat)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device': <String, dynamic>{'device_type_id': 12},
      });
      expect(v.deviceTypeId, 12);
    });

    test('device.type.id (web shape: dbVehicle?.device?.type?.id)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device': <String, dynamic>{
          'type': <String, dynamic>{'id': 13, 'name': 'GPS'},
        },
      });
      expect(v.deviceTypeId, 13);
    });

    test('device.deviceType.id (device wrapper with nested deviceType object)',
        () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device': <String, dynamic>{
          'deviceType': <String, dynamic>{'id': 14},
        },
      });
      expect(v.deviceTypeId, 14);
    });

    test('device.device_type.id (device wrapper snake-case nested)', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'device': <String, dynamic>{
          'device_type': <String, dynamic>{'id': 15},
        },
      });
      expect(v.deviceTypeId, 15);
    });

    test('missing deviceTypeId returns null without crashing', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
      });
      expect(v.deviceTypeId, isNull);
    });

    test('vehicleTypeId is NOT used as deviceTypeId', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'vehicleTypeId': 99,
      });
      expect(v.deviceTypeId, isNull);
    });

    test('root deviceTypeId takes precedence over nested device.type.id', () {
      final v = VehicleSummary.fromJson(<String, dynamic>{
        'id': '1',
        'name': 'V',
        'plateNumber': 'ABC',
        'status': 'ok',
        'speed': 0,
        'latitude': 0,
        'longitude': 0,
        'deviceTypeId': 5,
        'device': <String, dynamic>{
          'type': <String, dynamic>{'id': 99},
        },
      });
      expect(v.deviceTypeId, 5);
    });
  });
}
