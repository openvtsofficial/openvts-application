import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_options.dart';
import '../../../core/providers/core_providers.dart';
import '../models/admin_payments_model.dart';
import '../models/admin_team_permissions.dart';
import '../services/admin_transactions_service.dart';

final adminParityControllerProvider = Provider<AdminParityController>(
  (ref) => AdminParityController(ref.watch(apiClientProvider)),
);

/// Coordinates the current API contract for the compact mobile detail sheets.
/// Server validation and authorization errors propagate to the owning sheet.
class AdminParityController {
  const AdminParityController(this._api);
  final ApiClient _api;
  Future<AdminPaymentsPage> transactions({
    required int page,
    String? search,
    String? status,
    DateTimeRangeBounds? range,
  }) => AdminTransactionsService(
    _api,
  ).getTransactions(page: page, search: search, status: status, range: range);
  Future<Map<String, dynamic>> _read(
    String path, {
    Map<String, dynamic>? query,
  }) async => unwrapAdminTeamPayload(
    (await _api.get<dynamic>(
      path,
      queryParameters: query,
      options: normalReadOptions(),
      parser: (v) => v,
    )).data,
  );
  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async => unwrapAdminTeamPayload(
    (await _api.post<dynamic>(
      path,
      data: data,
      options: normalWriteOptions(),
      parser: (v) => v,
    )).data,
  );
  Future<void> _put(String path, Map<String, dynamic> data) async {
    await _api.put<dynamic>(
      path,
      data: data,
      options: normalWriteOptions(),
      parser: (v) => v,
    );
  }

  Future<List<Map<String, dynamic>>> loadTeamPermissions(String id) =>
      Future.wait([
        _read(AdminExtendedEndpoints.teamPermissionCatalog),
        _read(AdminExtendedEndpoints.teamPermissions(id)),
      ]);
  Future<void> saveTeamPermissions(
    String id,
    List<Map<String, String>> grants,
  ) => _put(AdminExtendedEndpoints.teamPermissions(id), {'grants': grants});
  Future<Map<String, dynamic>> teamActivity(String id, {int? cursor}) => _read(
    AdminExtendedEndpoints.teamActivity(id),
    query: {'limit': 30, if (cursor != null) 'cursorId': cursor},
  );
  Future<Map<String, dynamic>> userPermissions(String id) =>
      _read(AdminExtendedEndpoints.userPermissions(id));
  Future<void> saveUserPermissions(String id, Map<String, dynamic> data) =>
      _put(AdminExtendedEndpoints.userPermissions(id), data);
  Future<Map<String, dynamic>> vehicleService(String id) =>
      _read(AdminExtendedEndpoints.vehicleService(id));
  Future<void> saveVehicleService(String id, Map<String, dynamic> data) async {
    await _api.patch<dynamic>(
      AdminExtendedEndpoints.vehicleService(id),
      data: data,
      options: normalWriteOptions(),
      parser: (v) => v,
    );
  }

  Future<Map<String, dynamic>> renewAnnual(String id) =>
      _post(AdminExtendedEndpoints.annualRenew(id), {});
  Future<Map<String, dynamic>> renewalRequests({int? cursor}) => _read(
    AdminExtendedEndpoints.renewalRequests,
    query: {
      'status': 'PENDING',
      'limit': 30,
      if (cursor != null) 'cursor': cursor,
    },
  );
  Future<void> confirmRenewal(String id, Map<String, dynamic> data) async {
    await _post(AdminExtendedEndpoints.confirmRenewal(id), data);
  }

  Future<void> cancelRenewal(String id) async {
    await _post(AdminExtendedEndpoints.cancelRenewal(id), {});
  }
}
