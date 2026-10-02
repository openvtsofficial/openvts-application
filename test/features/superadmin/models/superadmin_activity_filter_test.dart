import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/superadmin/models/superadmin_activity_filter.dart';

void main() {
  group('administrator activity categories', () {
    test('maps chips to valid backend prefixes', () {
      expect(SuperadminActivityCategory.all.backendPrefix, isNull);
      expect(SuperadminActivityCategory.security.backendPrefix, 'ADMIN.AUTH');
      expect(
          SuperadminActivityCategory.vehicles.backendPrefix, 'ADMIN.VEHICLE');
      expect(SuperadminActivityCategory.drivers.backendPrefix, 'ADMIN.DRIVER');
      expect(SuperadminActivityCategory.security.backendPrefix, isNot('AUTH'));
      expect(
          SuperadminActivityCategory.vehicles.backendPrefix, isNot('VEHICLE'));
    });

    test('settings matches confirmed generated resources', () {
      final filter = SuperadminActivityCategory.settings;
      expect(filter.backendPrefix, 'ADMIN.');
      expect(filter.matches('ADMIN.PROFILE.UPDATE'), isTrue);
      expect(filter.matches('ADMIN.SMTP_CONFIG.UPDATE'), isTrue);
      expect(filter.matches('ADMIN.LOCALIZATION_DATA.UPDATE'), isTrue);
      expect(filter.matches('ADMIN.WHITE_LABEL_SETTINGS.UPDATE'), isTrue);
      expect(filter.matches('ADMIN.VEHICLE.CREATE'), isFalse);
    });

    test('billing matches confirmed generated resources', () {
      final filter = SuperadminActivityCategory.billing;
      expect(filter.matches('ADMIN.PRICING_PLAN.CREATE'), isTrue);
      expect(filter.matches('ADMIN.VEHICLES_PAYMENT.RENEW'), isTrue);
      expect(filter.matches('ADMIN.TRANSACTION.CREATE'), isTrue);
      expect(filter.matches('ADMIN.DRIVER.UPDATE'), isFalse);
    });
  });

  test('activity timestamps preserve time and serialize as UTC ISO-8601', () {
    final value = DateTime.parse('2026-08-09T15:30:45+05:30');
    expect(serializeActivityDateTime(value), '2026-08-09T10:00:45.000Z');
    expect(serializeActivityDateTime(null), isNull);
  });
}
