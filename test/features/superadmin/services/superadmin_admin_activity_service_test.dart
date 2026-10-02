import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/services/superadmin_admin_details_service.dart';

void main() {
  test('sends trimmed search, full timestamps, prefix and cursor', () async {
    RequestOptions? request;
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: const <String, dynamic>{'items': <dynamic>[], 'hasMore': false},
      ));
    }));
    final service = SuperadminAdminDetailsService(ApiClient(dio));

    await service.getAdminActivityLogs(
      adminId: '42',
      q: '  login  ',
      actionPrefix: 'ADMIN.AUTH',
      from: '2026-08-09T10:00:00.000Z',
      to: '2026-08-09T11:30:00.000Z',
      cursorId: 91,
    );

    expect(request?.queryParameters, containsPair('q', 'login'));
    expect(
        request?.queryParameters, containsPair('actionPrefix', 'ADMIN.AUTH'));
    expect(request?.queryParameters,
        containsPair('from', '2026-08-09T10:00:00.000Z'));
    expect(request?.queryParameters,
        containsPair('to', '2026-08-09T11:30:00.000Z'));
    expect(request?.queryParameters, containsPair('cursorId', 91));
  });

  test('omits empty optional filters', () async {
    RequestOptions? request;
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: const <String, dynamic>{'items': <dynamic>[], 'hasMore': false},
      ));
    }));

    await SuperadminAdminDetailsService(ApiClient(dio)).getAdminActivityLogs(
      adminId: '42',
      q: '   ',
    );

    expect(request?.queryParameters.containsKey('q'), isFalse);
    expect(request?.queryParameters.containsKey('actionPrefix'), isFalse);
    expect(request?.queryParameters.containsKey('from'), isFalse);
    expect(request?.queryParameters.containsKey('to'), isFalse);
    expect(request?.queryParameters.containsKey('cursorId'), isFalse);
  });
}
