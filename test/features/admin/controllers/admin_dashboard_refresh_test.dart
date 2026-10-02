import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_users_controller.dart';
import 'package:open_vts/features/admin/controllers/admin_vehicles_controller.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/services/admin_users_service.dart';
import 'package:open_vts/features/admin/services/admin_vehicle_service.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';

// ---------------------------------------------------------------------------
// Minimal stubs
// ---------------------------------------------------------------------------

final _emptyUser = AdminUserListItem(
  id: '1',
  name: 'Test',
  username: 'test',
  email: 'test@example.com',
  mobilePrefix: '+91',
  mobileNumber: '9999999999',
  mobileDisplay: '+91 9999999999',
  isEmailVerified: false,
  isActive: true,
  companyName: '-',
  location: '-',
  countryCode: 'IN',
  stateCode: '',
  city: '',
  pincode: '',
  vehicleCount: 0,
  createdAt: null,
  updatedAt: null,
);

AdminUserDetails _emptyUserDetails({String id = '1'}) => AdminUserDetails(
      id: id,
      name: 'Test',
      username: 'test',
      email: 'test@example.com',
      mobilePrefix: '+91',
      mobileNumber: '9999999999',
      mobileDisplay: '+91 9999999999',
      isEmailVerified: false,
      isActive: true,
      companyName: '-',
      location: '-',
      countryCode: 'IN',
      stateCode: '',
      city: '',
      pincode: '',
      vehicleCount: 0,
      createdAt: null,
      updatedAt: null,
      address: const <String, dynamic>{},
      companies: const <Map<String, dynamic>>[],
      raw: const <String, dynamic>{},
    );

class _FakeUsersService extends Fake implements AdminUsersService {
  bool throwOnCreate = false;
  bool throwOnUpdate = false;
  bool throwOnUpdateStatus = false;
  bool throwOnDelete = false;

  @override
  Future<List<AdminUserListItem>> getUsers({
    String? refreshKey,
    String? search,
  }) async =>
      <AdminUserListItem>[_emptyUser];

  @override
  Future<AdminUserDetails> createUser(AdminCreateUserRequest request) async {
    if (throwOnCreate) throw Exception('create failed');
    return _emptyUserDetails();
  }

  @override
  Future<AdminUserDetails> updateUser({
    required String id,
    required AdminUpdateUserRequest request,
  }) async {
    if (throwOnUpdate) throw Exception('update failed');
    return _emptyUserDetails(id: id);
  }

  @override
  Future<void> updateUserStatus({
    required String id,
    required bool isActive,
  }) async {
    if (throwOnUpdateStatus) throw Exception('updateStatus failed');
  }

  @override
  Future<void> deleteUser(String id) async {
    if (throwOnDelete) throw Exception('delete failed');
  }
}

// AuthController has many required deps; we subclass StateNotifier directly
// to satisfy the type without instantiating the real implementation.
class _FakeAuthController extends StateNotifier<AuthState>
    implements AuthController {
  _FakeAuthController() : super(const AuthState.initial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeVehicleService extends Fake implements AdminVehicleService {
  bool throwOnCreate = false;
  bool throwOnUpdateStatus = false;
  bool throwOnDelete = false;

  @override
  Future<List<AdminVehicleListItem>> getVehicles({String? refreshKey}) async =>
      const <AdminVehicleListItem>[];

  @override
  Future<AdminVehicleDetails> createVehicle(
      AdminCreateVehicleRequest request) async {
    if (throwOnCreate) throw Exception('create failed');
    return AdminVehicleDetails.fromJson(
      const <String, dynamic>{'id': 1, 'name': 'New Vehicle'},
      fallbackId: '1',
    );
  }

  @override
  Future<void> updateVehicleStatus({
    required String id,
    required bool isActive,
  }) async {
    if (throwOnUpdateStatus) throw Exception('updateStatus failed');
  }

  @override
  Future<void> deleteVehicle(String id) async {
    if (throwOnDelete) throw Exception('delete failed');
  }

  // Required by createVehicle catalog fetch (not under test here)
  @override
  Future<List<AdminVehicleUserMini>> getUsers() async =>
      const <AdminVehicleUserMini>[];

  @override
  Future<List<AdminQuickDeviceOption>> getQuickDevices() async =>
      const <AdminQuickDeviceOption>[];

  @override
  Future<List<AdminVehicleTypeOption>> getVehicleTypes() async =>
      const <AdminVehicleTypeOption>[];

  @override
  Future<List<AdminPricingPlanOption>> getPricingPlans() async =>
      const <AdminPricingPlanOption>[];
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminUsersController _makeUsersController(
  _FakeUsersService service, {
  void Function()? onDashboardRefresh,
}) {
  return AdminUsersController(
    service: service,
    authController: _FakeAuthController(),
    onDashboardRefresh: onDashboardRefresh,
  );
}

AdminVehiclesController _makeVehiclesController(
  _FakeVehicleService service, {
  void Function()? onDashboardRefresh,
}) {
  return AdminVehiclesController(
    service: service,
    onDashboardRefresh: onDashboardRefresh,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminUsersController — onDashboardRefresh', () {
    test('fires after createUser succeeds', () async {
      var callCount = 0;
      final service = _FakeUsersService();
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await controller.createUser(_stubCreateRequest());

      expect(callCount, 1);
    });

    test('does NOT fire after createUser throws', () async {
      var callCount = 0;
      final service = _FakeUsersService()..throwOnCreate = true;
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await expectLater(
        controller.createUser(_stubCreateRequest()),
        throwsException,
      );
      expect(callCount, 0);
    });

    test('fires after updateUser succeeds', () async {
      var callCount = 0;
      final service = _FakeUsersService();
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await controller.updateUser('1', const AdminUpdateUserRequest());

      expect(callCount, 1);
    });

    test('does NOT fire after updateUser throws', () async {
      var callCount = 0;
      final service = _FakeUsersService()..throwOnUpdate = true;
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await expectLater(
        controller.updateUser('1', const AdminUpdateUserRequest()),
        throwsException,
      );
      expect(callCount, 0);
    });

    test('fires after updateUserStatus succeeds', () async {
      var callCount = 0;
      final service = _FakeUsersService();
      // Pre-populate state with a user so the optimistic update has something
      // to work with — do this by setting state directly via a load-like path.
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await controller.updateUserStatus('1', false);

      expect(callCount, 1);
    });

    test('does NOT fire after updateUserStatus throws', () async {
      var callCount = 0;
      final service = _FakeUsersService()..throwOnUpdateStatus = true;
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await expectLater(
        controller.updateUserStatus('1', false),
        throwsException,
      );
      expect(callCount, 0);
    });

    test('fires after deleteUser succeeds', () async {
      var callCount = 0;
      final service = _FakeUsersService();
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await controller.deleteUser('1');

      expect(callCount, 1);
    });

    test('does NOT fire after deleteUser throws', () async {
      var callCount = 0;
      final service = _FakeUsersService()..throwOnDelete = true;
      final controller = _makeUsersController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await expectLater(
        controller.deleteUser('1'),
        throwsException,
      );
      expect(callCount, 0);
    });

    test('works correctly when onDashboardRefresh is null (no crash)',
        () async {
      final service = _FakeUsersService();
      final controller = _makeUsersController(service);

      await expectLater(
        controller.createUser(_stubCreateRequest()),
        completes,
      );
    });
  });

  group('AdminVehiclesController — onDashboardRefresh', () {
    test('fires after createVehicle succeeds', () async {
      var callCount = 0;
      final service = _FakeVehicleService();
      final controller = _makeVehiclesController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await controller.createVehicle(_stubCreateVehicleRequest());

      expect(callCount, 1);
    });

    test('does NOT fire after createVehicle throws', () async {
      var callCount = 0;
      final service = _FakeVehicleService()..throwOnCreate = true;
      final controller = _makeVehiclesController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      await expectLater(
        controller.createVehicle(_stubCreateVehicleRequest()),
        throwsException,
      );
      expect(callCount, 0);
    });

    test('fires after updateVehicleStatus succeeds', () async {
      var callCount = 0;
      final service = _FakeVehicleService();
      final controller = _makeVehiclesController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      final result = await controller.updateVehicleStatus(
        id: '1',
        isActive: false,
      );

      expect(result, isTrue);
      expect(callCount, 1);
    });

    test('does NOT fire after updateVehicleStatus throws', () async {
      var callCount = 0;
      final service = _FakeVehicleService()..throwOnUpdateStatus = true;
      final controller = _makeVehiclesController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      final result = await controller.updateVehicleStatus(
        id: '1',
        isActive: false,
      );

      expect(result, isFalse);
      expect(callCount, 0);
    });

    test('fires after deleteVehicle succeeds', () async {
      var callCount = 0;
      final service = _FakeVehicleService();
      final controller = _makeVehiclesController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      final result = await controller.deleteVehicle('1');

      expect(result, isTrue);
      expect(callCount, 1);
    });

    test('does NOT fire after deleteVehicle throws', () async {
      var callCount = 0;
      final service = _FakeVehicleService()..throwOnDelete = true;
      final controller = _makeVehiclesController(
        service,
        onDashboardRefresh: () => callCount++,
      );

      final result = await controller.deleteVehicle('1');

      expect(result, isFalse);
      expect(callCount, 0);
    });

    test('works correctly when onDashboardRefresh is null (no crash)',
        () async {
      final service = _FakeVehicleService();
      final controller = _makeVehiclesController(service);

      final result = await controller.deleteVehicle('1');
      expect(result, isTrue);
    });
  });
}

// ---------------------------------------------------------------------------
// Stub factories
// ---------------------------------------------------------------------------

AdminCreateUserRequest _stubCreateRequest() {
  return const AdminCreateUserRequest(
    name: 'Test User',
    email: 'test@example.com',
    mobilePrefix: '+91',
    mobileNumber: '9999999999',
    username: 'testuser',
    password: 'password123',
    companyName: 'Test Co',
    address: 'Test Address',
    countryCode: 'IN',
    stateCode: 'MH',
    city: 'Mumbai',
    pincode: '400001',
  );
}

AdminCreateVehicleRequest _stubCreateVehicleRequest() {
  return const AdminCreateVehicleRequest(
    name: 'Test Vehicle',
    vin: '',
    plateNumber: 'MH01AB1234',
    primaryUserId: '1',
    vehicleTypeId: '1',
    planId: '1',
    deviceId: null,
  );
}
