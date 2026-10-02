import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_dashboard_model.dart';

void main() {
  group('AdminDashboardTotals.fromJson', () {
    test('reads totalVehicles and totalUsers from backend field names', () {
      final totals = AdminDashboardTotals.fromJson(const <String, dynamic>{
        'totalVehicles': 86,
        'totalUsers': 19,
      });
      expect(totals.totalVehicles, 86);
      expect(totals.totalUsers, 19);
    });

    test('falls back to alias field names', () {
      final totals = AdminDashboardTotals.fromJson(const <String, dynamic>{
        'vehiclesCount': 10,
        'usersCount': 3,
      });
      expect(totals.totalVehicles, 10);
      expect(totals.totalUsers, 3);
    });

    test('defaults to 0 when fields are absent', () {
      final totals = AdminDashboardTotals.fromJson(const <String, dynamic>{});
      expect(totals.totalVehicles, 0);
      expect(totals.totalUsers, 0);
    });
  });

  group('AdminVehicleLiveStatus.fromJson', () {
    // Backend invariant: all = running + stop + inactive + noData.
    // connected is a cross-cutting subset, NOT an additive bucket.
    test('uses explicit all field when present', () {
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'all': 76,
          'connected': 54,
          'running': 24,
          'stop': 18,
          'inactive': 4,
          'noData': 10,
          'noDevice': 10,
        },
        totalVehicles: 86,
      );
      expect(status.all, 76);
      expect(status.connected, 54);
      expect(status.running, 24);
      expect(status.stop, 18);
      expect(status.inactive, 4);
      expect(status.noData, 10);
      expect(status.noDevice, 10);
    });

    test('derives all from running+stop+inactive+noData, excludes connected',
        () {
      // connected=54 must NOT inflate the derived total.
      // running(24)+stop(18)+inactive(4)+noData(10) = 56, not 110.
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'connected': 54,
          'running': 24,
          'stop': 18,
          'inactive': 4,
          'noData': 10,
          'noDevice': 10,
        },
        totalVehicles: 86,
      );
      expect(status.all, 56);
      expect(status.connected, 54);
    });

    test('derived all does not include connected even when connected is large',
        () {
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'connected': 100,
          'running': 5,
          'stop': 3,
          'inactive': 1,
          'noData': 1,
        },
        totalVehicles: 20,
      );
      expect(status.all, 10); // 5+3+1+1
    });

    test('computes noDevice from totalVehicles when not explicit', () {
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'all': 76,
          'connected': 54,
          'running': 24,
          'stop': 18,
          'inactive': 4,
          'noData': 10,
        },
        totalVehicles: 86,
      );
      // 86 - 76 = 10
      expect(status.noDevice, 10);
    });

    test('noDevice never goes negative', () {
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'all': 90,
          'connected': 50,
          'running': 50,
          'stop': 20,
          'inactive': 10,
          'noData': 10,
        },
        totalVehicles: 86,
      );
      expect(status.noDevice, 0);
    });

    test('all never goes negative', () {
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'connected': 0,
          'running': 0,
          'stop': 0,
          'inactive': 0,
          'noData': 0,
        },
        totalVehicles: 5,
      );
      expect(status.all, 0);
    });

    test('reads notInstalled as deprecated alias for noDevice', () {
      final status = AdminVehicleLiveStatus.fromJson(
        const <String, dynamic>{
          'all': 70,
          'connected': 40,
          'running': 20,
          'stop': 10,
          'inactive': 5,
          'noData': 5,
          'notInstalled': 8,
        },
        totalVehicles: 78,
      );
      // explicit noDevice absent; notInstalled used as fallback
      expect(status.noDevice, 8);
      expect(status.notInstalled, 8);
    });
  });

  group('AdminRecentUser.fromJson', () {
    test('parses all six fields from live backend shape', () {
      final user = AdminRecentUser.fromJson(const <String, dynamic>{
        'uid': 7,
        'name': 'Daniel',
        'username': 'daniel',
        'email': 'daniel125@gmail.com',
        'createdAt': '2026-07-01T10:00:00.000Z',
        'isActive': true,
      });
      expect(user.uid, 7);
      expect(user.name, 'Daniel');
      expect(user.username, 'daniel');
      expect(user.email, 'daniel125@gmail.com');
      expect(user.createdAt, isNotNull);
      expect(user.isActive, isTrue);
      expect(user.vehicleCount, isNull);
    });

    test('vehicleCount is null when backend omits the field', () {
      final user = AdminRecentUser.fromJson(const <String, dynamic>{
        'uid': 8,
        'name': 'Robert',
        'username': 'robert',
        'email': 'robert@example.com',
        'createdAt': '2026-07-10T08:00:00.000Z',
        'isActive': true,
      });
      expect(user.vehicleCount, isNull);
    });

    test(
        'vehicleCount parses backend field totalvehicles (GET /admin/users shape)',
        () {
      final user = AdminRecentUser.fromJson(const <String, dynamic>{
        'uid': 9,
        'name': 'Prerna',
        'username': 'prerna',
        'email': 'prerna@example.com',
        'createdAt': '2026-07-15T12:00:00.000Z',
        'isActive': false,
        'totalvehicles': 9,
      });
      expect(user.vehicleCount, 9);
    });

    test('vehicleCount also parses camelCase vehicleCount field', () {
      final user = AdminRecentUser.fromJson(const <String, dynamic>{
        'uid': 10,
        'name': 'Ali',
        'username': 'ali',
        'email': 'ali@example.com',
        'createdAt': '2026-07-20T08:00:00.000Z',
        'isActive': true,
        'vehicleCount': 5,
      });
      expect(user.vehicleCount, 5);
    });

    test('vehicleCount of zero is preserved (not treated as absent)', () {
      final user = AdminRecentUser.fromJson(const <String, dynamic>{
        'uid': 11,
        'name': 'New User',
        'username': 'newuser',
        'email': 'new@example.com',
        'createdAt': '2026-08-01T00:00:00.000Z',
        'isActive': true,
        'vehicleCount': 0,
      });
      expect(user.vehicleCount, 0);
    });

    test('listFromJson parses a list correctly', () {
      final users = AdminRecentUser.listFromJson(<dynamic>[
        <String, dynamic>{
          'uid': 1,
          'name': 'A',
          'username': 'a',
          'email': 'a@x.com',
          'createdAt': '2026-01-01T00:00:00.000Z',
          'isActive': true,
        },
        <String, dynamic>{
          'uid': 2,
          'name': 'B',
          'username': 'b',
          'email': 'b@x.com',
          'createdAt': '2026-02-01T00:00:00.000Z',
          'isActive': false,
          'vehicleCount': 3,
        },
        // Empty map should be filtered out
        <String, dynamic>{},
      ]);
      expect(users.length, 2);
      expect(users[0].vehicleCount, isNull);
      expect(users[1].vehicleCount, 3);
    });
  });

  group('AdminDashboardSummary.fromJson — totals parsing', () {
    test('reads totals from nested totals object (live backend shape)', () {
      final summary = AdminDashboardSummary.fromJson(<String, dynamic>{
        'status': 'success',
        'data': <String, dynamic>{
          'generatedAt': '2026-08-01T00:00:00.000Z',
          'selectedCurrency': 'INR',
          'defaultCurrency': 'INR',
          'availableCurrencies': <String>['INR'],
          'currency': 'INR',
          'totals': <String, dynamic>{
            'totalVehicles': 86,
            'totalUsers': 19,
          },
          'revenue': <String, dynamic>{},
          'expiry': <String, dynamic>{},
          'installs': <String, dynamic>{},
          'vehicleLiveStatus': <String, dynamic>{
            'all': 76,
            'connected': 54,
            'running': 24,
            'stop': 18,
            'inactive': 4,
            'noData': 10,
            'noDevice': 10,
          },
          'graph': <dynamic>[],
          'graphMeta': <String, dynamic>{},
          'topClients': <dynamic>[],
          'recent': <String, dynamic>{
            'users': <dynamic>[],
            'vehicles': <dynamic>[],
            'payments': <dynamic>[],
          },
        },
      });

      expect(summary.totals.totalVehicles, 86);
      expect(summary.totals.totalUsers, 19);
      expect(summary.vehicleLiveStatus.all, 76);
      expect(summary.vehicleLiveStatus.connected, 54);
      expect(summary.vehicleLiveStatus.noDevice, 10);
    });

    test('totalVehicles and totalUsers are from API, not derived from any list',
        () {
      // The API returns totals as a COUNT(*) from the database.
      // They must never be derived from recent.users.length or recent.vehicles.length.
      final summary = AdminDashboardSummary.fromJson(<String, dynamic>{
        'generatedAt': '2026-08-01T00:00:00.000Z',
        'selectedCurrency': 'USD',
        'defaultCurrency': 'USD',
        'availableCurrencies': <String>['USD'],
        'currency': 'USD',
        'totals': <String, dynamic>{
          'totalVehicles': 500,
          'totalUsers': 200,
        },
        'revenue': <String, dynamic>{},
        'expiry': <String, dynamic>{},
        'installs': <String, dynamic>{},
        'vehicleLiveStatus': <String, dynamic>{
          'all': 480,
          'connected': 300,
          'running': 200,
          'stop': 150,
          'inactive': 80,
          'noData': 50,
          'noDevice': 20,
        },
        'graph': <dynamic>[],
        'graphMeta': <String, dynamic>{},
        'topClients': <dynamic>[],
        'recent': <String, dynamic>{
          // Only 3 items returned here — totals must still be 500/200
          'users': <dynamic>[
            <String, dynamic>{
              'uid': 1,
              'name': 'A',
              'username': 'a',
              'email': 'a@x.com',
              'createdAt': '2026-01-01T00:00:00.000Z',
              'isActive': true,
            },
          ],
          'vehicles': <dynamic>[
            <String, dynamic>{
              'id': 1,
              'name': 'V',
              'liveStatus': 'RUNNING',
              'hasDevice': true,
              'isLicenseBlocked': false,
            },
          ],
          'payments': <dynamic>[],
        },
      });

      expect(summary.totalVehicles, 500,
          reason:
              'totalVehicles must come from totals, not recent list length');
      expect(summary.totalUsers, 200,
          reason: 'totalUsers must come from totals, not recent list length');
    });
  });
}
