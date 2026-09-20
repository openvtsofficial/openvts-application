import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_driver_details_model.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminDriverAddress _parse({
  Map<String, dynamic> address = const {},
  Map<String, dynamic> root = const {},
}) =>
    AdminDriverAddress.fromJson(address, root);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Complete nested address
  // -------------------------------------------------------------------------

  group('complete nested address', () {
    late AdminDriverAddress result;

    setUp(() {
      result = _parse(
        address: {
          'addressLine': '12 Main St',
          'city': 'Lagos',
          'stateCode': 'LA',
          'countryCode': 'NG',
          'pincode': '100001',
        },
      );
    });

    test('addressLine', () => expect(result.addressLine, '12 Main St'));
    test('cityId', () => expect(result.cityId, 'Lagos'));
    test('stateCode', () => expect(result.stateCode, 'LA'));
    test('countryCode', () => expect(result.countryCode, 'NG'));
    test('pincode', () => expect(result.pincode, '100001'));

    test('fullAddress joins all parts without duplication', () {
      expect(result.fullAddress, '12 Main St, Lagos, LA, NG, 100001');
    });
  });

  // -------------------------------------------------------------------------
  // Partial nested address
  // -------------------------------------------------------------------------

  group('partial nested address (city + country only)', () {
    late AdminDriverAddress result;

    setUp(() {
      result = _parse(
        address: {
          'city': 'Abuja',
          'countryCode': 'NG',
        },
      );
    });

    test('addressLine is empty string', () => expect(result.addressLine, ''));
    test('stateCode is empty string', () => expect(result.stateCode, ''));
    test('pincode is empty string', () => expect(result.pincode, ''));
    test('cityId is parsed', () => expect(result.cityId, 'Abuja'));
    test('countryCode is parsed', () => expect(result.countryCode, 'NG'));

    test('fullAddress omits missing parts', () {
      expect(result.fullAddress, 'Abuja, NG');
    });
  });

  // -------------------------------------------------------------------------
  // Root address map must not be stringified into addressLine
  // -------------------------------------------------------------------------

  group('root "address" key is a Map – must not stringify', () {
    test('map under root address key does not leak into addressLine', () {
      final result = _parse(
        address: const {},
        root: {
          'address': {'line1': 'should not appear'},
          'city': 'Mumbai',
          'countryCode': 'IN',
        },
      );
      // addressLine must not contain '{' or map text
      expect(result.addressLine, isNot(contains('{')));
      expect(result.addressLine, '');
    });

    test('scalar city/country from root are still parsed', () {
      final result = _parse(
        address: const {},
        root: {
          'address': {'line1': 'nested'},
          'city': 'Mumbai',
          'countryCode': 'IN',
        },
      );
      expect(result.cityId, 'Mumbai');
      expect(result.countryCode, 'IN');
    });
  });

  // -------------------------------------------------------------------------
  // Confirmed flat scalar fallback (root-level scalar 'address' key)
  // -------------------------------------------------------------------------

  group('flat scalar fallback from root', () {
    test('scalar root address falls back to addressLine when nested is absent',
        () {
      // When 'address' in root is a plain String (flat payload), it should
      // be treated as the address line.
      // NOTE: AdminDriverDetails.fromJson strips root['address'] into the
      // nested address map via _firstMap, so a String value in root['address']
      // would not be passed as the address Map.  The flat-field fallback uses
      // root['addressLine'] or root['address_line'] as scalar keys instead.
      final result = _parse(
        address: const {},
        root: {'addressLine': '5 Baker St', 'countryCode': 'GB'},
      );
      expect(result.addressLine, '5 Baker St');
      expect(result.countryCode, 'GB');
    });
  });

  // -------------------------------------------------------------------------
  // null / empty / whitespace normalization
  // -------------------------------------------------------------------------

  group('null, empty and whitespace values', () {
    test('null value produces empty string field', () {
      final result = _parse(address: {'addressLine': null});
      expect(result.addressLine, '');
    });

    test('empty string value produces empty string field', () {
      final result = _parse(address: {'addressLine': ''});
      expect(result.addressLine, '');
    });

    test('whitespace-only value produces empty string field', () {
      final result = _parse(address: {'addressLine': '   '});
      expect(result.addressLine, '');
    });

    test('all-null address produces all-empty fields', () {
      final result = _parse();
      expect(result.addressLine, '');
      expect(result.cityId, '');
      expect(result.stateCode, '');
      expect(result.countryCode, '');
      expect(result.pincode, '');
      expect(result.fullAddress, '');
    });
  });

  // -------------------------------------------------------------------------
  // Legacy '-' sentinel normalization
  // -------------------------------------------------------------------------

  group("'-' sentinel is normalized to empty string", () {
    test('addressLine sentinel', () {
      expect(_parse(address: {'addressLine': '-'}).addressLine, '');
    });

    test('stateCode sentinel', () {
      expect(_parse(address: {'stateCode': '-'}).stateCode, '');
    });

    test('countryCode sentinel', () {
      expect(_parse(address: {'countryCode': '-'}).countryCode, '');
    });

    test('city sentinel', () {
      expect(_parse(address: {'city': '-'}).cityId, '');
    });

    test('pincode sentinel', () {
      expect(_parse(address: {'pincode': '-'}).pincode, '');
    });

    test("sentinel fields are excluded from composed fullAddress", () {
      final result = _parse(
        address: {
          'addressLine': '-',
          'city': 'Lagos',
          'stateCode': '-',
          'countryCode': 'NG',
          'pincode': '-',
        },
      );
      expect(result.fullAddress, 'Lagos, NG');
    });
  });

  // -------------------------------------------------------------------------
  // fullAddress precedence
  // -------------------------------------------------------------------------

  group('fullAddress precedence', () {
    test('API fullAddress overrides composed value', () {
      final result = _parse(
        address: {
          'fullAddress': 'Flat 3, Victoria Island, Lagos, Nigeria',
          'addressLine': '12 Main St',
          'city': 'Lagos',
          'countryCode': 'NG',
        },
      );
      expect(result.fullAddress, 'Flat 3, Victoria Island, Lagos, Nigeria');
    });

    test('API fullAddress sentinel "-" falls through to composed', () {
      final result = _parse(
        address: {
          'fullAddress': '-',
          'city': 'Lagos',
          'countryCode': 'NG',
        },
      );
      expect(result.fullAddress, 'Lagos, NG');
    });

    test('missing fullAddress falls back to composed parts', () {
      final result = _parse(
        address: {'city': 'Kano', 'countryCode': 'NG'},
      );
      expect(result.fullAddress, 'Kano, NG');
    });
  });

  // -------------------------------------------------------------------------
  // Non-duplicated formatted address
  // -------------------------------------------------------------------------

  group('composed fullAddress has no duplicate components', () {
    test('each component appears exactly once', () {
      final result = _parse(
        address: {
          'addressLine': '10 Test Rd',
          'city': 'Ibadan',
          'stateCode': 'OY',
          'countryCode': 'NG',
          'pincode': '200001',
        },
      );
      final parts = result.fullAddress.split(', ');
      // All distinct parts, no repeats.
      expect(parts.toSet().length, parts.length);
      expect(parts, ['10 Test Rd', 'Ibadan', 'OY', 'NG', '200001']);
    });

    test('empty components are not included in composed address', () {
      final result = _parse(
        address: {'city': 'Kano', 'countryCode': 'NG'},
      );
      expect(result.fullAddress.contains(', ,'), isFalse);
      expect(result.fullAddress, isNot(startsWith(', ')));
      expect(result.fullAddress, isNot(endsWith(', ')));
    });
  });

  // -------------------------------------------------------------------------
  // Map / List values must never appear in scalar fields
  // -------------------------------------------------------------------------

  group('Map and List values are rejected for scalar fields', () {
    test('map value in addressLine key is rejected', () {
      final result = _parse(
        address: {
          'addressLine': {'nested': 'map'},
        },
      );
      expect(result.addressLine, '');
      expect(result.addressLine, isNot(contains('{')));
    });

    test('list value in city key is rejected', () {
      final result = _parse(
        address: {
          'city': <String>['Lagos']
        },
      );
      expect(result.cityId, '');
    });

    test('map value for countryCode is rejected', () {
      final result = _parse(
        address: {
          'countryCode': {'code': 'NG'},
        },
      );
      expect(result.countryCode, '');
    });
  });

  // -------------------------------------------------------------------------
  // Edit Profile blank prefill
  // -------------------------------------------------------------------------

  group('Edit Profile blank prefill (no address supplied)', () {
    test('addressLine is empty when address was absent', () {
      final result = _parse();
      // The edit sheet uses result.addressLine directly; it must be ''.
      expect(result.addressLine, '');
    });

    test('pincode is empty when address was absent', () {
      final result = _parse();
      expect(result.pincode, '');
    });

    test('countryCode is empty (not "-") when absent', () {
      final result = _parse();
      expect(result.countryCode, isNot('-'));
    });

    test('stateCode is empty (not "-") when absent', () {
      final result = _parse();
      expect(result.stateCode, isNot('-'));
    });

    test('cityId is empty (not "-") when absent', () {
      final result = _parse();
      expect(result.cityId, isNot('-'));
    });
  });

  // -------------------------------------------------------------------------
  // Update request must not send placeholder text
  // -------------------------------------------------------------------------

  group('update request excludes placeholder text', () {
    test('address field in request is empty string when not provided', () {
      const request = AdminDriverUpdateRequest(
        name: 'Test Driver',
        mobilePrefix: '+91',
        mobile: '9999999999',
        email: 'test@example.com',
        username: 'testdriver',
        countryCode: 'IN',
        stateCode: 'MH',
        city: 'Mumbai',
        address: '',
        pincode: '',
        attributes: {},
      );
      final json = request.toJson();
      expect(json['address'], '');
      expect(json['address'], isNot('-'));
      expect(json['address'], isNot(contains('{')));
    });

    test('pincode field in request is empty string when not provided', () {
      const request = AdminDriverUpdateRequest(
        name: 'Test Driver',
        mobilePrefix: '+91',
        mobile: '9999999999',
        email: '',
        username: 'testdriver',
        countryCode: 'IN',
        stateCode: 'MH',
        city: 'Mumbai',
        address: '',
        pincode: '',
        attributes: {},
      );
      final json = request.toJson();
      expect(json['pincode'], '');
    });
  });
}
