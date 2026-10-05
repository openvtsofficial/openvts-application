/// Backend RouteStopDto; geographic inputs stay separate from routed vertices.
class UserRouteStop {
  const UserRouteStop({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.type = 'WAYPOINT',
    this.sourceType = 'MANUAL',
    this.sourceId,
    this.geofenceRadiusMeters = 50,
    this.expectedDwellSeconds = 0,
    this.sequence = 0,
  });
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String type;
  final String sourceType;
  final String? sourceId;
  final int geofenceRadiusMeters;
  final int expectedDwellSeconds;
  final int sequence;
  bool get isVia => sourceType.toUpperCase() == 'VIA';
  bool get validCoordinates =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude.abs() <= 90 &&
      longitude.abs() <= 180;

  UserRouteStop withType(String next) => UserRouteStop(
    name: name,
    latitude: latitude,
    longitude: longitude,
    address: address,
    type: next,
    sourceType: sourceType,
    sourceId: sourceId,
    geofenceRadiusMeters: geofenceRadiusMeters,
    expectedDwellSeconds: expectedDwellSeconds,
    sequence: sequence,
  );

  Map<String, dynamic> toJson() => {
    'name': name.trim(),
    'latitude': latitude,
    'longitude': longitude,
    'type': type,
    'sourceType': sourceType,
    if (address?.trim().isNotEmpty == true) 'address': address!.trim(),
    if (sourceId != null) 'sourceId': sourceId,
    'geofenceRadiusMeters': geofenceRadiusMeters,
    'expectedDwellSeconds': expectedDwellSeconds,
  };

  factory UserRouteStop.fromJson(Map<dynamic, dynamic> json) => UserRouteStop(
    name: '${json['name'] ?? ''}',
    latitude: double.tryParse('${json['latitude']}') ?? double.nan,
    longitude: double.tryParse('${json['longitude']}') ?? double.nan,
    address: json['address']?.toString(),
    type: '${json['type'] ?? 'WAYPOINT'}',
    sourceType: '${json['sourceType'] ?? 'MAP'}',
    sourceId: json['sourceId']?.toString(),
    geofenceRadiusMeters: int.tryParse('${json['geofenceRadiusMeters']}') ?? 50,
    expectedDwellSeconds: int.tryParse('${json['expectedDwellSeconds']}') ?? 0,
    sequence: int.tryParse('${json['sequence']}') ?? 0,
  );

  static List<UserRouteStop> listFromJson(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map(UserRouteStop.fromJson).toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
  }
}

void validateUserRouteStops(List<UserRouteStop> stops) {
  if (stops.length < 2 || stops.length > 100) {
    throw ArgumentError('A route requires 2 to 100 stops.');
  }
  for (final stop in stops) {
    if (!stop.validCoordinates ||
        stop.name.trim().isEmpty ||
        stop.name.trim().length > 160 ||
        (stop.address?.length ?? 0) > 300 ||
        stop.geofenceRadiusMeters < 50 ||
        stop.geofenceRadiusMeters > 2000 ||
        stop.expectedDwellSeconds < 0 ||
        stop.expectedDwellSeconds > 86400 ||
        !const ['ORIGIN', 'WAYPOINT', 'DESTINATION'].contains(stop.type) ||
        stop.sourceType.length > 40 ||
        (stop.sourceId?.length ?? 0) > 100) {
      throw ArgumentError('Invalid route stop.');
    }
  }
}

List<UserRouteStop> routeStopsForSave(
  List<UserRouteStop> points, {
  required bool roundTrip,
}) {
  if (points.isNotEmpty &&
      (points.first.isVia || (!roundTrip && points.last.isVia))) {
    throw ArgumentError('A route must start and end at operational stops.');
  }
  final regular = points.where((point) => !point.isVia).toList();
  if (regular.length < 2 ||
      !regular
          .skip(1)
          .any(
            (s) =>
                (s.latitude - regular.first.latitude).abs() > 0.000001 ||
                (s.longitude - regular.first.longitude).abs() > 0.000001,
          )) {
    throw ArgumentError('At least two distinct stops are required.');
  }
  final result = points
      .map(
        (point) => point.withType(
          point == regular.first
              ? 'ORIGIN'
              : !roundTrip && point == regular.last
              ? 'DESTINATION'
              : 'WAYPOINT',
        ),
      )
      .toList();
  if (roundTrip) result.add(regular.first.withType('DESTINATION'));
  validateUserRouteStops(result);
  return result;
}
