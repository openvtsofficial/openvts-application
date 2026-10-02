import 'user_landmark_model.dart';
import 'user_report_model.dart';
import 'user_vehicle_model.dart';

// ---------------------------------------------------------------------------
// Vehicle scope
// ---------------------------------------------------------------------------

enum ReportScopeMode { all, single, multiple, group }

class ReportVehicleScope {
  const ReportVehicleScope.all()
      : mode = ReportScopeMode.all,
        vehicleId = null,
        vehicleIds = const [],
        groupId = null;
  const ReportVehicleScope.single(String id)
      : mode = ReportScopeMode.single,
        vehicleId = id,
        vehicleIds = const [],
        groupId = null;
  const ReportVehicleScope.multiple(List<String> ids)
      : mode = ReportScopeMode.multiple,
        vehicleId = null,
        vehicleIds = ids,
        groupId = null;
  const ReportVehicleScope.group(String id)
      : mode = ReportScopeMode.group,
        vehicleId = null,
        vehicleIds = const [],
        groupId = id;

  final ReportScopeMode mode;
  final String? vehicleId;
  final List<String> vehicleIds;
  final String? groupId;

  Map<String, dynamic> toJson() {
    return switch (mode) {
      ReportScopeMode.all => {'mode': 'all'},
      ReportScopeMode.single => {
          'mode': 'single',
          'vehicleId': _toIntOrString(vehicleId),
        },
      ReportScopeMode.multiple => {
          'mode': 'multiple',
          'vehicleIds': vehicleIds.map(_toIntOrString).toList(),
        },
      ReportScopeMode.group => {
          'mode': 'group',
          'groupId': _toIntOrString(groupId),
        },
    };
  }

  /// Backend DTOs expect numeric IDs. Parse to int when possible so NestJS
  /// @Type(() => Number) coercion on nested objects works reliably.
  static dynamic _toIntOrString(String? s) {
    if (s == null || s.isEmpty) return s;
    final n = int.tryParse(s);
    return n ?? s;
  }
}

// ---------------------------------------------------------------------------
// Date range
// ---------------------------------------------------------------------------

class ReportDateRange {
  const ReportDateRange.dateOnly(
      {required this.startDate, required this.endDate})
      : mode = 'dateOnly',
        fromISO = null,
        toISO = null;
  const ReportDateRange.dateTime({required String from, required String to})
      : mode = 'dateTime',
        fromISO = from,
        toISO = to,
        startDate = null,
        endDate = null;

  final String mode;
  // dateOnly fields
  final String? startDate; // YYYY-MM-DD
  final String? endDate; // YYYY-MM-DD
  // dateTime fields
  final String? fromISO;
  final String? toISO;

  Map<String, dynamic> toJson() {
    if (mode == 'dateOnly') {
      return {'mode': 'dateOnly', 'startDate': startDate, 'endDate': endDate};
    }
    return {'mode': 'dateTime', 'fromISO': fromISO, 'toISO': toISO};
  }
}

// ---------------------------------------------------------------------------
// Per-report filter payloads
// ---------------------------------------------------------------------------

class OverspeedFilters {
  const OverspeedFilters({this.speedLimitKmh = 120});
  final int speedLimitKmh;
  Map<String, dynamic> toJson() => {'speedLimitKmh': speedLimitKmh};
}

class GeofenceFilters {
  const GeofenceFilters({this.geofenceIds = const []});
  final List<String> geofenceIds;
  Map<String, dynamic> toJson() => {'geofenceIds': geofenceIds};
}

class SensorFilters {
  const SensorFilters({this.sensorIds = const []});
  final List<String> sensorIds;
  Map<String, dynamic> toJson() => {'sensorIds': sensorIds};
}

class AlertsFilters {
  const AlertsFilters({
    this.alertTypes = const [],
    this.severities = const [],
    this.acknowledged = 'all',
  });
  final List<String> alertTypes;
  final List<String> severities;
  final String acknowledged; // 'all' | 'yes' | 'no'
  Map<String, dynamic> toJson() => {
        'alertTypes': alertTypes,
        'severities': severities,
        'acknowledged': acknowledged,
      };
}

class LogsFilters {
  const LogsFilters({
    this.categories = const [],
    this.levels = const [],
    this.directions = const [],
    this.search = '',
  });
  final List<String> categories;
  final List<String> levels;
  final List<String> directions;
  final String search;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'categories': categories,
      'levels': levels,
      'directions': directions,
    };
    // Backend requires min 3 chars; omit if shorter to avoid 400.
    final trimmed = search.trim();
    if (trimmed.length >= 3) map['search'] = trimmed;
    return map;
  }
}

class TimelineFilters {
  const TimelineFilters({this.states = const ['running', 'stopped']});
  final List<String> states;
  Map<String, dynamic> toJson() => {'states': states};
}

// ---------------------------------------------------------------------------
// Generation status
// ---------------------------------------------------------------------------

enum ReportGenStatus { initial, loading, success, empty, error }

// ---------------------------------------------------------------------------
// Workspace state
// ---------------------------------------------------------------------------

class UserReportWorkspaceState {
  const UserReportWorkspaceState({
    required this.reportKey,
    this.options,
    this.optionsError,
    this.isLoadingOptions = false,
    this.scope = const ReportVehicleScope.all(),
    this.dateRange,
    this.overspeedFilters = const OverspeedFilters(),
    this.geofenceFilters = const GeofenceFilters(),
    this.sensorFilters = const SensorFilters(),
    this.alertsFilters = const AlertsFilters(),
    this.logsFilters = const LogsFilters(),
    this.timelineFilters = const TimelineFilters(),
    this.genStatus = ReportGenStatus.initial,
    this.rows = const [],
    this.hasMore = false,
    this.nextCursor,
    this.warning,
    this.source,
    this.generatedAt,
    this.genError,
    this.loadMoreError,
    this.isLoadingMore = false,
    this.validationErrors = const {},
    // sensor/geofence auxiliary
    this.sensors = const [],
    this.isLoadingSensors = false,
    this.sensorLoadError,
    this.geofences = const [],
    this.isLoadingGeofences = false,
    this.requestToken = 0,
  });

  final UserReportKey reportKey;
  final UserReportOptions? options;
  final String? optionsError;
  final bool isLoadingOptions;

  final ReportVehicleScope scope;
  final ReportDateRange? dateRange;

  final OverspeedFilters overspeedFilters;
  final GeofenceFilters geofenceFilters;
  final SensorFilters sensorFilters;
  final AlertsFilters alertsFilters;
  final LogsFilters logsFilters;
  final TimelineFilters timelineFilters;

  final ReportGenStatus genStatus;
  final List<Map<String, dynamic>> rows;
  final bool hasMore;
  final String? nextCursor;
  final String? warning;
  final String? source;
  final DateTime? generatedAt;
  final String? genError;
  final String? loadMoreError;
  final bool isLoadingMore;
  final Map<String, String> validationErrors;

  final List<UserVehicleSensor> sensors;
  final bool isLoadingSensors;
  final String? sensorLoadError;
  final List<UserGeofence> geofences;
  final bool isLoadingGeofences;

  final int requestToken;

  UserReportWorkspaceState copyWith({
    UserReportKey? reportKey,
    UserReportOptions? options,
    String? optionsError,
    bool? isLoadingOptions,
    ReportVehicleScope? scope,
    ReportDateRange? dateRange,
    OverspeedFilters? overspeedFilters,
    GeofenceFilters? geofenceFilters,
    SensorFilters? sensorFilters,
    AlertsFilters? alertsFilters,
    LogsFilters? logsFilters,
    TimelineFilters? timelineFilters,
    ReportGenStatus? genStatus,
    List<Map<String, dynamic>>? rows,
    bool? hasMore,
    String? nextCursor,
    String? warning,
    String? source,
    DateTime? generatedAt,
    String? genError,
    String? loadMoreError,
    bool? isLoadingMore,
    Map<String, String>? validationErrors,
    List<UserVehicleSensor>? sensors,
    bool? isLoadingSensors,
    String? sensorLoadError,
    List<UserGeofence>? geofences,
    bool? isLoadingGeofences,
    int? requestToken,
    // sentinels for nullable clears
    bool clearOptionsError = false,
    bool clearNextCursor = false,
    bool clearWarning = false,
    bool clearSource = false,
    bool clearGenError = false,
    bool clearLoadMoreError = false,
    bool clearDateRange = false,
    bool clearGeneratedAt = false,
    bool clearSensorLoadError = false,
  }) {
    return UserReportWorkspaceState(
      reportKey: reportKey ?? this.reportKey,
      options: options ?? this.options,
      optionsError:
          clearOptionsError ? null : (optionsError ?? this.optionsError),
      isLoadingOptions: isLoadingOptions ?? this.isLoadingOptions,
      scope: scope ?? this.scope,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      overspeedFilters: overspeedFilters ?? this.overspeedFilters,
      geofenceFilters: geofenceFilters ?? this.geofenceFilters,
      sensorFilters: sensorFilters ?? this.sensorFilters,
      alertsFilters: alertsFilters ?? this.alertsFilters,
      logsFilters: logsFilters ?? this.logsFilters,
      timelineFilters: timelineFilters ?? this.timelineFilters,
      genStatus: genStatus ?? this.genStatus,
      rows: rows ?? this.rows,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      warning: clearWarning ? null : (warning ?? this.warning),
      source: clearSource ? null : (source ?? this.source),
      generatedAt: clearGeneratedAt ? null : (generatedAt ?? this.generatedAt),
      genError: clearGenError ? null : (genError ?? this.genError),
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      validationErrors: validationErrors ?? this.validationErrors,
      sensors: sensors ?? this.sensors,
      isLoadingSensors: isLoadingSensors ?? this.isLoadingSensors,
      sensorLoadError: clearSensorLoadError
          ? null
          : (sensorLoadError ?? this.sensorLoadError),
      geofences: geofences ?? this.geofences,
      isLoadingGeofences: isLoadingGeofences ?? this.isLoadingGeofences,
      requestToken: requestToken ?? this.requestToken,
    );
  }
}

// ---------------------------------------------------------------------------
// Typed row adapters
// ---------------------------------------------------------------------------

class DistanceRow {
  const DistanceRow({
    required this.raw,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.date,
    required this.distanceKm,
    required this.engineHoursSeconds,
    this.firstMovement,
    this.lastMovement,
    this.startAddress,
    this.endAddress,
    this.startLat,
    this.startLon,
    this.endLat,
    this.endLon,
    this.odometerStartKm,
    this.odometerEndKm,
  });

  final Map<String, dynamic> raw;
  final String vehicleName;
  final String vehicleNumber;
  final String date;
  final double distanceKm;
  final double engineHoursSeconds;
  final String? firstMovement;
  final String? lastMovement;
  final String? startAddress;
  final String? endAddress;
  final double? startLat;
  final double? startLon;
  final double? endLat;
  final double? endLon;
  final double? odometerStartKm;
  final double? odometerEndKm;

  factory DistanceRow.fromMap(Map<String, dynamic> m) => DistanceRow(
        raw: m,
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        vehicleNumber: reportText(m['vehicleNumber']),
        date: reportText(m['date']),
        distanceKm: reportDouble(m['distanceKm']),
        engineHoursSeconds: reportDouble(m['engineHoursSeconds']),
        firstMovement: reportNullableText(m['firstMovement']),
        lastMovement: reportNullableText(m['lastMovement']),
        startAddress: reportNullableText(m['startAddress']),
        endAddress: reportNullableText(m['endAddress']),
        startLat: _nullDouble(m['startLat']),
        startLon: _nullDouble(m['startLon']),
        endLat: _nullDouble(m['endLat']),
        endLon: _nullDouble(m['endLon']),
        odometerStartKm: _nullDouble(m['odometerStartKm']),
        odometerEndKm: _nullDouble(m['odometerEndKm']),
      );
}

class DrivenRow {
  const DrivenRow(
      {required this.raw,
      required this.vehicleName,
      required this.date,
      required this.distanceKm,
      required this.durationSeconds,
      required this.maxSpeedKmh,
      required this.avgSpeedKmh});
  final Map<String, dynamic> raw;
  final String vehicleName;
  final String date;
  final double distanceKm;
  final double durationSeconds;
  final double maxSpeedKmh;
  final double avgSpeedKmh;
  factory DrivenRow.fromMap(Map<String, dynamic> m) => DrivenRow(
        raw: m,
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        date: reportText(m['date']),
        distanceKm: reportDouble(m['distanceKm']),
        durationSeconds: reportDouble(m['durationSeconds']),
        maxSpeedKmh: reportDouble(m['maxSpeedKmh']),
        avgSpeedKmh: reportDouble(m['avgSpeedKmh']),
      );
}

class DetailsRow {
  const DetailsRow(
      {required this.raw,
      required this.vehicleName,
      required this.date,
      required this.distanceKm,
      required this.engineHoursSeconds,
      required this.dayDistanceKm,
      required this.nightDistanceKm,
      required this.dayEngineHoursSeconds,
      required this.nightEngineHoursSeconds,
      required this.maxSpeedKmh,
      required this.avgSpeedKmh,
      required this.totalTrips,
      this.startAddress,
      this.endAddress,
      this.startLat,
      this.startLon,
      this.endLat,
      this.endLon});
  final Map<String, dynamic> raw;
  final String vehicleName;
  final String date;
  final double distanceKm;
  final double engineHoursSeconds;
  final double dayDistanceKm;
  final double nightDistanceKm;
  final double dayEngineHoursSeconds;
  final double nightEngineHoursSeconds;
  final double maxSpeedKmh;
  final double avgSpeedKmh;
  final int totalTrips;
  final String? startAddress;
  final String? endAddress;
  final double? startLat;
  final double? startLon;
  final double? endLat;
  final double? endLon;
  factory DetailsRow.fromMap(Map<String, dynamic> m) => DetailsRow(
        raw: m,
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        date: reportText(m['date']),
        distanceKm: reportDouble(m['distanceKm']),
        engineHoursSeconds: reportDouble(m['engineHoursSeconds']),
        dayDistanceKm: reportDouble(m['dayDistanceKm']),
        nightDistanceKm: reportDouble(m['nightDistanceKm']),
        dayEngineHoursSeconds: reportDouble(m['dayEngineHoursSeconds']),
        nightEngineHoursSeconds: reportDouble(m['nightEngineHoursSeconds']),
        maxSpeedKmh: reportDouble(m['maxSpeedKmh']),
        avgSpeedKmh: reportDouble(m['avgSpeedKmh']),
        totalTrips: reportInt(m['totalTrips']),
        startAddress: reportNullableText(m['startAddress']),
        endAddress: reportNullableText(m['endAddress']),
        startLat: _nullDouble(m['startLat']),
        startLon: _nullDouble(m['startLon']),
        endLat: _nullDouble(m['endLat']),
        endLon: _nullDouble(m['endLon']),
      );
}

class OverspeedRow {
  const OverspeedRow(
      {required this.raw,
      required this.vehicleName,
      required this.startedAt,
      required this.durationSeconds,
      required this.maxSpeedKmh,
      required this.configuredLimitKmh,
      required this.excessKmh,
      this.endedAt,
      this.date,
      this.address,
      this.lat,
      this.lon});
  final Map<String, dynamic> raw;
  final String vehicleName;
  final String startedAt;
  final double durationSeconds;
  final double maxSpeedKmh;
  final double configuredLimitKmh;
  final double excessKmh;
  final String? endedAt;
  final String? date;
  final String? address;
  final double? lat;
  final double? lon;
  factory OverspeedRow.fromMap(Map<String, dynamic> m) => OverspeedRow(
        raw: m,
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        startedAt: reportText(m['startedAt']),
        durationSeconds: reportDouble(m['durationSeconds']),
        maxSpeedKmh: reportDouble(m['maxSpeedKmh']),
        configuredLimitKmh: reportDouble(m['configuredLimitKmh']),
        excessKmh: reportDouble(m['excessKmh']),
        endedAt: reportNullableText(m['endedAt']),
        date: reportNullableText(m['date']),
        address: reportNullableText(m['address']),
        lat: _nullDouble(m['lat']),
        lon: _nullDouble(m['lon']),
      );
}

class GeofenceRow {
  const GeofenceRow(
      {required this.raw,
      required this.vehicleName,
      required this.event,
      required this.geofenceName,
      required this.timestamp,
      this.durationSeconds,
      this.address,
      this.lat,
      this.lon});
  final Map<String, dynamic> raw;
  final String vehicleName;
  final String event; // 'entry' | 'exit'
  final String geofenceName;
  final String timestamp;
  final double? durationSeconds;
  final String? address;
  final double? lat;
  final double? lon;
  factory GeofenceRow.fromMap(Map<String, dynamic> m) => GeofenceRow(
        raw: m,
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        event: reportText(m['event'], fallback: 'entry'),
        geofenceName: reportText(m['geofenceName'], fallback: 'Geofence'),
        timestamp: reportText(m['timestamp']),
        durationSeconds: _nullDouble(m['durationSeconds']),
        address: reportNullableText(m['address']),
        lat: _nullDouble(m['lat']),
        lon: _nullDouble(m['lon']),
      );
}

class AlertRow {
  const AlertRow(
      {required this.raw,
      required this.id,
      required this.vehicleId,
      required this.vehicleName,
      required this.alertType,
      required this.severity,
      required this.eventTime,
      required this.acknowledged,
      this.message,
      this.speedKmh,
      this.address,
      this.lat,
      this.lon});
  final Map<String, dynamic> raw;
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String alertType;
  final String severity;
  // Web API sends 'timestamp'; legacy mobile API may send 'eventTime' — accept both.
  final String eventTime;
  final bool acknowledged;
  final String? message;
  final double? speedKmh;
  final String? address;
  final double? lat;
  final double? lon;
  factory AlertRow.fromMap(Map<String, dynamic> m) => AlertRow(
        raw: m,
        id: reportText(m['id']),
        vehicleId: reportText(m['vehicleId']),
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        alertType: reportText(m['alertType'], fallback: 'alert'),
        severity: reportText(m['severity'], fallback: 'low'),
        // Accept 'timestamp' (web/fixture) or 'eventTime' (legacy mobile API)
        eventTime: reportText(m['timestamp'] ?? m['eventTime']),
        acknowledged: reportBool(m['acknowledged']),
        message: reportNullableText(m['message']),
        speedKmh: _nullDouble(m['speedKmh']),
        address: reportNullableText(m['address']),
        lat: _nullDouble(m['lat']),
        lon: _nullDouble(m['lon']),
      );
}

class SensorRow {
  const SensorRow(
      {required this.raw,
      required this.sensorId,
      required this.vehicleName,
      required this.sensorLabel,
      required this.timestamp,
      required this.rawValue,
      this.valueMode,
      this.unit});
  final Map<String, dynamic> raw;
  final String sensorId;
  final String vehicleName;
  final String sensorLabel;
  final String timestamp;
  final dynamic rawValue; // num or bool
  // 'numeric' | 'boolean' — mirrors web SensorRow.valueMode; null means infer.
  final String? valueMode;
  final String? unit;
  factory SensorRow.fromMap(Map<String, dynamic> m) => SensorRow(
        raw: m,
        sensorId: reportText(m['sensorId']),
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        sensorLabel: reportText(m['sensorLabel'], fallback: 'Sensor'),
        timestamp: reportText(m['timestamp']),
        rawValue: m['value'],
        valueMode: reportNullableText(m['valueMode']),
        unit: reportNullableText(m['unit']),
      );
  // valueMode='boolean' overrides raw-value heuristic when the API supplies it.
  bool get isBoolean =>
      valueMode == 'boolean' ||
      (valueMode == null &&
          (rawValue is bool || rawValue == 0 || rawValue == 1));
  double get numericValue => reportDouble(rawValue);
  // Parses ISO timestamp to ms-since-epoch for chart x-axis; null when absent.
  double? get timestampMs {
    if (timestamp.isEmpty) return null;
    final dt = DateTime.tryParse(timestamp);
    if (dt == null) return null;
    return dt.millisecondsSinceEpoch.toDouble();
  }
}

class LogRow {
  const LogRow(
      {required this.raw,
      required this.timestamp,
      required this.category,
      required this.level,
      required this.event,
      this.direction,
      this.message,
      this.protocol,
      this.payload});
  final Map<String, dynamic> raw;
  final String timestamp;
  final String category;
  final String level;
  final String event;
  final String? direction;
  final String? message;
  final String? protocol;
  final String? payload;
  factory LogRow.fromMap(Map<String, dynamic> m) => LogRow(
        raw: m,
        timestamp: reportText(m['timestamp']),
        category: reportText(m['category'], fallback: 'system'),
        level: reportText(m['level'], fallback: 'info'),
        event: reportText(m['event']),
        direction: reportNullableText(m['direction']),
        message: reportNullableText(m['message']),
        protocol: reportNullableText(m['protocol']),
        payload: reportNullableText(m['rawPayload'] ?? m['payload']),
      );
}

class TimelineRow {
  const TimelineRow(
      {required this.raw,
      required this.vehicleId,
      required this.vehicleName,
      required this.state,
      required this.startedAt,
      required this.durationSeconds,
      this.endedAt,
      this.date,
      this.distanceKm,
      this.engineHoursSeconds,
      this.maxSpeedKmh,
      this.avgSpeedKmh,
      this.startAddress,
      this.endAddress,
      this.startLat,
      this.startLon,
      this.endLat,
      this.endLon});
  final Map<String, dynamic> raw;
  final String vehicleId;
  final String vehicleName;
  final String state; // 'running' | 'stopped'
  final String startedAt;
  final double durationSeconds;
  final String? endedAt;
  final String? date;
  final double? distanceKm;
  final double? engineHoursSeconds;
  final double? maxSpeedKmh;
  final double? avgSpeedKmh;
  final String? startAddress;
  final String? endAddress;
  final double? startLat;
  final double? startLon;
  final double? endLat;
  final double? endLon;
  bool get isRunning => state == 'running';
  factory TimelineRow.fromMap(Map<String, dynamic> m) => TimelineRow(
        raw: m,
        vehicleId: reportText(m['vehicleId']),
        vehicleName: reportText(m['vehicleName'], fallback: 'Vehicle'),
        state: reportText(m['state'], fallback: 'stopped'),
        startedAt: reportText(m['startedAt']),
        durationSeconds: reportDouble(m['durationSeconds']),
        endedAt: reportNullableText(m['endedAt']),
        date: reportNullableText(m['date']),
        distanceKm: _nullDouble(m['distanceKm']),
        engineHoursSeconds: _nullDouble(m['engineHoursSeconds']),
        maxSpeedKmh: _nullDouble(m['maxSpeedKmh']),
        avgSpeedKmh: _nullDouble(m['avgSpeedKmh']),
        startAddress: reportNullableText(m['startAddress']),
        endAddress: reportNullableText(m['endAddress']),
        startLat: _nullDouble(m['startLat']),
        startLon: _nullDouble(m['startLon']),
        endLat: _nullDouble(m['endLat']),
        endLon: _nullDouble(m['endLon']),
      );
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

double? _nullDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  final parsed = double.tryParse(v.toString());
  return parsed;
}
