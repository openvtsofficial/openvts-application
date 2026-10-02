import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/user/controllers/user_notification_settings_controller.dart';
import 'package:open_vts/features/user/models/user_notification_settings_model.dart';
import 'package:open_vts/features/user/services/user_notification_settings_service.dart';

void main() {
  test('parses five channels, duration rows, routes, and route matrix', () {
    final preferences = UserNotificationPreferences.fromDynamic(_payload());

    expect(
        preferences.channels
            .flagsFor(UserNotificationGroup.basic)
            .notifyWebPush,
        isTrue);
    expect(
        preferences.channels
            .flagsFor(UserNotificationGroup.overspeed)
            .notifyMobilePush,
        isTrue);
    expect(
        preferences.channels
            .flagsFor(UserNotificationGroup.duration)
            .notifyEmail,
        isTrue);
    expect(
        preferences.channels
            .flagsFor(UserNotificationGroup.geofence)
            .notifyWhatsapp,
        isTrue);
    expect(
        preferences.channels
            .flagsFor(UserNotificationGroup.route)
            .notifyMobilePush,
        isTrue);
    expect(preferences.duration.single.runningLimitMinutes, 60);
    expect(preferences.routes.single.toleranceMeters, 75.5);
    expect(preferences.routeMatrix.single.enabled, isTrue);
  });

  test('save payload uses exact duration and routes backend keys', () {
    final payload =
        UserNotificationPreferences.fromDynamic(_payload()).toSavePayload();

    expect(
        payload.keys,
        containsAll([
          'channels',
          'basic',
          'overspeed',
          'duration',
          'geofences',
          'routes'
        ]));
    expect(payload['duration'], [
      {
        'vehicleId': 1,
        'runningEnabled': true,
        'runningLimitMinutes': 60,
        'stopEnabled': false,
        'stopLimitMinutes': null,
        'idleEnabled': true,
        'idleLimitMinutes': 15,
      }
    ]);
    expect(payload['routes'], [
      {'vehicleId': 1, 'routeId': 9, 'enabled': true}
    ]);
    expect((payload['channels'] as Map<String, dynamic>).keys,
        containsAll(['BASIC', 'OVERSPEED', 'DURATION', 'GEOFENCE', 'ROUTE']));
  });

  test('duration validation blocks invalid values and permits valid save',
      () async {
    final service = _FakeSettingsService();
    final controller = UserNotificationSettingsController(service: service);
    addTearDown(controller.dispose);
    await controller.load();

    controller.updateDurationEnabled(
        1, UserDurationNotificationKind.stop, true);
    await controller.save();
    expect(controller.state.errorMessage, contains('at least 1 minute'));
    expect(service.saveCalls, 0);

    controller.updateDurationLimit(1, UserDurationNotificationKind.stop, 10081);
    await controller.save();
    expect(controller.state.errorMessage, contains('10080'));
    expect(service.saveCalls, 0);

    controller.updateDurationLimit(1, UserDurationNotificationKind.stop, 30);
    controller.updateRouteToggle(1, 9, false);
    await controller.save();
    expect(service.saveCalls, 1);
    expect(service.lastPayload!['duration'], isNotEmpty);
    expect(service.lastPayload!['routes'], [
      {'vehicleId': 1, 'routeId': 9, 'enabled': false}
    ]);
    expect(controller.state.isDirty, isFalse);
  });

  test('GET edit PUT GET round trip preserves existing groups', () async {
    final service = _FakeSettingsService();
    final controller = UserNotificationSettingsController(service: service);
    addTearDown(controller.dispose);
    await controller.load();

    controller.updateChannel(
        UserNotificationGroup.route, UserNotificationChannel.email, true);
    controller.updateDurationLimit(1, UserDurationNotificationKind.running, 90);
    await controller.save();
    await controller.refresh(discardUnsavedChanges: true);

    final current = controller.state.draftPreferences!;
    expect(current.duration.single.runningLimitMinutes, 90);
    expect(current.channels.route.notifyEmail, isTrue);
    expect(current.basic.single.ignitionEnabled, isTrue);
    expect(current.overspeed.single.speedLimitKph, 80);
    expect(current.geofenceMatrix.single.enabled, isTrue);
  });
}

Map<String, dynamic> _payload() => <String, dynamic>{
      'channels': {
        'BASIC': {'notifyWebPush': true},
        'OVERSPEED': {'notifyMobilePush': true},
        'DURATION': {'notifyEmail': true},
        'GEOFENCE': {'notifyWhatsapp': true},
        'ROUTE': {'notifyMobilePush': true},
      },
      'vehicles': [
        {'id': 1, 'name': 'Truck', 'plateNumber': 'AB-1'}
      ],
      'basic': [
        {'vehicleId': 1, 'ignitionEnabled': true, 'alarmEnabled': false}
      ],
      'overspeed': [
        {'vehicleId': 1, 'enabled': true, 'speedLimitKph': 80}
      ],
      'duration': [
        {
          'vehicleId': 1,
          'runningEnabled': true,
          'runningLimitMinutes': 60,
          'stopEnabled': false,
          'stopLimitMinutes': null,
          'idleEnabled': true,
          'idleLimitMinutes': 15,
        }
      ],
      'geofences': [
        {'id': 4, 'name': 'Depot', 'type': 'CIRCLE', 'isActive': true}
      ],
      'geofenceMatrix': [
        {'vehicleId': 1, 'geofenceId': 4, 'enabled': true}
      ],
      'routes': [
        {
          'id': 9,
          'name': 'North Route',
          'isActive': true,
          'toleranceMeters': 75.5,
        }
      ],
      'routeMatrix': [
        {'vehicleId': 1, 'routeId': 9, 'enabled': true}
      ],
    };

class _FakeSettingsService extends UserNotificationSettingsService {
  _FakeSettingsService() : super(ApiClient(Dio()));

  UserNotificationPreferences stored =
      UserNotificationPreferences.fromDynamic(_payload());
  int saveCalls = 0;
  Map<String, dynamic>? lastPayload;

  @override
  Future<UserNotificationPreferences> fetchPreferences(
          {String? refreshKey}) async =>
      stored;

  @override
  Future<UserNotificationPreferences> savePreferences(
      UserNotificationPreferences preferences) async {
    saveCalls++;
    lastPayload = preferences.toSavePayload();
    stored = preferences;
    return stored;
  }
}
