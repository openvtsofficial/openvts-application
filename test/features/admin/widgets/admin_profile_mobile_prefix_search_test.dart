import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/screens/settings/widgets/admin_profile_settings_section.dart';

void main() {
  testWidgets('Profile Prefix preserves selection and searches dial/country', (
    tester,
  ) async {
    String? selectedPrefix = '+91';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AdminProfileMobilePrefixDropdown(
              value: selectedPrefix,
              prefixes: const [
                AdminUserMobilePrefixOption(
                  value: '+91',
                  label: '+91 (IN)',
                  countryCode: 'IN',
                ),
                AdminUserMobilePrefixOption(
                  value: '+44',
                  label: '+44 (GB)',
                  countryCode: 'GB',
                ),
              ],
              onChanged: (value) => setState(() => selectedPrefix = value),
            ),
          ),
        ),
      ),
    );

    expect(find.text('+91 (IN)'), findsOneWidget);
    final trigger = find.descendant(
      of: find.byType(AdminProfileMobilePrefixDropdown),
      matching: find.byType(InkWell),
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final search = find.byType(TextField).last;
    final results = find.byType(ListView);
    final gb = find.descendant(
      of: results,
      matching: find.text('+44 (GB)'),
    );

    await tester.enterText(search, '44');
    await tester.pump();
    expect(gb, findsOneWidget);
    expect(
      find.descendant(of: results, matching: find.text('+91 (IN)')),
      findsNothing,
    );

    await tester.enterText(search, 'gb');
    await tester.pump();
    expect(gb, findsOneWidget);

    await tester.tap(gb);
    await tester.pumpAndSettle();
    expect(selectedPrefix, '+44');
    expect(find.text('+44 (GB)'), findsOneWidget);
  });
}
