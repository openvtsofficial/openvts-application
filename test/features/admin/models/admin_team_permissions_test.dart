import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_team_permissions.dart';

void main() {
  final features = parseAdminTeamFeatures({
    'features': [
      {
        'label': 'Vehicles',
        'actions': [
          {
            'action': 'view',
            'permissionSlug': 'vehicles.view',
            'allowedScopes': ['OWN', 'TENANT']
          },
          {
            'action': 'edit',
            'permissionSlug': 'vehicles.update',
            'allowedScopes': ['OWN', 'TENANT']
          },
          {
            'action': 'delete',
            'permissionSlug': 'vehicles.delete',
            'allowedScopes': ['TENANT']
          }
        ]
      }
    ]
  });
  final view = features.single.actions[0],
      edit = features.single.actions[1],
      delete = features.single.actions[2];
  test('write widens view and removal of view removes dependent grants', () {
    final selected = changeAdminTeamGrant(features, {}, edit, 'TENANT');
    expect(selected, {'vehicles.update': 'TENANT', 'vehicles.view': 'TENANT'});
    expect(changeAdminTeamGrant(features, selected, view, null), isEmpty);
  });
  test('narrowing view clamps edit and removes illegal delete scope', () {
    var selected = changeAdminTeamGrant(features, {}, delete, 'TENANT');
    selected = changeAdminTeamGrant(features, selected, edit, 'TENANT');
    selected = changeAdminTeamGrant(features, selected, view, 'OWN');
    expect(selected, {'vehicles.view': 'OWN', 'vehicles.update': 'OWN'});
  });
  test('unknown capability, unsupported scope, write without view fail closed',
      () {
    expect(
        legalAdminTeamGrants(features, {
          'unknown.view': 'TENANT',
          'vehicles.view': 'ASSIGNED',
          'vehicles.update': 'TENANT',
          'vehicles.delete': 'OWN'
        }),
        isEmpty);
  });
  test('direct grants unwrap envelope and discard inherited ASSIGNED scope',
      () {
    expect(
        parseAdminTeamGrants({
          'data': {
            'grants': [
              {'permissionSlug': 'vehicles.view', 'scope': 'OWN'},
              {'permissionSlug': 'vehicles.update', 'scope': 'ASSIGNED'}
            ]
          }
        }),
        {'vehicles.view': 'OWN'});
  });
}
