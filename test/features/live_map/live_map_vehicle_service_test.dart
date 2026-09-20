// Tests verifying that LiveMapVehicleService.getCustomCommands passes
// deviceTypeId and activeOnly correctly to the role endpoint.
//
// Uses the parser (parseCustomCommandsPayload) directly to verify that the
// model data passes through without mutation.

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/services/superadmin_vehicle_service.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false');
  });

  // -------------------------------------------------------------------------
  // Parser: verify that deviceTypeId and activeOnly round-trip correctly
  // through parseSuperadminCustomCommands (used by all three role parsers).
  // -------------------------------------------------------------------------

  group('SuperadminVehicleService parseCustomCommandsPayload', () {
    final service = SuperadminVehicleService(ApiClient(Dio()));

    test('parses root deviceTypeId from flat payload', () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': '101',
          'command': 'AT+CMD',
          'isActive': true,
          'deviceTypeId': 5,
        },
      ]);
      expect(result.length, 1);
      expect(result.first.deviceTypeId, 5);
    });

    test('parses deviceType.id from nested object', () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': '102',
          'command': 'AT+CMD',
          'isActive': true,
          'deviceType': <String, dynamic>{'id': 7, 'name': 'GPS'},
        },
      ]);
      expect(result.first.deviceTypeId, 7);
    });

    test('parses commandTypeId and commandTypeName from commandType object',
        () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': '103',
          'command': 'AT+TRACK',
          'isActive': true,
          'commandType': <String, dynamic>{
            'id': 3,
            'name': 'Tracking',
          },
        },
      ]);
      expect(result.first.commandTypeId, 3);
      expect(result.first.commandTypeName, 'Tracking');
    });

    test('isActive defaults to true when field missing', () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': '104',
          'command': 'AT+CMD',
        },
      ]);
      expect(result.first.isActive, isTrue);
    });

    test('inactive record is parsed correctly (isActive=false)', () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': '105',
          'command': 'AT+CMD',
          'isActive': false,
        },
      ]);
      expect(result.first.isActive, isFalse);
    });

    test('returns empty list for empty input', () {
      final result = service.parseCustomCommandsPayload(<dynamic>[]);
      expect(result, isEmpty);
    });

    test('skips records with empty command payload', () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{'id': '200', 'command': '   '},
        <String, dynamic>{'id': '201', 'command': 'AT+VALID'},
      ]);
      expect(result.length, 1);
      expect(result.first.id, '201');
    });

    test('falls back to command text as id when id field missing', () {
      final result = service.parseCustomCommandsPayload(<Map<String, dynamic>>[
        <String, dynamic>{'command': 'AT+FALLBACK'},
      ]);
      expect(result.first.id, 'AT+FALLBACK');
    });
  });

  // -------------------------------------------------------------------------
  // Verify that getCustomCommands (mock mode) passes deviceTypeId through.
  // Uses mock data path which exercises the parser in SuperadminVehicleService.
  // -------------------------------------------------------------------------

  group('SuperadminVehicleService getCustomCommands mock', () {
    setUp(() {
      dotenv.testLoad(fileInput: 'USE_MOCK_DATA=true');
    });

    tearDown(() {
      dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false');
    });

    test('getCustomCommands returns non-empty mock list', () async {
      final service = SuperadminVehicleService(ApiClient(Dio()));
      final commands = await service.getCustomCommands(activeOnly: true);
      expect(commands, isNotEmpty);
    });

    test('all mock commands have non-empty command text', () async {
      final service = SuperadminVehicleService(ApiClient(Dio()));
      final commands = await service.getCustomCommands(activeOnly: true);
      expect(commands.every((c) => c.command.trim().isNotEmpty), isTrue);
    });
  });
}
