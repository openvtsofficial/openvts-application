import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/models/superadmin_admin_details_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_administrator_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_settings_model.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';

void main() {
  test('administrator create preserves Unicode and exact password', () {
    final body = const SuperadminCreateAdministratorRequest(
      name: '管理者',
      username: 'admin1',
      password: ' secret ',
      companyName: 'वाहन सेवा',
      address: '北京市东城区',
      country: 'CN',
      state: '',
      city: '',
      email: '',
    ).toJson();
    expect(body['password'], ' secret ');
    expect(body['name'], '管理者');
    expect(body['companyName'], 'वाहन सेवा');
    expect(body['address'], '北京市东城区');
    expect(body.containsKey('email'), isFalse);
    expect(body['state'], '');
    expect(body['city'], '');
  });
  test('password reset does not silently alter credentials', () {
    final body = const SuperadminAdminPasswordUpdateRequest(
      adminId: ' 12 ',
      newPassword: ' secret ',
      confirmPassword: ' secret ',
    ).toJson();
    expect(body['adminid'], '12');
    expect(body['newpassword'], ' secret ');
    expect(body['confirmpassword'], ' secret ');
  });
  test('blank optional email explicitly clears previous email', () {
    final body = const SuperadminUpdateAdminRequest(
      name: 'Admin',
      email: '',
      mobilePrefix: '+91',
      mobileNumber: '9999999999',
      addressLine: 'Main road',
      countryCode: 'IN',
      stateCode: '',
      cityName: '',
      pincode: '',
    ).toJson();
    expect(body.containsKey('email'), isTrue);
    expect(body['email'], '');
    expect(body['stateCode'], '');
    expect(body['cityName'], '');
  });
  test('zero coordinates and cleared localization fields remain distinct', () {
    final zero = SuperadminLocalizationSettings.fromJson({
      'defaultLat': 0,
      'defaultLon': 0,
      'mapZoom': 1,
    }).toJson();
    expect(zero['defaultLat'], 0);
    expect(zero['defaultLon'], 0);
    expect(zero['mapZoom'], 1);
    final cleared = SuperadminLocalizationSettings.fromJson({
      'defaultLat': null,
      'defaultLon': null,
      'mapZoom': null,
    }).toJson();
    expect(cleared['defaultLat'], isNull);
    expect(cleared['defaultLon'], isNull);
    expect(cleared['mapZoom'], isNull);
  });
  test('inactive is never presented as Active', () {
    expect(
      SuperadminVehicleRecord.fromJson({'id': 1, 'isActive': false}).status,
      'Inactive',
    );
  });
  test('disconnected is presented as Offline', () {
    expect(
      SuperadminVehicleRecord.fromJson({'id': 1, 'status': 'disconnected'})
          .status,
      'Offline',
    );
  });
  test('server license block takes precedence over active flag', () {
    final vehicle = SuperadminVehicleRecord.fromJson({
      'id': 1,
      'isActive': true,
      'isLicenseBlocked': true,
      'licenseBlockReason': 'Vehicle capacity exceeded',
    });
    expect(vehicle.status, 'License blocked');
    expect(vehicle.isLicenseBlocked, isTrue);
    expect(vehicle.licenseBlockReason, 'Vehicle capacity exceeded');
  });
  test('ordinary active vehicle remains Active', () {
    expect(
      SuperadminVehicleRecord.fromJson({
        'id': 1,
        'isActive': true,
        'isLicenseBlocked': false,
      }).status,
      'Active',
    );
  });
}
