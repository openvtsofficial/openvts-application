import 'dart:math' as math;

import '../../../core/api/road_routing_client.dart';
import '../models/user_landmark_model.dart';
import '../models/user_route_stop.dart';

class UserRoadRoute {
  const UserRoadRoute({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
  final List<UserGeoPoint> points;
  final double distanceMeters;
  final double durationSeconds;
}

class UserRoadRouteException implements Exception {
  const UserRoadRouteException();
}

/// Public routing traffic is isolated from the authenticated backend client.
/// No access token, cookies, account headers, or API logging is attached here.
class UserRoadRouteService {
  UserRoadRouteService({RoadRoutingClient? routingClient})
    : _client = routingClient ?? RoadRoutingClient();
  final RoadRoutingClient _client;
  void dispose() => _client.dispose();

  Future<UserRoadRoute> route(
    List<UserRouteStop> stops, {
    RoadRoutingRequest? request,
  }) async {
    validateUserRouteStops(stops);
    final points = <UserGeoPoint>[];
    var distance = 0.0, duration = 0.0;
    try {
      for (
        var start = 0;
        start < stops.length - 1;
        start += RoadRoutingClient.maxWaypoints - 1
      ) {
        request?.throwIfCancelled();
        final chunk = stops
            .skip(start)
            .take(RoadRoutingClient.maxWaypoints)
            .toList();
        final data = await _client.drivingRoute(
          chunk
              .map((s) => (latitude: s.latitude, longitude: s.longitude))
              .toList(),
          request: request,
        );
        if (data is! Map ||
            data['code'] != 'Ok' ||
            data['routes'] is! List ||
            (data['routes'] as List).isEmpty) {
          throw const UserRoadRouteException();
        }
        final route = (data['routes'] as List).first;
        if (route is! Map ||
            route['geometry'] is! Map ||
            route['geometry']['type'] != 'LineString') {
          throw const UserRoadRouteException();
        }
        final raw = route['geometry']['coordinates'];
        final metres = route['distance'], seconds = route['duration'];
        if (raw is! List ||
            raw.length < 2 ||
            raw.length > 100000 ||
            metres is! num ||
            seconds is! num ||
            !metres.isFinite ||
            !seconds.isFinite ||
            metres < 0 ||
            seconds < 0) {
          throw const UserRoadRouteException();
        }
        final next = <UserGeoPoint>[];
        for (final pair in raw) {
          if (pair is! List ||
              pair.length < 2 ||
              pair[0] is! num ||
              pair[1] is! num) {
            throw const UserRoadRouteException();
          }
          final lon = (pair[0] as num).toDouble(),
              lat = (pair[1] as num).toDouble();
          if (!lat.isFinite ||
              !lon.isFinite ||
              lat.abs() > 90 ||
              lon.abs() > 180) {
            throw const UserRoadRouteException();
          }
          next.add(UserGeoPoint(lat: lat, lon: lon));
        }
        final waypoints = data['waypoints'];
        final legs = route['legs'];
        if (waypoints is! List ||
            waypoints.length != chunk.length ||
            legs is! List ||
            legs.length != chunk.length - 1) {
          throw const UserRoadRouteException();
        }
        final snapped = <UserGeoPoint>[];
        for (var i = 0; i < waypoints.length; i++) {
          final waypoint = waypoints[i];
          if (waypoint is! Map || waypoint['location'] is! List) {
            throw const UserRoadRouteException();
          }
          final pair = waypoint['location'] as List;
          if (pair.length < 2 || pair[0] is! num || pair[1] is! num) {
            throw const UserRoadRouteException();
          }
          final p = UserGeoPoint(
            lat: (pair[1] as num).toDouble(),
            lon: (pair[0] as num).toDouble(),
          );
          if (!p.lat.isFinite ||
              !p.lon.isFinite ||
              p.lat.abs() > 90 ||
              p.lon.abs() > 180 ||
              _metres(
                    p,
                    UserGeoPoint(
                      lat: chunk[i].latitude,
                      lon: chunk[i].longitude,
                    ),
                  ) >
                  RoadRoutingClient.snapRadiusMeters + 1) {
            throw const UserRoadRouteException();
          }
          snapped.add(p);
        }
        if (_metres(next.first, snapped.first) > 5 ||
            _metres(next.last, snapped.last) > 5) {
          throw const UserRoadRouteException();
        }
        // Consecutive chunks overlap at one waypoint. Never invent connectors
        // across disconnected or malformed provider geometries.
        if (points.isNotEmpty &&
            !points.last.isCloseTo(next.first, epsilon: 0.0001)) {
          throw const UserRoadRouteException();
        }
        points.addAll(points.isEmpty ? next : next.skip(1));
        distance += metres;
        duration += seconds;
      }
      request?.throwIfCancelled();
      if (points.length < 2) throw const UserRoadRouteException();
      return UserRoadRoute(
        points: List.unmodifiable(points),
        distanceMeters: distance,
        durationSeconds: duration,
      );
    } on RoadRoutingTransportException {
      throw const UserRoadRouteException();
    }
  }
}

double _metres(UserGeoPoint a, UserGeoPoint b) {
  final lat = (b.lat - a.lat) * math.pi / 180,
      lon = (b.lon - a.lon) * math.pi / 180;
  final h =
      math.pow(math.sin(lat / 2), 2) +
      math.cos(a.lat * math.pi / 180) *
          math.cos(b.lat * math.pi / 180) *
          math.pow(math.sin(lon / 2), 2);
  return 12742000 * math.asin(math.sqrt(h.clamp(0, 1)));
}
