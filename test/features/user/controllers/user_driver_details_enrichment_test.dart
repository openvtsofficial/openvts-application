import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/controllers/user_driver_details_controller.dart';
import 'package:open_vts/features/user/models/user_driver_model.dart';
import 'package:open_vts/features/user/models/user_drivers_state.dart';
import 'package:open_vts/features/user/services/user_driver_service.dart';

// ---------------------------------------------------------------------------
// Minimal fakes
// ---------------------------------------------------------------------------

class _FakeDriverService implements UserDriverService {
  _FakeDriverService({
    required this.driverResult,
    required this.vehiclesResult,
  });

  final Future<UserDriver> Function() driverResult;
  final Future<List<UserDriverVehicleMini>> Function() vehiclesResult;

  @override
  Future<UserDriver> fetchDriverById(String id, {String? refreshKey}) =>
      driverResult();

  @override
  Future<List<UserDriverVehicleMini>> fetchAvailableVehicles(
          {String? refreshKey}) =>
      vehiclesResult();

  @override
  Future<void> assignVehicle(String driverId, String vehicleId) =>
      Future<void>.value();

  @override
  Future<void> unassignVehicle(String driverId) => Future<void>.value();

  // Unused paths for these tests — return safe defaults.
  @override
  Future<List<UserDriverLog>> fetchDriverLogs(String id,
          {String? refreshKey}) async =>
      const [];

  @override
  Future<List<UserDriverDocument>> fetchDriverDocuments(String id,
          {String? refreshKey}) async =>
      const [];

  @override
  Future<List<UserDriverDocumentType>> fetchDriverDocumentTypes(
          {String? refreshKey}) async =>
      const [];

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

// ---------------------------------------------------------------------------
// Model builders
// ---------------------------------------------------------------------------

UserDriverVehicleMini _miniVehicle({
  String id = '1',
  String name = 'Vehicle',
  String plateNumber = 'PLATE1',
  String imei = '',
  String vin = '',
}) =>
    UserDriverVehicleMini(
      id: id,
      name: name,
      plateNumber: plateNumber,
      imei: imei,
      vin: vin,
      vehicleType: '',
      createdAt: null,
    );

UserDriver _driverWith({
  String id = 'drv1',
  UserDriverVehicleAssignment? assignment,
}) =>
    UserDriver(
      id: id,
      name: 'Test Driver',
      mobilePrefix: '',
      mobile: '',
      email: '',
      username: '',
      countryCode: '',
      stateCode: '',
      city: '',
      address: '',
      pincode: '',
      status: '',
      isActive: true,
      isVerified: false,
      createdAt: null,
      updatedAt: null,
      attributes: const {},
      addressDetails: null,
      vehicleAssignment: assignment,
    );

UserDriverVehicleAssignment _assignment({
  String vehicleId = '1',
  UserDriverVehicleMini? vehicle,
}) =>
    UserDriverVehicleAssignment(
      id: 'a1',
      driverId: 'drv1',
      vehicleId: vehicleId,
      vehicle: vehicle,
      createdAt: null,
      updatedAt: null,
      raw: const {},
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserDriverDetailsController — assigned vehicle enrichment', () {
    // Helper: build controller, loadInitial, return state.
    Future<UserDriverDetailsState> loadState({
      required UserDriver driver,
      required List<UserDriverVehicleMini> vehicles,
    }) async {
      final svc = _FakeDriverService(
        driverResult: () async => driver,
        vehiclesResult: () async => vehicles,
      );
      final controller = UserDriverDetailsController(
        driverId: 'drv1',
        service: svc,
      );
      await controller.loadInitial();
      final result = controller.state;
      controller.dispose();
      return result;
    }

    // 1. IMEI missing from driver details but present in vehicle list.
    test('enriches imei from vehicle list when driver detail lacks it',
        () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(
            id: '10',
            name: 'GT06 Vehicle 10',
            plateNumber: 'UP89YZ7823',
            imei: '',
          ),
        ),
      );
      final vehicles = [
        _miniVehicle(
            id: '10', imei: '867XXXXXXXXXXXX', plateNumber: 'UP89YZ7823'),
        _miniVehicle(id: '99', imei: '000000000000000'),
      ];

      final state = await loadState(driver: driver, vehicles: vehicles);

      expect(state.driver?.assignedVehicle?.imei, '867XXXXXXXXXXXX');
    });

    // 2. Matching is by ID only — other vehicles must not bleed through.
    test('matches only by vehicle ID, not name or plate', () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(
            id: '10',
            name: 'GT06 Vehicle 10',
            plateNumber: 'UP89YZ7823',
            imei: '',
          ),
        ),
      );
      final vehicles = [
        // Same name/plate but different ID — must NOT be used.
        _miniVehicle(
          id: '99',
          name: 'GT06 Vehicle 10',
          plateNumber: 'UP89YZ7823',
          imei: 'WRONG_IMEI',
        ),
        // Correct ID.
        _miniVehicle(id: '10', imei: '867XXXXXXXXXXXX'),
      ];

      final state = await loadState(driver: driver, vehicles: vehicles);
      expect(state.driver?.assignedVehicle?.imei, '867XXXXXXXXXXXX');
    });

    // 3. Non-matching vehicles do not affect assigned vehicle.
    test('does not enrich from wrong vehicle id', () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: ''),
        ),
      );
      final vehicles = [
        _miniVehicle(id: '55', imei: 'SHOULDNOTAPPEAR'),
      ];

      final state = await loadState(driver: driver, vehicles: vehicles);
      // No match found — imei stays empty.
      expect(state.driver?.assignedVehicle?.imei, '');
    });

    // 4. Existing non-empty detail value is preserved.
    test('preserves non-empty imei from driver detail response', () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: 'EXISTING_IMEI'),
        ),
      );
      final vehicles = [
        _miniVehicle(id: '10', imei: 'DIFFERENT_IMEI'),
      ];

      final state = await loadState(driver: driver, vehicles: vehicles);
      expect(state.driver?.assignedVehicle?.imei, 'EXISTING_IMEI');
    });

    // 5. Driver with no assignment is returned unchanged.
    test('returns driver unchanged when no vehicle is assigned', () async {
      final driver = _driverWith(assignment: null);
      final vehicles = [_miniVehicle(id: '10', imei: '867XXXXXXXXXXXX')];

      final state = await loadState(driver: driver, vehicles: vehicles);
      expect(state.driver?.assignedVehicle, isNull);
    });

    // 6. Refresh repeats enrichment.
    test('refresh enriches imei just as loadInitial does', () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: ''),
        ),
      );
      final vehicles = [_miniVehicle(id: '10', imei: '867XXXXXXXXXXXX')];

      final svc = _FakeDriverService(
        driverResult: () async => driver,
        vehiclesResult: () async => vehicles,
      );
      final controller = UserDriverDetailsController(
        driverId: 'drv1',
        service: svc,
      );
      await controller.loadInitial();
      await controller.refresh();
      expect(controller.state.driver?.assignedVehicle?.imei, '867XXXXXXXXXXXX');
      controller.dispose();
    });

    // 7. After assignVehicle, new vehicle gets its own IMEI.
    test('assignVehicle: new vehicle receives its IMEI after reload', () async {
      final driverBefore = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: ''),
        ),
      );
      final driverAfter = _driverWith(
        assignment: _assignment(
          vehicleId: '20',
          vehicle: _miniVehicle(id: '20', imei: ''),
        ),
      );
      var callCount = 0;
      final vehicles = [
        _miniVehicle(id: '10', imei: 'OLD_IMEI'),
        _miniVehicle(id: '20', imei: 'NEW_IMEI'),
      ];

      final svc = _FakeDriverService(
        driverResult: () async => callCount++ == 0 ? driverBefore : driverAfter,
        vehiclesResult: () async => vehicles,
      );
      final controller = UserDriverDetailsController(
        driverId: 'drv1',
        service: svc,
      );
      await controller.loadInitial();
      await controller.assignVehicle('20');
      expect(controller.state.driver?.assignedVehicle?.imei, 'NEW_IMEI');
      controller.dispose();
    });

    // 8. Change vehicle: old IMEI is not retained.
    test('old vehicle IMEI is not retained after vehicle change', () async {
      final driverBefore = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: ''),
        ),
      );
      final driverAfter = _driverWith(
        assignment: _assignment(
          vehicleId: '20',
          vehicle: _miniVehicle(id: '20', imei: ''),
        ),
      );
      var callCount = 0;
      final vehicles = [
        _miniVehicle(id: '10', imei: 'OLD_IMEI'),
        _miniVehicle(id: '20', imei: 'NEW_IMEI'),
      ];

      final svc = _FakeDriverService(
        driverResult: () async => callCount++ == 0 ? driverBefore : driverAfter,
        vehiclesResult: () async => vehicles,
      );
      final controller = UserDriverDetailsController(
        driverId: 'drv1',
        service: svc,
      );
      await controller.loadInitial();
      await controller.assignVehicle('20');

      final imei = controller.state.driver?.assignedVehicle?.imei;
      expect(imei, isNot('OLD_IMEI'));
      expect(imei, 'NEW_IMEI');
      controller.dispose();
    });

    // 9. After unassign, assignedVehicle is null.
    test('unassignVehicle: assignedVehicle becomes null', () async {
      final driverBefore = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: 'OLD_IMEI'),
        ),
      );
      final driverAfter = _driverWith(assignment: null);
      var callCount = 0;
      final vehicles = [_miniVehicle(id: '10', imei: 'OLD_IMEI')];

      final svc = _FakeDriverService(
        driverResult: () async => callCount++ == 0 ? driverBefore : driverAfter,
        vehiclesResult: () async => vehicles,
      );
      final controller = UserDriverDetailsController(
        driverId: 'drv1',
        service: svc,
      );
      await controller.loadInitial();
      await controller.unassignVehicle();
      expect(controller.state.driver?.assignedVehicle, isNull);
      controller.dispose();
    });

    // 10. Empty IMEI in all confirmed sources — UI shows "-".
    test('imei stays empty when not present in any source', () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: ''),
        ),
      );
      final vehicles = [_miniVehicle(id: '10', imei: '')];

      final state = await loadState(driver: driver, vehicles: vehicles);
      expect(state.driver?.assignedVehicle?.imei, '');
    });

    // 11. Available vehicle list still excludes currently assigned vehicle.
    test('available vehicles excludes the assigned vehicle after enrichment',
        () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', imei: ''),
        ),
      );
      final vehicles = [
        _miniVehicle(id: '10', imei: 'ASSIGNED_IMEI'),
        _miniVehicle(id: '20', imei: 'OTHER_IMEI'),
      ];

      final state = await loadState(driver: driver, vehicles: vehicles);
      final availableIds = state.availableVehicles.map((v) => v.id).toList();
      expect(availableIds, isNot(contains('10')));
      expect(availableIds, contains('20'));
    });

    // 12. VIN enrichment follows same precedence rule.
    test('enriches vin from vehicle list when driver detail lacks it',
        () async {
      final driver = _driverWith(
        assignment: _assignment(
          vehicleId: '10',
          vehicle: _miniVehicle(id: '10', vin: ''),
        ),
      );
      final vehicles = [_miniVehicle(id: '10', vin: 'VIN123456')];

      final state = await loadState(driver: driver, vehicles: vehicles);
      expect(state.driver?.assignedVehicle?.vin, 'VIN123456');
    });
  });

  group('UserDriverVehicleMini.fromJson — device.imei fallback', () {
    test('uses device.imei when top-level imei is absent', () {
      final json = <String, dynamic>{
        'id': '10',
        'name': 'TestVehicle',
        'plateNumber': 'ABC123',
        'device': {'imei': '867DEVICE000000'},
      };
      final vehicle = UserDriverVehicleMini.fromJson(json);
      expect(vehicle.imei, '867DEVICE000000');
    });

    test('top-level imei takes precedence over device.imei', () {
      final json = <String, dynamic>{
        'id': '10',
        'name': 'TestVehicle',
        'plateNumber': 'ABC123',
        'imei': '867TOPLEVEL00000',
        'device': {'imei': '867DEVICE000000'},
      };
      final vehicle = UserDriverVehicleMini.fromJson(json);
      expect(vehicle.imei, '867TOPLEVEL00000');
    });

    test('returns empty imei when neither source has a value', () {
      final json = <String, dynamic>{
        'id': '10',
        'name': 'TestVehicle',
        'plateNumber': 'ABC123',
      };
      final vehicle = UserDriverVehicleMini.fromJson(json);
      expect(vehicle.imei, '');
    });
  });
}
