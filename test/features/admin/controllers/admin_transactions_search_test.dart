import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/services/admin_transactions_service.dart';

void main() {
  test(
      'ledger uses separate endpoint, trims search and preserves paging/filter contract',
      () async {
    final requests = <RequestOptions>[];
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) {
      requests.add(o);
      h.resolve(Response(requestOptions: o, statusCode: 200, data: {
        'items': [],
        'page': o.queryParameters['page'],
        'limit': 50,
        'total': 250
      }));
    }));
    final service = AdminTransactionsService(ApiClient(dio));
    final first = await service.getTransactions(
        search: '  invoice-42  ', status: 'SUCCESS');
    expect(first.page, 1);
    expect(first.total, 250);
    await service.getTransactions(
        page: 2, search: 'invoice-42', status: 'SUCCESS');
    await service.getTransactions(search: '  ');
    expect(requests.map((r) => r.path), everyElement('/admin/transactions'));
    expect(requests[0].queryParameters['q'], 'invoice-42');
    expect(requests[1].queryParameters['q'], 'invoice-42');
    expect(requests[1].queryParameters['page'], 2);
    expect(requests[1].queryParameters['status'], 'SUCCESS');
    expect(requests[2].queryParameters.containsKey('q'), false);
    expect(requests[2].queryParameters['page'], 1);
  });
}
