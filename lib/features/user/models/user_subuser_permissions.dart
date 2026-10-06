import '../../../core/access/mobile_access.dart';

/// Direct denies are distinct from the parent's effective access. Unknown or
/// missing inherited access must never produce an editable, default-on switch.
class UserSubUserPermissions {
  const UserSubUserPermissions({
    required this.availableFeatures,
    required this.availableReports,
    required this.disabledFeatures,
    required this.disabledReports,
  });

  final Map<String, bool> availableFeatures;
  final Map<String, bool> availableReports;
  final Set<String> disabledFeatures;
  final Set<String> disabledReports;

  factory UserSubUserPermissions.fromJson(dynamic value) {
    var source = value;
    for (var i = 0; i < 3 && source is Map && source['data'] is Map; i++) {
      source = source['data'];
    }
    if (source is! Map ||
        source['availableFeatures'] is! Map ||
        source['availableReports'] is! Map ||
        source['disabledFeatures'] is! List ||
        source['disabledReports'] is! List) {
      throw const FormatException('Invalid subuser permission response');
    }
    Map<String, bool> availability(String key, Set<String> expected) {
      final raw = source[key] as Map;
      if (!expected.every((name) => raw[name] is bool)) {
        throw const FormatException('Incomplete inherited permissions');
      }
      return Map.unmodifiable({
        for (final name in expected) name: raw[name] == true,
      });
    }

    Set<String> denies(String key, Set<String> expected) {
      final raw = source[key] as List;
      if (raw.any((value) => value is! String || !expected.contains(value))) {
        throw const FormatException('Invalid direct permissions');
      }
      return Set.unmodifiable(raw.cast<String>());
    }

    return UserSubUserPermissions(
      availableFeatures: availability(
        'availableFeatures',
        MobileAccess.userFeatures,
      ),
      availableReports: availability(
        'availableReports',
        MobileAccess.userReports,
      ),
      disabledFeatures: denies('disabledFeatures', MobileAccess.userFeatures),
      disabledReports: denies('disabledReports', MobileAccess.userReports),
    );
  }
}
