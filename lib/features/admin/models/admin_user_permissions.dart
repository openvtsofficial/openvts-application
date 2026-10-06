import '../../../core/api/api_exception.dart';

/// Current user-access contract. Workflow is preserved but has no mobile editor.
class AdminUserPermissions {
  AdminUserPermissions({
    required Map<String, bool> features,
    required Map<String, bool> reports,
  }) : features = Map.unmodifiable(features),
       reports = Map.unmodifiable(reports);

  static const featureKeys = [
    'dashboard',
    'maps',
    'landmarks',
    'shareTrackLink',
    'routeOptimization',
    'support',
    'transactions',
    'notifications',
    'vehicles',
    'accounts',
    'reports',
    'workflow',
  ];
  static const reportKeys = [
    'distance',
    'driven',
    'overspeed',
    'geofence',
    'sensor',
    'alerts',
    'logs',
    'timeline',
    'details',
  ];
  final Map<String, bool> features;
  final Map<String, bool> reports;

  factory AdminUserPermissions.fromJson(Map<String, dynamic> json) {
    final features = json['features'];
    final reports = json['reports'];
    if (json['catalogVersion'] != 1 ||
        features is! Map ||
        reports is! Map ||
        !featureKeys.every((key) => features[key] is bool) ||
        !reportKeys.every((key) => reports[key] is bool)) {
      throw const ApiException(
        message: 'The server returned an unsupported permission catalog. Editing is disabled.',
      );
    }
    return AdminUserPermissions(
      features: {for (final key in featureKeys) key: features[key] as bool},
      reports: {for (final key in reportKeys) key: reports[key] as bool},
    );
  }

  AdminUserPermissions withFeature(String key, bool enabled) {
    if (!featureKeys.contains(key) || key == 'workflow') return this;
    return AdminUserPermissions(
      features: {...features, key: enabled},
      reports: reports,
    );
  }

  AdminUserPermissions withReport(String key, bool enabled) {
    if (!reportKeys.contains(key) || features['reports'] != true) return this;
    return AdminUserPermissions(
      features: features,
      reports: {...reports, key: enabled},
    );
  }

  Map<String, dynamic> toJson() => {
    'disabledFeatures':
        (features.entries.where((e) => !e.value).map((e) => e.key).toList()
          ..sort()),
    'disabledReports':
        (reports.entries.where((e) => !e.value).map((e) => e.key).toList()
          ..sort()),
  };
}
