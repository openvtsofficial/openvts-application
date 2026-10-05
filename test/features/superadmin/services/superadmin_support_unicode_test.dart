import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/models/superadmin_support_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_support_service.dart';

void main() {
  test(
    'Unicode-only title and message reach the ticket API unchanged',
    () async {
      RequestOptions? captured;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'action': true,
                  'data': {'id': 9, 'ticketNo': 'SUP-9'},
                },
              ),
            );
          },
        ),
      );
      final created = await SuperadminSupportService(ApiClient(dio))
          .createTicket(
            adminId: 12,
            title: 'वाहन की समस्या',
            message: '位置が更新されません',
            category: SuperadminSupportTicketCategory.maps,
            priority: SuperadminSupportTicketPriority.medium,
          );
      expect(created.ticketId, 9);
      expect(captured!.uri.path, '/api/superadmin/support/tickets');
      final fields = Map<String, String>.fromEntries(
        (captured!.data as FormData).fields,
      );
      expect(fields['title'], 'वाहन की समस्या');
      expect(fields['message'], '位置が更新されません');
      expect(fields['adminId'], '12');
      dio.close();
    },
  );
  test('punctuation-only title rejected before HTTP', () async {
    final dio = Dio();
    await expectLater(
      SuperadminSupportService(ApiClient(dio)).createTicket(
        adminId: 12,
        title: '!!!',
        message: 'Message',
        category: SuperadminSupportTicketCategory.other,
        priority: SuperadminSupportTicketPriority.low,
      ),
      throwsArgumentError,
    );
    dio.close();
  });
}
