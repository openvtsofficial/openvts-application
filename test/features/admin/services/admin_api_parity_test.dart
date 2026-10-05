import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/models/admin_payments_model.dart';
import 'package:open_vts/features/admin/models/admin_user_details_model.dart';
import 'package:open_vts/features/admin/services/admin_drivers_service.dart';
import 'package:open_vts/features/admin/services/admin_payments_service.dart';
import 'package:open_vts/features/admin/services/admin_team_service.dart';
import 'package:open_vts/features/admin/services/admin_user_details_service.dart';
import 'package:open_vts/features/admin/services/admin_vehicle_service.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  late List<RequestOptions> requests;
  ApiClient client(UserRole role) {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          requests.add(o);
          h.resolve(
            Response<dynamic>(
              requestOptions: o,
              statusCode: 200,
              data: o.path.contains('/documents') ? [] : {'items': []},
            ),
          );
        },
      ),
    );
    return ApiClient(
      dio,
      activeUser: () => CurrentUser(
        id: '7',
        name: 'Test',
        email: '',
        role: role,
        access: const MobileAccess(
          loaded: true,
          grants: {
            'vehicles.view': 'OWN',
            'users.view': 'OWN',
            'drivers.view': 'OWN',
          },
        ),
      ),
    );
  }

  setUp(() => requests = []);
  test(
    'team picker APIs use contextual scopes and do not call admin users',
    () async {
      final api = client(UserRole.team);
      await AdminVehicleService(api).getUsers();
      await AdminDriversService(api).getUsersForDriverPrimarySelection();
      final payments = AdminPaymentsService(api);
      await payments.getUsers();
      await payments.getRenewalUsers();
      await payments.getLinkedVehicles('42');
      expect(requests.map((r) => r.path), [
        '/team/vehicle-options/users',
        '/team/drivers/eligible-users',
        '/team/payments/users',
        '/team/payments/renew/users',
        '/team/payments/renew/users/42/vehicles',
      ]);
    },
  );
  test(
    'view-only team detail does not request mutation-only assignment options',
    () async {
      final api = client(UserRole.team);
      expect(await AdminVehicleService(api).getUnlinkedUsers('42'), isEmpty);
      expect(await AdminDriversService(api).getUnlinkedUsers('42'), isEmpty);
      expect(
        await AdminUserDetailsService(api).getUnlinkedVehicles('42'),
        isEmpty,
      );
      expect(
        await AdminUserDetailsService(api).getUnlinkedDrivers('42'),
        isEmpty,
      );
      expect(requests, isEmpty);
    },
  );
  test('team document delete carries owning entity in URL', () async {
    final api = client(UserRole.team);
    await AdminVehicleService(api).deleteVehicleDocument('8', vehicleId: '42');
    await AdminDriversService(api).deleteDriverDocument('9', driverId: '6');
    await AdminUserDetailsService(api).deleteDocument('10', userId: '3');
    expect(requests.map((r) => r.path), [
      '/team/vehicles/42/documents/8',
      '/team/drivers/6/documents/9',
      '/team/users/3/documents/10',
    ]);
    expect(requests.map((r) => r.method), everyElement('DELETE'));
  });
  test(
    'team command uses approved command ID and explicit confirmation',
    () async {
      await AdminVehicleService(client(UserRole.team)).sendCommandByImei(
        imei: '123456789012345',
        vehicleId: '42',
        commandId: '5',
        command: 'DO NOT SEND RAW',
      );
      expect(requests.single.path, '/team/vehicles/42/commands');
      expect(requests.single.data, {'commandId': 5, 'confirmed': true});
    },
  );
  test('manual renewal preserves provided UUID and reason exactly', () async {
    final service = AdminPaymentsService(client(UserRole.admin));
    const request = AdminRenewPaymentRequest(
      userId: '7',
      vehicleIds: ['42'],
      paymentMode: AdminPaymentMode.cash,
      idempotencyKey: 'bd3633ea-3dfc-4441-a287-1ab2356d9cb2',
      amountOverride: '100.00',
      overrideReason: 'Agreed discount',
    );
    await service.renewVehicles(request);
    await service.renewVehicles(request);
    expect(
      requests.map((r) => (r.data as Map)['idempotencyKey']),
      everyElement(request.idempotencyKey),
    );
    expect((requests.first.data as Map)['overrideReason'], 'Agreed discount');
  });
  test(
    'legacy renewal request object retains generated key across retries',
    () async {
      final service = AdminPaymentsService(client(UserRole.admin));
      const request = AdminRenewPaymentRequest(
        userId: '7',
        vehicleIds: ['42'],
        paymentMode: AdminPaymentMode.cash,
      );
      await service.renewVehicles(request);
      await service.renewVehicles(request);
      final first = (requests.first.data as Map)['idempotencyKey'];
      expect(
        first,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect((requests.last.data as Map)['idempotencyKey'], first);
    },
  );
  test('user detail team renewal has scoped endpoint and UUID', () async {
    await AdminUserDetailsService(client(UserRole.team)).renewVehiclesPayment(
      const AdminRenewVehiclesPaymentRequest(
        userId: '7',
        vehicleIds: ['42'],
        paymentMode: 'CASH',
        idempotencyKey: 'bd3633ea-3dfc-4441-a287-1ab2356d9cb2',
      ),
    );
    expect(requests.single.path, '/team/users/7/payments/renew');
    expect(
      (requests.single.data as Map)['idempotencyKey'],
      'bd3633ea-3dfc-4441-a287-1ab2356d9cb2',
    );
  });
  test(
    'administrator resets preserve exact ASCII password including spaces',
    () async {
      final api = client(UserRole.admin);
      await AdminUserDetailsService(
        api,
      ).updateUserPassword('42', '  pass1234  ');
      await AdminTeamService(
        api,
      ).changeTeamMemberPassword('43', '  pass1234  ');
      await AdminDriversService(
        api,
      ).updateDriverPassword(id: '44', password: '  pass1234  ');
      expect((requests[0].data as Map)['newPassword'], '  pass1234  ');
      expect((requests[1].data as Map)['password'], '  pass1234  ');
      expect((requests[2].data as Map)['password'], '  pass1234  ');
      expect(requests[0].method, 'POST');
    },
  );
}
