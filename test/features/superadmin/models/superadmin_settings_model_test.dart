import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/models/superadmin_settings_model.dart';

void main() {
  // -----------------------------------------------------------------------
  // 1. SuperadminUpdateProfileRequest.toJson — city serialization
  // -----------------------------------------------------------------------
  group('SuperadminUpdateProfileRequest.toJson', () {
    test('contains cityName when city is set', () {
      final req = const SuperadminUpdateProfileRequest(
        name: 'Test',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: '123 Main St',
        countryCode: 'IN',
        stateCode: 'CH',
        cityName: 'Bastar',
      );
      final json = req.toJson();
      expect(json['cityName'], 'Bastar');
    });

    test('does NOT contain city alias', () {
      final req = const SuperadminUpdateProfileRequest(
        name: 'Test',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: '123 Main St',
        countryCode: 'IN',
        stateCode: 'CH',
        cityName: 'Bastar',
      );
      final json = req.toJson();
      expect(json.containsKey('city'), isFalse);
    });

    test('accepted DTO key set matches backend ProfileDto exactly', () {
      final req = const SuperadminUpdateProfileRequest(
        name: 'Test',
        email: 'test@example.com',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: '123 Main St',
        countryCode: 'IN',
        stateCode: 'CH',
        cityName: 'Bastar',
        pincode: '494001',
      );
      final json = req.toJson();
      const allowed = {
        'name',
        'email',
        'mobilePrefix',
        'mobileNumber',
        'addressLine',
        'countryCode',
        'stateCode',
        'cityName',
        'pincode',
      };
      for (final key in json.keys) {
        expect(allowed.contains(key), isTrue,
            reason: 'Unexpected key "$key" in toJson output');
      }
    });

    test('omits optional pincode when null', () {
      final req = const SuperadminUpdateProfileRequest(
        name: 'Test',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: '123 Main St',
        countryCode: 'IN',
        stateCode: 'CH',
        cityName: 'Bastar',
      );
      final json = req.toJson();
      expect(json.containsKey('pincode'), isFalse);
    });

    test('omits optional email when null', () {
      final req = const SuperadminUpdateProfileRequest(
        name: 'Test',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: '123 Main St',
        countryCode: 'IN',
        stateCode: 'CH',
        cityName: 'Bastar',
      );
      final json = req.toJson();
      expect(json.containsKey('email'), isFalse);
    });
  });

  // -----------------------------------------------------------------------
  // 4. SuperadminAddressSettings.fromJson — string cityId
  // -----------------------------------------------------------------------
  group('SuperadminAddressSettings.fromJson', () {
    test('parses string cityId as city display name', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'cityId': 'Bastar',
      });
      expect(addr.cityDisplayName, 'Bastar');
    });

    test('prefers explicit cityName over cityId', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'cityName': 'Raipur',
        'cityId': 'Bastar',
      });
      expect(addr.cityDisplayName, 'Raipur');
    });

    test('parses city_name field', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'city_name': 'Bilaspur',
      });
      expect(addr.cityDisplayName, 'Bilaspur');
    });

    test('parses city field', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'city': 'Durg',
      });
      expect(addr.cityDisplayName, 'Durg');
    });

    test('numeric-looking cityId string is preserved', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'cityId': '12345',
      });
      // String "12345" is a valid city identifier — must not be lost.
      expect(addr.cityId, '12345');
      expect(addr.cityDisplayName, '12345');
    });

    test('cityDisplayName is null when all city fields are absent', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'addressLine': '123 Main St',
      });
      expect(addr.cityDisplayName, isNull);
    });

    test('city_id string field is parsed', () {
      final addr = SuperadminAddressSettings.fromJson(<String, dynamic>{
        'city_id': 'Jagdalpur',
      });
      expect(addr.cityId, 'Jagdalpur');
      expect(addr.cityDisplayName, 'Jagdalpur');
    });
  });

  // -----------------------------------------------------------------------
  // SuperadminProfileSettings.fromJson — city propagation from address
  // -----------------------------------------------------------------------
  group('SuperadminProfileSettings.fromJson', () {
    test('cityName propagated from address.cityId string', () {
      final profile = SuperadminProfileSettings.fromJson(<String, dynamic>{
        'name': 'Superadmin',
        'address': <String, dynamic>{
          'addressLine': '123 Main St',
          'countryCode': 'IN',
          'stateCode': 'CG',
          'cityId': 'Bastar',
        },
      });
      expect(profile.cityName, 'Bastar');
      expect(profile.address?.cityDisplayName, 'Bastar');
    });

    test('cityName propagated from address.cityName', () {
      final profile = SuperadminProfileSettings.fromJson(<String, dynamic>{
        'name': 'Superadmin',
        'address': <String, dynamic>{
          'cityName': 'Raipur',
        },
      });
      expect(profile.cityName, 'Raipur');
    });

    test('city remains visible after re-parse (refresh simulation)', () {
      final json = <String, dynamic>{
        'name': 'Superadmin',
        'address': <String, dynamic>{
          'addressLine': '123 Main St',
          'countryCode': 'IN',
          'stateCode': 'CG',
          'cityId': 'Bastar',
          'pincode': '494001',
        },
      };
      final profile1 = SuperadminProfileSettings.fromJson(json);
      final profile2 = SuperadminProfileSettings.fromJson(json);
      expect(profile1.address?.cityDisplayName, 'Bastar');
      expect(profile2.address?.cityDisplayName, 'Bastar');
    });
  });

  // -----------------------------------------------------------------------
  // SuperadminAddressSettings.copyWith — cityId stays String
  // -----------------------------------------------------------------------
  group('SuperadminAddressSettings.copyWith', () {
    test('cityId can be updated with a string value', () {
      const addr = SuperadminAddressSettings(cityId: 'Old City');
      final updated = addr.copyWith(cityId: 'New City');
      expect(updated.cityId, 'New City');
      expect(updated.cityDisplayName, 'New City');
    });
  });

  // -----------------------------------------------------------------------
  // SuperadminLocalizationSettings.toJson — distanceUnit removed
  // -----------------------------------------------------------------------
  group('SuperadminLocalizationSettings.toJson', () {
    late SuperadminLocalizationSettings loc;

    setUp(() {
      loc = const SuperadminLocalizationSettings(
        language: 'en',
        layoutDirection: SuperadminLayoutDirection.ltr,
        dateFormat: 'YYYY-MM-DD',
        use24Hour: true,
        theme: SuperadminTheme.system,
        timezoneOffset: '+05:30',
        units: SuperadminUnits.km,
        defaultLat: 0,
        defaultLon: 0,
        mapZoom: 10,
      );
    });

    test('contains units key', () {
      expect(loc.toJson(), containsPair('units', 'KM'));
    });

    test('does NOT contain distanceUnit key', () {
      expect(loc.toJson().containsKey('distanceUnit'), isFalse);
    });

    test('exact top-level key set matches UpdateSettingsStateDto', () {
      expect(
        loc.toJson().keys.toSet(),
        equals({
          'language',
          'layoutDirection',
          'dateFormat',
          'use24Hour',
          'theme',
          'timezoneOffset',
          'units',
          'defaultLat',
          'defaultLon',
          'mapZoom',
        }),
      );
    });

    test('miles units serializes as MILES', () {
      final milesLoc = const SuperadminLocalizationSettings(
        language: 'en',
        layoutDirection: SuperadminLayoutDirection.ltr,
        dateFormat: 'YYYY-MM-DD',
        use24Hour: false,
        theme: SuperadminTheme.light,
        timezoneOffset: '+00:00',
        units: SuperadminUnits.miles,
        defaultLat: 0,
        defaultLon: 0,
        mapZoom: 10,
      );
      expect(milesLoc.toJson()['units'], 'MILES');
    });
  });

  // -----------------------------------------------------------------------
  // SuperadminLanguageOption — filtering to supported locales
  // -----------------------------------------------------------------------
  group('SuperadminLanguageOption list filtering', () {
    final backendOptions = [
      const SuperadminLanguageOption(code: 'en', label: 'English'),
      const SuperadminLanguageOption(code: 'hi', label: 'Hindi'),
      const SuperadminLanguageOption(code: 'ar', label: 'Arabic'),
      const SuperadminLanguageOption(code: 'es', label: 'Spanish'),
      const SuperadminLanguageOption(code: 'fr', label: 'French'),
      const SuperadminLanguageOption(code: 'pt', label: 'Portuguese'),
      // unsupported backend-only languages
      const SuperadminLanguageOption(code: 'ru', label: 'Russian'),
      const SuperadminLanguageOption(code: 'de', label: 'German'),
      const SuperadminLanguageOption(code: 'zh-Hans', label: 'Chinese'),
      const SuperadminLanguageOption(
          code: 'pt-BR', label: 'Portuguese (Brazil)'),
      const SuperadminLanguageOption(
          code: 'pt-PT', label: 'Portuguese (Portugal)'),
    ];

    const supportedCodes = {'ar', 'en', 'es', 'fr', 'hi', 'pt'};

    String normalizeLangCode(String code) {
      final base = code.split('-').first.split('_').first.toLowerCase();
      if (base == 'pt') return 'pt';
      return base;
    }

    List<SuperadminLanguageOption> filterToSupported(
        List<SuperadminLanguageOption> options) {
      final seen = <String>{};
      final result = <SuperadminLanguageOption>[];
      for (final o in options) {
        final normalized = normalizeLangCode(o.code);
        if (supportedCodes.contains(normalized) && seen.add(normalized)) {
          result
              .add(SuperadminLanguageOption(code: normalized, label: o.label));
        }
      }
      return result;
    }

    test('excludes unsupported backend languages', () {
      final filtered = filterToSupported(backendOptions);
      final codes = filtered.map((o) => o.code).toSet();
      expect(codes.contains('ru'), isFalse);
      expect(codes.contains('de'), isFalse);
      expect(codes.contains('zh-Hans'), isFalse);
    });

    test('includes all six supported locales', () {
      final filtered = filterToSupported(backendOptions);
      final codes = filtered.map((o) => o.code).toSet();
      expect(codes, equals(supportedCodes));
    });

    test('pt-BR and pt-PT both collapse to pt without duplication', () {
      final ptOnly = [
        const SuperadminLanguageOption(
            code: 'pt-BR', label: 'Portuguese (Brazil)'),
        const SuperadminLanguageOption(
            code: 'pt-PT', label: 'Portuguese (Portugal)'),
      ];
      final filtered = filterToSupported(ptOnly);
      expect(filtered.length, 1);
      expect(filtered.first.code, 'pt');
    });

    test('filtered list length equals number of supported locales', () {
      final filtered = filterToSupported(backendOptions);
      expect(filtered.length, supportedCodes.length);
    });

    test('normalization is case-insensitive', () {
      expect(normalizeLangCode('EN'), 'en');
      expect(normalizeLangCode('Pt-BR'), 'pt');
      expect(normalizeLangCode('ZH-Hans'), 'zh');
    });
  });

  // -----------------------------------------------------------------------
  // SuperadminUpdateProfileRequest.toJson — optional subdivision contract
  // (Required FIX 2: '' vs null vs omitted)
  // -----------------------------------------------------------------------
  group('SuperadminUpdateProfileRequest.toJson — optional subdivisions', () {
    test('empty stateCode is serialized as empty string, not omitted', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'AX',
        stateCode: '',
        cityName: '',
      ).toJson();
      expect(json.containsKey('stateCode'), isTrue,
          reason: 'stateCode="" must appear in JSON');
      expect(json['stateCode'], '',
          reason: 'stateCode must be empty string, not null');
      expect(json.containsKey('cityName'), isTrue,
          reason: 'cityName="" must appear in JSON');
      expect(json['cityName'], '',
          reason: 'cityName must be empty string, not null');
    });

    test('non-empty stateCode is serialized verbatim', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'IN',
        stateCode: 'MH',
        cityName: 'Mumbai',
      ).toJson();
      expect(json['stateCode'], 'MH');
      expect(json['cityName'], 'Mumbai');
    });

    test('null stateCode is omitted (not sent as null)', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'IN',
      ).toJson();
      expect(json.containsKey('stateCode'), isFalse);
      expect(json.containsKey('cityName'), isFalse);
    });

    test('empty cityName with non-empty stateCode sends both', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'US',
        stateCode: 'TX',
        cityName: '',
      ).toJson();
      expect(json['stateCode'], 'TX');
      expect(json['cityName'], '');
    });

    test('countryCode is always included when set', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'AX',
        stateCode: '',
        cityName: '',
      ).toJson();
      expect(json['countryCode'], 'AX');
    });
  });
}
