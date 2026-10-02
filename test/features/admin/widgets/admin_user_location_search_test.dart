import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/screens/users/widgets/admin_user_form_fields.dart';

Finder _dropdown(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is AdminUserDropdownField && widget.label == label,
  );
}

Future<void> _openDropdown(WidgetTester tester, String label) async {
  final trigger = find.descendant(
    of: _dropdown(label),
    matching: find.byType(GestureDetector),
  );
  await tester.tap(trigger);
  await tester.pumpAndSettle();
}

Widget _singleDropdown({
  required String label,
  required List<AdminUserDropdownOption> options,
  required ValueChanged<String?> onChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: AdminUserDropdownField(
        label: label,
        value: options.first.value,
        options: options,
        searchable: true,
        onChanged: onChanged,
      ),
    ),
  );
}

class _CascadingLocationFields extends StatefulWidget {
  const _CascadingLocationFields();

  @override
  State<_CascadingLocationFields> createState() =>
      _CascadingLocationFieldsState();
}

class _CascadingLocationFieldsState extends State<_CascadingLocationFields> {
  String? _country = 'IN';
  String? _state = 'MH';
  String? _city = 'city-mumbai';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            AdminUserDropdownField(
              label: 'Country',
              value: _country,
              options: const [
                AdminUserDropdownOption(value: 'IN', label: 'India'),
                AdminUserDropdownOption(value: 'US', label: 'United States'),
              ],
              searchable: true,
              onChanged: (value) => setState(() {
                _country = value;
                _state = null;
                _city = null;
              }),
            ),
            AdminUserDropdownField(
              label: 'State',
              value: _state,
              options: const [
                AdminUserDropdownOption(value: 'MH', label: 'Maharashtra'),
              ],
              searchable: true,
              onChanged: (_) {},
            ),
            AdminUserDropdownField(
              label: 'City',
              value: _city,
              options: const [
                AdminUserDropdownOption(
                  value: 'city-mumbai',
                  label: 'Mumbai',
                ),
              ],
              searchable: true,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final searchCases = <({
    String label,
    String query,
    String result,
    String value,
    List<AdminUserDropdownOption> options,
  })>[
    (
      label: 'Country',
      query: 'united',
      result: 'United States',
      value: 'US',
      options: const [
        AdminUserDropdownOption(value: 'IN', label: 'India'),
        AdminUserDropdownOption(value: 'US', label: 'United States'),
      ],
    ),
    (
      label: 'State',
      query: 'maharashtra',
      result: 'Maharashtra',
      value: 'MH',
      options: const [
        AdminUserDropdownOption(value: 'KA', label: 'Karnataka'),
        AdminUserDropdownOption(value: 'MH', label: 'Maharashtra'),
      ],
    ),
    (
      label: 'City',
      query: 'mumbai',
      result: 'Mumbai',
      value: 'city-mumbai',
      options: const [
        AdminUserDropdownOption(value: 'city-pune', label: 'Pune'),
        AdminUserDropdownOption(value: 'city-mumbai', label: 'Mumbai'),
      ],
    ),
  ];

  for (final searchCase in searchCases) {
    testWidgets('${searchCase.label} searches locally and returns its ID', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _singleDropdown(
          label: searchCase.label,
          options: searchCase.options,
          onChanged: (value) => selected = value,
        ),
      );

      await _openDropdown(tester, searchCase.label);
      await tester.enterText(find.byType(TextField), searchCase.query);
      await tester.pump();

      expect(find.text(searchCase.result), findsOneWidget);
      await tester.tap(find.text(searchCase.result));
      await tester.pumpAndSettle();
      expect(selected, searchCase.value);
    });
  }

  testWidgets('changing country resets state and city selections', (
    tester,
  ) async {
    await tester.pumpWidget(const _CascadingLocationFields());

    await _openDropdown(tester, 'Country');
    await tester.tap(find.text('United States'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<AdminUserDropdownField>(_dropdown('Country')).value,
      'US',
    );
    expect(
      tester.widget<AdminUserDropdownField>(_dropdown('State')).value,
      isNull,
    );
    expect(
      tester.widget<AdminUserDropdownField>(_dropdown('City')).value,
      isNull,
    );
  });
}
