class DemoSession {
  const DemoSession({
    required this.user,
    required this.settings,
    required this.permissions,
  });

  final DemoSessionUser user;
  final DemoSessionSettings settings;
  final DemoSessionPermissions permissions;

  factory DemoSession.fromJson(dynamic json) {
    final root = _asMap(json);
    final user = DemoSessionUser.fromJson(root['user']);
    if (!user.isValid) {
      throw const FormatException('Demo session is missing a valid user.');
    }

    return DemoSession(
      user: user,
      settings: DemoSessionSettings.fromJson(root['settings']),
      permissions: DemoSessionPermissions.fromJson(root['permissions']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': user.toJson(),
      'settings': settings.toJson(),
      'permissions': permissions.toJson(),
    };
  }
}

class DemoSessionUser {
  const DemoSessionUser({
    required this.id,
    required this.name,
    required this.email,
    required this.companyName,
  });

  final String id;
  final String name;
  final String email;
  final String companyName;

  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  factory DemoSessionUser.fromJson(dynamic json) {
    final source = _asMap(json);
    return DemoSessionUser(
      id: _string(source['id']),
      name: _string(source['name'], fallback: 'Demo Fleet Manager'),
      email: _string(source['email'], fallback: 'demo@openvts.io'),
      companyName: _string(
        source['companyName'],
        fallback: 'Open VTS Demo Logistics',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'companyName': companyName,
    };
  }
}

class DemoSessionSettings {
  const DemoSessionSettings({
    required this.languageCode,
    required this.theme,
    required this.timezone,
  });

  final String languageCode;
  final String theme;
  final String timezone;

  factory DemoSessionSettings.fromJson(dynamic json) {
    final source = _asMap(json);
    return DemoSessionSettings(
      languageCode: _string(source['languageCode'], fallback: 'en'),
      theme: _string(source['theme'], fallback: 'SYSTEM'),
      timezone: _string(source['timezone'], fallback: 'America/New_York'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'languageCode': languageCode,
      'theme': theme,
      'timezone': timezone,
    };
  }
}

class DemoSessionPermissions {
  const DemoSessionPermissions({
    required this.readOnly,
    required this.sendCommands,
    required this.createVehicles,
    required this.editVehicles,
    required this.deleteVehicles,
  });

  final bool readOnly;
  final bool sendCommands;
  final bool createVehicles;
  final bool editVehicles;
  final bool deleteVehicles;

  factory DemoSessionPermissions.fromJson(dynamic json) {
    final source = _asMap(json);
    return DemoSessionPermissions(
      readOnly: _bool(source['readOnly'], fallback: true),
      sendCommands: _bool(source['sendCommands']),
      createVehicles: _bool(source['createVehicles']),
      editVehicles: _bool(source['editVehicles']),
      deleteVehicles: _bool(source['deleteVehicles']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'readOnly': readOnly,
      'sendCommands': sendCommands,
      'createVehicles': createVehicles,
      'editVehicles': editVehicles,
      'deleteVehicles': deleteVehicles,
    };
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (key, item) => MapEntry(key.toString(), item),
    );
  }
  return const <String, dynamic>{};
}

String _string(dynamic value, {String fallback = ''}) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty ? fallback : normalized;
}

bool _bool(dynamic value, {bool fallback = false}) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  switch (value?.toString().trim().toLowerCase()) {
    case 'true':
    case '1':
    case 'yes':
      return true;
    case 'false':
    case '0':
    case 'no':
      return false;
    default:
      return fallback;
  }
}
