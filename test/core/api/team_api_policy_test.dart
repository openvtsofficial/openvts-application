import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/core/api/team_api_policy.dart';

void main() {
  test('maps shared reads to the explicit Team contract', () {
    expect(TeamApiPolicy.resolve('GET', '/admin/map-telemetry'),
        '/team/map-telemetry');
    expect(TeamApiPolicy.resolve('GET', '/admin/vehicles/by-imei/123/details'),
        '/team/map/vehicles/by-imei/123/details');
    expect(TeamApiPolicy.resolve('GET', '/admin/documents/driver/17'),
        '/team/drivers/17/documents');
    expect(TeamApiPolicy.resolve('GET', '/admin/devices'),
        '/team/inventory/devices');
    expect(TeamApiPolicy.resolve('GET', '/admin/transactions/analytics'),
        '/team/payments/analytics');
  });
  test('unsupported Team mutations cannot fall back to Admin', () {
    for (final path in [
      '/admin/teams',
      '/admin/transactions',
      '/admin/smtpconfig',
      '/admin/uploaddoc'
    ]) {
      expect(() => TeamApiPolicy.resolve('POST', path),
          throwsA(isA<ApiException>()));
    }
    expect(() => TeamApiPolicy.resolve('POST', '/admin/pricingplans'),
        throwsA(isA<ApiException>()));
    expect(() => TeamApiPolicy.resolve('DELETE', '/admin/payments'),
        throwsA(isA<ApiException>()));
  });
  test('method and entire path must match a backend route', () {
    expect(TeamApiPolicy.isSupported('POST', '/team/users/3/password'), isTrue);
    expect(
        TeamApiPolicy.isSupported('PATCH', '/team/users/3/password'), isFalse);
    expect(TeamApiPolicy.isSupported('GET', '/team/users/3/extra'), isFalse);
    expect(
        TeamApiPolicy.resolve('GET', '/user/permissions'), '/user/permissions');
  });
}
