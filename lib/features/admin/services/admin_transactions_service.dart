import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_options.dart';
import '../models/admin_payments_model.dart';

/// The administrator's own ledger, distinct from customer payments.
class AdminTransactionsService {
  const AdminTransactionsService(this._api);
  final ApiClient _api;
  Future<AdminPaymentsPage> getTransactions(
      {int page = 1,
      int limit = 50,
      String? search,
      String? status,
      DateTimeRangeBounds? range}) async {
    final response =
        await _api.get<dynamic>(AdminExtendedEndpoints.transactions,
            queryParameters: {
              'page': page < 1 ? 1 : page,
              'limit': limit.clamp(1, 100),
              if ((search ?? '').trim().isNotEmpty) 'q': search!.trim(),
              if (status != null) 'status': status,
              if (range != null) 'from': range.from.toUtc().toIso8601String(),
              if (range != null) 'to': range.to.toUtc().toIso8601String()
            },
            options: normalReadOptions(),
            parser: (v) => v);
    return AdminPaymentsPage.fromJson(response.data,
        defaultPage: page, defaultLimit: limit);
  }
}

class DateTimeRangeBounds {
  const DateTimeRangeBounds(this.from, this.to);
  final DateTime from, to;
}
