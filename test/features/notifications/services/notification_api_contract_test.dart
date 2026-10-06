import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/services/admin_notification_service.dart';
import 'package:open_vts/features/superadmin/services/superadmin_notification_service.dart';
import 'package:open_vts/features/user/services/user_notification_service.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));

  test('backend page cap does not prematurely stop pagination', () async {
    RequestOptions? request;
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{
                'action': true,
                'data': <String, dynamic>{
                  'items': List.generate(
                    30,
                    (index) => <String, dynamic>{
                      'id': 100 - index,
                      'title': 'Vehicle alert',
                    },
                  ),
                  'nextCursor': 71,
                  'unreadCount': 65,
                },
              },
            ),
          );
        },
      ),
    );

    final page = await SuperadminNotificationService(
      ApiClient(dio),
    ).getNotifications(limit: 100, category: 'SYSTEM');
    expect(request!.queryParameters['limit'], '30');
    expect(request!.queryParameters.containsKey('category'), isFalse);
    expect(page.hasMore, isTrue);
    expect(page.nextBeforeId, 71);
    expect(page.unreadCount, 65);
  });

  test(
    'notification cursor follows the capped page through its final rows',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            final isFinalPage = request.queryParameters['beforeId'] == '71';
            handler.resolve(
              Response<dynamic>(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'action': true,
                  'data': {
                    'items': List.generate(
                      isFinalPage ? 2 : 30,
                      (index) => {
                        'id': (isFinalPage ? 70 : 100) - index,
                        'title': 'Vehicle alert',
                      },
                    ),
                    'nextCursor': isFinalPage ? 69 : 71,
                  },
                },
              ),
            );
          },
        ),
      );
      final service = SuperadminNotificationService(ApiClient(dio));
      final first = await service.getNotifications(
        limit: 100,
        unreadOnly: true,
      );
      final last = await service.getNotifications(
        limit: 100,
        beforeId: first.nextBeforeId,
        unreadOnly: true,
      );
      expect(first.hasMore, isTrue);
      expect(last.hasMore, isFalse);
      expect(last.items.map((item) => item.id), [70, 69]);
      expect(requests.last.queryParameters, {
        'limit': '30',
        'beforeId': '71',
        'unreadOnly': 'true',
      });
    },
  );

  test(
    'category query is retained only for the Admin endpoint accepting it',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response<dynamic>(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'action': true,
                  'data': {'items': <dynamic>[]},
                },
              ),
            );
          },
        ),
      );
      final client = ApiClient(dio);
      await AdminNotificationService(
        client,
      ).getNotifications(limit: 0, category: ' SYSTEM ');
      await UserNotificationService(
        client,
      ).getNotifications(limit: 100, category: 'SYSTEM');
      expect(requests.first.queryParameters, {
        'limit': '1',
        'category': 'SYSTEM',
      });
      expect(requests.last.queryParameters, {'limit': '30'});
    },
  );
}
