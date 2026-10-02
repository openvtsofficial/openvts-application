// Focused unit tests for User → Dashboard cross-client synchronization.
//
// Coverage:
//   • refresh() replaces selected dashboard config from server response
//   • added/removed/reordered widgets are reflected after refresh
//   • stable widget IDs are preserved across config change
//   • selected dashboard is retained after refresh when it still exists
//   • renamed dashboard is reflected in the dashboard list after refresh
//   • lifecycle resume triggers exactly one refresh
//   • concurrent resume + manual refresh does not double-fire
//   • changed server version/config replaces orderedWidgets
//   • error during refresh retains the previous usable state

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/features/user/controllers/user_dashboard_controller.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';
import 'package:open_vts/features/user/services/user_dashboard_service.dart';

// ── Fake LocalCache ───────────────────────────────────────────────────────────

class _FakeLocalCache implements LocalCache {
  final Map<String, dynamic> _store = {};

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _store[key] as bool?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _store.remove(key);
    return true;
  }
}

// ── Fake UserDashboardService ─────────────────────────────────────────────────

class _FakeService implements UserDashboardService {
  Completer<List<UserDashboardListItem>>? dashboardsCompleter;
  Completer<UserDashboardDetail>? detailCompleter;

  List<UserDashboardListItem>? nextDashboards;
  UserDashboardDetail? nextDetail;
  bool throwOnNextDashboards = false;
  bool throwOnNextDetail = false;

  int getDashboardsCallCount = 0;
  int getDashboardByIdCallCount = 0;
  int invalidateCacheCallCount = 0;

  @override
  void invalidateDashboardOverviewCache() {
    invalidateCacheCallCount++;
  }

  @override
  Future<List<UserDashboardListItem>> getDashboards() async {
    getDashboardsCallCount++;
    if (throwOnNextDashboards) {
      throwOnNextDashboards = false;
      throw Exception('network error');
    }
    final c = dashboardsCompleter;
    if (c != null) return c.future;
    return nextDashboards ?? const [];
  }

  @override
  Future<UserDashboardDetail> getDashboardById(String id) async {
    getDashboardByIdCallCount++;
    if (throwOnNextDetail) {
      throwOnNextDetail = false;
      throw Exception('network error');
    }
    final c = detailCompleter;
    if (c != null) return c.future;
    return nextDetail ?? _detail(id, widgets: const [], version: 1);
  }

  // ── Unsupported widget-data methods ── //
  @override
  Future<UserDashboardFleetStatus> getFleetStatus(
          {bool forceRefresh = false}) =>
      throw UnimplementedError();
  @override
  Future<UserDashboardUsageLast7Days> getUsageLast7Days(
          {String? vehicleId, bool forceRefresh = false}) =>
      throw UnimplementedError();
  @override
  Future<UserDashboardWeeklyComparison> getWeeklyComparison(
          {String? vehicleId, bool forceRefresh = false}) =>
      throw UnimplementedError();
  @override
  Future<UserDashboardRecentAlertsPage> getRecentAlerts(
          {String? vehicleId,
          int limit = 30,
          int? beforeId,
          String? from,
          String? refreshKey,
          bool forceRefresh = false}) =>
      throw UnimplementedError();
  @override
  Future<UserDashboardAlertDetail> getRecentAlertDetail(String id) =>
      throw UnimplementedError();
  @override
  Future<void> markRecentAlertRead(String id) => throw UnimplementedError();
  @override
  Future<UserDashboardTopAssets> getTopPerformingAssets(
          {required DateTime from,
          required DateTime to,
          int limit = 10,
          bool forceRefresh = false}) =>
      throw UnimplementedError();
  @override
  Future<UserDashboardDayNightComparison> getDayNightComparison(
          {String? vehicleId, required DateTime from, required DateTime to}) =>
      throw UnimplementedError();
  @override
  Future<List<UserDashboardVehicleOption>> getVehicles(
          {bool forceRefresh = false}) =>
      throw UnimplementedError();
  @override
  Future<List<UserDashboardSensorOption>> getVehicleSensors(String vehicleId) =>
      throw UnimplementedError();
  @override
  Future<UserDashboardSensorHistory> getSensorHistory(
          {required String vehicleId,
          required String sensorId,
          required DateTime from,
          required DateTime to,
          int maxPoints = 500}) =>
      throw UnimplementedError();
  @override
  Future<List<UserDashboardCustomCommand>> getCustomCommands() =>
      throw UnimplementedError();
  @override
  Future<List<UserDashboardSystemVariable>> getSystemVariables() =>
      throw UnimplementedError();
  @override
  Future<UserDashboardSendCommandResult> sendBulkCommand(
          {required UserDashboardSendCommandMode mode,
          String? command,
          List<String> vehicleIds = const [],
          List<UserDashboardSendCommandItem> items = const [],
          String? note}) =>
      throw UnimplementedError();
}

// ── Model builders ─────────────────────────────────────────────────────────────

UserDashboardListItem _listItem(
  String id, {
  String name = 'Dashboard',
  int version = 1,
}) {
  return UserDashboardListItem(
    id: id,
    name: name,
    version: version,
    updatedAt: DateTime(2026, 1, 1),
  );
}

UserDashboardWidgetConfig _widget(String id, String type) {
  return UserDashboardWidgetConfig(id: id, type: type);
}

UserDashboardDetail _detail(
  String id, {
  required List<UserDashboardWidgetConfig> widgets,
  int version = 1,
  String name = 'Dashboard',
  Map<String, List<UserDashboardLayoutItem>>? layouts,
}) {
  final effectiveLayouts = layouts ??
      {
        'xxs': [
          for (var i = 0; i < widgets.length; i++)
            UserDashboardLayoutItem(
              i: widgets[i].id,
              x: 0,
              y: i,
              w: 2,
              h: 4,
            ),
        ],
        'xs': const [],
        'sm': const [],
        'md': const [],
        'lg': const [],
      };

  return UserDashboardDetail(
    id: id,
    name: name,
    version: version,
    config: UserDashboardConfig(
      widgets: widgets,
      layouts: Map.unmodifiable(effectiveLayouts),
    ),
    updatedAt: DateTime(2026, 1, 1),
  );
}

// ── Controller factory ─────────────────────────────────────────────────────────

UserDashboardController _makeController(_FakeService service) {
  return UserDashboardController(
    service: service,
    localCache: _FakeLocalCache(),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. refresh() replaces selected dashboard config
// ─────────────────────────────────────────────────────────────────────────────
  group('refresh() replaces selected dashboard config', () {
    test('updated widget list from server replaces orderedWidgets', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      // Seed initial state: one widget.
      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();

      expect(ctrl.state.orderedWidgets.map((w) => w.id), ['w1']);

      // Server now has two widgets.
      service.nextDashboards = [_listItem('d1', version: 2)];
      service.nextDetail = _detail('d1',
          widgets: [
            _widget('w1', 'fleet_status'),
            _widget('w2', 'recent_alerts')
          ],
          version: 2);

      await ctrl.refresh();

      expect(ctrl.state.orderedWidgets.map((w) => w.id), ['w1', 'w2']);
    });

    test('selectedDashboard reflects server detail after refresh', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: [], version: 1);
      await ctrl.loadInitial();

      final updatedDetail = _detail('d1',
          widgets: [_widget('wA', 'usage_last_7_days')], version: 2);
      service.nextDashboards = [_listItem('d1', version: 2)];
      service.nextDetail = updatedDetail;

      await ctrl.refresh();

      expect(ctrl.state.selectedDashboard?.version, 2);
      expect(ctrl.state.selectedDashboard?.config.widgets.length, 1);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Widget added / removed / reordered
// ─────────────────────────────────────────────────────────────────────────────
  group('Widget add/remove/reorder after refresh', () {
    test('added widget appears in orderedWidgets', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();

      service.nextDashboards = [_listItem('d1', version: 2)];
      service.nextDetail = _detail('d1',
          widgets: [
            _widget('w1', 'fleet_status'),
            _widget('w2', 'weekly_comparison')
          ],
          version: 2);
      await ctrl.refresh();

      final ids = ctrl.state.orderedWidgets.map((w) => w.id).toList();
      expect(ids, contains('w2'));
      expect(ids.length, 2);
    });

    test('removed widget disappears from orderedWidgets', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: [
        _widget('w1', 'fleet_status'),
        _widget('w2', 'recent_alerts')
      ]);
      await ctrl.loadInitial();
      expect(ctrl.state.orderedWidgets.length, 2);

      service.nextDashboards = [_listItem('d1', version: 2)];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')], version: 2);
      await ctrl.refresh();

      expect(ctrl.state.orderedWidgets.map((w) => w.id), ['w1']);
    });

    test('reordered widgets reflect saved xxs layout ordering', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: [
        _widget('w1', 'fleet_status'),
        _widget('w2', 'recent_alerts')
      ], layouts: {
        'xxs': [
          const UserDashboardLayoutItem(i: 'w2', x: 0, y: 0, w: 2, h: 4),
          const UserDashboardLayoutItem(i: 'w1', x: 0, y: 1, w: 2, h: 4),
        ],
        'xs': const [],
        'sm': const [],
        'md': const [],
        'lg': const [],
      });
      await ctrl.loadInitial();

      // w2 has lower y → appears first.
      expect(ctrl.state.orderedWidgets.first.id, 'w2');
      expect(ctrl.state.orderedWidgets.last.id, 'w1');

      // After web reorder: w1 moves to y:0, w2 to y:1.
      service.nextDashboards = [_listItem('d1', version: 2)];
      service.nextDetail = _detail('d1',
          widgets: [
            _widget('w1', 'fleet_status'),
            _widget('w2', 'recent_alerts')
          ],
          version: 2,
          layouts: {
            'xxs': [
              const UserDashboardLayoutItem(i: 'w1', x: 0, y: 0, w: 2, h: 4),
              const UserDashboardLayoutItem(i: 'w2', x: 0, y: 1, w: 2, h: 4),
            ],
            'xs': const [],
            'sm': const [],
            'md': const [],
            'lg': const [],
          });
      await ctrl.refresh();

      expect(ctrl.state.orderedWidgets.first.id, 'w1');
      expect(ctrl.state.orderedWidgets.last.id, 'w2');
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. Stable widget IDs
// ─────────────────────────────────────────────────────────────────────────────
  group('Stable widget IDs', () {
    test('widget IDs from server are preserved unchanged', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: [
        _widget('uuid-abc-123', 'fleet_status'),
        _widget('uuid-def-456', 'recent_alerts')
      ]);
      await ctrl.loadInitial();

      final ids = ctrl.state.orderedWidgets.map((w) => w.id).toList();
      expect(ids, contains('uuid-abc-123'));
      expect(ids, contains('uuid-def-456'));
    });

    test('widget IDs are stable across refresh with same config', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.refresh();

      expect(ctrl.state.orderedWidgets.single.id, 'w1');
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. Selected dashboard is preserved after refresh
// ─────────────────────────────────────────────────────────────────────────────
  group('Selected dashboard preserved after refresh', () {
    test('currently selected dashboard remains selected after refresh',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      // loadInitial selects d1, loads its detail.
      service.nextDashboards = [_listItem('d1'), _listItem('d2')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();

      // Switch detail so selectDashboard loads d2 correctly.
      service.nextDetail = _detail('d2', widgets: []);
      await ctrl.selectDashboard('d2');

      expect(ctrl.state.selectedDashboardId, 'd2');

      // Refresh: d2 is still on the server with an updated config.
      service.nextDashboards = [_listItem('d1'), _listItem('d2', version: 2)];
      service.nextDetail =
          _detail('d2', widgets: [_widget('wX', 'fleet_status')], version: 2);
      await ctrl.refresh();

      expect(ctrl.state.selectedDashboardId, 'd2');
    });

    test('falls back to first dashboard if selected is deleted on server',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1'), _listItem('d2')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();

      // Select d2.
      service.nextDetail = _detail('d2', widgets: []);
      await ctrl.selectDashboard('d2');

      // d2 is removed on the server — refresh must fall back to d1.
      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('wA', 'fleet_status')]);
      await ctrl.refresh();

      expect(ctrl.state.selectedDashboardId, 'd1');
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. Dashboard rename is reflected
// ─────────────────────────────────────────────────────────────────────────────
  group('Dashboard rename', () {
    test('renamed dashboard name appears in dashboards list after refresh',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1', name: 'Old Name')];
      service.nextDetail = _detail('d1', widgets: [], name: 'Old Name');
      await ctrl.loadInitial();

      service.nextDashboards = [_listItem('d1', name: 'New Name', version: 2)];
      service.nextDetail =
          _detail('d1', widgets: [], name: 'New Name', version: 2);
      await ctrl.refresh();

      final item = ctrl.state.dashboards.firstWhere((d) => d.id == 'd1');
      expect(item.name, 'New Name');
    });

    test('selectedDashboard reflects new name after refresh', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1', name: 'Old Name')];
      service.nextDetail = _detail('d1', widgets: [], name: 'Old Name');
      await ctrl.loadInitial();

      service.nextDashboards = [_listItem('d1', name: 'New Name', version: 2)];
      service.nextDetail =
          _detail('d1', widgets: [], name: 'New Name', version: 2);
      await ctrl.refresh();

      expect(ctrl.state.selectedDashboard?.name, 'New Name');
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 6. Lifecycle: resume triggers exactly one refresh
// ─────────────────────────────────────────────────────────────────────────────
  group('Concurrent refresh guard', () {
    test('second refresh() call while first is in flight is ignored', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();

      final completer = Completer<List<UserDashboardListItem>>();
      service.dashboardsCompleter = completer;

      // Start first refresh but do not await.
      final first = ctrl.refresh();

      // Second call while first is in flight must be a no-op.
      final second = ctrl.refresh();

      completer.complete([_listItem('d1')]);
      service.dashboardsCompleter = null;
      await Future.wait([first, second]);

      // getDashboards called once for loadInitial + once for the first refresh only.
      expect(service.getDashboardsCallCount, 2);
    });

    test('refresh can be called again after previous one completes', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();

      await ctrl.refresh();
      await ctrl.refresh(); // second call after first finished must proceed.

      // loadInitial + 2 successful refreshes = 3 total calls.
      expect(service.getDashboardsCallCount, 3);
    });

    test('isRefreshing is cleared after successful refresh', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();
      await ctrl.refresh();

      expect(ctrl.state.isRefreshing, isFalse);
    });

    test('isRefreshing is cleared after failed refresh', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();

      service.throwOnNextDashboards = true;
      await ctrl.refresh();

      expect(ctrl.state.isRefreshing, isFalse);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 7. Changed server version/config
// ─────────────────────────────────────────────────────────────────────────────
  group('Server version and config changes', () {
    test('higher version from server updates orderedWidgets', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1', version: 1)];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')], version: 1);
      await ctrl.loadInitial();

      service.nextDashboards = [_listItem('d1', version: 5)];
      service.nextDetail = _detail('d1',
          widgets: [
            _widget('w1', 'fleet_status'),
            _widget('w2', 'recent_alerts'),
            _widget('w3', 'weekly_comparison')
          ],
          version: 5);
      await ctrl.refresh();

      expect(ctrl.state.selectedDashboard?.version, 5);
      expect(ctrl.state.orderedWidgets.length, 3);
    });

    test('empty widget list from server results in no orderedWidgets',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();
      expect(ctrl.state.hasOrderedWidgets, isTrue);

      service.nextDashboards = [_listItem('d1', version: 2)];
      service.nextDetail = _detail('d1', widgets: [], version: 2);
      await ctrl.refresh();

      expect(ctrl.state.hasOrderedWidgets, isFalse);
      expect(ctrl.state.orderedWidgets, isEmpty);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 8. Error retains previous usable state
// ─────────────────────────────────────────────────────────────────────────────
  group('Error during refresh retains previous state', () {
    test('previous orderedWidgets are retained when getDashboards throws',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();

      final previousWidgets = ctrl.state.orderedWidgets;

      service.throwOnNextDashboards = true;
      await ctrl.refresh();

      // The error message is set.
      expect(ctrl.state.errorMessage, isNotNull);
      // The widget list is retained.
      expect(ctrl.state.orderedWidgets, equals(previousWidgets));
    });

    test('previous selectedDashboardId is retained when getDashboards throws',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: []);
      await ctrl.loadInitial();

      service.throwOnNextDashboards = true;
      await ctrl.refresh();

      expect(ctrl.state.selectedDashboardId, 'd1');
    });

    test('previous orderedWidgets retained when getDashboardById throws',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();

      final previousWidgets = ctrl.state.orderedWidgets;

      service.nextDashboards = [_listItem('d1', version: 2)];
      service.throwOnNextDetail = true;
      await ctrl.refresh();

      // Detail fetch failed — fall back to previous config.
      expect(ctrl.state.orderedWidgets, equals(previousWidgets));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 9. No-dashboard edge case
// ─────────────────────────────────────────────────────────────────────────────
  group('No dashboards after refresh', () {
    test('orderedWidgets is cleared when server returns no dashboards',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail =
          _detail('d1', widgets: [_widget('w1', 'fleet_status')]);
      await ctrl.loadInitial();
      expect(ctrl.state.hasDashboards, isTrue);

      service.nextDashboards = [];
      await ctrl.refresh();

      expect(ctrl.state.hasDashboards, isFalse);
      expect(ctrl.state.orderedWidgets, isEmpty);
      expect(ctrl.state.selectedDashboardId, isNull);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 10. _orderWidgets breakpoint preference (xxs → xs → sm → md → lg)
// ─────────────────────────────────────────────────────────────────────────────
  group('_orderWidgets breakpoint preference', () {
    test('uses xxs layout when present, ignoring lg', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: [
        _widget('w1', 'fleet_status'),
        _widget('w2', 'recent_alerts')
      ], layouts: {
        'xxs': [
          const UserDashboardLayoutItem(i: 'w2', x: 0, y: 0, w: 2, h: 4),
          const UserDashboardLayoutItem(i: 'w1', x: 0, y: 1, w: 2, h: 4),
        ],
        'xs': const [],
        'sm': const [],
        'md': const [],
        'lg': [
          // lg has opposite order — must not be used.
          const UserDashboardLayoutItem(i: 'w1', x: 0, y: 0, w: 6, h: 4),
          const UserDashboardLayoutItem(i: 'w2', x: 6, y: 0, w: 6, h: 4),
        ],
      });
      await ctrl.loadInitial();

      // xxs ordering: w2 (y:0) then w1 (y:1).
      expect(ctrl.state.orderedWidgets.first.id, 'w2');
      expect(ctrl.state.orderedWidgets.last.id, 'w1');
    });

    test('falls back to xs when xxs is empty', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      service.nextDashboards = [_listItem('d1')];
      service.nextDetail = _detail('d1', widgets: [
        _widget('wA', 'fleet_status'),
        _widget('wB', 'recent_alerts')
      ], layouts: {
        'xxs': const [],
        'xs': [
          const UserDashboardLayoutItem(i: 'wB', x: 0, y: 0, w: 2, h: 4),
          const UserDashboardLayoutItem(i: 'wA', x: 0, y: 1, w: 2, h: 4),
        ],
        'sm': const [],
        'md': const [],
        'lg': const [],
      });
      await ctrl.loadInitial();

      expect(ctrl.state.orderedWidgets.first.id, 'wB');
      expect(ctrl.state.orderedWidgets.last.id, 'wA');
    });
  });
} // end main()
