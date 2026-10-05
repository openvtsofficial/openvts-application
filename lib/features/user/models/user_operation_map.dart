import 'package:latlong2/latlong.dart';

class UserOperationMapStop {
  const UserOperationMapStop({
    required this.point,
    required this.sequence,
    required this.name,
    required this.status,
  });
  final LatLng point;
  final int sequence;
  final String name;
  final String status;
}

/// Parses the current Operations DTO, whose route is nested GeoJSON
/// `route.geometry` in [longitude, latitude] order, not driver routeGeometry.
class UserOperationMapData {
  const UserOperationMapData({
    required this.stops,
    required this.route,
    required this.exactRoute,
    required this.position,
    required this.trackingStatus,
    required this.recordedAt,
    this.timezone = '',
  });
  final List<UserOperationMapStop> stops;
  final List<LatLng> route;
  final bool exactRoute;
  final LatLng? position;
  final String trackingStatus;
  final DateTime? recordedAt;
  final String timezone;
  List<LatLng> get bounds => [
    for (final stop in stops) stop.point,
    ...route,
    if (position != null) position!,
  ];

  factory UserOperationMapData.fromJson(Map<String, dynamic> trip) {
    final stops = <UserOperationMapStop>[];
    if (trip['stops'] is List) {
      for (final value in trip['stops'] as List) {
        if (value is! Map) continue;
        final point = _point(value['latitude'], value['longitude']);
        if (point != null) {
          stops.add(
            UserOperationMapStop(
              point: point,
              sequence:
                  int.tryParse('${value['sequence']}') ?? stops.length + 1,
              name: '${value['name'] ?? 'Stop'}',
              status: '${value['status'] ?? ''}',
            ),
          );
        }
      }
    }
    final routeData = trip['route'] is Map ? trip['route'] as Map : const {};
    final geometry = routeData['geometry'] is Map
        ? routeData['geometry'] as Map
        : const {};
    final route = <LatLng>[];
    if (geometry['type'] == 'LineString' && geometry['coordinates'] is List) {
      for (final value in geometry['coordinates'] as List) {
        final point = value is List && value.length >= 2
            ? _point(value[1], value[0])
            : null;
        // Never bridge an invalid/missing segment with an invented straight line.
        if (point == null) {
          route.clear();
          break;
        }
        route.add(point);
      }
    }
    final current = trip['currentPosition'] is Map
        ? trip['currentPosition'] as Map
        : const {};
    final tracking = trip['tracking'] is Map
        ? trip['tracking'] as Map
        : const {};
    return UserOperationMapData(
      stops: List.unmodifiable(stops),
      route: List.unmodifiable(route),
      exactRoute:
          routeData['exact'] == true &&
          routeData['source'] == 'OPTIMIZED_ROUTE',
      position: _point(current['latitude'], current['longitude']),
      trackingStatus: '${tracking['status'] ?? 'UNAVAILABLE'}',
      timezone: '${trip['timezone'] ?? ''}',
      recordedAt: DateTime.tryParse(
        '${tracking['lastPositionAt'] ?? current['recordedAt'] ?? trip['lastTelemetryAt'] ?? ''}',
      ),
    );
  }
  static LatLng? _point(dynamic latitude, dynamic longitude) {
    final lat = double.tryParse('$latitude'),
        lon = double.tryParse('$longitude');
    if (lat == null ||
        lon == null ||
        !lat.isFinite ||
        !lon.isFinite ||
        lat.abs() > 90 ||
        lon.abs() > 180) {
      return null;
    }
    return LatLng(lat, lon);
  }
}
