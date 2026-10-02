import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_admin_details_controller.dart';
import 'package:open_vts/features/superadmin/models/superadmin_activity_filter.dart';
import 'package:open_vts/features/superadmin/models/superadmin_admin_details_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_admin_details_service.dart';
import 'package:open_vts/features/superadmin/services/superadmin_payments_service.dart';

void main() {
  test('rejects an invalid date range without changing filters', () {
    final controller = _controller(_FakeDetailsService());
    final valid = controller.setActivityDateRange(
      from: DateTime(2026, 8, 10, 12),
      to: DateTime(2026, 8, 10, 11),
    );

    expect(valid, isFalse);
    expect(controller.state.activityFrom, isNull);
    expect(controller.state.activityTo, isNull);
  });

  test('slower previous search cannot overwrite the latest results', () async {
    final service = _FakeDetailsService();
    final first = Completer<SuperadminAdminActivityLogPage>();
    final second = Completer<SuperadminAdminActivityLogPage>();
    service.responses.addAll([first.future, second.future]);
    final controller = _controller(service);

    controller.setActivitySearch('old');
    final oldRequest = controller.loadActivity();
    controller.setActivitySearch('new');
    final newRequest = controller.loadActivity();
    second.complete(_page([_log(2, 'ADMIN.AUTH.LOGIN')]));
    await newRequest;
    first.complete(_page([_log(1, 'ADMIN.VEHICLE.CREATE')]));
    await oldRequest;

    expect(controller.state.activityLogs.map((log) => log.id), [2]);
    expect(service.calls.last.q, 'new');
  });

  test('load more preserves filters and deduplicates overlapping ids',
      () async {
    final service = _FakeDetailsService();
    service.responses.addAll([
      Future.value(_page(
          [_log(2, 'ADMIN.AUTH.LOGIN'), _log(1, 'ADMIN.AUTH.LOGIN')],
          cursor: 1, hasMore: true)),
      Future.value(
          _page([_log(1, 'ADMIN.AUTH.LOGIN'), _log(0, 'ADMIN.AUTH.LOGIN')])),
    ]);
    final controller = _controller(service);
    controller.setActivitySearch(' login ');
    controller.setActivityActionPrefix(
      SuperadminActivityCategory.security.value,
    );
    controller.setActivityDateRange(
      from: DateTime.utc(2026, 8, 9, 10),
      to: DateTime.utc(2026, 8, 9, 11, 30),
    );

    await controller.loadActivity();
    await controller.loadMoreActivity();

    expect(controller.state.activityLogs.map((log) => log.id), [2, 1, 0]);
    expect(service.calls.last.q, 'login');
    expect(service.calls.last.actionPrefix, 'ADMIN.AUTH');
    expect(service.calls.last.from, '2026-08-09T10:00:00.000Z');
    expect(service.calls.last.to, '2026-08-09T11:30:00.000Z');
    expect(service.calls.last.cursorId, 1);
  });
}

SuperadminAdminDetailsController _controller(_FakeDetailsService service) =>
    SuperadminAdminDetailsController(
      adminId: '42',
      detailsService: service,
      paymentsService: SuperadminPaymentsService(ApiClient(Dio())),
      onAdminStatusChanged: null,
    );

class _FakeDetailsService extends SuperadminAdminDetailsService {
  _FakeDetailsService() : super(ApiClient(Dio()));

  final responses = <Future<SuperadminAdminActivityLogPage>>[];
  final calls = <_ActivityCall>[];

  @override
  Future<SuperadminAdminActivityLogPage> getAdminActivityLogs({
    required String adminId,
    int limit = 20,
    String? q,
    String? actionPrefix,
    String? from,
    String? to,
    int? cursorId,
    String? refreshKey,
  }) {
    calls.add(_ActivityCall(q, actionPrefix, from, to, cursorId));
    return responses.removeAt(0);
  }
}

class _ActivityCall {
  const _ActivityCall(
    this.q,
    this.actionPrefix,
    this.from,
    this.to,
    this.cursorId,
  );

  final String? q;
  final String? actionPrefix;
  final String? from;
  final String? to;
  final int? cursorId;
}

SuperadminAdminActivityLogPage _page(
  List<SuperadminAdminActivityLog> items, {
  int? cursor,
  bool hasMore = false,
}) =>
    SuperadminAdminActivityLogPage(
      items: items,
      nextCursorId: cursor,
      hasMore: hasMore,
      admin: null,
    );

SuperadminAdminActivityLog _log(int id, String action) =>
    SuperadminAdminActivityLog(
      id: id,
      action: action,
      entity: '',
      entityId: '',
      meta: const {},
      ip: '',
      browser: '',
      platform: '',
      createdAt: null,
      user: null,
    );
