import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/driver/controllers/driver_messages_controller.dart';
import 'package:open_vts/features/driver/services/driver_workspace_service.dart';

class _MessagesService extends Fake implements DriverWorkspaceService {
  final calls = <String?>[];
  final sent = <Map<String, String>>[];
  final pages = <Map<String, dynamic>>[];
  bool failRead = false, failSend = false;
  Completer<Map<String, dynamic>>? pending;
  @override
  Future<Map<String, dynamic>> messages({String? beforeId}) async {
    calls.add(beforeId);
    if (failRead) throw Exception('offline');
    if (pending != null) return pending!.future;
    return pages.isEmpty ? {'items': [], 'hasMore': false} : pages.removeAt(0);
  }

  @override
  Future<void> readMessages() async {}
  @override
  Future<void> sendMessage(String body, String clientMessageId) async {
    sent.add({'body': body, 'clientMessageId': clientMessageId});
    if (failSend) throw TimeoutException('ambiguous response');
  }
}

void main() {
  test('failed initial request can retry and still load cursor history',
      () async {
    final service = _MessagesService()..failRead = true;
    final controller = DriverMessagesController(service);
    addTearDown(controller.dispose);
    await controller.refresh();
    expect(controller.state.loading, isFalse);
    expect(controller.state.error, isNotNull);
    service.failRead = false;
    service.pages.addAll([
      {
        'items': [
          {'id': '100', 'body': 'new'}
        ],
        'hasMore': true,
        'nextBeforeId': '100'
      },
      {
        'items': [
          {'id': '98', 'body': 'old'},
          {'id': '99', 'body': 'middle'}
        ],
        'hasMore': false
      },
    ]);
    await controller.refresh();
    expect(controller.state.nextBeforeId, '100');
    await controller.loadOlder();
    expect(service.calls, [null, null, '100']);
    expect(controller.state.items.map((v) => v['id']), ['98', '99', '100']);
    expect(controller.state.nextBeforeId, isNull);
  });
  test('ambiguous send retry reuses UUID; changed draft gets new UUID',
      () async {
    final service = _MessagesService()..failSend = true;
    final controller = DriverMessagesController(service);
    addTearDown(controller.dispose);
    expect(await controller.send(' dispatch '), isFalse);
    expect(await controller.send('dispatch'), isFalse);
    expect(
        service.sent[0]['clientMessageId'], service.sent[1]['clientMessageId']);
    expect(await controller.send('different'), isFalse);
    expect(service.sent[2]['clientMessageId'],
        isNot(service.sent[0]['clientMessageId']));
    service.failSend = false;
    expect(await controller.send('different'), isTrue);
    expect(controller.state.sending, isFalse);
    expect(
        service.sent[2]['clientMessageId'], service.sent[3]['clientMessageId']);
  });
  test('refresh is single-flight and account disposal drops old response',
      () async {
    final service = _MessagesService()
      ..pending = Completer<Map<String, dynamic>>();
    final controller = DriverMessagesController(service);
    final first = controller.refresh(), second = controller.refresh();
    expect(service.calls.length, 1);
    controller.dispose();
    service.pending!.complete({
      'items': [
        {'id': '1', 'body': 'private'}
      ],
      'hasMore': false
    });
    await Future.wait([first, second]);
  });
  test('refresh merges bigint IDs without losing older history', () async {
    final service = _MessagesService()
      ..pages.addAll([
        {
          'items': [
            {'id': '9223372036854775805', 'body': 'a'}
          ],
          'hasMore': true,
          'nextBeforeId': '9223372036854775805'
        },
        {
          'items': [
            {'id': '9223372036854775804', 'body': 'older'}
          ],
          'hasMore': false
        },
        {
          'items': [
            {'id': '9223372036854775805', 'body': 'a', 'isRead': true},
            {'id': '9223372036854775806', 'body': 'b'}
          ],
          'hasMore': true,
          'nextBeforeId': '9223372036854775805'
        },
      ]);
    final controller = DriverMessagesController(service);
    addTearDown(controller.dispose);
    await controller.refresh();
    await controller.loadOlder();
    await controller.refresh();
    expect(controller.state.items.map((v) => v['id']),
        ['9223372036854775804', '9223372036854775805', '9223372036854775806']);
    expect(controller.state.items[1]['isRead'], isTrue);
    expect(controller.state.nextBeforeId, isNull);
  });
}
