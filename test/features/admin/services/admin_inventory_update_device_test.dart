import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_inventory_controller.dart';
import 'package:open_vts/features/admin/models/admin_inventory_model.dart';
import 'package:open_vts/features/admin/services/admin_inventory_service.dart';

// ---------------------------------------------------------------------------
// Minimal stubs
// ---------------------------------------------------------------------------

AdminInventoryDevice _mkDevice(String id) => AdminInventoryDevice(
      id: id,
      imei: '123456789012345',
      deviceType: 'GT06',
      deviceTypeId: '1',
      assignedSimId: null,
      assignedSimNumber: '',
      status: AdminInventoryStatus.inStock,
      isActive: true,
      createdAt: null,
      updatedAt: null,
    );

// ---------------------------------------------------------------------------
// Fake service
// ---------------------------------------------------------------------------

class _FakeInventoryService extends Fake implements AdminInventoryService {
  // Tracks which endpoints were invoked.
  final List<String> patchedIds = [];
  final List<String> getByIdCalls = [];

  bool throwOnPatch = false;
  String? patchErrorMessage;

  List<AdminInventoryDevice> devicesResult = const [];
  List<AdminInventorySimCard> simCardsResult = const [];

  @override
  Future<void> updateDevice({
    required String id,
    required AdminUpdateDeviceRequest request,
  }) async {
    if (throwOnPatch) {
      throw Exception(patchErrorMessage ?? 'PATCH failed');
    }
    patchedIds.add(id);
  }

  @override
  Future<List<AdminInventoryDevice>> getDevices({String? refreshKey}) async {
    return devicesResult;
  }

  @override
  Future<List<AdminInventorySimCard>> getSimCards({String? refreshKey}) async {
    return simCardsResult;
  }

  // The remaining service methods are not exercised by these tests.
  @override
  Future<List<AdminDeviceTypeOption>> getDeviceTypes() async => const [];

  @override
  Future<List<AdminSimProviderOption>> getSimProviders() async => const [];

  @override
  Future<List<AdminQuickSimCardOption>> getQuickSimcards() async => const [];
}

// ---------------------------------------------------------------------------
// Helper to build a StateNotifier under test without a ProviderContainer
// ---------------------------------------------------------------------------

AdminInventoryController _buildController(_FakeInventoryService svc) =>
    AdminInventoryController(service: svc);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminInventoryService.updateDevice — no GET after PATCH', () {
    test('successful PATCH calls patch endpoint exactly once', () async {
      final svc = _FakeInventoryService();
      await svc.updateDevice(
        id: '42',
        request: const AdminUpdateDeviceRequest(
          deviceTypeId: 1,
          simId: null,
          status: 'IN_USE',
          isActive: true,
        ),
      );

      expect(svc.patchedIds, equals(['42']));
      expect(svc.getByIdCalls, isEmpty,
          reason: 'GET /admin/devices/:id must never be called');
    });

    test('PATCH failure throws and does not attempt a GET', () async {
      final svc = _FakeInventoryService()
        ..throwOnPatch = true
        ..patchErrorMessage = 'Device not found';

      expect(
        () => svc.updateDevice(
          id: '99',
          request: const AdminUpdateDeviceRequest(
            deviceTypeId: null,
            simId: null,
            status: 'IN_SCRAP',
            isActive: false,
          ),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Device not found'),
        )),
      );
      expect(svc.getByIdCalls, isEmpty);
    });
  });

  group('AdminInventoryController.updateDevice — post-success refresh', () {
    test('returns true and refreshes both devices and SIM cards on success',
        () async {
      final device = _mkDevice('1');
      final svc = _FakeInventoryService()
        ..devicesResult = [device]
        ..simCardsResult = const [];

      final controller = _buildController(svc);

      // Pre-load so the controller has the devices list populated.
      await controller.loadDevices();

      final result = await controller.updateDevice(
        id: '1',
        request: const AdminUpdateDeviceRequest(
          deviceTypeId: 1,
          simId: null,
          status: 'IN_USE',
          isActive: true,
        ),
      );

      expect(result, isTrue);
      // getDevices is called: once for loadDevices + once for refreshDevices
      // after the successful update. We verify devices list is populated.
      expect(controller.state.devices, equals([device]));
    });

    test('returns false and sets editErrorMessage on PATCH failure', () async {
      final svc = _FakeInventoryService()
        ..throwOnPatch = true
        ..patchErrorMessage = 'Unauthorized';

      final controller = _buildController(svc);

      final result = await controller.updateDevice(
        id: '5',
        request: const AdminUpdateDeviceRequest(
          deviceTypeId: null,
          simId: null,
          status: 'IN_STOCK',
          isActive: false,
        ),
      );

      expect(result, isFalse);
      expect(controller.state.editErrorMessage, equals('Unauthorized'));
    });

    test('editing device id is removed from editingDeviceIds after success',
        () async {
      final svc = _FakeInventoryService();
      final controller = _buildController(svc);

      await controller.updateDevice(
        id: '7',
        request: const AdminUpdateDeviceRequest(
          deviceTypeId: null,
          simId: null,
          status: 'IN_STOCK',
          isActive: true,
        ),
      );

      expect(controller.state.editingDeviceIds, isNot(contains('7')));
    });

    test('editing device id is removed from editingDeviceIds after failure',
        () async {
      final svc = _FakeInventoryService()..throwOnPatch = true;
      final controller = _buildController(svc);

      await controller.updateDevice(
        id: '8',
        request: const AdminUpdateDeviceRequest(
          deviceTypeId: null,
          simId: null,
          status: 'IN_STOCK',
          isActive: true,
        ),
      );

      expect(controller.state.editingDeviceIds, isNot(contains('8')));
    });
  });
}
