import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../shared/models/user_role.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/user_subuser_permissions.dart';
import '../services/user_subuser_service.dart';
import 'user_providers.dart';

final userSubUserPermissionsControllerProvider = StateNotifierProvider
    .autoDispose
    .family<
      UserSubUserPermissionsController,
      AsyncValue<UserSubUserPermissions>,
      String
    >((ref, id) {
      // Recreate the controller on identity/access changes and discard old drafts
      // and pending responses before they can cross account boundaries.
      final scope = ref.watch(
        authControllerProvider.select(
          (s) => (
            s.user?.id,
            s.user?.role,
            s.user?.access.loaded,
            s.user?.access.version,
            s.user?.access.features['accounts'],
          ),
        ),
      );
      bool canManage() {
        final auth = ref.read(authControllerProvider);
        return auth.isRealSession &&
            auth.user?.id == scope.$1 &&
            auth.user?.role == UserRole.user &&
            auth.user!.access.canFeature(UserRole.user, 'accounts');
      }

      return UserSubUserPermissionsController(
        ref.watch(userSubUsersServiceProvider),
        id,
        canManage: canManage,
      )..load();
    });

class UserSubUserPermissionsController
    extends StateNotifier<AsyncValue<UserSubUserPermissions>> {
  UserSubUserPermissionsController(
    this._service,
    this.id, {
    bool Function()? canManage,
  }) : _canManage = canManage ?? (() => true),
       super(const AsyncLoading());
  final UserSubUserService _service;
  final String id;
  final bool Function() _canManage;
  int _generation = 0;
  bool _saving = false;

  void _authorize() {
    if (!mounted || !_canManage()) {
      throw const ApiException(
        message: 'Unable to update permissions',
        statusCode: 403,
      );
    }
  }

  Future<void> load() async {
    if (_saving || !mounted) return;
    final generation = ++_generation;
    state = const AsyncLoading();
    try {
      _authorize();
      final data = UserSubUserPermissions.fromJson(
        await _service.fetchPermissions(id),
      );
      if (mounted && generation == _generation && _canManage()) {
        state = AsyncData(data);
      }
    } catch (e, trace) {
      if (mounted && generation == _generation) state = AsyncError(e, trace);
    }
  }

  Future<bool> save({
    required List<String> disabledFeatures,
    required List<String> disabledReports,
  }) async {
    _authorize();
    final loaded = state.valueOrNull;
    if (state.isLoading || loaded == null || _saving) return false;
    if (disabledFeatures.any((k) => !loaded.availableFeatures.containsKey(k)) ||
        disabledReports.any((k) => !loaded.availableReports.containsKey(k))) {
      throw const FormatException('Unknown permission');
    }
    final generation = ++_generation;
    _saving = true;
    try {
      // The web-only workflow choice is never silently changed by the mobile UI.
      final features = disabledFeatures.toSet();
      final reports = disabledReports.toSet();
      for (final entry in loaded.availableFeatures.entries.where(
        (entry) => !entry.value,
      )) {
        loaded.disabledFeatures.contains(entry.key)
            ? features.add(entry.key)
            : features.remove(entry.key);
      }
      for (final entry in loaded.availableReports.entries.where(
        (entry) => !entry.value,
      )) {
        loaded.disabledReports.contains(entry.key)
            ? reports.add(entry.key)
            : reports.remove(entry.key);
      }
      loaded.disabledFeatures.contains('workflow')
          ? features.add('workflow')
          : features.remove('workflow');
      final data = UserSubUserPermissions.fromJson(
        await _service.replacePermissions(
          id,
          disabledFeatures: features.toList()..sort(),
          disabledReports: reports.toList()..sort(),
        ),
      );
      if (!mounted || generation != _generation || !_canManage()) return false;
      state = AsyncData(data);
      return true;
    } finally {
      _saving = false;
    }
  }

  @override
  void dispose() {
    _generation++;
    super.dispose();
  }
}
