import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_form_fields.dart';

void main() {
  testWidgets(
    'driver edit mobile prefix searches dial and country codes and selects value',
    (tester) async {
      String? selectedPrefix = '+91';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => AdminUserDropdownField(
                label: 'Mobile Prefix',
                value: selectedPrefix,
                options: const [
                  AdminUserDropdownOption(value: '+91', label: '+91 IN'),
                  AdminUserDropdownOption(value: '+44', label: '+44 GB'),
                ],
                searchable: true,
                onChanged: (value) => setState(() => selectedPrefix = value),
              ),
            ),
          ),
        ),
      );

      expect(find.text('+91 IN'), findsOneWidget);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField).last;
      await tester.enterText(searchField, '44');
      await tester.pump();
      final results = find.byType(ListView);
      expect(
        find.descendant(of: results, matching: find.text('+44 GB')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: results, matching: find.text('+91 IN')),
        findsNothing,
      );

      await tester.enterText(searchField, 'gb');
      await tester.pump();
      expect(
        find.descendant(of: results, matching: find.text('+44 GB')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: results, matching: find.text('+91 IN')),
        findsNothing,
      );

      await tester.tap(find.text('+44 GB'));
      await tester.pumpAndSettle();

      expect(selectedPrefix, '+44');
      expect(find.text('+44 GB'), findsOneWidget);
    },
  );
}
