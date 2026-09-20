// Integration-level tests for the live map command catalogue normalisation.
//
// Mirrors the acceptance criteria from the fix specification:
//   - duplicate stable ID → one option
//   - same payload with different IDs → one option
//   - same payload with different commandTypeIds → one option
//   - same payload with different deviceTypeIds in fallback → one option
//   - same title with different payloads → two distinguishable options
//   - inactive commands removed before dedup
//   - CRLF and LF payload equivalence
//   - original command payload preserved on retained record
//   - stable unique selection keys
//   - device-type filter applied when selectedDeviceTypeId is provided
//   - stale selection cleared when key no longer in catalogue

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';
import 'package:open_vts/shared/utils/command_catalogue_utils.dart';

SuperadminCustomCommand _cmd({
  required String id,
  required String command,
  int? deviceTypeId,
  int? commandTypeId,
  String? commandTypeName,
  String? deviceTypeName,
  bool isActive = true,
}) {
  return SuperadminCustomCommand(
    id: id,
    command: command,
    isActive: isActive,
    deviceTypeId: deviceTypeId,
    commandTypeId: commandTypeId,
    commandTypeName: commandTypeName,
    deviceTypeName: deviceTypeName,
  );
}

void main() {
  // -----------------------------------------------------------------------
  // Repeated API records produce one dropdown option
  // -----------------------------------------------------------------------

  group('repeated API records', () {
    test('duplicate stable ID gives one option', () {
      final raw = [
        _cmd(id: '1', command: 'AT+CMD', deviceTypeId: 5),
        _cmd(id: '1', command: 'AT+CMD', deviceTypeId: 5),
        _cmd(id: '1', command: 'AT+CMD', deviceTypeId: 5),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 1);
    });

    test('same payload with different IDs gives one option', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+CMD'),
        _cmd(id: 'b', command: 'AT+CMD'),
        _cmd(id: 'c', command: 'AT+CMD'),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 1);
    });

    test('same payload with different commandTypeIds gives one option', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+CMD', commandTypeId: 1),
        _cmd(id: 'b', command: 'AT+CMD', commandTypeId: 2),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 1);
    });

    test(
        'same payload with different deviceTypeIds in fallback (no filter) gives one option',
        () {
      final raw = [
        _cmd(id: 'a', command: 'AT+CMD', deviceTypeId: 1),
        _cmd(id: 'b', command: 'AT+CMD', deviceTypeId: 2),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 1);
    });
  });

  // -----------------------------------------------------------------------
  // Different payloads with same title remain distinguishable
  // -----------------------------------------------------------------------

  group('same title different payloads', () {
    test('keeps both commands', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+TRACK=ON', commandTypeName: 'Tracking'),
        _cmd(id: 'b', command: 'AT+TRACK=OFF', commandTypeName: 'Tracking'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 2);
    });

    test('displaySelectedLabel includes payload for disambiguation', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+TRACK=ON', commandTypeName: 'Tracking'),
        _cmd(id: 'b', command: 'AT+TRACK=OFF', commandTypeName: 'Tracking'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      final labels = result.map((c) => c.displaySelectedLabel).toList();
      // Both have same type name but different payloads → labels must differ
      expect(labels.toSet().length, 2,
          reason: 'Labels must be distinguishable for same-title commands');
    });
  });

  // -----------------------------------------------------------------------
  // All DropdownMenuItem values are unique
  // -----------------------------------------------------------------------

  group('unique dropdown values', () {
    test('stableKeys are unique across all returned items', () {
      final raw = [
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1, commandTypeId: 1),
        _cmd(id: 'b', command: 'CMD_B', deviceTypeId: 1, commandTypeId: 2),
        _cmd(id: 'a', command: 'CMD_A', deviceTypeId: 1, commandTypeId: 1),
        _cmd(id: 'c', command: 'CMD_C', deviceTypeId: 2, commandTypeId: 1),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      final keys = result.map((c) => c.stableKey).toList();
      expect(keys.toSet().length, keys.length);
    });
  });

  // -----------------------------------------------------------------------
  // Selecting a command inserts the correct original payload
  // -----------------------------------------------------------------------

  group('payload preservation', () {
    test('retained record preserves original command text (not lowercased)',
        () {
      final raw = [
        _cmd(id: 'a', command: 'AT+CMD=Value'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.first.command, 'AT+CMD=Value');
    });

    test('CRLF variant loses to LF but payload kept as original', () {
      final raw = [
        _cmd(id: 'a', command: 'LINE1\r\nLINE2'),
        _cmd(id: 'b', command: 'LINE1\nLINE2'),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      // First entry wins — its original CRLF payload is preserved
      expect(result.first.command, 'LINE1\r\nLINE2');
    });
  });

  // -----------------------------------------------------------------------
  // Inactive commands removed
  // -----------------------------------------------------------------------

  group('inactive removal', () {
    test('inactive commands are excluded before dedup', () {
      final raw = [
        _cmd(id: 'x', command: 'CMD', isActive: false),
        _cmd(id: 'y', command: 'OTHER', isActive: true),
      ];
      final result = deduplicateLiveMapCommandCatalogue(raw);
      expect(result.length, 1);
      expect(result.first.id, 'y');
    });

    test('empty catalogue does not throw when accessing items', () {
      final result = deduplicateLiveMapCommandCatalogue([]);
      expect(result, isEmpty);
      // Verify safe isEmpty check (no .first call on empty)
      expect(result.isEmpty, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // Vehicle device-type change reloads correct catalogue (stale key)
  // -----------------------------------------------------------------------

  group('stale selection after vehicle change', () {
    test('old stableKey is absent from new catalogue', () {
      final catalogue1 = deduplicateLiveMapCommandCatalogue([
        _cmd(id: 'old-cmd', command: 'AT+OLD'),
      ]);
      final oldKey = catalogue1.first.stableKey;

      final catalogue2 = deduplicateLiveMapCommandCatalogue([
        _cmd(id: 'new-cmd', command: 'AT+NEW'),
      ]);
      expect(catalogue2.any((c) => c.stableKey == oldKey), isFalse);
    });
  });

  // -----------------------------------------------------------------------
  // CRLF / LF equivalence
  // -----------------------------------------------------------------------

  group('line-ending normalisation', () {
    test('CRLF, LF, and CR variants of the same payload deduplicate to one',
        () {
      final raw = [
        _cmd(id: 'a', command: 'A\r\nB'),
        _cmd(id: 'b', command: 'A\nB'),
        _cmd(id: 'c', command: 'A\rB'),
      ];
      expect(deduplicateLiveMapCommandCatalogue(raw).length, 1);
    });
  });

  // -----------------------------------------------------------------------
  // Device-type filter: two records with same title, different deviceTypeId
  // -----------------------------------------------------------------------

  group('device-type filter with selectedDeviceTypeId', () {
    test('retains only the command matching selectedDeviceTypeId', () {
      final raw = [
        _cmd(
          id: 'a',
          command: 'AT+TRACK=ON',
          commandTypeName: 'Tracking',
          deviceTypeId: 5,
        ),
        _cmd(
          id: 'b',
          command: 'AT+TRACK=ON',
          commandTypeName: 'Tracking',
          deviceTypeId: 99,
        ),
      ];
      final result = deduplicateLiveMapCommandCatalogue(
        raw,
        selectedDeviceTypeId: 5,
      );
      expect(result.length, 1);
      expect(result.first.deviceTypeId, 5);
    });

    test('drops commands with non-null deviceTypeId that does not match', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+X', deviceTypeId: 1),
        _cmd(id: 'b', command: 'AT+Y', deviceTypeId: 2),
        _cmd(id: 'c', command: 'AT+Z', deviceTypeId: 1),
      ];
      final result = deduplicateLiveMapCommandCatalogue(
        raw,
        selectedDeviceTypeId: 1,
      );
      expect(result.length, 2);
      expect(result.every((cmd) => cmd.deviceTypeId == 1), isTrue);
    });

    test('keeps null-deviceTypeId commands regardless of selected type', () {
      final raw = [
        _cmd(id: 'a', command: 'AT+UNIVERSAL'),
        _cmd(id: 'b', command: 'AT+TYPED', deviceTypeId: 5),
        _cmd(id: 'c', command: 'AT+OTHER', deviceTypeId: 99),
      ];
      final result = deduplicateLiveMapCommandCatalogue(
        raw,
        selectedDeviceTypeId: 5,
      );
      expect(result.length, 2);
      final ids = result.map((cmd) => cmd.id).toSet();
      expect(ids.contains('a'), isTrue);
      expect(ids.contains('b'), isTrue);
    });
  });
}
