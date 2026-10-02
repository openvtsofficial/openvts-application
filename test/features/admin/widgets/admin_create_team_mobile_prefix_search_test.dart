import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_team_model.dart';
import 'package:open_vts/features/admin/screens/team/widgets/admin_create_team_sheet.dart';

void main() {
  testWidgets('Add Team Member searches and selects a mobile prefix', (
    tester,
  ) async {
    String? selectedPrefix;
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => Form(
              key: formKey,
              child: AdminTeamMobilePrefixDropdown(
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
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Mobile prefix is required'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(AdminTeamMobilePrefixDropdown),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, '44');
    await tester.pump();
    final results = find.byType(ListView);
    final ukOption = find.descendant(
      of: results,
      matching: find.text('+44'),
    );
    expect(ukOption, findsOneWidget);
    expect(
      find.descendant(
        of: results,
        matching: find.text('United Kingdom GB'),
      ),
      findsOneWidget,
    );

    await tester.enterText(searchField, 'gb');
    await tester.pump();
    expect(ukOption, findsOneWidget);
    expect(
      find.descendant(of: results, matching: find.text('+91')),
      findsNothing,
    );

    await tester.tap(ukOption);
    await tester.pumpAndSettle();

    expect(selectedPrefix, '+44');
    expect(formKey.currentState!.validate(), isTrue);
  });
}
