import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/controllers/admin_transactions_controller.dart';
import 'package:open_vts/features/admin/models/admin_transactions_model.dart';
import 'package:open_vts/features/admin/services/admin_transactions_service.dart';

class _RecordingTransactionsService extends AdminTransactionsService {
  _RecordingTransactionsService() : super(ApiClient(Dio()));

  final pages = <int>[];
  final searches = <String?>[];

  @override
  Future<AdminTransactionPage> getTransactions({
    int page = 1,
    int limit = 100,
    AdminTransactionStatus? status,
    String? search,
    DateTime? from,
    DateTime? to,
    String? refreshKey,
  }) async {
    pages.add(page);
    searches.add(search);
    return AdminTransactionPage(
      items: const [],
      page: page,
      limit: limit,
      total: 250,
    );
  }
}

void main() {
  test('search trims, resets paging, persists for load more, and clears',
      () async {
    final service = _RecordingTransactionsService();
    final controller = AdminTransactionsController(service: service);

    await controller.setSearch('  invoice-42  ');
    expect(controller.state.searchQuery, 'invoice-42');
    expect(controller.state.page, 1);
    expect(service.pages, [1]);
    expect(service.searches, ['invoice-42']);

    await controller.loadMore();
    expect(service.pages, [1, 2]);
    expect(service.searches, ['invoice-42', 'invoice-42']);

    await controller.clearFilters();
    expect(controller.state.searchQuery, isEmpty);
    expect(controller.state.page, 1);
    expect(service.searches.last, isEmpty);

    await controller.setSearch('   ');
    expect(service.searches, hasLength(3),
        reason: 'unchanged search is ignored');
  });
}
