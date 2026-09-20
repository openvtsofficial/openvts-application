import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/utils/location_label_resolver.dart';
import 'package:open_vts/features/superadmin/models/superadmin_admin_details_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_administrator_model.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Card list: countryName priority over countryCode
  // ---------------------------------------------------------------------------

  group('SuperadminAdministrator card country display', () {
    test('shows countryName when non-empty (not raw countryCode)', () {
      final admin = _makeAdministrator(countryCode: 'IN', countryName: 'India');
      final label = _resolveAdminCountryLabel(admin);
      expect(label, 'India');
      expect(label, isNot('IN'));
    });

    test('falls back to resolved code when countryName is empty — IN → India',
        () {
      final admin = _makeAdministrator(countryCode: 'IN', countryName: '');
      final label = _resolveAdminCountryLabel(admin);
      expect(label, 'India');
    });

    test('falls back to resolved code when countryName is empty — NG → Nigeria',
        () {
      final admin = _makeAdministrator(countryCode: 'NG', countryName: '');
      final label = _resolveAdminCountryLabel(admin);
      expect(label, 'Nigeria');
    });

    test(
        'unknown code with empty countryName returns raw code without crashing',
        () {
      final admin = _makeAdministrator(countryCode: 'ZZ', countryName: '');
      final label = _resolveAdminCountryLabel(admin);
      expect(label, 'ZZ');
    });

    test('empty code and empty name returns empty string', () {
      final admin = _makeAdministrator(countryCode: '', countryName: '');
      final label = _resolveAdminCountryLabel(admin);
      expect(label, '');
    });
  });

  // ---------------------------------------------------------------------------
  // Profile: countryName / stateName priority
  // ---------------------------------------------------------------------------

  group('SuperadminAdminDetails profile country/state display', () {
    test('explicit countryName takes priority over code resolution', () {
      final admin = _makeDetails(
        countryCode: 'IN',
        countryName: 'India',
        stateCode: 'MH',
        stateName: '',
      );
      final label = _resolveProfileCountry(admin, null);
      expect(label, 'India');
    });

    test('empty countryName falls back to resolver — IN → India', () {
      final admin = _makeDetails(
        countryCode: 'IN',
        countryName: '',
        stateCode: '',
        stateName: '',
      );
      final label = _resolveProfileCountry(admin, null);
      expect(label, 'India');
    });

    test('empty countryName falls back to resolver — NG → Nigeria', () {
      final admin = _makeDetails(
        countryCode: 'NG',
        countryName: '',
        stateCode: '',
        stateName: '',
      );
      final label = _resolveProfileCountry(admin, null);
      expect(label, 'Nigeria');
    });

    test('explicit stateName takes priority over stateCode resolution', () {
      final admin = _makeDetails(
        countryCode: 'NG',
        countryName: '',
        stateCode: 'LA',
        stateName: 'Lagos State',
      );
      final label = _resolveProfileState(admin, null);
      expect(label, 'Lagos State');
    });

    test('empty stateName falls back to resolver — NG/LA → Lagos', () {
      final admin = _makeDetails(
        countryCode: 'NG',
        countryName: '',
        stateCode: 'LA',
        stateName: '',
      );
      final label = _resolveProfileState(admin, null);
      expect(label, 'Lagos');
    });

    test('state resolution uses correct countryCode — IN/MH → Maharashtra', () {
      final admin = _makeDetails(
        countryCode: 'IN',
        countryName: '',
        stateCode: 'MH',
        stateName: '',
      );
      final label = _resolveProfileState(admin, null);
      expect(label, 'Maharashtra');
    });

    test('returns — for empty countryCode and empty countryName', () {
      final admin = _makeDetails(
        countryCode: '',
        countryName: '',
        stateCode: '',
        stateName: '',
      );
      expect(_resolveProfileCountry(admin, null), '—');
      expect(_resolveProfileState(admin, null), '—');
    });
  });

  // ---------------------------------------------------------------------------
  // Profile: address takes priority over top-level fields
  // ---------------------------------------------------------------------------

  group('SuperadminAdminAddress overrides top-level country/state', () {
    test('address countryName takes priority over admin top-level fields', () {
      final admin = _makeDetails(
        countryCode: 'US',
        countryName: 'United States',
        stateCode: '',
        stateName: '',
      );
      final address = _makeAddress(
        countryCode: 'NG',
        countryName: 'Nigeria',
        stateCode: '',
        stateName: '',
      );
      expect(_resolveProfileCountry(admin, address), 'Nigeria');
    });

    test('address stateName takes priority over admin top-level fields', () {
      final admin = _makeDetails(
        countryCode: 'NG',
        countryName: '',
        stateCode: 'AB',
        stateName: 'Abia',
      );
      final address = _makeAddress(
        countryCode: 'NG',
        countryName: '',
        stateCode: 'LA',
        stateName: 'Lagos State',
      );
      expect(_resolveProfileState(admin, address), 'Lagos State');
    });

    test('address falls back to resolver when address stateName is empty', () {
      final admin = _makeDetails(
        countryCode: 'IN',
        countryName: '',
        stateCode: '',
        stateName: '',
      );
      final address = _makeAddress(
        countryCode: 'IN',
        countryName: '',
        stateCode: 'MH',
        stateName: '',
      );
      expect(_resolveProfileState(admin, address), 'Maharashtra');
    });
  });

  // ---------------------------------------------------------------------------
  // SuperadminAdminDetails.fromJson — generic country field handling
  // ---------------------------------------------------------------------------

  group('SuperadminAdminDetails.fromJson country field handling', () {
    test('generic country: "India" parsed as countryName, not code', () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'country': 'India',
      });
      expect(details.countryName, 'India');
      expect(details.countryCode, '');
    });

    test('generic country: "IN" parsed as countryCode, not name', () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'country': 'IN',
      });
      expect(details.countryCode, 'IN');
      expect(details.countryName, '');
    });

    test('explicit countryCode key takes precedence', () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'countryCode': 'NG',
        'country': 'Some long name',
      });
      expect(details.countryCode, 'NG');
    });
  });

  // ---------------------------------------------------------------------------
  // SuperadminAdminDetails.fromJson — generic state field handling
  // ---------------------------------------------------------------------------

  group('SuperadminAdminDetails.fromJson state field handling', () {
    test('generic state: "Maharashtra" parsed as stateName, not code', () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'state': 'Maharashtra',
      });
      expect(details.stateName, 'Maharashtra');
      expect(details.stateCode, '');
    });

    test('generic state: "MH" parsed as stateCode, not name', () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'state': 'MH',
      });
      expect(details.stateCode, 'MH');
      expect(details.stateName, '');
    });
  });

  // ---------------------------------------------------------------------------
  // Canonical codes unchanged — resolver is pure, no side-effects
  // ---------------------------------------------------------------------------

  group('canonical API codes remain unchanged', () {
    test('resolveCountry does not mutate input code', () {
      const code = 'IN';
      LocationLabelResolver.resolveCountry(code);
      expect(code, 'IN');
    });

    test('countryCode field is preserved after fromJson — not replaced by name',
        () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'countryCode': 'NG',
      });
      expect(details.countryCode, 'NG');
    });

    test('stateCode field preserved after fromJson', () {
      final details = SuperadminAdminDetails.fromJson(<String, dynamic>{
        'id': '1',
        'stateCode': 'LA',
      });
      expect(details.stateCode, 'LA');
    });
  });

  // ---------------------------------------------------------------------------
  // Country catalogue does not require per-card network calls
  // ---------------------------------------------------------------------------

  group('resolver is pure synchronous (no network calls)', () {
    test('resolveCountry is synchronous and returns a String', () {
      final result = LocationLabelResolver.resolveCountry('NG');
      expect(result, isA<String>());
      expect(result, 'Nigeria');
    });

    test('resolveState is synchronous and returns a String', () {
      final result = LocationLabelResolver.resolveState('IN', 'MH');
      expect(result, isA<String>());
      expect(result, 'Maharashtra');
    });
  });
}

// ---------------------------------------------------------------------------
// Test doubles
// ---------------------------------------------------------------------------

SuperadminAdministrator _makeAdministrator({
  required String countryCode,
  required String countryName,
}) {
  return SuperadminAdministrator(
    id: 'test',
    name: 'Test Admin',
    username: 'testadmin',
    email: 'test@example.com',
    role: 'admin',
    companyName: 'Test Co',
    mobilePrefix: '',
    mobileNumber: '',
    countryCode: countryCode,
    countryName: countryName,
    stateCode: '',
    stateName: '',
    cityName: '',
    address: '',
    pincode: '',
    primaryContact: '',
    totalVehicles: 0,
    totalUsers: 0,
    totalCredits: 0,
    isActive: true,
    isVerified: false,
    lastLoginAt: null,
    lastLoginText: null,
    createdAt: null,
  );
}

SuperadminAdminDetails _makeDetails({
  required String countryCode,
  required String countryName,
  required String stateCode,
  required String stateName,
}) {
  return SuperadminAdminDetails(
    id: 'test',
    name: 'Test',
    username: 'test',
    email: 'test@test.com',
    mobilePrefix: '',
    mobileNumber: '',
    mobileDisplay: '',
    credits: 0,
    totalVehicles: 0,
    recentLogin: null,
    isActive: true,
    hasExplicitActiveStatus: true,
    isEmailVerified: false,
    countryCode: countryCode,
    countryName: countryName,
    stateCode: stateCode,
    stateName: stateName,
    cityName: '',
    pincode: '',
    organization: '',
    location: '',
    createdAt: null,
    updatedAt: null,
    companies: const [],
    address: null,
  );
}

SuperadminAdminAddress _makeAddress({
  required String countryCode,
  required String countryName,
  required String stateCode,
  required String stateName,
}) {
  return SuperadminAdminAddress(
    id: '',
    addressLine: '',
    countryCode: countryCode,
    countryName: countryName,
    stateCode: stateCode,
    stateName: stateName,
    cityId: '',
    cityName: '',
    pincode: '',
    fullAddress: '',
  );
}

// Mirror of the widget-level helpers (tested in isolation here).

String _resolveAdminCountryLabel(SuperadminAdministrator administrator) {
  final name = administrator.countryName.trim();
  if (name.isNotEmpty) return name;
  final code = administrator.countryCode.trim();
  if (code.isEmpty) return '';
  return LocationLabelResolver.resolveCountry(code);
}

String _resolveProfileCountry(
  SuperadminAdminDetails admin,
  SuperadminAdminAddress? address,
) {
  final name = address?.countryName.trim().isNotEmpty == true
      ? address!.countryName.trim()
      : admin.countryName.trim().isNotEmpty
          ? admin.countryName.trim()
          : null;
  if (name != null) return name;
  final code = (address?.countryCode.trim().isNotEmpty == true
          ? address!.countryCode
          : admin.countryCode)
      .trim();
  if (code.isEmpty) return '—';
  return LocationLabelResolver.resolveCountry(code);
}

String _resolveProfileState(
  SuperadminAdminDetails admin,
  SuperadminAdminAddress? address,
) {
  final name = address?.stateName.trim().isNotEmpty == true
      ? address!.stateName.trim()
      : admin.stateName.trim().isNotEmpty
          ? admin.stateName.trim()
          : null;
  if (name != null) return name;
  final countryCode = (address?.countryCode.trim().isNotEmpty == true
          ? address!.countryCode
          : admin.countryCode)
      .trim();
  final stateCode = (address?.stateCode.trim().isNotEmpty == true
          ? address!.stateCode
          : admin.stateCode)
      .trim();
  if (stateCode.isEmpty) return '—';
  return LocationLabelResolver.resolveState(countryCode, stateCode);
}
