import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_logs_model.dart';
import 'package:open_vts/features/admin/screens/logs/widgets/admin_vehicle_logs_panel.dart';

void main() {
  testWidgets('Recipient/User searches, selects canonical UID, and clears', (
    tester,
  ) async {
    String? selectedUserId;
    final changes = <String?>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AdminVehicleRecipientUserDropdown(
              value: selectedUserId,
              users: const [
                AdminLogsUserOption(
                  uid: 'recipient-42',
                  name: 'Asha Rao',
                  username: 'asha_admin',
                  loginType: 'ADMIN',
                ),
                AdminLogsUserOption(
                  uid: 'recipient-99',
                  name: 'Bob Smith',
                  username: 'bob_user',
                  loginType: 'USER',
                ),
              ],
              onChanged: (value) => setState(() {
                selectedUserId = value;
                changes.add(value);
              }),
            ),
          ),
        ),
      ),
    );

    expect(find.text('All users'), findsOneWidget);
    final trigger = find.descendant(
      of: find.byType(AdminVehicleRecipientUserDropdown),
      matching: find.byType(InkWell),
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final search = find.byType(TextField).last;
    await tester.enterText(search, 'ASHA_ADMIN');
    await tester.pump();
    final results = find.byType(ListView);
    final asha = find.descendant(
      of: results,
      matching: find.text('Asha Rao'),
    );
    expect(asha, findsOneWidget);
    expect(
      find.descendant(of: results, matching: find.text('Bob Smith')),
      findsNothing,
    );

    await tester.enterText(search, 'recipient-42');
    await tester.pump();
    expect(asha, findsOneWidget);

    await tester.tap(asha);
    await tester.pumpAndSettle();
    expect(selectedUserId, 'recipient-42');
    expect(changes, ['recipient-42']);

    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(selectedUserId, isNull);
    expect(changes, ['recipient-42', null]);
    expect(find.text('All users'), findsOneWidget);
  });
}
