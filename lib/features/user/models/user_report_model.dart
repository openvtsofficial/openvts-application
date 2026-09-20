enum UserReportKey {
  distance,
  driven,
  overspeed,
  geofence,
  sensor,
  alerts,
  logs,
  timeline,
  details,
}

extension UserReportKeyMetadata on UserReportKey {
  String get apiValue => name;

  String get label {
    switch (this) {
      case UserReportKey.distance:
        return 'Distance';
      case UserReportKey.driven:
        return 'Driven';
      case UserReportKey.overspeed:
        return 'Overspeed';
      case UserReportKey.geofence:
        return 'Geofence';
      case UserReportKey.sensor:
        return 'Sensor';
      case UserReportKey.alerts:
        return 'Alerts';
      case UserReportKey.logs:
        return 'Device logs';
      case UserReportKey.timeline:
        return 'Timeline';
      case UserReportKey.details:
        return 'Details';
    }
  }

  bool get usesDateOnly =>
      this == UserReportKey.distance ||
      this == UserReportKey.timeline ||
      this == UserReportKey.details;

  bool get requiresSingleVehicle =>
      this == UserReportKey.sensor || this == UserReportKey.logs;

  int get maxDays {
    switch (this) {
      case UserReportKey.overspeed:
      case UserReportKey.timeline:
      case UserReportKey.logs:
        return 7;
      case UserReportKey.sensor:
        return 30;
      case UserReportKey.distance:
      case UserReportKey.driven:
      case UserReportKey.details:
        return 31;
      case UserReportKey.geofence:
      case UserReportKey.alerts:
        return 90;
    }
  }

  String? get chartMetric {
    switch (this) {
      case UserReportKey.distance:
      case UserReportKey.driven:
        return 'distanceKm';
      case UserReportKey.overspeed:
        return 'maxSpeedKmh';
      case UserReportKey.geofence:
      case UserReportKey.alerts:
      case UserReportKey.logs:
        return null;
      case UserReportKey.sensor:
        return 'value';
      case UserReportKey.timeline:
        return 'durationSeconds';
      case UserReportKey.details:
        return 'distanceKm';
    }
  }

  String? get chartCategory {
    switch (this) {
      case UserReportKey.geofence:
        return 'event';
      case UserReportKey.alerts:
        return 'severity';
      case UserReportKey.logs:
        return 'level';
      case UserReportKey.distance:
      case UserReportKey.driven:
      case UserReportKey.overspeed:
      case UserReportKey.sensor:
      case UserReportKey.timeline:
      case UserReportKey.details:
        return null;
    }
  }

  Map<String, String> get columnLabels => const {
        'vehicleName': 'Vehicle',
        'vehicleNumber': 'Vehicle No.',
        'date': 'Date',
        'distanceKm': 'Distance (km)',
        'engineHoursSeconds': 'Engine Hours (s)',
        'firstMovement': 'First Movement',
        'lastMovement': 'Last Movement',
        'startAddress': 'Start Address',
        'endAddress': 'End Address',
        'startLat': 'Start Lat',
        'startLon': 'Start Lon',
        'endLat': 'End Lat',
        'endLon': 'End Lon',
        'odometerStartKm': 'Odometer Start (km)',
        'odometerEndKm': 'Odometer End (km)',
        'durationSeconds': 'Duration (s)',
        'maxSpeedKmh': 'Max Speed (km/h)',
        'avgSpeedKmh': 'Avg Speed (km/h)',
        'startedAt': 'Started At',
        'endedAt': 'Ended At',
        'address': 'Address',
        'lat': 'Latitude',
        'lon': 'Longitude',
        'configuredLimitKmh': 'Speed Limit (km/h)',
        'excessKmh': 'Excess (km/h)',
        'geofenceName': 'Geofence',
        'event': 'Event',
        'timestamp': 'Time',
        'sensorLabel': 'Sensor',
        'sensorId': 'Sensor ID',
        'value': 'Value',
        'state': 'State',
        'unit': 'Unit',
        'id': 'ID',
        'vehicleId': 'Vehicle ID',
        'alertType': 'Alert Type',
        'severity': 'Severity',
        'message': 'Message',
        'acknowledged': 'Acknowledged',
        'speedKmh': 'Speed (km/h)',
        'category': 'Category',
        'level': 'Level',
        'direction': 'Direction',
        'protocol': 'Protocol',
        'rawPayload': 'Payload',
        'payload': 'Payload',
        'dayDistanceKm': 'Day Distance (km)',
        'nightDistanceKm': 'Night Distance (km)',
        'dayEngineHoursSeconds': 'Day Engine Hours (s)',
        'nightEngineHoursSeconds': 'Night Engine Hours (s)',
        'totalTrips': 'Trips',
        'lastLocation': 'Last Location',
      };

  List<String> get preferredColumns {
    switch (this) {
      case UserReportKey.distance:
        return const [
          'vehicleName',
          'date',
          'distanceKm',
          'startAddress',
          'endAddress',
        ];
      case UserReportKey.driven:
        return const [
          'vehicleName',
          'date',
          'durationSeconds',
          'distanceKm',
          'maxSpeedKmh',
          'avgSpeedKmh',
        ];
      case UserReportKey.overspeed:
        return const [
          'vehicleName',
          'startedAt',
          'endedAt',
          'durationSeconds',
          'maxSpeedKmh',
          'address',
        ];
      case UserReportKey.geofence:
        return const [
          'vehicleName',
          'geofenceName',
          'event',
          'timestamp',
          'address',
        ];
      case UserReportKey.sensor:
        return const [
          'vehicleName',
          'sensorLabel',
          'value',
          'state',
          'unit',
          'timestamp',
        ];
      case UserReportKey.alerts:
        return const [
          'vehicleName',
          'alertType',
          'severity',
          'message',
          'timestamp',
          'acknowledged',
        ];
      case UserReportKey.logs:
        return const [
          'timestamp',
          'category',
          'level',
          'direction',
          'event',
          'message',
          'protocol',
        ];
      case UserReportKey.timeline:
        return const [
          'vehicleName',
          'state',
          'startedAt',
          'endedAt',
          'durationSeconds',
          'distanceKm',
          'maxSpeedKmh',
        ];
      case UserReportKey.details:
        return const [
          'vehicleName',
          'date',
          'distanceKm',
          'engineHoursSeconds',
          'maxSpeedKmh',
          'lastLocation',
        ];
    }
  }
}

class UserReportVehicleOption {
  const UserReportVehicleOption({
    required this.id,
    required this.name,
    required this.imei,
    this.plateNumber,
  });

  final String id;
  final String name;
  final String imei;
  final String? plateNumber;

  String get displayName {
    final plate = plateNumber?.trim();
    return plate == null || plate.isEmpty ? name : '$name · $plate';
  }

  factory UserReportVehicleOption.fromJson(dynamic json) {
    final map = reportMap(json);
    return UserReportVehicleOption(
      id: reportText(map['id']),
      name: reportText(map['name'], fallback: 'Vehicle'),
      imei: reportText(map['imei']),
      plateNumber: reportNullableText(map['plateNumber']),
    );
  }
}

class UserReportGroupOption {
  const UserReportGroupOption({
    required this.id,
    required this.name,
    required this.vehicleCount,
  });

  final String id;
  final String name;
  final int vehicleCount;

  factory UserReportGroupOption.fromJson(dynamic json) {
    final map = reportMap(json);
    return UserReportGroupOption(
      id: reportText(map['id']),
      name: reportText(map['name'], fallback: 'Group'),
      vehicleCount: reportInt(map['vehicleCount']),
    );
  }
}

class UserReportOptions {
  const UserReportOptions({
    required this.vehicles,
    required this.groups,
  });

  final List<UserReportVehicleOption> vehicles;
  final List<UserReportGroupOption> groups;

  factory UserReportOptions.fromJson(dynamic json) {
    final map = reportMap(json);
    return UserReportOptions(
      vehicles: reportList(map['vehicles'])
          .map(UserReportVehicleOption.fromJson)
          .where((vehicle) => vehicle.id.isNotEmpty)
          .toList(growable: false),
      groups: reportList(map['groups'])
          .map(UserReportGroupOption.fromJson)
          .where((group) => group.id.isNotEmpty)
          .toList(growable: false),
    );
  }
}

class UserReportPage {
  const UserReportPage({
    required this.rows,
    required this.generatedAt,
    required this.hasMore,
    this.nextCursor,
    this.warning,
    this.source,
  });

  final List<Map<String, dynamic>> rows;
  final DateTime? generatedAt;
  final bool hasMore;
  final String? nextCursor;
  final String? warning;
  final String? source;

  factory UserReportPage.fromJson(dynamic json) {
    final map = reportMap(json);
    final meta = reportMap(map['meta']);
    return UserReportPage(
      rows: reportList(map['rows'])
          .map(reportMap)
          .where((row) => row.isNotEmpty)
          .toList(growable: false),
      generatedAt: DateTime.tryParse(reportText(meta['generatedAt'])),
      hasMore: reportBool(meta['hasMore']),
      nextCursor: reportNullableText(meta['nextCursor']),
      warning: reportNullableText(meta['warning']),
      source: reportNullableText(meta['source']),
    );
  }
}

class UserTimelinePoint {
  const UserTimelinePoint({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  final DateTime? timestamp;
  final double latitude;
  final double longitude;

  factory UserTimelinePoint.fromJson(dynamic json) {
    final map = reportMap(json);
    return UserTimelinePoint(
      timestamp: DateTime.tryParse(reportText(map['t'])),
      latitude: reportDouble(map['lat']),
      longitude: reportDouble(map['lon']),
    );
  }

  bool get isValid =>
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}

Map<String, dynamic> reportMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return <String, dynamic>{};
}

List<dynamic> reportList(dynamic value) =>
    value is List ? value : const <dynamic>[];

String reportText(dynamic value, {String fallback = ''}) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? fallback : text;
}

String? reportNullableText(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int reportInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double reportDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool reportBool(dynamic value) {
  if (value is bool) return value;
  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}
