import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_options.dart';
import '../models/driver_workspace_models.dart';

class DriverWorkspaceService {
  DriverWorkspaceService(this._api);
  final ApiClient _api;
  Future<dynamic> _get(String path, [Map<String, dynamic>? query]) async =>
      (await _api.get<dynamic>(
        path,
        queryParameters: query,
        options: normalReadOptions(),
        parser: (v) => v,
      )).data;
  Future<Map<String, dynamic>> dashboard() async =>
      driverMap(await _get(DriverEndpoints.dashboard));
  Future<DriverTripsPage> trips(DriverTripsQuery query) async =>
      DriverTripsPage.fromJson(
        await _get(DriverEndpoints.trips, {
          'scope': query.scope,
          'page': query.page,
          'limit': 20,
          if (query.search.trim().isNotEmpty) 'search': query.search.trim(),
        }),
      );
  Future<DriverTrip> trip(String id) async =>
      DriverTrip.fromJson(driverMap(await _get(DriverEndpoints.trip(id))));
  Future<List<DriverTrip>> calendar(DateTime month) async {
    // serviceDate is a UTC date key, independent of the handset timezone.
    final from = DateTime.utc(month.year, month.month);
    final to = DateTime.utc(
      month.year,
      month.month + 1,
    ).subtract(const Duration(milliseconds: 1));
    return driverItems(
      await _get(DriverEndpoints.calendar, {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      }),
    ).map(DriverTrip.fromJson).toList(growable: false);
  }

  Future<void> acknowledge(String id) => _post(DriverEndpoints.acknowledge(id));
  Future<void> start(String id, String note) =>
      _post(DriverEndpoints.start(id), {'note': note.trim()});
  Future<void> completeStop(String id, String stopId, String note) =>
      _post(DriverEndpoints.completeStop(id, stopId), {'note': note.trim()});
  Future<void> remark(String id, String note) =>
      _post(DriverEndpoints.remarks(id), {'note': note.trim()});
  Future<void> reportException(String id, String reason, String note) => _post(
    DriverEndpoints.exceptions(id),
    {'reason': reason, 'note': note.trim()},
  );
  Future<Map<String, dynamic>> messages({String? beforeId}) async => driverMap(
    await _get(DriverEndpoints.messages, {
      'limit': 50,
      if (beforeId != null) 'beforeId': beforeId,
    }),
  );
  Future<void> sendMessage(String body, String clientMessageId) => _post(
    DriverEndpoints.messages,
    {'body': body.trim(), 'clientMessageId': clientMessageId},
  );
  Future<void> readMessages() => _post(DriverEndpoints.messagesRead);
  Future<Map<String, dynamic>> notifications() async =>
      driverMap(await _get(DriverEndpoints.notifications, {'limit': 100}));
  Future<void> readNotification(String id) async {
    await _api.patch<void>(
      DriverEndpoints.readNotification(id),
      options: normalWriteOptions(),
      parser: (_) {},
    );
  }

  Future<void> readAllNotifications() =>
      _post(DriverEndpoints.notificationsReadAll);
  Future<List<Map<String, dynamic>>> documents() async =>
      driverItems(await _get(DriverEndpoints.documents));
  Future<List<Map<String, dynamic>>> documentTypes() async =>
      driverItems(await _get(DriverEndpoints.documentTypes));
  Future<void> deleteDocument(String id) async {
    await _api.delete<void>(
      DriverEndpoints.document(id),
      options: normalWriteOptions(),
      parser: (_) {},
    );
  }

  Future<void> uploadDocument({
    required PlatformFile file,
    required String title,
    required String documentTypeId,
    String description = '',
    DateTime? expiry,
  }) async {
    await _upload(
      DriverEndpoints.documents,
      FormData.fromMap({
        'title': title.trim(),
        'docTypeId': documentTypeId,
        'description': description.trim(),
        if (expiry != null) 'expiryAt': expiry.toUtc().toIso8601String(),
        'file': await _file(file, allowWord: true),
      }),
    );
  }

  Future<void> uploadProof({
    required String tripId,
    required PlatformFile file,
    required String proofType,
    String? stopId,
    String title = '',
    String note = '',
  }) async {
    await _upload(
      DriverEndpoints.proofs(tripId),
      FormData.fromMap({
        'proofType': proofType,
        if (stopId != null && stopId.isNotEmpty) 'stopId': stopId,
        if (title.trim().isNotEmpty) 'title': title.trim(),
        if (note.trim().isNotEmpty) 'note': note.trim(),
        'file': await _file(file, allowWord: false),
      }),
    );
  }

  Future<Uint8List> documentContent(String id) =>
      _content(DriverEndpoints.documentContent(id));
  Future<Uint8List> proofContent(String id, String proofId) =>
      _content(DriverEndpoints.proofContent(id, proofId));
  Future<Uint8List> _content(String path) async => (await _api.get<Uint8List>(
    path,
    options: downloadOptions().copyWith(responseType: ResponseType.bytes),
    parser: (value) => Uint8List.fromList((value as List).cast<int>()),
  )).data;
  Future<void> _post(String path, [Map<String, dynamic>? body]) async {
    await _api.post<void>(
      path,
      data: body ?? <String, dynamic>{},
      options: normalWriteOptions(),
      parser: (_) {},
    );
  }

  Future<void> _upload(String path, FormData form) async {
    await _api.post<void>(
      path,
      data: form,
      options: uploadOptions().copyWith(
        contentType: Headers.multipartFormDataContentType,
      ),
      parser: (_) {},
    );
  }

  static Future<MultipartFile> _file(
    PlatformFile file, {
    required bool allowWord,
  }) async {
    if (file.size <= 0 || file.size > 5 * 1024 * 1024) {
      throw ArgumentError('Select a non-empty file up to 5 MB.');
    }
    final mime = switch (file.name.split('.').last.toLowerCase()) {
      'pdf' => 'application/pdf',
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'doc' when allowWord => 'application/msword',
      'docx' when allowWord =>
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      _ => throw ArgumentError('This file type is not supported.'),
    };
    if (file.bytes != null) {
      return MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
        contentType: MediaType.parse(mime),
      );
    }
    if (file.path == null) {
      throw ArgumentError('The selected file cannot be read.');
    }
    return MultipartFile.fromFile(
      file.path!,
      filename: file.name,
      contentType: MediaType.parse(mime),
    );
  }
}
