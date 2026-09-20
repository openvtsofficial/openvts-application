import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/utils/validators.dart';
import '../models/user_settings_model.dart';
import '../models/user_settings_state.dart';
import '../services/user_settings_service.dart';

// ignore: avoid_print
void _debugLog(String message) {
  assert(() {
    // ignore: avoid_print
    print('[UserSettings] $message');
    return true;
  }());
}

class UserSettingsController extends StateNotifier<UserSettingsState> {
  UserSettingsController({
    required UserSettingsService service,
  })  : _service = service,
        super(const UserSettingsState.initial()) {
    _debugLog('controller created');
  }

  final UserSettingsService _service;

  // ── Request generation counters ──────────────────────────────────────────
  // Each new loadStates / loadCities call increments the counter; the
  // response is applied only when it still matches the latest counter.
  int _statesGeneration = 0;
  int _citiesGeneration = 0;

  // ── In-flight coalesce guards ─────────────────────────────────────────────
  // loadInitial already uses isLoadingInitial. These prevent a second
  // concurrent initial call from bypassing the flag before it is set.
  bool _initialLoadStarted = false;
  int _profileLoadCount = 0;
  int _localizationLoadCount = 0;
  int _referenceLoadCount = 0;

  // ── Address caches (country → states, country+state → cities) ───────────
  final Map<String, List<UserStateOption>> _statesCache = {};
  final Map<String, List<UserCityOption>> _citiesCache = {};

  @override
  void dispose() {
    _debugLog('controller disposed');
    super.dispose();
  }

  // ── Initial load ──────────────────────────────────────────────────────────

  Future<void> loadInitial() async {
    if (_initialLoadStarted || state.isLoadingInitial) {
      _debugLog('loadInitial: already started – skipping');
      return;
    }

    _initialLoadStarted = true;
    _debugLog('loadInitial: start');

    state = state.copyWith(
      isLoadingInitial: true,
      errorMessage: null,
      profileErrorMessage: null,
      localizationErrorMessage: null,
    );

    try {
      final profileLoaded = await loadProfile(preserveDraftIfDirty: false);

      if (!mounted) return;

      await Future.wait<void>([
        loadEmailSubscription(),
        loadReferenceData(),
        if (state.localization == null)
          loadLocalization(preserveDraftIfDirty: false),
      ]);

      if (!mounted) return;

      if (profileLoaded) {
        unawaited(_loadAddressDependenciesFromDraft());
      }

      _debugLog('loadInitial: complete');
    } catch (error) {
      if (!mounted) return;
      state = state.copyWith(errorMessage: _toErrorMessage(error));
    } finally {
      if (mounted) {
        state = state.copyWith(isLoadingInitial: false);
      }
    }
  }

  // ── Tab selection ─────────────────────────────────────────────────────────

  void selectTab(UserSettingsTab tab) {
    if (state.selectedTab == tab) return;

    state = state.copyWith(
      selectedTab: tab,
      errorMessage: null,
    );

    if (tab == UserSettingsTab.profile) {
      if (state.profile == null && !state.isLoadingProfile) {
        unawaited(loadProfile());
      }
      if (state.emailSubscription == null &&
          !state.isLoadingEmailSubscription) {
        unawaited(loadEmailSubscription());
      }
      final needsProfileReferences =
          state.countries.isEmpty || state.mobilePrefixes.isEmpty;
      if (needsProfileReferences && !state.isLoadingReferences) {
        unawaited(loadReferenceData());
      }
      return;
    }

    if (state.localization == null && !state.isLoadingLocalization) {
      unawaited(loadLocalization());
    }
    final needsLocalizationReferences = state.languages.isEmpty ||
        state.dateFormats.isEmpty ||
        state.timezones.isEmpty;
    if (needsLocalizationReferences && !state.isLoadingReferences) {
      unawaited(loadReferenceData());
    }
  }

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<bool> loadProfile({bool preserveDraftIfDirty = true}) async {
    if (!mounted) return false;
    if (state.isLoadingProfile) return false;

    _profileLoadCount++;
    _debugLog('loadProfile #$_profileLoadCount start');

    state = state.copyWith(
      isLoadingProfile: true,
      profileErrorMessage: null,
    );

    try {
      final profile = await _service.getProfile();
      if (!mounted) return true;

      final shouldKeepDraft = preserveDraftIfDirty && state.isProfileDirty;
      state = state.copyWith(
        profile: profile,
        draftProfile: shouldKeepDraft ? state.draftProfile : profile,
        isLoadingProfile: false,
      );
      _debugLog('loadProfile #$_profileLoadCount complete');
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isLoadingProfile: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> saveProfile() async {
    if (state.isSavingProfile) return false;

    final draft = state.draftProfile;
    if (draft == null || !state.isProfileDirty) return false;

    final validationError = _validateProfileDraft(draft);
    if (validationError != null) {
      state = state.copyWith(profileErrorMessage: validationError);
      return false;
    }

    final request = _buildUpdateProfileRequest(draft);

    state = state.copyWith(
      isSavingProfile: true,
      profileErrorMessage: null,
    );

    try {
      final updated = await _service.updateProfile(request);
      if (!mounted) return true;

      state = state.copyWith(
        profile: updated,
        draftProfile: updated,
        isSavingProfile: false,
      );
      unawaited(_loadAddressDependenciesFromDraft());
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isSavingProfile: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> updateCompany(UserUpdateCompanyRequest request) async {
    if (state.isSavingCompany) return false;

    final validationError = _validateCompanyRequest(request);
    if (validationError != null) {
      state = state.copyWith(profileErrorMessage: validationError);
      return false;
    }

    state = state.copyWith(
      isSavingCompany: true,
      profileErrorMessage: null,
    );

    try {
      await _service.updateCompany(request);
      final refreshed = await _service.getProfile();
      if (!mounted) return true;

      _applyRefreshedProfile(refreshed,
          preserveDraftEdits: state.isProfileDirty);
      state = state.copyWith(isSavingCompany: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isSavingCompany: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> changePassword(UserChangePasswordRequest request) async {
    if (state.isChangingPassword) return false;

    state = state.copyWith(
      isChangingPassword: true,
      profileErrorMessage: null,
    );

    try {
      await _service.changePassword(request);
      if (!mounted) return true;
      state = state.copyWith(isChangingPassword: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isChangingPassword: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> uploadProfilePhoto({
    required List<int> bytes,
    required String fileName,
  }) async {
    if (state.isUploadingProfilePhoto) return false;

    state = state.copyWith(
      isUploadingProfilePhoto: true,
      profileErrorMessage: null,
    );

    try {
      final refreshed = await _service.uploadProfilePhoto(
        bytes: bytes,
        fileName: fileName,
      );
      if (!mounted) return true;

      _applyRefreshedProfile(refreshed,
          preserveDraftEdits: state.isProfileDirty);
      state = state.copyWith(isUploadingProfilePhoto: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isUploadingProfilePhoto: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  // ── OTP ───────────────────────────────────────────────────────────────────

  Future<bool> requestEmailOtp() async {
    if (state.isRequestingEmailOtp) return false;
    state = state.copyWith(
      isRequestingEmailOtp: true,
      profileErrorMessage: null,
    );
    try {
      await _service.requestEmailOtp();
      if (!mounted) return true;
      state = state.copyWith(isRequestingEmailOtp: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isRequestingEmailOtp: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> confirmEmailOtp(String otp) async {
    if (state.isConfirmingEmailOtp) return false;
    state = state.copyWith(
      isConfirmingEmailOtp: true,
      profileErrorMessage: null,
    );
    try {
      await _service.confirmEmailOtp(otp);
      final refreshed = await _service.getProfile();
      if (!mounted) return true;

      _applyRefreshedProfile(refreshed,
          preserveDraftEdits: state.isProfileDirty);
      state = state.copyWith(isConfirmingEmailOtp: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isConfirmingEmailOtp: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> requestWhatsAppOtp() async {
    if (state.isRequestingWhatsAppOtp) return false;
    state = state.copyWith(
      isRequestingWhatsAppOtp: true,
      profileErrorMessage: null,
    );
    try {
      await _service.requestWhatsAppOtp();
      if (!mounted) return true;
      state = state.copyWith(isRequestingWhatsAppOtp: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isRequestingWhatsAppOtp: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> confirmWhatsAppOtp(String otp) async {
    if (state.isConfirmingWhatsAppOtp) return false;
    state = state.copyWith(
      isConfirmingWhatsAppOtp: true,
      profileErrorMessage: null,
    );
    try {
      await _service.confirmWhatsAppOtp(otp);
      final refreshed = await _service.getProfile();
      if (!mounted) return true;

      _applyRefreshedProfile(refreshed,
          preserveDraftEdits: state.isProfileDirty);
      state = state.copyWith(isConfirmingWhatsAppOtp: false);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isConfirmingWhatsAppOtp: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  // ── Email subscription ────────────────────────────────────────────────────

  Future<void> loadEmailSubscription() async {
    if (state.isLoadingEmailSubscription) return;
    state = state.copyWith(isLoadingEmailSubscription: true);

    try {
      final status = await _service.getEmailSubscription();
      if (!mounted) return;
      state = state.copyWith(
        emailSubscription: status,
        isLoadingEmailSubscription: false,
      );
    } catch (error) {
      if (!mounted) return;
      // Email subscription failure should not surface as profileErrorMessage
      // because that would disable Localization Save via isProfileTabBusy.
      // Keep it silent here; the card can show its own inline error.
      state = state.copyWith(isLoadingEmailSubscription: false);
    }
  }

  Future<bool> subscribeEmail() async {
    if (state.isSubscribingEmail) return false;
    state = state.copyWith(
      isSubscribingEmail: true,
      profileErrorMessage: null,
    );
    try {
      final status = await _service.subscribeEmail();
      if (!mounted) return true;
      state =
          state.copyWith(isSubscribingEmail: false, emailSubscription: status);
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isSubscribingEmail: false,
        profileErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  // ── Localization ──────────────────────────────────────────────────────────

  Future<bool> loadLocalization({bool preserveDraftIfDirty = true}) async {
    if (state.isLoadingLocalization) return false;

    _localizationLoadCount++;
    _debugLog('loadLocalization #$_localizationLoadCount start');

    state = state.copyWith(
      isLoadingLocalization: true,
      localizationErrorMessage: null,
    );

    try {
      final localization = await _service.getLocalization();
      if (!mounted) return true;

      final shouldKeepDraft = preserveDraftIfDirty && state.isLocalizationDirty;

      // Increment epoch so the tab widget re-syncs its text controllers.
      final newEpoch = state.localizationHydrationEpoch + 1;
      state = state.copyWith(
        localization: localization,
        draftLocalization:
            shouldKeepDraft ? state.draftLocalization : localization,
        isLoadingLocalization: false,
        localizationHydrationEpoch: newEpoch,
      );
      _debugLog('loadLocalization #$_localizationLoadCount complete '
          '(epoch=$newEpoch)');
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isLoadingLocalization: false,
        localizationErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> saveLocalization() async {
    if (state.isSavingLocalization) return false;

    final draft = state.draftLocalization;
    if (draft == null || !state.isLocalizationDirty) return false;

    final validationError = _validateLocalizationDraft(draft);
    if (validationError != null) {
      state = state.copyWith(localizationErrorMessage: validationError);
      return false;
    }

    state = state.copyWith(
      isSavingLocalization: true,
      localizationErrorMessage: null,
    );

    try {
      final saved = await _service.updateLocalization(draft);
      if (!mounted) return true;

      // Increment epoch so controllers re-hydrate from the canonical saved
      // values (normalised server floats may differ from typed intermediates).
      final newEpoch = state.localizationHydrationEpoch + 1;
      state = state.copyWith(
        localization: saved,
        draftLocalization: saved,
        isSavingLocalization: false,
        localizationHydrationEpoch: newEpoch,
      );
      _debugLog('saveLocalization complete (epoch=$newEpoch)');
      return true;
    } catch (error) {
      if (!mounted) return false;
      state = state.copyWith(
        isSavingLocalization: false,
        localizationErrorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  // ── References ────────────────────────────────────────────────────────────

  Future<void> loadReferenceData({bool force = false}) async {
    final shouldLoadLanguages = force || state.languages.isEmpty;
    final shouldLoadDateFormats = force || state.dateFormats.isEmpty;
    final shouldLoadTimezones = force || state.timezones.isEmpty;
    final shouldLoadCountries = force || state.countries.isEmpty;
    final shouldLoadMobilePrefixes = force || state.mobilePrefixes.isEmpty;

    if (!(shouldLoadLanguages ||
        shouldLoadDateFormats ||
        shouldLoadTimezones ||
        shouldLoadCountries ||
        shouldLoadMobilePrefixes)) {
      return;
    }

    if (state.isLoadingReferences) return;

    _referenceLoadCount++;
    _debugLog('loadReferenceData #$_referenceLoadCount start');

    state = state.copyWith(isLoadingReferences: true, errorMessage: null);

    final failedLabels = <String>[];

    final languageFuture = shouldLoadLanguages
        ? _loadReferenceSafely<List<UserLanguageOption>>(
            _service.getLanguages,
            failedLabels: failedLabels,
            label: 'languages',
          )
        : Future<List<UserLanguageOption>?>.value(null);

    final dateFormatsFuture = shouldLoadDateFormats
        ? _loadReferenceSafely<List<UserDateFormatOption>>(
            _service.getDateFormats,
            failedLabels: failedLabels,
            label: 'date formats',
          )
        : Future<List<UserDateFormatOption>?>.value(null);

    final timezoneFuture = shouldLoadTimezones
        ? _loadReferenceSafely<List<String>>(
            _service.getTimezones,
            failedLabels: failedLabels,
            label: 'timezones',
          )
        : Future<List<String>?>.value(null);

    final countriesFuture = shouldLoadCountries
        ? _loadReferenceSafely<List<UserCountryOption>>(
            _service.getCountries,
            failedLabels: failedLabels,
            label: 'countries',
          )
        : Future<List<UserCountryOption>?>.value(null);

    final mobilePrefixesFuture = shouldLoadMobilePrefixes
        ? _loadReferenceSafely<List<UserMobilePrefixOption>>(
            _service.getMobilePrefixes,
            failedLabels: failedLabels,
            label: 'mobile prefixes',
          )
        : Future<List<UserMobilePrefixOption>?>.value(null);

    final results = await Future.wait<dynamic>([
      languageFuture,
      dateFormatsFuture,
      timezoneFuture,
      countriesFuture,
      mobilePrefixesFuture,
    ]);

    if (!mounted) return;

    final failedMessage = failedLabels.isEmpty
        ? null
        : 'Some reference lists could not be loaded '
            '(${failedLabels.join(', ')}). You can continue and retry.';

    state = state.copyWith(
      languages: (results[0] as List<UserLanguageOption>?) ?? state.languages,
      dateFormats:
          (results[1] as List<UserDateFormatOption>?) ?? state.dateFormats,
      timezones: (results[2] as List<String>?) ?? state.timezones,
      countries: (results[3] as List<UserCountryOption>?) ?? state.countries,
      mobilePrefixes:
          (results[4] as List<UserMobilePrefixOption>?) ?? state.mobilePrefixes,
      isLoadingReferences: false,
      errorMessage: failedMessage,
    );
    _debugLog('loadReferenceData #$_referenceLoadCount complete');
  }

  // ── States loading (generation-counter guarded) ───────────────────────────

  Future<void> loadStates(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();

    if (normalized.isEmpty) {
      if (!mounted) return;
      state = state.copyWith(
        states: const <UserStateOption>[],
        cities: const <UserCityOption>[],
        statesForCountryCode: null,
        citiesForCountryAndStateCode: null,
        isLoadingStates: false,
        isLoadingCities: false,
      );
      return;
    }

    // Immediately clear dependent options so old lists are never visible.
    state = state.copyWith(
      states: const <UserStateOption>[],
      cities: const <UserCityOption>[],
      statesForCountryCode: null,
      citiesForCountryAndStateCode: null,
      isLoadingStates: true,
      isLoadingCities: false,
    );

    // Capture this request's generation counter before awaiting.
    _statesGeneration++;
    final thisGeneration = _statesGeneration;
    _debugLog('loadStates gen=$thisGeneration country=$normalized');

    // Cache hit.
    final cached = _statesCache[normalized];
    if (cached != null) {
      if (!mounted) return;
      if (_statesGeneration != thisGeneration) {
        _debugLog('loadStates gen=$thisGeneration STALE (cache) – ignored');
        return;
      }
      state = state.copyWith(
        states: cached,
        statesForCountryCode: normalized,
        isLoadingStates: false,
      );
      return;
    }

    try {
      final states = await _service.getStates(normalized);
      if (!mounted) return;

      if (_statesGeneration != thisGeneration) {
        _debugLog('loadStates gen=$thisGeneration STALE (network) – ignored');
        return;
      }

      _statesCache[normalized] = states;
      state = state.copyWith(
        states: states,
        statesForCountryCode: normalized,
        isLoadingStates: false,
      );
      _debugLog('loadStates gen=$thisGeneration applied country=$normalized '
          'count=${states.length}');
    } catch (error) {
      if (!mounted) return;
      if (_statesGeneration != thisGeneration) return;
      state = state.copyWith(
        states: const <UserStateOption>[],
        statesForCountryCode: normalized,
        isLoadingStates: false,
        profileErrorMessage: _toErrorMessage(error),
      );
    }
  }

  // ── Cities loading (generation-counter guarded) ───────────────────────────

  Future<void> loadCities(String countryCode, String stateCode) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final normalizedState = stateCode.trim().toUpperCase();

    if (normalizedCountry.isEmpty || normalizedState.isEmpty) {
      if (!mounted) return;
      state = state.copyWith(
        cities: const <UserCityOption>[],
        citiesForCountryAndStateCode: null,
        isLoadingCities: false,
      );
      return;
    }

    // Immediately clear old city options.
    state = state.copyWith(
      cities: const <UserCityOption>[],
      citiesForCountryAndStateCode: null,
      isLoadingCities: true,
    );

    _citiesGeneration++;
    final thisGeneration = _citiesGeneration;
    final cacheKey = '$normalizedCountry/$normalizedState';
    _debugLog('loadCities gen=$thisGeneration key=$cacheKey');

    // Cache hit.
    final cached = _citiesCache[cacheKey];
    if (cached != null) {
      if (!mounted) return;
      if (_citiesGeneration != thisGeneration) {
        _debugLog('loadCities gen=$thisGeneration STALE (cache) – ignored');
        return;
      }
      state = state.copyWith(
        cities: cached,
        citiesForCountryAndStateCode: cacheKey,
        isLoadingCities: false,
      );
      return;
    }

    try {
      final cities =
          await _service.getCities(normalizedCountry, normalizedState);
      if (!mounted) return;

      if (_citiesGeneration != thisGeneration) {
        _debugLog('loadCities gen=$thisGeneration STALE (network) – ignored');
        return;
      }

      _citiesCache[cacheKey] = cities;
      state = state.copyWith(
        cities: cities,
        citiesForCountryAndStateCode: cacheKey,
        isLoadingCities: false,
      );
      _debugLog('loadCities gen=$thisGeneration applied key=$cacheKey '
          'count=${cities.length}');
    } catch (error) {
      if (!mounted) return;
      if (_citiesGeneration != thisGeneration) return;
      state = state.copyWith(
        cities: const <UserCityOption>[],
        citiesForCountryAndStateCode: cacheKey,
        isLoadingCities: false,
        profileErrorMessage: _toErrorMessage(error),
      );
    }
  }

  // ── Draft management ──────────────────────────────────────────────────────

  void resetProfileDraft() {
    if (state.profile == null) return;
    state = state.copyWith(
      draftProfile: state.profile,
      profileErrorMessage: null,
    );
  }

  void resetLocalizationDraft() {
    if (state.localization == null) return;

    // Increment epoch so the tab re-hydrates text controllers from the
    // saved canonical values.
    final newEpoch = state.localizationHydrationEpoch + 1;
    _debugLog('resetLocalizationDraft epoch=$newEpoch');
    state = state.copyWith(
      draftLocalization: state.localization,
      localizationErrorMessage: null,
      localizationHydrationEpoch: newEpoch,
    );
  }

  void patchDraftProfile({
    String? name,
    String? email,
    String? mobilePrefix,
    String? mobileNumber,
    String? addressLine,
    String? countryCode,
    String? stateCode,
    String? cityName,
    String? pincode,
  }) {
    final current = state.draftProfile;
    if (current == null) return;

    final currentAddress = current.address ?? const UserSettingsAddress();
    final updatedAddress = currentAddress.copyWith(
      addressLine: addressLine,
      countryCode: countryCode,
      stateCode: stateCode,
      cityName: cityName,
      pincode: pincode,
    );

    state = state.copyWith(
      draftProfile: current.copyWith(
        name: name,
        email: email,
        mobilePrefix: mobilePrefix,
        mobileNumber: mobileNumber,
        address: updatedAddress,
      ),
      profileErrorMessage: null,
    );
  }

  void patchDraftLocalization({
    String? language,
    UserLayoutDirection? layoutDirection,
    String? dateFormat,
    bool? use24Hour,
    UserThemeMode? theme,
    String? timezoneOffset,
    UserDistanceUnit? units,
    double? defaultLat,
    double? defaultLon,
    int? mapZoom,
  }) {
    final base = state.draftLocalization ??
        state.localization ??
        UserLocalizationSettings.defaults;

    state = state.copyWith(
      draftLocalization: base.copyWith(
        language: language,
        layoutDirection: layoutDirection,
        dateFormat: dateFormat,
        use24Hour: use24Hour,
        theme: theme,
        timezoneOffset: timezoneOffset,
        units: units,
        defaultLat: defaultLat,
        defaultLon: defaultLon,
        mapZoom: mapZoom,
      ),
      localizationErrorMessage: null,
    );
  }

  // ── Refresh ───────────────────────────────────────────────────────────────

  Future<void> refreshCurrentTab({bool discardUnsaved = false}) async {
    if (state.selectedTab == UserSettingsTab.profile) {
      final profileLoaded = await loadProfile(
        preserveDraftIfDirty: !discardUnsaved,
      );
      await loadEmailSubscription();
      await loadReferenceData(force: discardUnsaved);

      if (profileLoaded) {
        await _loadAddressDependenciesFromDraft();
      }
      return;
    }

    await Future.wait<void>([
      loadLocalization(preserveDraftIfDirty: !discardUnsaved),
      loadReferenceData(force: discardUnsaved),
    ]);
  }

  // ── Error clearing ────────────────────────────────────────────────────────

  void clearErrorMessage() {
    if (state.errorMessage == null) return;
    state = state.copyWith(errorMessage: null);
  }

  void clearProfileErrorMessage() {
    if (state.profileErrorMessage == null) return;
    state = state.copyWith(profileErrorMessage: null);
  }

  void clearLocalizationErrorMessage() {
    if (state.localizationErrorMessage == null) return;
    state = state.copyWith(localizationErrorMessage: null);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<void> _loadAddressDependenciesFromDraft() async {
    final draft = state.draftProfile;
    final countryCode = draft?.address?.countryCode?.trim() ?? '';
    final stateCode = draft?.address?.stateCode?.trim() ?? '';

    if (countryCode.isEmpty) return;

    await loadStates(countryCode);
    if (!mounted || stateCode.isEmpty) return;

    await loadCities(countryCode, stateCode);
  }

  UserUpdateProfileRequest _buildUpdateProfileRequest(
      UserSettingsProfile draft) {
    final address = draft.address;
    return UserUpdateProfileRequest(
      name: (draft.name ?? '').trim(),
      email: _nullIfBlank(draft.email),
      mobilePrefix: (draft.mobilePrefix ?? '').trim(),
      mobileNumber: (draft.mobileNumber ?? '').trim(),
      addressLine: (address?.addressLine ?? '').trim(),
      countryCode: (address?.countryCode ?? '').trim(),
      stateCode: (address?.stateCode ?? '').trim(),
      cityName: (address?.cityName ?? '').trim(),
      pincode: _nullIfBlank(address?.pincode),
    );
  }

  String? _validateProfileDraft(UserSettingsProfile draft) {
    final name = draft.name?.trim() ?? '';
    if (name.isEmpty) return 'Name is required.';

    final mobilePrefix = draft.mobilePrefix?.trim() ?? '';
    if (mobilePrefix.isEmpty) return 'Mobile prefix is required.';

    final mobileNumber = draft.mobileNumber?.trim() ?? '';
    if (mobileNumber.isEmpty) return 'Mobile number is required.';

    final address = draft.address;
    if ((address?.addressLine?.trim() ?? '').isEmpty) {
      return 'Address line is required.';
    }
    if ((address?.countryCode?.trim() ?? '').isEmpty) {
      return 'Country is required.';
    }
    if ((address?.stateCode?.trim() ?? '').isEmpty) {
      return 'State is required.';
    }
    if ((address?.cityName?.trim() ?? '').isEmpty) {
      return 'City is required.';
    }

    final pincode = (address?.pincode?.trim() ?? '').trim();
    if (pincode.isNotEmpty) {
      if (pincode.length < Validators.minPincodeLength) {
        return 'Pincode must be at least ${Validators.minPincodeLength} digits.';
      }
      if (pincode.length > Validators.maxPincodeLength) {
        return 'Pincode must be ${Validators.maxPincodeLength} digits or fewer.';
      }
      if (!RegExp(r'^\d+$').hasMatch(pincode)) {
        return 'Pincode must be numeric.';
      }
    }

    return null;
  }

  String? _validateLocalizationDraft(UserLocalizationSettings draft) {
    if (draft.language.trim().isEmpty) return 'Language is required.';
    if (draft.dateFormat.trim().isEmpty) return 'Date format is required.';
    if (draft.timezoneOffset.trim().isEmpty) return 'Timezone is required.';
    if (draft.defaultLat < -90 || draft.defaultLat > 90) {
      return 'Latitude must be between -90 and 90.';
    }
    if (draft.defaultLon < -180 || draft.defaultLon > 180) {
      return 'Longitude must be between -180 and 180.';
    }
    if (draft.mapZoom < 1 || draft.mapZoom > 22) {
      return 'Map zoom must be between 1 and 22.';
    }
    return null;
  }

  Future<T?> _loadReferenceSafely<T>(
    Future<T> Function() loader, {
    required List<String> failedLabels,
    required String label,
  }) async {
    try {
      return await loader();
    } catch (_) {
      failedLabels.add(label);
      return null;
    }
  }

  String? _validateCompanyRequest(UserUpdateCompanyRequest request) {
    final companyName = request.name?.trim() ?? '';
    if (companyName.isEmpty) return 'Company name is required.';

    final invalidFields = <String>[];

    void validateUrlField(String label, String? rawValue) {
      final value = rawValue?.trim() ?? '';
      if (value.isEmpty) return;
      if (!_looksLikeUrl(value)) invalidFields.add(label);
    }

    validateUrlField('Website URL', request.websiteUrl);
    validateUrlField('Custom domain', request.customDomain);

    final socialLinks = request.socialLinks;
    validateUrlField('Facebook URL', socialLinks?.facebook);
    validateUrlField('Twitter/X URL', socialLinks?.twitter);
    validateUrlField('LinkedIn URL', socialLinks?.linkedin);
    validateUrlField('Instagram URL', socialLinks?.instagram);
    validateUrlField('YouTube URL', socialLinks?.youtube);
    validateUrlField('GitHub URL', socialLinks?.github);

    if (invalidFields.isNotEmpty) {
      return '${invalidFields.first} is not a valid URL.';
    }

    return null;
  }

  bool _looksLikeUrl(String rawValue) {
    final normalized = rawValue.trim();
    if (normalized.isEmpty) return false;

    final candidate =
        normalized.startsWith('http://') || normalized.startsWith('https://')
            ? normalized
            : 'https://$normalized';

    final uri = Uri.tryParse(candidate);
    return uri != null && uri.host.trim().isNotEmpty;
  }

  void _applyRefreshedProfile(
    UserSettingsProfile refreshed, {
    required bool preserveDraftEdits,
  }) {
    if (!mounted) return;

    if (!preserveDraftEdits || state.draftProfile == null) {
      state = state.copyWith(
        profile: refreshed,
        draftProfile: refreshed,
      );
      return;
    }

    final mergedDraft =
        _mergeServerManagedFields(state.draftProfile!, refreshed);
    state = state.copyWith(
      profile: refreshed,
      draftProfile: mergedDraft,
    );
  }

  UserSettingsProfile _mergeServerManagedFields(
    UserSettingsProfile draft,
    UserSettingsProfile server,
  ) {
    return draft.copyWith(
      uid: server.uid,
      username: server.username,
      profileUrl: server.profileUrl,
      credits: server.credits,
      createdAt: server.createdAt,
      updatedAt: server.updatedAt,
      isEmailVerified: server.isEmailVerified,
      emailVerifiedAt: server.emailVerifiedAt,
      isMobileVerified: server.isMobileVerified,
      mobileVerifiedAt: server.mobileVerifiedAt,
      company: server.company,
    );
  }

  String? _nullIfBlank(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    return normalized;
  }

  String _toErrorMessage(Object error) {
    if (error is ApiException) {
      final message = error.message.trim();
      return message.isNotEmpty ? message : 'Request failed. Please try again.';
    }

    if (error is DioException) {
      final responseMessage = _extractResponseMessage(error.response?.data);
      if (responseMessage != null) return responseMessage;

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'The request timed out. Please try again.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'Unable to reach the server right now.';
      }

      final message = error.message?.trim();
      if (message != null && message.isNotEmpty) return message;
    }

    final raw = error.toString().trim();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length).trim();
    }

    return raw;
  }

  String? _extractResponseMessage(dynamic data) {
    if (data is Map) {
      final map = data.map((key, value) => MapEntry(key.toString(), value));

      for (final key in const ['message', 'error']) {
        final value = map[key];

        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }

        if (value is List) {
          final items = value
              .whereType<String>()
              .map((entry) => entry.trim())
              .where((entry) => entry.isNotEmpty)
              .toList(growable: false);
          if (items.isNotEmpty) return items.join(', ');
        }
      }

      final nestedData = map['data'];
      if (!identical(nestedData, data)) {
        final nestedMessage = _extractResponseMessage(nestedData);
        if (nestedMessage != null) return nestedMessage;
      }
    }

    if (data is String && data.trim().isNotEmpty) return data.trim();

    return null;
  }
}
