import '../../../core/data/location_data.dart';
import '../models/admin_users_model.dart';

/// Resolves country and state codes to human-readable labels.
///
/// Priority order for each lookup:
///   1. Loaded API reference options (passed from the controller cache)
///   2. Hardcoded [LocationData] fallback
///   3. The raw code itself (safe, never crashes)
///
/// Call [resolveCountry] / [resolveState] from widgets. The caller supplies
/// the already-cached options from the controller so no network request
/// originates from any widget.
class LocationLabelResolver {
  const LocationLabelResolver._();

  // ---------------------------------------------------------------------------
  // Country
  // ---------------------------------------------------------------------------

  /// Returns the human-readable country name for [code], or [code] itself when
  /// no name can be found (never returns null / never crashes).
  static String resolveCountry(
    String code, {
    List<AdminUserCountryOption> apiOptions = const [],
  }) {
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty) return '';

    // 1. Loaded API options
    for (final option in apiOptions) {
      if (option.value.toUpperCase() == normalized) {
        return option.label;
      }
    }

    // 2. Hardcoded fallback
    for (final entry in LocationData.countries) {
      if ((entry['code'] ?? '').toUpperCase() == normalized) {
        return entry['name'] ?? normalized;
      }
    }

    // 3. Raw code safe fallback
    return normalized;
  }

  /// Returns the human-readable state name for [stateCode] within [countryCode].
  static String resolveState(
    String countryCode,
    String stateCode, {
    List<AdminUserStateOption> apiOptions = const [],
  }) {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final normalizedState = stateCode.trim().toUpperCase();
    if (normalizedState.isEmpty) return '';

    // 1. Loaded API options
    for (final option in apiOptions) {
      if (option.value.toUpperCase() == normalizedState) {
        return option.label;
      }
    }

    // 2. Hardcoded fallback
    final statesForCountry = LocationData.statesByCountry[normalizedCountry];
    if (statesForCountry != null) {
      for (final entry in statesForCountry) {
        if ((entry['code'] ?? '').toUpperCase() == normalizedState) {
          return entry['name'] ?? normalizedState;
        }
      }
    }

    // 3. Raw code safe fallback
    return normalizedState;
  }

  /// Returns the readable city label for a saved canonical city value.
  static String resolveCity(
    String value, {
    List<AdminUserCityOption> apiOptions = const [],
  }) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '';

    for (final option in apiOptions) {
      if (option.value.trim().toLowerCase() == normalized.toLowerCase()) {
        return option.label;
      }
    }

    return normalized;
  }

  /// Builds a sorted list of unique [AdminUserCountryOption] entries whose
  /// codes are present in [codes], resolved against [apiOptions] and the
  /// hardcoded fallback.
  static List<AdminUserCountryOption> resolvedCountryOptions(
    Iterable<String> codes, {
    List<AdminUserCountryOption> apiOptions = const [],
  }) {
    final seen = <String>{};
    final result = <AdminUserCountryOption>[];
    for (final code in codes) {
      final normalized = code.trim().toUpperCase();
      if (normalized.isEmpty || seen.contains(normalized)) continue;
      seen.add(normalized);
      result.add(AdminUserCountryOption(
        value: normalized,
        label: resolveCountry(normalized, apiOptions: apiOptions),
      ));
    }
    result.sort((a, b) => a.label.compareTo(b.label));
    return result;
  }
}
