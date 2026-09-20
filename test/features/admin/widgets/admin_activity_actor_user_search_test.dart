import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_logs_model.dart';
import 'package:open_vts/features/admin/screens/logs/widgets/admin_activity_logs_panel.dart';

void main() {
  testWidgets('Actor User searches loaded users, selects, and clears', (
    tester,
  ) async {
    String? selectedUserId;
    var changes = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AdminActivityActorUserDropdown(
              value: selectedUserId,
              users: const [
                AdminLogsUserOption(
                  uid: 'uid-asha',
                  name: 'Asha Rao',
                  username: 'asha_admin',
                  loginType: 'ADMIN',
                ),
                AdminLogsUserOption(
                  uid: 'uid-bob',
                  name: 'Bob Smith',
                  username: 'bob_user',
                  loginType: 'USER',
                ),
              ],
              onChanged: (value) => setState(() {
                selectedUserId = value;
                changes++;
              }),
            ),
          ),
        ),
      ),
    );

    expect(find.text('All users'), findsOneWidget);
    final trigger = find.descendant(
      of: find.byType(AdminActivityActorUserDropdown),
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

    await tester.enterText(search, 'uid-asha');
    await tester.pump();
    expect(asha, findsOneWidget);

    await tester.tap(asha);
    await tester.pumpAndSettle();
    expect(selectedUserId, 'uid-asha');
    expect(changes, 1);

    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(selectedUserId, isNull);
    expect(changes, 2);
    expect(find.text('All users'), findsOneWidget);
  });
}
