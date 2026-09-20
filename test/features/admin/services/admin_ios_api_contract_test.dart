import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/utils/validators.dart';
import 'package:open_vts/features/admin/models/admin_payments_model.dart';
import 'package:open_vts/features/admin/models/admin_user_details_model.dart'
    show AdminRenewVehiclesPaymentRequest;
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/services/admin_payments_service.dart';
import 'package:open_vts/features/admin/services/admin_settings_service.dart';
import 'package:open_vts/features/admin/services/admin_user_details_service.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('SMTP test posts the named email field expected by the controller', () async {
    final requests = <RequestOptions>[];
    final service = AdminSettingsService(_client(requests));
    await service.testSmtp('  operator@example.com  ');
    expect(requests.single.method, 'POST');
    expect(requests.single.path, '/admin/testsmtp');
    expect(requests.single.data, {'email': 'operator@example.com'});
  });

  test('new user permits absent optional email and location fields', () {
    const request = AdminCreateUserRequest(
      name: 'Operator', email: ' ', mobilePrefix: '+1',
      mobileNumber: '2025550100', username: 'operator',
      password: 'ExampleSecret123', companyName: '', address: '1 Main Street',
      countryCode: 'us', stateCode: ' ', city: '', pincode: '',
    );
    final payload = request.toJson();
    expect(payload.containsKey('email'), isFalse);
    expect(payload.containsKey('stateCode'), isFalse);
    expect(payload.containsKey('city'), isFalse);
    expect(payload['countryCode'], 'US');
    expect(Validators.adminEmailOptional(''), isNull);
    expect(Validators.adminEmailOptional('invalid-address'), isNotNull);
    expect(const AdminUpdateUserRequest(email: '').toJson()['email'], '');
  });

  test('both iOS renewal entry points reject before issuing any request', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final requests = <RequestOptions>[];
    final client = _client(requests);
    await expectLater(
      AdminPaymentsService(client).renewVehicles(const AdminRenewPaymentRequest(
        userId: '12', vehicleIds: ['34'], paymentMode: AdminPaymentMode.cash,
      )),
      throwsUnsupportedError,
    );
    await expectLater(
      AdminUserDetailsService(client).renewVehiclesPayment(
        const AdminRenewVehiclesPaymentRequest(
          userId: '12', vehicleIds: ['34'], paymentMode: 'CASH',
        ),
      ),
      throwsUnsupportedError,
    );
    expect(requests, isEmpty);
  });

  test('iOS retains payment history access', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final requests = <RequestOptions>[];
    final service = AdminPaymentsService(_client(requests));
    await service.getPayments(userId: '12');
    expect(requests.single.method, 'GET');
    expect(requests.single.path, '/admin/payments');
    expect(requests.single.queryParameters['userId'], '12');
  });

  test('Android renewal preserves the backend mutation contract', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final requests = <RequestOptions>[];
    await AdminPaymentsService(_client(requests)).renewVehicles(
      const AdminRenewPaymentRequest(
        userId: '12', vehicleIds: ['34'], paymentMode: AdminPaymentMode.cash,
        reference: ' receipt-1 ', amountOverride: '150.00',
      ),
    );
    expect(requests.single.method, 'POST');
    expect(requests.single.path, '/admin/payments/renew');
    expect(requests.single.data, {
      'userId': 12, 'vehicleIds': [34], 'paymentMode': 'CASH',
      'reference': 'receipt-1', 'amountOverride': '150.00',
    });
  });
}

ApiClient _client(List<RequestOptions> requests) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    requests.add(options);
    handler.resolve(Response<dynamic>(
      requestOptions: options,
      statusCode: 200,
      data: {'action': true, 'data': <String, dynamic>{'items': [], 'total': 0}},
    ));
  }));
  return ApiClient(dio);
}
