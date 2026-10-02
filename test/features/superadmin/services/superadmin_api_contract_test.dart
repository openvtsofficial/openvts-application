import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/services/superadmin_admin_details_service.dart';
import 'package:open_vts/features/superadmin/services/superadmin_dashboard_service.dart';

void main() {
  test('dashboard cursor pagination retains actor and time boundaries', () async {
    RequestOptions? request;
    final service = SuperadminDashboardService(_client((value) => request = value));
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
    expect(request!.queryParameters, containsPair('from', from.toIso8601String()));
    expect(request!.queryParameters, containsPair('to', to.toIso8601String()));
    expect(request!.queryParameters, containsPair('limit', 50));
  });

  test('administrator activity respects current backend DTO page bounds', () async {
    final requests = <RequestOptions>[];
    final service = SuperadminAdminDetailsService(_client(requests.add));
    await service.getAdminActivityLogs(adminId: '7', limit: 1);
    await service.getAdminActivityLogs(adminId: '7', limit: 100);
    expect(requests[0].queryParameters['limit'], 5);
    expect(requests[1].queryParameters['limit'], 50);
  });
}

ApiClient _client(void Function(RequestOptions) capture) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    capture(options);
    handler.resolve(Response<dynamic>(
      requestOptions: options,
      statusCode: 200,
      data: <String, dynamic>{'items': <dynamic>[], 'hasMore': false},
    ));
  }));
  return ApiClient(dio);
}
