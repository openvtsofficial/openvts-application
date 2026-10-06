import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_endpoints.dart';
import 'package:open_vts/core/api/api_response.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';
import 'package:open_vts/features/user/services/user_landmark_service.dart';

void main() {
  test(
    'POI create sends selected icon, Unicode labels and exact coordinates once',
    () async {
      final client = _Client();
      final poi = await UserLandmarkService(client).createPoi(
        const CreateUserPoiRequest(
          name: '仓库 نقطة الوصول',
          category: 'warehouse',
          iconSlug: 'warehouse',
          coordinates: UserGeoPoint(lat: 40.712345, lon: -74.023456),
        ),
      );
      expect(poi.id, '7');
      expect(client.requests, hasLength(1));
      final request = client.requests.single;
      expect(request.$1, 'POST');
      expect(request.$2, ApiEndpoints.user.pois);
      expect(request.$3['name'], '仓库 نقطة الوصول');
      expect(request.$3['iconSlug'], 'warehouse');
      expect(request.$3['coordinates'], {'lat': 40.712345, 'lon': -74.023456});
    },
  );

  test(
    'partial POI icon update never invents replacement coordinates',
    () async {
      final client = _Client();
      await UserLandmarkService(
        client,
      ).updatePoi('7', const UpdateUserPoiRequest(iconSlug: 'fuel'));
      expect(client.requests, hasLength(1));
      expect(client.requests.single.$1, 'PATCH');
      expect(client.requests.single.$2, ApiEndpoints.user.poiById('7'));
      expect(client.requests.single.$3, {'iconSlug': 'fuel'});
    },
  );

  test(
    'rejected POI update propagates the error without retry or resetting location',
    () async {
      final client = _Client(reject: true);
      await expectLater(
        UserLandmarkService(
          client,
        ).updatePoi('7', const UpdateUserPoiRequest(iconSlug: 'fuel')),
        throwsA(isA<DioException>()),
      );
      expect(client.requests, hasLength(1));
      expect(client.requests.single.$3, {'iconSlug': 'fuel'});
    },
  );

  test(
    'each bulk entity reaches current endpoint with correct typed envelope',
    () async {
      for (final entity in UserLandmarkEntityType.values) {
        final client = _Client();
        final rows = switch (entity) {
          UserLandmarkEntityType.geofence => [
            {
              'rowNumber': 1,
              'name': 'مستودع',
              'type': 'LINE',
              'lineCoordinates': '[[-74.0,40.7],[-74.1,40.8]]',
              'toleranceMeters': 50,
            },
          ],
          UserLandmarkEntityType.poi => [
            {
              'rowNumber': 1,
              'name': 'مستودع',
              'category': 'warehouse',
              'iconSlug': 'warehouse',
              'lat': 40.7,
              'lon': -74.0,
            },
          ],
          UserLandmarkEntityType.route => [
            {
              'rowNumber': 1,
              'name': 'مستودع',
              'coordinates': '[[-74.0,40.7],[-74.1,40.8]]',
            },
          ],
        };
        await UserLandmarkService(client).createBulkJob(
          CreateUserLandmarkBulkJobRequest(entityType: entity, rows: rows),
        );
        expect(client.requests, hasLength(1));
        expect(client.requests.single.$2, ApiEndpoints.user.landmarkBulkJobs);
        expect(client.requests.single.$3, {
          'entityType': entity.name,
          '${entity.name}Rows': rows,
        });
      }
    },
  );

  test(
    'line tolerance override is nested and does not modify stored geometry',
    () {
      const geometry = UserLineGeoData(
        coordinates: [
          UserGeoPoint(lat: 40.7, lon: -74.0),
          UserGeoPoint(lat: 40.8, lon: -74.1),
        ],
        toleranceM: 25,
      );
      final payload = const UpdateUserGeofenceRequest(
        geodata: geometry,
        toleranceMeters: 90,
      ).toJson();
      final data = payload['geodata'] as Map;
      expect(data['toleranceM'], 90);
      expect(data['geometry'], {
        'type': 'LineString',
        'coordinates': [
          [-74.0, 40.7],
          [-74.1, 40.8],
        ],
      });
      expect(geometry.toleranceM, 25);
      expect(payload.containsKey('toleranceMeters'), isFalse);
      expect(const UpdateUserGeofenceRequest(isActive: false).toJson(), {
        'isActive': false,
      });
    },
  );

  test(
    'tolerance-only geofence patch cannot silently succeed without geometry',
    () {
      expect(
        () => const UpdateUserGeofenceRequest(toleranceMeters: 90).toJson(),
        throwsArgumentError,
      );
    },
  );
}

class _Client extends ApiClient {
  _Client({this.reject = false}) : super(Dio());
  final bool reject;
  final requests = <(String, String, Map<String, dynamic>)>[];

  Future<ApiResponse<T>> _response<T>(
    String method,
    String endpoint,
    dynamic data,
    T Function(dynamic) parser,
  ) async {
    requests.add((method, endpoint, Map<String, dynamic>.from(data as Map)));
    if (reject) {
      final options = RequestOptions(path: endpoint);
      throw DioException(
        requestOptions: options,
        response: Response<dynamic>(requestOptions: options, statusCode: 400),
        type: DioExceptionType.badResponse,
      );
    }
    return ApiResponse(success: true, data: parser({'id': 7}));
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) => _response('POST', endpoint, data, parser);

  @override
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) => _response('PATCH', endpoint, data, parser);
}
