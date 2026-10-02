import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_driver_model.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';
import 'package:open_vts/features/user/models/user_subuser_model.dart';

void main() {
  const line = UserLineGeoData(coordinates: [
    UserGeoPoint(lat: 40.7, lon: -74.0),
    UserGeoPoint(lat: 40.8, lon: -74.1),
  ]);

  test('line geofence create/update use nested tolerance accepted by strict DTO', () {
    final create = const CreateUserGeofenceRequest(
      name: 'Depot route', geodata: line, toleranceMeters: 75,
    ).toJson();
    final update = const UpdateUserGeofenceRequest(
      geodata: line, toleranceMeters: 90,
    ).toJson();
    expect(create.containsKey('toleranceMeters'), isFalse);
    expect(update.containsKey('toleranceMeters'), isFalse);
    expect((create['geodata'] as Map)['toleranceM'], 75);
    expect((update['geodata'] as Map)['toleranceM'], 90);
    expect(create['type'], 'LINE');
  });

  test('driver active state uses current legacy DTO spelling and type', () {
    final disabled = const UpdateUserDriverRequest(isActive: false).toJson();
    final enabled = const UpdateUserDriverRequest(isActive: true).toJson();
    expect(disabled, {'isactive': 'false'});
    expect(enabled, {'isactive': 'true'});
  });

  test('POI selected icon reaches create and update APIs', () {
    final create = const CreateUserPoiRequest(
      name: 'Depot', category: 'warehouse', iconSlug: 'warehouse',
      coordinates: UserGeoPoint(lat: 40.7, lon: -74.0),
    ).toJson();
    expect(create['iconSlug'], 'warehouse');
    expect(const UpdateUserPoiRequest(iconSlug: 'fuel').toJson(), {'iconSlug': 'fuel'});
  });

  test('subuser creation requires a password and preserves intended characters', () {
    expect(
      () => const CreateUserSubUserRequest(name: 'Fleet user', password: '').toJson(),
      throwsArgumentError,
    );
    expect(
      const CreateUserSubUserRequest(name: 'Fleet user', password: ' secret ').toJson()['password'],
      ' secret ',
    );
  });

  test('bulk landmark requests use entity-specific row envelopes', () {
    for (final entity in UserLandmarkEntityType.values) {
      final payload = CreateUserLandmarkBulkJobRequest(
        entityType: entity,
        rows: const [{'rowNumber': 1, 'name': 'Depot'}],
      ).toJson();
      expect(payload.keys.toSet(), {'entityType', '${entity.name}Rows'});
      expect(payload['entityType'], entity.name);
    }
  });
}
