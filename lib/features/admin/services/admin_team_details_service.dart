import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_options.dart';
import '../models/admin_team_model.dart';
import '../models/admin_team_permissions.dart';

class AdminTeamPermissionSnapshot {
  const AdminTeamPermissionSnapshot(this.features, this.grants);
  final List<AdminTeamPermissionFeature> features;
  final Map<String, String> grants;

  factory AdminTeamPermissionSnapshot.fromJson(
    dynamic catalog,
    dynamic access,
    String memberId,
  ) {
    final catalogMap = unwrapAdminTeamPayload(catalog);
    final accessMap = unwrapAdminTeamPayload(access);
    final member = accessMap['member'];
    final role = accessMap['role'];
    if (member is! Map ||
        '${member['id']}' != memberId ||
        (accessMap['grants'] is! List &&
            (role is! Map || role['grants'] is! List)) ||
        catalogMap['features'] is! List) {
      throw const FormatException('Invalid member permission response');
    }
    final seenFeatures = <String>{};
    final seenSlugs = <String>{};
    for (final raw in catalogMap['features'] as List) {
      if (raw is! Map ||
          raw['key'] is! String ||
          !seenFeatures.add(raw['key'] as String) ||
          raw['actions'] is! List ||
          (raw['actions'] as List).isEmpty) {
        throw const FormatException('Invalid permission catalog');
      }
      for (final action in raw['actions'] as List) {
        if (action is! Map ||
            !const {'view', 'edit', 'delete'}.contains(action['action']) ||
            action['permissionSlug'] is! String ||
            (action['permissionSlug'] as String).isEmpty ||
            !seenSlugs.add(action['permissionSlug'] as String) ||
            action['allowedScopes'] is! List ||
            (action['allowedScopes'] as List).isEmpty ||
            (action['allowedScopes'] as List).any(
              (scope) => !const {'OWN', 'TENANT'}.contains(scope),
            )) {
          throw const FormatException('Invalid permission catalog action');
        }
      }
    }
    final rawGrants = accessMap['grants'] ?? (role as Map)['grants'];
    for (final grant in rawGrants as List) {
      if (grant is! Map ||
          grant['permissionSlug'] is! String ||
          !seenSlugs.contains(grant['permissionSlug']) ||
          !const {'OWN', 'TENANT'}.contains(grant['scope'])) {
        throw const FormatException('Invalid direct member grant');
      }
    }
    final features = parseAdminTeamFeatures(catalogMap);
    if (features.isEmpty || features.any((f) => f.actions.isEmpty)) {
      throw const FormatException(
        'The permission catalog is unavailable. Editing is disabled.',
      );
    }
    return AdminTeamPermissionSnapshot(
      List.unmodifiable(features),
      Map.unmodifiable(parseAdminTeamGrants(accessMap)),
    );
  }
}

class AdminTeamActivityPage {
  const AdminTeamActivityPage({
    required this.items,
    required this.hasMore,
    this.cursor,
  });
  final List<Map<String, dynamic>> items;
  final bool hasMore;
  final int? cursor;
  factory AdminTeamActivityPage.fromJson(dynamic value) {
    final data = unwrapAdminTeamPayload(value);
    if (data['items'] is! List || data['hasMore'] is! bool) {
      throw const FormatException('Invalid team activity response');
    }
    final cursor = int.tryParse('${data['nextCursorId']}');
    if (data['hasMore'] == true && cursor == null) {
      throw const FormatException('Invalid activity cursor');
    }
    return AdminTeamActivityPage(
      items: List.unmodifiable(
        (data['items'] as List).whereType<Map>().map(
          (v) => Map<String, dynamic>.from(v),
        ),
      ),
      hasMore: data['hasMore'] == true,
      cursor: cursor,
    );
  }
}

class AdminTeamDetailsService {
  const AdminTeamDetailsService(this._api);
  final ApiClient _api;

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

  Future<AdminTeamListItem> profile(String id) async {
    final data = await _read(ApiEndpoints.admin.teamById(id));
    final member = AdminTeamListItem.fromJson(data);
    if (member.id != id) {
      throw const FormatException('Invalid team member response');
    }
    return member;
  }

  Future<AdminTeamPermissionSnapshot> permissions(String id) async {
    final responses = await Future.wait([
      _read(AdminExtendedEndpoints.teamPermissionCatalog),
      _read(AdminExtendedEndpoints.teamPermissions(id)),
    ]);
    return AdminTeamPermissionSnapshot.fromJson(responses[0], responses[1], id);
  }

  Future<void> savePermissions(
    String id,
    List<Map<String, String>> grants,
  ) async {
    await _api.put<dynamic>(
      AdminExtendedEndpoints.teamPermissions(id),
      data: {'grants': grants},
      options: normalWriteOptions(),
      parser: (v) => v,
    );
  }

  Future<AdminTeamActivityPage> activity(String id, {int? cursor}) async =>
      AdminTeamActivityPage.fromJson(
        await _read(
          AdminExtendedEndpoints.teamActivity(id),
          query: {'limit': 30, if (cursor != null) 'cursorId': cursor},
        ),
      );
}
