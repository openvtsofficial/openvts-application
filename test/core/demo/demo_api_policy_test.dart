import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/core/demo/demo_api_policy.dart';

void main() {
  late DemoApiPolicy policy;

  setUp(() {
    policy = DemoApiPolicy(isDemoMode: () => true);
  });

  test('maps user reads to isolated public demo routes', () {
    expect(
      policy.resolveGet('/user/vehicles', null).endpoint,
      '/demo/vehicles',
    );
    expect(
      policy.resolveGet('/user/dashboard/fleet-status', null).endpoint,
      '/demo/dashboard/fleet-status',
    );
    expect(
      policy.resolveGet('/user/sharetracklinks/link-1', null).endpoint,
      '/demo/share-track-links/link-1',
    );
    expect(
      policy.resolveGet('/vehicletypes', null).endpoint,
      '/demo/vehicletypes',
    );
  });

  test('blocks all writes before transport', () {
    for (final method in const ['POST', 'PUT', 'PATCH', 'DELETE']) {
      expect(
        () => policy.ensureMutationAllowed(method, '/user/vehicles/1'),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 403)
              .having(
                (error) => error.message,
                'message',
                DemoApiPolicy.restrictedMessage,
              ),
        ),
      );
    }
  });

  test('serves demo-safe reference data locally', () {
    final countries = policy.resolveGet('/countries', null);
    expect(countries.hasLocalPayload, isTrue);
    expect(
      (countries.localPayload as Map<String, dynamic>)['countries'],
      isNotEmpty,
    );
  });

  test('normalizes notification IDs and cursor paging', () {
    final resolution = policy.resolveGet(
      '/user/notifications',
      const <String, dynamic>{'limit': '1', 'unreadOnly': 'true'},
    );
    final firstPage = resolution.adapt(const <String, dynamic>{
      'notifications': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'notif-001',
          'title': 'First',
          'message': 'One',
          'read': false,
          'timestamp': '2026-07-26T08:00:00.000Z',
        },
        <String, dynamic>{
          'id': 'notif-002',
          'title': 'Second',
          'message': 'Two',
          'read': false,
          'timestamp': '2026-07-26T07:00:00.000Z',
        },
      ],
    }) as Map<String, dynamic>;

    final items = firstPage['items'] as List<dynamic>;
    expect(items, hasLength(1));
    expect((items.first as Map<String, dynamic>)['id'], 999999);
    expect(firstPage['hasMore'], isTrue);
    expect(firstPage['nextBeforeId'], 999999);
    expect(firstPage['unreadCount'], 2);
  });

  test('selects and normalizes a support conversation', () {
    final resolution = policy.resolveGet('/user/tickets/OVT-1', null);
    final detail = resolution.adapt(const <String, dynamic>{
      'tickets': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'OVT-1',
          'subject': 'Help',
          'status': 'in_progress',
          'priority': 'high',
          'assignedTo': 'Support Team',
          'createdAt': '2026-07-25T00:00:00.000Z',
          'updatedAt': '2026-07-26T00:00:00.000Z',
          'messages': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'msg-1',
              'sender': 'Demo Fleet Manager',
              'body': 'Please help.',
              'sentAt': '2026-07-25T00:00:00.000Z',
            },
          ],
        },
      ],
    }) as Map<String, dynamic>;

    expect(detail['ticketNo'], 'OVT-1');
    expect(detail['status'], 'IN_PROGRESS');
    final messages = detail['messages'] as List<dynamic>;
    expect(
      (messages.first as Map<String, dynamic>)['senderId'],
      'demo-user',
    );
  });
}
