import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_options.dart';
import 'user_operations_service.dart' show operationMap;

class UserVehicleServiceBillingService {
  UserVehicleServiceBillingService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> load(
      {required bool requests, int? cursor, String? search}) async {
    final response = await _api.get<Map<String, dynamic>>(
        requests
            ? UserExtendedEndpoints.renewalRequests
            : UserExtendedEndpoints.serviceVehicles,
        queryParameters: {
          'limit': 30,
          if (cursor != null) 'cursor': cursor,
          if (!requests && search != null && search.trim().isNotEmpty)
            'search': search.trim()
        },
        options: normalReadOptions(),
        parser: operationMap);
    return response.data;
  }

  Future<Map<String, dynamic>> requestRenewal(
      {required int vehicleId, required String idempotencyKey}) async {
    final response = await _api.post<Map<String, dynamic>>(
        UserExtendedEndpoints.renewalRequests,
        data: {
          'vehicleIds': [vehicleId],
          'idempotencyKey': idempotencyKey
        },
        options: normalWriteOptions(),
        parser: operationMap);
    return response.data;
  }

  Future<void> cancel(int id) async {
    await _api.post<void>(UserExtendedEndpoints.cancelRenewal(id),
        options: normalWriteOptions(), parser: (_) {});
  }
}
