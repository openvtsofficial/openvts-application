import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_options.dart';
import '../../../shared/models/user_role.dart';
import '../models/admin_team_permissions.dart';
import '../models/admin_user_permissions.dart';
import '../models/admin_user_retention_policy.dart';

class AdminUserAccessService {
  AdminUserAccessService(this._api)
    : _scope = workspaceDataScope(_api.activeUser);
  final ApiClient _api;
  final String _scope;
  bool get isCurrent =>
      _api.activeRole == UserRole.admin &&
      workspaceDataScope(_api.activeUser) == _scope;

  void _authorize() {
    if (!isCurrent) {
      throw const ApiException(
        message: 'Your account does not have permission to view this section.',
        statusCode: 403,
      );
    }
  }

  String _id(String id) {
    if (id.trim().isEmpty) throw ArgumentError('userId is required.');
    return id.trim();
  }

  Future<AdminUserPermissions> getPermissions(String userId) async {
    _authorize();
    final response = await _api.get<dynamic>(
      AdminExtendedEndpoints.userPermissions(_id(userId)),
      options: normalReadOptions(),
      parser: (json) => json,
    );
    _authorize();
    return AdminUserPermissions.fromJson(unwrapAdminTeamPayload(response.data));
  }

  Future<AdminUserPermissions> savePermissions(
    String userId,
    AdminUserPermissions permissions,
  ) async {
    _authorize();
    final response = await _api.put<dynamic>(
      AdminExtendedEndpoints.userPermissions(_id(userId)),
      data: permissions.toJson(),
      options: normalWriteOptions(),
      parser: (json) => json,
    );
    _authorize();
    return AdminUserPermissions.fromJson(unwrapAdminTeamPayload(response.data));
  }

  Future<AdminUserRetentionPolicy> getRetention(String userId) async {
    _authorize();
    final response = await _api.get<dynamic>(
      AdminExtendedEndpoints.userDataRetention(_id(userId)),
      options: normalReadOptions(),
      parser: (json) => json,
    );
    _authorize();
    return AdminUserRetentionPolicy.fromJson(
      unwrapAdminTeamPayload(response.data),
    );
  }

  Future<AdminUserRetentionPolicy> saveRetention(
    String userId,
    int? days, {
    required int maxDays,
  }) async {
    _authorize();
    if (days != null && (days < 30 || days > 3650 || days > maxDays)) {
      throw const ApiException(message: 'Invalid retention period.');
    }
    final response = await _api.patch<dynamic>(
      AdminExtendedEndpoints.userDataRetention(_id(userId)),
      data: {'retentionDays': days},
      options: normalWriteOptions(),
      parser: (json) => json,
    );
    _authorize();
    return AdminUserRetentionPolicy.fromJson(
      unwrapAdminTeamPayload(response.data),
    );
  }
}
