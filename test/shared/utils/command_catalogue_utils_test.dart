// Tests for deduplicateLiveMapCommandCatalogue.
//
// Covers all three roles (superadmin / admin / user) by verifying the
// function under the same conditions that each role's _loadCatalog() call
// produces, since all role endpoints return the same model type
// (SuperadminCustomCommand via LiveMapCustomCommand typedef).

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';
import 'package:open_vts/shared/utils/command_catalogue_utils.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SuperadminCustomCommand _cmd({
  required String id,
  required String command,
  int? deviceTypeId,
  int? commandTypeId,
  String? commandTypeName,
  bool isActive = true,
}) {
  return SuperadminCustomCommand(
    id: id,
    command: command,
    isActive: isActive,
    deviceTypeId: deviceTypeId,
    commandTypeId: commandTypeId,
    commandTypeName: commandTypeName,
  );
}

void main() {
  // -------------------------------------------------------------------------
  // Empty / single-item edge cases
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue empty and single', () {
    test('returns empty list for empty input', () {
      expect(deduplicateLiveMapCommandCatalogue([]), isEmpty);
    });

    test('returns single active item unchanged', () {
      final result = deduplicateLiveMapCommandCatalogue([
        _cmd(id: 'a', command: 'CMD', deviceTypeId: 1, commandTypeId: 1),
      ]);
      expect(result.length, 1);
      expect(result.first.id, 'a');
    });

    test('returns empty list when only item is inactive', () {
      final result = deduplicateLiveMapCommandCatalogue([
        _cmd(id: 'a', command: 'CMD', isActive: false),
      ]);
      expect(result, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // A. Inactive commands removed
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue inactive removal', () {
    test('removes inactive commands', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', isActive: true),
        _cmd(id: 'b', command: 'CMD_B', isActive: false),
        _cmd(id: 'c', command: 'CMD_C', isActive: true),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 2);
      expect(result.map((c) => c.id).toList(), containsAll(['a', 'c']));
    });
  });

  // -------------------------------------------------------------------------
  // B. Device-type filtering
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue device-type filtering', () {
    test(
        'drops commands with different deviceTypeId when selectedDeviceTypeId is set',
        () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 2),
        _cmd(id: 'c', command: 'CMD_C', deviceTypeId: 1),
      ];
      final result =
          deduplicateLiveMapCommandCatalogue(raw, selectedDeviceTypeId: 1);
      expect(result.length, 2);
      expect(result.map((c) => c.id).toList(), containsAll(['a', 'c']));
    });

    test(
        'keeps commands with null deviceTypeId when selectedDeviceTypeId is set',
        () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: null),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 1),
        _cmd(id: 'c', command: 'CMD_C', deviceTypeId: 2),
      ];
      final result =
          deduplicateLiveMapCommandCatalogue(raw, selectedDeviceTypeId: 1);
      // null deviceTypeId kept; deviceTypeId=2 dropped
      expect(result.length, 2);
      expect(result.map((c) => c.id).toList(), containsAll(['a', 'b']));
    });

    test('keeps all commands when selectedDeviceTypeId is null', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 2),
        _cmd(id: 'c', command: 'CMD_C', deviceTypeId: null),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 3);
    });
  });

  // -------------------------------------------------------------------------
  // C. Duplicate stable ID
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue duplicate by ID', () {
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
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'cmd-1');
    });

    test('keeps three commands when all IDs differ', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A'),
        _cmd(id: 'b', command: 'CMD_B'),
        _cmd(id: 'c', command: 'CMD_C'),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 3);
    });
  });

  // -------------------------------------------------------------------------
  // D. Payload-only deduplication
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue payload deduplication', () {
    test('drops second record with same payload and different commandTypeId',
        () {
      final raw = [
        _cmd(id: 'id-1', command: 'AT+TRACK', commandTypeId: 1),
        _cmd(id: 'id-2', command: 'AT+TRACK', commandTypeId: 2),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'id-1');
    });

    test(
        'drops second record with same payload and different deviceTypeId in fallback (no selectedDeviceTypeId)',
        () {
      final raw = [
        _cmd(id: 'id-1', command: 'AT+TRACK', deviceTypeId: 1),
        _cmd(id: 'id-2', command: 'AT+TRACK', deviceTypeId: 2),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'id-1');
    });

    test('keeps both when command text differs', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+TRACK=1', commandTypeId: 2),
        _cmd(id: 'b', command: 'AT+TRACK=0', commandTypeId: 2),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 2);
    });

    test('normalises CRLF and CR to LF for payload comparison', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD\r\nLINE'),
        _cmd(id: 'b', command: 'CMD\nLINE'),
        _cmd(id: 'c', command: 'CMD\rLINE'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'a');
    });

    test('normalises command text case for payload key', () {
      final raw = [
        _cmd(id: 'a', command: 'at+track'),
        _cmd(id: 'b', command: 'AT+TRACK'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'a');
    });

    test('preserves original command text on retained record', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+TRACK=ON'),
        _cmd(id: 'b', command: 'at+track=on'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.first.command, 'AT+TRACK=ON');
    });

    test('keeps same title with different payloads as separate entries', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+TRACK=1', commandTypeName: 'Track'),
        _cmd(id: 'b', command: 'AT+TRACK=0', commandTypeName: 'Track'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 2);
    });
  });

  // -------------------------------------------------------------------------
  // Stable unique selection keys
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue stable keys', () {
    test('all returned stableKeys are unique', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1, commandTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 1, commandTypeId: 2),
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1, commandTypeId: 1),
        _cmd(id: 'c', command: 'CMD_C', deviceTypeId: 2, commandTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 1, commandTypeId: 2),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      final keys = result.map((c) => c.stableKey).toList();
      expect(keys.toSet().length, keys.length,
          reason: 'All stableKeys must be unique for DropdownMenuItem.value');
    });

    test('stableKey equals id when ids are all unique', () {
      final raw = [
        _cmd(id: 'alpha', command: 'CMD_A'),
        _cmd(id: 'beta', command: 'CMD_B'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result[0].stableKey, 'alpha');
      expect(result[1].stableKey, 'beta');
    });

    test('original backend id preserved separately from stableKey', () {
      // Two records with different IDs and different payloads are both kept;
      // each gets a stableKey equal to its unique id.
      final raw = [
        _cmd(id: 'x', command: 'CMD_X'),
        _cmd(id: 'y', command: 'CMD_Y'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 2);
      expect(result[0].id, isNot(result[1].id));
      expect(result[0].stableKey, result[0].id);
      expect(result[1].stableKey, result[1].id);
    });

    test(
        'duplicate backend id but different payload: ID collision wins, second dropped',
        () {
      // Step C (ID dedup) fires before step D (payload dedup).
      // The second record is dropped by ID dedup even though its payload differs.
      final raw = [
        _cmd(id: 'x', command: 'CMD_X'),
        _cmd(id: 'x', command: 'CMD_DIFFERENT'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'x');
      expect(result.first.command, 'CMD_X');
    });
  });

  // -------------------------------------------------------------------------
  // Sorting
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue sorting', () {
    test('sorts by commandTypeName ascending then command text ascending', () {
      final raw = [
        _cmd(id: 'c', command: 'ZZZ', commandTypeName: 'Beta'),
        _cmd(id: 'a', command: 'AAA_ZETA', commandTypeName: 'Zeta'),
        _cmd(id: 'b', command: 'MMM', commandTypeName: 'Alpha'),
        _cmd(id: 'd', command: 'AAA_BETA', commandTypeName: 'Beta'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
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
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.first.id, 'b');
    });
  });

  // -------------------------------------------------------------------------
  // Role-specific endpoint context: all three roles use the same model type
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue role compatibility', () {
    test('superadmin: deduplicates repeated commands for a given deviceTypeId',
        () {
      final raw = [
        _cmd(id: 'sa-1', command: 'AT+SA', deviceTypeId: 10, commandTypeId: 1),
        _cmd(id: 'sa-1', command: 'AT+SA', deviceTypeId: 10, commandTypeId: 1),
      ];
      expect(
          deduplicateLiveMapCommandCatalogue(raw, selectedDeviceTypeId: 10)
              .length,
          1);
    });

    test('admin: deduplicates repeated commands for a given deviceTypeId', () {
      final raw = [
        _cmd(
            id: 'adm-1',
            command: 'AT+ADMIN',
            deviceTypeId: 5,
            commandTypeId: 2),
        _cmd(
            id: 'adm-1',
            command: 'AT+ADMIN',
            deviceTypeId: 5,
            commandTypeId: 2),
      ];
      expect(
          deduplicateLiveMapCommandCatalogue(raw, selectedDeviceTypeId: 5)
              .length,
          1);
    });

    test('user: deduplicates repeated commands for a given deviceTypeId', () {
      final raw = [
        _cmd(
            id: 'usr-1', command: 'AT+USER', deviceTypeId: 3, commandTypeId: 3),
        _cmd(
            id: 'usr-1', command: 'AT+USER', deviceTypeId: 3, commandTypeId: 3),
      ];
      expect(
          deduplicateLiveMapCommandCatalogue(raw, selectedDeviceTypeId: 3)
              .length,
          1);
    });

    test(
        'null deviceTypeId (no filter applied at API level) still deduplicates by payload',
        () {
      final raw = [
        _cmd(id: 'x', command: 'CMD', deviceTypeId: null, commandTypeId: 1),
        _cmd(id: 'y', command: 'CMD', deviceTypeId: null, commandTypeId: 2),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 1);
    });
  });

  // -------------------------------------------------------------------------
  // Stale selection scenario
  // -------------------------------------------------------------------------

  group('deduplicateLiveMapCommandCatalogue stale selection', () {
    test('command with removed ID is not present after refresh', () {
      final afterRefresh = [
        _cmd(id: 'new-id', command: 'CMD_NEW'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(afterRefresh);
      expect(result.any((c) => c.id == 'old-id'), isFalse,
          reason: 'stale selection old-id should not be present after refresh');
    });
  });
}
