import 'package:shared_preferences/shared_preferences.dart';

class AdminDriverTimestampStorage {
  static const String _prefix = 'admin_driver_updated_at_';

  static String _key(String driverId) => '$_prefix$driverId';

  static Future<void> persistUpdatedAt(
    String driverId,
    DateTime timestamp,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(driverId), timestamp.toUtc().toIso8601String());
  }

  static Future<DateTime?> readUpdatedAt(String driverId) async {
    final prefs = await SharedPreferences.getInstance();
    return _parseStored(prefs.getString(_key(driverId)));
  }

  /// Reads persisted timestamps for all supplied driver IDs in one prefs access.
  static Future<Map<String, DateTime>> readUpdatedAtMap(
    Iterable<String> driverIds,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, DateTime>{};
    for (final id in driverIds) {
      if (id.isEmpty) continue;
      final parsed = _parseStored(prefs.getString(_key(id)));
      if (parsed != null) result[id] = parsed;
    }
    return result;
  }

  static Future<void> clearUpdatedAt(String driverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(driverId));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  static DateTime? _parseStored(String? value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value).toLocal();
    } catch (_) {
      return null;
    }
  }
}

/// Resolves the effective Driver Updated timestamp following the precedence:
///   1. real server updatedAt (authoritative if the backend ever provides it)
///   2. locally persisted last-successful-edit timestamp
///   3. createdAt as the initial fallback
///
/// A persisted value that pre-dates createdAt is treated as stale and ignored.
DateTime? resolveDriverEffectiveUpdatedAt({
  required DateTime? serverUpdatedAt,
  required DateTime? persistedUpdatedAt,
  required DateTime? createdAt,
}) {
  if (serverUpdatedAt != null) return serverUpdatedAt;

  if (persistedUpdatedAt != null) {
    // Guard against corrupt/stale local values older than creation time.
    if (createdAt != null && persistedUpdatedAt.isBefore(createdAt)) {
      return createdAt;
    }
    return persistedUpdatedAt;
  }

  return createdAt;
}
