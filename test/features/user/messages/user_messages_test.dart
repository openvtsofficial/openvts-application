import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/user/messages/user_message_models.dart';
import 'package:open_vts/features/user/messages/user_messages_controller.dart';
import 'package:open_vts/features/user/messages/user_messages_screen.dart';
import 'package:open_vts/features/user/messages/user_messages_service.dart';
import 'package:open_vts/shared/models/user_role.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  dynamic payload = <String, dynamic>{};
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    return ResponseBody.fromString(
        jsonEncode({
          'status': 'success',
          'data': {'action': true, 'data': payload}
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        });
  }

  @override
  void close({bool force = false}) {}
}

UserChatMessage message(String id, {int driverId = 1}) => UserChatMessage(
    id: id,
    driverId: driverId,
    senderType: 'USER',
    senderName: 'Dispatcher',
    body: 'Arrive at the delivery entrance 🚚',
    isRead: true,
    assignmentReference: 'LONG-REFERENCE-123456789');
Map<String, dynamic> messageJson(String id) => {
      'id': id,
      'driverId': 7,
      'senderType': 'USER',
      'senderName': 'Dispatch',
      'body': 'हैलो 🚚',
      'isRead': true,
      'createdAt': '2026-09-01T00:00:00Z'
    };

class _FakeService extends UserMessagesService {
  _FakeService() : super(ApiClient(Dio()));
  final sentIds = <String>[];
  final readDrivers = <int>[];
  bool failSend = false;
  Future<UserMessagePage> Function(int, String?)? load;
  @override
  Future<UserMessageThreads> threads({String search = ''}) async =>
      const UserMessageThreads([], 0);
  @override
  Future<UserMessagePage> messages(int driverId, {String? beforeId}) =>
      load?.call(driverId, beforeId) ?? Future.value(const UserMessagePage([]));
  @override
  Future<UserChatMessage> send(
      int driverId, String text, String clientMessageId) async {
    sentIds.add(clientMessageId);
    if (failSend) throw Exception('Network response lost');
    return message('9223372036854775806', driverId: driverId);
  }

  @override
  Future<int> markRead(int driverId) async {
    readDrivers.add(driverId);
    return 0;
  }
}

void main() {
  test(
      'USER always-available Messages still denies SUBUSER and unloaded access',
      () {
    const access = MobileAccess(loaded: true);
    expect(access.canAccessPath(UserRole.user, '/user/messages'), isTrue);
    expect(access.canFeature(UserRole.user, 'messages'), isTrue);
    expect(access.canAccessPath(UserRole.subuser, '/user/messages'), isFalse);
    expect(access.canAccessPath(UserRole.team, '/user/messages'), isFalse);
    expect(
        const MobileAccess.unavailable()
            .canAccessPath(UserRole.user, '/user/messages'),
        isFalse);
  });
  test(
      'request contract preserves API prefix, bounded search, bigint cursor, UUID and read route',
      () async {
    final adapter = _Adapter();
    final service = UserMessagesService(ApiClient(
        Dio(BaseOptions(baseUrl: 'https://fleet.example/api'))
          ..httpClientAdapter = adapter));
    adapter.payload = {
      'items': [
        {
          'driverId': 7,
          'title': 'Driver',
          'subtitle': 'Truck A',
          'isActive': false,
          'unreadCount': 2
        }
      ],
      'totalUnread': 2
    };
    final threads = await service.threads(search: '  Truck A ');
    expect(threads.items.single.isActive, isFalse);
    expect(adapter.requests.last.uri.path, '/api/user/driver-messages/threads');
    expect(adapter.requests.last.queryParameters,
        {'limit': 500, 'search': 'Truck A'});
    adapter.payload = {
      'items': [messageJson('9223372036854775806')],
      'hasMore': true,
      'nextBeforeId': '9223372036854775806',
      'unreadCount': 2
    };
    final page = await service.messages(7, beforeId: '9223372036854775807');
    expect(page.items.single.id, '9223372036854775806');
    expect(adapter.requests.last.queryParameters,
        {'limit': 50, 'beforeId': '9223372036854775807'});
    adapter.payload = {
      'message': messageJson('9223372036854775806'),
      'recipientUnreadCount': 1
    };
    const id = '9f72feaa-8205-4421-af81-95bf5d193a40';
    await service.send(7, '  हैलो 🚚 ', id);
    expect(adapter.requests.last.method, 'POST');
    expect(adapter.requests.last.uri.path, '/api/user/driver-messages/7');
    expect(
        adapter.requests.last.data, {'body': 'हैलो 🚚', 'clientMessageId': id});
    adapter.payload = {
      'updated': 2,
      'totalUnread': 3,
      'readAt': '2026-09-01T00:00:00Z'
    };
    expect(await service.markRead(7), 3);
    expect(adapter.requests.last.uri.path, '/api/user/driver-messages/7/read');
    expect(adapter.requests.last.method, 'POST');
    await expectLater(
        service.messages(7, beforeId: '../read'), throwsArgumentError);
    expect(adapter.requests.length, 4);
  });
  test('failed send retry reuses UUID, successful next message gets new UUID',
      () async {
    final service = _FakeService();
    final messages = UserMessagesController(service);
    addTearDown(messages.dispose);
    await messages.select(const UserMessageThread(driverId: 1, title: 'One'));
    service.failSend = true;
    expect(await messages.send(' hello '), isFalse);
    service.failSend = false;
    expect(await messages.send('hello'), isTrue);
    expect(service.sentIds[0], service.sentIds[1]);
    expect(await messages.send('hello'), isTrue);
    expect(service.sentIds[2], isNot(service.sentIds[1]));
  });
  test(
      'late response from previous driver cannot replace current conversation or mark it read',
      () async {
    final service = _FakeService();
    final first = Completer<UserMessagePage>(),
        second = Completer<UserMessagePage>();
    service.load = (id, _) => id == 1 ? first.future : second.future;
    final controller = UserMessagesController(service);
    addTearDown(controller.dispose);
    final old =
        controller.select(const UserMessageThread(driverId: 1, title: 'One'));
    final current =
        controller.select(const UserMessageThread(driverId: 2, title: 'Two'));
    second.complete(
        UserMessagePage([message('22', driverId: 2)], unreadCount: 1));
    await current;
    first.complete(UserMessagePage([message('11')], unreadCount: 1));
    await old;
    expect(controller.state.selected?.driverId, 2);
    expect(controller.state.messages.single.id, '22');
    expect(service.readDrivers, [2]);
  });
  test(
      'latest refresh retains loaded history and oldest cursor without numeric precision loss',
      () async {
    final service = _FakeService();
    var latest = 0;
    service.load = (_, before) async => before == null
        ? UserMessagePage([
            message(
                latest++ == 0 ? '9223372036854775805' : '9223372036854775806')
          ], nextBeforeId: '9223372036854775805')
        : UserMessagePage([message('9223372036854775803')],
            nextBeforeId: '9223372036854775803');
    final controller = UserMessagesController(service);
    addTearDown(controller.dispose);
    await controller.select(const UserMessageThread(driverId: 1, title: 'One'));
    await controller.loadMessages(older: true);
    await controller.loadMessages();
    expect(controller.state.messages.map((m) => m.id),
        ['9223372036854775803', '9223372036854775805', '9223372036854775806']);
    expect(controller.state.nextBeforeId, '9223372036854775803');
  });
  test(
      'disposed or background conversation cannot apply response or mark unread messages read',
      () async {
    final service = _FakeService(), pending = Completer<UserMessagePage>();
    service.load = (driverId, beforeId) => pending.future;
    final controller = UserMessagesController(service);
    final load =
        controller.select(const UserMessageThread(driverId: 1, title: 'One'));
    controller.setForeground(false);
    pending.complete(UserMessagePage([message('11')], unreadCount: 1));
    await load;
    expect(service.readDrivers, isEmpty);
    controller.dispose();
    await controller.loadMessages();
    expect(service.readDrivers, isEmpty);
  });
  for (final scale in [1.0, 2.0]) {
    testWidgets('conversation row and bubble fit 320px at text scale $scale',
        (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(
          home: MediaQuery(
              data: MediaQueryData(
                  size: const Size(320, 720),
                  textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                  body: ListView(children: [
                UserMessageThreadTile(
                    thread: const UserMessageThread(
                        driverId: 1,
                        title: 'Long driver name on a narrow phone screen',
                        subtitle: 'Vehicle registration ABC1234',
                        unreadCount: 104),
                    onTap: () {}),
                UserMessageBubble(
                    message: message('1'), timestamp: '01 Oct 2026, 10:25 AM'),
              ])))));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('99+'), findsOneWidget);
      expect(find.textContaining('Arrive at'), findsOneWidget);
    });
  }
}
