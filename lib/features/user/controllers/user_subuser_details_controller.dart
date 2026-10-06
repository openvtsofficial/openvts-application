import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../models/user_subuser_model.dart';
import '../models/user_subusers_state.dart';
import '../services/user_subuser_service.dart';

class UserSubUserDetailsController
    extends StateNotifier<UserSubUserDetailsState> {
  UserSubUserDetailsController({
    required String subUserId,
    required UserSubUserService service,
  }) : _subUserId = subUserId,
       _service = service,
       super(const UserSubUserDetailsState.initial());

  final String _subUserId;
  final UserSubUserService _service;
  int _profileGeneration = 0;

  Future<void> loadInitial() async {
    if (!mounted) return;
    final generation = ++_profileGeneration;
    // Only state fetched by this scoped controller is retained during refresh.
    // List/route extras have no principal/server provenance and cannot seed it.
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final subUser = await _service.fetchSubUserById(
        _subUserId,
        refreshKey: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      if (!mounted || generation != _profileGeneration) return;
      if (subUser.id != _subUserId) {
        throw const ApiException(
          message: 'Sub user details could not be loaded.',
        );
      }
      state = state.copyWith(subUser: subUser, isLoading: false);
      // A denied/unavailable vehicle list must not hide a verified profile or
      // prevent the manager from opening the independent Permissions tab.
      await loadVehicles();
    } catch (error) {
      if (!mounted || generation != _profileGeneration) return;
      final statusCode = error is ApiException
          ? error.statusCode
          : error is DioException
          ? error.response?.statusCode
          : null;
      final noAccess = const {401, 403, 404}.contains(statusCode);
      state = state.copyWith(
        isLoading: false,
        subUser: noAccess ? null : state.subUser,
        errorMessage: _toErrorMessage(error),
      );
    }
  }

  @override
  void dispose() {
    _profileGeneration++;
    super.dispose();
  }

  bool get _canMutate =>
      mounted &&
      !state.isLoading &&
      state.subUser?.id == _subUserId &&
      !state.isSaving &&
      !state.isDeleting &&
      !state.isTogglingStatus &&
      !state.isAssigningVehicles &&
      !state.isUnassigningVehicles;

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<bool> updateSubUser(UpdateUserSubUserRequest request) async {
    if (!_canMutate) return false;
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final updated = await _service.updateSubUser(_subUserId, request);
      if (!mounted) {
        return false;
      }

      state = state.copyWith(subUser: updated, isSaving: false);
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        isSaving: false,
        errorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> toggleStatus() async {
    if (!_canMutate) return false;
    final current = state.subUser;
    if (current == null) {
      return false;
    }

    final optimistic = current.copyWith(
      isActive: !current.isActive,
      status: current.isActive ? 'inactive' : 'active',
    );

    state = state.copyWith(
      subUser: optimistic,
      isTogglingStatus: true,
      errorMessage: null,
    );

    try {
      final updated = await _service.updateSubUser(
        _subUserId,
        UpdateUserSubUserRequest(isActive: optimistic.isActive),
      );

      if (!mounted) {
        return false;
      }

      state = state.copyWith(subUser: updated, isTogglingStatus: false);
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        subUser: current,
        isTogglingStatus: false,
        errorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> deleteSubUser() async {
    if (!_canMutate) return false;
    state = state.copyWith(isDeleting: true, errorMessage: null);

    try {
      await _service.deleteSubUser(_subUserId);
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        subUser: null,
        assignedVehicles: const <UserSubUserVehicle>[],
        availableVehicles: const <UserSubUserVehicle>[],
        selectedVehicleIds: const <String>{},
        isDeleting: false,
      );
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        isDeleting: false,
        errorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<void> loadVehicles() async {
    if (!mounted || state.subUser?.id != _subUserId) return;
    state = state.copyWith(isLoadingVehicles: true, errorMessage: null);

    try {
      final results = await Future.wait<dynamic>([
        _service.fetchSubUserVehicles(_subUserId),
        _service.fetchAvailableVehicles(),
      ]);

      if (!mounted) {
        return;
      }

      final assigned = results[0] as List<UserSubUserVehicle>;
      final available = _toAvailableVehicles(
        results[1] as List<UserSubUserVehicle>,
        assigned,
      );

      state = state.copyWith(
        assignedVehicles: assigned,
        availableVehicles: available,
        selectedVehicleIds: _keepExistingSelection(
          state.selectedVehicleIds,
          available,
        ),
        isLoadingVehicles: false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isLoadingVehicles: false,
        errorMessage: _toErrorMessage(error),
      );
    }
  }

  Future<bool> assignVehicles(List<String> vehicleIds) async {
    if (!_canMutate) return false;
    final normalizedIds = _normalizeVehicleIds(vehicleIds);
    if (normalizedIds.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please select at least one vehicle.',
      );
      return false;
    }

    state = state.copyWith(isAssigningVehicles: true, errorMessage: null);

    try {
      await _service.assignVehicles(_subUserId, normalizedIds);
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        isAssigningVehicles: false,
        selectedVehicleIds: const <String>{},
      );

      await loadVehicles();
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        isAssigningVehicles: false,
        errorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> unassignVehicles(List<String> vehicleIds) async {
    if (!_canMutate) return false;
    final normalizedIds = _normalizeVehicleIds(vehicleIds);
    if (normalizedIds.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please select at least one vehicle.',
      );
      return false;
    }

    state = state.copyWith(isUnassigningVehicles: true, errorMessage: null);

    try {
      await _service.unassignVehicles(_subUserId, normalizedIds);
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        isUnassigningVehicles: false,
        selectedVehicleIds: const <String>{},
      );

      await loadVehicles();
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      state = state.copyWith(
        isUnassigningVehicles: false,
        errorMessage: _toErrorMessage(error),
      );
      return false;
    }
  }

  void setSelectedVehicleIds(Iterable<String> vehicleIds) {
    state = state.copyWith(
      selectedVehicleIds: _normalizeVehicleIds(vehicleIds.toList()).toSet(),
    );
  }

  void clearVehicleSelection() {
    state = state.copyWith(selectedVehicleIds: const <String>{});
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  List<UserSubUserVehicle> _toAvailableVehicles(
    List<UserSubUserVehicle> source,
    List<UserSubUserVehicle> assigned,
  ) {
    final assignedIds = assigned
        .map((item) => item.id.trim())
        .where((item) => item.isNotEmpty)
        .toSet();

    final deduped = <String, UserSubUserVehicle>{};
    for (final vehicle in source) {
      final id = vehicle.id.trim();
      if (id.isEmpty || assignedIds.contains(id) || deduped.containsKey(id)) {
        continue;
      }
      deduped[id] = vehicle;
    }

    return deduped.values.toList(growable: false);
  }

  Set<String> _keepExistingSelection(
    Set<String> selected,
    List<UserSubUserVehicle> available,
  ) {
    final allowed = available
        .map((item) => item.id.trim())
        .where((item) => item.isNotEmpty)
        .toSet();

    return selected.where((id) => allowed.contains(id.trim())).toSet();
  }

  List<String> _normalizeVehicleIds(List<String> values) {
    final ordered = <String>[];
    final seen = <String>{};

    for (final value in values) {
      final normalized = value.trim();
      final parsed = int.tryParse(normalized);
      if (parsed == null || parsed <= 0) {
        continue;
      }
      final key = parsed.toString();
      if (seen.contains(key)) {
        continue;
      }
      seen.add(key);
      ordered.add(key);
    }

    return ordered;
  }

  String _toErrorMessage(Object error) {
    if (error is ApiException) return error.message;
    if (error is ArgumentError) {
      final message = error.message?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    if (error is DioException) {
      final responseMessage = _extractResponseMessage(error.response?.data);
      if (responseMessage != null) {
        return responseMessage;
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'The request timed out. Please try again.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'Unable to reach the server right now.';
      }

      final message = error.message?.trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    final raw = error.toString().trim();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length).trim();
    }

    return raw.isEmpty ? 'Sub user details could not be loaded.' : raw;
  }

  String? _extractResponseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final key in const ['message', 'error']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }

        if (value is List) {
          final parts = value
              .whereType<String>()
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList(growable: false);
          if (parts.isNotEmpty) {
            return parts.join(', ');
          }
        }
      }

      final nestedData = data['data'];
      if (!identical(nestedData, data)) {
        return _extractResponseMessage(nestedData);
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    return null;
  }
}
