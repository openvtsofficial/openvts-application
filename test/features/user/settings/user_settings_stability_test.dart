// Focused unit tests for the User → Settings stability fixes.
//
// Coverage:
//   • Localization form: epoch-gated hydration, draft preservation
//   • Location requests: generation-counter stale-response suppression
//   • Busy states: independent profile / localization operation flags
//   • Lifecycle: single initial load, idempotent guards

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/controllers/user_settings_controller.dart';
import 'package:open_vts/features/user/models/user_settings_model.dart';
import 'package:open_vts/features/user/models/user_settings_state.dart';
import 'package:open_vts/features/user/services/user_settings_service.dart';

// ── Minimal fake service ──────────────────────────────────────────────────────

class _FakeService implements UserSettingsService {
  // Completers allow tests to control exactly when a response arrives.
  Completer<UserSettingsProfile>? profileCompleter;
  Completer<UserLocalizationSettings>? localizationCompleter;
  Completer<List<UserStateOption>>? statesCompleter;
  Completer<List<UserCityOption>>? citiesCompleter;
  Completer<UserEmailSubscriptionStatus>? emailSubCompleter;

  int getProfileCallCount = 0;
  int getLocalizationCallCount = 0;
  int getStatesCallCount = 0;
  int getCitiesCallCount = 0;
  String? lastStatesCountryCode;
  String? lastCitiesCountryCode;
  String? lastCitiesStateCode;

  static const _defaultProfile = UserSettingsProfile();
  static const _defaultLocalization = UserLocalizationSettings();
  static const _defaultEmailSub =
      UserEmailSubscriptionStatus(isSubscribed: false);

  @override
  Future<UserSettingsProfile> getProfile() async {
    getProfileCallCount++;
    final c = profileCompleter;
    if (c != null) return c.future;
    return _defaultProfile;
  }

  @override
  Future<UserSettingsProfile> updateProfile(
          UserUpdateProfileRequest request) async =>
      _defaultProfile;

  @override
  Future<void> updateCompany(UserUpdateCompanyRequest request) async {}

  @override
  Future<void> changePassword(UserChangePasswordRequest request) async {}

  @override
  Future<UserSettingsProfile> uploadProfilePhoto({
    required List<int> bytes,
    required String fileName,
  }) async =>
      _defaultProfile;

  @override
  Future<void> requestEmailOtp() async {}

  @override
  Future<void> confirmEmailOtp(String otp) async {}

  @override
  Future<void> requestWhatsAppOtp() async {}

  @override
  Future<void> confirmWhatsAppOtp(String otp) async {}

  @override
  Future<UserEmailSubscriptionStatus> getEmailSubscription() async {
    final c = emailSubCompleter;
    if (c != null) return c.future;
    return _defaultEmailSub;
  }

  @override
  Future<UserEmailSubscriptionStatus> subscribeEmail() async =>
      _defaultEmailSub;

  @override
  Future<UserLocalizationSettings> getLocalization() async {
    getLocalizationCallCount++;
    final c = localizationCompleter;
    if (c != null) return c.future;
    return _defaultLocalization;
  }

  @override
  Future<UserLocalizationSettings> updateLocalization(
          UserLocalizationSettings settings) async =>
      settings;

  @override
  Future<List<UserLanguageOption>> getLanguages() async => const [];

  @override
  Future<List<UserDateFormatOption>> getDateFormats() async => const [];

  @override
  Future<List<String>> getTimezones() async => const [];

  @override
  Future<List<UserCountryOption>> getCountries() async => const [];

  @override
  Future<List<UserMobilePrefixOption>> getMobilePrefixes() async => const [];

  @override
  Future<List<UserStateOption>> getStates(String countryCode) async {
    getStatesCallCount++;
    lastStatesCountryCode = countryCode;
    final c = statesCompleter;
    if (c != null) return c.future;
    return const [];
  }

  @override
  Future<List<UserCityOption>> getCities(
    String countryCode,
    String stateCode,
  ) async {
    getCitiesCallCount++;
    lastCitiesCountryCode = countryCode;
    lastCitiesStateCode = stateCode;
    final c = citiesCompleter;
    if (c != null) return c.future;
    return const [];
  }
}

// ── Test helpers ──────────────────────────────────────────────────────────────

UserSettingsController _makeController(_FakeService service) {
  return UserSettingsController(service: service);
}

void main() {
// ═════════════════════════════════════════════════════════════════════════════
// 1. LOCALIZATION FORM — epoch-gated hydration
// ═════════════════════════════════════════════════════════════════════════════

  group('Localization hydration epoch', () {
    test('epoch is 0 in initial state', () {
      final state = const UserSettingsState.initial();
      expect(state.localizationHydrationEpoch, 0);
    });

    test('loadLocalization increments epoch', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      expect(ctrl.state.localizationHydrationEpoch, 0);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      expect(ctrl.state.localizationHydrationEpoch, 1);
    });

    test('saveLocalization increments epoch on success', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'hi');

      final epochBefore = ctrl.state.localizationHydrationEpoch;
      await ctrl.saveLocalization();
      expect(ctrl.state.localizationHydrationEpoch, epochBefore + 1);
    });

    test('resetLocalizationDraft increments epoch', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'hi');

      final epochBefore = ctrl.state.localizationHydrationEpoch;
      ctrl.resetLocalizationDraft();
      expect(ctrl.state.localizationHydrationEpoch, epochBefore + 1);
    });

    test('patchDraftLocalization does NOT increment epoch', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);

      final epochBefore = ctrl.state.localizationHydrationEpoch;
      ctrl.patchDraftLocalization(language: 'ar');
      expect(ctrl.state.localizationHydrationEpoch, epochBefore);
    });

    test('unrelated reference load does NOT increment localization epoch',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);

      final epochBefore = ctrl.state.localizationHydrationEpoch;
      await ctrl.loadReferenceData(force: true);
      expect(ctrl.state.localizationHydrationEpoch, epochBefore);
    });

    test('email subscription load does NOT increment localization epoch',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);

      final epochBefore = ctrl.state.localizationHydrationEpoch;
      await ctrl.loadEmailSubscription();
      expect(ctrl.state.localizationHydrationEpoch, epochBefore);
    });

    test('dirty draft is preserved when load uses preserveDraftIfDirty=true',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'ar');

      final draftBefore = ctrl.state.draftLocalization;

      // Simulate a second load that should preserve the dirty draft.
      await ctrl.loadLocalization(preserveDraftIfDirty: true);

      expect(ctrl.state.draftLocalization, equals(draftBefore));
    });
  });

// ═════════════════════════════════════════════════════════════════════════════
// 2. LOCATION REQUESTS — stale-response suppression
// ═════════════════════════════════════════════════════════════════════════════

  group('States loading generation counter', () {
    test('states for country A are not applied when B finishes first',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      final completerA = Completer<List<UserStateOption>>();
      final completerB = Completer<List<UserStateOption>>();

      final statesA = [const UserStateOption(value: 'CA', label: 'California')];
      final statesB = [const UserStateOption(value: 'TX', label: 'Texas')];

      // Request A starts.
      service.statesCompleter = completerA;
      final futureA = ctrl.loadStates('US');

      // Request B starts immediately after (newer generation).
      service.statesCompleter = completerB;
      final futureB = ctrl.loadStates('GB');

      // B finishes first.
      completerB.complete(statesB);
      await futureB;

      expect(ctrl.state.states, equals(statesB));
      expect(ctrl.state.statesForCountryCode, 'GB');

      // A finishes later — must be ignored.
      completerA.complete(statesA);
      await futureA;

      // State must still reflect B's result.
      expect(ctrl.state.states, equals(statesB));
      expect(ctrl.state.statesForCountryCode, 'GB');
    });

    test('changing country immediately clears state list', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      // Seed with some states.
      await ctrl.loadStates('US');
      // Simulate state list present.
      expect(ctrl.state.isLoadingStates, false);

      // Start loading a new country — old states must be gone immediately.
      final completer = Completer<List<UserStateOption>>();
      service.statesCompleter = completer;
      final future = ctrl.loadStates('IN');

      // Before future resolves, state list must be empty.
      expect(ctrl.state.states, isEmpty);
      expect(ctrl.state.isLoadingStates, true);

      completer
          .complete(const [UserStateOption(value: 'MH', label: 'Maharashtra')]);
      await future;
      expect(ctrl.state.isLoadingStates, false);
    });

    test('changing country immediately clears city list', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      // Seed with cities.
      await ctrl.loadCities('US', 'CA');
      expect(ctrl.state.cities, isEmpty); // fake returns empty

      // Start a new country load — cities must be cleared.
      service.statesCompleter = Completer();
      final future = ctrl.loadStates('IN');

      expect(ctrl.state.cities, isEmpty);
      expect(ctrl.state.citiesForCountryAndStateCode, isNull);

      service.statesCompleter!.complete(const []);
      await future;
    });
  });

  group('Cities loading generation counter', () {
    test('cities for state A are not applied when B finishes first', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      final completerA = Completer<List<UserCityOption>>();
      final completerB = Completer<List<UserCityOption>>();

      final citiesA = [
        const UserCityOption(value: 'San Francisco', label: 'San Francisco')
      ];
      final citiesB = [const UserCityOption(value: 'Austin', label: 'Austin')];

      service.citiesCompleter = completerA;
      final futureA = ctrl.loadCities('US', 'CA');

      service.citiesCompleter = completerB;
      final futureB = ctrl.loadCities('US', 'TX');

      completerB.complete(citiesB);
      await futureB;

      expect(ctrl.state.cities, equals(citiesB));
      expect(ctrl.state.citiesForCountryAndStateCode, 'US/TX');

      completerA.complete(citiesA);
      await futureA;

      // Stale A response must not overwrite B's result.
      expect(ctrl.state.cities, equals(citiesB));
      expect(ctrl.state.citiesForCountryAndStateCode, 'US/TX');
    });

    test('changing state immediately clears city list', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadCities('US', 'CA');

      final completer = Completer<List<UserCityOption>>();
      service.citiesCompleter = completer;
      final future = ctrl.loadCities('US', 'TX');

      // Must be cleared immediately.
      expect(ctrl.state.cities, isEmpty);
      expect(ctrl.state.isLoadingCities, true);

      completer
          .complete(const [UserCityOption(value: 'Austin', label: 'Austin')]);
      await future;
      expect(ctrl.state.isLoadingCities, false);
    });

    test('state response is associated with the requested country code',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadStates('IN');

      expect(ctrl.state.statesForCountryCode, 'IN');
    });

    test('city response is associated with the requested country and state',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadCities('IN', 'MH');

      expect(ctrl.state.citiesForCountryAndStateCode, 'IN/MH');
    });

    test('cached states are reused without a new network call', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadStates('US');
      final firstCallCount = service.getStatesCallCount;

      await ctrl.loadStates('US');
      // Second call must hit cache — no extra network request.
      expect(service.getStatesCallCount, equals(firstCallCount));
    });

    test('cached cities are reused without a new network call', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadCities('US', 'CA');
      final firstCallCount = service.getCitiesCallCount;

      await ctrl.loadCities('US', 'CA');
      expect(service.getCitiesCallCount, equals(firstCallCount));
    });
  });

// ═════════════════════════════════════════════════════════════════════════════
// 3. BUSY STATES — independent profile / localization operations
// ═════════════════════════════════════════════════════════════════════════════

  group('Independent busy states', () {
    test('email subscription loading does not prevent canSaveLocalization',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'ar');

      // Manually set email subscription loading (simulated via state directly
      // since we only have controller API; instead test via the state getter).
      final dirtyState = ctrl.state;
      expect(dirtyState.isLocalizationDirty, isTrue);

      // isLoadingEmailSubscription must not affect canSaveLocalization.
      final stateWithEmailLoading = dirtyState.copyWith(
        isLoadingEmailSubscription: true,
      );
      expect(stateWithEmailLoading.canSaveLocalization, isTrue);
    });

    test('OTP request does not prevent canSaveLocalization', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'ar');

      final dirtyState = ctrl.state;
      final stateWithOtp = dirtyState.copyWith(
        isRequestingEmailOtp: true,
      );
      expect(stateWithOtp.canSaveLocalization, isTrue);
    });

    test('isSavingProfile does not prevent canSaveLocalization', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'ar');

      final dirtyState = ctrl.state;
      final stateWithProfileSave = dirtyState.copyWith(
        isSavingProfile: true,
      );
      expect(stateWithProfileSave.canSaveLocalization, isTrue);
    });

    test('isSavingLocalization prevents duplicate localization save', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadLocalization(preserveDraftIfDirty: false);
      ctrl.patchDraftLocalization(language: 'ar');

      final dirtyState = ctrl.state;
      final stateWhileSaving = dirtyState.copyWith(
        isSavingLocalization: true,
      );
      expect(stateWhileSaving.canSaveLocalization, isFalse);
      expect(stateWhileSaving.isLocalizationTabBusy, isTrue);
    });

    test('isSavingLocalization does not prevent canSaveProfile', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadProfile(preserveDraftIfDirty: false);
      ctrl.patchDraftProfile(name: 'New Name');

      final dirtyState = ctrl.state;
      final stateWhileLocSaving = dirtyState.copyWith(
        isSavingLocalization: true,
      );
      expect(stateWhileLocSaving.canSaveProfile, isTrue);
    });

    test('isSubscribingEmail does not disable isLocalizationTabBusy', () {
      final state = const UserSettingsState.initial().copyWith(
        isSubscribingEmail: true,
      );
      expect(state.isLocalizationTabBusy, isFalse);
    });

    test('isLoadingEmailSubscription does not disable isLocalizationTabBusy',
        () {
      final state = const UserSettingsState.initial().copyWith(
        isLoadingEmailSubscription: true,
      );
      expect(state.isLocalizationTabBusy, isFalse);
    });

    test('isLoadingLocalization disables isLocalizationTabBusy', () {
      final state = const UserSettingsState.initial().copyWith(
        isLoadingLocalization: true,
      );
      expect(state.isLocalizationTabBusy, isTrue);
    });

    test('isProfileRefreshBusy is true during initial load', () {
      final state = const UserSettingsState.initial().copyWith(
        isLoadingInitial: true,
      );
      expect(state.isProfileRefreshBusy, isTrue);
    });

    test('isLocalizationRefreshBusy is true during initial load', () {
      final state = const UserSettingsState.initial().copyWith(
        isLoadingInitial: true,
      );
      expect(state.isLocalizationRefreshBusy, isTrue);
    });

    test('isLocalizationRefreshBusy is false when only email sub is loading',
        () {
      final state = const UserSettingsState.initial().copyWith(
        isLoadingEmailSubscription: true,
      );
      expect(state.isLocalizationRefreshBusy, isFalse);
    });
  });

// ═════════════════════════════════════════════════════════════════════════════
// 4. LIFECYCLE — single initial load, idempotent guards
// ═════════════════════════════════════════════════════════════════════════════

  group('Lifecycle: single initial load', () {
    test('loadInitial issues exactly one profile request', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadInitial();
      expect(service.getProfileCallCount, 1);
    });

    test('loadInitial is idempotent – second call is ignored while first runs',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      final completer = Completer<UserSettingsProfile>();
      service.profileCompleter = completer;

      // Start first load but don't await.
      final first = ctrl.loadInitial();
      // Immediately call again.
      final second = ctrl.loadInitial();

      completer.complete(const UserSettingsProfile());
      await Future.wait([first, second]);

      // Only one network call despite two invocations.
      expect(service.getProfileCallCount, 1);
    });

    test('profile stays clean when profile load preserves dirty draft',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.loadProfile(preserveDraftIfDirty: false);
      ctrl.patchDraftProfile(name: 'Edited Name');

      final draftBefore = ctrl.state.draftProfile;
      await ctrl.loadProfile(preserveDraftIfDirty: true);

      // Draft must be preserved.
      expect(ctrl.state.draftProfile, equals(draftBefore));
    });

    test('controller does not update state after disposal', () async {
      final service = _FakeService();
      // Create within a container and immediately invalidate it.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final provider = StateNotifierProvider.autoDispose<UserSettingsController,
          UserSettingsState>((ref) {
        return UserSettingsController(service: service);
      });

      // Keep reference before disposal.
      final ctrl = container.read(provider.notifier);

      // Dispose the container (which disposes the autoDispose notifier).
      container.dispose();

      // Calling loadProfile after disposal must not throw.
      await expectLater(ctrl.loadProfile(), completes);
    });
  });

// ═════════════════════════════════════════════════════════════════════════════
// 5. STATE MODEL — copyWith preserves all new fields correctly
// ═════════════════════════════════════════════════════════════════════════════

  group('UserSettingsState copyWith new fields', () {
    test('copyWith updates isLoadingStates', () {
      final initial = const UserSettingsState.initial();
      final updated = initial.copyWith(isLoadingStates: true);
      expect(updated.isLoadingStates, isTrue);
      expect(updated.isLoadingCities, isFalse);
    });

    test('copyWith updates isLoadingCities', () {
      final initial = const UserSettingsState.initial();
      final updated = initial.copyWith(isLoadingCities: true);
      expect(updated.isLoadingCities, isTrue);
      expect(updated.isLoadingStates, isFalse);
    });

    test('copyWith updates statesForCountryCode', () {
      final initial = const UserSettingsState.initial();
      final updated = initial.copyWith(statesForCountryCode: 'US');
      expect(updated.statesForCountryCode, 'US');
    });

    test('copyWith clears statesForCountryCode to null', () {
      final initial = const UserSettingsState.initial()
          .copyWith(statesForCountryCode: 'US');
      final cleared = initial.copyWith(statesForCountryCode: null);
      expect(cleared.statesForCountryCode, isNull);
    });

    test('copyWith updates citiesForCountryAndStateCode', () {
      final initial = const UserSettingsState.initial();
      final updated = initial.copyWith(citiesForCountryAndStateCode: 'US/CA');
      expect(updated.citiesForCountryAndStateCode, 'US/CA');
    });

    test('copyWith updates localizationHydrationEpoch', () {
      final initial = const UserSettingsState.initial();
      final updated = initial.copyWith(localizationHydrationEpoch: 5);
      expect(updated.localizationHydrationEpoch, 5);
    });

    test('initial state has epoch 0', () {
      expect(const UserSettingsState.initial().localizationHydrationEpoch, 0);
    });
  });

// ═════════════════════════════════════════════════════════════════════════════
// 6. SERVICE PARSING — action:false is not treated as saved data
// ═════════════════════════════════════════════════════════════════════════════

  group('UserLocalizationSettings.fromDynamic', () {
    test('parses canonical localization payload', () {
      final json = {
        'language': 'en',
        'layoutDirection': 'LTR',
        'dateFormat': 'YYYY-MM-DD',
        'use24Hour': true,
        'theme': 'DARK',
        'timezoneOffset': '+05:30',
        'units': 'KM',
        'defaultLat': 12.9716,
        'defaultLon': 77.5946,
        'mapZoom': 12,
      };
      final result = UserLocalizationSettings.fromDynamic(json);
      expect(result.language, 'en');
      expect(result.theme, UserThemeMode.dark);
      expect(result.defaultLat, closeTo(12.9716, 0.0001));
      expect(result.mapZoom, 12);
    });

    test('empty map returns defaults', () {
      final result = UserLocalizationSettings.fromDynamic(<String, dynamic>{});
      expect(result.language, UserLocalizationSettings.defaults.language);
      expect(result.mapZoom, UserLocalizationSettings.defaults.mapZoom);
    });

    test('action:false payload is not mistaken for valid localization data',
        () {
      // An API response of {"action": false} should fall back to defaults, not
      // produce a settings object with meaningless field values.
      final result = UserLocalizationSettings.fromDynamic({'action': false});
      expect(result, equals(UserLocalizationSettings.defaults));
    });
  });

  group('UserSettingsProfile.fromDynamic', () {
    test('parses canonical profile payload', () {
      final json = {
        'uid': 42,
        'name': 'Jane',
        'email': 'jane@example.com',
        'mobilePrefix': '+1',
        'mobileNumber': '5550001234',
      };
      final result = UserSettingsProfile.fromDynamic(json);
      expect(result.uid, 42);
      expect(result.name, 'Jane');
    });

    test('missing required fields produce null values without throwing', () {
      expect(() => UserSettingsProfile.fromDynamic({}), returnsNormally);
    });
  });
} // end main()
