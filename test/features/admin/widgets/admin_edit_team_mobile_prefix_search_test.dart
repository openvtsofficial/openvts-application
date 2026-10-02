import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_team_model.dart';
import 'package:open_vts/features/admin/screens/team/widgets/admin_create_team_sheet.dart';

void main() {
  testWidgets('Edit Team Member preserves, searches, and updates prefix', (
    tester,
  ) async {
    String? selectedPrefix = '+91';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AdminTeamMobilePrefixDropdown(
              value: selectedPrefix,
              prefixes: const [
                AdminTeamMobilePrefixOption(
                  code: '+91',
                  country: 'India IN',
                  label: 'India IN • +91',
                ),
                AdminTeamMobilePrefixOption(
                  code: '+44',
                  country: 'United Kingdom GB',
                  label: 'United Kingdom GB • +44',
                ),
              ],
              onChanged: (value) => setState(() => selectedPrefix = value),
            ),
          ),
        ),
      ),
    );

    expect(find.text('+91'), findsOneWidget);
    expect(find.text('India IN'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(AdminTeamMobilePrefixDropdown),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'kingdom');
    await tester.pump();

    final result = find.descendant(
      of: find.byType(ListView),
      matching: find.text('+44'),
    );
    expect(result, findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('+91'),
      ),
      findsNothing,
    );

    await tester.tap(result);
    await tester.pumpAndSettle();
    expect(selectedPrefix, '+44');

    final update = AdminUpdateTeamRequest(
      name: 'Alex Admin',
      email: 'alex@example.com',
      mobilePrefix: selectedPrefix!,
      mobileNumber: '7700900900',
      username: 'alex',
    );
    expect(update.toJson()['mobilePrefix'], '+44');
  });
}
