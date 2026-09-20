import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_driver_details_model.dart';
import 'package:open_vts/features/admin/models/admin_driver_details_state.dart';
import 'package:open_vts/features/admin/models/admin_drivers_model.dart';

// ---------------------------------------------------------------------------
// These tests verify timestamp state-machine logic in isolation.
// They mirror what the controllers do without requiring real network/storage.
// ---------------------------------------------------------------------------

// Minimal AdminDriverDetails builder for tests.
AdminDriverDetails _mkDriver({
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    AdminDriverDetails(
      id: 'drv-1',
      name: 'Test Driver',
      username: 'testdriver',
      email: 'driver@test.com',
      phone: '+91 9000000000',
      mobilePrefix: '+91',
      mobile: '9000000000',
      isActive: true,
      isVerified: false,
      countryCode: 'IN',
      createdAt: createdAt,
      updatedAt: updatedAt,
      address: const AdminDriverAddress(
        id: '',
        addressLine: '',
        countryCode: '',
        stateCode: '',
        cityId: '',
        pincode: '',
        fullAddress: '',
      ),
      attributes: const {},
    );

void main() {
  // =========================================================================
  // AdminDriverDetailsState.profileUpdatedAt — initial state
  // =========================================================================

  group('AdminDriverDetailsState.initial', () {
    test('profileUpdatedAt is null on initial state', () {
      const state = AdminDriverDetailsState.initial(driverId: 'drv-1');
      expect(state.profileUpdatedAt, isNull);
    });
  });

  // =========================================================================
  // copyWith — profileUpdatedAt propagation
  // =========================================================================

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
  });

  // =========================================================================
  // loadProfile — mirrors controller timestamp resolution
  // =========================================================================

  group('loadProfile timestamp resolution (controller logic mirrored)', () {
    const base = AdminDriverDetailsState.initial(driverId: 'drv-1');

    test('createdAt used as effective when server and persisted are absent',
        () {
      final createdAt = DateTime.utc(2026, 8, 7, 14, 15);
      final driver = _mkDriver(createdAt: createdAt, updatedAt: null);
      // Mirrors: resolveDriverEffectiveUpdatedAt(server: null, persisted: null, created: createdAt)
      final effective = driver.updatedAt ?? driver.createdAt;
      final afterLoad =
          base.copyWith(driver: driver, profileUpdatedAt: effective);
      expect(afterLoad.profileUpdatedAt, createdAt);
    });

    test('server updatedAt wins when present', () {
      final serverTs = DateTime.utc(2026, 8, 7, 9, 0);
      final driver = _mkDriver(
        createdAt: DateTime.utc(2026, 8, 1),
        updatedAt: serverTs,
      );
      final effective = driver.updatedAt;
      final afterLoad =
          base.copyWith(driver: driver, profileUpdatedAt: effective);
      expect(afterLoad.profileUpdatedAt, serverTs);
    });

    test('persisted timestamp used when server omits updatedAt', () {
      final persisted = DateTime.utc(2026, 8, 5, 14, 0);
      final driver = _mkDriver(
        createdAt: DateTime.utc(2026, 8, 1),
        updatedAt: null,
      );
      // Mirrors: resolveDriverEffectiveUpdatedAt(server: null, persisted: persisted, created: ...)
      final effective = driver.updatedAt ?? persisted;
      final afterLoad =
          base.copyWith(driver: driver, profileUpdatedAt: effective);
      expect(afterLoad.profileUpdatedAt, persisted);
    });

    test('null server timestamp does not wipe existing state value', () {
      final existingTs = DateTime.utc(2026, 8, 7, 11, 0);
      final withExisting = base.copyWith(profileUpdatedAt: existingTs);
      final driver = _mkDriver(updatedAt: null, createdAt: null);
      // If both server and persisted are null, state is preserved from prior value.
      final effective = driver.updatedAt ?? existingTs;
      final afterRefresh = withExisting.copyWith(
        driver: driver,
        profileUpdatedAt: effective,
      );
      expect(afterRefresh.profileUpdatedAt, existingTs);
    });
  });

  // =========================================================================
  // updateProfile — successful update sets new timestamp
  // =========================================================================

  group('updateProfile success', () {
    const base = AdminDriverDetailsState.initial(driverId: 'drv-1');

    test('successful updateProfile sets profileUpdatedAt to edit time', () {
      final editTime = DateTime.utc(2026, 8, 7, 15, 40);
      final driver =
          _mkDriver(createdAt: DateTime.utc(2026, 8, 1), updatedAt: null);
      // Mirrors: effectiveUpdatedAt = driver.updatedAt ?? editTime
      final effectiveUpdatedAt = driver.updatedAt ?? editTime;
      final afterUpdate = base.copyWith(
        driver: driver,
        isSavingProfile: false,
        profileUpdatedAt: effectiveUpdatedAt.toLocal(),
      );
      expect(afterUpdate.profileUpdatedAt, isNotNull);
      expect(afterUpdate.isSavingProfile, isFalse);
    });

    test('server updatedAt from response overrides edit time', () {
      final editTime = DateTime.utc(2026, 8, 7, 15, 40);
      final serverTs = DateTime.utc(2026, 8, 7, 15, 41);
      final driver = _mkDriver(updatedAt: serverTs);
      final effectiveUpdatedAt = driver.updatedAt ?? editTime;
      final afterUpdate = base.copyWith(
        driver: driver,
        isSavingProfile: false,
        profileUpdatedAt: effectiveUpdatedAt.toLocal(),
      );
      expect(afterUpdate.profileUpdatedAt, serverTs.toLocal());
    });
  });

  // =========================================================================
  // Failed update — timestamp MUST NOT change
  // =========================================================================

  group('failed updateProfile does not alter timestamp', () {
    test('profileUpdatedAt remains null when update fails', () {
      const state = AdminDriverDetailsState.initial(driverId: 'drv-1');
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

  // =========================================================================
  // AdminDriverListItem.copyWith — updatedAt field
  // =========================================================================

  group('AdminDriverListItem.copyWith updatedAt', () {
    final base = AdminDriverListItem(
      id: 'drv-1',
      firstName: 'Test',
      email: 'test@example.com',
      username: 'test',
      mobilePrefix: '+91',
      mobile: '9000000000',
      phone: '+91 9000000000',
      address: '-',
      fullAddress: '-',
      countryCode: 'IN',
      stateCode: '',
      city: '',
      pincode: '',
      primaryUserName: '-',
      primaryUserUid: '',
      isVerified: false,
      isActive: true,
      statusLabel: 'Active',
      createdAt: DateTime.utc(2026, 8, 7, 14, 15),
      updatedAt: null,
    );

    test('updatedAt can be set via copyWith', () {
      final ts = DateTime.utc(2026, 8, 7, 15, 40);
      final updated = base.copyWith(updatedAt: ts);
      expect(updated.updatedAt, ts);
    });

    test('omitting updatedAt in copyWith preserves the existing value', () {
      final ts = DateTime.utc(2026, 8, 7, 15, 40);
      final withTs = base.copyWith(updatedAt: ts);
      final again = withTs.copyWith(isActive: true);
      expect(again.updatedAt, ts);
    });

    test('explicit null in copyWith clears updatedAt', () {
      final ts = DateTime.utc(2026, 8, 7, 15, 40);
      final withTs = base.copyWith(updatedAt: ts);
      final cleared = withTs.copyWith(updatedAt: null);
      expect(cleared.updatedAt, isNull);
    });

    test('other fields are unaffected when only updatedAt changes', () {
      final ts = DateTime.utc(2026, 8, 7, 15, 40);
      final updated = base.copyWith(updatedAt: ts);
      expect(updated.id, 'drv-1');
      expect(updated.firstName, 'Test');
      expect(updated.createdAt, base.createdAt);
      expect(updated.isActive, true);
    });
  });

  // =========================================================================
  // List enrichment: API list without updatedAt + persisted → enriched list
  // =========================================================================

  group('list enrichment logic', () {
    test('driver without updatedAt receives effective value from createdAt',
        () {
      final createdAt = DateTime.utc(2026, 8, 7, 14, 15);
      final driver = AdminDriverListItem(
        id: 'drv-1',
        firstName: 'Test',
        email: 'test@example.com',
        username: 'test',
        mobilePrefix: '',
        mobile: '',
        phone: '-',
        address: '-',
        fullAddress: '-',
        countryCode: 'IN',
        stateCode: '',
        city: '',
        pincode: '',
        primaryUserName: '-',
        primaryUserUid: '',
        isVerified: false,
        isActive: true,
        statusLabel: 'Active',
        createdAt: createdAt,
        updatedAt: null,
      );

      // Mirrors _fetchDrivers enrichment logic with no persisted value.
      final effective = driver.updatedAt ?? driver.createdAt;
      final enriched = effective == driver.updatedAt
          ? driver
          : driver.copyWith(updatedAt: effective);

      expect(enriched.updatedAt, createdAt);
    });

    test('driver without updatedAt receives persisted timestamp', () {
      final createdAt = DateTime.utc(2026, 8, 1);
      final persisted = DateTime.utc(2026, 8, 5, 14, 0);
      final driver = AdminDriverListItem(
        id: 'drv-2',
        firstName: 'Driver2',
        email: 'd2@example.com',
        username: 'driver2',
        mobilePrefix: '',
        mobile: '',
        phone: '-',
        address: '-',
        fullAddress: '-',
        countryCode: 'IN',
        stateCode: '',
        city: '',
        pincode: '',
        primaryUserName: '-',
        primaryUserUid: '',
        isVerified: false,
        isActive: true,
        statusLabel: 'Active',
        createdAt: createdAt,
        updatedAt: null,
      );

      // Mirrors: resolveDriverEffectiveUpdatedAt(server: null, persisted, created)
      final effective = driver.updatedAt ?? persisted;
      final enriched = driver.copyWith(updatedAt: effective);
      expect(enriched.updatedAt, persisted);
    });

    test(
        'list refresh: existing persisted timestamp survives API response with null updatedAt',
        () {
      final createdAt = DateTime.utc(2026, 8, 1);
      final persisted = DateTime.utc(2026, 8, 5, 14, 0);
      final driver = AdminDriverListItem(
        id: 'drv-2',
        firstName: 'Driver2',
        email: 'd2@example.com',
        username: 'driver2',
        mobilePrefix: '',
        mobile: '',
        phone: '-',
        address: '-',
        fullAddress: '-',
        countryCode: 'IN',
        stateCode: '',
        city: '',
        pincode: '',
        primaryUserName: '-',
        primaryUserUid: '',
        isVerified: false,
        isActive: true,
        statusLabel: 'Active',
        createdAt: createdAt,
        updatedAt: null,
      );

      // Simulate: after refresh, API still has no updatedAt, persisted survives.
      final effective = driver.updatedAt ?? persisted;
      final enriched = driver.copyWith(updatedAt: effective);
      expect(enriched.updatedAt, persisted);
    });
  });

  // =========================================================================
  // Created / Updated semantics: Created must never change
  // =========================================================================

  group('Created vs Updated semantics', () {
    test('createdAt is unchanged after profile edit', () {
      final createdAt = DateTime.utc(2026, 8, 7, 14, 15);
      final driver = _mkDriver(createdAt: createdAt, updatedAt: null);
      expect(driver.createdAt, createdAt);

      // After update, updatedAt changes but createdAt stays the same.
      final editTs = DateTime.utc(2026, 8, 7, 15, 40);
      // The driver returned from the update call still has the same createdAt.
      final updatedDriver = _mkDriver(createdAt: createdAt, updatedAt: editTs);
      expect(updatedDriver.createdAt, createdAt);
      expect(updatedDriver.updatedAt, editTs);
    });
  });
}
