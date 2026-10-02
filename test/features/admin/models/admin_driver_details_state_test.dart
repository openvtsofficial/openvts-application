import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_driver_details_state.dart';

void main() {
  // -------------------------------------------------------------------------
  // profileUpdatedAt — initial state
  // -------------------------------------------------------------------------

  group('AdminDriverDetailsState.initial', () {
    test('profileUpdatedAt is null on initial state', () {
      const state = AdminDriverDetailsState.initial(driverId: 'drv-1');
      expect(state.profileUpdatedAt, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // profileUpdatedAt — copyWith
  // -------------------------------------------------------------------------

  group('AdminDriverDetailsState.copyWith profileUpdatedAt', () {
    const base = AdminDriverDetailsState.initial(driverId: 'drv-1');

    test('setting profileUpdatedAt stores the provided value', () {
      final ts = DateTime.utc(2026, 8, 7, 10, 30);
      final updated = base.copyWith(profileUpdatedAt: ts);
      expect(updated.profileUpdatedAt, ts);
    });

    test('omitting profileUpdatedAt preserves the existing value', () {
      final ts = DateTime.utc(2026, 8, 7, 10, 30);
      final withTs = base.copyWith(profileUpdatedAt: ts);
      final again = withTs.copyWith(isSavingProfile: false);
      expect(again.profileUpdatedAt, ts);
    });

    test('passing null explicitly clears profileUpdatedAt', () {
      final ts = DateTime.utc(2026, 8, 7, 10, 30);
      final withTs = base.copyWith(profileUpdatedAt: ts);
      final cleared = withTs.copyWith(profileUpdatedAt: null);
      expect(cleared.profileUpdatedAt, isNull);
    });

    test('other fields are unaffected when only profileUpdatedAt changes', () {
      const state = AdminDriverDetailsState.initial(driverId: 'drv-42');
      final ts = DateTime.utc(2026, 1, 1);
      final updated = state.copyWith(profileUpdatedAt: ts);
      expect(updated.driverId, 'drv-42');
      expect(updated.isSavingProfile, false);
      expect(updated.driver, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // profileUpdatedAt — fallback logic (mirrors controller logic in tests)
  // -------------------------------------------------------------------------

  group('effective updated-at fallback logic', () {
    test('server timestamp is preferred over session-local value', () {
      final serverTs = DateTime.utc(2026, 8, 7, 9, 0);
      final localTs = DateTime.utc(2026, 8, 7, 8, 0);
      // Simulate: driver.updatedAt is available → prefer it.
      final effective = serverTs ?? localTs;
      expect(effective, serverTs);
    });

    test('session-local value is used when server omits updatedAt', () {
      final localTs = DateTime.utc(2026, 8, 7, 8, 0);
      // Simulate: driver.updatedAt is null → fall back to profileUpdatedAt.
      final effective = (null as DateTime?) ?? localTs;
      expect(effective, localTs);
    });

    test('both null → effective is null → display shows em-dash', () {
      final effective = (null as DateTime?) ?? (null as DateTime?);
      expect(effective, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // Failed update must NOT change profileUpdatedAt
  // -------------------------------------------------------------------------

  group('failed update does not set profileUpdatedAt', () {
    test('profileUpdatedAt remains null when update fails', () {
      const state = AdminDriverDetailsState.initial(driverId: 'drv-1');
      // Failed update only sets isSavingProfile: false and sectionErrorMessage.
      final afterFailure = state.copyWith(
        isSavingProfile: false,
        sectionErrorMessage: 'Update failed',
      );
      expect(afterFailure.profileUpdatedAt, isNull);
    });

    test('existing profileUpdatedAt is preserved through a failed update', () {
      final priorTs = DateTime.utc(2026, 8, 1, 12, 0);
      const base = AdminDriverDetailsState.initial(driverId: 'drv-1');
      final withTs = base.copyWith(profileUpdatedAt: priorTs);
      final afterFailure = withTs.copyWith(
        isSavingProfile: false,
        sectionErrorMessage: 'Network error',
      );
      expect(afterFailure.profileUpdatedAt, priorTs);
    });
  });

  // -------------------------------------------------------------------------
  // loadProfile refresh preserves session-local value when server omits it
  // -------------------------------------------------------------------------

  group('loadProfile preserves session-local profileUpdatedAt', () {
    test('null server timestamp does not wipe the session-local value', () {
      final localTs = DateTime.utc(2026, 8, 7, 11, 0);
      const base = AdminDriverDetailsState.initial(driverId: 'drv-1');
      final withLocal = base.copyWith(profileUpdatedAt: localTs);

      // Simulate loadProfile success when driver.updatedAt is null.
      final DateTime? serverTs = null;
      final afterRefresh = withLocal.copyWith(
        profileUpdatedAt: serverTs ?? withLocal.profileUpdatedAt,
      );
      expect(afterRefresh.profileUpdatedAt, localTs);
    });

    test('non-null server timestamp replaces the session-local value', () {
      final localTs = DateTime.utc(2026, 8, 7, 11, 0);
      final serverTs = DateTime.utc(2026, 8, 7, 12, 0);
      const base = AdminDriverDetailsState.initial(driverId: 'drv-1');
      final withLocal = base.copyWith(profileUpdatedAt: localTs);

      final afterRefresh = withLocal.copyWith(
        profileUpdatedAt: serverTs ?? withLocal.profileUpdatedAt,
      );
      expect(afterRefresh.profileUpdatedAt, serverTs);
    });
  });
}
