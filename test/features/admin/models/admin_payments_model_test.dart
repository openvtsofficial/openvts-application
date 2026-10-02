import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_payments_model.dart';

void main() {
  // ── AdminPaymentTransaction.fromJson ──────────────────────────────────────

  group('AdminPaymentTransaction.fromJson', () {
    test('parses id and amount from canonical field names', () {
      final tx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'TXN-001',
        'amount': '1500',
        'currency': 'INR',
        'status': 'SUCCESS',
        'paymentMode': 'CASH',
        'paymentType': 'RENEWAL',
        'reference': 'REF-001',
        'provider': '',
        'providerRef': '',
        'createdAt': '2026-08-01T10:00:00.000Z',
      });
      expect(tx.id, 'TXN-001');
      expect(tx.amount, '1500');
      expect(tx.currency, 'INR');
      expect(tx.status, AdminPaymentStatus.success);
      expect(tx.paymentMode, AdminPaymentMode.cash);
    });

    test('falls back to transactionId alias for id', () {
      final tx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'transactionId': 'TXN-999',
        'amount': '500',
        'currency': 'USD',
        'status': 'PENDING',
      });
      expect(tx.id, 'TXN-999');
      expect(tx.status, AdminPaymentStatus.pending);
    });

    test('resolves vehicle from vehicleInfo alias', () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-010',
        'amount': '200',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicleInfo': <String, dynamic>{
          'name': 'My Truck',
          'plateNumber': 'KA 01 AB 1234',
          'imei': '864123456789010',
        },
      });
      expect(tx.vehicle['name'], 'My Truck');
      expect(tx.vehicleDisplayName, 'My Truck');
      expect(tx.vehicleImei, '864123456789010');
    });

    test('vehicleDisplayName falls back to plateNumber when name is absent',
        () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-011',
        'amount': '100',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicle': <String, dynamic>{
          'plateNumber': 'MH 12 TX 9999',
        },
      });
      expect(tx.vehicleDisplayName, 'MH 12 TX 9999');
    });

    test('vehicleImei resolved from nested device object', () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-012',
        'amount': '100',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicle': <String, dynamic>{
          'name': 'Car 5',
          'device': <String, dynamic>{'imei': '864000000000001'},
        },
      });
      expect(tx.vehicleImei, '864000000000001');
    });

    test('vehicleImei from gpsDevice alias', () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-013',
        'amount': '100',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicle': <String, dynamic>{
          'name': 'Van 3',
          'gpsDevice': <String, dynamic>{'imei': '864000000000002'},
        },
      });
      expect(tx.vehicleImei, '864000000000002');
    });

    test('planDisplayName resolved from nested vehicle.plan', () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-014',
        'amount': '1200',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicle': <String, dynamic>{
          'name': 'Truck 7',
          'plan': <String, dynamic>{
            'id': 3,
            'name': 'Premium',
            'price': 1200,
          },
        },
      });
      expect(tx.planDisplayName, 'Premium');
    });

    test('planDisplayName falls back to plan.title alias', () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-015',
        'amount': '800',
        'currency': 'INR',
        'status': 'SUCCESS',
        'vehicle': <String, dynamic>{
          'name': 'Bus 1',
          'plan': <String, dynamic>{'title': 'Basic Plan'},
        },
      });
      expect(tx.planDisplayName, 'Basic Plan');
    });

    test(
        'vehicleDisplayName, vehicleImei, planDisplayName are empty when vehicle is absent',
        () {
      final tx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'TXN-016',
        'amount': '0',
        'currency': 'INR',
        'status': 'FAILED',
      });
      expect(tx.vehicleDisplayName, '');
      expect(tx.vehicleImei, '');
      expect(tx.planDisplayName, '');
    });

    test('resolves vehicle from linkedVehicle alias', () {
      final tx = AdminPaymentTransaction.fromJson(<String, dynamic>{
        'id': 'TXN-017',
        'amount': '500',
        'currency': 'INR',
        'status': 'SUCCESS',
        'linkedVehicle': <String, dynamic>{
          'name': 'Sedan 4',
          'plateNumber': 'DL 01 CD 5678',
        },
      });
      expect(tx.vehicleDisplayName, 'Sedan 4');
    });

    test('amountDisplay includes currency prefix', () {
      final tx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'TXN-018',
        'amount': '750',
        'currency': 'USD',
        'status': 'SUCCESS',
      });
      expect(tx.amountDisplay, 'USD 750');
    });

    test('status defaults to pending for unknown value', () {
      final tx = AdminPaymentTransaction.fromJson(const <String, dynamic>{
        'id': 'TXN-019',
        'amount': '0',
        'currency': '',
        'status': 'UNKNOWN_STATUS',
      });
      expect(tx.status, AdminPaymentStatus.pending);
    });
  });

  // ── parseRenewalTransaction ───────────────────────────────────────────────

  group('parseRenewalTransaction', () {
    test('returns transaction from transaction key in backend response', () {
      final json = <String, dynamic>{
        'action': true,
        'message': 'Vehicles renewed successfully',
        'data': <String, dynamic>{
          'transaction': <String, dynamic>{
            'id': 'TXN-REN-001',
            'amount': '1500',
            'currency': 'INR',
            'status': 'SUCCESS',
            'paymentMode': 'CASH',
          },
          'updatedVehicles': <dynamic>[],
        },
      };
      final tx = parseRenewalTransaction(json);
      expect(tx, isNotNull);
      expect(tx!.id, 'TXN-REN-001');
      expect(tx.amount, '1500');
      expect(tx.status, AdminPaymentStatus.success);
    });

    test('returns transaction when nested directly under data', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'id': 'TXN-REN-002',
          'amount': '800',
          'currency': 'USD',
          'status': 'SUCCESS',
          'paymentMode': 'UPI',
        },
      };
      final tx = parseRenewalTransaction(json);
      expect(tx, isNotNull);
      expect(tx!.id, 'TXN-REN-002');
    });

    test('returns null when id is absent in the transaction payload', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'transaction': <String, dynamic>{
            'amount': '500',
            'status': 'SUCCESS',
          },
        },
      };
      final tx = parseRenewalTransaction(json);
      expect(tx, isNull);
    });

    test('returns null for empty json', () {
      expect(parseRenewalTransaction(const <String, dynamic>{}), isNull);
    });

    test('returns null for null input', () {
      expect(parseRenewalTransaction(null), isNull);
    });

    test('transaction from renewal includes vehicle if present', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'transaction': <String, dynamic>{
            'id': 'TXN-REN-003',
            'amount': '1200',
            'currency': 'INR',
            'status': 'SUCCESS',
            'vehicle': <String, dynamic>{
              'name': 'Fleet Truck',
              'plan': <String, dynamic>{'name': 'Fleet Plan'},
            },
          },
        },
      };
      final tx = parseRenewalTransaction(json);
      expect(tx, isNotNull);
      expect(tx!.vehicleDisplayName, 'Fleet Truck');
      expect(tx.planDisplayName, 'Fleet Plan');
    });
  });

  // ── AdminPaymentsPage.fromJson ────────────────────────────────────────────

  group('AdminPaymentsPage.fromJson', () {
    test('parses canonical envelope shape', () {
      final page = AdminPaymentsPage.fromJson(<String, dynamic>{
        'data': <String, dynamic>{
          'page': 1,
          'limit': 10,
          'total': 2,
          'items': <dynamic>[
            <String, dynamic>{'id': 'T1', 'amount': '100', 'status': 'SUCCESS'},
            <String, dynamic>{'id': 'T2', 'amount': '200', 'status': 'PENDING'},
          ],
        },
      });
      expect(page.page, 1);
      expect(page.total, 2);
      expect(page.items.length, 2);
      expect(page.items[0].id, 'T1');
      expect(page.hasMore, isFalse);
    });

    test('hasMore is true when page * limit < total', () {
      final page = AdminPaymentsPage.fromJson(<String, dynamic>{
        'page': 1,
        'limit': 5,
        'total': 20,
        'items': <dynamic>[
          for (var i = 0; i < 5; i++)
            <String, dynamic>{
              'id': 'T$i',
              'amount': '100',
              'status': 'SUCCESS'
            },
        ],
      });
      expect(page.hasMore, isTrue);
    });

    test('filters out items with empty id', () {
      final page = AdminPaymentsPage.fromJson(<String, dynamic>{
        'items': <dynamic>[
          <String, dynamic>{
            'id': 'VALID',
            'amount': '100',
            'status': 'SUCCESS'
          },
          <String, dynamic>{'amount': '200', 'status': 'PENDING'},
        ],
      });
      expect(page.items.length, 1);
      expect(page.items.first.id, 'VALID');
    });

    test('handles bare List input', () {
      final page = AdminPaymentsPage.fromJson(<dynamic>[
        <String, dynamic>{'id': 'T10', 'amount': '50', 'status': 'SUCCESS'},
      ]);
      expect(page.items.length, 1);
    });
  });

  // ── AdminPaymentsAnalytics.fromJson ───────────────────────────────────────

  group('AdminPaymentsAnalytics.fromJson', () {
    test('parses totalTransactions and status breakdown', () {
      final analytics = AdminPaymentsAnalytics.fromJson(<String, dynamic>{
        'data': <String, dynamic>{
          'totalTransactions': 30,
          'statusBreakdown': <String, dynamic>{
            'SUCCESS': 20,
            'PENDING': 5,
            'FAILED': 5,
          },
          'totalsByCurrency': <dynamic>[],
          'modeBreakdown': <dynamic>[],
          'dailySeriesByCurrency': <dynamic>[],
        },
      });
      expect(analytics.totalTransactions, 30);
      expect(analytics.statusBreakdown[AdminPaymentStatus.success], 20);
      expect(analytics.statusBreakdown[AdminPaymentStatus.pending], 5);
      expect(analytics.statusBreakdown[AdminPaymentStatus.failed], 5);
    });

    test('empty() has zero counts', () {
      const analytics = AdminPaymentsAnalytics.empty();
      expect(analytics.totalTransactions, 0);
      expect(analytics.totalsByCurrency, isEmpty);
      expect(analytics.modeBreakdown, isEmpty);
    });
  });

  // ── AdminRenewVehicleOption.fromJson ──────────────────────────────────────

  group('AdminRenewVehicleOption.fromJson', () {
    test('isRenewable is true when planId and plan name are present', () {
      final option = AdminRenewVehicleOption.fromJson(<String, dynamic>{
        'id': '42',
        'name': 'Truck 1',
        'plateNumber': 'KA 01 AB 1111',
        'planId': '3',
        'plan': <String, dynamic>{
          'id': 3,
          'name': 'Premium',
          'price': '1200',
          'currency': 'INR',
          'durationDays': 365,
        },
      });
      expect(option.isRenewable, isTrue);
      expect(option.planName, 'Premium');
      expect(option.planPrice, 1200.0);
      expect(option.planCurrency, 'INR');
    });

    test('isRenewable is false when plan name is absent', () {
      final option = AdminRenewVehicleOption.fromJson(<String, dynamic>{
        'id': '43',
        'name': 'Van 2',
        'plateNumber': 'MH 01 CD 2222',
        'planId': '3',
        'plan': <String, dynamic>{'id': 3},
      });
      expect(option.isRenewable, isFalse);
    });

    test('matchesQuery returns true for name match', () {
      final option = AdminRenewVehicleOption.fromJson(<String, dynamic>{
        'id': '44',
        'name': 'Transit Van',
        'plateNumber': 'DL 01 EF 3333',
        'plan': <String, dynamic>{'id': 1, 'name': 'Basic'},
      });
      expect(option.matchesQuery('transit'), isTrue);
      expect(option.matchesQuery('xyz'), isFalse);
      expect(option.matchesQuery(''), isTrue);
    });
  });

  // ── AdminRenewPaymentRequest.toJson ──────────────────────────────────────

  group('AdminRenewPaymentRequest.toJson', () {
    test('serializes userId and vehicleIds as integers when parseable', () {
      const request = AdminRenewPaymentRequest(
        userId: '7',
        vehicleIds: ['41', '42'],
        paymentMode: AdminPaymentMode.cash,
      );
      final json = request.toJson();
      expect(json['userId'], 7);
      expect(json['vehicleIds'], [41, 42]);
      expect(json['paymentMode'], 'CASH');
      expect(json.containsKey('reference'), isFalse);
      expect(json.containsKey('amountOverride'), isFalse);
    });

    test('falls back to string when userId is not parseable as int', () {
      const request = AdminRenewPaymentRequest(
        userId: 'uid-abc',
        vehicleIds: ['vid-x'],
        paymentMode: AdminPaymentMode.upi,
      );
      final json = request.toJson();
      expect(json['userId'], 'uid-abc');
      expect(json['vehicleIds'], ['vid-x']);
      expect(json['paymentMode'], 'UPI');
    });

    test('includes reference and amountOverride when non-empty', () {
      const request = AdminRenewPaymentRequest(
        userId: '7',
        vehicleIds: ['41'],
        paymentMode: AdminPaymentMode.bankTransfer,
        reference: 'REF-XYZ',
        amountOverride: '999.99',
      );
      final json = request.toJson();
      expect(json['reference'], 'REF-XYZ');
      expect(json['amountOverride'], '999.99');
    });

    test('omits blank reference and amountOverride', () {
      const request = AdminRenewPaymentRequest(
        userId: '7',
        vehicleIds: ['41'],
        paymentMode: AdminPaymentMode.card,
        reference: '   ',
        amountOverride: '',
      );
      final json = request.toJson();
      expect(json.containsKey('reference'), isFalse);
      expect(json.containsKey('amountOverride'), isFalse);
    });
  });
}
