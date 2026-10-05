import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../models/user_operation_attachment.dart';
import '../services/user_operations_service.dart';

final userOperationsServiceProvider = Provider<UserOperationsService>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return UserOperationsService(ref.watch(apiClientProvider));
});
final userOperationPlanningProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
      return ref.watch(userOperationsServiceProvider).read('planning-options');
    });
final userOperationTripProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, id) {
      return ref
          .watch(userOperationsServiceProvider)
          .read('trips/${Uri.encodeComponent(id)}');
    });
final userOperationDriverProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, id) {
      return ref
          .watch(userOperationsServiceProvider)
          .read('drivers/${Uri.encodeComponent(id)}/dashboard');
    });
final userOperationsControllerProvider =
    StateNotifierProvider.autoDispose<
      UserOperationsController,
      UserOperationsState
    >((ref) {
      return UserOperationsController(ref.watch(userOperationsServiceProvider))
        ..load('today', const {});
    });
final userOperationsActionsProvider =
    Provider.autoDispose<UserOperationsActionsController>((ref) {
      return UserOperationsActionsController(
        ref.watch(userOperationsServiceProvider),
      );
    });

class UserOperationsState {
  const UserOperationsState({
    this.data = const {},
    this.items = const [],
    this.page = 1,
    this.loading = false,
    this.error,
  });
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> items;
  final int page;
  final bool loading;
  final Object? error;
}

class UserOperationsController extends StateNotifier<UserOperationsState> {
  UserOperationsController(this._service) : super(const UserOperationsState());
  final UserOperationsService _service;
  int _generation = 0;
  String? _resource;
  Map<String, dynamic> _query = const {};
  Future<void> load(
    String resource,
    Map<String, dynamic> query, {
    bool more = false,
  }) async {
    if (more && state.loading) return;
    final generation = ++_generation;
    final previous = state;
    final sameView =
        _resource == resource &&
        _query.length == query.length &&
        _query.entries.every((entry) => query[entry.key] == entry.value);
    _resource = resource;
    _query = Map.of(query);
    final page = more ? previous.page + 1 : 1;
    state = UserOperationsState(
      data: sameView ? previous.data : const {},
      items: sameView ? previous.items : const [],
      page: previous.page,
      loading: true,
    );
    try {
      final data = await _service.read(resource, {
        if (resource != 'calendar') ...{'page': page, 'limit': 30},
        ...query,
      });
      if (!mounted || generation != _generation) return;
      state = UserOperationsState(
        data: data,
        items: [if (more) ...previous.items, ...operationItems(data['items'])],
        page: page,
      );
    } catch (error) {
      if (mounted && generation == _generation) {
        state = UserOperationsState(
          data: state.data,
          items: state.items,
          page: state.page,
          error: error,
        );
      }
    }
  }
}

class UserOperationsActionsController {
  UserOperationsActionsController(this._service);
  final UserOperationsService _service;
  Future<Map<String, dynamic>> create(
    Map<String, dynamic> payload, {
    required bool recurring,
  }) => _service.create(payload, recurring: recurring);
  Future<Map<String, dynamic>> updateRecurring(
    String id,
    Map<String, dynamic> payload,
  ) => _service.updateRecurring(id, payload);
  Future<void> acknowledgeEvent(String id) => _service.acknowledgeEvent(id);
  Future<void> recurringAction(String id, String action) =>
      _service.recurringAction(id, action);
  Future<void> overrideTrip(
    String id, {
    required String action,
    required String reason,
    required int version,
  }) => _service.overrideTrip(
    id,
    action: action,
    reason: reason,
    version: version,
  );
}

final userOperationProofProvider = FutureProvider.autoDispose
    .family<Uint8List, UserOperationProof>((ref, proof) {
      return ref.watch(userOperationsServiceProvider).proofContent(proof);
    });
