import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_form_fields.dart';

Finder _dropdown(String label) => find.byWidgetPredicate(
      (widget) => widget is AdminUserDropdownField && widget.label == label,
    );

Future<void> _open(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: _dropdown(label),
      matching: find.byType(GestureDetector),
    ),
  );
  await tester.pumpAndSettle();
}

class _DriverEditLocationHarness extends StatefulWidget {
  const _DriverEditLocationHarness();

  @override
  State<_DriverEditLocationHarness> createState() =>
      _DriverEditLocationHarnessState();
}

class _DriverEditLocationHarnessState
    extends State<_DriverEditLocationHarness> {
  String? country = 'IN';
  String? state = 'MH';
  String? city = 'mumbai';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            AdminUserDropdownField(
              label: 'Country',
              value: country,
              options: const [
                AdminUserDropdownOption(value: 'IN', label: 'India'),
                AdminUserDropdownOption(value: 'US', label: 'United States'),
              ],
              searchable: true,
              onChanged: (value) => setState(() {
                country = value;
                state = null;
                city = null;
              }),
            ),
            AdminUserDropdownField(
              label: 'State',
              value: state,
              options: const [
                AdminUserDropdownOption(value: 'MH', label: 'Maharashtra'),
                AdminUserDropdownOption(value: 'KA', label: 'Karnataka'),
              ],
              searchable: true,
              onChanged: (value) => setState(() {
                state = value;
                city = null;
              }),
            ),
            AdminUserDropdownField(
              label: 'City',
              value: city,
              options: const [
                AdminUserDropdownOption(value: 'mumbai', label: 'Mumbai'),
                AdminUserDropdownOption(value: 'pune', label: 'Pune'),
              ],
              searchable: true,
              onChanged: (value) => setState(() => city = value),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  for (final searchCase in const [
    (label: 'Country', query: 'united', result: 'United States', value: 'US'),
    (label: 'State', query: 'karna', result: 'Karnataka', value: 'KA'),
    (label: 'City', query: 'pune', result: 'Pune', value: 'pune'),
  ]) {
    testWidgets('Driver Edit ${searchCase.label} searches loaded options', (
      tester,
    ) async {
      await tester.pumpWidget(const _DriverEditLocationHarness());
      await _open(tester, searchCase.label);

      await tester.enterText(find.byType(TextField).last, searchCase.query);
      await tester.pump();

      final result = find.descendant(
        of: find.byType(ListView),
        matching: find.text(searchCase.result),
      );
      expect(result, findsOneWidget);
      await tester.tap(result);
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<AdminUserDropdownField>(_dropdown(searchCase.label))
            .value,
        searchCase.value,
      );
    });
  }

  testWidgets('changing country resets state and city', (tester) async {
    await tester.pumpWidget(const _DriverEditLocationHarness());
    await _open(tester, 'Country');
    await tester.tap(find.text('United States'));
    await tester.pumpAndSettle();

    expect(tester.widget<AdminUserDropdownField>(_dropdown('State')).value,
        isNull);
    expect(
        tester.widget<AdminUserDropdownField>(_dropdown('City')).value, isNull);
  });

  testWidgets('changing state resets city', (tester) async {
    await tester.pumpWidget(const _DriverEditLocationHarness());
    await _open(tester, 'State');
    await tester.tap(find.text('Karnataka'));
    await tester.pumpAndSettle();

    expect(
        tester.widget<AdminUserDropdownField>(_dropdown('State')).value, 'KA');
    expect(
        tester.widget<AdminUserDropdownField>(_dropdown('City')).value, isNull);
  });
}
