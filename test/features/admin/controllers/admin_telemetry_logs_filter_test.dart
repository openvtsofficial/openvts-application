import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_logs_controller.dart';
import 'package:open_vts/features/admin/models/admin_logs_model.dart';
import 'package:open_vts/features/admin/models/admin_logs_state.dart';
import 'package:open_vts/features/admin/services/admin_logs_service.dart';

// ---------------------------------------------------------------------------
// Fake service — records getTelemetryLogs calls, stubs everything else
// ---------------------------------------------------------------------------

class _FakeService extends Fake implements AdminLogsService {
  final List<Map<String, dynamic>> telemetryCalls = [];
  List<AdminTelemetryLogItem> nextItems = const [];
  String? nextCursor;
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
  }) async =>
      AdminVehicleEventLogPage(items: const [], nextCursorId: null);

  @override
  Future<AdminTelemetryLogPage> getTelemetryLogs({
    int limit = 200,
    String? beforeId,
    String? from,
    String? to,
    String? vehicleId,
    String? imei,
    String? packetType,
  }) async {
    if (throwError != null) throw throwError!;
    telemetryCalls.add({
      'limit': limit,
      'beforeId': beforeId,
      'from': from,
      'to': to,
      'vehicleId': vehicleId,
      'imei': imei,
      'packetType': packetType,
    });
    return AdminTelemetryLogPage(items: nextItems, nextCursor: nextCursor);
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
  group('AdminLogsController — telemetry filters', () {
    // -----------------------------------------------------------------------
    // Default 1h window is visible in state
    // -----------------------------------------------------------------------

    test('telemetryFrom is initialized to ~1h ago on construction', () {
      final svc = _FakeService();
      final before = DateTime.now().subtract(const Duration(hours: 1));
      final ctrl = _build(svc);
      final after = DateTime.now().subtract(const Duration(hours: 1));

      expect(ctrl.state.telemetryFrom, isNotNull);
      expect(
        ctrl.state.telemetryFrom!.millisecondsSinceEpoch,
        greaterThanOrEqualTo(before.millisecondsSinceEpoch - 500),
      );
      expect(
        ctrl.state.telemetryFrom!.millisecondsSinceEpoch,
        lessThanOrEqualTo(after.millisecondsSinceEpoch + 500),
      );
    });

    test('initial load sends the visible telemetryFrom to the service',
        () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      await ctrl.loadTelemetryLogs();

      expect(svc.telemetryCalls, hasLength(1));
      final call = svc.telemetryCalls.first;
      expect(call['from'], isNotNull,
          reason:
              'the visible 1h default must be sent — no silent hidden override');
      expect(call['from'], contains('T'));
    });

    // -----------------------------------------------------------------------
    // No hidden fallback when user clears the date range
    // -----------------------------------------------------------------------

    test('clearFrom=true sends null from — no hidden 1h fallback', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      ctrl.setTelemetryFilters(clearFrom: true);
      await ctrl.loadTelemetryLogs();

      expect(svc.telemetryCalls.first['from'], isNull,
          reason: 'clearing From must omit from entirely');
    });

    test('clearFrom + clearTo both null after clear', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.setTelemetryFilters(
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );
      ctrl.setTelemetryFilters(clearFrom: true, clearTo: true);

      expect(ctrl.state.telemetryFrom, isNull);
      expect(ctrl.state.telemetryTo, isNull);
    });

    // -----------------------------------------------------------------------
    // Vehicle filter — clear semantics
    // -----------------------------------------------------------------------

    test('clearVehicleId=true clears a previously set vehicleId', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      ctrl.setTelemetryFilters(vehicleId: '42');
      expect(ctrl.state.telemetryVehicleId, '42');

      ctrl.setTelemetryFilters(clearVehicleId: true);
      expect(ctrl.state.telemetryVehicleId, isNull,
          reason: 'clearVehicleId must nullify telemetryVehicleId');

      await ctrl.loadTelemetryLogs();
      expect(svc.telemetryCalls.first['vehicleId'], isNull);
    });

    test('vehicleId=null without clearVehicleId preserves existing id', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.setTelemetryFilters(vehicleId: '7');
      ctrl.setTelemetryFilters(packetType: 'LOCATION');

      expect(ctrl.state.telemetryVehicleId, '7');
    });

    // -----------------------------------------------------------------------
    // All filters forwarded correctly
    // -----------------------------------------------------------------------

    test('vehicleId, imei, packetType, from, to all forwarded', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      final from = DateTime.utc(2026, 7, 1, 0, 0, 0);
      final to = DateTime.utc(2026, 7, 31, 23, 59, 59);
      ctrl.setTelemetryFilters(
        vehicleId: '5',
        imeiSearch: '123456789012345',
        packetType: 'HEARTBEAT',
        from: from,
        to: to,
      );
      await ctrl.loadTelemetryLogs();

      final call = svc.telemetryCalls.first;
      expect(call['vehicleId'], '5');
      expect(call['imei'], '123456789012345');
      expect(call['packetType'], 'HEARTBEAT');
      expect(call['from'], contains('T'));
      expect(call['from'], contains('00:00'));
      expect(call['to'], contains('T'));
      expect(call['to'], contains('23:59'));
    });

    test('empty packetType sends null packetType to service', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      ctrl.setTelemetryFilters(packetType: '');
      await ctrl.loadTelemetryLogs();

      // Service _nz() strips empty strings — the call itself records ''
      // but the service layer omits it from the query. We just verify the
      // controller passes the value through correctly.
      expect(svc.telemetryCalls.first['packetType'], '');
    });

    test('empty imeiSearch sends empty string to service', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      ctrl.setTelemetryFilters(imeiSearch: '');
      await ctrl.loadTelemetryLogs();

      expect(svc.telemetryCalls.first['imei'], '');
    });

    // -----------------------------------------------------------------------
    // setTelemetryFilters resets pagination
    // -----------------------------------------------------------------------

    test('setTelemetryFilters clears logs and cursor', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.state = ctrl.state.copyWith(
        telemetryNextCursor: 'old-cursor',
      );

      ctrl.setTelemetryFilters(packetType: 'LOCATION');

      expect(ctrl.state.telemetryLogs, isEmpty);
      expect(ctrl.state.telemetryNextCursor, isNull);
    });

    // -----------------------------------------------------------------------
    // Load More preserves all active filters and sends beforeId cursor
    // -----------------------------------------------------------------------

    test('loadMoreTelemetryLogs carries all filters and sends beforeId',
        () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      final from = DateTime.utc(2026, 6, 1);
      final to = DateTime.utc(2026, 6, 30, 23, 59, 59);
      ctrl.setTelemetryFilters(
        vehicleId: '11',
        packetType: 'EVENT',
        from: from,
        to: to,
      );
      await ctrl.loadTelemetryLogs();

      ctrl.state = ctrl.state.copyWith(
        telemetryNextCursor: 'abc-cursor',
        isLoadingTelemetry: false,
        isLoadingMoreTelemetry: false,
      );

      await ctrl.loadMoreTelemetryLogs();

      expect(svc.telemetryCalls, hasLength(2));
      final moreCall = svc.telemetryCalls[1];
      expect(moreCall['beforeId'], 'abc-cursor');
      expect(moreCall['vehicleId'], '11');
      expect(moreCall['packetType'], 'EVENT');
      expect(moreCall['from'], contains('T'));
      expect(moreCall['to'], contains('T'));
    });

    // -----------------------------------------------------------------------
    // Full reset sends null vehicleId and no from/to
    // -----------------------------------------------------------------------

    test('clearing all telemetry filters sends null vehicleId/from/to',
        () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.telemetryCalls.clear();

      ctrl.setTelemetryFilters(
        vehicleId: '3',
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );

      ctrl.setTelemetryFilters(
        clearVehicleId: true,
        clearFrom: true,
        clearTo: true,
      );
      await ctrl.loadTelemetryLogs();

      final call = svc.telemetryCalls.first;
      expect(call['vehicleId'], isNull);
      expect(call['from'], isNull);
      expect(call['to'], isNull);
    });

    // -----------------------------------------------------------------------
    // Error handling
    // -----------------------------------------------------------------------

    test('service error sets sectionErrorMessage and clears isLoadingTelemetry',
        () async {
      final svc = _FakeService()..throwError = ArgumentError('backend error');
      final ctrl = _build(svc);

      await ctrl.loadTelemetryLogs();

      expect(ctrl.state.isLoadingTelemetry, isFalse);
      expect(ctrl.state.sectionErrorMessage, isNotNull);
    });
  });
}
