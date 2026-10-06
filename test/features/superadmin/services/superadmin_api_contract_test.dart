import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/controllers/superadmin_dashboard_controller.dart';
import 'package:open_vts/features/superadmin/models/superadmin_dashboard_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_admin_details_service.dart';
import 'package:open_vts/features/superadmin/services/superadmin_dashboard_service.dart';

void main() {
  test(
    'dashboard cursor pagination retains actor and time boundaries',
    () async {
      RequestOptions? request;
      final service = SuperadminDashboardService(
        _client((value) => request = value),
      );
      final from = DateTime.utc(2026, 9, 1);
      final to = DateTime.utc(2026, 9, 20);

      await service.fetchActivityLogs(
        limit: 100,
        cursorId: 80,
        actorId: 7,
        from: from,
        to: to,
      );

      expect(request!.queryParameters, containsPair('actorId', 7));
      expect(request!.queryParameters, containsPair('cursorId', 80));
      expect(
        request!.queryParameters,
        containsPair('from', from.toIso8601String()),
      );
      expect(
        request!.queryParameters,
        containsPair('to', to.toIso8601String()),
      );
      expect(request!.queryParameters, containsPair('limit', 50));
    },
  );

  test(
    'administrator activity respects current backend DTO page bounds',
    () async {
      final requests = <RequestOptions>[];
      final service = SuperadminAdminDetailsService(_client(requests.add));
      await service.getAdminActivityLogs(adminId: '7', limit: 1);
      await service.getAdminActivityLogs(adminId: '7', limit: 100);
      expect(requests[0].queryParameters['limit'], 5);
      expect(requests[1].queryParameters['limit'], 50);
    },
  );

  test(
    'activity subsequent page keeps search/action/time filters and valid DTO IDs',
    () async {
      final requests = <RequestOptions>[];
      final client = _client(requests.add);
      await SuperadminAdminDetailsService(client).getAdminActivityLogs(
        adminId: '7',
        limit: 20,
        q: ' update ',
        actionPrefix: ' VEHICLE ',
        from: '2026-09-01T00:00:00Z',
        to: '2026-09-20T00:00:00Z',
        cursorId: 80,
      );
      await SuperadminDashboardService(
        client,
      ).fetchActivityLogs(limit: 1, actorId: 0, cursorId: 0);
      expect(requests.first.queryParameters, {
        'limit': 20,
        'q': 'update',
        'actionPrefix': 'VEHICLE',
        'from': '2026-09-01T00:00:00Z',
        'to': '2026-09-20T00:00:00Z',
        'cursorId': 80,
      });
      expect(requests.last.queryParameters['limit'], 5);
      expect(requests.last.queryParameters.containsKey('cursorId'), isFalse);
      expect(requests.last.queryParameters.containsKey('actorId'), isFalse);
    },
  );
  test(
    'dashboard controller load-more forwards the active filter scope',
    () async {
      final requests = <RequestOptions>[];
      final service = _SeededDashboardService(
        _client(
          requests.add,
          reply: (request) {
            final isMore = request.queryParameters.containsKey('cursorId');
            return {
              'items': [
                {'id': isMore ? 70 : 80, 'action': 'VEHICLE_UPDATE'},
              ],
              'nextCursorId': isMore ? null : 80,
            };
          },
        ),
      );
      final controller = SuperadminDashboardController(service);
      addTearDown(controller.dispose);
      final loaded = Completer<void>();
      final removeListener = controller.addListener((state) {
        if (!state.isInitialLoading && !loaded.isCompleted) loaded.complete();
      });
      await loaded.future;
      removeListener();
      final from = DateTime.utc(2026, 9, 1);
      final to = DateTime.utc(2026, 9, 20);
      await controller.applyFilters(actorId: 7, from: from, to: to);
      await controller.loadMoreActivityLogs();
      expect(requests, hasLength(2));
      expect(requests.last.queryParameters, containsPair('cursorId', 80));
      for (final request in requests) {
        expect(request.queryParameters, containsPair('actorId', 7));
        expect(
          request.queryParameters,
          containsPair('from', from.toIso8601String()),
        );
        expect(
          request.queryParameters,
          containsPair('to', to.toIso8601String()),
        );
      }
      expect(
        controller.state.dashboard!.activityLogs.items.map((item) => item.id),
        ['80', '70'],
      );
      expect(controller.state.dashboard!.activityLogs.hasMore, isFalse);
    },
  );
}

class _SeededDashboardService extends SuperadminDashboardService {
  _SeededDashboardService(super.client);

  @override
  Future<SuperadminDashboardModel> getDashboard() async =>
      SuperadminDashboardModel.fromJson(const {});
}

ApiClient _client(
  void Function(RequestOptions) capture, {
  dynamic Function(RequestOptions)? reply,
}) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        capture(options);
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data:
                reply?.call(options) ??
                <String, dynamic>{'items': <dynamic>[], 'hasMore': false},
          ),
        );
      },
    ),
  );
  return ApiClient(dio);
}
