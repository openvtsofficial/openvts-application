Map<String, dynamic> driverMap(dynamic value) => value is Map
    ? value.map((key, value) => MapEntry(key.toString(), value))
    : <String, dynamic>{};
List<Map<String, dynamic>> driverItems(dynamic value) => value is List
    ? value.whereType<Map>().map(driverMap).toList(growable: false)
    : const [];
String driverText(dynamic value, [String fallback = '']) =>
    value?.toString() ?? fallback;
int driverInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
double driverNumber(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
String driverStatusLabel(String value) => switch (value) {
      'ASSIGNED' => 'Assigned',
      'ACKNOWLEDGED' => 'Acknowledged',
      'IN_PROGRESS' => 'In progress',
      'COMPLETED' => 'Completed',
      'FAILED' => 'Failed',
      'CANCELLED' => 'Cancelled',
      'PENDING' => 'Pending',
      'ARRIVED' => 'Arrived',
      'SKIPPED' => 'Skipped',
      'ON_TRIP' => 'On a trip',
      'READY' => 'Ready',
      'NO_ASSIGNMENT' => 'No assignment',
      _ => value,
    };

/// Bigint IDs remain strings; route order and action eligibility mirror the API.
class DriverStop {
  DriverStop.fromJson(Map<String, dynamic> json)
      : id = driverText(json['id']),
        sequence = driverInt(json['sequence']),
        name = driverText(json['name'], 'Stop'),
        address = driverText(json['address']),
        status = driverText(json['status']),
        type = driverText(json['type']),
        latitude = double.tryParse('${json['latitude']}'),
        longitude = double.tryParse('${json['longitude']}'),
        plannedAt = DateTime.tryParse(driverText(json['plannedAt']));
  final String id, name, address, status, type;
  final int sequence;
  final double? latitude, longitude;
  final DateTime? plannedAt;
  bool get pending => status == 'PENDING' || status == 'ARRIVED';
  bool get hasPosition =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180;
}

class DriverTrip {
  DriverTrip.fromJson(Map<String, dynamic> json)
      : raw = Map.unmodifiable(json),
        id = driverText(json['id']),
        title = driverText(json['title'], 'Trip'),
        referenceCode = driverText(json['referenceCode']),
        status = driverText(json['status']),
        instructions = driverText(json['instructions']),
        timezone = driverText(json['timezone'], 'UTC'),
        scheduledStart =
            DateTime.tryParse(driverText(json['scheduledStartAt'])),
        scheduledEnd = DateTime.tryParse(driverText(json['scheduledEndAt'])),
        serviceDate = DateTime.tryParse(driverText(json['serviceDate'])),
        stops = driverItems(json['stops']).map(DriverStop.fromJson).toList()
          ..sort((a, b) => a.sequence.compareTo(b.sequence)),
        proofs = driverItems(json['proofs']),
        events = driverItems(json['events']);
  final Map<String, dynamic> raw;
  final String id, title, referenceCode, status, instructions, timezone;
  final DateTime? scheduledStart, scheduledEnd, serviceDate;
  final List<DriverStop> stops;
  final List<Map<String, dynamic>> proofs, events;
  bool get canAcknowledge => status == 'ASSIGNED';
  bool get canStart => status == 'ASSIGNED' || status == 'ACKNOWLEDGED';
  bool get canUploadProof => status == 'IN_PROGRESS' || status == 'COMPLETED';
  DriverStop? get currentStop {
    for (final stop in stops) {
      if (stop.pending) return stop;
    }
    return null;
  }

  bool canComplete(DriverStop stop) =>
      status == 'IN_PROGRESS' && currentStop?.id == stop.id;
  String get vehicleLabel {
    final vehicle = driverMap(raw['vehicle']);
    return [vehicle['name'], vehicle['plateNumber']]
        .where((v) => v != null && '$v'.isNotEmpty)
        .join(' · ');
  }

  double get progress =>
      (driverNumber(driverMap(raw['progress'])['percent']) / 100)
          .clamp(0, 1)
          .toDouble();
  Uri? get navigationUri {
    if (stops.isEmpty || stops.any((s) => !s.hasPosition)) return null;
    return Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${stops.last.latitude},${stops.last.longitude}',
      if (stops.length > 1)
        'origin': '${stops.first.latitude},${stops.first.longitude}',
      if (stops.length > 2)
        'waypoints': stops
            .skip(1)
            .take(stops.length - 2)
            .map((s) => '${s.latitude},${s.longitude}')
            .join('|'),
    });
  }
}

class DriverTripsPage {
  DriverTripsPage.fromJson(dynamic value)
      : items = driverItems(driverMap(value)['items'])
            .map(DriverTrip.fromJson)
            .toList(growable: false),
        page = driverInt(driverMap(value)['page']),
        total = driverInt(driverMap(value)['total']),
        totalPages = driverInt(driverMap(value)['totalPages']);
  final List<DriverTrip> items;
  final int page, total, totalPages;
}

class DriverTripsQuery {
  const DriverTripsQuery(
      {this.scope = 'today', this.page = 1, this.search = ''});
  final String scope, search;
  final int page;
  @override
  bool operator ==(Object other) =>
      other is DriverTripsQuery &&
      other.scope == scope &&
      other.page == page &&
      other.search == search;
  @override
  int get hashCode => Object.hash(scope, page, search);
}
