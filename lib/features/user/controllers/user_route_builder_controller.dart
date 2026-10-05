import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/api/road_routing_client.dart';
import '../models/user_landmark_model.dart';
import '../models/user_route_stop.dart';
import '../services/user_landmark_service.dart';
import '../services/user_route_builder_service.dart';
import 'user_providers.dart';

final userRoadRouteServiceProvider = Provider.autoDispose<UserRoadRouteService>(
  (ref) {
    ref.watch(workspaceDataScopeProvider);
    final service = UserRoadRouteService();
    ref.onDispose(service.dispose);
    return service;
  },
);

final userRouteBuilderControllerProvider =
    Provider.autoDispose<UserRouteBuilderController>((ref) {
      return UserRouteBuilderController(
        ref.watch(userLandmarkServiceProvider),
        ref.watch(userRoadRouteServiceProvider),
      );
    });

/// Orchestrates persisted route data independently from ephemeral UI drafts.
class UserRouteBuilderController {
  UserRouteBuilderController(this._landmarks, this._roads);
  final UserLandmarkService _landmarks;
  final UserRoadRouteService _roads;
  Future<UserRouteLandmark> load(String id) => _landmarks.fetchRouteById(id);
  Future<UserRoadRoute> road(
    List<UserRouteStop> stops, {
    RoadRoutingRequest? request,
  }) => _roads.route(stops, request: request);
  Future<UserRouteLandmark> save({
    required String name,
    required List<UserRouteStop> stops,
    required List<UserGeoPoint> geometry,
    UserRouteLandmark? existing,
  }) {
    validateUserRouteStops(stops);
    final tolerance = existing?.toleranceMeters ?? 100;
    final geo = UserLineGeoData(coordinates: geometry, toleranceM: tolerance);
    if (existing == null) {
      return _landmarks.createRoute(
        CreateUserRouteRequest(
          name: name.trim(),
          geodata: geo,
          stops: stops,
          color: '#5F6974',
          toleranceMeters: tolerance,
        ),
      );
    }
    return _landmarks.updateRoute(
      existing.id,
      UpdateUserRouteRequest(
        name: name.trim(),
        geodata: geo,
        stops: stops,
        toleranceMeters: tolerance,
      ),
    );
  }
}

final userRouteLandmarkStopsProvider = FutureProvider.autoDispose
    .family<List<UserRouteStop>, bool>((ref, geofences) async {
      final service = ref.watch(userLandmarkServiceProvider);
      if (geofences) {
        return (await service.fetchGeofences(
          isActive: true,
        )).map(geofenceRouteStop).whereType<UserRouteStop>().toList();
      }
      return (await service.fetchPois(isActive: true))
          .where((p) => p.coordinates != null)
          .map(
            (p) => UserRouteStop(
              name: p.name,
              latitude: p.coordinates!.lat,
              longitude: p.coordinates!.lon,
              sourceType: 'POI',
              sourceId: p.id,
            ),
          )
          .where((s) => s.validCoordinates)
          .toList();
    });

/// Same circle centre, polygon vertex-average and line midpoint as the web.
/// Invalid geometry is excluded, never silently replaced with coordinate zero.
UserRouteStop? geofenceRouteStop(UserGeofence fence) {
  final geo = fence.geodata;
  UserGeoPoint? point;
  if (geo is UserCircleGeoData) {
    point = geo.center;
  } else if (geo is UserPolygonGeoData && geo.coordinates.isNotEmpty) {
    point = UserGeoPoint(
      lat:
          geo.coordinates.fold(0.0, (sum, p) => sum + p.lat) /
          geo.coordinates.length,
      lon:
          geo.coordinates.fold(0.0, (sum, p) => sum + p.lon) /
          geo.coordinates.length,
    );
  } else if (geo is UserLineGeoData && geo.coordinates.isNotEmpty) {
    point = geo.coordinates[geo.coordinates.length ~/ 2];
  }
  if (point == null) return null;
  final stop = UserRouteStop(
    name: fence.name,
    latitude: point.lat,
    longitude: point.lon,
    sourceType: 'GEOFENCE',
    sourceId: fence.id,
  );
  return stop.validCoordinates ? stop : null;
}
