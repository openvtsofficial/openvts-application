import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../models/admin_user_retention_policy.dart';
import '../services/admin_user_access_service.dart';
import 'admin_user_permissions_controller.dart';

final adminUserRetentionControllerProvider = StateNotifierProvider.autoDispose
    .family<AdminUserRetentionController, AdminUserRetentionState, String>((
      ref,
      id,
    ) {
      final controller = AdminUserRetentionController(
        ref.watch(adminUserAccessServiceProvider),
        id,
      );
      controller.load();
      return controller;
    });

class AdminUserRetentionState {
  const AdminUserRetentionState({
    this.policy,
    this.days,
    this.loading = false,
    this.saving = false,
    this.error,
  });
  final AdminUserRetentionPolicy? policy;
  final int? days;
  final bool loading, saving;
  final String? error;
  bool get dirty => policy != null && days != policy!.selectedDays;
}

class AdminUserRetentionController
    extends StateNotifier<AdminUserRetentionState> {
  AdminUserRetentionController(this._service, this.userId)
    : super(const AdminUserRetentionState());
  final AdminUserAccessService _service;
  final String userId;
  int _request = 0;
  bool _valid(int request) =>
      mounted && request == _request && _service.isCurrent;
  Future<void> load() async {
    if (!mounted || state.saving) return;
    final request = ++_request;
    state = const AdminUserRetentionState(loading: true);
    try {
      final policy = await _service.getRetention(userId);
      if (_valid(request)) {
        state = AdminUserRetentionState(
          policy: policy,
          days: policy.selectedDays,
        );
      }
    } catch (error) {
      if (mounted && request == _request) {
        state = AdminUserRetentionState(
          error: error is ApiException
              ? error.message
              : 'Unable to load data retention',
        );
      }
    }
  }

  void select(int? days) {
    if (!mounted) return;
    final policy = state.policy;
    if (!mounted ||
        state.loading ||
        state.saving ||
        !_service.isCurrent ||
        policy == null ||
        (days != null && !policy.availableDays.contains(days))) {
      return;
    }
    state = AdminUserRetentionState(policy: policy, days: days);
  }

  void reset() {
    if (mounted &&
        !state.saving &&
        _service.isCurrent &&
        state.policy != null) {
      state = AdminUserRetentionState(
        policy: state.policy,
        days: state.policy!.selectedDays,
      );
    }
  }

  Future<bool> save() async {
    if (!mounted ||
        state.loading ||
        state.saving ||
        !state.dirty ||
        !_service.isCurrent ||
        state.policy == null) {
      return false;
    }
    final request = ++_request;
    final previous = state;
    state = AdminUserRetentionState(
      policy: previous.policy,
      days: previous.days,
      saving: true,
    );
    try {
      final policy = await _service.saveRetention(
        userId,
        previous.days,
        maxDays: previous.policy!.maxDays,
      );
      if (!_valid(request)) return false;
      state = AdminUserRetentionState(
        policy: policy,
        days: policy.selectedDays,
      );
      return true;
    } catch (error) {
      if (mounted && request == _request) {
        state = AdminUserRetentionState(
          policy: previous.policy,
          days: previous.days,
          error: error is ApiException
              ? error.message
              : 'Unable to save data retention',
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    _request++;
    super.dispose();
  }
}
