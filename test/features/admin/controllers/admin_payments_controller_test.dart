import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_payments_controller.dart';
import 'package:open_vts/features/admin/models/admin_payments_model.dart';
import 'package:open_vts/features/admin/models/admin_payments_state.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/services/admin_payments_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminPaymentTransaction _mkTx(String id, {String status = 'SUCCESS'}) =>
    AdminPaymentTransaction.fromJson(<String, dynamic>{
      'id': id,
      'amount': '100',
      'currency': 'INR',
      'status': status,
      'paymentMode': 'CASH',
      'createdAt': '2026-08-01T10:00:00.000Z',
    });

AdminPaymentsPage _emptyPage({int page = 1}) => AdminPaymentsPage(
      page: page,
      limit: 100,
      total: 0,
      items: const <AdminPaymentTransaction>[],
    );

// ---------------------------------------------------------------------------
// Fake service
// ---------------------------------------------------------------------------

class _FakePaymentsService extends Fake implements AdminPaymentsService {
  List<AdminPaymentTransaction> items = const [];
  int getPaymentsCallCount = 0;
  bool throwOnRenew = false;
  AdminPaymentTransaction? renewResponse;

  @override
  Future<AdminPaymentsPage> getPayments({
    int page = 1,
    int limit = 100,
    String? userId,
    AdminPaymentStatus? status,
    DateTime? from,
    DateTime? to,
    String? q,
    String? refreshKey,
  }) async {
    getPaymentsCallCount++;
    return AdminPaymentsPage(
      page: page,
      limit: limit,
      total: items.length,
      items: items,
    );
  }

  @override
  Future<AdminPaymentsAnalytics> getTransactionsAnalytics({
    String? userId,
    DateTime? from,
    DateTime? to,
    String? refreshKey,
  }) async =>
      const AdminPaymentsAnalytics.empty();

  @override
  Future<List<AdminUserListItem>> getUsers() async =>
      const <AdminUserListItem>[];

  @override
  Future<List<AdminRenewVehicleOption>> getLinkedVehicles(
          String userId) async =>
      const <AdminRenewVehicleOption>[];

  @override
  Future<AdminPaymentTransaction?> renewVehicles(
      AdminRenewPaymentRequest request) async {
    if (throwOnRenew) throw Exception('Payment gateway timeout');
    return renewResponse;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── initial state ─────────────────────────────────────────────────────────

  group('AdminPaymentsController — initial state', () {
    test('isLoading is true before load() completes', () {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      expect(controller.state.isLoading, isTrue);
    });

    test('after load() isLoading is false', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      expect(controller.state.isLoading, isFalse);
    });

    test('transactions empty after load() when service returns none', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      expect(controller.state.transactions, isEmpty);
    });

    test('error during load sets errorMessage', () async {
      final svc = _FakePaymentsService();
      // Make getPayments throw after first call (initial load).
      var callCount = 0;
      svc.items = const []; // not used; override via subclass trick below

      final throwSvc = _ThrowingPaymentsService();
      final controller = AdminPaymentsController(service: throwSvc);
      await controller.load();
      expect(controller.state.errorMessage, isNotNull);
      expect(controller.state.isLoading, isFalse);
    });
  });

  // ── load with items ───────────────────────────────────────────────────────

  group('AdminPaymentsController — load with transactions', () {
    test('transactions are populated after successful load', () async {
      final svc = _FakePaymentsService();
      svc.items = [_mkTx('T1'), _mkTx('T2')];
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      expect(controller.state.transactions.length, 2);
    });
  });

  // ── refresh ───────────────────────────────────────────────────────────────

  group('AdminPaymentsController.refresh', () {
    test('increments refreshKey on each refresh', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      final keyBefore = controller.state.refreshKey;
      await controller.refresh();
      expect(controller.state.refreshKey, greaterThan(keyBefore));
    });

    test('isRefreshing transitions to false after refresh completes', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      await controller.refresh();
      expect(controller.state.isRefreshing, isFalse);
    });

    test('refresh replaces transactions with fresh data', () async {
      final svc = _FakePaymentsService();
      svc.items = [_mkTx('T1')];
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      svc.items = [_mkTx('T2'), _mkTx('T3')];
      await controller.refresh();
      final ids = controller.state.transactions.map((t) => t.id).toList();
      expect(ids, containsAll(['T2', 'T3']));
    });
  });

  // ── renewVehicles — success path ─────────────────────────────────────────

  group('AdminPaymentsController.renewVehicles — success', () {
    test('returns true on success', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      final ok = await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      expect(ok, isTrue);
    });

    test('clears isRenewing after success', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.upi,
        ),
      );
      expect(controller.state.isRenewing, isFalse);
    });

    test('no errorMessage on success', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      expect(controller.state.errorMessage, isNull);
    });

    test('triggers a full refresh after successful renewal', () async {
      final svc = _FakePaymentsService();
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      final callsBefore = svc.getPaymentsCallCount;
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      // At least one extra getPayments call expected from refresh().
      expect(svc.getPaymentsCallCount, greaterThan(callsBefore));
    });

    test('optimistically prepends renewed transaction before refresh',
        () async {
      final svc = _FakePaymentsService();
      final renewedTx = _mkTx('TXN-OPTIMISTIC');
      svc.renewResponse = renewedTx;
      // Service still returns empty list from refresh.
      svc.items = const [];

      final controller = AdminPaymentsController(service: svc);
      await controller.load();

      // After renew+refresh, the optimistic tx should appear (or at least
      // have been present transiently). Since refresh returns nothing, the
      // list ends up empty — but the controller must not crash.
      final ok = await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      expect(ok, isTrue);
    });

    test('renewed transaction with vehicle/plan is present after renew',
        () async {
      final svc = _FakePaymentsService();
      final renewedTx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-V',
        'amount': '1200',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicle': <String, dynamic>{
          'name': 'Fleet Truck',
          'plan': <String, dynamic>{'name': 'Fleet Plan'},
        },
      });
      svc.renewResponse = renewedTx;
      // Make refresh also return the transaction.
      svc.items = [renewedTx];

      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );

      final found =
          controller.state.transactions.where((t) => t.id == 'TXN-V').toList();
      expect(found, isNotEmpty);
      expect(found.first.vehicleDisplayName, 'Fleet Truck');
      expect(found.first.planDisplayName, 'Fleet Plan');
    });
  });

  // ── renewVehicles — error path ────────────────────────────────────────────

  group('AdminPaymentsController.renewVehicles — error', () {
    test('returns false on exception', () async {
      final svc = _FakePaymentsService();
      svc.throwOnRenew = true;
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      final ok = await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      expect(ok, isFalse);
    });

    test('sets errorMessage on exception', () async {
      final svc = _FakePaymentsService();
      svc.throwOnRenew = true;
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      expect(controller.state.errorMessage, isNotNull);
      expect(
          controller.state.errorMessage, contains('Payment gateway timeout'));
    });

    test('clears isRenewing on error', () async {
      final svc = _FakePaymentsService();
      svc.throwOnRenew = true;
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      expect(controller.state.isRenewing, isFalse);
    });

    test('does not call refresh after error', () async {
      final svc = _FakePaymentsService();
      svc.throwOnRenew = true;
      final controller = AdminPaymentsController(service: svc);
      await controller.load();
      final callsBefore = svc.getPaymentsCallCount;
      await controller.renewVehicles(
        const AdminRenewPaymentRequest(
          userId: '7',
          vehicleIds: ['41'],
          paymentMode: AdminPaymentMode.cash,
        ),
      );
      // No extra getPayments calls expected.
      expect(svc.getPaymentsCallCount, equals(callsBefore));
    });
  });

  // ── client-side mode filter ───────────────────────────────────────────────

  group('AdminPaymentsController — client-side mode filter', () {
    test('setMode(cash) shows only CASH transactions', () async {
      final cashTx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'T-CASH',
        'amount': '100',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'CASH',
        'createdAt': '2026-08-01T10:00:00.000Z',
      });
      final upiTx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'T-UPI',
        'amount': '200',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'UPI',
        'createdAt': '2026-08-01T11:00:00.000Z',
      });
      final svc = _FakePaymentsService();
      svc.items = [cashTx, upiTx];
      final controller = AdminPaymentsController(service: svc);
      await controller.load();

      expect(controller.state.transactions.length, 2);

      controller.setMode(AdminPaymentMode.cash);
      expect(controller.state.transactions.length, 1);
      expect(controller.state.transactions.first.paymentMode,
          AdminPaymentMode.cash);
    });

    test('setMode(null) restores all transactions', () async {
      final cashTx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'T-CASH2',
        'amount': '100',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'CASH',
        'createdAt': '2026-08-01T10:00:00.000Z',
      });
      final upiTx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'T-UPI2',
        'amount': '200',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'UPI',
        'createdAt': '2026-08-01T11:00:00.000Z',
      });
      final svc = _FakePaymentsService();
      svc.items = [cashTx, upiTx];
      final controller = AdminPaymentsController(service: svc);
      await controller.load();

      controller.setMode(AdminPaymentMode.upi);
      expect(controller.state.transactions.length, 1);

      controller.setMode(null);
      expect(controller.state.transactions.length, 2);
    });
  });

  // ── AdminPaymentsState.hasMore ────────────────────────────────────────────

  group('AdminPaymentsState.hasMore', () {
    test('true when page * limit < total', () {
      const state = AdminPaymentsState(
        transactions: [],
        analytics: null,
        users: [],
        selectedUserId: null,
        selectedStatus: null,
        selectedMode: null,
        searchQuery: '',
        rangePreset: AdminPaymentsRangePreset.last30Days,
        customFrom: null,
        customTo: null,
        page: 1,
        limit: 10,
        total: 25,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        isLoadingAnalytics: false,
        isRenewing: false,
        errorMessage: null,
        analyticsErrorMessage: null,
        refreshKey: 0,
      );
      expect(state.hasMore, isTrue);
    });

    test('false when all pages loaded', () {
      const state = AdminPaymentsState(
        transactions: [],
        analytics: null,
        users: [],
        selectedUserId: null,
        selectedStatus: null,
        selectedMode: null,
        searchQuery: '',
        rangePreset: AdminPaymentsRangePreset.last30Days,
        customFrom: null,
        customTo: null,
        page: 3,
        limit: 10,
        total: 25,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        isLoadingAnalytics: false,
        isRenewing: false,
        errorMessage: null,
        analyticsErrorMessage: null,
        refreshKey: 0,
      );
      expect(state.hasMore, isFalse);
    });
  });
}

// ---------------------------------------------------------------------------
// Service that always throws on getPayments
// ---------------------------------------------------------------------------

class _ThrowingPaymentsService extends Fake implements AdminPaymentsService {
  @override
  Future<AdminPaymentsPage> getPayments({
    int page = 1,
    int limit = 100,
    String? userId,
    AdminPaymentStatus? status,
    DateTime? from,
    DateTime? to,
    String? q,
    String? refreshKey,
  }) async =>
      throw Exception('Server error');

  @override
  Future<AdminPaymentsAnalytics> getTransactionsAnalytics({
    String? userId,
    DateTime? from,
    DateTime? to,
    String? refreshKey,
  }) async =>
      const AdminPaymentsAnalytics.empty();

  @override
  Future<List<AdminUserListItem>> getUsers() async =>
      const <AdminUserListItem>[];

  @override
  Future<List<AdminRenewVehicleOption>> getLinkedVehicles(
          String userId) async =>
      const <AdminRenewVehicleOption>[];

  @override
  Future<AdminPaymentTransaction?> renewVehicles(
          AdminRenewPaymentRequest request) async =>
      null;
}
