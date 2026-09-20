import 'package:flutter/foundation.dart';

enum UserNotificationGroup { basic, overspeed, duration, geofence, route }

enum UserNotificationChannel { webPush, mobilePush, whatsapp, email }

enum UserDurationNotificationKind { running, stop, idle }

class UserNotificationChannelFlags {
  const UserNotificationChannelFlags({
    this.notifyWebPush = false,
    this.notifyMobilePush = false,
    this.notifyWhatsapp = false,
    this.notifyEmail = false,
  });

  final bool notifyWebPush;
  final bool notifyMobilePush;
  final bool notifyWhatsapp;
  final bool notifyEmail;

  factory UserNotificationChannelFlags.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserNotificationChannelFlags(
      notifyWebPush: _asBool(map['notifyWebPush']),
      notifyMobilePush: _asBool(map['notifyMobilePush']),
      notifyWhatsapp: _asBool(map['notifyWhatsapp']),
      notifyEmail: _asBool(map['notifyEmail']),
    );
  }

  int get activeCount {
    var count = 0;
    if (notifyWebPush) count += 1;
    if (notifyMobilePush) count += 1;
    if (notifyWhatsapp) count += 1;
    if (notifyEmail) count += 1;
    return count;
  }

  bool valueFor(UserNotificationChannel channel) {
    switch (channel) {
      case UserNotificationChannel.webPush:
        return notifyWebPush;
      case UserNotificationChannel.mobilePush:
        return notifyMobilePush;
      case UserNotificationChannel.whatsapp:
        return notifyWhatsapp;
      case UserNotificationChannel.email:
        return notifyEmail;
    }
  }

  UserNotificationChannelFlags updateChannel(
    UserNotificationChannel channel,
    bool value,
  ) {
    switch (channel) {
      case UserNotificationChannel.webPush:
        return copyWith(notifyWebPush: value);
      case UserNotificationChannel.mobilePush:
        return copyWith(notifyMobilePush: value);
      case UserNotificationChannel.whatsapp:
        return copyWith(notifyWhatsapp: value);
      case UserNotificationChannel.email:
        return copyWith(notifyEmail: value);
    }
  }

  UserNotificationChannelFlags copyWith({
    bool? notifyWebPush,
    bool? notifyMobilePush,
    bool? notifyWhatsapp,
    bool? notifyEmail,
  }) {
    return UserNotificationChannelFlags(
      notifyWebPush: notifyWebPush ?? this.notifyWebPush,
      notifyMobilePush: notifyMobilePush ?? this.notifyMobilePush,
      notifyWhatsapp: notifyWhatsapp ?? this.notifyWhatsapp,
      notifyEmail: notifyEmail ?? this.notifyEmail,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notifyWebPush': notifyWebPush,
      'notifyMobilePush': notifyMobilePush,
      'notifyWhatsapp': notifyWhatsapp,
      'notifyEmail': notifyEmail,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationChannelFlags &&
        other.notifyWebPush == notifyWebPush &&
        other.notifyMobilePush == notifyMobilePush &&
        other.notifyWhatsapp == notifyWhatsapp &&
        other.notifyEmail == notifyEmail;
  }

  @override
  int get hashCode {
    return Object.hash(
      notifyWebPush,
      notifyMobilePush,
      notifyWhatsapp,
      notifyEmail,
    );
  }
}

class UserNotificationChannels {
  const UserNotificationChannels({
    this.basic = const UserNotificationChannelFlags(),
    this.overspeed = const UserNotificationChannelFlags(),
    this.duration = const UserNotificationChannelFlags(),
    this.geofence = const UserNotificationChannelFlags(),
    this.route = const UserNotificationChannelFlags(),
  });

  final UserNotificationChannelFlags basic;
  final UserNotificationChannelFlags overspeed;
  final UserNotificationChannelFlags duration;
  final UserNotificationChannelFlags geofence;
  final UserNotificationChannelFlags route;

  factory UserNotificationChannels.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserNotificationChannels(
      basic: UserNotificationChannelFlags.fromJson(
        _firstByKeys(map, const ['BASIC', 'basic']),
      ),
      overspeed: UserNotificationChannelFlags.fromJson(
        _firstByKeys(map, const ['OVERSPEED', 'overspeed']),
      ),
      duration: UserNotificationChannelFlags.fromJson(
        _firstByKeys(map, const ['DURATION', 'duration']),
      ),
      geofence: UserNotificationChannelFlags.fromJson(
        _firstByKeys(map, const ['GEOFENCE', 'geofence']),
      ),
      route: UserNotificationChannelFlags.fromJson(
        _firstByKeys(map, const ['ROUTE', 'route']),
      ),
    );
  }

  int get activeCount {
    return basic.activeCount +
        overspeed.activeCount +
        duration.activeCount +
        geofence.activeCount +
        route.activeCount;
  }

  UserNotificationChannelFlags flagsFor(UserNotificationGroup group) {
    switch (group) {
      case UserNotificationGroup.basic:
        return basic;
      case UserNotificationGroup.overspeed:
        return overspeed;
      case UserNotificationGroup.duration:
        return duration;
      case UserNotificationGroup.geofence:
        return geofence;
      case UserNotificationGroup.route:
        return route;
    }
  }

  UserNotificationChannels updateFlags(
    UserNotificationGroup group,
    UserNotificationChannelFlags flags,
  ) {
    switch (group) {
      case UserNotificationGroup.basic:
        return copyWith(basic: flags);
      case UserNotificationGroup.overspeed:
        return copyWith(overspeed: flags);
      case UserNotificationGroup.duration:
        return copyWith(duration: flags);
      case UserNotificationGroup.geofence:
        return copyWith(geofence: flags);
      case UserNotificationGroup.route:
        return copyWith(route: flags);
    }
  }

  UserNotificationChannels updateChannel(
    UserNotificationGroup group,
    UserNotificationChannel channel,
    bool value,
  ) {
    final flags = flagsFor(group).updateChannel(channel, value);
    return updateFlags(group, flags);
  }

  UserNotificationChannels copyWith({
    UserNotificationChannelFlags? basic,
    UserNotificationChannelFlags? overspeed,
    UserNotificationChannelFlags? duration,
    UserNotificationChannelFlags? geofence,
    UserNotificationChannelFlags? route,
  }) {
    return UserNotificationChannels(
      basic: basic ?? this.basic,
      overspeed: overspeed ?? this.overspeed,
      duration: duration ?? this.duration,
      geofence: geofence ?? this.geofence,
      route: route ?? this.route,
    );
  }

  Map<String, dynamic> toSaveJson() {
    return <String, dynamic>{
      'BASIC': basic.toJson(),
      'OVERSPEED': overspeed.toJson(),
      'DURATION': duration.toJson(),
      'GEOFENCE': geofence.toJson(),
      'ROUTE': route.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationChannels &&
        other.basic == basic &&
        other.overspeed == overspeed &&
        other.duration == duration &&
        other.geofence == geofence &&
        other.route == route;
  }

  @override
  int get hashCode => Object.hash(basic, overspeed, duration, geofence, route);
}

class UserNotificationVehicle {
  const UserNotificationVehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
  });

  final int id;
  final String name;
  final String plateNumber;

  factory UserNotificationVehicle.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserNotificationVehicle(
      id: _asInt(map['id']),
      name: _asString(map['name']),
      plateNumber: _asString(map['plateNumber']),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationVehicle &&
        other.id == id &&
        other.name == name &&
        other.plateNumber == plateNumber;
  }

  @override
  int get hashCode => Object.hash(id, name, plateNumber);
}

class UserBasicNotificationRow {
  const UserBasicNotificationRow({
    required this.vehicleId,
    this.ignitionEnabled = false,
    this.alarmEnabled = false,
  });

  final int vehicleId;
  final bool ignitionEnabled;
  final bool alarmEnabled;

  factory UserBasicNotificationRow.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserBasicNotificationRow(
      vehicleId: _asInt(map['vehicleId']),
      ignitionEnabled: _asBool(map['ignitionEnabled']),
      alarmEnabled: _asBool(map['alarmEnabled']),
    );
  }

  UserBasicNotificationRow copyWith({
    int? vehicleId,
    bool? ignitionEnabled,
    bool? alarmEnabled,
  }) {
    return UserBasicNotificationRow(
      vehicleId: vehicleId ?? this.vehicleId,
      ignitionEnabled: ignitionEnabled ?? this.ignitionEnabled,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
    );
  }

  Map<String, dynamic> toSaveJson() {
    return <String, dynamic>{
      'vehicleId': vehicleId,
      'ignitionEnabled': ignitionEnabled,
      'alarmEnabled': alarmEnabled,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is UserBasicNotificationRow &&
        other.vehicleId == vehicleId &&
        other.ignitionEnabled == ignitionEnabled &&
        other.alarmEnabled == alarmEnabled;
  }

  @override
  int get hashCode => Object.hash(vehicleId, ignitionEnabled, alarmEnabled);
}

class UserOverspeedNotificationRow {
  const UserOverspeedNotificationRow({
    required this.vehicleId,
    this.enabled = false,
    this.speedLimitKph,
  });

  final int vehicleId;
  final bool enabled;
  final int? speedLimitKph;

  factory UserOverspeedNotificationRow.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserOverspeedNotificationRow(
      vehicleId: _asInt(map['vehicleId']),
      enabled: _asBool(map['enabled']),
      speedLimitKph: _asNullableInt(map['speedLimitKph']),
    );
  }

  UserOverspeedNotificationRow copyWith({
    int? vehicleId,
    bool? enabled,
    Object? speedLimitKph = _unset,
  }) {
    return UserOverspeedNotificationRow(
      vehicleId: vehicleId ?? this.vehicleId,
      enabled: enabled ?? this.enabled,
      speedLimitKph: identical(speedLimitKph, _unset)
          ? this.speedLimitKph
          : speedLimitKph as int?,
    );
  }

  Map<String, dynamic> toSaveJson() {
    return <String, dynamic>{
      'vehicleId': vehicleId,
      'enabled': enabled,
      'speedLimitKph': speedLimitKph,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is UserOverspeedNotificationRow &&
        other.vehicleId == vehicleId &&
        other.enabled == enabled &&
        other.speedLimitKph == speedLimitKph;
  }

  @override
  int get hashCode => Object.hash(vehicleId, enabled, speedLimitKph);
}

class UserDurationNotificationRow {
  const UserDurationNotificationRow({
    required this.vehicleId,
    this.runningEnabled = false,
    this.runningLimitMinutes,
    this.stopEnabled = false,
    this.stopLimitMinutes,
    this.idleEnabled = false,
    this.idleLimitMinutes,
  });

  final int vehicleId;
  final bool runningEnabled;
  final int? runningLimitMinutes;
  final bool stopEnabled;
  final int? stopLimitMinutes;
  final bool idleEnabled;
  final int? idleLimitMinutes;

  factory UserDurationNotificationRow.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserDurationNotificationRow(
      vehicleId: _asInt(map['vehicleId']),
      runningEnabled: _asBool(map['runningEnabled']),
      runningLimitMinutes: _asNullableInt(map['runningLimitMinutes']),
      stopEnabled: _asBool(map['stopEnabled']),
      stopLimitMinutes: _asNullableInt(map['stopLimitMinutes']),
      idleEnabled: _asBool(map['idleEnabled']),
      idleLimitMinutes: _asNullableInt(map['idleLimitMinutes']),
    );
  }

  UserDurationNotificationRow copyWith({
    bool? runningEnabled,
    Object? runningLimitMinutes = _unset,
    bool? stopEnabled,
    Object? stopLimitMinutes = _unset,
    bool? idleEnabled,
    Object? idleLimitMinutes = _unset,
  }) {
    return UserDurationNotificationRow(
      vehicleId: vehicleId,
      runningEnabled: runningEnabled ?? this.runningEnabled,
      runningLimitMinutes: identical(runningLimitMinutes, _unset)
          ? this.runningLimitMinutes
          : runningLimitMinutes as int?,
      stopEnabled: stopEnabled ?? this.stopEnabled,
      stopLimitMinutes: identical(stopLimitMinutes, _unset)
          ? this.stopLimitMinutes
          : stopLimitMinutes as int?,
      idleEnabled: idleEnabled ?? this.idleEnabled,
      idleLimitMinutes: identical(idleLimitMinutes, _unset)
          ? this.idleLimitMinutes
          : idleLimitMinutes as int?,
    );
  }

  Map<String, dynamic> toSaveJson() => <String, dynamic>{
        'vehicleId': vehicleId,
        'runningEnabled': runningEnabled,
        'runningLimitMinutes': runningLimitMinutes,
        'stopEnabled': stopEnabled,
        'stopLimitMinutes': stopLimitMinutes,
        'idleEnabled': idleEnabled,
        'idleLimitMinutes': idleLimitMinutes,
      };

  @override
  bool operator ==(Object other) =>
      other is UserDurationNotificationRow &&
      other.vehicleId == vehicleId &&
      other.runningEnabled == runningEnabled &&
      other.runningLimitMinutes == runningLimitMinutes &&
      other.stopEnabled == stopEnabled &&
      other.stopLimitMinutes == stopLimitMinutes &&
      other.idleEnabled == idleEnabled &&
      other.idleLimitMinutes == idleLimitMinutes;

  @override
  int get hashCode => Object.hash(
      vehicleId,
      runningEnabled,
      runningLimitMinutes,
      stopEnabled,
      stopLimitMinutes,
      idleEnabled,
      idleLimitMinutes);
}

class UserNotificationGeofence {
  const UserNotificationGeofence({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = false,
  });

  final int id;
  final String name;
  final String type;
  final bool isActive;

  factory UserNotificationGeofence.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserNotificationGeofence(
      id: _asInt(map['id']),
      name: _asString(map['name']),
      type: _asString(map['type']),
      isActive: _asBool(map['isActive']),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationGeofence &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, name, type, isActive);
}

class UserGeofenceMatrixEntry {
  const UserGeofenceMatrixEntry({
    required this.vehicleId,
    required this.geofenceId,
    this.enabled = false,
  });

  final int vehicleId;
  final int geofenceId;
  final bool enabled;

  factory UserGeofenceMatrixEntry.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserGeofenceMatrixEntry(
      vehicleId: _asInt(map['vehicleId']),
      geofenceId: _asInt(map['geofenceId']),
      enabled: _asBool(map['enabled']),
    );
  }

  UserGeofenceMatrixEntry copyWith({
    int? vehicleId,
    int? geofenceId,
    bool? enabled,
  }) {
    return UserGeofenceMatrixEntry(
      vehicleId: vehicleId ?? this.vehicleId,
      geofenceId: geofenceId ?? this.geofenceId,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toSaveJson() {
    return <String, dynamic>{
      'vehicleId': vehicleId,
      'geofenceId': geofenceId,
      'enabled': enabled,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is UserGeofenceMatrixEntry &&
        other.vehicleId == vehicleId &&
        other.geofenceId == geofenceId &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(vehicleId, geofenceId, enabled);
}

class UserNotificationRoute {
  const UserNotificationRoute({
    required this.id,
    required this.name,
    this.isActive = false,
    this.toleranceMeters,
  });

  final int id;
  final String name;
  final bool isActive;
  final double? toleranceMeters;

  factory UserNotificationRoute.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserNotificationRoute(
      id: _asInt(map['id']),
      name: _asString(map['name']),
      isActive: _asBool(map['isActive']),
      toleranceMeters: _asNullableDouble(map['toleranceMeters']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is UserNotificationRoute &&
      other.id == id &&
      other.name == name &&
      other.isActive == isActive &&
      other.toleranceMeters == toleranceMeters;

  @override
  int get hashCode => Object.hash(id, name, isActive, toleranceMeters);
}

class UserRouteMatrixEntry {
  const UserRouteMatrixEntry({
    required this.vehicleId,
    required this.routeId,
    this.enabled = false,
  });

  final int vehicleId;
  final int routeId;
  final bool enabled;

  factory UserRouteMatrixEntry.fromJson(dynamic json) {
    final map = _asMap(json);
    return UserRouteMatrixEntry(
      vehicleId: _asInt(map['vehicleId']),
      routeId: _asInt(map['routeId']),
      enabled: _asBool(map['enabled']),
    );
  }

  UserRouteMatrixEntry copyWith({bool? enabled}) => UserRouteMatrixEntry(
        vehicleId: vehicleId,
        routeId: routeId,
        enabled: enabled ?? this.enabled,
      );

  Map<String, dynamic> toSaveJson() => <String, dynamic>{
        'vehicleId': vehicleId,
        'routeId': routeId,
        'enabled': enabled,
      };

  @override
  bool operator ==(Object other) =>
      other is UserRouteMatrixEntry &&
      other.vehicleId == vehicleId &&
      other.routeId == routeId &&
      other.enabled == enabled;

  @override
  int get hashCode => Object.hash(vehicleId, routeId, enabled);
}

class UserNotificationPreferences {
  const UserNotificationPreferences({
    this.channels = const UserNotificationChannels(),
    this.vehicles = const <UserNotificationVehicle>[],
    this.basic = const <UserBasicNotificationRow>[],
    this.overspeed = const <UserOverspeedNotificationRow>[],
    this.duration = const <UserDurationNotificationRow>[],
    this.geofences = const <UserNotificationGeofence>[],
    this.geofenceMatrix = const <UserGeofenceMatrixEntry>[],
    this.routes = const <UserNotificationRoute>[],
    this.routeMatrix = const <UserRouteMatrixEntry>[],
  });

  final UserNotificationChannels channels;
  final List<UserNotificationVehicle> vehicles;
  final List<UserBasicNotificationRow> basic;
  final List<UserOverspeedNotificationRow> overspeed;
  final List<UserDurationNotificationRow> duration;
  final List<UserNotificationGeofence> geofences;
  final List<UserGeofenceMatrixEntry> geofenceMatrix;
  final List<UserNotificationRoute> routes;
  final List<UserRouteMatrixEntry> routeMatrix;

  factory UserNotificationPreferences.fromDynamic(dynamic json) {
    final payload = _extractPreferencesPayload(json);

    return UserNotificationPreferences(
      channels: UserNotificationChannels.fromJson(payload['channels']),
      vehicles: _asList(payload['vehicles'])
          .map(UserNotificationVehicle.fromJson)
          .where((item) => item.id > 0)
          .toList(growable: false),
      basic: _asList(payload['basic'])
          .map(UserBasicNotificationRow.fromJson)
          .where((item) => item.vehicleId > 0)
          .toList(growable: false),
      overspeed: _asList(payload['overspeed'])
          .map(UserOverspeedNotificationRow.fromJson)
          .where((item) => item.vehicleId > 0)
          .toList(growable: false),
      duration: _asList(payload['duration'])
          .map(UserDurationNotificationRow.fromJson)
          .where((item) => item.vehicleId > 0)
          .toList(growable: false),
      geofences: _asList(payload['geofences'])
          .map(UserNotificationGeofence.fromJson)
          .where((item) => item.id > 0)
          .toList(growable: false),
      geofenceMatrix: _asList(payload['geofenceMatrix'])
          .map(UserGeofenceMatrixEntry.fromJson)
          .where((item) => item.vehicleId > 0 && item.geofenceId > 0)
          .toList(growable: false),
      routes: _asList(payload['routes'])
          .map(UserNotificationRoute.fromJson)
          .where((item) => item.id > 0)
          .toList(growable: false),
      routeMatrix: _asList(payload['routeMatrix'])
          .map(UserRouteMatrixEntry.fromJson)
          .where((item) => item.vehicleId > 0 && item.routeId > 0)
          .toList(growable: false),
    );
  }

  UserNotificationPreferences copyWith({
    UserNotificationChannels? channels,
    List<UserNotificationVehicle>? vehicles,
    List<UserBasicNotificationRow>? basic,
    List<UserOverspeedNotificationRow>? overspeed,
    List<UserDurationNotificationRow>? duration,
    List<UserNotificationGeofence>? geofences,
    List<UserGeofenceMatrixEntry>? geofenceMatrix,
    List<UserNotificationRoute>? routes,
    List<UserRouteMatrixEntry>? routeMatrix,
  }) {
    return UserNotificationPreferences(
      channels: channels ?? this.channels,
      vehicles: vehicles ?? this.vehicles,
      basic: basic ?? this.basic,
      overspeed: overspeed ?? this.overspeed,
      duration: duration ?? this.duration,
      geofences: geofences ?? this.geofences,
      geofenceMatrix: geofenceMatrix ?? this.geofenceMatrix,
      routes: routes ?? this.routes,
      routeMatrix: routeMatrix ?? this.routeMatrix,
    );
  }

  Map<String, dynamic> toSavePayload() {
    return <String, dynamic>{
      'channels': channels.toSaveJson(),
      'basic': basic.map((item) => item.toSaveJson()).toList(growable: false),
      'overspeed':
          overspeed.map((item) => item.toSaveJson()).toList(growable: false),
      'duration':
          duration.map((item) => item.toSaveJson()).toList(growable: false),
      // Backend expects this key to be `geofences` for matrix updates.
      'geofences': geofenceMatrix
          .map((item) => item.toSaveJson())
          .toList(growable: false),
      'routes':
          routeMatrix.map((item) => item.toSaveJson()).toList(growable: false),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationPreferences &&
        other.channels == channels &&
        listEquals(other.vehicles, vehicles) &&
        listEquals(other.basic, basic) &&
        listEquals(other.overspeed, overspeed) &&
        listEquals(other.duration, duration) &&
        listEquals(other.geofences, geofences) &&
        listEquals(other.geofenceMatrix, geofenceMatrix) &&
        listEquals(other.routes, routes) &&
        listEquals(other.routeMatrix, routeMatrix);
  }

  @override
  int get hashCode {
    return Object.hash(
      channels,
      Object.hashAll(vehicles),
      Object.hashAll(basic),
      Object.hashAll(overspeed),
      Object.hashAll(duration),
      Object.hashAll(geofences),
      Object.hashAll(geofenceMatrix),
      Object.hashAll(routes),
      Object.hashAll(routeMatrix),
    );
  }
}

const Object _unset = Object();

Map<String, dynamic> _extractPreferencesPayload(dynamic source) {
  final root = _asMap(source);
  if (root.isEmpty) {
    return const <String, dynamic>{};
  }

  if (_looksLikePreferencesPayload(root)) {
    return root;
  }

  for (final key in const ['data', 'payload', 'result', 'response']) {
    final nested = _asMap(root[key]);
    if (nested.isEmpty || identical(nested, root)) {
      continue;
    }

    final resolved = _extractPreferencesPayload(nested);
    if (resolved.isNotEmpty || _looksLikePreferencesPayload(nested)) {
      return resolved;
    }
  }

  return root;
}

bool _looksLikePreferencesPayload(Map<String, dynamic> map) {
  return map.containsKey('channels') ||
      map.containsKey('vehicles') ||
      map.containsKey('basic') ||
      map.containsKey('overspeed') ||
      map.containsKey('duration') ||
      map.containsKey('geofences') ||
      map.containsKey('geofenceMatrix') ||
      map.containsKey('routes') ||
      map.containsKey('routeMatrix');
}

dynamic _firstByKeys(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    if (map.containsKey(key)) {
      return map[key];
    }
  }
  return null;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }

  return const <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) {
    return value;
  }
  return const <dynamic>[];
}

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }
  return value.toString().trim();
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }

  return 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  final parsed = _asInt(value);
  if (value is String && parsed == 0 && value.trim() != '0') {
    return null;
  }
  return parsed;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim());
}

bool _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) {
    return false;
  }

  switch (normalized) {
    case '1':
    case 'true':
    case 'yes':
    case 'on':
      return true;
    default:
      return false;
  }
}
