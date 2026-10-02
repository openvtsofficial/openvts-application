import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/controllers/user_settings_controller.dart';
import 'package:open_vts/features/user/models/user_settings_model.dart';
import 'package:open_vts/features/user/models/user_settings_state.dart';
import 'package:open_vts/features/user/screens/settings/widgets/user_address_card.dart';
import 'package:open_vts/features/user/screens/settings/widgets/user_profile_edit_sheet.dart';

// ---------------------------------------------------------------------------
// Shared fixtures
// ---------------------------------------------------------------------------

const _countries = [
  UserCountryOption(value: 'IN', label: 'India'),
  UserCountryOption(value: 'US', label: 'United States'),
  UserCountryOption(value: 'GB', label: 'United Kingdom'),
];

const _statesIN = [
  UserStateOption(value: 'CT', label: 'Chhattisgarh'),
  UserStateOption(value: 'MH', label: 'Maharashtra'),
  UserStateOption(value: 'KA', label: 'Karnataka'),
];

const _prefixes = [
  UserMobilePrefixOption(value: '+91', label: '+91 IN', countryCode: 'IN'),
  UserMobilePrefixOption(value: '+1', label: '+1 US', countryCode: 'US'),
];

const _baseProfile = UserSettingsProfile(
  name: 'Test User',
  mobilePrefix: '+91',
  mobileNumber: '9876543210',
  address: UserSettingsAddress(
    addressLine: '123 Main Street',
    countryCode: 'IN',
    stateCode: 'CT',
    cityName: 'Raipur',
  ),
);

// ---------------------------------------------------------------------------
// Fake controller
// ---------------------------------------------------------------------------

class _FakeController extends StateNotifier<UserSettingsState>
    implements UserSettingsController {
  _FakeController(super.state);

  @override
  Future<void> loadInitial() async {}

  @override
  Future<void> loadReferenceData({bool force = false}) async {}

  @override
  Future<void> loadStates(String countryCode) async {}

  @override
  Future<void> loadCities(String countryCode, String stateCode) async {}

  @override
  Future<void> loadEmailSubscription() async {}

  @override
  Future<void> refreshCurrentTab({bool discardUnsaved = false}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

UserSettingsState _makeState({
  List<UserCountryOption> countries = _countries,
  List<UserStateOption> states = _statesIN,
  String? statesForCountryCode = 'IN',
  List<UserMobilePrefixOption> prefixes = _prefixes,
  bool isLoadingReferences = false,
  bool isLoadingStates = false,
  String? errorMessage,
}) {
  return const UserSettingsState.initial().copyWith(
    countries: countries,
    states: states,
    statesForCountryCode: statesForCountryCode,
    mobilePrefixes: prefixes,
    isLoadingReferences: isLoadingReferences,
    isLoadingStates: isLoadingStates,
    errorMessage: errorMessage,
    draftProfile: _baseProfile,
    profile: _baseProfile,
  );
}

Widget _pumpEditSheet({
  UserSettingsProfile profile = _baseProfile,
  required UserSettingsState state,
}) {
  final controller = _FakeController(state);
  return ProviderScope(
    overrides: [
      userSettingsControllerProvider.overrideWith((_) => controller),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: UserProfileEditSheet(
            profile: profile,
            controller: controller,
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // 1. UserAddressCard — label resolution
  // -------------------------------------------------------------------------

  group('UserAddressCard — label display', () {
    testWidgets('shows countryLabel instead of raw country code', (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAddressCard(
              address: UserSettingsAddress(
                addressLine: '123 Main Street',
                countryCode: 'IN',
                stateCode: 'CT',
                cityName: 'Raipur',
              ),
              countryLabel: 'India',
              stateLabel: 'Chhattisgarh',
            ),
          ),
        ),
      );
      expect(find.text('India'), findsOneWidget);
      expect(find.text('Chhattisgarh'), findsOneWidget);
      // Raw codes must not appear as standalone text widgets
      expect(find.text('IN'), findsNothing);
      expect(find.text('CT'), findsNothing);
    });

    testWidgets('falls back to raw country code when countryLabel is null',
        (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAddressCard(
              address: UserSettingsAddress(
                addressLine: '123 St',
                countryCode: 'IN',
                stateCode: 'CT',
                cityName: 'City',
              ),
            ),
          ),
        ),
      );
      // No label provided → raw code is shown as fallback
      expect(find.text('IN'), findsOneWidget);
      expect(find.text('CT'), findsOneWidget);
    });

    testWidgets('falls back to raw state code when only stateLabel is null',
        (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAddressCard(
              address: UserSettingsAddress(
                addressLine: 'Addr',
                countryCode: 'US',
                stateCode: 'CA',
                cityName: 'Los Angeles',
              ),
              countryLabel: 'United States',
            ),
          ),
        ),
      );
      expect(find.text('United States'), findsOneWidget);
      // stateLabel not given → raw code
      expect(find.text('CA'), findsOneWidget);
    });

    testWidgets('empty card when address has no content', (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAddressCard(address: null),
          ),
        ),
      );
      expect(find.text('ADDRESS'), findsNothing);
    });

    testWidgets('shows partial address — country only', (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserAddressCard(
              address: UserSettingsAddress(countryCode: 'GB'),
              countryLabel: 'United Kingdom',
            ),
          ),
        ),
      );
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('GB'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // 2. UserProfileEditSheet — country dropdown when references loaded
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — country dropdown with loaded references', () {
    testWidgets('shows Country dropdown (not a text field) when options loaded',
        (t) async {
      await t.pumpWidget(_pumpEditSheet(state: _makeState()));
      await t.pump();

      // DropdownButtonFormField renders a DropdownButton — check for its
      // decorated field, not a TextField.
      expect(find.byType(DropdownButtonFormField<String>), findsWidgets);
    });

    testWidgets('country dropdown shows the saved country as selected',
        (t) async {
      await t.pumpWidget(_pumpEditSheet(state: _makeState()));
      await t.pump();

      // The dropdown's current item label should be visible.
      // 'India' should appear in a Text widget inside the dropdown.
      expect(find.text('India'), findsWidgets);
    });

    testWidgets('state dropdown shows the saved state as selected', (t) async {
      await t.pumpWidget(_pumpEditSheet(state: _makeState()));
      await t.pump();
      expect(find.text('Chhattisgarh'), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // 3. Loading placeholders
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — loading states', () {
    testWidgets(
        'shows loading placeholder for Country when references are loading',
        (t) async {
      await t.pumpWidget(_pumpEditSheet(
        state: _makeState(countries: const [], isLoadingReferences: true),
      ));
      await t.pump();
      // Country loading indicator replaces the text field
      expect(find.text('Country'), findsWidgets);
      // No code-only text input visible
      expect(find.text('Country Code'), findsNothing);
    });

    testWidgets('shows loading placeholder for State when states are loading',
        (t) async {
      await t.pumpWidget(_pumpEditSheet(
        state: _makeState(
          states: const [],
          statesForCountryCode: null,
          isLoadingStates: true,
        ),
      ));
      await t.pump();
      expect(find.text('State'), findsWidgets);
      expect(find.text('State Code'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // 4. Reference-load-failed → retry widget
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — reference load failed', () {
    testWidgets('shows Retry button when country reference failed', (t) async {
      await t.pumpWidget(_pumpEditSheet(
        state: _makeState(
          countries: const [],
          isLoadingReferences: false,
          errorMessage: 'Could not load country list.',
        ),
      ));
      await t.pump();

      expect(find.text('Retry'), findsOneWidget);
      // No raw-code text input should be present
      expect(find.text('Country Code'), findsNothing);
    });

    testWidgets(
        'retry field carries error text when profile has no pre-selected country',
        (t) async {
      const noCountryProfile = UserSettingsProfile(
        name: 'User',
        mobilePrefix: '+1',
        mobileNumber: '5550000',
        address: UserSettingsAddress(
          addressLine: 'Addr',
          stateCode: 'CA',
          cityName: 'LA',
          // No countryCode
        ),
      );

      await t.pumpWidget(_pumpEditSheet(
        profile: noCountryProfile,
        state: _makeState(
          countries: const [],
          isLoadingReferences: false,
          errorMessage: 'Network error',
        ),
      ));
      await t.pump();

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets(
        'retry field does not show validation error when country already resolved',
        (t) async {
      // Profile has IN → validator should pass even without the dropdown list.
      await t.pumpWidget(_pumpEditSheet(
        state: _makeState(
          countries: const [],
          isLoadingReferences: false,
          errorMessage: 'Timeout',
        ),
      ));
      await t.pump();

      // No validation error text visible initially
      expect(find.text('Country is required. Tap Retry to reload options.'),
          findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // 5. Disabled placeholder — country not selected
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — state disabled placeholder', () {
    testWidgets('shows "Select a country first" when no country chosen',
        (t) async {
      const noCountryProfile = UserSettingsProfile(
        name: 'User',
        mobilePrefix: '+1',
        mobileNumber: '5550000',
        address: UserSettingsAddress(
          addressLine: 'Addr',
          cityName: 'LA',
          // No countryCode, no stateCode
        ),
      );

      await t.pumpWidget(_pumpEditSheet(
        profile: noCountryProfile,
        state: _makeState(
          states: const [],
          statesForCountryCode: null,
        ),
      ));
      await t.pump();

      expect(find.text('Select a country first'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // 6. State code label ("State Code" is never shown)
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — no raw "State Code" label', () {
    testWidgets(
        '"State Code" label never appears regardless of reference state',
        (t) async {
      // Test with empty states but country loaded
      await t.pumpWidget(_pumpEditSheet(
        state: _makeState(
          states: const [],
          statesForCountryCode: 'IN',
        ),
      ));
      await t.pump();
      expect(find.text('State Code'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // 7. State dropdown with loaded states
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — state dropdown', () {
    testWidgets('state dropdown is shown when states are loaded for country',
        (t) async {
      await t.pumpWidget(_pumpEditSheet(state: _makeState()));
      await t.pump();

      // There should be DropdownButtonFormField widgets (country + state)
      expect(
        find.byType(DropdownButtonFormField<String>),
        findsNWidgets(2),
      );
    });
  });

  // -------------------------------------------------------------------------
  // 8. "Country Code" text input is never shown
  // -------------------------------------------------------------------------

  group('UserProfileEditSheet — country code text input blocked', () {
    testWidgets('"Country Code" label never appears', (t) async {
      // Test across multiple states: loaded, loading, failed
      for (final state in [
        _makeState(),
        _makeState(countries: const [], isLoadingReferences: true),
        _makeState(
            countries: const [],
            isLoadingReferences: false,
            errorMessage: 'Error'),
      ]) {
        await t.pumpWidget(_pumpEditSheet(state: state));
        await t.pump();
        expect(find.text('Country Code'), findsNothing,
            reason: 'Country Code label must never appear');
      }
    });
  });
}
