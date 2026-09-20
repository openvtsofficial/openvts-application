// Widget tests for Admin → Vehicle Details → Commands → Template dropdown.
//
// Covers section J of the fix specification:
//   - normal command selection fills correct command text
//   - stale selected ID cleared when commands reload (didUpdateWidget)
//   - same-type commands show distinct labels so each is selectable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/screens/vehicles/widgets/admin_vehicle_commands_tab.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminCustomCommand _cmd({
  required String id,
  required String command,
  String? commandTypeName,
}) {
  return SuperadminCustomCommand(
    id: id,
    command: command,
    isActive: true,
    commandTypeName: commandTypeName,
  );
}

AdminVehicleDetails _vehicle({String imei = '123456789012345'}) {
  return AdminVehicleDetails(
    id: '1',
    name: 'Test',
    vin: '',
    plateNumber: 'ABC123',
    isActive: true,
    isLicenseBlocked: false,
    createdAt: null,
    updatedAt: null,
    imei: imei,
    simNumber: '',
    vehicleType: null,
    vehicleTypeId: '',
    device: null,
    primaryUser: null,
    gmtOffset: '',
    vehicleMeta: const {},
    plan: null,
  );
}

Widget _buildTab({
  required List<AdminCustomCommand> commands,
  String imei = '123456789012345',
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: AdminVehicleCommandsTab(
          vehicle: _vehicle(imei: imei),
          customCommands: commands,
          systemVariables: const [],
          history: const [],
          isLoading: false,
          isSending: false,
          onRefresh: () async {},
          onSend: ({required String command, String? note}) async {},
          onPollStatus: (_) async => null,
          onFetchCommandLog: (_) async => null,
        ),
      ),
    ),
  );
}

// Harness that can rebuild the tab with a different command list to test
// didUpdateWidget / stale-selection clearing.
class _Harness extends StatefulWidget {
  const _Harness({super.key, required this.initial});
  final List<AdminCustomCommand> initial;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late List<AdminCustomCommand> _commands;

  @override
  void initState() {
    super.initState();
    _commands = widget.initial;
  }

  void update(List<AdminCustomCommand> next) =>
      setState(() => _commands = next);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: AdminVehicleCommandsTab(
            vehicle: _vehicle(),
            customCommands: _commands,
            systemVariables: const [],
            history: const [],
            isLoading: false,
            isSending: false,
            onRefresh: () async {},
            onSend: ({required String command, String? note}) async {},
            onPollStatus: (_) async => null,
            onFetchCommandLog: (_) async => null,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminVehicleCommandsTab — no IMEI', () {
    testWidgets('shows unavailable state when IMEI is empty', (tester) async {
      await tester.pumpWidget(_buildTab(commands: const [], imei: ''));
      expect(find.text('Command unavailable'), findsOneWidget);
    });
  });

  group('AdminVehicleCommandsTab — normal command selection', () {
    testWidgets('selecting a template fills the command text field',
        (tester) async {
      final commands = [
        _cmd(id: 'cmd-1', command: 'AT+TRACK=1', commandTypeName: 'Tracking'),
        _cmd(id: 'cmd-2', command: 'AT+LOCK=0', commandTypeName: 'Engine Lock'),
      ];

      await tester.pumpWidget(_buildTab(commands: commands));
      await tester.pump();

      // Hint visible before any selection.
      expect(find.text('Select command template'), findsOneWidget);

      // Open dropdown.
      await tester.tap(find.text('Select command template'));
      await tester.pumpAndSettle();

      // Both items appear with distinct labels (displaySelectedLabel format).
      expect(find.text('Tracking — AT+TRACK=1'), findsWidgets);
      expect(find.text('Engine Lock — AT+LOCK=0'), findsWidgets);

      // Tap 'Engine Lock — AT+LOCK=0' in the overlay (last match).
      await tester.tap(find.text('Engine Lock — AT+LOCK=0').last);
      await tester.pumpAndSettle();

      // The command text field should now contain the payload.
      final editableTexts =
          tester.widgetList<EditableText>(find.byType(EditableText)).toList();
      expect(
        editableTexts.any((e) => e.controller.text == 'AT+LOCK=0'),
        isTrue,
        reason: 'Command text field must contain the selected template payload',
      );
    });

    testWidgets(
        'selecting second of two same-type templates fills different payload',
        (tester) async {
      final commands = [
        _cmd(id: 'cmd-1', command: 'AT+LOCK=1', commandTypeName: 'Engine Lock'),
        _cmd(id: 'cmd-2', command: 'AT+LOCK=0', commandTypeName: 'Engine Lock'),
      ];

      await tester.pumpWidget(_buildTab(commands: commands));
      await tester.pump();

      await tester.tap(find.text('Select command template'));
      await tester.pumpAndSettle();

      // Both items must have distinct labels.
      expect(find.text('Engine Lock — AT+LOCK=1'), findsWidgets);
      expect(find.text('Engine Lock — AT+LOCK=0'), findsWidgets);

      // Select the second one.
      await tester.tap(find.text('Engine Lock — AT+LOCK=0').last);
      await tester.pumpAndSettle();

      final editableTexts =
          tester.widgetList<EditableText>(find.byType(EditableText)).toList();
      expect(
        editableTexts.any((e) => e.controller.text == 'AT+LOCK=0'),
        isTrue,
      );
    });
  });

  group('AdminVehicleCommandsTab — stale selection cleared on reload', () {
    testWidgets('hint is restored when selected ID disappears after reload',
        (tester) async {
      final harnessKey = GlobalKey<_HarnessState>();

      final initial = [
        _cmd(id: 'cmd-1', command: 'AT+TRACK=1', commandTypeName: 'Tracking'),
        _cmd(id: 'cmd-2', command: 'AT+LOCK=0', commandTypeName: 'Engine Lock'),
      ];

      await tester.pumpWidget(_Harness(key: harnessKey, initial: initial));
      await tester.pump();

      // Select cmd-2.
      await tester.tap(find.text('Select command template'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Engine Lock — AT+LOCK=0').last);
      await tester.pumpAndSettle();

      // Verify selection is active: hint gone, payload in command field.
      expect(find.text('Select command template'), findsNothing);

      // Reload with a list that no longer contains cmd-2.
      harnessKey.currentState!.update([
        _cmd(id: 'cmd-1', command: 'AT+TRACK=1', commandTypeName: 'Tracking'),
      ]);
      await tester.pumpAndSettle();

      // Selection cleared — hint visible again.
      expect(find.text('Select command template'), findsOneWidget);
    });
  });
}
