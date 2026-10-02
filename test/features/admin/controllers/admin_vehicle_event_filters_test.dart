import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_vehicle_details_controller.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_state.dart';
import 'package:open_vts/features/admin/services/admin_vehicle_service.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';

// ---------------------------------------------------------------------------
// Fake service that records getVehicleEventsByImei calls
// ---------------------------------------------------------------------------

class _FakeService extends Fake implements AdminVehicleService {
  final List<Map<String, dynamic>> calls = [];
  List<AdminVehicleEventItem> nextItems = const [];
  String? nextCursor;
  Object? throwError;

  @override
  Future<AdminVehicleEventPage> getVehicleEventsByImei({
    required String imei,
    int limit = 50,
    String? beforeId,
    DateTime? from,
    DateTime? to,
    String? source,
    String? severity,
  }) async {
    if (throwError != null) throw throwError!;
    calls.add({
      'imei': imei,
      'beforeId': beforeId,
      'from': from,
      'to': to,
      'source': source,
      'severity': severity,
    });
    return SuperadminVehicleEventPage(
      items: nextItems,
      nextCursor: nextCursor,
    );
  }
}

// ---------------------------------------------------------------------------
// Helper — build a controller with a vehicle already in state
// ---------------------------------------------------------------------------

AdminVehicleDetailsController _buildController(_FakeService svc) {
  final ctrl = AdminVehicleDetailsController(
    vehicleId: '1',
    service: svc,
  );
  ctrl.state = ctrl.state.copyWith(
    vehicle: AdminVehicleDetails.fromJson(<String, dynamic>{
      'id': '1',
      'imei': '123456789012345',
      'name': 'Test Vehicle',
      'plateNumber': 'TEST-01',
    }),
  );
  return ctrl;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminVehicleDetailsController — event filters', () {
    // -----------------------------------------------------------------------
    // No default date range
    // -----------------------------------------------------------------------

    test('loadEvents sends no from/to when no filters are applied', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      await ctrl.loadEvents();

      expect(svc.calls, hasLength(1));
      expect(svc.calls.first['from'], isNull,
          reason: 'from must not be sent without an explicit filter');
      expect(svc.calls.first['to'], isNull,
          reason: 'to must not be sent without an explicit filter');
    });

    // -----------------------------------------------------------------------
    // Source enum values
    // -----------------------------------------------------------------------

    for (final source in [
      'SYSTEM',
      'GEOFENCE',
      'ROUTE',
      'MOTION',
      'OVERSPEED',
      'IGNITION',
      'REMINDER',
      'SENSOR',
      'DRIVER',
      'COMMAND',
    ]) {
      test('source=$source is forwarded verbatim', () async {
        final svc = _FakeService();
        final ctrl = _buildController(svc);

        await ctrl.applyEventFilters(source: source);

        expect(svc.calls.last['source'], source);
      });
    }

    // -----------------------------------------------------------------------
    // Severity enum values
    // -----------------------------------------------------------------------

    for (final severity in ['INFO', 'WARNING', 'CRITICAL']) {
      test('severity=$severity is forwarded verbatim', () async {
        final svc = _FakeService();
        final ctrl = _buildController(svc);

        await ctrl.applyEventFilters(severity: severity);

        expect(svc.calls.last['severity'], severity);
      });
    }

    // -----------------------------------------------------------------------
    // Combined source + severity
    // -----------------------------------------------------------------------

    test('source and severity are both forwarded when combined', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      await ctrl.applyEventFilters(source: 'GEOFENCE', severity: 'WARNING');

      expect(svc.calls.last['source'], 'GEOFENCE');
      expect(svc.calls.last['severity'], 'WARNING');
    });

    // -----------------------------------------------------------------------
    // Inclusive date range
    // -----------------------------------------------------------------------

    test('apply preserves from and to in filter state', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      final from = DateTime(2026, 7, 1);
      final to = DateTime(2026, 7, 31, 23, 59, 59, 999);

      await ctrl.applyEventFilters(from: from, to: to);

      expect(ctrl.state.eventFilters.from, from);
      expect(ctrl.state.eventFilters.to, to);
      expect(svc.calls.last['from'], from);
      expect(svc.calls.last['to'], to);
    });

    // -----------------------------------------------------------------------
    // Filter state persistence
    // -----------------------------------------------------------------------

    test('applyEventFilters stores filters in state', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      await ctrl.applyEventFilters(source: 'ROUTE', severity: 'CRITICAL');

      expect(ctrl.state.eventFilters.source, 'ROUTE');
      expect(ctrl.state.eventFilters.severity, 'CRITICAL');
    });

    test('applyEventFilters clears previous events and cursor before loading',
        () async {
      final svc = _FakeService()
        ..nextItems = const []
        ..nextCursor = null;
      final ctrl = _buildController(svc);

      ctrl.state = ctrl.state.copyWith(
        events: [
          AdminVehicleEventItem.fromJson(<String, dynamic>{
            'id': 99,
            'title': 'old event',
            'message': 'old',
          }),
        ],
        eventNextCursor: 'old-cursor',
      );

      await ctrl.applyEventFilters(source: 'SYSTEM');

      expect(ctrl.state.events, isEmpty);
      expect(ctrl.state.eventNextCursor, isNull);
    });

    // -----------------------------------------------------------------------
    // Load-more retains filters
    // -----------------------------------------------------------------------

    test('loadMoreEvents carries source, severity, from, to, and beforeId',
        () async {
      final svc = _FakeService()..nextCursor = null;
      final ctrl = _buildController(svc);

      final from = DateTime(2026, 6, 1);
      final to = DateTime(2026, 6, 30, 23, 59, 59, 999);
      await ctrl.applyEventFilters(
          source: 'IGNITION', severity: 'INFO', from: from, to: to);

      ctrl.state = ctrl.state.copyWith(
        eventNextCursor: 'cursor-42',
        isLoadingMoreEvents: false,
      );

      await ctrl.loadMoreEvents();

      expect(svc.calls, hasLength(2));
      final moreCall = svc.calls[1];
      expect(moreCall['beforeId'], 'cursor-42');
      expect(moreCall['source'], 'IGNITION');
      expect(moreCall['severity'], 'INFO');
      expect(moreCall['from'], from);
      expect(moreCall['to'], to);
    });

    // -----------------------------------------------------------------------
    // Clear resets filters and cursor
    // -----------------------------------------------------------------------

    test('clearEventFilters resets all filter fields and reloads unfiltered',
        () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      await ctrl.applyEventFilters(
        source: 'SENSOR',
        severity: 'CRITICAL',
        from: DateTime(2026, 1, 1),
        to: DateTime(2026, 12, 31),
      );

      await ctrl.clearEventFilters();

      expect(ctrl.state.eventFilters.source, isNull);
      expect(ctrl.state.eventFilters.severity, isNull);
      expect(ctrl.state.eventFilters.from, isNull);
      expect(ctrl.state.eventFilters.to, isNull);
      expect(ctrl.state.eventNextCursor, isNull);

      // Last service call must have no filters
      final clearCall = svc.calls.last;
      expect(clearCall['source'], isNull);
      expect(clearCall['severity'], isNull);
      expect(clearCall['from'], isNull);
      expect(clearCall['to'], isNull);
    });

    // -----------------------------------------------------------------------
    // Filtered request failure — stale results are cleared
    // -----------------------------------------------------------------------

    test('failed applyEventFilters clears events and sets sectionErrorMessage',
        () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.state = ctrl.state.copyWith(
        events: [
          AdminVehicleEventItem.fromJson(<String, dynamic>{
            'id': 1,
            'title': 'stale event',
            'message': 'stale',
          }),
        ],
      );

      svc.throwError = Exception('Server error');
      await ctrl.applyEventFilters(source: 'COMMAND');

      expect(ctrl.state.events, isEmpty,
          reason: 'stale events must be cleared on filter failure');
      expect(ctrl.state.sectionErrorMessage, isNotNull);
      expect(ctrl.state.isLoadingEvents, isFalse);
    });

    // -----------------------------------------------------------------------
    // Duplicate Apply protection
    // -----------------------------------------------------------------------

    test('applyEventFilters is a no-op while isLoadingEvents is true',
        () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.state = ctrl.state.copyWith(isLoadingEvents: true);

      await ctrl.applyEventFilters(source: 'DRIVER');

      expect(svc.calls, isEmpty,
          reason: 'must not issue a request while already loading');
    });
  });

  // -------------------------------------------------------------------------
  // AdminVehicleEventFilters unit tests
  // -------------------------------------------------------------------------

  group('AdminVehicleEventFilters', () {
    test('empty() has all null fields', () {
      const f = AdminVehicleEventFilters.empty();
      expect(f.from, isNull);
      expect(f.to, isNull);
      expect(f.source, isNull);
      expect(f.severity, isNull);
      expect(f.isEmpty, isTrue);
    });

    test('non-empty filter reports isEmpty as false', () {
      const f = AdminVehicleEventFilters(source: 'SYSTEM');
      expect(f.isEmpty, isFalse);
    });

    test('copyWith preserves unspecified fields', () {
      const f = AdminVehicleEventFilters(source: 'ROUTE', severity: 'WARNING');
      final updated = f.copyWith(severity: 'CRITICAL');
      expect(updated.source, 'ROUTE');
      expect(updated.severity, 'CRITICAL');
    });

    test('copyWith can null out a field', () {
      const f = AdminVehicleEventFilters(source: 'MOTION');
      final cleared = f.copyWith(source: null);
      expect(cleared.source, isNull);
    });
  });
}
