import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

// ---------------------------------------------------------------------------
// Options mirroring _EditProfileSheetState._build*Options() output:
//   Country  value=code  label=name  searchText='name code'
//   State    value=code  label=name  searchText='name code'
//   City     value=name  label=name  searchText=name
// ---------------------------------------------------------------------------

const _countries = [
  OpenVtsDropdownOption<String>(
    value: 'IN',
    label: 'India',
    searchText: 'India IN',
  ),
  OpenVtsDropdownOption<String>(
    value: 'US',
    label: 'United States',
    searchText: 'United States US',
  ),
  OpenVtsDropdownOption<String>(
    value: 'GB',
    label: 'United Kingdom',
    searchText: 'United Kingdom GB',
  ),
  OpenVtsDropdownOption<String>(
    value: 'AE',
    label: 'United Arab Emirates',
    searchText: 'United Arab Emirates AE',
  ),
];

const _statesIN = [
  OpenVtsDropdownOption<String>(
    value: 'MH',
    label: 'Maharashtra',
    searchText: 'Maharashtra MH',
  ),
  OpenVtsDropdownOption<String>(
    value: 'KA',
    label: 'Karnataka',
    searchText: 'Karnataka KA',
  ),
  OpenVtsDropdownOption<String>(
    value: 'DL',
    label: 'Delhi',
    searchText: 'Delhi DL',
  ),
];

const _citiesMH = [
  OpenVtsDropdownOption<String>(
    value: 'Mumbai',
    label: 'Mumbai',
    searchText: 'Mumbai',
  ),
  OpenVtsDropdownOption<String>(
    value: 'Pune',
    label: 'Pune',
    searchText: 'Pune',
  ),
  OpenVtsDropdownOption<String>(
    value: 'Nagpur',
    label: 'Nagpur',
    searchText: 'Nagpur',
  ),
];

// ---------------------------------------------------------------------------
// Cascade harness
//
// Mirrors the state machine in _EditProfileSheetState:
//   - selecting country clears state + city, loads that country's states
//   - selecting state clears city, loads that state's cities
//   - _hasStates / _hasCities gate enabled + options
//   - _statesLoadFailed / _citiesLoadFailed stay null until a load completes
//     (preventing an API failure from being treated as "no states")
// ---------------------------------------------------------------------------

enum _LoadResult { success, empty, failure }

class _CascadeHost extends StatefulWidget {
  const _CascadeHost({
    this.onCountryChanged,
    this.onStateChanged,
    this.onCityChanged,
    this.stateLoadResult = _LoadResult.success,
    this.cityLoadResult = _LoadResult.success,
  });

  final ValueChanged<String?>? onCountryChanged;
  final ValueChanged<String?>? onStateChanged;
  final ValueChanged<String?>? onCityChanged;
  final _LoadResult stateLoadResult;
  final _LoadResult cityLoadResult;

  @override
  State<_CascadeHost> createState() => _CascadeHostState();
}

class _CascadeHostState extends State<_CascadeHost> {
  String? _country;
  String? _state;
  String? _city;

  // Mirrors _EditProfileSheetState flags.
  // null = never loaded (loading / failed). '' = loaded for this key.
  String? _statesLoadedForCountry;
  String? _citiesLoadedForState;
  bool _statesLoadFailed = false;
  bool _citiesLoadFailed = false;
  bool _loadingStates = false;
  bool _loadingCities = false;

  List<OpenVtsDropdownOption<String>> _stateOptions = const [];
  List<OpenVtsDropdownOption<String>> _cityOptions = const [];

  bool get _hasStates =>
      _statesLoadedForCountry != null && _stateOptions.isNotEmpty;
  bool get _hasCities =>
      _citiesLoadedForState != null && _cityOptions.isNotEmpty;
  bool get _statesNotApplicable =>
      _statesLoadedForCountry != null && _stateOptions.isEmpty;
  bool get _citiesNotApplicable =>
      _citiesLoadedForState != null && _cityOptions.isEmpty;

  Future<void> _loadStates(String countryCode) async {
    setState(() {
      _loadingStates = true;
      _stateOptions = const [];
      _statesLoadedForCountry = null;
      _statesLoadFailed = false;
      _citiesLoadedForState = null;
      _citiesLoadFailed = false;
    });

    // Simulate async boundary so UI shows loading state.
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    switch (widget.stateLoadResult) {
      case _LoadResult.success:
        final loaded = countryCode == 'IN'
            ? _statesIN
            : const <OpenVtsDropdownOption<String>>[];
        setState(() {
          _stateOptions = loaded;
          _loadingStates = false;
          _statesLoadedForCountry = countryCode;
          // If current state is not in the new list, clear it.
          if (_state != null && !loaded.any((s) => s.value == _state)) {
            _state = null;
            _city = null;
            _cityOptions = const [];
            _citiesLoadedForState = null;
            _citiesLoadFailed = false;
          }
        });
      case _LoadResult.empty:
        setState(() {
          _stateOptions = const [];
          _loadingStates = false;
          _statesLoadedForCountry = countryCode;
        });
      case _LoadResult.failure:
        setState(() {
          _loadingStates = false;
          _statesLoadFailed = true;
        });
    }
  }

  Future<void> _loadCities(String countryCode, String stateCode) async {
    setState(() {
      _loadingCities = true;
      _cityOptions = const [];
      _citiesLoadedForState = null;
      _citiesLoadFailed = false;
    });

    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    switch (widget.cityLoadResult) {
      case _LoadResult.success:
        final loaded = (countryCode == 'IN' && stateCode == 'MH')
            ? _citiesMH
            : const <OpenVtsDropdownOption<String>>[];
        setState(() {
          _cityOptions = loaded;
          _loadingCities = false;
          _citiesLoadedForState = stateCode;
        });
      case _LoadResult.empty:
        setState(() {
          _cityOptions = const [];
          _loadingCities = false;
          _citiesLoadedForState = stateCode;
        });
      case _LoadResult.failure:
        setState(() {
          _loadingCities = false;
          _citiesLoadFailed = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              OpenVtsSearchableDropdown<String>(
                label: 'Country',
                hintText: 'Select country',
                searchHintText: 'Search country name or code',
                sheetTitle: 'Select Country',
                options: _countries,
                value: _country,
                onChanged: (v) {
                  setState(() {
                    _country = v;
                    _state = null;
                    _city = null;
                    _stateOptions = const [];
                    _cityOptions = const [];
                    _statesLoadedForCountry = null;
                    _statesLoadFailed = false;
                    _citiesLoadedForState = null;
                    _citiesLoadFailed = false;
                  });
                  widget.onCountryChanged?.call(v);
                  if (v != null) _loadStates(v);
                },
              ),
              const SizedBox(height: 12),
              OpenVtsSearchableDropdown<String>(
                label: 'State',
                hintText: _loadingStates
                    ? 'Loading…'
                    : _statesLoadFailed
                        ? 'Failed to load — retry'
                        : _statesNotApplicable
                            ? 'Not applicable'
                            : 'Select state',
                searchHintText: 'Search state name or code',
                sheetTitle: 'Select State',
                options: _stateOptions,
                value: _hasStates ? _state : null,
                enabled: _hasStates,
                isLoading: _loadingStates,
                onChanged: (v) {
                  setState(() {
                    _state = v;
                    _city = null;
                    _cityOptions = const [];
                    _citiesLoadedForState = null;
                    _citiesLoadFailed = false;
                  });
                  widget.onStateChanged?.call(v);
                  if (v != null && _country != null) _loadCities(_country!, v);
                },
              ),
              const SizedBox(height: 12),
              OpenVtsSearchableDropdown<String>(
                label: 'City',
                hintText: _loadingCities
                    ? 'Loading…'
                    : _citiesLoadFailed
                        ? 'Failed to load — retry'
                        : _citiesNotApplicable
                            ? 'Not applicable'
                            : (_hasStates && _state != null)
                                ? 'Select city'
                                : 'Not applicable',
                searchHintText: 'Search city',
                sheetTitle: 'Select City',
                options: _cityOptions,
                value: _hasCities ? _city : null,
                enabled: _hasCities,
                isLoading: _loadingCities,
                onChanged: (v) {
                  setState(() => _city = v);
                  widget.onCityChanged?.call(v);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Scopes text matching to the picker BottomSheet only.
Finder _inPicker(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );

Finder _searchField(String hint) => find.widgetWithText(TextField, hint);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // --------------------------------------------------------------------------
  // Field type assertions
  // --------------------------------------------------------------------------

  group('profile settings location — field types', () {
    testWidgets('all three location fields use OpenVtsSearchableDropdown', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      expect(
        find.byType(OpenVtsSearchableDropdown<String>),
        findsNWidgets(3),
      );
      expect(find.byType(DropdownButton<String>), findsNothing);
    });

    testWidgets('country hint is "Select country" when nothing selected', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      expect(find.text('Select country'), findsOneWidget);
    });

    testWidgets(
        'state shows "Select state" hint after a country with states is loaded',
        (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      // Select India; states load asynchronously.
      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle(); // loads states

      expect(find.text('Select state'), findsOneWidget);
    });

    testWidgets(
        'city shows "Select city" hint after a state with cities is loaded', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle(); // loads cities

      expect(find.text('Select city'), findsOneWidget);
    });
  });

  // --------------------------------------------------------------------------
  // Country search
  // --------------------------------------------------------------------------

  group('profile settings location — country search by name', () {
    testWidgets('searching "india" shows only India', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search country name or code'),
        'india',
      );
      await tester.pump();

      expect(_inPicker('India'), findsOneWidget);
      expect(_inPicker('United States'), findsNothing);
      expect(_inPicker('United Kingdom'), findsNothing);
    });

    testWidgets('searching "united" shows all United-prefixed countries', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search country name or code'),
        'united',
      );
      await tester.pump();

      expect(_inPicker('United States'), findsOneWidget);
      expect(_inPicker('United Kingdom'), findsOneWidget);
      expect(_inPicker('United Arab Emirates'), findsOneWidget);
      expect(_inPicker('India'), findsNothing);
    });
  });

  group('profile settings location — country search by code', () {
    testWidgets('searching "IN" shows India', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search country name or code'),
        'IN',
      );
      await tester.pump();

      expect(_inPicker('India'), findsOneWidget);
      expect(_inPicker('United States'), findsNothing);
    });

    testWidgets('searching "AE" shows United Arab Emirates', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search country name or code'),
        'AE',
      );
      await tester.pump();

      expect(_inPicker('United Arab Emirates'), findsOneWidget);
      expect(_inPicker('India'), findsNothing);
    });

    testWidgets('country search is case-insensitive ("gb" → United Kingdom)', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search country name or code'),
        'gb',
      );
      await tester.pump();

      expect(_inPicker('United Kingdom'), findsOneWidget);
      expect(_inPicker('India'), findsNothing);
    });
  });

  group('profile settings location — country selection', () {
    testWidgets('selecting fires onChanged with country code', (tester) async {
      String? captured;
      await tester.pumpWidget(
        _CascadeHost(onCountryChanged: (v) => captured = v),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      expect(captured, 'IN');
    });

    testWidgets('search then select returns canonical code', (tester) async {
      String? captured;
      await tester.pumpWidget(
        _CascadeHost(onCountryChanged: (v) => captured = v),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.enterText(
        _searchField('Search country name or code'),
        'US',
      );
      await tester.pump();
      await tester.tap(_inPicker('United States'));
      await tester.pumpAndSettle();

      expect(captured, 'US');
    });

    testWidgets('trigger shows country name after selection', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      expect(find.text('India'), findsWidgets);
    });
  });

  // --------------------------------------------------------------------------
  // State search
  // --------------------------------------------------------------------------

  group('profile settings location — state search', () {
    testWidgets('after selecting India, state picker shows Indian states', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      expect(_inPicker('Maharashtra'), findsOneWidget);
      expect(_inPicker('Karnataka'), findsOneWidget);
      expect(_inPicker('Delhi'), findsOneWidget);
    });

    testWidgets('searching "maha" filters to Maharashtra', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search state name or code'),
        'maha',
      );
      await tester.pump();

      expect(_inPicker('Maharashtra'), findsOneWidget);
      expect(_inPicker('Karnataka'), findsNothing);
      expect(_inPicker('Delhi'), findsNothing);
    });

    testWidgets('searching "KA" shows Karnataka', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search state name or code'),
        'KA',
      );
      await tester.pump();

      expect(_inPicker('Karnataka'), findsOneWidget);
      expect(_inPicker('Maharashtra'), findsNothing);
    });

    testWidgets('state search is case-insensitive ("dl" → Delhi)', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search state name or code'),
        'dl',
      );
      await tester.pump();

      expect(_inPicker('Delhi'), findsOneWidget);
      expect(_inPicker('Maharashtra'), findsNothing);
    });
  });

  group('profile settings location — state selection', () {
    testWidgets('selecting Maharashtra fires onChanged with code MH', (
      tester,
    ) async {
      String? captured;
      await tester.pumpWidget(
        _CascadeHost(onStateChanged: (v) => captured = v),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      expect(captured, 'MH');
    });
  });

  // --------------------------------------------------------------------------
  // City search
  // --------------------------------------------------------------------------

  group('profile settings location — city search', () {
    testWidgets('after selecting IN/MH, city picker shows cities', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      expect(_inPicker('Mumbai'), findsOneWidget);
      expect(_inPicker('Pune'), findsOneWidget);
      expect(_inPicker('Nagpur'), findsOneWidget);
    });

    testWidgets('searching "mum" shows only Mumbai', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField('Search city'), 'mum');
      await tester.pump();

      expect(_inPicker('Mumbai'), findsOneWidget);
      expect(_inPicker('Pune'), findsNothing);
      expect(_inPicker('Nagpur'), findsNothing);
    });

    testWidgets('city search is case-insensitive ("PUNE" → Pune)', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();

      await tester.enterText(_searchField('Search city'), 'PUNE');
      await tester.pump();

      expect(_inPicker('Pune'), findsOneWidget);
      expect(_inPicker('Mumbai'), findsNothing);
    });
  });

  group('profile settings location — city selection', () {
    testWidgets('selecting Mumbai fires onChanged with "Mumbai"', (
      tester,
    ) async {
      String? captured;
      await tester.pumpWidget(
        _CascadeHost(onCityChanged: (v) => captured = v),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Mumbai'));
      await tester.pumpAndSettle();

      expect(captured, 'Mumbai');
    });
  });

  // --------------------------------------------------------------------------
  // Cascade resets
  // --------------------------------------------------------------------------

  group('profile settings location — cascade resets', () {
    testWidgets('changing country clears state and city', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      // Full selection: India → Maharashtra → Mumbai.
      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Mumbai'));
      await tester.pumpAndSettle();

      expect(find.text('Maharashtra'), findsWidgets);
      expect(find.text('Mumbai'), findsWidgets);

      // Change country to US — harness loads empty states for non-IN countries,
      // so hint becomes "Not applicable" and the dropdown is disabled.
      await tester.tap(find.text('India'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('United States'));
      await tester.pumpAndSettle();

      // Previous state and city selections must be cleared.
      expect(find.text('Maharashtra'), findsNothing);
      expect(find.text('Mumbai'), findsNothing);
      // State is disabled (no states for US).
      final stateWidget = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'State',
        ),
      );
      expect(stateWidget.enabled, isFalse);
    });

    testWidgets('changing state clears city', (tester) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select city'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Pune'));
      await tester.pumpAndSettle();

      expect(find.text('Pune'), findsWidgets);

      // Change state to Karnataka (no cities in harness).
      await tester.tap(find.text('Maharashtra'));
      await tester.pumpAndSettle();
      await tester.enterText(
        _searchField('Search state name or code'),
        'Karna',
      );
      await tester.pump();
      await tester.tap(_inPicker('Karnataka'));
      await tester.pumpAndSettle();

      // Previous city selection must be cleared.
      expect(find.text('Pune'), findsNothing);
      // City is disabled (no cities for Karnataka in harness).
      final cityWidget = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'City',
        ),
      );
      expect(cityWidget.enabled, isFalse);
    });
  });

  // --------------------------------------------------------------------------
  // Enabled / disabled semantics
  // --------------------------------------------------------------------------

  group('profile settings location — enabled semantics', () {
    testWidgets('state dropdown is disabled before country is selected', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      final state = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'State',
        ),
      );
      expect(state.enabled, isFalse);
    });

    testWidgets('city dropdown is disabled before state is selected', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      final city = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'City',
        ),
      );
      expect(city.enabled, isFalse);
    });

    testWidgets('state enabled after country-with-states is selected', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      final state = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'State',
        ),
      );
      expect(state.enabled, isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // API failure does NOT clear hierarchy
  // --------------------------------------------------------------------------

  group('profile settings location — API failure semantics', () {
    testWidgets(
        'state load failure keeps state disabled (not "not applicable")', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _CascadeHost(stateLoadResult: _LoadResult.failure),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      // State dropdown should not be enabled (failure ≠ "no states").
      final state = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'State',
        ),
      );
      expect(state.enabled, isFalse);
      // The hint communicates the failure, not "Not applicable".
      expect(find.text('Failed to load — retry'), findsOneWidget);
    });

    testWidgets('city load failure keeps city disabled', (tester) async {
      await tester.pumpWidget(
        const _CascadeHost(cityLoadResult: _LoadResult.failure),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('Maharashtra'));
      await tester.pumpAndSettle();

      final city = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'City',
        ),
      );
      expect(city.enabled, isFalse);
      expect(find.text('Failed to load — retry'), findsOneWidget);
    });
  });

  // --------------------------------------------------------------------------
  // No-states / no-cities countries
  // --------------------------------------------------------------------------

  group('profile settings location — empty location hierarchy', () {
    testWidgets(
        'country with no states shows "Not applicable" and keeps state disabled',
        (tester) async {
      await tester.pumpWidget(
        const _CascadeHost(stateLoadResult: _LoadResult.empty),
      );
      await tester.pumpAndSettle();

      // Select US — harness returns empty states for non-IN countries.
      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('United States'));
      await tester.pumpAndSettle();

      final state = tester.widget<OpenVtsSearchableDropdown<String>>(
        find.byWidgetPredicate(
          (w) => w is OpenVtsSearchableDropdown<String> && w.label == 'State',
        ),
      );
      expect(state.enabled, isFalse);
      expect(find.text('Not applicable'), findsAtLeast(1));
    });
  });

  // --------------------------------------------------------------------------
  // No-match empty state
  // --------------------------------------------------------------------------

  group('profile settings location — no-match state', () {
    testWidgets('no-match query in country shows empty state without throwing',
        (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search country name or code'),
        'ZZZZ',
      );
      await tester.pump();

      expect(_inPicker('India'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('no-match query in state shows empty state without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(const _CascadeHost());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select country'));
      await tester.pumpAndSettle();
      await tester.tap(_inPicker('India'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();

      await tester.enterText(
        _searchField('Search state name or code'),
        'ZZZZ',
      );
      await tester.pump();

      expect(_inPicker('Maharashtra'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
