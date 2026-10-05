import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/user/models/user_subuser_model.dart';
import 'package:open_vts/features/user/models/user_vehicle_model.dart';
import 'package:open_vts/features/user/services/user_operations_service.dart';
import 'package:open_vts/features/user/services/user_subuser_service.dart';
import 'package:open_vts/features/user/services/user_vehicle_service_billing_service.dart';

void main() {
  late List<RequestOptions> requests;
  late ApiClient api;
  setUp(() {
    requests = [];
    final dio = Dio(BaseOptions(baseUrl: 'https://fleet.example/api'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'status': 'success',
                'data': {
                  'action': true,
                  'data': {
                    'items': [],
                    'hasMore': false,
                    'nextCursor': null,
                    'disabledFeatures': ['maps'],
                    'disabledReports': ['logs'],
                    'availableFeatures': {'maps': true},
                  },
                },
              },
            ),
          );
        },
      ),
    );
    api = ApiClient(dio);
  });

  test('Operations override sends current revision and reason', () async {
    final service = UserOperationsService(api);
    await service.overrideTrip(
      'b0c44995-79d4-41b5-a9ad-b520e74ed084',
      action: 'START',
      reason: 'Dispatcher approved',
      version: 4,
    );
    expect(
      requests.single.uri.path,
      '/api/user/operations/trips/b0c44995-79d4-41b5-a9ad-b520e74ed084/override',
    );
    expect(requests.single.data, {
      'action': 'START',
      'reason': 'Dispatcher approved',
      'expectedVersion': 4,
    });
    await expectLater(
      service.overrideTrip('trip', action: 'START', reason: '', version: 4),
      throwsArgumentError,
    );
    await expectLater(
      service.overrideTrip(
        'trip',
        action: 'INVALID',
        reason: 'Reason',
        version: 4,
      ),
      throwsArgumentError,
    );
    expect(requests.length, 1);
  });

  test(
    'Operations exception acknowledgment uses the current user event endpoint',
    () async {
      await UserOperationsService(api).acknowledgeEvent('932');
      expect(requests.single.method, 'PATCH');
      expect(
        requests.single.uri.path,
        '/api/user/operations/events/932/acknowledge',
      );
      await expectLater(
        UserOperationsService(api).acknowledgeEvent('../1'),
        throwsArgumentError,
      );
      expect(requests.length, 1);
    },
  );

  test(
    'Recurring updates include optimistic version without touching trips',
    () async {
      await UserOperationsService(api).updateRecurring('rule-id', {
        'version': 2,
        'title': 'Morning route',
        'exceptionDates': ['2026-10-10'],
      });
      expect(requests.single.method, 'PATCH');
      expect(
        requests.single.uri.path,
        '/api/user/operations/recurring/rule-id',
      );
      expect(requests.single.data['version'], 2);
    },
  );

  test(
    'Renewal retries preserve caller idempotency key and numeric vehicle ID',
    () async {
      final service = UserVehicleServiceBillingService(api);
      const key = 'b0c44995-79d4-41b5-a9ad-b520e74ed084';
      await service.requestRenewal(vehicleId: 13, idempotencyKey: key);
      await service.requestRenewal(vehicleId: 13, idempotencyKey: key);
      expect(
        requests.map((r) => r.data),
        everyElement({
          'vehicleIds': [13],
          'idempotencyKey': key,
        }),
      );
      expect(requests.first.uri.path, '/api/user/vehicle-service/requests');
    },
  );

  test(
    'Vehicle service lists use cursor pagination and unwrap nested envelope',
    () async {
      final data = await UserVehicleServiceBillingService(
        api,
      ).load(requests: false, cursor: 23, search: '  Truck  ');
      expect(requests.single.queryParameters, {
        'limit': 30,
        'cursor': 23,
        'search': 'Truck',
      });
      expect(data['hasMore'], false);
    },
  );

  test(
    'Subuser replacement preserves explicit and web-only deny lists',
    () async {
      final result = await UserSubUserService(api).replacePermissions(
        '42',
        disabledFeatures: ['maps', 'workflow'],
        disabledReports: ['logs'],
      );
      expect(requests.single.method, 'PUT');
      expect(requests.single.uri.path, '/api/user/subusers/42/permissions');
      expect(requests.single.data, {
        'disabledFeatures': ['maps', 'workflow'],
        'disabledReports': ['logs'],
      });
      expect(result['availableFeatures'], {'maps': true});
    },
  );

  test(
    'Subuser credentials remain exact; Unicode display names are accepted',
    () {
      final payload = const CreateUserSubUserRequest(
        name: '测试用户',
        password: '  secret  ',
      ).toJson();
      expect(payload['name'], '测试用户');
      expect(payload['password'], '  secret  ');
      expect(
        () =>
            const CreateUserSubUserRequest(name: 'User', password: '').toJson(),
        throwsArgumentError,
      );
      expect(
        () => const CreateUserSubUserRequest(
          name: 'User',
          password: 'पासवर्ड123',
        ).toJson(),
        throwsArgumentError,
      );
      expect(
        const UpdateUserSubUserRequest(
          password: '  secret  ',
        ).toJson()['password'],
        '  secret  ',
      );
    },
  );

  test(
    'Vehicle details distinguish customer expiry from provider coverage',
    () {
      final details = UserVehicleDetails.fromJson({
        'vehicle': {
          'id': 5,
          'primaryExpiry': '2027-10-02T00:00:00Z',
          'secondaryExpiry': '2027-01-02T00:00:00Z',
          'registrationAt': '2026-10-02T00:00:00Z',
        },
      });
      expect(details.primaryExpiry, DateTime.utc(2027, 10, 2));
      expect(details.secondaryExpiry, DateTime.utc(2027, 1, 2));
      expect(details.registrationAt, DateTime.utc(2026, 10, 2));
    },
  );
}
