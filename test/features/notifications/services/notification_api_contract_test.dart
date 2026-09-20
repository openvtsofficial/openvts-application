import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/services/superadmin_notification_service.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));

  test('backend page cap does not prematurely stop pagination', () async {
    RequestOptions? request;
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: <String, dynamic>{
          'action': true,
          'data': <String, dynamic>{
            'items': List.generate(30, (index) => <String, dynamic>{
              'id': 100 - index,
              'title': 'Vehicle alert',
            }),
            'nextCursor': 71,
            'unreadCount': 65,
          },
        },
      ));
    }));

    final page = await SuperadminNotificationService(ApiClient(dio))
        .getNotifications(limit: 100, category: 'SYSTEM');
    expect(request!.queryParameters['limit'], '30');
    expect(request!.queryParameters.containsKey('category'), isFalse);
    expect(page.hasMore, isTrue);
    expect(page.nextBeforeId, 71);
    expect(page.unreadCount, 65);
  });
}
