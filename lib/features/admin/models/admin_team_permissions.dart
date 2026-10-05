class AdminTeamPermissionAction {
  const AdminTeamPermissionAction({
    required this.action,
    required this.slug,
    required this.scopes,
  });
  final String action;
  final String slug;
  final List<String> scopes;
  factory AdminTeamPermissionAction.fromJson(Map<String, dynamic> json) =>
      AdminTeamPermissionAction(
        action: '${json['action'] ?? ''}',
        slug: '${json['permissionSlug'] ?? ''}',
        scopes: (json['allowedScopes'] as List? ?? [])
            .map((v) => '$v')
            .where((v) => v == 'OWN' || v == 'TENANT')
            .toList(),
      );
}

class AdminTeamPermissionFeature {
  const AdminTeamPermissionFeature({
    required this.label,
    required this.description,
    required this.actions,
  });
  final String label;
  final String description;
  final List<AdminTeamPermissionAction> actions;
  factory AdminTeamPermissionFeature.fromJson(Map<String, dynamic> json) =>
      AdminTeamPermissionFeature(
        label: '${json['label'] ?? json['key'] ?? ''}',
        description: '${json['description'] ?? ''}',
        actions: (json['actions'] as List? ?? [])
            .whereType<Map>()
            .map(
              (v) => AdminTeamPermissionAction.fromJson(
                Map<String, dynamic>.from(v),
              ),
            )
            .where((a) => a.action.isNotEmpty && a.slug.isNotEmpty)
            .toList(),
      );
}

Map<String, dynamic> unwrapAdminTeamPayload(dynamic value) {
  var map = value is Map
      ? Map<String, dynamic>.from(value)
      : <String, dynamic>{};
  for (var i = 0; i < 3 && map['data'] is Map; i++) {
    map = Map<String, dynamic>.from(map['data'] as Map);
  }
  return map;
}

List<AdminTeamPermissionFeature> parseAdminTeamFeatures(dynamic value) =>
    (unwrapAdminTeamPayload(value)['features'] as List? ?? [])
        .whereType<Map>()
        .map(
          (v) =>
              AdminTeamPermissionFeature.fromJson(Map<String, dynamic>.from(v)),
        )
        .toList();
Map<String, String> parseAdminTeamGrants(dynamic value) {
  final data = unwrapAdminTeamPayload(value);
  final role = data['role'] is Map ? data['role'] as Map : const {};
  final grants = data['grants'] ?? role['grants'];
  return {
    for (final raw in grants is List ? grants.whereType<Map>() : <Map>[])
      if (raw['permissionSlug'] is String &&
          (raw['scope'] == 'OWN' || raw['scope'] == 'TENANT'))
        raw['permissionSlug'] as String: raw['scope'] as String,
  };
}

int _weight(String? value) => value == 'TENANT'
    ? 2
    : value == 'OWN'
    ? 1
    : 0;
List<Map<String, String>> legalAdminTeamGrants(
  List<AdminTeamPermissionFeature> features,
  Map<String, String> selected,
) {
  final result = <Map<String, String>>[];
  for (final feature in features) {
    final view = feature.actions.where((a) => a.action == 'view').firstOrNull;
    final viewScope = view == null ? null : selected[view.slug];
    for (final action in feature.actions) {
      final scope = selected[action.slug];
      if (scope == null || !action.scopes.contains(scope)) continue;
      if (view != null &&
          action.action != 'view' &&
          (_weight(scope) > _weight(viewScope) ||
              !view.scopes.contains(viewScope))) {
        continue;
      }
      result.add({'permissionSlug': action.slug, 'scope': scope});
    }
  }
  result.sort((a, b) => a['permissionSlug']!.compareTo(b['permissionSlug']!));
  return result;
}

Map<String, String> changeAdminTeamGrant(
  List<AdminTeamPermissionFeature> features,
  Map<String, String> selected,
  AdminTeamPermissionAction changed,
  String? scope,
) {
  final next = Map<String, String>.from(selected);
  final feature = features
      .where((f) => f.actions.any((a) => a.slug == changed.slug))
      .firstOrNull;
  if (feature == null) return next;
  if (scope == null || !changed.scopes.contains(scope)) {
    next.remove(changed.slug);
  } else {
    next[changed.slug] = scope;
  }
  final view = feature.actions.where((a) => a.action == 'view').firstOrNull;
  if (view == null) return next;
  if (changed.action != 'view' &&
      scope != null &&
      changed.scopes.contains(scope)) {
    if (_weight(next[view.slug]) < _weight(scope) &&
        view.scopes.contains(scope)) {
      next[view.slug] = scope;
    }
  } else {
    for (final action in feature.actions.where((a) => a.action != 'view')) {
      if (next[view.slug] == null) {
        next.remove(action.slug);
      } else if (_weight(next[action.slug]) > _weight(next[view.slug])) {
        if (action.scopes.contains(next[view.slug])) {
          next[action.slug] = next[view.slug]!;
        } else {
          next.remove(action.slug);
        }
      }
    }
  }
  return next;
}
