import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/driver_workspace_service.dart';
import 'driver_providers.dart';

/// Mutation/download facade keeps views independent of transport services.
final driverActionsControllerProvider =
    Provider.autoDispose<DriverActionsController>((ref) =>
        DriverActionsController(ref.watch(driverWorkspaceServiceProvider)));

class DriverActionsController {
  DriverActionsController(this._service);
  final DriverWorkspaceService _service;
  Future<void> acknowledge(String id) => _service.acknowledge(id);
  Future<void> start(String id, String note) => _service.start(id, note);
  Future<void> completeStop(String id, String stopId, String note) =>
      _service.completeStop(id, stopId, note);
  Future<void> remark(String id, String note) => _service.remark(id, note);
  Future<void> reportException(String id, String reason, String note) =>
      _service.reportException(id, reason, note);
  Future<void> readNotification(String id) => _service.readNotification(id);
  Future<void> readAllNotifications() => _service.readAllNotifications();
  Future<void> deleteDocument(String id) => _service.deleteDocument(id);
  Future<Uint8List> documentContent(String id) => _service.documentContent(id);
  Future<Uint8List> proofContent(String id, String proofId) =>
      _service.proofContent(id, proofId);
  Future<void> uploadDocument(
          {required PlatformFile file,
          required String title,
          required String documentTypeId,
          String description = '',
          DateTime? expiry}) =>
      _service.uploadDocument(
          file: file,
          title: title,
          documentTypeId: documentTypeId,
          description: description,
          expiry: expiry);
  Future<void> uploadProof(
          {required String tripId,
          required PlatformFile file,
          required String proofType,
          String? stopId,
          String title = '',
          String note = ''}) =>
      _service.uploadProof(
          tripId: tripId,
          file: file,
          proofType: proofType,
          stopId: stopId,
          title: title,
          note: note);
}
