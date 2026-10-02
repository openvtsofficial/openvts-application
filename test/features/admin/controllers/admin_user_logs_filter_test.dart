import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/controllers/admin_user_details_controller.dart';
import 'package:open_vts/features/admin/models/admin_user_details_model.dart';
import 'package:open_vts/features/admin/services/admin_user_details_service.dart';

// ---------------------------------------------------------------------------
// Fake service that records calls to getActivityLogs
// ---------------------------------------------------------------------------

class _FakeService extends Fake implements AdminUserDetailsService {
  final List<Map<String, dynamic>> logCalls = [];
  List<AdminUserActivityLog> nextItems = const [];
  int? nextCursorId;
  bool nextHasMore = false;
  Object? throwError;

  @override
  Future<AdminUserActivityLogPage> getActivityLogs({
    required String userId,
    int limit = 20,
    int? cursorId,
    String? q,
    String? actionPrefix,
    String? from,
    String? to,
  }) async {
    if (throwError != null) throw throwError!;
    logCalls.add({
      'userId': userId,
      'limit': limit,
      'cursorId': cursorId,
      'q': q,
      'actionPrefix': actionPrefix,
      'from': from,
      'to': to,
    });
    return AdminUserActivityLogPage(
      items: nextItems,
      nextCursorId: nextCursorId,
      hasMore: nextHasMore,
    );
  }
}

// ---------------------------------------------------------------------------
// Builder helper
// ---------------------------------------------------------------------------

AdminUserDetailsController _buildController(_FakeService service) {
  return AdminUserDetailsController(
    userId: '1',
    service: service,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AdminUserDetailsController — log filters', () {
    // -----------------------------------------------------------------------
    // Chip keyword goes through q, not actionPrefix
    // -----------------------------------------------------------------------

    test('action chip keyword is sent as q, not actionPrefix', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(actionPrefix: 'AUTH');
      await ctrl.loadLogs();

      expect(svc.logCalls, hasLength(1));
      final call = svc.logCalls.first;
      expect(call['q'], 'AUTH');
      expect(call['actionPrefix'], isNull,
          reason: 'chip keyword must not be sent as actionPrefix');
    });

    test('VEHICLE chip sent as q', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(actionPrefix: 'VEHICLE');
      await ctrl.loadLogs();

      expect(svc.logCalls.first['q'], 'VEHICLE');
      expect(svc.logCalls.first['actionPrefix'], isNull);
    });

    test('PAYMENT chip sent as q', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(actionPrefix: 'PAYMENT');
      await ctrl.loadLogs();

      expect(svc.logCalls.first['q'], 'PAYMENT');
    });

    // -----------------------------------------------------------------------
    // Manual search takes priority over chip keyword
    // -----------------------------------------------------------------------

    test('manual search text takes priority over chip keyword', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(actionPrefix: 'AUTH');
      ctrl.setLogFilters(q: 'login failed');
      await ctrl.loadLogs();

      expect(svc.logCalls.first['q'], 'login failed');
    });

    test('empty manual search falls back to chip keyword', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(actionPrefix: 'DRIVER');
      ctrl.setLogFilters(q: '');
      await ctrl.loadLogs();

      expect(svc.logCalls.first['q'], 'DRIVER');
    });

    // -----------------------------------------------------------------------
    // Empty query omission
    // -----------------------------------------------------------------------

    test('q is null when both search and chip keyword are empty', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      await ctrl.loadLogs();

      expect(svc.logCalls.first['q'], isNull);
    });

    // -----------------------------------------------------------------------
    // Full ISO from/to datetime serialization
    // -----------------------------------------------------------------------

    test('from is serialized as full ISO 8601 datetime string', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      final from = DateTime.utc(2026, 7, 1, 8, 30, 0);
      ctrl.setLogFilters(from: from);
      await ctrl.loadLogs();

      final fromStr = svc.logCalls.first['from'] as String?;
      expect(fromStr, isNotNull);
      // Must include time component — not just YYYY-MM-DD
      expect(fromStr, contains('T'));
      expect(fromStr, contains('08:30'));
    });

    test('to is serialized as full ISO 8601 datetime string', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      final to = DateTime.utc(2026, 7, 31, 23, 59, 59);
      ctrl.setLogFilters(to: to);
      await ctrl.loadLogs();

      final toStr = svc.logCalls.first['to'] as String?;
      expect(toStr, isNotNull);
      expect(toStr, contains('T'));
      expect(toStr, contains('23:59'));
    });

    test('null from/to results in null from/to sent to service', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      await ctrl.loadLogs();

      expect(svc.logCalls.first['from'], isNull);
      expect(svc.logCalls.first['to'], isNull);
    });

    // -----------------------------------------------------------------------
    // Filter change resets cursor state
    // -----------------------------------------------------------------------

    test('setLogFilters clears logs, cursor, and hasMore', () {
      final svc = _FakeService()
        ..nextItems = [
          AdminUserActivityLog.fromJson(<String, dynamic>{
            'id': 1,
            'action': 'AUTH.LOGIN',
          }),
        ]
        ..nextCursorId = 42
        ..nextHasMore = true;
      final ctrl = _buildController(svc);

      // Pretend logs are loaded
      ctrl.state = ctrl.state.copyWith(
        logs: [
          AdminUserActivityLog.fromJson(<String, dynamic>{
            'id': 1,
            'action': 'AUTH.LOGIN',
          }),
        ],
        logsNextCursorId: 42,
        logsHasMore: true,
      );

      ctrl.setLogFilters(q: 'new search');

      expect(ctrl.state.logs, isEmpty);
      expect(ctrl.state.logsNextCursorId, isNull);
      expect(ctrl.state.logsHasMore, isFalse);
    });

    // -----------------------------------------------------------------------
    // Load More retains active filters
    // -----------------------------------------------------------------------

    test('loadMoreLogs uses same q, from, to as loadLogs', () async {
      final svc = _FakeService()
        ..nextItems = const []
        ..nextCursorId = null
        ..nextHasMore = false;
      final ctrl = _buildController(svc);

      final from = DateTime.utc(2026, 6, 1, 0, 0, 0);
      final to = DateTime.utc(2026, 6, 30, 23, 59, 59);
      ctrl.setLogFilters(actionPrefix: 'VEHICLE', from: from, to: to);
      await ctrl.loadLogs();

      // Simulate a first page that has more
      ctrl.state = ctrl.state.copyWith(
        logs: const [],
        logsNextCursorId: 10,
        logsHasMore: true,
        isLoadingLogs: false,
      );

      await ctrl.loadMoreLogs();

      expect(svc.logCalls, hasLength(2));
      final moreCall = svc.logCalls[1];
      expect(moreCall['q'], 'VEHICLE',
          reason: 'Load More must carry the same chip keyword as initial load');
      expect(moreCall['from'], contains('T'));
      expect(moreCall['to'], contains('T'));
      expect(moreCall['cursorId'], 10);
    });

    // -----------------------------------------------------------------------
    // Clear filters restores unfiltered state
    // -----------------------------------------------------------------------

    test('clearing all filters sends null q, from, to on reload', () async {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(
        q: 'something',
        actionPrefix: 'PAYMENT',
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );

      // Now clear everything
      ctrl.setLogFilters(
          q: '', actionPrefix: '', clearFrom: true, clearTo: true);
      await ctrl.loadLogs();

      final call = svc.logCalls.first;
      expect(call['q'], isNull);
      expect(call['from'], isNull);
      expect(call['to'], isNull);
    });

    test('clear all resets state fields', () {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(
        q: 'foo',
        actionPrefix: 'AUTH',
        from: DateTime.utc(2026, 1, 1),
        to: DateTime.utc(2026, 12, 31),
      );

      ctrl.setLogFilters(
          q: '', actionPrefix: '', clearFrom: true, clearTo: true);

      expect(ctrl.state.logSearch, '');
      expect(ctrl.state.logActionPrefix, '');
      expect(ctrl.state.logFrom, isNull);
      expect(ctrl.state.logTo, isNull);
      expect(ctrl.state.logs, isEmpty);
      expect(ctrl.state.logsNextCursorId, isNull);
    });

    // -----------------------------------------------------------------------
    // Debounce: setLogFilters does not auto-trigger loadLogs
    // -----------------------------------------------------------------------

    test('setLogFilters alone does not call the service', () {
      final svc = _FakeService();
      final ctrl = _buildController(svc);

      ctrl.setLogFilters(q: 'AUTH');
      ctrl.setLogFilters(q: 'AUTH.LOGIN');
      ctrl.setLogFilters(actionPrefix: 'VEHICLE');

      // No service calls yet — the UI layer calls loadLogs() explicitly after
      // debounce.
      expect(svc.logCalls, isEmpty);
    });

    // -----------------------------------------------------------------------
    // Backend error state
    // -----------------------------------------------------------------------

    test('service error sets sectionErrorMessage and clears isLoadingLogs',
        () async {
      final svc = _FakeService()
        ..throwError = ArgumentError('Server rejected request');
      final ctrl = _buildController(svc);

      await ctrl.loadLogs();

      expect(ctrl.state.isLoadingLogs, isFalse);
      expect(ctrl.state.sectionErrorMessage, isNotNull);
      expect(
          ctrl.state.sectionErrorMessage, contains('Server rejected request'));
    });

    test('loadMoreLogs error sets sectionErrorMessage without clearing logs',
        () async {
      final svc = _FakeService()
        ..nextItems = const []
        ..nextCursorId = null
        ..nextHasMore = false;
      final ctrl = _buildController(svc);

      // First load succeeds, puts a log in state
      svc.nextItems = [
        AdminUserActivityLog.fromJson(<String, dynamic>{
          'id': 1,
          'action': 'AUTH.LOGIN',
        }),
      ];
      svc.nextHasMore = true;
      svc.nextCursorId = 5;
      await ctrl.loadLogs();

      // Next call throws
      svc.throwError = ArgumentError('Cursor expired');
      await ctrl.loadMoreLogs();

      expect(ctrl.state.isLoadingMoreLogs, isFalse);
      expect(ctrl.state.sectionErrorMessage, contains('Cursor expired'));
      expect(ctrl.state.logs, isNotEmpty,
          reason: 'existing rows must be preserved on loadMore error');
    });
  });
}
