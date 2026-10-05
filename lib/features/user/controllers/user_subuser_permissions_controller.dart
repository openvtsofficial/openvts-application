import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_subuser_service.dart';
import 'user_providers.dart';

final userSubUserPermissionsControllerProvider =
    StateNotifierProvider.autoDispose.family<UserSubUserPermissionsController,
        AsyncValue<Map<String, dynamic>>, String>((ref, id) {
  return UserSubUserPermissionsController(
      ref.watch(userSubUsersServiceProvider), id)
    ..load();
});

class UserSubUserPermissionsController
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  UserSubUserPermissionsController(this._service, this.id)
      : super(const AsyncLoading());
  final UserSubUserService _service;
  final String id;
  int _generation = 0;
  Future<void> load() async {
    final generation = ++_generation;
    state = const AsyncLoading();
    try {
      final data = await _service.fetchPermissions(id);
      if (mounted && generation == _generation) state = AsyncData(data);
    } catch (e, trace) {
      if (mounted && generation == _generation) state = AsyncError(e, trace);
    }
  }

  Future<void> save(
      {required List<String> disabledFeatures,
      required List<String> disabledReports}) async {
    final generation = ++_generation;
    final data = await _service.replacePermissions(id,
        disabledFeatures: disabledFeatures, disabledReports: disabledReports);
    if (mounted && generation == _generation) state = AsyncData(data);
  }
}
