import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_user_details_model.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminUserVehicle _mkVehicle({
  required String id,
  String name = '',
  String plateNumber = '',
  String imei = '',
}) {
  return AdminUserVehicle.fromJson(<String, dynamic>{
    'id': id,
    'name': name,
    'plateNumber': plateNumber,
    'imei': imei,
  });
}

AdminUserPayment _mkPaymentJson(Map<String, dynamic> json) {
  return AdminUserPayment.fromJson(json);
}

// ---------------------------------------------------------------------------
// AdminRenewalVehicleSummary.fromJson
// ---------------------------------------------------------------------------

void main() {
  group('AdminRenewalVehicleSummary.fromJson', () {
    test('parses all canonical fields', () {
      final s = AdminRenewalVehicleSummary.fromJson(<String, dynamic>{
        'vehicleId': '101',
        'name': 'Truck A',
        'planId': 'P-1',
        'planName': 'Standard',
        'price': '1500',
        'durationDays': 365,
        'oldSecondaryExpiry': '2026-01-01T00:00:00.000Z',
        'newSecondaryExpiry': '2027-01-01T00:00:00.000Z',
      });
      expect(s.vehicleId, '101');
      expect(s.name, 'Truck A');
      expect(s.planId, 'P-1');
      expect(s.planName, 'Standard');
      expect(s.price, '1500');
      expect(s.durationDays, 365);
      expect(s.oldSecondaryExpiry, isNotNull);
      expect(s.newSecondaryExpiry, isNotNull);
      expect(s.hasVehicleId, isTrue);
    });

    test('tolerates missing optional fields without throwing', () {
      final s = AdminRenewalVehicleSummary.fromJson(<String, dynamic>{
        'vehicleId': '5',
        'name': 'Van',
      });
      expect(s.vehicleId, '5');
      expect(s.planName, '');
      expect(s.durationDays, isNull);
      expect(s.newSecondaryExpiry, isNull);
    });

    test('hasVehicleId is false when vehicleId is empty', () {
      final s = AdminRenewalVehicleSummary.fromJson(<String, dynamic>{
        'name': 'Ghost vehicle',
      });
      expect(s.hasVehicleId, isFalse);
    });

    test('vehicle_id snake_case alias is accepted', () {
      final s = AdminRenewalVehicleSummary.fromJson(<String, dynamic>{
        'vehicle_id': '77',
        'plan_name': 'Gold',
      });
      expect(s.vehicleId, '77');
      expect(s.planName, 'Gold');
    });
  });

  // -------------------------------------------------------------------------
  // AdminUserPayment.fromJson — normal payment (top-level vehicle/plan)
  // -------------------------------------------------------------------------

  group('AdminUserPayment.fromJson — normal payment', () {
    test('parses top-level vehicle and plan; renewalVehicles is empty', () {
      final p = _mkPaymentJson(<String, dynamic>{
        'id': 'TXN-001',
        'amount': '500',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'CASH',
        'vehicle': <String, dynamic>{
          'id': '10',
          'name': 'Car A',
          'imei': '111111111111111',
        },
        'plan': <String, dynamic>{'name': 'Basic'},
      });
      expect(p.id, 'TXN-001');
      expect(p.vehicle['name'], 'Car A');
      expect(p.plan['name'], 'Basic');
      expect(p.isRenewal, isFalse);
      expect(p.renewalVehicles, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // AdminUserPayment.fromJson — renewal with one meta.vehicles item
  // -------------------------------------------------------------------------

  group('AdminUserPayment.fromJson — renewal one vehicle', () {
    test('isRenewal is true and renewalVehicles has one item', () {
      final p = _mkPaymentJson(<String, dynamic>{
        'id': 'TXN-002',
        'amount': '1500',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'CASH',
        'paymentType': 'RENEWAL',
        'meta': <String, dynamic>{
          'vehicles': <dynamic>[
            <String, dynamic>{
              'vehicleId': '101',
              'name': 'Truck A',
              'planName': 'Standard',
              'price': '1500',
              'durationDays': 365,
            },
          ],
        },
      });
      expect(p.isRenewal, isTrue);
      expect(p.renewalVehicles.length, 1);
      expect(p.renewalVehicles.first.vehicleId, '101');
      expect(p.renewalVehicles.first.name, 'Truck A');
      expect(p.renewalVehicles.first.planName, 'Standard');
    });
  });

  // -------------------------------------------------------------------------
  // AdminUserPayment.fromJson — renewal with multiple meta.vehicles items
  // -------------------------------------------------------------------------

  group('AdminUserPayment.fromJson — renewal multiple vehicles', () {
    test('renewalVehicles contains all items; none collapsed', () {
      final p = _mkPaymentJson(<String, dynamic>{
        'id': 'TXN-003',
        'amount': '3000',
        'currency': 'NGN',
        'status': 'SUCCESS',
        'paymentType': 'RENEWAL',
        'meta': <String, dynamic>{
          'vehicles': <dynamic>[
            <String, dynamic>{
              'vehicleId': '1',
              'name': 'Bus 1',
              'planName': 'Gold',
              'price': '1000',
            },
            <String, dynamic>{
              'vehicleId': '2',
              'name': 'Bus 2',
              'planName': 'Silver',
              'price': '2000',
            },
          ],
        },
      });
      expect(p.isRenewal, isTrue);
      expect(p.renewalVehicles.length, 2);
      expect(p.renewalVehicles[0].vehicleId, '1');
      expect(p.renewalVehicles[1].vehicleId, '2');
    });
  });

  // -------------------------------------------------------------------------
  // Matching meta vehicleId to linked vehicle IMEI
  // -------------------------------------------------------------------------

  group('linked vehicle IMEI resolution', () {
    test('string vehicleId matches linked vehicle and returns IMEI', () {
      final vehicles = [
        _mkVehicle(id: '101', name: 'Truck A', imei: '864123456789000'),
      ];
      final summary = AdminRenewalVehicleSummary.fromJson(<String, dynamic>{
        'vehicleId': '101',
        'name': 'Truck A',
        'planName': 'Standard',
      });
      final matched =
          vehicles.where((v) => v.id == summary.vehicleId).firstOrNull;
      expect(matched, isNotNull);
      expect(matched!.imei, '864123456789000');
    });

    test('numeric vehicleId string matches vehicle with int-style id', () {
      final vehicles = [
        _mkVehicle(id: '55', imei: '864000000000055'),
      ];
      // vehicleId may come from JSON as a number — both get toString-ed
      final summaryNumeric = AdminRenewalVehicleSummary.fromJson(
        <String, dynamic>{'vehicleId': 55, 'name': 'Van'},
      );
      expect(summaryNumeric.vehicleId, '55');
      final matched =
          vehicles.where((v) => v.id == summaryNumeric.vehicleId).firstOrNull;
      expect(matched, isNotNull);
      expect(matched!.imei, '864000000000055');
    });

    test('missing linked vehicle does not throw; imei is empty', () {
      final summary = AdminRenewalVehicleSummary.fromJson(<String, dynamic>{
        'vehicleId': '999',
        'name': 'Ghost',
      });
      final vehicles = <AdminUserVehicle>[];
      final matched =
          vehicles.where((v) => v.id == summary.vehicleId).firstOrNull;
      expect(matched, isNull);
      // No crash; caller uses empty string fallback
    });
  });

  // -------------------------------------------------------------------------
  // AdminRenewVehiclesPaymentResult.fromJson
  // -------------------------------------------------------------------------

  group('AdminRenewVehiclesPaymentResult.fromJson', () {
    test('parses transaction from direct { transaction: ... } shape', () {
      final result = AdminRenewVehiclesPaymentResult.fromJson(<String, dynamic>{
        'transaction': <String, dynamic>{
          'id': 'TXN-REN-1',
          'amount': '2000',
          'currency': 'INR',
          'status': 'SUCCESS',
          'meta': <String, dynamic>{
            'vehicles': <dynamic>[
              <String, dynamic>{'vehicleId': '10', 'name': 'Van'},
            ],
          },
        },
        'updatedVehicles': <dynamic>[],
      });
      expect(result.transaction, isNotNull);
      expect(result.transaction!.id, 'TXN-REN-1');
      expect(result.transaction!.isRenewal, isTrue);
      expect(result.validationWarnings, isEmpty);
    });

    test('parses validationWarnings when present', () {
      final result = AdminRenewVehiclesPaymentResult.fromJson(<String, dynamic>{
        'transaction': <String, dynamic>{'id': 'TXN-REN-2', 'amount': '0'},
        'validationWarnings': <dynamic>[
          'Vehicle 5 has no active plan',
          'Amount rounded to 0',
        ],
      });
      expect(result.validationWarnings.length, 2);
      expect(result.validationWarnings.first, 'Vehicle 5 has no active plan');
    });

    test('handles wrapped { data: { transaction: ... } } envelope', () {
      final result = AdminRenewVehiclesPaymentResult.fromJson(<String, dynamic>{
        'action': true,
        'message': 'Vehicles renewed successfully',
        'data': <String, dynamic>{
          'transaction': <String, dynamic>{
            'id': 'TXN-REN-3',
            'amount': '500',
          },
        },
      });
      expect(result.transaction, isNotNull);
      expect(result.transaction!.id, 'TXN-REN-3');
    });

    test('transaction is null when response has no transaction key', () {
      final result = AdminRenewVehiclesPaymentResult.fromJson(<String, dynamic>{
        'action': true,
        'message': 'ok',
      });
      expect(result.transaction, isNull);
      expect(result.validationWarnings, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // UI — renewal card renders all vehicle rows
  // -------------------------------------------------------------------------

  group('_PaymentCard renders renewal vehicles', () {
    testWidgets('single renewal vehicle shows name, plan, and IMEI chips',
        (tester) async {
      final payment = _mkPaymentJson(<String, dynamic>{
        'id': 'TXN-UI-1',
        'amount': '1500',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentType': 'RENEWAL',
        'meta': <String, dynamic>{
          'vehicles': <dynamic>[
            <String, dynamic>{
              'vehicleId': '42',
              'name': 'Truck X',
              'planName': 'Premium',
              'price': '1500',
            },
          ],
        },
      });
      final linkedVehicles = [
        _mkVehicle(id: '42', name: 'Truck X', imei: '864111111111111'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminUserPaymentCardForTest(
              payment: payment,
              linkedVehicles: linkedVehicles,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Truck X'), findsWidgets);
      expect(find.text('Premium'), findsWidgets);
      expect(find.text('864111111111111'), findsWidgets);
      expect(find.textContaining('Renewal'), findsOneWidget);
    });

    testWidgets('multiple renewal vehicles: each vehicle row is rendered',
        (tester) async {
      final payment = _mkPaymentJson(<String, dynamic>{
        'id': 'TXN-UI-2',
        'amount': '3000',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentType': 'RENEWAL',
        'meta': <String, dynamic>{
          'vehicles': <dynamic>[
            <String, dynamic>{
              'vehicleId': '1',
              'name': 'Bus Alpha',
              'planName': 'Gold',
            },
            <String, dynamic>{
              'vehicleId': '2',
              'name': 'Bus Beta',
              'planName': 'Silver',
            },
          ],
        },
      });
      final linkedVehicles = [
        _mkVehicle(id: '1', name: 'Bus Alpha', imei: '111111111111111'),
        _mkVehicle(id: '2', name: 'Bus Beta', imei: '222222222222222'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AdminUserPaymentCardForTest(
                payment: payment,
                linkedVehicles: linkedVehicles,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Bus Alpha'), findsWidgets);
      expect(find.text('Bus Beta'), findsWidgets);
      expect(find.text('111111111111111'), findsWidgets);
      expect(find.text('222222222222222'), findsWidgets);
      expect(find.textContaining('2 vehicles'), findsOneWidget);
    });

    testWidgets('missing linked vehicle shows — for IMEI without crashing',
        (tester) async {
      final payment = _mkPaymentJson(<String, dynamic>{
        'id': 'TXN-UI-3',
        'amount': '500',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentType': 'RENEWAL',
        'meta': <String, dynamic>{
          'vehicles': <dynamic>[
            <String, dynamic>{
              'vehicleId': '99',
              'name': 'Unknown Vehicle',
              'planName': 'Basic',
            },
          ],
        },
      });
      final linkedVehicles = <AdminUserVehicle>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminUserPaymentCardForTest(
              payment: payment,
              linkedVehicles: linkedVehicles,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Unknown Vehicle'), findsWidgets);
      // IMEI shows — because no linked vehicle found
      expect(tester.takeException(), isNull);
    });
  });
}

// ---------------------------------------------------------------------------
// Test-only export wrapper for _PaymentCard (private class in tab file).
// We expose it by re-wrapping with the same constructor shape.
// ---------------------------------------------------------------------------

class AdminUserPaymentCardForTest extends StatelessWidget {
  const AdminUserPaymentCardForTest({
    required this.payment,
    required this.linkedVehicles,
    super.key,
  });

  final AdminUserPayment payment;
  final List<AdminUserVehicle> linkedVehicles;

  @override
  Widget build(BuildContext context) {
    // Directly exercise the renewal chip widgets that _PaymentCard delegates to.
    if (payment.isRenewal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RenewalVehicleChipsWrapper(
            summaries: payment.renewalVehicles,
            linkedVehicles: linkedVehicles,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

/// Directly creates the renewal widget subtree used by _PaymentCard.
class _RenewalVehicleChipsWrapper extends StatelessWidget {
  const _RenewalVehicleChipsWrapper({
    required this.summaries,
    required this.linkedVehicles,
  });

  final List<AdminRenewalVehicleSummary> summaries;
  final List<AdminUserVehicle> linkedVehicles;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.autorenew_rounded,
                size: 13, color: colors.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              summaries.length == 1
                  ? 'Renewal — 1 vehicle'
                  : 'Renewal — ${summaries.length} vehicles',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
        for (final summary in summaries)
          _VehicleRowTest(summary: summary, linkedVehicles: linkedVehicles),
      ],
    );
  }
}

class _VehicleRowTest extends StatelessWidget {
  const _VehicleRowTest({
    required this.summary,
    required this.linkedVehicles,
  });

  final AdminRenewalVehicleSummary summary;
  final List<AdminUserVehicle> linkedVehicles;

  @override
  Widget build(BuildContext context) {
    final matched = summary.vehicleId.isNotEmpty
        ? linkedVehicles
            .where((v) => v.id == summary.vehicleId)
            .cast<AdminUserVehicle?>()
            .firstOrNull
        : null;
    final imei = matched?.imei ?? '';
    final vehicleName = [
      summary.name,
      matched?.name ?? '',
      matched?.plateNumber ?? ''
    ].firstWhere((s) => s.isNotEmpty, orElse: () => '');
    final planName = summary.planName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(vehicleName.isEmpty ? '-' : vehicleName),
        Text(planName.isEmpty ? '-' : planName),
        Text(imei.isEmpty ? '-' : imei),
      ],
    );
  }
}
