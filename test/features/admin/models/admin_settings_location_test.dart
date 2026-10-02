import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_settings_model.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';

void main() {
  group('admin profile location values', () {
    test('keeps saved city id separate from an explicit readable name', () {
      final address = AdminAddressSettings.fromJson(<String, dynamic>{
        'countryCode': 'IN',
        'countryName': 'India',
        'stateCode': 'MH',
        'stateName': 'Maharashtra',
        'cityId': 'city-42',
        'cityName': 'Mumbai',
      });

      expect(address.countryCode, 'IN');
      expect(address.countryName, 'India');
      expect(address.stateCode, 'MH');
      expect(address.stateName, 'Maharashtra');
      expect(address.cityValue, 'city-42');
      expect(address.cityDisplayName, 'Mumbai');
    });

    test('normalizes numeric city ids to canonical string values', () {
      final address = AdminAddressSettings.fromJson(<String, dynamic>{
        'cityId': 123,
      });

      expect(address.cityValue, '123');
      expect(address.cityDisplayName, '123');
    });

    test('profile update payload sends canonical location values', () {
      const request = AdminUpdateProfileRequest(
        countryCode: 'IN',
        stateCode: 'MH',
        cityName: 'city-42',
      );

      expect(request.toJson(), <String, dynamic>{
        'countryCode': 'IN',
        'stateCode': 'MH',
        'cityName': 'city-42',
      });
    });

    test('city options preserve an API identifier as their value', () {
      final options = AdminUserCityOption.listFromJson(<String, dynamic>{
        'cities': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'city-42', 'name': 'Mumbai'},
        ],
      });

      expect(options.single.value, 'city-42');
      expect(options.single.label, 'Mumbai');
    });
  });
}
