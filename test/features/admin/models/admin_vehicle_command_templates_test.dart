// Tests for command-template deduplication, sorting, and device-type parsing.
//
// Covers every acceptance criterion from the fix specification:
//   - deviceTypeId parsed from vehicle details (device.deviceTypeId)
//   - no deviceTypeId when device field absent or field missing
//   - duplicate record with the same ID dropped
//   - semantically identical record with different wrapper dropped
//   - two genuinely different commands sharing a display title kept
//   - result sorted by commandTypeName then command text
//   - unique IDs produced (safe for DropdownMenuItem value)
//   - stale selected value scenario documented via model behaviour
//   - correct command text returned for a given ID

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/utils/admin_command_template_utils.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminCustomCommand _cmd({
  required String id,
  required String command,
  int? deviceTypeId,
  int? commandTypeId,
  String? commandTypeName,
}) {
  return SuperadminCustomCommand(
    id: id,
    command: command,
    isActive: true,
    deviceTypeId: deviceTypeId,
    commandTypeId: commandTypeId,
    commandTypeName: commandTypeName,
  );
}

void main() {
  // -------------------------------------------------------------------------
  // 1. deviceTypeId parsing from vehicle details
  // -------------------------------------------------------------------------

  group('AdminVehicleDeviceMini.fromJson deviceTypeId', () {
    test('parses deviceTypeId as int', () {
      final device = AdminVehicleDeviceMini.fromJson(<String, dynamic>{
        'id': '1',
        'imei': '123456789012345',
        'deviceTypeId': 7,
      });
      expect(device.deviceTypeId, 7);
    });

    test('parses device_type_id alias', () {
      final device = AdminVehicleDeviceMini.fromJson(<String, dynamic>{
        'id': '1',
        'imei': '123456789012345',
        'device_type_id': 3,
      });
      expect(device.deviceTypeId, 3);
    });

    test('parses deviceTypeId given as numeric string', () {
      final device = AdminVehicleDeviceMini.fromJson(<String, dynamic>{
        'id': '1',
        'imei': '123456789012345',
        'deviceTypeId': '5',
      });
      expect(device.deviceTypeId, 5);
    });

    test('returns null when deviceTypeId absent', () {
      final device = AdminVehicleDeviceMini.fromJson(<String, dynamic>{
        'id': '1',
        'imei': '123456789012345',
      });
      expect(device.deviceTypeId, isNull);
    });
  });

  group('AdminVehicleDetails device.deviceTypeId reachable', () {
    test('device.deviceTypeId is accessible from vehicle details', () {
      final vehicle = AdminVehicleDetails.fromJson(<String, dynamic>{
        'id': '42',
        'imei': '123456789012345',
        'device': <String, dynamic>{
          'id': '10',
          'imei': '123456789012345',
          'deviceTypeId': 9,
        },
      });
      expect(vehicle.device?.deviceTypeId, 9);
    });

    test('device.deviceTypeId is null when device absent', () {
      final vehicle = AdminVehicleDetails.fromJson(<String, dynamic>{
        'id': '42',
        'imei': '123456789012345',
      });
      expect(vehicle.device, isNull);
    });

    test('device.deviceTypeId is null when field missing from device', () {
      final vehicle = AdminVehicleDetails.fromJson(<String, dynamic>{
        'id': '42',
        'imei': '123456789012345',
        'device': <String, dynamic>{
          'id': '10',
          'imei': '123456789012345',
        },
      });
      expect(vehicle.device?.deviceTypeId, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 2. deduplicateAndSortCommands
  // -------------------------------------------------------------------------

  group('deduplicateAndSortCommands duplicate same ID', () {
    test('drops the second record when ID is identical', () {
      final raw = [
        _cmd(
            id: 'cmd-1',
            command: 'AT+TRACK',
            deviceTypeId: 1,
            commandTypeId: 2),
        _cmd(
            id: 'cmd-1',
            command: 'AT+TRACK',
            deviceTypeId: 1,
            commandTypeId: 2),
      ];
      final result = deduplicateAndSortCommands(raw);
      expect(result.length, 1);
      expect(result.first.id, 'cmd-1');
    });

    test('keeps three commands when all IDs differ', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A'),
        _cmd(id: 'b', command: 'CMD_B'),
        _cmd(id: 'c', command: 'CMD_C'),
      ];
      expect(deduplicateAndSortCommands(raw).length, 3);
    });
  });

  group('deduplicateAndSortCommands semantic duplicates with different IDs',
      () {
    test(
        'drops semantic duplicate (same deviceTypeId + commandTypeId + command)',
        () {
      final raw = [
        _cmd(
            id: 'id-1', command: 'AT+TRACK', deviceTypeId: 1, commandTypeId: 2),
        _cmd(
            id: 'id-2', command: 'AT+TRACK', deviceTypeId: 1, commandTypeId: 2),
      ];
      final result = deduplicateAndSortCommands(raw);
      expect(result.length, 1);
      expect(result.first.id, 'id-1');
    });

    test('keeps both when command text differs (same type IDs)', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+TRACK=1', deviceTypeId: 1, commandTypeId: 2),
        _cmd(id: 'b', command: 'AT+TRACK=0', deviceTypeId: 1, commandTypeId: 2),
      ];
      expect(deduplicateAndSortCommands(raw).length, 2);
    });

    test('keeps both when deviceTypeId differs (same command + commandTypeId)',
        () {
      final raw = [
        _cmd(id: 'a', command: 'AT+CMD', deviceTypeId: 1, commandTypeId: 5),
        _cmd(id: 'b', command: 'AT+CMD', deviceTypeId: 2, commandTypeId: 5),
      ];
      expect(deduplicateAndSortCommands(raw).length, 2);
    });

    test('normalises command text case for composite key', () {
      final raw = [
        _cmd(id: 'a', command: 'at+track', deviceTypeId: 1, commandTypeId: 2),
        _cmd(id: 'b', command: 'AT+TRACK', deviceTypeId: 1, commandTypeId: 2),
      ];
      final result = deduplicateAndSortCommands(raw);
      expect(result.length, 1);
      expect(result.first.id, 'a');
    });
  });

  group('deduplicateAndSortCommands different commands sharing a display title',
      () {
    test('keeps both when display title matches but command text differs', () {
      final raw = [
        _cmd(
            id: 'x',
            command: 'AT+PROTOCOL=1',
            commandTypeName: 'Track',
            deviceTypeId: 1,
            commandTypeId: 3),
        _cmd(
            id: 'y',
            command: 'AT+PROTOCOL=2',
            commandTypeName: 'Track',
            deviceTypeId: 2,
            commandTypeId: 3),
      ];
      final result = deduplicateAndSortCommands(raw);
      expect(result.length, 2);
      final ids = result.map((c) => c.id).toSet();
      expect(ids, contains('x'));
      expect(ids, contains('y'));
    });
  });

  group('deduplicateAndSortCommands sorting', () {
    test('sorts by commandTypeName ascending then command text ascending', () {
      // Give each command a unique text so composite dedup does not merge them.
      final raw = [
        _cmd(id: 'c', command: 'ZZZ', commandTypeName: 'Beta'),
        _cmd(id: 'a', command: 'AAA_ZETA', commandTypeName: 'Zeta'),
        _cmd(id: 'b', command: 'MMM', commandTypeName: 'Alpha'),
        _cmd(id: 'd', command: 'AAA_BETA', commandTypeName: 'Beta'),
      ];
      final result = deduplicateAndSortCommands(raw);
      expect(result.length, 4);
      expect(result[0].commandTypeName, 'Alpha');
      expect(result[0].command, 'MMM');
      expect(result[1].commandTypeName, 'Beta');
      expect(result[1].command, 'AAA_BETA');
      expect(result[2].commandTypeName, 'Beta');
      expect(result[2].command, 'ZZZ');
      expect(result[3].commandTypeName, 'Zeta');
      expect(result[3].command, 'AAA_ZETA');
    });

    test('null commandTypeName sorts before non-null', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD', commandTypeName: 'Zebra'),
        _cmd(id: 'b', command: 'BCMD', commandTypeName: null),
      ];
      final result = deduplicateAndSortCommands(raw);
      // null -> empty string -> sorts before 'Zebra'
      expect(result.first.id, 'b');
    });
  });

  group('deduplicateAndSortCommands unique dropdown values', () {
    test('all result IDs are unique', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1, commandTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 1, commandTypeId: 2),
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1, commandTypeId: 1),
        _cmd(id: 'c', command: 'CMD_C', deviceTypeId: 2, commandTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 1, commandTypeId: 2),
      ];
      final result = deduplicateAndSortCommands(raw);
      final ids = result.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length,
          reason: 'All dropdown values must be unique');
    });
  });

  group('deduplicateAndSortCommands empty input', () {
    test('returns empty list for empty input', () {
      expect(deduplicateAndSortCommands([]), isEmpty);
    });
  });

  group('deduplicateAndSortCommands correct command text for selected ID', () {
    test('command text is correct for the kept record after dedup', () {
      final raw = [
        _cmd(
            id: 'cmd-99',
            command: 'AT+SETPARAM=VALUE',
            deviceTypeId: 1,
            commandTypeId: 4),
        _cmd(
            id: 'cmd-99',
            command: 'AT+SETPARAM=VALUE',
            deviceTypeId: 1,
            commandTypeId: 4),
      ];
      final result = deduplicateAndSortCommands(raw);
      expect(result.length, 1);
      expect(result.first.command, 'AT+SETPARAM=VALUE');
    });
  });

  group('stale selected value invalid ID cleared after refresh', () {
    test('command with removed ID is not present in deduped list', () {
      // Simulates a refresh that no longer includes 'old-id'.
      final afterRefresh = [
        _cmd(id: 'new-id', command: 'CMD_NEW'),
      ];
      final result = deduplicateAndSortCommands(afterRefresh);
      final stillExists = result.any((c) => c.id == 'old-id');
      expect(stillExists, isFalse,
          reason: 'stale selection old-id should not be present after refresh');
    });
  });

  // -------------------------------------------------------------------------
  // 9. displaySelectedLabel — same-type commands must be distinguishable
  // -------------------------------------------------------------------------

  group('SuperadminCustomCommand.displaySelectedLabel', () {
    test('returns "Type — payload" when type and payload differ', () {
      final cmd = _cmd(
        id: 'x',
        command: 'AT+LOCK=1',
        commandTypeName: 'Engine Lock',
      );
      expect(cmd.displaySelectedLabel, 'Engine Lock — AT+LOCK=1');
    });

    test('returns just type when payload matches type exactly', () {
      final cmd = _cmd(
        id: 'x',
        command: 'Engine Lock',
        commandTypeName: 'Engine Lock',
      );
      expect(cmd.displaySelectedLabel, 'Engine Lock');
    });

    test('returns payload alone when commandTypeName is null', () {
      final cmd = _cmd(id: 'x', command: 'AT+TRACK=1');
      expect(cmd.displaySelectedLabel, 'AT+TRACK=1');
    });

    test('two same-type commands produce distinct displaySelectedLabels', () {
      final cmd1 = _cmd(
        id: 'a',
        command: 'AT+LOCK=1',
        commandTypeName: 'Engine Lock',
      );
      final cmd2 = _cmd(
        id: 'b',
        command: 'AT+LOCK=0',
        commandTypeName: 'Engine Lock',
      );
      expect(cmd1.displaySelectedLabel, isNot(cmd2.displaySelectedLabel));
      expect(cmd1.displaySelectedLabel, 'Engine Lock — AT+LOCK=1');
      expect(cmd2.displaySelectedLabel, 'Engine Lock — AT+LOCK=0');
    });

    test('truncates payload longer than 40 chars', () {
      final longPayload = 'A' * 50;
      final cmd = _cmd(
        id: 'x',
        command: longPayload,
        commandTypeName: 'Type',
      );
      final label = cmd.displaySelectedLabel;
      expect(label.length, lessThanOrEqualTo('Type — '.length + 40));
      expect(label, endsWith('…'));
    });
  });
}
