import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/validators.dart';

void main() {
  test('credentials stay ASCII; names support Unicode', () {
    expect(Validators.adminPassword('secret12'), isNull);
    expect(Validators.adminPassword('पासवर्ड12'), isNotNull);
    expect(Validators.adminPassword('abc\n123'), isNotNull);
    expect(Validators.adminUsername('用户'), isNotNull);
    expect(Validators.email('用户@example.com'), isNotNull);
    expect(Validators.adminEmailOptional(''), isNull);
    expect(Validators.driverName('अमित कुमार'), isNull);
    expect(Validators.adminName('محمد أحمد'), isNull);
  });
  test('password length uses exact input and current minimum', () {
    expect(Validators.adminPassword('123456'), isNull);
    expect(Validators.adminPassword(' abcd '), isNull);
    expect(Validators.adminPassword('12345'), isNotNull);
  });
}
