import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/live_map/models/live_map_role_config.dart';

void main() {
  group('LiveMapRoleConfig vehicle detail endpoints', () {
    test('use the backend details route for every role', () {
      expect(
        LiveMapRoleConfig.superadmin().vehicleDetailsByImei('867440060976859'),
        '/superadmin/vehicles/by-imei/867440060976859/details',
      );
      expect(
        LiveMapRoleConfig.admin().vehicleDetailsByImei('867440060976859'),
        '/admin/vehicles/by-imei/867440060976859/details',
      );
      expect(
        LiveMapRoleConfig.user().vehicleDetailsByImei('867440060976859'),
        '/user/vehicles/by-imei/867440060976859/details',
      );
      expect(
        LiveMapRoleConfig.demo().vehicleDetailsByImei('867440060976859'),
        '/demo/vehicles/by-imei/867440060976859/details',
      );
    });

    test('encodes raw IMEI values before appending details', () {
      expect(
        LiveMapRoleConfig.superadmin().vehicleDetailsByImei('imei/with space'),
        '/superadmin/vehicles/by-imei/imei%2Fwith%20space/details',
      );
    });
  });

  group('LiveMapRoleConfig telemetry subscriptions', () {
    test('superadmin uses the scoped batch stream', () {
      expect(
        LiveMapRoleConfig.superadmin().telemetrySubscribeMode,
        LiveMapTelemetrySubscribeMode.superadminScope,
      );
    });

    test('admin and user use explicit IMEI subscriptions', () {
      expect(
        LiveMapRoleConfig.admin().telemetrySubscribeMode,
        LiveMapTelemetrySubscribeMode.imeis,
      );
      expect(
        LiveMapRoleConfig.user().telemetrySubscribeMode,
        LiveMapTelemetrySubscribeMode.imeis,
      );
    });

    test('demo uses the isolated public scope without notification socket', () {
      final config = LiveMapRoleConfig.demo();
      expect(
        config.telemetrySubscribeMode,
        LiveMapTelemetrySubscribeMode.demoScope,
      );
      expect(config.telemetryNamespace, '/demo-telemetry');
      expect(config.notificationNamespace, isNull);
      expect(config.socketAuthenticationRequired, isFalse);
      expect(
        config.notificationSubscribeMode,
        LiveMapNotificationSubscribeMode.disabled,
      );
      expect(config.mapTelemetryEndpoint, '/demo/map-telemetry');
    });
  });
}
