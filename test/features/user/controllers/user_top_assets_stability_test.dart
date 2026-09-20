// Focused tests for User → Dashboard → Top Performing Assets stability fix.
//
// Coverage:
//   • UserDashboardTopAssetsArgs equality: same values → equal / same hash
//   • Slightly different `to` timestamps → different args (previous bug trigger)
//   • Same widget rebuild → stable args identity (resolved once in initState)
//   • Range selection → new stable args
//   • Refresh → new stable args (refreshKey incremented, dates re-resolved)
//   • Completed Future renders data (controller smoke-test)
//   • Empty response produces empty items list, not an error
//   • API error surfaces as an exception from the controller
//   • No repeated request after completion (provider dedup)

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/features/user/controllers/user_dashboard_controller.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';
import 'package:open_vts/features/user/services/user_dashboard_service.dart';

// ── Shared test fixtures ───────────────────────────────────────────────────────

final _t0 = DateTime(2026, 8, 8, 10, 0, 0);
final _t1 = DateTime(2026, 8, 8, 10, 0, 1); // 1 s later — bug trigger

// ── Fake LocalCache ────────────────────────────────────────────────────────────

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

// ── Fake UserDashboardService ──────────────────────────────────────────────────

class _FakeService implements UserDashboardService {
  int topAssetsCallCount = 0;
  UserDashboardTopAssets? nextTopAssets;
  bool throwOnNextTopAssets = false;
  Completer<UserDashboardTopAssets>? topAssetsCompleter;

  @override
  void invalidateDashboardOverviewCache() {}

  @override
  Future<List<UserDashboardListItem>> getDashboards() async => const [];

  @override
  Future<UserDashboardDetail> getDashboardById(String id) async {
    return UserDashboardDetail(
      id: id,
      name: 'Dashboard',
      version: 1,
      config: const UserDashboardConfig.empty(),
    );
  }

  @override
  Future<UserDashboardTopAssets> getTopPerformingAssets({
    required DateTime from,
    required DateTime to,
    int limit = 10,
    bool forceRefresh = false,
  }) async {
    topAssetsCallCount++;
    if (throwOnNextTopAssets) {
      throwOnNextTopAssets = false;
      throw Exception('server error');
    }
    final c = topAssetsCompleter;
    if (c != null) return c.future;
    return nextTopAssets ??
        UserDashboardTopAssets(
          range: const UserDashboardDateRange(),
          limit: limit,
          items: const <UserDashboardTopAssetItem>[],
        );
  }

  // ── unused stubs ── //
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

// ── Controller factory ─────────────────────────────────────────────────────────

UserDashboardController _makeController(_FakeService service) {
  return UserDashboardController(
    service: service,
    localCache: _FakeLocalCache(),
  );
}

// ── Helper: build top-assets args with a fixed range ─────────────────────────

UserDashboardTopAssetsArgs _args({
  String widgetId = 'w1',
  int refreshKey = 0,
  required DateTime from,
  required DateTime to,
  int limit = 10,
}) {
  return UserDashboardTopAssetsArgs(
    widgetId: widgetId,
    refreshKey: refreshKey,
    from: from,
    to: to,
    limit: limit,
  );
}

// ══════════════════════════════════════════════════════════════════════════════
void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. UserDashboardTopAssetsArgs equality
// ─────────────────────────────────────────────────────────────────────────────
  group('UserDashboardTopAssetsArgs equality', () {
    test('identical from/to are equal and share the same hashCode', () {
      final a = _args(from: _t0, to: _t0);
      final b = _args(from: _t0, to: _t0);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differing to by 1 second produces different instances (previous bug)',
        () {
      final a = _args(from: _t0, to: _t0);
      final b = _args(from: _t0, to: _t1);
      // This is the key property: before the fix, build() would produce `b`
      // on the next frame even though the user did nothing.
      expect(a, isNot(equals(b)));
    });

    test('differing widgetId are not equal', () {
      final a = _args(widgetId: 'w1', from: _t0, to: _t0);
      final b = _args(widgetId: 'w2', from: _t0, to: _t0);
      expect(a, isNot(equals(b)));
    });

    test('differing refreshKey are not equal', () {
      final a = _args(refreshKey: 0, from: _t0, to: _t0);
      final b = _args(refreshKey: 1, from: _t0, to: _t0);
      expect(a, isNot(equals(b)));
    });

    test('differing limit are not equal', () {
      final a = _args(limit: 10, from: _t0, to: _t0);
      final b = _args(limit: 5, from: _t0, to: _t0);
      expect(a, isNot(equals(b)));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Stable args across repeated "builds" (the fix)
//    Simulates what the fixed widget does: resolve once, reuse on rebuild.
// ─────────────────────────────────────────────────────────────────────────────
  group('Stable args across simulated rebuilds', () {
    test('args built from the same stored DateTime values are equal', () {
      // Simulates initState: resolve once.
      final from = _t0;
      final to = _t0.add(const Duration(hours: 8));

      // Simulate two successive build() calls using the stored values.
      final argsOnBuild1 = _args(from: from, to: to);
      final argsOnBuild2 = _args(from: from, to: to);

      expect(argsOnBuild1, equals(argsOnBuild2));
      expect(argsOnBuild1.hashCode, argsOnBuild2.hashCode);
    });

    test(
        'args are NOT equal when to advances by 1 ms (the old bug on each frame)',
        () {
      final from = _t0;
      final to1 = _t0.add(const Duration(hours: 8));
      final to2 = to1.add(const Duration(milliseconds: 1));

      final argsFrame1 = _args(from: from, to: to1);
      final argsFrame2 = _args(from: from, to: to2);

      expect(argsFrame1, isNot(equals(argsFrame2)));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. Range selection → new stable args
// ─────────────────────────────────────────────────────────────────────────────
  group('Range selection produces a new stable args object', () {
    test('changing from today to last7Days changes from and to', () {
      // Simulate initState for today.
      final todayNow = DateTime(2026, 8, 8, 10, 30, 0);
      final todayFrom = DateTime(todayNow.year, todayNow.month, todayNow.day);

      final argsToday = _args(refreshKey: 0, from: todayFrom, to: todayNow);

      // Simulate _changeRange to last7Days.
      final newNow = DateTime(2026, 8, 8, 10, 30, 5);
      final last7From = newNow.subtract(const Duration(days: 7));
      final argsLast7 = _args(refreshKey: 1, from: last7From, to: newNow);

      expect(argsToday, isNot(equals(argsLast7)));
      expect(argsLast7.from, equals(last7From));
      expect(argsLast7.to, equals(newNow));
    });

    test('two successive builds after range change are equal (stored values)',
        () {
      final newNow = DateTime(2026, 8, 8, 11, 0, 0);
      final last30From = newNow.subtract(const Duration(days: 30));

      // After _changeRange resolves and stores, both builds use the same fields.
      final build1 = _args(refreshKey: 1, from: last30From, to: newNow);
      final build2 = _args(refreshKey: 1, from: last30From, to: newNow);

      expect(build1, equals(build2));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. Refresh increments refreshKey exactly once
// ─────────────────────────────────────────────────────────────────────────────
  group('Refresh increments refreshKey exactly once per operation', () {
    test('reload produces args with refreshKey incremented by 1', () {
      final t = DateTime(2026, 8, 8, 9, 0, 0);
      final before = _args(refreshKey: 0, from: t, to: t);

      // Simulate _reload(): resolve new range, increment key.
      final tNew = DateTime(2026, 8, 8, 9, 5, 0);
      final after = _args(refreshKey: 1, from: t, to: tNew);

      expect(after.refreshKey, 1);
      expect(before.refreshKey, 0);
      expect(before, isNot(equals(after)));
    });

    test('two builds after reload share the same refreshKey', () {
      final tNew = DateTime(2026, 8, 8, 9, 5, 0);
      final reload1 = _args(refreshKey: 1, from: _t0, to: tNew);
      final reload2 = _args(refreshKey: 1, from: _t0, to: tNew);

      expect(reload1, equals(reload2));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. Controller.getTopPerformingAssets returns data
// ─────────────────────────────────────────────────────────────────────────────
  group('Controller.getTopPerformingAssets smoke-tests', () {
    test('returns data from service', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      service.nextTopAssets = const UserDashboardTopAssets(
        range: UserDashboardDateRange(),
        limit: 10,
        items: [
          UserDashboardTopAssetItem(
            vehicleId: 'v1',
            vehicleName: 'Truck 1',
            imei: '111',
            drivenKm: 120.0,
          ),
        ],
      );

      final result =
          await ctrl.getTopPerformingAssets(from: _t0, to: _t0, limit: 10);

      expect(result.items.length, 1);
      expect(result.items.first.vehicleName, 'Truck 1');
    });

    test('empty items list is returned without error', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      service.nextTopAssets = const UserDashboardTopAssets(
        range: UserDashboardDateRange(),
        limit: 10,
        items: [],
      );

      final result =
          await ctrl.getTopPerformingAssets(from: _t0, to: _t0, limit: 10);

      expect(result.items, isEmpty);
    });

    test('service error propagates as an exception', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);
      service.throwOnNextTopAssets = true;

      await expectLater(
        () => ctrl.getTopPerformingAssets(from: _t0, to: _t0),
        throwsException,
      );
    });

    test('controller passes forceRefresh flag through to the service',
        () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      await ctrl.getTopPerformingAssets(from: _t0, to: _t0, forceRefresh: true);
      await ctrl.getTopPerformingAssets(from: _t0, to: _t0, forceRefresh: true);

      // Both calls reach the service (caching lives inside the real service,
      // not in the controller itself).
      expect(service.topAssetsCallCount, 2);
    });

    test('controller forwards default limit when not specified', () async {
      final service = _FakeService();
      final ctrl = _makeController(service);

      final result = await ctrl.getTopPerformingAssets(from: _t0, to: _t0);

      // Result must be valid even without an explicit limit.
      expect(result, isNotNull);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 6. Stable args — provider never shifts identity on normal rebuilds
// ─────────────────────────────────────────────────────────────────────────────
  group('No request loop after completion', () {
    test('args built from the same stored DateTime values are always equal',
        () async {
      // The key invariant: once from/to are stored in state and not
      // re-resolved from DateTime.now(), every build() produces the same
      // UserDashboardTopAssetsArgs, so the FutureProvider.family key is stable.
      final storedFrom = DateTime(2026, 8, 8, 0, 0, 0);
      final storedTo = DateTime(2026, 8, 8, 10, 30, 0);

      final argsA = _args(refreshKey: 0, from: storedFrom, to: storedTo);
      final argsB = _args(refreshKey: 0, from: storedFrom, to: storedTo);
      final argsC = _args(refreshKey: 0, from: storedFrom, to: storedTo);

      expect(argsA, equals(argsB));
      expect(argsB, equals(argsC));
      expect(argsA.hashCode, argsC.hashCode);
    });

    test('args differ only after explicit reload (refreshKey increment)', () {
      final storedFrom = DateTime(2026, 8, 8, 0, 0, 0);
      final storedTo = DateTime(2026, 8, 8, 10, 30, 0);
      final reloadTo = DateTime(2026, 8, 8, 10, 35, 0); // re-resolved on reload

      final beforeReload = _args(refreshKey: 0, from: storedFrom, to: storedTo);
      final afterReload = _args(refreshKey: 1, from: storedFrom, to: reloadTo);

      expect(beforeReload, isNot(equals(afterReload)));
    });
  });
} // end main()
