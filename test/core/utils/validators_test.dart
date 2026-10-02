import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('adminName', () {
      test('returns error for empty name', () {
        final result = Validators.adminName('');
        expect(result, contains('required'));
      });

      test('returns error for name less than 2 characters', () {
        final result = Validators.adminName('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid name with 2 characters', () {
        final result = Validators.adminName('Ab');
        expect(result, isNull);
      });

      test('returns error for name more than 120 characters', () {
        final longName = 'A' * 121;
        final result = Validators.adminName(longName);
        expect(result, contains('120 characters or fewer'));
      });

      test('returns null for valid name with 120 characters', () {
        final validName = 'A' * 120;
        final result = Validators.adminName(validName);
        expect(result, isNull);
      });
    });

    group('adminUsername', () {
      test('returns error for empty username', () {
        final result = Validators.adminUsername('');
        expect(result, contains('required'));
      });

      test('returns error for username less than 2 characters', () {
        final result = Validators.adminUsername('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid username with 2 characters', () {
        final result = Validators.adminUsername('Ab');
        expect(result, isNull);
      });

      test('returns error for username more than 50 characters', () {
        final longUsername = 'A' * 51;
        final result = Validators.adminUsername(longUsername);
        expect(result, contains('50 characters or fewer'));
      });

      test('returns null for valid username with 50 characters', () {
        final validUsername = 'A' * 50;
        final result = Validators.adminUsername(validUsername);
        expect(result, isNull);
      });
    });

    group('mobileNumber', () {
      test('returns error for empty mobile number', () {
        final result = Validators.mobileNumber('');
        expect(result, contains('required'));
      });

      test('returns error for mobile number less than 7 digits', () {
        final result = Validators.mobileNumber('123456');
        expect(result, contains('at least'));
      });

      test('returns null for valid mobile number with 7 digits', () {
        final result = Validators.mobileNumber('1234567');
        expect(result, isNull);
      });

      test('returns error for mobile number more than 20 digits', () {
        final longNumber = '1' * 21;
        final result = Validators.mobileNumber(longNumber);
        expect(result, contains('20 digits or fewer'));
      });

      test('returns null for valid mobile number with 20 digits', () {
        final validNumber = '1' * 20;
        final result = Validators.mobileNumber(validNumber);
        expect(result, isNull);
      });

      test('returns error for non-numeric mobile number', () {
        final result = Validators.mobileNumber('123456a');
        expect(result, contains('numeric'));
      });
    });

    group('companyName', () {
      test('returns error for empty company name', () {
        final result = Validators.companyName('');
        expect(result, contains('required'));
      });

      test('returns error for company name less than 2 characters', () {
        final result = Validators.companyName('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid company name with 2 characters', () {
        final result = Validators.companyName('Ab');
        expect(result, isNull);
      });

      test('returns error for company name more than 200 characters', () {
        final longName = 'A' * 201;
        final result = Validators.companyName(longName);
        expect(result, contains('200 characters or fewer'));
      });

      test('returns null for valid company name with 200 characters', () {
        final validName = 'A' * 200;
        final result = Validators.companyName(validName);
        expect(result, isNull);
      });
    });

    group('address', () {
      test('returns error for empty address', () {
        final result = Validators.address('');
        expect(result, contains('required'));
      });

      test('returns error for address less than 3 characters', () {
        final result = Validators.address('Ab');
        expect(result, contains('at least'));
      });

      test('returns null for valid address with 3 characters', () {
        final result = Validators.address('Abc');
        expect(result, isNull);
      });

      test('returns error for address more than 200 characters', () {
        final longAddress = 'A' * 201;
        final result = Validators.address(longAddress);
        expect(result, contains('200 characters or fewer'));
      });

      test('returns null for valid address with 200 characters', () {
        final validAddress = 'A' * 200;
        final result = Validators.address(validAddress);
        expect(result, isNull);
      });
    });

    group('pincodeOptional', () {
      test('returns null for empty pincode', () {
        final result = Validators.pincodeOptional('');
        expect(result, isNull);
      });

      test('returns error for pincode less than 4 digits', () {
        final result = Validators.pincodeOptional('123');
        expect(result, contains('at least'));
      });

      test('returns null for valid pincode with 4 digits', () {
        final result = Validators.pincodeOptional('1234');
        expect(result, isNull);
      });

      test('returns error for pincode more than 12 digits', () {
        final longPincode = '1' * 13;
        final result = Validators.pincodeOptional(longPincode);
        expect(result, contains('12 characters or fewer'));
      });

      test('returns null for valid pincode with 12 digits', () {
        final validPincode = '1' * 12;
        final result = Validators.pincodeOptional(validPincode);
        expect(result, isNull);
      });

      test('returns error for non-numeric pincode', () {
        final result = Validators.pincodeOptional('12345a');
        expect(result, contains('numeric'));
      });
    });

    group('vehicleName', () {
      test('returns error for empty name', () {
        final result = Validators.vehicleName('');
        expect(result, contains('required'));
      });

      test('returns error for name less than 2 characters', () {
        final result = Validators.vehicleName('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid name with 2 characters', () {
        final result = Validators.vehicleName('RV');
        expect(result, isNull);
      });

      test('returns error for name more than 120 characters', () {
        final longName = 'A' * 121;
        final result = Validators.vehicleName(longName);
        expect(result, contains('120 characters or fewer'));
      });

      test('returns null for valid name with 120 characters', () {
        final validName = 'A' * 120;
        final result = Validators.vehicleName(validName);
        expect(result, isNull);
      });
    });

    group('plateNumber', () {
      test('returns error for empty plate number', () {
        final result = Validators.plateNumber('');
        expect(result, contains('required'));
      });

      test('returns error for plate number less than 2 characters', () {
        final result = Validators.plateNumber('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid plate number with 2 characters', () {
        final result = Validators.plateNumber('AB');
        expect(result, isNull);
      });

      test('returns error for plate number more than 32 characters', () {
        final longPlate = 'A' * 33;
        final result = Validators.plateNumber(longPlate);
        expect(result, contains('32 characters or fewer'));
      });

      test('returns null for valid plate number with 32 characters', () {
        final validPlate = 'A' * 32;
        final result = Validators.plateNumber(validPlate);
        expect(result, isNull);
      });
    });

    group('plateNumberOptional', () {
      test('returns null for empty plate number', () {
        final result = Validators.plateNumberOptional('');
        expect(result, isNull);
      });

      test('returns error for plate number less than 2 characters', () {
        final result = Validators.plateNumberOptional('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid plate number with 2 characters', () {
        final result = Validators.plateNumberOptional('AB');
        expect(result, isNull);
      });

      test('returns error for plate number more than 32 characters', () {
        final longPlate = 'A' * 33;
        final result = Validators.plateNumberOptional(longPlate);
        expect(result, contains('32 characters or fewer'));
      });

      test('returns null for valid plate number with 32 characters', () {
        final validPlate = 'A' * 32;
        final result = Validators.plateNumberOptional(validPlate);
        expect(result, isNull);
      });
    });

    group('vin', () {
      test('returns error for empty VIN', () {
        final result = Validators.vin('');
        expect(result, contains('required'));
      });

      test('returns error for VIN less than 2 characters', () {
        final result = Validators.vin('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid VIN with 2 characters', () {
        final result = Validators.vin('AB');
        expect(result, isNull);
      });

      test('returns error for VIN more than 64 characters', () {
        final longVin = 'A' * 65;
        final result = Validators.vin(longVin);
        expect(result, contains('64 characters or fewer'));
      });

      test('returns null for valid VIN with 64 characters', () {
        final validVin = 'A' * 64;
        final result = Validators.vin(validVin);
        expect(result, isNull);
      });

      test('returns error for standard VIN (17 chars) with invalid format', () {
        final result = Validators.vin('IIIIIIIIIIIIIIIII');
        expect(result, contains('17 alphanumeric'));
      });

      test('returns null for valid standard VIN (17 chars)', () {
        final result = Validators.vin('1HGBH41JXMN109186');
        expect(result, isNull);
      });

      test('returns error for non-alphanumeric VIN', () {
        final result = Validators.vin('ABC-123');
        expect(result, contains('letters and numbers'));
      });
    });

    group('vinOptional', () {
      test('returns null for empty VIN', () {
        final result = Validators.vinOptional('');
        expect(result, isNull);
      });

      test('returns error for VIN less than 2 characters', () {
        final result = Validators.vinOptional('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid VIN with 2 characters', () {
        final result = Validators.vinOptional('AB');
        expect(result, isNull);
      });

      test('returns error for VIN more than 64 characters', () {
        final longVin = 'A' * 65;
        final result = Validators.vinOptional(longVin);
        expect(result, contains('64 characters or fewer'));
      });

      test('returns null for valid VIN with 64 characters', () {
        final validVin = 'A' * 64;
        final result = Validators.vinOptional(validVin);
        expect(result, isNull);
      });

      test('returns error for standard VIN (17 chars) with invalid format', () {
        final result = Validators.vinOptional('IIIIIIIIIIIIIIIII');
        expect(result, contains('17 alphanumeric'));
      });

      test('returns null for valid standard VIN (17 chars)', () {
        final result = Validators.vinOptional('1HGBH41JXMN109186');
        expect(result, isNull);
      });

      test('returns error for non-alphanumeric VIN', () {
        final result = Validators.vinOptional('ABC-123');
        expect(result, contains('letters and numbers'));
      });
    });

    group('driverName', () {
      test('returns error for empty name', () {
        final result = Validators.driverName('');
        expect(result, contains('required'));
      });

      test('returns error for name with 1 character', () {
        final result = Validators.driverName('A');
        expect(result, contains('at least'));
      });

      test('returns null for valid name with 2 characters', () {
        final result = Validators.driverName('Ab');
        expect(result, isNull);
      });

      test('returns error for name more than 120 characters', () {
        final longName = 'A' * 121;
        final result = Validators.driverName(longName);
        expect(result, contains('120 characters or fewer'));
      });

      test('returns null for valid name with 120 characters', () {
        final validName = 'A' * 120;
        final result = Validators.driverName(validName);
        expect(result, isNull);
      });
    });

    group('driverUsername', () {
      test('returns error for empty username', () {
        final result = Validators.driverUsername('');
        expect(result, contains('required'));
      });

      test('returns error for username with 1 character', () {
        final result = Validators.driverUsername('A');
        expect(result, contains('at least'));
      });

      test('returns error for username with 2 characters', () {
        final result = Validators.driverUsername('Ab');
        expect(result, contains('at least'));
      });

      test('returns null for valid username with 3 characters', () {
        final result = Validators.driverUsername('Abc');
        expect(result, isNull);
      });

      test('returns error for username more than 50 characters', () {
        final longUsername = 'A' * 51;
        final result = Validators.driverUsername(longUsername);
        expect(result, contains('50 characters or fewer'));
      });

      test('returns null for valid username with 50 characters', () {
        final validUsername = 'A' * 50;
        final result = Validators.driverUsername(validUsername);
        expect(result, isNull);
      });
    });

    group('driverAddressOptional', () {
      test('returns null for empty address', () {
        final result = Validators.driverAddressOptional('');
        expect(result, isNull);
      });

      test('returns error for address with 1 character', () {
        final result = Validators.driverAddressOptional('A');
        expect(result, contains('at least'));
      });

      test('returns error for address with 2 characters', () {
        final result = Validators.driverAddressOptional('Ab');
        expect(result, contains('at least'));
      });

      test('returns null for valid address with 3 characters', () {
        final result = Validators.driverAddressOptional('Abc');
        expect(result, isNull);
      });

      test('returns error for address more than 200 characters', () {
        final longAddress = 'A' * 201;
        final result = Validators.driverAddressOptional(longAddress);
        expect(result, contains('200 characters or fewer'));
      });

      test('returns null for valid address with 200 characters', () {
        final validAddress = 'A' * 200;
        final result = Validators.driverAddressOptional(validAddress);
        expect(result, isNull);
      });
    });

    group('driverPincodeOptional', () {
      test('returns null for empty pincode', () {
        final result = Validators.driverPincodeOptional('');
        expect(result, isNull);
      });

      test('returns error for pincode with 1 digit', () {
        final result = Validators.driverPincodeOptional('1');
        expect(result, contains('at least'));
      });

      test('returns error for pincode with 3 digits', () {
        final result = Validators.driverPincodeOptional('123');
        expect(result, contains('at least'));
      });

      test('returns null for valid pincode with 4 digits', () {
        final result = Validators.driverPincodeOptional('1234');
        expect(result, isNull);
      });

      test('returns error for pincode more than 12 digits', () {
        final longPincode = '1' * 13;
        final result = Validators.driverPincodeOptional(longPincode);
        expect(result, contains('12 characters or fewer'));
      });

      test('returns null for valid pincode with 12 digits', () {
        final validPincode = '1' * 12;
        final result = Validators.driverPincodeOptional(validPincode);
        expect(result, isNull);
      });

      test('returns error for non-numeric pincode', () {
        final result = Validators.driverPincodeOptional('1234a');
        expect(result, contains('numeric'));
      });
    });
  });
}
