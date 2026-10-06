import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../models/admin_user_permissions.dart';
import '../services/admin_user_access_service.dart';

final adminUserAccessServiceProvider = Provider<AdminUserAccessService>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return AdminUserAccessService(ref.watch(apiClientProvider));
});
final adminUserPermissionsControllerProvider = StateNotifierProvider.autoDispose
    .family<AdminUserPermissionsController, AdminUserPermissionsState, String>((
      ref,
      id,
    ) {
      final controller = AdminUserPermissionsController(
        ref.watch(adminUserAccessServiceProvider),
        id,
      );
      controller.load();
      return controller;
    });

class AdminUserPermissionsState {
  const AdminUserPermissionsState({
    this.saved,
    this.draft,
    this.loading = false,
    this.saving = false,
    this.error,
  });
  final AdminUserPermissions? saved;
  final AdminUserPermissions? draft;
  final bool loading;
  final bool saving;
  final String? error;
  bool get dirty =>
      saved != null &&
      draft != null &&
      jsonEncode(saved!.toJson()) != jsonEncode(draft!.toJson());
}

class AdminUserPermissionsController
    extends StateNotifier<AdminUserPermissionsState> {
  AdminUserPermissionsController(this._service, this.userId)
    : super(const AdminUserPermissionsState());
  final AdminUserAccessService _service;
  final String userId;
  int _request = 0;
  bool _valid(int request) =>
      mounted && request == _request && _service.isCurrent;

  Future<void> load() async {
    if (!mounted || state.saving) return;
    final request = ++_request;
    state = const AdminUserPermissionsState(loading: true);
    try {
      final data = await _service.getPermissions(userId);
      if (_valid(request)) {
        state = AdminUserPermissionsState(saved: data, draft: data);
      }
    } catch (error) {
      if (mounted && request == _request) {
        state = AdminUserPermissionsState(
          error: error is ApiException ? error.message : 'Unable to load',
        );
      }
    }
  }

  void setFeature(String key, bool enabled) {
    if (!mounted ||
        state.loading ||
        state.saving ||
        !_service.isCurrent ||
        state.draft == null) {
      return;
    }
    state = AdminUserPermissionsState(
      saved: state.saved,
      draft: state.draft!.withFeature(key, enabled),
    );
  }

  void setReport(String key, bool enabled) {
    if (!mounted ||
        state.loading ||
        state.saving ||
        !_service.isCurrent ||
        state.draft == null) {
      return;
    }
    state = AdminUserPermissionsState(
      saved: state.saved,
      draft: state.draft!.withReport(key, enabled),
    );
  }

  void reset() {
    if (mounted && !state.saving && _service.isCurrent) {
      state = AdminUserPermissionsState(saved: state.saved, draft: state.saved);
    }
  }

  Future<bool> save() async {
    if (!mounted ||
        state.loading ||
        state.saving ||
        !state.dirty ||
        state.draft == null ||
        !_service.isCurrent) {
      return false;
    }
    final request = ++_request;
    final previous = state;
    state = AdminUserPermissionsState(
      saved: previous.saved,
      draft: previous.draft,
      saving: true,
    );
    try {
      final data = await _service.savePermissions(userId, previous.draft!);
      if (!_valid(request)) return false;
      state = AdminUserPermissionsState(saved: data, draft: data);
      return true;
    } catch (error) {
      if (mounted && request == _request) {
        state = AdminUserPermissionsState(
          saved: previous.saved,
          draft: previous.draft,
          error: _message(error),
        );
      }
      return false;
    }
  }

  String _message(Object error) =>
      error is ApiException ? error.message : 'Unable to save permissions';
  @override
  void dispose() {
    _request++;
    super.dispose();
  }
}
