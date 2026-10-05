import '../../shared/models/user_role.dart';

/// A fresh server permission snapshot. Missing/malformed values never grant
/// access. Cached profile JSON deliberately omits this authorization snapshot.
class MobileAccess {
  const MobileAccess.unavailable()
    : loaded = false,
      features = const {},
      reports = const {},
      grants = const {},
      navigation = const {},
      version = 0;
  const MobileAccess.account()
    : loaded = true,
      features = const {},
      reports = const {},
      grants = const {},
      navigation = const {},
      version = 0;
  const MobileAccess({
    required this.loaded,
    this.features = const {},
    this.reports = const {},
    this.grants = const {},
    this.navigation = const {},
    this.version = 0,
  });

  final bool loaded;
  final Map<String, bool> features;
  final Map<String, bool> reports;
  final Map<String, String> grants;
  final Set<String> navigation;
  final int version;
  static const userFeatures = {
    'dashboard',
    'maps',
    'landmarks',
    'workflow',
    'shareTrackLink',
    'routeOptimization',
    'support',
    'transactions',
    'notifications',
    'vehicles',
    'accounts',
    'reports',
  };
  static const userReports = {
    'distance',
    'driven',
    'overspeed',
    'geofence',
    'sensor',
    'alerts',
    'logs',
    'timeline',
    'details',
  };
  static const teamNavigationCapabilities = {
    'dashboard': 'dashboard.view',
    'users': 'users.view',
    'vehicles': 'vehicles.view',
    'drivers': 'drivers.view',
    'inventory': 'inventory.view',
    'maps': 'vehicles.telemetry.view',
    'payments': 'payments.view',
    'support': 'support.view',
    'calendar': 'calendar.view',
    'logs': 'logs.view',
  };

  factory MobileAccess.user(Map<String, dynamic> json) {
    final rawFeatures = json['features'];
    final rawReports = json['reports'];
    if (rawFeatures is! Map ||
        rawReports is! Map ||
        !userFeatures.every((key) => rawFeatures[key] is bool) ||
        !userReports.every((key) => rawReports[key] is bool)) {
      throw const FormatException('Invalid user permissions response');
    }
    return MobileAccess(
      loaded: true,
      features: Map.unmodifiable({
        for (final key in userFeatures) key: rawFeatures[key] == true,
      }),
      reports: Map.unmodifiable({
        for (final key in userReports) key: rawReports[key] == true,
      }),
      version: json['version'] is num ? (json['version'] as num).toInt() : 0,
    );
  }
  factory MobileAccess.team(Map<String, dynamic> json) {
    final rawGrants = json['grants'];
    final rawNavigation = json['navigation'];
    if (rawGrants is! Map || rawNavigation is! List) {
      throw const FormatException('Invalid team permissions response');
    }
    final grants = <String, String>{};
    for (final entry in rawGrants.entries) {
      if (entry.key is String &&
          const {'OWN', 'ASSIGNED', 'TENANT'}.contains(entry.value)) {
        grants[entry.key as String] = entry.value as String;
      }
    }
    final navigation = <String>{};
    for (final key in rawNavigation.whereType<String>()) {
      final capability = teamNavigationCapabilities[key];
      if (capability != null && grants.containsKey(capability)) {
        navigation.add(key);
      }
    }
    final role = json['role'];
    return MobileAccess(
      loaded: true,
      grants: Map.unmodifiable(grants),
      navigation: Set.unmodifiable(navigation),
      version: role is Map && role['permissionVersion'] is num
          ? (role['permissionVersion'] as num).toInt()
          : 0,
    );
  }

  bool hasCapability(String capability) =>
      loaded && grants.containsKey(capability);
  bool canFeature(UserRole role, String key) {
    if (key == 'settings' && role != UserRole.unknown) return true;
    if (!loaded ||
        role == UserRole.unknown ||
        key == 'workflow' ||
        key == 'notify') {
      return false;
    }
    if (role == UserRole.team) return navigation.contains(key);
    if (role.isUserWorkspace) {
      if (key == 'messages') return role == UserRole.user;
      return features[key] == true;
    }
    return switch (role) {
      UserRole.admin => const {
        'dashboard',
        'users',
        'vehicles',
        'drivers',
        'team',
        'inventory',
        'maps',
        'payments',
        'transactions',
        'support',
        'calendar',
        'logs',
        'plans',
        'notifications',
        'settings',
      }.contains(key),
      UserRole.superadmin => const {
        'dashboard',
        'administrators',
        'vehicles',
        'maps',
        'calendar',
        'server',
        'support',
        'payments',
        'notifications',
        'settings',
      }.contains(key),
      UserRole.driver => const {
        'dashboard',
        'trips',
        'calendar',
        'documents',
        'messages',
        'notifications',
        'settings',
      }.contains(key),
      _ => false,
    };
  }

  bool canReport(UserRole role, String key) =>
      role.isUserWorkspace &&
      canFeature(role, 'reports') &&
      reports[key] == true;

  bool canAccessPath(UserRole role, String rawPath) {
    if (role == UserRole.unknown) return false;
    final uri = Uri.tryParse(rawPath);
    if (uri == null || uri.hasScheme || uri.hasAuthority) return false;
    var path = uri.path;
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    final prefix = role.routePrefix;
    if (path != prefix && !path.startsWith('$prefix/')) return false;
    final relative = path == prefix ? '' : path.substring(prefix.length + 1);
    // Even failed permission refreshes must leave retry, identity and MFA reachable.
    if (const {'', 'profile', 'security', 'settings'}.contains(relative)) {
      return true;
    }
    if (!loaded) return false;
    if (role == UserRole.driver) {
      return const {
        'dashboard',
        'trips',
        'calendar',
        'documents',
        'messages',
        'notifications',
        'settings',
      }.contains(relative);
    }
    if (role == UserRole.superadmin) {
      return const {
            'dashboard',
            'map',
            'vehicles',
            'administrators',
            'create-admin',
            'calendar',
            'server',
            'support',
            'support/create',
            'payments',
            'notifications',
            'settings',
          }.contains(relative) ||
          RegExp(r'^administrators/[^/]+$').hasMatch(relative);
    }
    if (role.isAdminWorkspace) return _adminPath(role, relative);
    if (role.isUserWorkspace) return _userPath(role, relative);
    return false;
  }

  bool _adminPath(UserRole role, String path) {
    if (role == UserRole.admin) {
      return const {
            'dashboard',
            'map',
            'users',
            'create-user',
            'vehicles',
            'create-vehicle',
            'drivers',
            'team',
            'inventory',
            'payments',
            'transactions',
            'support',
            'support/create',
            'calendar',
            'notifications',
            'logs',
            'plans',
            'settings',
          }.contains(path) ||
          RegExp(r'^(users|vehicles|drivers)/[^/]+$').hasMatch(path);
    }
    if (path == 'create-user') {
      return canFeature(role, 'users') &&
          const {'OWN', 'TENANT'}.contains(grants['users.update']);
    }
    if (path == 'create-vehicle') {
      return canFeature(role, 'vehicles') &&
          grants['vehicles.update'] == 'TENANT';
    }
    if (path == 'notifications') {
      return hasCapability('operational_notifications.view');
    }
    final first = path.split('/').first;
    final key = first == 'map' ? 'maps' : first;
    if (!canFeature(role, key)) return false;
    if (const {
      'dashboard',
      'map',
      'users',
      'vehicles',
      'drivers',
      'inventory',
      'payments',
      'support',
      'calendar',
      'logs',
    }.contains(path)) {
      return true;
    }
    if (path == 'support/create') return hasCapability('support.reply');
    return RegExp(r'^(users|vehicles|drivers)/[^/]+$').hasMatch(path);
  }

  bool _userPath(UserRole role, String path) {
    if (path == 'settings') return true;
    if (path == 'messages') return role == UserRole.user;
    if (path == 'operations') {
      return role == UserRole.user && canFeature(role, 'routeOptimization');
    }
    if (path == 'accounts/sub-users' ||
        path.startsWith('accounts/sub-users/')) {
      return role == UserRole.user &&
          canFeature(role, 'accounts') &&
          (path == 'accounts/sub-users' ||
              RegExp(r'^accounts/sub-users/[^/]+$').hasMatch(path));
    }
    if (path.startsWith('reports/')) {
      final parts = path.split('/');
      return parts.length == 2 && canReport(role, parts[1]);
    }
    const paths = {
      'dashboard': 'dashboard',
      'map': 'maps',
      'history': 'maps',
      'vehicles': 'vehicles',
      'reports': 'reports',
      'landmarks-studio': 'landmarks',
      'landmarks-studio/geofences': 'landmarks',
      'landmarks-studio/pois': 'landmarks',
      'landmarks-studio/routes': 'landmarks',
      'landmarks-studio/geofences/editor': 'landmarks',
      'landmarks-studio/pois/editor': 'landmarks',
      'landmarks-studio/routes/editor': 'landmarks',
      'track-links': 'shareTrackLink',
      'support': 'support',
      'support/create': 'support',
      'transactions': 'transactions',
      'accounts': 'accounts',
      'accounts/drivers': 'accounts',
      'notifications': 'notifications',
      'notifications/center': 'notifications',
    };
    final feature = paths[path];
    if (feature != null) return canFeature(role, feature);
    if (RegExp(r'^vehicles/[^/]+$').hasMatch(path)) {
      return canFeature(role, 'vehicles');
    }
    if (RegExp(r'^accounts/drivers/[^/]+$').hasMatch(path)) {
      return canFeature(role, 'accounts');
    }
    return false;
  }
}
