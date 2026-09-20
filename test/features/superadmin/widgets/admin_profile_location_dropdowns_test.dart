import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Sample data mirroring SuperadminCountryOption → OpenVtsDropdownOption
// ---------------------------------------------------------------------------

final _countries = [
  const OpenVtsDropdownOption<String>(
    value: 'IN',
    label: 'India',
    searchText: 'India IN',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'US',
    label: 'United States',
    searchText: 'United States US',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'GB',
    label: 'United Kingdom',
    searchText: 'United Kingdom GB',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'AE',
    label: 'United Arab Emirates',
    searchText: 'United Arab Emirates AE',
  ),
];

// States for India
final _statesIN = [
  const OpenVtsDropdownOption<String>(
    value: 'MH',
    label: 'Maharashtra',
    searchText: 'Maharashtra MH',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'KA',
    label: 'Karnataka',
    searchText: 'Karnataka KA',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'DL',
    label: 'Delhi',
    searchText: 'Delhi DL',
  ),
];

// Cities for Maharashtra
final _citiesMH = [
  const OpenVtsDropdownOption<String>(
    value: 'Mumbai',
    label: 'Mumbai',
    searchText: 'Mumbai',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'Pune',
    label: 'Pune',
    searchText: 'Pune',
  ),
  const OpenVtsDropdownOption<String>(
    value: 'Nagpur',
    label: 'Nagpur',
    searchText: 'Nagpur',
  ),
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child, {bool dark = false}) => MaterialApp(
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

// ---------------------------------------------------------------------------
// Stateful cascade harness
//
// Simulates the Country→State→City cascade present in _EditProfileSheetState:
// selecting a country clears state & city and loads that country's states;
// selecting a state clears city and loads cities.
// ---------------------------------------------------------------------------

class _CascadeDropdowns extends StatefulWidget {
  const _CascadeDropdowns(
      {this.onCountryChanged, this.onStateChanged, this.onCityChanged});

  final ValueChanged<String?>? onCountryChanged;
  final ValueChanged<String?>? onStateChanged;
  final ValueChanged<String?>? onCityChanged;

  @override
  State<_CascadeDropdowns> createState() => _CascadeDropdownsState();
}

class _CascadeDropdownsState extends State<_CascadeDropdowns> {
  String? _country;
  String? _state;
  String? _city;

  List<OpenVtsDropdownOption<String>> get _stateOptions =>
      _country == 'IN' ? _statesIN : const [];

  List<OpenVtsDropdownOption<String>> get _cityOptions =>
      (_country == 'IN' && _state == 'MH') ? _citiesMH : const [];

  @override
  Widget build(BuildContext context) {
    return _wrap(
      Column(
        children: [
          OpenVtsSearchableDropdown<String>(
            label: 'Country',
            hintText: 'Select country',
            searchHintText: 'Search country name or code',
            sheetTitle: 'Country',
            value: _country,
            options: _countries,
            onChanged: (v) {
              setState(() {
                _country = v;
                _state = null;
                _city = null;
              });
              widget.onCountryChanged?.call(v);
            },
          ),
          const SizedBox(height: 12),
          OpenVtsSearchableDropdown<String>(
            label: 'State',
            hintText: 'Select state',
            searchHintText: 'Search state name or code',
            sheetTitle: 'State',
            value: _state,
            options: _stateOptions,
            onChanged: (v) {
              setState(() {
                _state = v;
                _city = null;
              });
              widget.onStateChanged?.call(v);
            },
          ),
          const SizedBox(height: 12),
          OpenVtsSearchableDropdown<String>(
            label: 'City',
            hintText: 'Select city',
            searchHintText: 'Search city',
            sheetTitle: 'City',
            value: _city,
            options: _cityOptions,
            onChanged: (v) {
              setState(() => _city = v);
              widget.onCityChanged?.call(v);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Country search tests
// ---------------------------------------------------------------------------

void main() {
  group('country dropdown — trigger state', () {
    testWidgets('label Country is visible (light)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Country',
            hintText: 'Select country',
            options: _countries,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Country'), findsOneWidget);
    });

    testWidgets('hint shown when nothing selected (dark)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Country',
            hintText: 'Select country',
            options: _countries,
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );
      expect(find.text('Select country'), findsOneWidget);
    });

    testWidgets('pre-selected country name shown in trigger', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OpenVtsSearchableDropdown<String>(
            label: 'Country',
            options: _countries,
            value: 'IN',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('India'), findsOneWidget);
    });
  });

  group('country dropdown — search by name', () {
    testWidgets('searching "india" shows India and hides others', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'india');
      await tester.pump();

      expect(find.text('India'), findsOneWidget);
      expect(find.text('United States'), findsNothing);
      expect(find.text('United Kingdom'), findsNothing);
    });

    testWidgets('searching "united" shows all United-prefixed countries', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'united');
      await tester.pump();

      expect(find.text('United States'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('United Arab Emirates'), findsOneWidget);
      expect(find.text('India'), findsNothing);
    });
  });

  group('country dropdown — search by code', () {
    testWidgets('searching "IN" shows India', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'IN');
      await tester.pump();

      expect(find.text('India'), findsOneWidget);
      expect(find.text('United States'), findsNothing);
    });

    testWidgets('searching "AE" shows United Arab Emirates', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'AE');
      await tester.pump();

      expect(find.text('United Arab Emirates'), findsOneWidget);
      expect(find.text('India'), findsNothing);
    });

    testWidgets('search is case-insensitive (lowercase "gb")', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'gb');
      await tester.pump();

      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('India'), findsNothing);
    });
  });

  group('country dropdown — selection', () {
    testWidgets('selecting India fires onChanged with country code IN', (
      tester,
    ) async {
      String? selected;
      await tester
          .pumpWidget(_CascadeDropdowns(onCountryChanged: (v) => selected = v));

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      expect(selected, 'IN');
    });

    testWidgets('trigger shows country name after selection', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      expect(find.text('India'), findsWidgets);
    });

    testWidgets('search then select returns canonical code', (tester) async {
      String? selected;
      await tester
          .pumpWidget(_CascadeDropdowns(onCountryChanged: (v) => selected = v));

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'US');
      await tester.pump();

      await tester.tap(find.text('United States'));
      await tester.pumpAndSettle();

      expect(selected, 'US');
    });
  });

  // -------------------------------------------------------------------------
  // State dropdown
  // -------------------------------------------------------------------------

  group('state dropdown — search by name', () {
    testWidgets('after selecting India, state sheet shows Indian states', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      // Select India first.
      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      // Open state dropdown.
      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      expect(find.text('Maharashtra'), findsOneWidget);
      expect(find.text('Karnataka'), findsOneWidget);
      expect(find.text('Delhi'), findsOneWidget);
    });

    testWidgets('searching "maha" filters to Maharashtra', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'maha');
      await tester.pump();

      expect(find.text('Maharashtra'), findsOneWidget);
      expect(find.text('Karnataka'), findsNothing);
      expect(find.text('Delhi'), findsNothing);
    });
  });

  group('state dropdown — search by code', () {
    testWidgets('searching "KA" shows Karnataka', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'KA');
      await tester.pump();

      expect(find.text('Karnataka'), findsOneWidget);
      expect(find.text('Maharashtra'), findsNothing);
    });

    testWidgets('searching "dl" (lowercase) shows Delhi', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'dl');
      await tester.pump();

      expect(find.text('Delhi'), findsOneWidget);
      expect(find.text('Maharashtra'), findsNothing);
    });
  });

  group('state dropdown — selection', () {
    testWidgets('selecting Maharashtra fires onChanged with code MH', (
      tester,
    ) async {
      String? selected;
      await tester
          .pumpWidget(_CascadeDropdowns(onStateChanged: (v) => selected = v));

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      expect(selected, 'MH');
    });
  });

  // -------------------------------------------------------------------------
  // City dropdown
  // -------------------------------------------------------------------------

  group('city dropdown — search by name', () {
    testWidgets('after selecting India/Maharashtra, city sheet shows cities', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      expect(find.text('Mumbai'), findsOneWidget);
      expect(find.text('Pune'), findsOneWidget);
      expect(find.text('Nagpur'), findsOneWidget);
    });

    testWidgets('searching "mum" shows only Mumbai', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'mum');
      await tester.pump();

      expect(find.text('Mumbai'), findsOneWidget);
      expect(find.text('Pune'), findsNothing);
      expect(find.text('Nagpur'), findsNothing);
    });

    testWidgets('city search is case-insensitive', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'PUNE');
      await tester.pump();

      expect(find.text('Pune'), findsOneWidget);
      expect(find.text('Mumbai'), findsNothing);
    });
  });

  group('city dropdown — selection', () {
    testWidgets('selecting Mumbai fires onChanged with "Mumbai"', (
      tester,
    ) async {
      String? selected;
      await tester
          .pumpWidget(_CascadeDropdowns(onCityChanged: (v) => selected = v));

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mumbai'));
      await tester.pumpAndSettle();

      expect(selected, 'Mumbai');
    });
  });

  // -------------------------------------------------------------------------
  // Cascade resets
  // -------------------------------------------------------------------------

  group('cascade resets', () {
    testWidgets('changing country clears state selection', (tester) async {
      String? lastState;
      await tester
          .pumpWidget(_CascadeDropdowns(onStateChanged: (v) => lastState = v));

      // Select India then a state.
      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      // State trigger now shows "Maharashtra".
      expect(find.text('Maharashtra'), findsWidgets);

      // Change country to US — state has no options for US in this harness,
      // so the state trigger must revert to its hint.
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      // Search with a partial term so the field text differs from the label.
      await tester.enterText(find.byType(TextField), 'United St');
      await tester.pump();
      await tester.tap(find.text('United States'));
      await tester.pumpAndSettle();

      // State field reverts to hint because the cascade cleared it.
      expect(find.text('Select state'), findsOneWidget);
      expect(find.text('Maharashtra'), findsNothing);
      // The onStateChanged was never called for the reset (setState-only).
      expect(lastState, 'MH');
    });

    testWidgets('changing country clears city selection', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      // Build full selection: country → state → city.
      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mumbai'));
      await tester.pumpAndSettle();

      expect(find.text('Mumbai'), findsWidgets);

      // Change country.
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('United States'));
      await tester.pumpAndSettle();

      // City must be cleared.
      expect(find.text('Select city'), findsOneWidget);
      expect(find.text('Mumbai'), findsNothing);
    });

    testWidgets('changing state clears city selection', (tester) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pune'));
      await tester.pumpAndSettle();

      expect(find.text('Pune'), findsWidgets);

      // Change state to Karnataka — no cities in this harness, so city clears.
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();

      // Partial search so the TextField text differs from the option label.
      await tester.enterText(find.byType(TextField), 'Karna');
      await tester.pump();
      await tester.tap(find.text('Karnataka'));
      await tester.pumpAndSettle();

      expect(find.text('Select city'), findsOneWidget);
      expect(find.text('Pune'), findsNothing);
    });

    testWidgets('empty search in country sheet shows all countries', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      expect(find.text('India'), findsOneWidget);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('United Arab Emirates'), findsOneWidget);
    });

    testWidgets('no-match query shows empty state without overflow', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeDropdowns());

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'ZZZZ');
      await tester.pump();

      expect(find.text('India'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
