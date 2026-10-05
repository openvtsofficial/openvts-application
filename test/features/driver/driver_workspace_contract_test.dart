import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/driver/models/driver_workspace_models.dart';
import 'package:open_vts/features/driver/services/driver_workspace_service.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  dynamic payload = <String, dynamic>{};
  bool bytes = false;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    if (bytes) {
      return ResponseBody.fromBytes([37, 80, 68, 70, 45], 200,
          headers: {
            Headers.contentTypeHeader: ['application/pdf']
          });
    }
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

void main() {
  late _Adapter adapter;
  late DriverWorkspaceService service;
  setUp(() {
    adapter = _Adapter();
    final dio = Dio(BaseOptions(
        baseUrl: 'https://fleet.example/api',
        headers: {'Authorization': 'Bearer fixture'}))
      ..httpClientAdapter = adapter;
    service = DriverWorkspaceService(ApiClient(dio));
  });
  test('trips use current driver scope and preserve API base prefix once',
      () async {
    adapter.payload = {
      'items': [
        {'id': 'trip-1', 'title': 'Delivery', 'status': 'ASSIGNED', 'stops': []}
      ],
      'page': 3,
      'total': 81,
      'totalPages': 5
    };
    final page = await service.trips(
        const DriverTripsQuery(scope: 'history', page: 3, search: '  truck  '));
    expect(adapter.requests.single.uri.path, '/api/driver/trips');
    expect(adapter.requests.single.queryParameters,
        {'scope': 'history', 'page': 3, 'limit': 20, 'search': 'truck'});
    expect(page.items.single.title, 'Delivery');
    expect(page.total, 81);
  });
  test('driver actions use POST and string bigint stop IDs', () async {
    await service.acknowledge('id');
    await service.start('id', ' start ');
    await service.completeStop('id', '9223372036854775806', ' arrived ');
    await service.remark('id', ' note ');
    await service.reportException('id', 'ACCESS', ' closed ');
    expect(adapter.requests.map((r) => r.method).toSet(), {'POST'});
    expect(adapter.requests[2].uri.path,
        '/api/driver/trips/id/stops/9223372036854775806/complete');
    expect(adapter.requests[2].data, {'note': 'arrived'});
    expect(adapter.requests.last.data, {'reason': 'ACCESS', 'note': 'closed'});
  });
  test('calendar passes complete UTC service-date month including leap day',
      () async {
    adapter.payload = [];
    await service.calendar(DateTime(2028, 2, 17));
    expect(adapter.requests.single.queryParameters,
        {'from': '2028-02-01T00:00:00.000Z', 'to': '2028-02-29T23:59:59.999Z'});
  });
  test('messages use cursor and UUID client identity; read receipt POST',
      () async {
    adapter.payload = {'items': [], 'hasMore': true, 'nextBeforeId': '99'};
    await service.messages(beforeId: '9223372036854775806');
    await service.sendMessage(
        ' hello ', '9f72feaa-8205-4421-af81-95bf5d193a40');
    await service.readMessages();
    expect(
        adapter.requests[0].queryParameters['beforeId'], '9223372036854775806');
    expect(adapter.requests[1].uri.path, '/api/driver/messages');
    expect(adapter.requests[1].data, {
      'body': 'hello',
      'clientMessageId': '9f72feaa-8205-4421-af81-95bf5d193a40'
    });
    expect(adapter.requests.last.uri.path, '/api/driver/messages/read');
  });
  test('private document content remains authenticated bytes without token URL',
      () async {
    adapter.bytes = true;
    final bytes = await service.documentContent('7');
    final request = adapter.requests.single;
    expect(bytes, [37, 80, 68, 70, 45]);
    expect(request.uri.path, '/api/driver/documents/7/content');
    expect(request.uri.query, '');
    expect(request.headers['Authorization'], 'Bearer fixture');
    expect(request.responseType, ResponseType.bytes);
  });
  test('uploads send current multipart fields, MIME, stop association',
      () async {
    final file = PlatformFile(
        name: 'receipt.pdf',
        size: 5,
        bytes: Uint8List.fromList([37, 80, 68, 70, 45]));
    await service.uploadProof(
        tripId: 'trip',
        file: file,
        proofType: 'POD',
        stopId: '100',
        title: ' Receipt ',
        note: ' Delivered ');
    final request = adapter.requests.single;
    final form = request.data as FormData;
    expect(request.uri.path, '/api/driver/trips/trip/proofs');
    expect(Map.fromEntries(form.fields), {
      'proofType': 'POD',
      'stopId': '100',
      'title': 'Receipt',
      'note': 'Delivered'
    });
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.contentType.toString(), 'application/pdf');
  });
  test('oversized files and unsupported proof types do not issue requests',
      () async {
    await expectLater(
        service.uploadProof(
            tripId: 'trip',
            proofType: 'POD',
            file: PlatformFile(
                name: 'large.pdf',
                size: 5 * 1024 * 1024 + 1,
                bytes: Uint8List(1))),
        throwsArgumentError);
    await expectLater(
        service.uploadProof(
            tripId: 'trip',
            proofType: 'POD',
            file:
                PlatformFile(name: 'file.docx', size: 1, bytes: Uint8List(1))),
        throwsArgumentError);
    expect(adapter.requests, isEmpty);
  });
  test('document writes use owner-scoped endpoint and do not submit owner IDs',
      () async {
    await service.uploadDocument(
        file: PlatformFile(name: 'license.docx', size: 1, bytes: Uint8List(1)),
        title: 'License',
        documentTypeId: '2');
    expect(adapter.requests.single.uri.path, '/api/driver/documents');
    final fields =
        Map.fromEntries((adapter.requests.single.data as FormData).fields);
    expect(fields, {'title': 'License', 'docTypeId': '2', 'description': ''});
    await service.deleteDocument('19');
    expect(adapter.requests.last.method, 'DELETE');
    await service.readNotification('24');
    expect(adapter.requests.last.method, 'PATCH');
    expect(adapter.requests.last.uri.path, '/api/driver/notifications/24/read');
  });
}
