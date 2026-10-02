import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/live_map/models/live_map_role_config.dart';
import 'package:open_vts/features/live_map/services/live_map_vehicle_service.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));

  for (final config in <LiveMapRoleConfig>[
    LiveMapRoleConfig.user(),
    LiveMapRoleConfig.admin(),
    LiveMapRoleConfig.superadmin(),
  ]) {
    test('${config.role.name} map follows cursor and retains later vehicles', () async {
      final requests = <RequestOptions>[];
      final dio = _dio((request) {
        requests.add(request);
        final secondPage = request.queryParameters['cursor'] == '500';
        return <String, dynamic>{
          'items': <Map<String, dynamic>>[
            _vehicle(secondPage ? '501' : '500'),
          ],
          'hasMore': !secondPage,
          'nextCursor': secondPage ? null : '500',
        };
      });
      final service = LiveMapVehicleService(
        apiClient: ApiClient(dio),
        config: config,
      );
      final result = await service.getMapTelemetry(refreshKey: 'contract');
      expect(result.vehicles.map((vehicle) => vehicle.id), ['500', '501']);
      expect(result.allCount, 2);
      expect(requests, hasLength(2));
      expect(requests.first.uri.path, '/api${config.mapTelemetryEndpoint}');
      expect(requests.first.queryParameters['limit'], 500);
      expect(requests.last.queryParameters['cursor'], '500');
      expect(requests.last.queryParameters['rk'], 'contract');
      final query = requests.first.queryParameters;
      expect(query['dayKey'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      final dayStart = DateTime.parse(query['dayStart'] as String).toLocal();
      expect(dayStart.hour, 0);
      expect(dayStart.minute, 0);
      expect(requests.last.queryParameters['dayStart'], query['dayStart']);
    });
  }

  test('map fails on repeated cursor instead of looping or truncating silently', () async {
    var requestCount = 0;
    final service = LiveMapVehicleService(
      apiClient: ApiClient(_dio((_) {
        requestCount++;
        return <String, dynamic>{
          'items': [_vehicle('500')],
          'hasMore': true,
          'nextCursor': '500',
        };
      })),
      config: LiveMapRoleConfig.user(),
    );
    await expectLater(service.getMapTelemetry(), throwsStateError);
    expect(requestCount, 2);
  });

  test('selected map command uses required mode and unwraps queued command ID', () async {
    RequestOptions? captured;
    final service = LiveMapVehicleService(
      apiClient: ApiClient(_dio((request) {
        captured = request;
        return <String, dynamic>{
          'mode': 'SELECTED',
          'totalTargets': 1,
          'queued': 1,
          'results': [
            {'vehicleId': 42, 'cmdId': 'cmd-42', 'queued': true,
              'connected': false, 'queueId': 'queue-42'},
          ],
        };
      })),
      config: LiveMapRoleConfig.user(),
    );
    final result = await service.sendBulkCommandForUserVehicles(
      vehicleIds: ['42'], command: 'STATUS#',
    );
    expect(captured!.method, 'POST');
    expect(captured!.uri.path, '/api/user/commands/send-bulk');
    expect(captured!.data, {
      'mode': 'SELECTED', 'vehicleIds': [42], 'command': 'STATUS#',
    });
    expect(result.cmdId, 'cmd-42');
    expect(result.queueId, 'queue-42');
    expect(result.wasQueued, isTrue);
  });

  test('per-vehicle dispatch failure is not reported as sent', () async {
    final service = LiveMapVehicleService(
      apiClient: ApiClient(_dio((_) => {
        'results': [
          {'vehicleId': 42, 'error': 'Missing or invalid IMEI'},
        ],
      })),
      config: LiveMapRoleConfig.user(),
    );
    await expectLater(
      service.sendBulkCommandForUserVehicles(vehicleIds: ['42'], command: 'STATUS#'),
      throwsStateError,
    );
  });
}

Map<String, dynamic> _vehicle(String id) => {
  'vehicleId': id,
  'vehicleName': 'Vehicle $id',
  'imei': '1234567890$id',
  'status': 'running',
  'latitude': 40.7,
  'longitude': -74.0,
  'speedKph': 35,
};

Dio _dio(dynamic Function(RequestOptions request) reply) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
    handler.resolve(Response<dynamic>(
      requestOptions: request,
      statusCode: 200,
      data: {'action': true, 'data': reply(request)},
    ));
  }));
  return dio;
}
