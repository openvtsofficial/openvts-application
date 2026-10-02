import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/user_notification_settings_model.dart';

class UserNotificationSettingsService {
  UserNotificationSettingsService(this._apiClient);

  final ApiClient _apiClient;

  Future<UserNotificationPreferences> fetchPreferences({
    String? refreshKey,
  }) async {
    if (_apiClient.isDemoMode) {
      return _fetchDemoPreferences();
    }

    final response = await _apiClient.get<UserNotificationPreferences>(
      ApiEndpoints.user.notificationPreferences,
      queryParameters: _query(refreshKey),
      parser: UserNotificationPreferences.fromDynamic,
    );
    return response.data;
  }

  Future<UserNotificationPreferences> _fetchDemoPreferences() async {
    final responses = await Future.wait([
      _apiClient.get<dynamic>(
        '/demo/vehicles',
        parser: (json) => json,
      ),
      _apiClient.get<dynamic>(
        '/demo/geofences',
        parser: (json) => json,
      ),
    ]);

    final vehiclePayload = _asMap(responses[0].data);
    final geofencePayload = _asMap(responses[1].data);
    final vehicles = _asList(vehiclePayload['vehicles']);
    final geofences = _asList(geofencePayload['geofences']);

    return UserNotificationPreferences.fromDynamic(<String, dynamic>{
      'channels': const <String, dynamic>{
        'BASIC': <String, bool>{
          'notifyWebPush': true,
          'notifyMobilePush': true,
          'notifyWhatsapp': false,
          'notifyEmail': true,
        },
        'OVERSPEED': <String, bool>{
          'notifyWebPush': true,
          'notifyMobilePush': true,
          'notifyWhatsapp': true,
          'notifyEmail': true,
        },
        'DURATION': <String, bool>{
          'notifyWebPush': true,
          'notifyMobilePush': true,
          'notifyWhatsapp': false,
          'notifyEmail': true,
        },
        'GEOFENCE': <String, bool>{
          'notifyWebPush': true,
          'notifyMobilePush': false,
          'notifyWhatsapp': true,
          'notifyEmail': true,
        },
        'ROUTE': <String, bool>{
          'notifyWebPush': true,
          'notifyMobilePush': false,
          'notifyWhatsapp': false,
          'notifyEmail': true,
        },
      },
      'vehicles': [
        for (var index = 0; index < vehicles.length; index++)
          <String, dynamic>{
            'id': index + 1,
            'name': _asMap(vehicles[index])['name'],
            'plateNumber': _asMap(vehicles[index])['plateNumber'],
          },
      ],
      'basic': [
        for (var index = 0; index < vehicles.length; index++)
          <String, dynamic>{
            'vehicleId': index + 1,
            'ignitionEnabled': true,
            'alarmEnabled': index % 3 != 1,
          },
      ],
      'overspeed': [
        for (var index = 0; index < vehicles.length; index++)
          <String, dynamic>{
            'vehicleId': index + 1,
            'enabled': index % 4 != 2,
            'speedLimitKph': 70 + (index % 4) * 10,
          },
      ],
      'duration': [
        for (var index = 0; index < vehicles.length; index++)
          <String, dynamic>{
            'vehicleId': index + 1,
            'runningEnabled': index.isEven,
            'runningLimitMinutes': index.isEven ? 120 : null,
            'stopEnabled': false,
            'stopLimitMinutes': null,
            'idleEnabled': false,
            'idleLimitMinutes': null,
          },
      ],
      'geofences': [
        for (var index = 0; index < geofences.length; index++)
          <String, dynamic>{
            'id': index + 1,
            'name': _asMap(geofences[index])['name'],
            'type': _asMap(geofences[index])['type'],
            'isActive': _asMap(geofences[index])['isActive'] != false,
          },
      ],
      'geofenceMatrix': [
        for (var vehicleIndex = 0;
            vehicleIndex < vehicles.length;
            vehicleIndex++)
          for (var geofenceIndex = 0;
              geofenceIndex < geofences.length;
              geofenceIndex++)
            <String, dynamic>{
              'vehicleId': vehicleIndex + 1,
              'geofenceId': geofenceIndex + 1,
              'enabled':
                  _asMap(geofences[geofenceIndex])['isActive'] != false &&
                      (vehicleIndex + geofenceIndex) % 2 == 0,
            },
      ],
      'routes': const <Map<String, dynamic>>[],
      'routeMatrix': const <Map<String, dynamic>>[],
    });
  }

  Future<UserNotificationPreferences> savePreferences(
    UserNotificationPreferences preferences,
  ) async {
    await _apiClient.put<dynamic>(
      ApiEndpoints.user.notificationPreferences,
      data: preferences.toSavePayload(),
      parser: (json) => json,
    );

    return fetchPreferences(
      refreshKey: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  Map<String, dynamic>? _query(String? refreshKey) {
    final normalizedKey = refreshKey?.trim();
    if (normalizedKey == null || normalizedKey.isEmpty) {
      return null;
    }

    return <String, dynamic>{'rk': normalizedKey};
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), item),
      );
    }
    return const <String, dynamic>{};
  }

  List<dynamic> _asList(dynamic value) {
    return value is List ? value : const <dynamic>[];
  }
}
