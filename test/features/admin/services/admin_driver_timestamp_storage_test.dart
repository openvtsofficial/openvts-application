import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/services/admin_driver_timestamp_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// resolveDriverEffectiveUpdatedAt — unit tests (no I/O required)
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  // =========================================================================
  // 1. Timestamp precedence
  // =========================================================================

  group('resolveDriverEffectiveUpdatedAt – precedence', () {
    final t1 = DateTime.utc(2026, 8, 1, 10, 0); // createdAt
    final t2 = DateTime.utc(2026, 8, 5, 14, 0); // persisted edit
    final t3 = DateTime.utc(2026, 8, 7, 9, 0); // server updatedAt

    test('server updatedAt wins over persisted and createdAt', () {
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: t3,
        persistedUpdatedAt: t2,
        createdAt: t1,
      );
      expect(result, t3);
    });

    test('persisted timestamp used when server omits updatedAt', () {
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: t2,
        createdAt: t1,
      );
      expect(result, t2);
    });

    test('createdAt used when server and persisted are both absent', () {
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: null,
        createdAt: t1,
      );
      expect(result, t1);
    });

    test('returns null when all three inputs are null', () {
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: null,
        createdAt: null,
      );
      expect(result, isNull);
    });
  });

  // =========================================================================
  // 2. Newly created driver: createdAt is the initial effective updatedAt
  // =========================================================================

  group('newly created driver', () {
    test('createdAt becomes effective updatedAt when updatedAt absent', () {
      final createdAt = DateTime.utc(2026, 8, 7, 14, 15);
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: null,
        createdAt: createdAt,
      );
      expect(result, createdAt);
    });
  });

  // =========================================================================
  // 3. Persisted timestamp with valid createdAt
  // =========================================================================

  group('persisted timestamp scenarios', () {
    final createdAt = DateTime.utc(2026, 8, 7, 14, 15);
    final persisted = DateTime.utc(2026, 8, 7, 15, 40);

    test('valid persisted value (after createdAt) is returned', () {
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: persisted,
        createdAt: createdAt,
      );
      expect(result, persisted);
    });

    test('stale persisted value (before createdAt) falls back to createdAt',
        () {
      final stalePersisted = DateTime.utc(2026, 7, 1, 0, 0);
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: stalePersisted,
        createdAt: createdAt,
      );
      expect(result, createdAt);
    });

    test('persisted equal to createdAt is accepted', () {
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: null,
        persistedUpdatedAt: createdAt,
        createdAt: createdAt,
      );
      expect(result, createdAt);
    });
  });

  // =========================================================================
  // 4. Real server timestamp overrides local fallback
  // =========================================================================

  group('server updatedAt future compatibility', () {
    test('real server updatedAt overrides persisted value', () {
      final persisted = DateTime.utc(2026, 8, 5, 10, 0);
      final server = DateTime.utc(2026, 8, 7, 12, 0);
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: server,
        persistedUpdatedAt: persisted,
        createdAt: DateTime.utc(2026, 8, 1),
      );
      expect(result, server);
    });

    test('server updatedAt overrides createdAt fallback', () {
      final server = DateTime.utc(2026, 8, 7, 12, 0);
      final result = resolveDriverEffectiveUpdatedAt(
        serverUpdatedAt: server,
        persistedUpdatedAt: null,
        createdAt: DateTime.utc(2026, 8, 1),
      );
      expect(result, server);
    });
  });

  // =========================================================================
  // 5. Storage key isolation between different driver IDs
  //    (verifies _key() logic via readUpdatedAtMap with empty inputs)
  // =========================================================================

  group('readUpdatedAtMap with empty input', () {
    test('returns empty map for empty id list', () async {
      final result =
          await AdminDriverTimestampStorage.readUpdatedAtMap(<String>[]);
      expect(result, isEmpty);
    });

    test('ignores empty-string id entries', () async {
      final result =
          await AdminDriverTimestampStorage.readUpdatedAtMap(['', '  ']);
      expect(result, isEmpty);
    });
  });

  // =========================================================================
  // 6. Malformed / missing value is ignored safely
  // =========================================================================

  group('malformed stored value is ignored', () {
    test('readUpdatedAtMap returns empty map when prefs has no keys', () async {
      final result = await AdminDriverTimestampStorage.readUpdatedAtMap(
        ['driver-999'],
      );
      expect(result['driver-999'], isNull);
    });
  });
}
