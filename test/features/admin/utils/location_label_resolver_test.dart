import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/utils/location_label_resolver.dart';

void main() {
  // -------------------------------------------------------------------------
  // resolveCountry
  // -------------------------------------------------------------------------

  group('LocationLabelResolver.resolveCountry', () {
    test('resolves IN to India from hardcoded data (no API options)', () {
      expect(LocationLabelResolver.resolveCountry('IN'), 'India');
    });

    test('resolves NG to Nigeria from hardcoded data (no API options)', () {
      expect(LocationLabelResolver.resolveCountry('NG'), 'Nigeria');
    });

    test('API options take priority over hardcoded data', () {
      final apiOptions = [
        const AdminUserCountryOption(value: 'IN', label: 'Bharat'),
      ];
      expect(
        LocationLabelResolver.resolveCountry('IN', apiOptions: apiOptions),
        'Bharat',
      );
    });

    test('falls back to hardcoded data when code not in API options', () {
      final apiOptions = [
        const AdminUserCountryOption(value: 'NG', label: 'Nigeria (API)'),
      ];
      // IN is not in apiOptions → should hit the hardcoded fallback.
      expect(
        LocationLabelResolver.resolveCountry('IN', apiOptions: apiOptions),
        'India',
      );
    });

    test('unknown code returns the code itself without crashing', () {
      expect(LocationLabelResolver.resolveCountry('ZZ'), 'ZZ');
    });

    test('empty code returns empty string', () {
      expect(LocationLabelResolver.resolveCountry(''), '');
    });

    test('matching is case-insensitive for code', () {
      expect(LocationLabelResolver.resolveCountry('in'), 'India');
      expect(LocationLabelResolver.resolveCountry('ng'), 'Nigeria');
    });
  });

  group('LocationLabelResolver profile address labels', () {
    test('resolves India and Maharashtra without network catalogues', () {
      expect(LocationLabelResolver.resolveCountry('IN'), 'India');
      expect(LocationLabelResolver.resolveState('IN', 'MH'), 'Maharashtra');
    });

    test('resolves a canonical city value from loaded catalogue options', () {
      const cities = <AdminUserCityOption>[
        AdminUserCityOption(value: 'city-42', label: 'Mumbai'),
      ];

      expect(
        LocationLabelResolver.resolveCity('city-42', apiOptions: cities),
        'Mumbai',
      );
      expect(LocationLabelResolver.resolveCity('unknown'), 'unknown');
    });
  });

  // -------------------------------------------------------------------------
  // resolveState
  // -------------------------------------------------------------------------

  group('LocationLabelResolver.resolveState', () {
    test('resolves NG/LA to Lagos from hardcoded data', () {
      expect(LocationLabelResolver.resolveState('NG', 'LA'), 'Lagos');
    });

    test('resolves IN/MH to Maharashtra from hardcoded data', () {
      expect(LocationLabelResolver.resolveState('IN', 'MH'), 'Maharashtra');
    });

    test('API state options take priority over hardcoded data', () {
      final apiOptions = [
        const AdminUserStateOption(value: 'LA', label: 'Lagos (API)'),
      ];
      expect(
        LocationLabelResolver.resolveState('NG', 'LA', apiOptions: apiOptions),
        'Lagos (API)',
      );
    });

    test('unknown state code returns the code itself without crashing', () {
      expect(LocationLabelResolver.resolveState('NG', 'ZZ'), 'ZZ');
    });

    test('empty state code returns empty string', () {
      expect(LocationLabelResolver.resolveState('NG', ''), '');
    });
  });

  // -------------------------------------------------------------------------
  // resolvedCountryOptions — filter menu builds with readable labels
  // -------------------------------------------------------------------------

  group('LocationLabelResolver.resolvedCountryOptions', () {
    test('builds options with readable labels from hardcoded data', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['IN', 'NG']);
      final inOption = options.firstWhere((o) => o.value == 'IN');
      final ngOption = options.firstWhere((o) => o.value == 'NG');

      expect(inOption.label, 'India');
      expect(ngOption.label, 'Nigeria');
    });

    test('canonical code is preserved as the value', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['IN', 'NG']);
      final values = options.map((o) => o.value).toList();
      expect(values, containsAll(['IN', 'NG']));
    });

    test('API options are used when provided', () {
      final apiOptions = [
        const AdminUserCountryOption(value: 'IN', label: 'India (API)'),
      ];
      final options = LocationLabelResolver.resolvedCountryOptions(
        ['IN'],
        apiOptions: apiOptions,
      );
      expect(options.first.label, 'India (API)');
      expect(options.first.value, 'IN');
    });

    test('deduplicates repeated codes', () {
      final options = LocationLabelResolver.resolvedCountryOptions(
        ['IN', 'IN', 'NG', 'NG'],
      );
      expect(options.where((o) => o.value == 'IN').length, 1);
      expect(options.where((o) => o.value == 'NG').length, 1);
    });

    test('unknown code appears with code as both value and label', () {
      final options = LocationLabelResolver.resolvedCountryOptions(['ZZ']);
      expect(options.first.value, 'ZZ');
      expect(options.first.label, 'ZZ');
    });

    test('result is sorted alphabetically by label', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['NG', 'IN']);
      // India comes before Nigeria alphabetically.
      expect(options.first.label, 'India');
      expect(options.last.label, 'Nigeria');
    });
  });

  // -------------------------------------------------------------------------
  // Profile-level resolution helpers (inline logic mirrored from widget)
  // -------------------------------------------------------------------------

  group('profile countryName/stateName priority', () {
    test('non-empty countryName is preferred over code resolution', () {
      const countryName = 'India';
      const countryCode = 'IN';
      // Simulate the widget logic: prefer name, fall back to resolution.
      final label = countryName.trim().isNotEmpty
          ? countryName
          : LocationLabelResolver.resolveCountry(countryCode);
      expect(label, 'India');
    });

    test('empty countryName falls back to resolved code', () {
      const countryName = '';
      const countryCode = 'NG';
      final label = countryName.trim().isNotEmpty
          ? countryName
          : LocationLabelResolver.resolveCountry(countryCode);
      expect(label, 'Nigeria');
    });

    test('non-empty stateName is preferred over code resolution', () {
      const stateName = 'Lagos State';
      const countryCode = 'NG';
      const stateCode = 'LA';
      final label = stateName.trim().isNotEmpty
          ? stateName
          : LocationLabelResolver.resolveState(countryCode, stateCode);
      expect(label, 'Lagos State');
    });

    test('empty stateName falls back to resolved code', () {
      const stateName = '';
      const countryCode = 'NG';
      const stateCode = 'LA';
      final label = stateName.trim().isNotEmpty
          ? stateName
          : LocationLabelResolver.resolveState(countryCode, stateCode);
      expect(label, 'Lagos');
    });
  });

  // -------------------------------------------------------------------------
  // No per-card network request: resolver is pure / stateless
  // -------------------------------------------------------------------------

  group('resolver is pure (no network calls)', () {
    test('resolveCountry is a synchronous pure function', () {
      // If this were async / made network calls it would not complete
      // synchronously. Confirming it returns a plain String.
      final result = LocationLabelResolver.resolveCountry('IN');
      expect(result, isA<String>());
      expect(result, 'India');
    });

    test('resolveState is a synchronous pure function', () {
      final result = LocationLabelResolver.resolveState('NG', 'LA');
      expect(result, isA<String>());
      expect(result, 'Lagos');
    });
  });

  // -------------------------------------------------------------------------
  // Driver filter — canonical code stored, readable label displayed
  // -------------------------------------------------------------------------

  group('driver country filter: canonical value vs readable label', () {
    test('resolvedCountryOptions preserves canonical code as value', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['IN', 'NG']);
      for (final opt in options) {
        expect(opt.value, equals(opt.value.toUpperCase()),
            reason: 'value must be uppercase canonical code');
      }
      expect(options.map((o) => o.value), containsAll(['IN', 'NG']));
    });

    test('readable label differs from code for known countries', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['IN', 'NG']);
      final inOpt = options.firstWhere((o) => o.value == 'IN');
      final ngOpt = options.firstWhere((o) => o.value == 'NG');
      expect(inOpt.label, isNot(equals('IN')));
      expect(ngOpt.label, isNot(equals('NG')));
    });

    test('filter apply preserves canonical code, not the label', () {
      // Simulate: user sees "India" but the filter stores "IN".
      final options = LocationLabelResolver.resolvedCountryOptions(
        ['IN'],
        apiOptions: [
          const AdminUserCountryOption(value: 'IN', label: 'India'),
        ],
      );
      final selected = options.first;
      expect(selected.label, 'India');
      // The value sent to the controller/API must be the canonical code.
      expect(selected.value, 'IN');
    });

    test(
        'unknown code in driver list appears with code as both value and label',
        () {
      final options = LocationLabelResolver.resolvedCountryOptions(['XX']);
      expect(options.first.value, 'XX');
      expect(options.first.label, 'XX');
    });

    test('empty codes are excluded from filter options', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['IN', '', '  ']);
      expect(options.length, 1);
      expect(options.first.value, 'IN');
    });

    test('duplicate codes produce a single filter pill', () {
      final options =
          LocationLabelResolver.resolvedCountryOptions(['IN', 'IN', 'IN']);
      expect(options.where((o) => o.value == 'IN').length, 1);
    });
  });

  // -------------------------------------------------------------------------
  // Driver profile — resolved country and state labels
  // -------------------------------------------------------------------------

  group('driver profile: resolved country and state labels', () {
    test('resolveCountry returns readable name for profile country code', () {
      expect(LocationLabelResolver.resolveCountry('IN'), 'India');
      expect(LocationLabelResolver.resolveCountry('NG'), 'Nigeria');
    });

    test('resolveState returns readable name for profile state code', () {
      expect(LocationLabelResolver.resolveState('NG', 'LA'), 'Lagos');
      expect(LocationLabelResolver.resolveState('IN', 'MH'), 'Maharashtra');
    });

    test('unknown country code degrades to raw code (not empty, not null)', () {
      final result = LocationLabelResolver.resolveCountry('ZZ');
      expect(result, isNotEmpty);
      expect(result, 'ZZ');
    });

    test('unknown state code degrades to raw code (not empty, not null)', () {
      final result = LocationLabelResolver.resolveState('IN', 'ZZ');
      expect(result, isNotEmpty);
      expect(result, 'ZZ');
    });

    test('empty country code returns empty string, not null', () {
      final result = LocationLabelResolver.resolveCountry('');
      expect(result, '');
    });

    test('empty state code returns empty string, not null', () {
      final result = LocationLabelResolver.resolveState('IN', '');
      expect(result, '');
    });

    test('API state options override hardcoded for profile display', () {
      final stateOpts = [
        const AdminUserStateOption(value: 'MH', label: 'Maharashtra (API)'),
      ];
      final label = LocationLabelResolver.resolveState(
        'IN',
        'MH',
        apiOptions: stateOpts,
      );
      expect(label, 'Maharashtra (API)');
    });

    test('profile country resolution is case-insensitive', () {
      expect(LocationLabelResolver.resolveCountry('in'), 'India');
      expect(LocationLabelResolver.resolveCountry('IN'), 'India');
    });

    test('profile state resolution is case-insensitive', () {
      expect(LocationLabelResolver.resolveState('NG', 'la'), 'Lagos');
      expect(LocationLabelResolver.resolveState('NG', 'LA'), 'Lagos');
    });

    test('dash placeholder "-" resolves to dash (not a country name)', () {
      // "-" is used as a sentinel value in AdminDriverAddress.
      final result = LocationLabelResolver.resolveCountry('-');
      // "-" is not a valid ISO code so it falls back to itself.
      expect(result, '-');
    });
  });

  // -------------------------------------------------------------------------
  // One state-options load per country (stateless resolver contract)
  // -------------------------------------------------------------------------

  group('stateless resolver — no per-row side effects', () {
    test('resolveCountry called N times for N drivers never accumulates state',
        () {
      // Calling the pure resolver multiple times with the same code must
      // always return the same value (no mutable cache that could drift).
      const codes = ['IN', 'NG', 'IN', 'NG', 'IN'];
      final results = codes.map(LocationLabelResolver.resolveCountry).toList();
      expect(results[0], results[2]);
      expect(results[2], results[4]);
      expect(results[1], results[3]);
    });

    test('resolveState called N times for N drivers never accumulates state',
        () {
      const pairs = [('NG', 'LA'), ('NG', 'LA'), ('IN', 'MH')];
      final r0 = LocationLabelResolver.resolveState(pairs[0].$1, pairs[0].$2);
      final r1 = LocationLabelResolver.resolveState(pairs[1].$1, pairs[1].$2);
      final r2 = LocationLabelResolver.resolveState(pairs[2].$1, pairs[2].$2);
      expect(r0, r1);
      expect(r2, 'Maharashtra');
    });
  });
}
