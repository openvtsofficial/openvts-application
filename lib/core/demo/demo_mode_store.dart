import 'dart:convert';

import '../storage/local_cache.dart';
import '../storage/storage_keys.dart';
import 'demo_session.dart';

class DemoModeStore {
  DemoModeStore(this._localCache);

  final LocalCache _localCache;

  bool get isEnabled =>
      _localCache.getBool(StorageKeys.demoModeEnabled) == true &&
      cachedSession != null;

  DemoSession? get cachedSession {
    final raw = _localCache.getString(StorageKeys.demoSession);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      return DemoSession.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> enable(DemoSession session) async {
    // Persist the session first so an interrupted write can never leave an
    // enabled demo flag without enough state to restore safely.
    await _localCache.setString(
      StorageKeys.demoSession,
      jsonEncode(session.toJson()),
    );
    await _localCache.setBool(StorageKeys.demoModeEnabled, true);
  }

  Future<void> clear() async {
    // Disable first so a partial cleanup cannot restore demo accidentally.
    await _localCache.remove(StorageKeys.demoModeEnabled);
    await _localCache.remove(StorageKeys.demoSession);
  }
}
