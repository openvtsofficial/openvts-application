import 'package:shared_preferences/shared_preferences.dart';

class AdminVehicleTimestampStorage {
  static const String _prefix = 'admin_vehicle_updated_at_';

  static String _key(String vehicleId) => '$_prefix$vehicleId';

  static Future<void> persistUpdatedAt(
    String vehicleId,
    DateTime timestamp,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(vehicleId), timestamp.toUtc().toIso8601String());
  }

  static Future<DateTime?> readUpdatedAt(String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key(vehicleId));
    if (value == null) return null;
    try {
      return DateTime.parse(value).toLocal();
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUpdatedAt(String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(vehicleId));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
