import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_logs_controller.dart';
import 'package:open_vts/features/admin/models/admin_logs_model.dart';
import 'package:open_vts/features/admin/models/admin_logs_state.dart';
import 'package:open_vts/features/admin/services/admin_logs_service.dart';

// ---------------------------------------------------------------------------
// Fake service — records getActivityLogs calls, ignores everything else
// ---------------------------------------------------------------------------

class _FakeService extends Fake implements AdminLogsService {
  final List<Map<String, dynamic>> activityCalls = [];
  List<AdminActivityLogItem> nextItems = const [];
  String? nextCursorId;
  bool nextHasMore = false;
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
  }) async {
    if (throwError != null) throw throwError!;
    activityCalls.add({
      'limit': limit,
      'q': q,
      'userId': userId,
      'actionPrefix': actionPrefix,
      'entity': entity,
      'from': from,
      'to': to,
      'cursorId': cursorId,
    });
    return AdminActivityLogPage(
      items: nextItems,
      nextCursorId: nextCursorId,
      hasMore: nextHasMore,
    );
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
  group('AdminLogsController — activity log filters', () {
    // -----------------------------------------------------------------------
    // Category chip → q (contains), never actionPrefix (startsWith)
    // -----------------------------------------------------------------------

    for (final chip in ['AUTH', 'SETTINGS', 'PAYMENT', 'VEHICLE', 'DRIVER']) {
      test('chip "$chip" is sent as q, not actionPrefix', () async {
        final svc = _FakeService();
        final ctrl = _build(svc);
        // Drain the auto-load triggered by loadInitial
        await Future<void>.delayed(Duration.zero);
        svc.activityCalls.clear();

        ctrl.setActivityFilters(actionPrefix: chip);
        await ctrl.loadActivityLogs();

        expect(svc.activityCalls, hasLength(1));
        final call = svc.activityCalls.first;
        expect(call['q'], chip,
            reason: 'chip must be forwarded as q (contains match)');
        expect(call['actionPrefix'], isNull,
            reason:
                'actionPrefix must not be sent — chips do not match ROLE.RESOURCE.OP format');
      });
    }

    test('"All" chip (empty string) sends null q when no manual search',
        () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      ctrl.setActivityFilters(actionPrefix: '');
      await ctrl.loadActivityLogs();

      expect(svc.activityCalls.first['q'], isNull);
      expect(svc.activityCalls.first['actionPrefix'], isNull);
    });

    // -----------------------------------------------------------------------
    // Manual search takes priority over chip keyword
    // -----------------------------------------------------------------------

    test('manual search takes priority over chip keyword', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      ctrl.setActivityFilters(actionPrefix: 'AUTH', search: 'login failed');
      await ctrl.loadActivityLogs();

      expect(svc.activityCalls.first['q'], 'login failed');
    });

    test('empty manual search falls back to chip keyword', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      ctrl.setActivityFilters(actionPrefix: 'DRIVER');
      ctrl.setActivityFilters(search: '');
      await ctrl.loadActivityLogs();

      expect(svc.activityCalls.first['q'], 'DRIVER');
    });

    // -----------------------------------------------------------------------
    // Actor / userId filter
    // -----------------------------------------------------------------------

    test('selecting a user sends userId', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      ctrl.setActivityFilters(userId: '42');
      await ctrl.loadActivityLogs();

      expect(svc.activityCalls.first['userId'], '42');
    });

    test('clearUserId=true clears an already-selected user', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      // Select a user first
      ctrl.setActivityFilters(userId: '99');
      expect(ctrl.state.activityUserId, '99');

      // Now select "All users"
      ctrl.setActivityFilters(clearUserId: true);
      expect(ctrl.state.activityUserId, isNull,
          reason: 'clearUserId must nullify activityUserId');

      await ctrl.loadActivityLogs();

      expect(svc.activityCalls.first['userId'], isNull);
    });

    test('passing userId=null without clearUserId preserves existing user', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.setActivityFilters(userId: '7');
      // Call without clearUserId — should NOT clear
      ctrl.setActivityFilters(search: 'test');

      expect(ctrl.state.activityUserId, '7',
          reason: 'userId must persist when clearUserId is false');
    });

    // -----------------------------------------------------------------------
    // Date range
    // -----------------------------------------------------------------------

    test('from/to are serialized as ISO 8601 with time component', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      final from = DateTime.utc(2026, 7, 1, 8, 30, 0);
      final to = DateTime.utc(2026, 7, 31, 23, 59, 59);
      ctrl.setActivityFilters(from: from, to: to);
      await ctrl.loadActivityLogs();

      final call = svc.activityCalls.first;
      expect(call['from'], isNotNull);
      expect(call['from'], contains('T'));
      expect(call['from'], contains('08:30'));
      expect(call['to'], isNotNull);
      expect(call['to'], contains('T'));
      expect(call['to'], contains('23:59'));
    });

    test('clearFrom=true and clearTo=true remove date filters', () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      ctrl.setActivityFilters(
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );
      ctrl.setActivityFilters(clearFrom: true, clearTo: true);
      await ctrl.loadActivityLogs();

      expect(svc.activityCalls.first['from'], isNull);
      expect(svc.activityCalls.first['to'], isNull);
    });

    // -----------------------------------------------------------------------
    // setActivityFilters resets pagination
    // -----------------------------------------------------------------------

    test('setActivityFilters clears logs, cursor, and hasMore', () {
      final svc = _FakeService();
      final ctrl = _build(svc);

      ctrl.state = ctrl.state.copyWith(
        activityLogs: [
          AdminActivityLogItem.fromJson(<String, dynamic>{
            'id': 1,
            'action': 'ADMIN.AUTH.LOGIN',
          }),
        ],
        activityNextCursorId: '5',
        activityHasMore: true,
      );

      ctrl.setActivityFilters(search: 'new');

      expect(ctrl.state.activityLogs, isEmpty);
      expect(ctrl.state.activityNextCursorId, isNull);
      expect(ctrl.state.activityHasMore, isFalse);
    });

    // -----------------------------------------------------------------------
    // Load More preserves active filters
    // -----------------------------------------------------------------------

    test('loadMoreActivityLogs carries same q, userId, from, to', () async {
      final svc = _FakeService()
        ..nextItems = const []
        ..nextHasMore = false
        ..nextCursorId = null;
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      final from = DateTime.utc(2026, 6, 1);
      final to = DateTime.utc(2026, 6, 30, 23, 59, 59);
      ctrl.setActivityFilters(
          actionPrefix: 'VEHICLE', userId: '5', from: from, to: to);
      await ctrl.loadActivityLogs();

      // Simulate a page that has more
      ctrl.state = ctrl.state.copyWith(
        activityNextCursorId: '20',
        activityHasMore: true,
        isLoadingActivity: false,
        isLoadingMoreActivity: false,
      );

      await ctrl.loadMoreActivityLogs();

      expect(svc.activityCalls, hasLength(2));
      final moreCall = svc.activityCalls[1];
      expect(moreCall['q'], 'VEHICLE',
          reason: 'Load More must carry the chip keyword');
      expect(moreCall['userId'], '5');
      expect(moreCall['from'], contains('T'));
      expect(moreCall['to'], contains('T'));
      expect(moreCall['cursorId'], '20');
      expect(moreCall['actionPrefix'], isNull);
    });

    // -----------------------------------------------------------------------
    // Clear / reset restores unfiltered state
    // -----------------------------------------------------------------------

    test('clearing all filters sends null q, userId, from, to on reload',
        () async {
      final svc = _FakeService();
      final ctrl = _build(svc);
      await Future<void>.delayed(Duration.zero);
      svc.activityCalls.clear();

      ctrl.setActivityFilters(
        actionPrefix: 'PAYMENT',
        userId: '3',
        search: 'something',
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );

      ctrl.setActivityFilters(
        actionPrefix: '',
        search: '',
        clearUserId: true,
        clearFrom: true,
        clearTo: true,
      );
      await ctrl.loadActivityLogs();

      final call = svc.activityCalls.first;
      expect(call['q'], isNull);
      expect(call['userId'], isNull);
      expect(call['from'], isNull);
      expect(call['to'], isNull);
    });
  });
}
