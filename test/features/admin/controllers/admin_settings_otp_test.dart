import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/controllers/admin_settings_controller.dart';
import 'package:open_vts/features/admin/services/admin_settings_service.dart';

void main() {
  test('email business failure exposes the clean backend message', () async {
    final controller = AdminSettingsController(
      AdminSettingsService(
        ApiClient(_otpDio(<String, dynamic>{
          'status': 'success',
          'data': <String, dynamic>{
            'action': false,
            'message': 'SMTP Settings not found',
            'data': <String, dynamic>{'code': 'SMTP_NOT_CONFIGURED'},
          },
        })),
      ),
    );

    expect(await controller.requestEmailOtp(), isFalse);
    expect(controller.state.sectionErrorMessage, 'SMTP Settings not found');
    expect(
        controller.state.sectionErrorMessage, isNot(contains('ApiException')));
  });

  test('WhatsApp business failure exposes the provider message', () async {
    final controller = AdminSettingsController(
      AdminSettingsService(
        ApiClient(_otpDio(<String, dynamic>{
          'status': 'success',
          'data': <String, dynamic>{
            'action': false,
            'message': 'WhatsApp configuration missing',
            'data': <String, dynamic>{'code': 'WHATSAPP_SEND_FAILED'},
          },
        })),
      ),
    );

    expect(await controller.requestWhatsAppOtp(), isFalse);
    expect(
      controller.state.sectionErrorMessage,
      'WhatsApp configuration missing',
    );
  });

  test('duplicate email requests are ignored while one is in flight', () async {
    final responseGate = Completer<void>();
    var requestCount = 0;
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          requestCount++;
          await responseGate.future;
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{
                'status': 'success',
                'data': <String, dynamic>{
                  'action': true,
                  'message': 'OTP sent successfully',
                  'data': null,
                },
              },
            ),
          );
        },
      ),
    );
    final controller = AdminSettingsController(
      AdminSettingsService(ApiClient(dio)),
    );

    final first = controller.requestEmailOtp();
    expect(controller.state.isRequestingEmailOtp, isTrue);
    expect(await controller.requestEmailOtp(), isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(requestCount, 1);
    responseGate.complete();
    expect(await first, isTrue);
  });
}

Dio _otpDio(Map<String, dynamic> body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) => handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: body,
        ),
      ),
    ),
  );
  return dio;
}
