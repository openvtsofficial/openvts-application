import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Finder _dropdown(String label) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is OpenVtsSearchableDropdown<String> && widget.label == label,
  );
}

Future<void> _openDropdown(WidgetTester tester, String label) async {
  final trigger = _dropdown(label);
  await tester.ensureVisible(trigger);
  await tester.pumpAndSettle();
  await tester.tap(trigger);
  await tester.pumpAndSettle();
}

Finder _sheetOption(String text) {
  return find.descendant(
    of: find.byType(ListView).last,
    matching: find.text(text),
  );
}

// ---------------------------------------------------------------------------
// Standalone cascading widget (mirrors _EditProfileSheetState's cascade logic)
// ---------------------------------------------------------------------------

class _CascadeWidget extends StatefulWidget {
  const _CascadeWidget({
    required this.countries,
    required this.states,
    required this.cities,
    this.initialCountry,
    this.initialState,
    this.initialCity,
  });

  final List<OpenVtsDropdownOption<String>> countries;
  final List<OpenVtsDropdownOption<String>> states;
  final List<OpenVtsDropdownOption<String>> cities;
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;

  @override
  State<_CascadeWidget> createState() => _CascadeWidgetState();
}

class _CascadeWidgetState extends State<_CascadeWidget> {
  late String? _country;
  late String? _state;
  late String? _city;

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry;
    _state = widget.initialState;
    _city = widget.initialCity;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              OpenVtsSearchableDropdown<String>(
                label: 'Country',
                value: _country,
                options: widget.countries,
                onChanged: (v) => setState(() {
                  _country = v;
                  _state = null;
                  _city = null;
                }),
              ),
              OpenVtsSearchableDropdown<String>(
                label: 'State',
                value: _state,
                options: widget.states,
                onChanged: (v) => setState(() {
                  _state = v;
                  _city = null;
                }),
              ),
              OpenVtsSearchableDropdown<String>(
                label: 'City',
                value: _city,
                options: widget.cities,
                onChanged: (v) => setState(() => _city = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _countries = [
  OpenVtsDropdownOption<String>(
    value: 'IN',
    label: 'India',
    searchText: 'IN',
  ),
  OpenVtsDropdownOption<String>(
    value: 'US',
    label: 'United States',
    searchText: 'US',
  ),
  OpenVtsDropdownOption<String>(
    value: 'GB',
    label: 'United Kingdom',
    searchText: 'GB',
  ),
];

const _states = [
  OpenVtsDropdownOption<String>(
    value: 'MH',
    label: 'Maharashtra',
    searchText: 'MH',
  ),
  OpenVtsDropdownOption<String>(
    value: 'KA',
    label: 'Karnataka',
    searchText: 'KA',
  ),
];

const _cities = [
  OpenVtsDropdownOption<String>(value: 'city-mumbai', label: 'Mumbai'),
  OpenVtsDropdownOption<String>(value: 'city-pune', label: 'Pune'),
];

Widget _app({
  String? country,
  String? state,
  String? city,
}) {
  return _CascadeWidget(
    countries: _countries,
    states: _states,
    cities: _cities,
    initialCountry: country,
    initialState: state,
    initialCity: city,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('Country dropdown –', () {
    testWidgets('searches by label (case-insensitive)', (tester) async {
      await tester.pumpWidget(_app());
      await _openDropdown(tester, 'Country');

      await tester.enterText(find.byType(TextField).last, 'india');
      await tester.pump();

      expect(_sheetOption('India'), findsOneWidget);
      expect(_sheetOption('United States'), findsNothing);
      expect(_sheetOption('United Kingdom'), findsNothing);
    });

    testWidgets('searches by ISO code', (tester) async {
      await tester.pumpWidget(_app());
      await _openDropdown(tester, 'Country');

      await tester.enterText(find.byType(TextField).last, 'GB');
      await tester.pump();

      expect(_sheetOption('United Kingdom'), findsOneWidget);
      expect(_sheetOption('India'), findsNothing);
    });

    testWidgets('selecting a country updates the trigger', (tester) async {
      await tester.pumpWidget(_app());
      await _openDropdown(tester, 'Country');

      await tester.tap(_sheetOption('India'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('Country'))
            .value,
        'IN',
      );
    });
  });

  group('State dropdown –', () {
    testWidgets('searches by label (case-insensitive)', (tester) async {
      await tester.pumpWidget(_app(country: 'IN'));
      await _openDropdown(tester, 'State');

      await tester.enterText(find.byType(TextField).last, 'maharashtra');
      await tester.pump();

      expect(_sheetOption('Maharashtra'), findsOneWidget);
      expect(_sheetOption('Karnataka'), findsNothing);
    });

    testWidgets('searches by ISO code', (tester) async {
      await tester.pumpWidget(_app(country: 'IN'));
      await _openDropdown(tester, 'State');

      await tester.enterText(find.byType(TextField).last, 'KA');
      await tester.pump();

      expect(_sheetOption('Karnataka'), findsOneWidget);
      expect(_sheetOption('Maharashtra'), findsNothing);
    });
  });

  group('City dropdown –', () {
    testWidgets('searches by name (case-insensitive)', (tester) async {
      await tester.pumpWidget(_app(country: 'IN', state: 'MH'));
      await _openDropdown(tester, 'City');

      await tester.enterText(find.byType(TextField).last, 'PUNE');
      await tester.pump();

      expect(_sheetOption('Pune'), findsOneWidget);
      expect(_sheetOption('Mumbai'), findsNothing);
    });
  });

  group('Cascade behaviour –', () {
    testWidgets('changing country clears state and city', (tester) async {
      await tester.pumpWidget(
        _app(country: 'IN', state: 'MH', city: 'city-mumbai'),
      );

      await _openDropdown(tester, 'Country');
      await tester.tap(_sheetOption('United States'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('Country'))
            .value,
        'US',
      );
      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('State'))
            .value,
        isNull,
      );
      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('City'))
            .value,
        isNull,
      );
    });

    testWidgets('changing state clears city but keeps country', (tester) async {
      await tester.pumpWidget(
        _app(country: 'IN', state: 'MH', city: 'city-mumbai'),
      );

      await _openDropdown(tester, 'State');
      await tester.tap(_sheetOption('Karnataka'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('Country'))
            .value,
        'IN',
      );
      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('State'))
            .value,
        'KA',
      );
      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('City'))
            .value,
        isNull,
      );
    });

    testWidgets('selecting city does not clear state or country', (
      tester,
    ) async {
      await tester.pumpWidget(_app(country: 'IN', state: 'MH'));
      await _openDropdown(tester, 'City');
      await tester.tap(_sheetOption('Mumbai'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('Country'))
            .value,
        'IN',
      );
      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('State'))
            .value,
        'MH',
      );
      expect(
        tester
            .widget<OpenVtsSearchableDropdown<String>>(_dropdown('City'))
            .value,
        'city-mumbai',
      );
    });
  });
}
