import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_logs_controller.dart';
import 'package:open_vts/features/admin/models/admin_logs_model.dart';
import 'package:open_vts/features/admin/models/admin_logs_state.dart';
import 'package:open_vts/features/admin/services/admin_logs_service.dart';

// ---------------------------------------------------------------------------
// Fake service — records getVehicleEventLogs calls, stubs everything else
// ---------------------------------------------------------------------------

class _FakeService extends Fake implements AdminLogsService {
  final List<Map<String, dynamic>> vehicleCalls = [];
  List<AdminVehicleEventLogItem> nextItems = const [];
  String? nextCursorId;
  Object? throwError;

  @override
  Future<AdminLogsOptions> getOptions() async => AdminLogsOptions.empty();

  @override
  Future<AdminActivityLogPage> getActivityLogs({
    int limit = 20,
    String? q,
    String? userId,
    String? actionPrefix,
    String? entity,
    String? from,
    String? to,
    String? cursorId,
  }) async =>
      AdminActivityLogPage(items: const [], nextCursorId: null, hasMore: false);

  @override
  Future<AdminVehicleEventLogPage> getVehicleEventLogs({
    int limit = 50,
    String? cursorId,
    String? from,
    String? to,
    String? vehicleId,
    String? userId,
    String? source,
    String? severity,
    String? q,
    bool? isRead,
    bool dedupe = true,
  }) async {
    if (throwError != null) throw throwError!;
    vehicleCalls.add({
      'limit': limit,
      'cursorId': cursorId,
      'from': from,
      'to': to,
      'vehicleId': vehicleId,
      'userId': userId,
      'source': source,
      'severity': severity,
      'q': q,
      'isRead': isRead,
      'dedupe': dedupe,
    });
    return AdminVehicleEventLogPage(
        items: nextItems, nextCursorId: nextCursorId);
  }
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

AdminLogsController _build(_FakeService svc) =>
    AdminLogsController(service: svc);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminLogsController — vehicle event filters', () {
    // -----------------------------------------------------------------------
    // Default 24h window is visible in state
    // -----------------------------------------------------------------------

    test('vehicleFrom is initialized to ~24h ago on construction', () {
      final svc = _FakeService();
      final before = DateTime.now().subtract(const Duration(hours: 24));
      final ctrl = _build(svc);
      final after = DateTime.now().subtract(const Duration(hours: 24));

      expect(ctrl.state.vehicleFrom, isNotNull);
      // Allow a few ms of skew either way
      expect(
        ctrl.state.vehicleFrom!.millisecondsSinceEpoch,
        greaterThanOrEqualTo(before.millisecondsSinceEpoch - 500),
      );
      expect(
        ctrl.state.vehicleFrom!.millisecondsSinceEpoch,
        lessThanOrEqualTo(after.millisecondsSinceEpoch + 500),
      );
    });

    test('initial load sends the visible vehicleFrom to the service', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero); // drain auto-load

      expect(svc.vehicleCalls, isEmpty,
          reason: 'vehicle tab is not loaded until selected');

      await ctrl.loadVehicleLogs();

      expect(svc.vehicleCalls, hasLength(1));
      final call = svc.vehicleCalls.first;
      expect(call['from'], isNotNull,
          reason:
              'the visible 24h default must be sent — no silent hidden override');
      expect(call['from'], contains('T'));
    });

    // -----------------------------------------------------------------------
    // No hidden fallback when user clears the date range
    // -----------------------------------------------------------------------

    test('clearFrom=true sends null from — no hidden 24h fallback', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(clearFrom: true);
      await ctrl.loadVehicleLogs();

      expect(svc.vehicleCalls.first['from'], isNull,
          reason: 'clearing From must omit from entirely');
    });

    test('clearFrom + clearTo both null after clear', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.setVehicleFilters(
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );
      ctrl.setVehicleFilters(clearFrom: true, clearTo: true);

      expect(ctrl.state.vehicleFrom, isNull);
      expect(ctrl.state.vehicleTo, isNull);
    });

    // -----------------------------------------------------------------------
    // Vehicle / user filter — clear semantics
    // -----------------------------------------------------------------------

    test('clearVehicleId=true clears a previously set vehicleId', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(vehicleId: '77');
      expect(ctrl.state.vehicleVehicleId, '77');

      ctrl.setVehicleFilters(clearVehicleId: true);
      expect(ctrl.state.vehicleVehicleId, isNull,
          reason: 'clearVehicleId must nullify vehicleVehicleId');

      await ctrl.loadVehicleLogs();
      expect(svc.vehicleCalls.first['vehicleId'], isNull);
    });

    test('clearUserId=true clears a previously set userId', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(userId: '55');
      expect(ctrl.state.vehicleUserId, '55');

      ctrl.setVehicleFilters(clearUserId: true);
      expect(ctrl.state.vehicleUserId, isNull,
          reason: 'clearUserId must nullify vehicleUserId');

      await ctrl.loadVehicleLogs();
      expect(svc.vehicleCalls.first['userId'], isNull);
    });

    test('vehicleId=null without clearVehicleId preserves existing id', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.setVehicleFilters(vehicleId: '3');
      ctrl.setVehicleFilters(search: 'test');

      expect(ctrl.state.vehicleVehicleId, '3');
    });

    test('userId=null without clearUserId preserves existing id', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.setVehicleFilters(userId: '9');
      ctrl.setVehicleFilters(severity: 'INFO');

      expect(ctrl.state.vehicleUserId, '9');
    });

    // -----------------------------------------------------------------------
    // All filters forwarded correctly
    // -----------------------------------------------------------------------

    test('source, severity, search, dedupe, isRead all forwarded', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(
        source: 'GEOFENCE',
        severity: 'CRITICAL',
        search: 'brake',
        dedupe: false,
        readFilter: AdminReadFilter.unread,
      );
      await ctrl.loadVehicleLogs();

      final call = svc.vehicleCalls.first;
      expect(call['source'], 'GEOFENCE');
      expect(call['severity'], 'CRITICAL');
      expect(call['q'], 'brake');
      expect(call['dedupe'], false);
      expect(call['isRead'], false,
          reason: 'Unread filter must map to isRead=false');
    });

    test('AdminReadFilter.all sends null isRead', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(readFilter: AdminReadFilter.all);
      await ctrl.loadVehicleLogs();

      expect(svc.vehicleCalls.first['isRead'], isNull);
    });

    test('AdminReadFilter.read sends isRead=true', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(readFilter: AdminReadFilter.read);
      await ctrl.loadVehicleLogs();

      expect(svc.vehicleCalls.first['isRead'], true);
    });

    // -----------------------------------------------------------------------
    // Date range forwarded as ISO 8601 with time
    // -----------------------------------------------------------------------

    test('from/to are sent as ISO 8601 with time component', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      final from = DateTime.utc(2026, 7, 1, 6, 0, 0);
      final to = DateTime.utc(2026, 7, 31, 23, 59, 59);
      ctrl.setVehicleFilters(from: from, to: to);
      await ctrl.loadVehicleLogs();

      final call = svc.vehicleCalls.first;
      expect(call['from'], contains('T'));
      expect(call['from'], contains('06:00'));
      expect(call['to'], contains('T'));
      expect(call['to'], contains('23:59'));
    });

    // -----------------------------------------------------------------------
    // setVehicleFilters resets pagination
    // -----------------------------------------------------------------------

    test('setVehicleFilters clears logs and cursor', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.state = ctrl.state.copyWith(
        vehicleLogs: [
          AdminVehicleEventLogItem.fromJson(<String, dynamic>{
            'id': 1,
            'title': 'old',
          }),
        ],
        vehicleNextCursorId: 'old-cursor',
      );

      ctrl.setVehicleFilters(search: 'new');

      expect(ctrl.state.vehicleLogs, isEmpty);
      expect(ctrl.state.vehicleNextCursorId, isNull);
    });

    // -----------------------------------------------------------------------
    // Load More preserves all active filters
    // -----------------------------------------------------------------------

    test('loadMoreVehicleLogs carries all filters including from/to', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      final from = DateTime.utc(2026, 6, 1);
      final to = DateTime.utc(2026, 6, 30, 23, 59, 59);
      ctrl.setVehicleFilters(
        vehicleId: '10',
        source: 'IGNITION',
        severity: 'WARNING',
        from: from,
        to: to,
        dedupe: false,
      );
      await ctrl.loadVehicleLogs();

      // Simulate first page with more
      ctrl.state = ctrl.state.copyWith(
        vehicleNextCursorId: '99',
        isLoadingVehicle: false,
        isLoadingMoreVehicle: false,
      );

      await ctrl.loadMoreVehicleLogs();

      expect(svc.vehicleCalls, hasLength(2));
      final moreCall = svc.vehicleCalls[1];
      expect(moreCall['cursorId'], '99');
      expect(moreCall['vehicleId'], '10');
      expect(moreCall['source'], 'IGNITION');
      expect(moreCall['severity'], 'WARNING');
      expect(moreCall['from'], contains('T'));
      expect(moreCall['to'], contains('T'));
      expect(moreCall['dedupe'], false);
    });

    // -----------------------------------------------------------------------
    // Full reset sends null vehicleId, userId, no from
    // -----------------------------------------------------------------------

    test('clearing all vehicle filters sends null vehicleId/userId/from/to',
        () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.vehicleCalls.clear();

      ctrl.setVehicleFilters(
        vehicleId: '5',
        userId: '6',
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );

      ctrl.setVehicleFilters(
        clearVehicleId: true,
        clearUserId: true,
        clearFrom: true,
        clearTo: true,
      );
      await ctrl.loadVehicleLogs();

      final call = svc.vehicleCalls.first;
      expect(call['vehicleId'], isNull);
      expect(call['userId'], isNull);
      expect(call['from'], isNull);
      expect(call['to'], isNull);
    });

    // -----------------------------------------------------------------------
    // Error handling
    // -----------------------------------------------------------------------

    test('service error sets sectionErrorMessage and clears isLoadingVehicle',
        () async {
      final svc = _FakeService()..throwError = ArgumentError('backend error');
      final ctrl = _build(svc);

      await ctrl.loadVehicleLogs();

      expect(ctrl.state.isLoadingVehicle, isFalse);
      expect(ctrl.state.sectionErrorMessage, isNotNull);
    });
  });
}
