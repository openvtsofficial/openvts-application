import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/demo/demo_api_policy.dart';
import 'package:open_vts/features/user/services/user_notification_settings_service.dart';

void main() {
  test('demo preferences keep vehicle and geofence matrix IDs consistent',
      () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final dynamic payload;
          switch (options.path) {
            case '/demo/vehicles':
              payload = const <String, dynamic>{
                'vehicles': <Map<String, dynamic>>[
                  <String, dynamic>{
                    'id': 'vehicle-alpha',
                    'name': 'Alpha',
                    'plateNumber': 'DEMO-1',
                  },
                  <String, dynamic>{
                    'id': 'vehicle-beta',
                    'name': 'Beta',
                    'plateNumber': 'DEMO-2',
                  },
                ],
              };
            case '/demo/geofences':
              payload = const <String, dynamic>{
                'geofences': <Map<String, dynamic>>[
                  <String, dynamic>{
                    'id': 'geofence-alpha',
                    'name': 'Depot',
                    'type': 'circle',
                    'isActive': true,
                  },
                ],
              };
            default:
              return handler.reject(
                DioException(
                  requestOptions: options,
                  message: 'Unexpected test request: ${options.path}',
                ),
              );
          }

          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{
                'success': true,
                'data': payload,
              },
            ),
          );
        },
      ),
    );

    final client = ApiClient(
      dio,
      demoPolicy: DemoApiPolicy(isDemoMode: () => true),
    );
    final preferences =
        await UserNotificationSettingsService(client).fetchPreferences();

    expect(
      preferences.vehicles.map((vehicle) => vehicle.id),
      orderedEquals(<int>[1, 2]),
    );
    expect(
      preferences.basic.map((row) => row.vehicleId),
      orderedEquals(<int>[1, 2]),
    );
    expect(
      preferences.overspeed.map((row) => row.vehicleId),
      orderedEquals(<int>[1, 2]),
    );
    expect(
      preferences.geofences.map((geofence) => geofence.id),
      orderedEquals(<int>[1]),
    );
    expect(preferences.geofenceMatrix, hasLength(2));
    expect(
      preferences.geofenceMatrix.every(
        (entry) =>
            <int>{1, 2}.contains(entry.vehicleId) && entry.geofenceId == 1,
      ),
      isTrue,
    );
  });
}
