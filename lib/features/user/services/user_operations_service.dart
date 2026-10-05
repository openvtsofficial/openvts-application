import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_options.dart';
import '../../../shared/models/user_role.dart';
import '../models/user_operation_attachment.dart';

/// Current USER-only Operations contract. The server remains authoritative for
/// eligibility, ownership, account timezone, and optimistic trip versions.
class UserOperationsService {
  UserOperationsService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> read(
    String resource, [
    Map<String, dynamic>? query,
  ]) async {
    final response = await _api.get<Map<String, dynamic>>(
      UserExtendedEndpoints.operations(resource),
      queryParameters: query,
      options: normalReadOptions(),
      parser: operationMap,
    );
    return response.data;
  }

  Future<Uint8List> proofContent(UserOperationProof proof) async {
    proof.validate();
    final principal = _api.activeUser;
    if (principal == null ||
        principal.role != UserRole.user ||
        !principal.access.canFeature(principal.role, 'routeOptimization')) {
      throw const ApiException(
        message: 'Operations access is required to view trip proofs.',
        statusCode: 403,
      );
    }
    final response = await _api.get<Uint8List>(
      UserExtendedEndpoints.operationProofContent(proof.tripId, proof.id),
      options: downloadOptions().copyWith(responseType: ResponseType.bytes),
      parser: (value) => Uint8List.fromList((value as List).cast<int>()),
    );
    if (!response.success) {
      throw ApiException(
        message: 'This trip proof could not be downloaded.',
        statusCode: response.statusCode,
      );
    }
    final current = _api.activeUser;
    if (current == null ||
        current.id != principal.id ||
        current.role != principal.role ||
        !current.access.canFeature(current.role, 'routeOptimization')) {
      throw const ApiException(
        message: 'Account access changed. Reopen this trip proof.',
        statusCode: 403,
      );
    }
    proof.validateContent(response.data);
    return response.data;
  }

  Future<Map<String, dynamic>> create(
    Map<String, dynamic> payload, {
    required bool recurring,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      UserExtendedEndpoints.operations(recurring ? 'recurring' : 'trips'),
      data: payload,
      options: normalWriteOptions(),
      parser: operationMap,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateRecurring(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _api.patch<Map<String, dynamic>>(
      UserExtendedEndpoints.recurring(id),
      data: payload,
      options: normalWriteOptions(),
      parser: operationMap,
    );
    return response.data;
  }

  Future<void> overrideTrip(
    String id, {
    required String action,
    required String reason,
    required int version,
  }) async {
    if (!const ['START', 'COMPLETE', 'CANCEL', 'ADD_REMARK'].contains(action) ||
        reason.trim().length < 3 ||
        reason.trim().length > 600 ||
        version < 1) {
      throw ArgumentError(
        'A supported action, reason and current trip version are required.',
      );
    }
    await _api.post<void>(
      '${UserExtendedEndpoints.operationTrip(id)}/override',
      data: {
        'action': action,
        'reason': reason.trim(),
        'expectedVersion': version,
      },
      options: normalWriteOptions(),
      parser: (_) {},
    );
  }

  Future<void> acknowledgeEvent(String id) async {
    if (!RegExp(r'^[1-9]\d*$').hasMatch(id)) {
      throw ArgumentError('A valid event is required.');
    }
    await _api.patch<void>(
      UserExtendedEndpoints.operations(
        'events/${Uri.encodeComponent(id)}/acknowledge',
      ),
      options: normalWriteOptions(),
      parser: (_) {},
    );
  }

  Future<void> recurringAction(String id, String action) async {
    if (!const ['pause', 'resume', 'end', 'delete'].contains(action)) {
      throw ArgumentError('Unsupported recurring action');
    }
    if (action == 'delete') {
      await _api.delete<void>(
        UserExtendedEndpoints.recurring(id),
        options: normalWriteOptions(),
        parser: (_) {},
      );
    } else {
      await _api.post<void>(
        '${UserExtendedEndpoints.recurring(id)}/$action',
        options: normalWriteOptions(),
        parser: (_) {},
      );
    }
  }
}

Map<String, dynamic> operationMap(dynamic value) {
  if (value is! Map) return <String, dynamic>{};
  final map = Map<String, dynamic>.from(value);
  if (map['data'] is Map) return operationMap(map['data']);
  return map;
}

List<Map<String, dynamic>> operationItems(dynamic value) => value is List
    ? value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : <Map<String, dynamic>>[];
