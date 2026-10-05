import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../services/user_operations_service.dart' show operationItems;
import '../services/user_vehicle_service_billing_service.dart';

final userVehicleServiceBillingControllerProvider =
    StateNotifierProvider.autoDispose<UserVehicleServiceBillingController,
        UserVehicleServiceBillingState>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return UserVehicleServiceBillingController(
      UserVehicleServiceBillingService(ref.watch(apiClientProvider)))
    ..load();
});

class UserVehicleServiceBillingState {
  const UserVehicleServiceBillingState(
      {this.requests = false,
      this.loading = false,
      this.items = const [],
      this.cursor,
      this.hasMore = false,
      this.error});
  final bool requests;
  final bool loading;
  final List<Map<String, dynamic>> items;
  final int? cursor;
  final bool hasMore;
  final Object? error;
}

class UserVehicleServiceBillingController
    extends StateNotifier<UserVehicleServiceBillingState> {
  UserVehicleServiceBillingController(this._service)
      : super(const UserVehicleServiceBillingState());
  final UserVehicleServiceBillingService _service;
  final Map<int, String> _requestKeys = {};
  int _generation = 0;
  Future<void> load({bool? requests, bool more = false, String? search}) async {
    final previous = state;
    final view = requests ?? state.requests;
    final generation = ++_generation;
    state = UserVehicleServiceBillingState(
        requests: view, loading: true, items: more ? previous.items : const []);
    try {
      final data = await _service.load(
          requests: view,
          cursor: more ? previous.cursor : null,
          search: search);
      if (!mounted || generation != _generation) return;
      final cursor = (data['nextCursor'] as num?)?.toInt();
      state = UserVehicleServiceBillingState(
          requests: view,
          items: [
            if (more) ...previous.items,
            ...operationItems(data['items'])
          ],
          cursor: cursor,
          hasMore: data['hasMore'] == true && cursor != null);
    } catch (error) {
      if (mounted && generation == _generation) {
        state = UserVehicleServiceBillingState(
            requests: view,
            items: state.items,
            cursor: previous.cursor,
            hasMore: more && previous.hasMore,
            error: error);
      }
    }
  }

  Future<void> requestRenewal(int vehicleId) async {
    await _service.requestRenewal(
        vehicleId: vehicleId,
        idempotencyKey:
            _requestKeys.putIfAbsent(vehicleId, () => const Uuid().v4()));
    _requestKeys.remove(vehicleId);
    if (mounted) await load(requests: true);
  }

  Future<void> cancel(int id) async {
    await _service.cancel(id);
    if (mounted) await load(requests: true);
  }
}
