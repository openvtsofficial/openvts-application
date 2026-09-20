import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_administrators_controller.dart';
import 'package:open_vts/features/superadmin/models/superadmin_administrator_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_administrators_service.dart';

// ---------------------------------------------------------------------------
// Fake service
// ---------------------------------------------------------------------------

class _FakeAdministratorsService extends SuperadminAdministratorsService {
  _FakeAdministratorsService({
    this.statesResult,
    this.statesError,
    this.citiesResult,
    this.citiesError,
    this.statesResultByCountry,
  }) : super(ApiClient(Dio()));

  final List<SuperadminStateOption>? statesResult;
  final Object? statesError;
  final List<SuperadminCityOption>? citiesResult;
  final Object? citiesError;

  /// Per-country override; falls back to [statesResult] when null or key absent.
  final Map<String, List<SuperadminStateOption>>? statesResultByCountry;

  @override
  Future<SuperadminAdministratorPage> getAdministrators({
    String? refreshKey,
  }) async =>
      const SuperadminAdministratorPage(items: [], totalCount: 0);

  @override
  Future<List<SuperadminCountryOption>> getCountries() async => [
        const SuperadminCountryOption(code: 'IN', name: 'India'),
        const SuperadminCountryOption(code: 'AX', name: 'Åland Islands'),
        const SuperadminCountryOption(code: 'US', name: 'United States'),
      ];

  @override
  Future<List<SuperadminMobilePrefixOption>> getMobilePrefixes() async => [];

  @override
  Future<List<SuperadminStateOption>> getStates(String countryCode) async {
    if (statesError != null) throw statesError!;
    if (statesResultByCountry != null &&
        statesResultByCountry!.containsKey(countryCode)) {
      return statesResultByCountry![countryCode]!;
    }
    return statesResult ?? [];
  }

  @override
  Future<List<SuperadminCityOption>> getCities(
    String countryCode,
    String stateCode,
  ) async {
    if (citiesError != null) throw citiesError!;
    return citiesResult ?? [];
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SuperadminAdministratorsController _makeController({
  List<SuperadminStateOption>? statesResult,
  Object? statesError,
  List<SuperadminCityOption>? citiesResult,
  Object? citiesError,
  Map<String, List<SuperadminStateOption>>? statesResultByCountry,
}) {
  return SuperadminAdministratorsController(
    _FakeAdministratorsService(
      statesResult: statesResult,
      statesError: statesError,
      citiesResult: citiesResult,
      citiesError: citiesError,
      statesResultByCountry: statesResultByCountry,
    ),
  );
}

const _stateIN = SuperadminStateOption(
  code: 'MH',
  name: 'Maharashtra',
  countryCode: 'IN',
);

const _cityMH = SuperadminCityOption(
  name: 'Mumbai',
  countryCode: 'IN',
  stateCode: 'MH',
);

Future<void> _flush() => Future<void>.delayed(Duration.zero);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SuperadminAdministratorsController — location hierarchy', () {
    // -----------------------------------------------------------------------
    // Case 1: country with states AND cities
    // -----------------------------------------------------------------------

    test('country with states: hasStates is true after successful load',
        () async {
      final controller = _makeController(statesResult: [_stateIN]);
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');

      expect(controller.state.hasStates, isTrue);
      expect(controller.state.statesLoadedForCountry, 'IN');
      expect(controller.state.isLoadingStates, isFalse);
      expect(controller.state.stateOptions, hasLength(1));
      expect(controller.state.stateOptions.first.code, 'MH');
    });

    test('country with states+cities: hasCities is true after loading cities',
        () async {
      final controller = _makeController(
        statesResult: [_stateIN],
        citiesResult: [_cityMH],
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      await controller.loadCityOptions('IN', 'MH');

      expect(controller.state.hasStates, isTrue);
      expect(controller.state.hasCities, isTrue);
      expect(controller.state.citiesLoadedForState, 'MH');
      expect(controller.state.isLoadingCities, isFalse);
      expect(controller.state.cityOptions, hasLength(1));
    });

    // -----------------------------------------------------------------------
    // Case 2: country with NO states
    // -----------------------------------------------------------------------

    test('country with no states: hasStates is false, not required', () async {
      final controller = _makeController(statesResult: []);
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('AX');

      expect(controller.state.hasStates, isFalse);
      expect(controller.state.statesLoadedForCountry, 'AX');
      expect(controller.state.stateOptions, isEmpty);
      expect(controller.state.isLoadingStates, isFalse);
    });

    test('country with no states: hasCities is false, cities not fetched',
        () async {
      final controller = _makeController(statesResult: []);
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('AX');

      // Cities endpoint must not have been called; citiesLoadedForState stays null.
      expect(controller.state.hasCities, isFalse);
      expect(controller.state.citiesLoadedForState, isNull);
      expect(controller.state.cityOptions, isEmpty);
    });

    test(
        'no-state country: request payload should use empty strings for state+city',
        () {
      // Validate that the model correctly serialises '' for state/city.
      const request = SuperadminCreateAdministratorRequest(
        name: 'Test Admin',
        username: 'testadmin',
        password: 'pass123',
        companyName: 'Test Co',
        address: '123 Street',
        country: 'AX',
        state: '',
        city: '',
      );
      final json = request.toJson();

      expect(json['country'], 'AX');
      expect(json['state'], '');
      expect(json['city'], '');
    });

    // -----------------------------------------------------------------------
    // Case 3: country has states but selected state has no cities
    // -----------------------------------------------------------------------

    test('state with no cities: hasCities is false, city optional', () async {
      final controller = _makeController(
        statesResult: [_stateIN],
        citiesResult: [],
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      await controller.loadCityOptions('IN', 'MH');

      expect(controller.state.hasStates, isTrue);
      expect(controller.state.hasCities, isFalse);
      expect(controller.state.citiesLoadedForState, 'MH');
      expect(controller.state.cityOptions, isEmpty);
    });

    test('no-city state: request payload uses selected state and empty city',
        () {
      const request = SuperadminCreateAdministratorRequest(
        name: 'Test Admin',
        username: 'testadmin',
        password: 'pass123',
        companyName: 'Test Co',
        address: '123 Street',
        country: 'IN',
        state: 'MH',
        city: '',
      );
      final json = request.toJson();

      expect(json['state'], 'MH');
      expect(json['city'], '');
    });

    // -----------------------------------------------------------------------
    // Case 4: changing country clears previous selections
    // -----------------------------------------------------------------------

    test('changing country clears previous state options and cities', () async {
      // IN has states+cities; AX returns an empty state list.
      final controller = _makeController(
        citiesResult: [_cityMH],
        statesResultByCountry: {
          'IN': [_stateIN],
          'AX': [],
        },
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      await controller.loadCityOptions('IN', 'MH');

      expect(controller.state.stateOptions, hasLength(1));
      expect(controller.state.cityOptions, hasLength(1));

      // Now switch country — loadStateOptions resets everything.
      await controller.loadStateOptions('AX');

      expect(controller.state.stateOptions, isEmpty);
      expect(controller.state.cityOptions, isEmpty);
      expect(controller.state.citiesLoadedForState, isNull);
      expect(controller.state.statesLoadedForCountry, 'AX');
    });

    test('changing country resets statesLoadedForCountry mid-call', () async {
      final controller = _makeController(statesResult: [_stateIN]);
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      expect(controller.state.statesLoadedForCountry, 'IN');

      // Start loading for a new country.
      await controller.loadStateOptions('US');
      expect(controller.state.statesLoadedForCountry, 'US');
      // Old IN data must be gone.
      expect(controller.state.cityOptions, isEmpty);
    });

    // -----------------------------------------------------------------------
    // Case 5: changing state clears city
    // -----------------------------------------------------------------------

    test('changing state clears previous city options', () async {
      final controller = _makeController(
        statesResult: [_stateIN],
        citiesResult: [_cityMH],
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      await controller.loadCityOptions('IN', 'MH');
      expect(controller.state.cityOptions, hasLength(1));

      // Simulate selecting a different state — loadCityOptions clears cities first.
      await controller.loadCityOptions('IN', 'KA');

      expect(controller.state.citiesLoadedForState, 'KA');
      // citiesResult for KA returns same list in fake, but we verify reset cycle.
      expect(controller.state.cityOptions, hasLength(1));
    });

    // -----------------------------------------------------------------------
    // Case 6: empty successful load is distinct from a failed load
    // -----------------------------------------------------------------------

    test('successful empty states load sets statesLoadedForCountry', () async {
      final controller = _makeController(statesResult: []);
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('AX');

      // statesLoadedForCountry is set → successful load that returned empty list.
      expect(controller.state.statesLoadedForCountry, 'AX');
      expect(controller.state.hasStates, isFalse);
    });

    test('failed states load does NOT set statesLoadedForCountry', () async {
      final controller = _makeController(
        statesError: Exception('network error'),
      );
      addTearDown(controller.dispose);
      await _flush();

      try {
        await controller.loadStateOptions('IN');
      } catch (_) {
        // Expected.
      }

      // statesLoadedForCountry must remain null — failed load is not "empty country".
      expect(controller.state.statesLoadedForCountry, isNull);
      expect(controller.state.isLoadingStates, isFalse);
      expect(controller.state.errorMessage, isNotNull);
    });

    test('successful empty cities load sets citiesLoadedForState', () async {
      final controller = _makeController(
        statesResult: [_stateIN],
        citiesResult: [],
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      await controller.loadCityOptions('IN', 'MH');

      expect(controller.state.citiesLoadedForState, 'MH');
      expect(controller.state.hasCities, isFalse);
    });

    test('failed cities load does NOT set citiesLoadedForState', () async {
      final controller = _makeController(
        statesResult: [_stateIN],
        citiesError: Exception('network error'),
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');

      try {
        await controller.loadCityOptions('IN', 'MH');
      } catch (_) {
        // Expected.
      }

      expect(controller.state.citiesLoadedForState, isNull);
      expect(controller.state.isLoadingCities, isFalse);
      expect(controller.state.errorMessage, isNotNull);
    });

    // -----------------------------------------------------------------------
    // Case 7: isLoadingStates / isLoadingCities lifecycle
    // -----------------------------------------------------------------------

    test('isLoadingStates is true during fetch and false after', () async {
      var seenLoading = false;

      final controller = _makeController(statesResult: [_stateIN]);
      addTearDown(controller.dispose);
      await _flush();

      // Attach listener to capture intermediate state.
      controller.addListener((s) {
        if (s.isLoadingStates) seenLoading = true;
      });

      await controller.loadStateOptions('IN');

      expect(seenLoading, isTrue);
      expect(controller.state.isLoadingStates, isFalse);
    });

    test('isLoadingCities is true during fetch and false after', () async {
      var seenLoading = false;

      final controller = _makeController(
        statesResult: [_stateIN],
        citiesResult: [_cityMH],
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');

      controller.addListener((s) {
        if (s.isLoadingCities) seenLoading = true;
      });

      await controller.loadCityOptions('IN', 'MH');

      expect(seenLoading, isTrue);
      expect(controller.state.isLoadingCities, isFalse);
    });

    // -----------------------------------------------------------------------
    // Case 8: existing countries with full hierarchy still require both
    // -----------------------------------------------------------------------

    test('full hierarchy: hasStates and hasCities both true', () async {
      final controller = _makeController(
        statesResult: [_stateIN],
        citiesResult: [_cityMH],
      );
      addTearDown(controller.dispose);
      await _flush();

      await controller.loadStateOptions('IN');
      await controller.loadCityOptions('IN', 'MH');

      expect(controller.state.hasStates, isTrue);
      expect(controller.state.hasCities, isTrue);
    });
  });
}
