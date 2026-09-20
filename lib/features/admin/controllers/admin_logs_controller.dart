import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../models/admin_logs_model.dart';
import '../models/admin_logs_state.dart';
import '../services/admin_logs_service.dart';

class AdminLogsController extends StateNotifier<AdminLogsState> {
  AdminLogsController({required AdminLogsService service})
      : _service = service,
        super(const AdminLogsState.initial()) {
    // Surface default date windows in the pickers so users know why results are
    // bounded.  The backend applies the same defaults when `from` is absent.
    final now = DateTime.now();
    state = state.copyWith(
      vehicleFrom: now.subtract(const Duration(hours: 24)),
      telemetryFrom: now.subtract(const Duration(hours: 1)),
    );
    unawaited(loadInitial());
  }

  final AdminLogsService _service;

  Future<void> loadInitial() async {
    await loadOptions();
    await loadActivityLogs();
  }

  Future<void> selectTab(AdminLogsTab tab) async {
    state = state.copyWith(selectedTab: tab, sectionErrorMessage: null);
    if (tab == AdminLogsTab.vehicle &&
        state.vehicleLogs.isEmpty &&
        !state.isLoadingVehicle) {
      await loadVehicleLogs();
    }
    if (tab == AdminLogsTab.telemetry &&
        state.telemetryLogs.isEmpty &&
        !state.isLoadingTelemetry) {
      await loadTelemetryLogs();
    }
  }

  Future<void> refreshCurrentTab() async {
    switch (state.selectedTab) {
      case AdminLogsTab.activity:
        await loadActivityLogs();
      case AdminLogsTab.vehicle:
        await loadVehicleLogs();
      case AdminLogsTab.telemetry:
        await loadTelemetryLogs();
    }
  }

  Future<void> loadOptions() async {
    state = state.copyWith(isLoadingOptions: true, errorMessage: null);
    try {
      final options = await _service.getOptions();
      state = state.copyWith(isLoadingOptions: false, options: options);
    } catch (e) {
      state =
          state.copyWith(isLoadingOptions: false, errorMessage: _toError(e));
    }
  }

  Future<void> loadActivityLogs() async {
    state = state.copyWith(
      isLoadingActivity: true,
      sectionErrorMessage: null,
      activityNextCursorId: null,
      activityHasMore: false,
    );
    try {
      final page = await _service.getActivityLogs(
        limit: 20,
        q: _effectiveActivityQuery(state),
        userId: state.activityUserId,
        entity: state.activityEntity,
        from: _fmt(state.activityFrom),
        to: _fmt(state.activityTo),
      );
      state = state.copyWith(
        isLoadingActivity: false,
        activityLogs: page.items,
        activityNextCursorId: page.nextCursorId,
        activityHasMore: page.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingActivity: false,
        sectionErrorMessage: _toError(e),
      );
    }
  }

  Future<void> loadMoreActivityLogs() async {
    if (!state.activityHasMore ||
        state.isLoadingMoreActivity ||
        state.isLoadingActivity) {
      return;
    }
    state = state.copyWith(isLoadingMoreActivity: true);
    try {
      final page = await _service.getActivityLogs(
        limit: 20,
        cursorId: state.activityNextCursorId,
        q: _effectiveActivityQuery(state),
        userId: state.activityUserId,
        entity: state.activityEntity,
        from: _fmt(state.activityFrom),
        to: _fmt(state.activityTo),
      );
      state = state.copyWith(
        isLoadingMoreActivity: false,
        activityLogs: <AdminActivityLogItem>[
          ...state.activityLogs,
          ...page.items
        ],
        activityNextCursorId: page.nextCursorId,
        activityHasMore: page.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMoreActivity: false,
        sectionErrorMessage: _toError(e),
      );
    }
  }

  Future<void> loadVehicleLogs() async {
    state = state.copyWith(
      isLoadingVehicle: true,
      sectionErrorMessage: null,
      vehicleNextCursorId: null,
    );
    try {
      final page = await _service.getVehicleEventLogs(
        limit: 50,
        from: _fmt(state.vehicleFrom),
        to: _fmt(state.vehicleTo),
        vehicleId: state.vehicleVehicleId,
        userId: state.vehicleUserId,
        source: state.vehicleSource,
        severity: state.vehicleSeverity,
        q: state.vehicleSearch,
        isRead: _serverReadFilter(state.vehicleReadFilter),
        dedupe: state.vehicleDedupe,
      );
      state = state.copyWith(
        isLoadingVehicle: false,
        vehicleLogs: page.items,
        vehicleNextCursorId: page.nextCursorId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingVehicle: false,
        sectionErrorMessage: _toError(e),
      );
    }
  }

  Future<void> loadMoreVehicleLogs() async {
    if (state.isLoadingMoreVehicle ||
        state.isLoadingVehicle ||
        (state.vehicleNextCursorId ?? '').isEmpty) {
      return;
    }
    state = state.copyWith(isLoadingMoreVehicle: true);
    try {
      final page = await _service.getVehicleEventLogs(
        limit: 50,
        cursorId: state.vehicleNextCursorId,
        from: _fmt(state.vehicleFrom),
        to: _fmt(state.vehicleTo),
        vehicleId: state.vehicleVehicleId,
        userId: state.vehicleUserId,
        source: state.vehicleSource,
        severity: state.vehicleSeverity,
        q: state.vehicleSearch,
        isRead: _serverReadFilter(state.vehicleReadFilter),
        dedupe: state.vehicleDedupe,
      );
      state = state.copyWith(
        isLoadingMoreVehicle: false,
        vehicleLogs: <AdminVehicleEventLogItem>[
          ...state.vehicleLogs,
          ...page.items
        ],
        vehicleNextCursorId: page.nextCursorId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMoreVehicle: false,
        sectionErrorMessage: _toError(e),
      );
    }
  }

  Future<void> loadTelemetryLogs() async {
    state = state.copyWith(
      isLoadingTelemetry: true,
      sectionErrorMessage: null,
      telemetryNextCursor: null,
    );
    try {
      final page = await _service.getTelemetryLogs(
        limit: 200,
        from: _fmt(state.telemetryFrom),
        to: _fmt(state.telemetryTo),
        vehicleId: state.telemetryVehicleId,
        imei: state.telemetryImeiSearch,
        packetType: state.telemetryPacketType,
      );
      state = state.copyWith(
        isLoadingTelemetry: false,
        telemetryLogs: page.items,
        telemetryNextCursor: page.nextCursor,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTelemetry: false,
        sectionErrorMessage: _toError(e),
      );
    }
  }

  Future<void> loadMoreTelemetryLogs() async {
    if (state.isLoadingMoreTelemetry ||
        state.isLoadingTelemetry ||
        (state.telemetryNextCursor ?? '').isEmpty) {
      return;
    }
    state = state.copyWith(isLoadingMoreTelemetry: true);
    try {
      final page = await _service.getTelemetryLogs(
        limit: 200,
        beforeId: state.telemetryNextCursor,
        from: _fmt(state.telemetryFrom),
        to: _fmt(state.telemetryTo),
        vehicleId: state.telemetryVehicleId,
        imei: state.telemetryImeiSearch,
        packetType: state.telemetryPacketType,
      );
      state = state.copyWith(
        isLoadingMoreTelemetry: false,
        telemetryLogs: <AdminTelemetryLogItem>[
          ...state.telemetryLogs,
          ...page.items
        ],
        telemetryNextCursor: page.nextCursor,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMoreTelemetry: false,
        sectionErrorMessage: _toError(e),
      );
    }
  }

  void setActivityFilters({
    String? userId,
    String? actionPrefix,
    String? entity,
    String? search,
    DateTime? from,
    DateTime? to,
    bool clearUserId = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    state = state.copyWith(
      activityUserId: clearUserId ? null : userId ?? state.activityUserId,
      activityActionPrefix: actionPrefix ?? state.activityActionPrefix,
      activityEntity: entity ?? state.activityEntity,
      activitySearch: search ?? state.activitySearch,
      activityFrom: clearFrom ? null : from ?? state.activityFrom,
      activityTo: clearTo ? null : to ?? state.activityTo,
      activityLogs: const <AdminActivityLogItem>[],
      activityNextCursorId: null,
      activityHasMore: false,
    );
  }

  void setVehicleFilters({
    String? vehicleId,
    String? userId,
    String? source,
    String? severity,
    AdminReadFilter? readFilter,
    String? search,
    DateTime? from,
    DateTime? to,
    bool? dedupe,
    bool clearVehicleId = false,
    bool clearUserId = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    state = state.copyWith(
      vehicleVehicleId:
          clearVehicleId ? null : vehicleId ?? state.vehicleVehicleId,
      vehicleUserId: clearUserId ? null : userId ?? state.vehicleUserId,
      vehicleSource: source ?? state.vehicleSource,
      vehicleSeverity: severity ?? state.vehicleSeverity,
      vehicleReadFilter: readFilter ?? state.vehicleReadFilter,
      vehicleSearch: search ?? state.vehicleSearch,
      vehicleFrom: clearFrom ? null : from ?? state.vehicleFrom,
      vehicleTo: clearTo ? null : to ?? state.vehicleTo,
      vehicleDedupe: dedupe ?? state.vehicleDedupe,
      vehicleLogs: const <AdminVehicleEventLogItem>[],
      vehicleNextCursorId: null,
    );
  }

  void setTelemetryFilters({
    String? vehicleId,
    String? packetType,
    String? imeiSearch,
    DateTime? from,
    DateTime? to,
    AdminReadFilter? readFilter,
    bool clearVehicleId = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    state = state.copyWith(
      telemetryVehicleId:
          clearVehicleId ? null : vehicleId ?? state.telemetryVehicleId,
      telemetryPacketType: packetType ?? state.telemetryPacketType,
      telemetryImeiSearch: imeiSearch ?? state.telemetryImeiSearch,
      telemetryFrom: clearFrom ? null : from ?? state.telemetryFrom,
      telemetryTo: clearTo ? null : to ?? state.telemetryTo,
      telemetryReadFilter: readFilter ?? state.telemetryReadFilter,
      telemetryLogs: const <AdminTelemetryLogItem>[],
      telemetryNextCursor: null,
    );
  }

  Future<AdminVehicleEventDetail> getVehicleEventDetail(String id) async {
    return _service.getVehicleEventDetail(id);
  }

  Future<AdminTelemetryDetail> getTelemetryDetail(String id) {
    return _service.getTelemetryDetail(id);
  }

  /// Manual search text takes priority; falls back to the selected chip keyword.
  /// Both are sent as `q` (backend: action/entity contains match), never as
  /// `actionPrefix` (backend: action startsWith) because chip values like
  /// "AUTH" do not match the `ROLE.RESOURCE.OP` action format.
  static String? _effectiveActivityQuery(AdminLogsState s) {
    final manual = s.activitySearch.trim();
    if (manual.isNotEmpty) return manual;
    final chip = s.activityActionPrefix.trim();
    if (chip.isNotEmpty) return chip;
    return null;
  }

  String? _fmt(DateTime? dt) {
    if (dt == null) return null;
    return dt.toUtc().toIso8601String();
  }

  bool? _serverReadFilter(AdminReadFilter filter) {
    switch (filter) {
      case AdminReadFilter.all:
        return null;
      case AdminReadFilter.read:
        return true;
      case AdminReadFilter.unread:
        return false;
    }
  }

  String _toError(Object e) {
    if (e is ApiException) return e.message;
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'] ??
            (data['data'] is Map ? (data['data'] as Map)['message'] : null);
        if (msg is String && msg.trim().isNotEmpty) return msg.trim();
      }
      final m = e.message?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    return 'Unable to load vehicle events.';
  }
}
