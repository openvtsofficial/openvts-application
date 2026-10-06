import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/socket/socket_service.dart';
import '../../../shared/models/vehicle_summary.dart';
import '../../../shared/utils/live_vehicle_presentation.dart';
import '../../notifications/models/app_notification.dart';
import '../models/live_map_role_config.dart';
import '../models/live_map_state.dart';
import '../services/live_map_events_service.dart';
import '../services/live_map_vehicle_service.dart';

/// Role-aware live-map controller.
///
/// A complete HTTP baseline establishes authorized membership; sockets patch
/// those existing identities while lifecycle recovery catches missed updates.
/// All endpoints come from [LiveMapRoleConfig], so Admin/User sessions never
/// touch a Superadmin route. Socket subscription messages are role-shaped:
///    * superadmin → explicit scope subscriptions with HTTP-seed snapshots
///      disabled; live telemetry arrives in bounded batches.
///    * admin / user → chunked `telemetry:subscribe { imeis: [...] }` and
///      `notif:subscribe { imeis: [...] }`, built from the REST baseline.
///
/// Telemetry publishes in a bounded 120 ms batch; alert dedupe retains the
/// newest 300 records. Status classification is shared with marker rendering.
class LiveMapController extends StateNotifier<LiveMapState>
    with WidgetsBindingObserver {
  LiveMapController({
    required LiveMapVehicleService vehicleService,
    required LiveMapEventsService mapEventsService,
    required SocketService socketService,
    required LiveMapRoleConfig config,
    DateTime Function()? now,
  }) : _vehicleService = vehicleService,
       _mapEventsService = mapEventsService,
       _socketService = socketService,
       _config = config,
       _now = now ?? DateTime.now,
       super(const LiveMapState.initial());

  static const String _superadminScope = 'superadmin';
  static const String _demoScope = 'demo';
  static const int _maxImeisPerSocketSubscription = 5000;
  static const int _alertBootstrapLimit = 50;
  static const int _maxAlerts = 300;
  static const Duration _liveUpdateBatchWindow = Duration(milliseconds: 120);
  static const double _minCoordinateMoveMeters = 2;
  static const double _stationaryDriftSpeedKph = 5;
  static const double _stationaryDriftDistanceMeters = 25;
  static const double _maxPlausibleImpliedSpeedKph = 320;

  final LiveMapVehicleService _vehicleService;
  final LiveMapEventsService _mapEventsService;
  final SocketService _socketService;
  final LiveMapRoleConfig _config;
  final DateTime Function() _now;
  Timer? _maintenanceTimer;
  Future<bool>? _baselineRequest;
  DateTime? _lastBaselineAttempt;
  String? _lastBaselineAttemptDay;
  DateTime? _lastTelemetryPacket;
  bool _initialized = false;
  bool _isForeground = true;
  bool _hasConnectedTelemetry = false;
  bool _isConnectingTelemetry = false;
  bool _isConnectingNotifications = false;
  final Map<String, DateTime> _deviceStatusTimes = <String, DateTime>{};

  SocketConnection? _telemetryConnection;
  SocketConnection? _notificationsConnection;
  Map<String, VehicleSummary> _vehiclesByKey = <String, VehicleSummary>{};
  Map<String, String> _vehicleKeyByAlias = <String, String>{};
  final Map<String, dynamic> _pendingTelemetryUpdatesByAlias =
      <String, dynamic>{};
  final Map<String, dynamic> _pendingDeviceStatusUpdatesByAlias =
      <String, dynamic>{};
  Timer? _liveTelemetryPublishTimer;
  bool _hasPendingTelemetryPublish = false;
  bool _didSeedTelemetry = false;
  bool _hasTelemetryBaseline = false;

  /// Sorted, de-duped IMEI list derived from REST baseline. Used as the
  /// subscription payload for admin/user roles.
  List<String> _baselineImeis = const <String>[];
  String? _lastSentTelemetrySubscriptionHash;
  String? _lastSentNotificationSubscriptionHash;

  LiveMapRoleConfig get config => _config;

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addObserver(this);
    _maintenanceTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _maintainTelemetry(),
    );
    unawaited(_initializeTelemetry());
    unawaited(_bootstrapAlerts());
    unawaited(_connectNotificationsSocket());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    if (_isForeground && mounted) {
      unawaited(refreshTelemetry());
      unawaited(_connectNotificationsSocket());
    }
  }

  /// Reconcile the authorized fleet after resume, reconnect, or retry. A
  /// failed page keeps the last complete baseline, never a partial fleet.
  Future<void> refreshTelemetry() async {
    final loaded = await _bootstrapTelemetrySeed(force: true);
    if (loaded && mounted) {
      await _connectTelemetrySocket(replaceDisconnected: true);
      await _connectNotificationsSocket(replaceDisconnected: true);
    }
  }

  void _maintainTelemetry() {
    if (!mounted || !_isForeground) return;
    // Classification ages without packets (pending stop, stale, inactive).
    // Publish only changed status/counts so an idle fleet does not repaint.
    if (_hasTelemetryBaseline) _publishMergedTelemetry(onlyIfChanged: true);
    final now = _now();
    final silent =
        _lastTelemetryPacket == null ||
        now.difference(_lastTelemetryPacket!) >= const Duration(seconds: 30);
    final interval = state.isTelemetryConnected && !silent
        ? const Duration(seconds: 60)
        : const Duration(seconds: 30);
    if (_lastBaselineAttempt == null ||
        _lastBaselineAttemptDay != _localDayKey(now) ||
        now.difference(_lastBaselineAttempt!) >= interval) {
      unawaited(refreshTelemetry());
    }
    if (_notificationsConnection == null) {
      unawaited(_connectNotificationsSocket());
    }
  }

  Future<void> _initializeTelemetry() async {
    final didLoadBaseline = await _bootstrapTelemetrySeed();
    if (!mounted || !didLoadBaseline) {
      return;
    }

    await _connectTelemetrySocket();
  }

  Future<bool> _bootstrapTelemetrySeed({bool force = false}) {
    if (_didSeedTelemetry && !force) return Future<bool>.value(true);
    final active = _baselineRequest;
    if (active != null) return active;
    final request = _loadTelemetryBaseline();
    _baselineRequest = request;
    return request.whenComplete(() {
      if (identical(_baselineRequest, request)) _baselineRequest = null;
    });
  }

  Future<bool> _loadTelemetryBaseline() async {
    _lastBaselineAttempt = _now();
    _lastBaselineAttemptDay = _localDayKey(_lastBaselineAttempt!);
    try {
      final telemetry = await _vehicleService.getMapTelemetry();
      if (!mounted) return false;

      final previous = _vehiclesByKey.values.toList(growable: false);
      final previousImeis = _baselineImeis.toSet();
      _didSeedTelemetry = true;
      _hasTelemetryBaseline = true;
      _replaceBaselineVehicles(telemetry.vehicles);
      // HTTP governs membership. Preserve newer socket state only for
      // identities that remain in the complete authorized response.
      for (final live in previous) {
        final key = _resolveStorageKey(
          _vehiclesByKey,
          _vehicleKeyByAlias,
          aliases: _identityAliasesForVehicle(live),
          allowCreate: false,
        );
        final fresh = key == null ? null : _vehiclesByKey[key];
        final liveTime = liveVehicleReceiveTime(live);
        final freshTime = fresh == null ? null : liveVehicleReceiveTime(fresh);
        if (fresh != null &&
            !fresh.licenseBlocked &&
            liveTime != null &&
            freshTime != null &&
            liveTime.isAfter(freshTime)) {
          _upsertVehicle(
            _vehiclesByKey,
            _vehicleKeyByAlias,
            live,
            aliases: _identityAliasesForVehicle(live),
            allowCreate: false,
          );
        }
      }
      _rebuildBaselineImeis();
      _deviceStatusTimes.removeWhere(
        (key, _) => !_vehiclesByKey.containsKey(key),
      );
      _applyPendingLiveUpdates();
      _publishMergedTelemetry();

      if (previousImeis.difference(_baselineImeis.toSet()).isNotEmpty) {
        // There is no unsubscribe contract. Recreate subscriptions to drop
        // rooms for removed assignments, rather than accumulating access.
        _telemetryConnection?.disconnect();
        _telemetryConnection = null;
        _notificationsConnection?.disconnect();
        _notificationsConnection = null;
        _lastSentTelemetrySubscriptionHash = null;
        _lastSentNotificationSubscriptionHash = null;
        unawaited(_connectNotificationsSocket());
      }
      _sendTelemetrySubscriptionIfNeeded();
      _sendNotificationSubscriptionIfNeeded();
      return true;
    } catch (error) {
      if (mounted) {
        state = state.copyWith(
          isInitialLoading: false,
          errorMessage: _formatError(error),
        );
      }
      return false;
    }
  }

  Future<void> _connectTelemetrySocket({
    bool replaceDisconnected = false,
  }) async {
    if (_isConnectingTelemetry) return;
    if (replaceDisconnected && _telemetryConnection?.isConnected == false) {
      _telemetryConnection?.disconnect();
      _telemetryConnection = null;
    }
    if (_telemetryConnection != null) return;
    _isConnectingTelemetry = true;
    try {
      final connection = await _socketService.connect(
        _config.telemetryNamespace,
        authenticated: _config.socketAuthenticationRequired,
      );
      if (!mounted) {
        connection.disconnect();
        return;
      }

      _telemetryConnection = connection;
      bool active() => mounted && identical(_telemetryConnection, connection);
      void listen(String event, SocketEventHandler handler) {
        connection.on(event, (data) {
          if (active()) handler(data);
        });
      }

      connection.onConnect(() {
        if (active()) _handleTelemetryConnected();
      });
      connection.onDisconnect((data) {
        if (active()) _handleTelemetryDisconnected(data);
      });
      connection.onError((error) {
        if (active()) _handleTelemetrySocketError(error);
      });
      listen('telemetry:snapshot', _handleTelemetrySnapshot);
      listen('telemetry:snapshot:chunk', _handleTelemetrySnapshotChunk);
      listen('telemetry:update', _handleTelemetryUpdate);
      listen('telemetry:update:batch', _handleTelemetryUpdateBatch);
      listen('devicestatus:update', _handleDeviceStatusUpdate);
      listen('telemetry:error', _handleTelemetrySocketError);

      if (connection.isConnected) {
        _handleTelemetryConnected();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isTelemetryConnected: false,
        errorMessage: _formatError(error),
      );
    } finally {
      _isConnectingTelemetry = false;
    }
  }

  Future<void> _connectNotificationsSocket({
    bool replaceDisconnected = false,
  }) async {
    if (_isConnectingNotifications) return;
    if (replaceDisconnected && _notificationsConnection?.isConnected == false) {
      _notificationsConnection?.disconnect();
      _notificationsConnection = null;
    }
    if (_notificationsConnection != null) return;
    final namespace = _config.notificationNamespace;
    if (namespace == null ||
        _config.notificationSubscribeMode ==
            LiveMapNotificationSubscribeMode.disabled) {
      return;
    }

    _isConnectingNotifications = true;
    try {
      final connection = await _socketService.connect(
        namespace,
        authenticated: _config.socketAuthenticationRequired,
      );
      if (!mounted) {
        connection.disconnect();
        return;
      }

      _notificationsConnection = connection;
      bool active() =>
          mounted && identical(_notificationsConnection, connection);
      connection.onConnect(() {
        if (active()) _handleNotificationsConnected();
      });
      connection.onDisconnect((data) {
        if (active()) _handleNotificationsDisconnected(data);
      });
      connection.onError((error) {
        if (active()) _handleNotificationsSocketError(error);
      });
      connection.on('notif:new', (data) {
        if (active()) _handleNotificationNew(data);
      });
      connection.on('notif:error', (error) {
        if (active()) _handleNotificationsSocketError(error);
      });

      if (connection.isConnected) {
        _handleNotificationsConnected();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isNotificationsConnected: false,
        errorMessage: _formatError(error),
      );
    } finally {
      _isConnectingNotifications = false;
    }
  }

  Future<void> _bootstrapAlerts() async {
    try {
      final page = await _mapEventsService.getMapEvents(
        limit: _alertBootstrapLimit,
      );
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        alerts: _mergeAlerts(current: state.alerts, incoming: page.items),
        isAlertsLoading: false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isAlertsLoading: false,
        errorMessage: _formatError(error),
      );
    }
  }

  void _handleTelemetryConnected() {
    if (!mounted) {
      return;
    }

    state = state.copyWith(isTelemetryConnected: true, errorMessage: null);

    // Force re-send on every connect (server lost any prior subscription).
    _lastSentTelemetrySubscriptionHash = null;
    _sendTelemetrySubscriptionIfNeeded();
    final reconnect = _hasConnectedTelemetry;
    _hasConnectedTelemetry = true;
    if (reconnect && _isForeground) unawaited(refreshTelemetry());
  }

  void _handleTelemetryDisconnected(dynamic _) {
    if (!mounted) {
      return;
    }

    _lastSentTelemetrySubscriptionHash = null;
    state = state.copyWith(isTelemetryConnected: false);
  }

  void _handleTelemetrySocketError(dynamic error) {
    if (!mounted) {
      return;
    }
    _lastSentTelemetrySubscriptionHash = null;
    state = state.copyWith(
      isTelemetryConnected: false,
      errorMessage: _formatError(error),
    );
  }

  void _handleTelemetrySnapshot(dynamic data) {
    _lastTelemetryPacket = _now();
    if (!mounted || !_hasTelemetryBaseline) {
      return;
    }

    var didChange = false;
    for (final record in _telemetryRecords(data)) {
      didChange = _applyTelemetryUpdate(record) || didChange;
    }
    if (didChange) _scheduleMergedTelemetryPublish();
  }

  void _handleTelemetrySnapshotChunk(dynamic data) {
    if (data is! Map) {
      return;
    }
    _handleTelemetrySnapshot(data['records']);
  }

  void _handleTelemetryUpdate(dynamic data) {
    if (!mounted) return;
    _lastTelemetryPacket = _now();
    if (!_hasTelemetryBaseline) {
      _bufferPendingTelemetryUpdate(data);
      return;
    }

    if (_applyTelemetryUpdate(data)) {
      _scheduleMergedTelemetryPublish();
    }
  }

  void _handleTelemetryUpdateBatch(dynamic data) {
    if (!mounted) return;
    _lastTelemetryPacket = _now();
    final records = _telemetryRecords(data);
    if (records.isEmpty) {
      return;
    }

    var didChange = false;
    for (final record in records) {
      if (!_hasTelemetryBaseline) {
        _bufferPendingTelemetryUpdate(record);
        continue;
      }
      didChange = _applyTelemetryUpdate(record) || didChange;
    }

    if (didChange) {
      _scheduleMergedTelemetryPublish();
    }
  }

  List<dynamic> _telemetryRecords(dynamic data) {
    if (data is List) {
      return data;
    }
    if (data is! Map) {
      return const <dynamic>[];
    }

    for (final key in const ['records', 'updates', 'items', 'data']) {
      final nested = data[key];
      if (nested is List) {
        return nested;
      }
    }
    return const <dynamic>[];
  }

  void _handleDeviceStatusUpdate(dynamic data) {
    if (!mounted) return;
    if (!_hasTelemetryBaseline) {
      _bufferPendingDeviceStatusUpdate(data);
      return;
    }

    if (_applyDeviceStatusUpdate(data)) {
      _scheduleMergedTelemetryPublish();
    }
  }

  bool _applyPendingLiveUpdates() {
    if (!_hasTelemetryBaseline) {
      return false;
    }

    var didChange = false;
    final pendingTelemetry = _pendingTelemetryUpdatesByAlias.values.toList(
      growable: false,
    );
    _pendingTelemetryUpdatesByAlias.clear();
    for (final update in pendingTelemetry) {
      didChange = _applyTelemetryUpdate(update) || didChange;
    }

    final pendingDeviceStatuses = _pendingDeviceStatusUpdatesByAlias.values
        .toList(growable: false);
    _pendingDeviceStatusUpdatesByAlias.clear();
    for (final update in pendingDeviceStatuses) {
      didChange = _applyDeviceStatusUpdate(update) || didChange;
    }

    return didChange;
  }

  void _bufferPendingTelemetryUpdate(dynamic data) {
    final vehicle = _vehicleService.parseTelemetryVehiclePayload(
      data,
      requireCoordinates: false,
    );
    final aliases = _identityAliasesForPayload(data, fallbackVehicle: vehicle);
    if (aliases.isEmpty) {
      return;
    }

    _pendingTelemetryUpdatesByAlias[aliases.first] = data;
  }

  void _bufferPendingDeviceStatusUpdate(dynamic data) {
    final aliases = _identityAliasesForPayload(data);
    if (aliases.isEmpty) {
      return;
    }

    _pendingDeviceStatusUpdatesByAlias[aliases.first] = data;
  }

  bool _applyTelemetryUpdate(dynamic data) {
    var vehicle = _vehicleService.parseTelemetryVehiclePayload(
      data,
      requireCoordinates: false,
    );
    if (vehicle == null) {
      return false;
    }

    final aliases = _identityAliasesForPayload(data, fallbackVehicle: vehicle);
    if (aliases.isEmpty) {
      return false;
    }

    final currentKey = _resolveStorageKey(
      _vehiclesByKey,
      _vehicleKeyByAlias,
      aliases: aliases,
      allowCreate: false,
    );
    final current = currentKey == null ? null : _vehiclesByKey[currentKey];
    if (current == null || current.licenseBlocked) return false;
    final source = _asMap(data);
    final telemetrySource = _asMap(source['telemetry']);
    bool hasField(List<String> keys) => keys.any(
      (key) => source.containsKey(key) || telemetrySource.containsKey(key),
    );
    // Socket payloads are telemetry patches, not vehicle records. Missing
    // values must not erase names, permissions, speed, or state. Explicit
    // zero/false/null remains an update where the field is present.
    vehicle = vehicle.copyWith(
      id: current.id,
      name: hasField(const ['name', 'vehicleName', 'vehicle_name'])
          ? vehicle.name
          : current.name,
      plateNumber: hasField(const ['plateNumber', 'plate_number'])
          ? vehicle.plateNumber
          : current.plateNumber,
      speed: hasField(const ['speed', 'speedKph', 'speed_kph'])
          ? vehicle.speed
          : current.speed,
      serverTime: vehicle.serverTime ?? current.serverTime,
      deviceTime: vehicle.deviceTime ?? current.deviceTime,
      updatedAt: vehicle.updatedAt ?? current.updatedAt,
      motionState: hasField(const ['motionState', 'motion_state'])
          ? vehicle.motionState
          : current.motionState,
      motionStateSince:
          hasField(const ['motionStateSince', 'motion_state_since'])
          ? vehicle.motionStateSince
          : current.motionStateSince,
      pendingMotionState:
          hasField(const [
            'pendingMotionState',
            'pendingMotionStateSince',
            'pendingStopSince',
          ])
          ? vehicle.pendingMotionState
          : current.pendingMotionState,
      pendingMotionStateSince:
          hasField(const [
            'pendingMotionState',
            'pendingMotionStateSince',
            'pendingStopSince',
          ])
          ? vehicle.pendingMotionStateSince
          : current.pendingMotionStateSince,
    );
    // These indexes are private and never published. Mutating one entry
    // avoids copying the entire fleet for every packet in a coalesced batch.
    return _upsertVehicle(
      _vehiclesByKey,
      _vehicleKeyByAlias,
      vehicle,
      aliases: aliases,
      allowCreate: false,
    );
  }

  bool _applyDeviceStatusUpdate(dynamic data) {
    final aliases = _identityAliasesForPayload(data);
    if (aliases.isEmpty) {
      return false;
    }

    final storageKey = _resolveStorageKey(
      _vehiclesByKey,
      _vehicleKeyByAlias,
      aliases: aliases,
      allowCreate: false,
    );
    if (storageKey == null) {
      return false;
    }

    final current = _vehiclesByKey[storageKey];
    if (current == null) {
      return false;
    }

    final source = _asMap(data);
    final connectionStatus = _firstString(source, const [
      'status',
      'deviceStatus',
      'device_status',
      'connectionStatus',
      'connection_status',
      'state',
    ]);
    final lastSeenAt = _firstDate(source, const [
      'lastSeenAt',
      'last_seen_at',
      'lastSeen',
      'last_seen',
    ]);
    final deviceStatusUpdatedAt = _firstDate(source, const [
      'updatedAt',
      'updated_at',
      'timestamp',
      'serverTime',
      'server_time',
    ]);
    final previousDeviceStatusTime = _deviceStatusTimes[storageKey];
    if (deviceStatusUpdatedAt != null &&
        previousDeviceStatusTime != null &&
        deviceStatusUpdatedAt.isBefore(previousDeviceStatusTime)) {
      return false;
    }
    if (deviceStatusUpdatedAt != null) {
      _deviceStatusTimes[storageKey] = deviceStatusUpdatedAt;
    }
    final resolvedLastSeenAt =
        current.lastSeenAt != null &&
            lastSeenAt != null &&
            lastSeenAt.isBefore(current.lastSeenAt!)
        ? current.lastSeenAt
        : lastSeenAt ?? current.lastSeenAt;
    Object? motionValue(String key, Object? previous) =>
        source.containsKey(key) ? source[key]?.toString() : previous;
    Object? motionDate(String key, DateTime? previous) =>
        source.containsKey(key) ? _asDateTime(source[key]) : previous;
    final updatedVehicle = current.copyWith(
      deviceConnectionStatus:
          connectionStatus ?? current.deviceConnectionStatus,
      lastSeenAt: resolvedLastSeenAt,
      motionState: motionValue('motionState', current.motionState),
      motionStateSince: motionDate(
        'motionStateSince',
        current.motionStateSince,
      ),
      pendingMotionState: motionValue(
        'pendingMotionState',
        current.pendingMotionState,
      ),
      pendingMotionStateSince: motionDate(
        'pendingMotionStateSince',
        current.pendingMotionStateSince,
      ),
    );
    if (_isSameVehicleSnapshot(current, updatedVehicle)) return false;

    _vehiclesByKey[storageKey] = updatedVehicle;
    for (final alias in _identityAliasesForVehicle(updatedVehicle)) {
      _vehicleKeyByAlias[alias] = storageKey;
    }
    return true;
  }

  void _handleNotificationsConnected() {
    if (!mounted) {
      return;
    }

    state = state.copyWith(isNotificationsConnected: true, errorMessage: null);

    _lastSentNotificationSubscriptionHash = null;
    _sendNotificationSubscriptionIfNeeded();
  }

  void _handleNotificationsDisconnected(dynamic _) {
    if (!mounted) {
      return;
    }

    _lastSentNotificationSubscriptionHash = null;
    state = state.copyWith(isNotificationsConnected: false);
  }

  void _handleNotificationsSocketError(dynamic error) {
    if (!mounted) {
      return;
    }
    _lastSentNotificationSubscriptionHash = null;
    state = state.copyWith(
      isNotificationsConnected: false,
      errorMessage: _formatError(error),
    );
  }

  void _handleNotificationNew(dynamic payload) {
    if (!mounted) {
      return;
    }

    final notification = _mapEventsService.parseMapEventPayload(payload);
    if (notification == null) {
      return;
    }

    final alerts = _mergeAlerts(
      current: state.alerts,
      incoming: <AppNotification>[notification],
    );
    if (identical(alerts, state.alerts)) {
      return;
    }

    state = state.copyWith(alerts: alerts, isAlertsLoading: false);
  }

  // -------------------------------------------------------------------------
  // Role-aware subscription wiring
  // -------------------------------------------------------------------------

  void _rebuildBaselineImeis() {
    final imeis = <String>{};
    for (final vehicle in _vehiclesByKey.values) {
      final imei = vehicle.imei.trim();
      if (imei.isNotEmpty) {
        imeis.add(imei);
      }
    }
    final sorted = imeis.toList()..sort();
    _baselineImeis = List<String>.unmodifiable(sorted);
  }

  void _sendTelemetrySubscriptionIfNeeded() {
    final connection = _telemetryConnection;
    if (connection == null || !connection.isConnected) {
      return;
    }
    if (!_hasTelemetryBaseline) {
      return;
    }

    switch (_config.telemetrySubscribeMode) {
      case LiveMapTelemetrySubscribeMode.superadminScope:
        const hash = 'scope:superadmin:snapshot:false';
        if (hash == _lastSentTelemetrySubscriptionHash) {
          return;
        }
        connection.emit('telemetry:subscribe', const <String, dynamic>{
          'scope': _superadminScope,
          'snapshot': false,
        });
        _lastSentTelemetrySubscriptionHash = hash;
        return;
      case LiveMapTelemetrySubscribeMode.imeis:
        final hash = 'imeis:${_baselineImeis.join(',')}';
        if (hash == _lastSentTelemetrySubscriptionHash) {
          return;
        }
        for (
          var offset = 0;
          offset < _baselineImeis.length;
          offset += _maxImeisPerSocketSubscription
        ) {
          final end = math.min(
            offset + _maxImeisPerSocketSubscription,
            _baselineImeis.length,
          );
          connection.emit('telemetry:subscribe', <String, dynamic>{
            'imeis': _baselineImeis.sublist(offset, end),
            // REST already supplied the current snapshot. Requesting a
            // socket copy multiplies memory/network cost on large fleets.
            'snapshot': false,
            'delivery': 'batch',
          });
        }
        _lastSentTelemetrySubscriptionHash = hash;
        return;
      case LiveMapTelemetrySubscribeMode.demoScope:
        const hash = 'scope:demo';
        if (hash == _lastSentTelemetrySubscriptionHash) {
          return;
        }
        connection.emit('telemetry:subscribe', const <String, dynamic>{
          'scope': _demoScope,
        });
        _lastSentTelemetrySubscriptionHash = hash;
    }
  }

  void _sendNotificationSubscriptionIfNeeded() {
    final connection = _notificationsConnection;
    if (connection == null || !connection.isConnected) {
      return;
    }

    switch (_config.notificationSubscribeMode) {
      case LiveMapNotificationSubscribeMode.superadminScope:
        const hash = 'scope:superadmin';
        if (hash == _lastSentNotificationSubscriptionHash) {
          return;
        }
        connection.emit('notif:subscribe', const <String, dynamic>{
          'scope': _superadminScope,
        });
        _lastSentNotificationSubscriptionHash = hash;
        return;
      case LiveMapNotificationSubscribeMode.imeis:
        if (!_hasTelemetryBaseline) {
          // Wait until baseline is ready so we send the IMEI list once,
          // matching the role spec.
          return;
        }
        final hash = 'imeis:${_baselineImeis.join(',')}';
        if (hash == _lastSentNotificationSubscriptionHash) {
          return;
        }
        for (
          var offset = 0;
          offset < _baselineImeis.length;
          offset += _maxImeisPerSocketSubscription
        ) {
          final end = math.min(
            offset + _maxImeisPerSocketSubscription,
            _baselineImeis.length,
          );
          connection.emit('notif:subscribe', <String, dynamic>{
            'imeis': _baselineImeis.sublist(offset, end),
          });
        }
        _lastSentNotificationSubscriptionHash = hash;
        return;
      case LiveMapNotificationSubscribeMode.disabled:
        return;
    }
  }

  // -------------------------------------------------------------------------
  // Alert merge / dedupe (preserved from working Superadmin controller)
  // -------------------------------------------------------------------------

  List<AppNotification> _mergeAlerts({
    required List<AppNotification> current,
    required Iterable<AppNotification> incoming,
  }) {
    final merged = <AppNotification>[];
    final seenKeys = <String>{};
    var didChange = false;

    void addNotification(AppNotification notification, {required bool isNew}) {
      final keys = _alertDedupeKeys(notification);
      if (keys.any(seenKeys.contains)) {
        return;
      }

      seenKeys.addAll(keys);
      merged.add(notification);
      if (isNew) {
        didChange = true;
      }
    }

    for (final notification in current) {
      addNotification(notification, isNew: false);
    }

    for (final notification in incoming) {
      addNotification(notification, isNew: true);
    }

    merged.sort(_compareAlertsNewestFirst);
    if (merged.length > _maxAlerts) {
      merged.removeRange(_maxAlerts, merged.length);
      didChange = true;
    }

    if (!didChange && merged.length == current.length) {
      return current;
    }

    return List<AppNotification>.unmodifiable(merged);
  }

  List<String> _alertDedupeKeys(AppNotification notification) {
    final keys = <String>[];
    final seen = <String>{};

    void add(String prefix, Object? value) {
      final text = value?.toString().trim() ?? '';
      if (text.isEmpty) {
        return;
      }

      final key = '$prefix:${text.toLowerCase()}';
      if (seen.add(key)) {
        keys.add(key);
      }
    }

    if (notification.id > 0) {
      add('id', notification.id);
    }
    if (notification.eventId != null && notification.eventId! > 0) {
      add('event', notification.eventId);
    }
    if (notification.readId != null && notification.readId! > 0) {
      add('read', notification.readId);
    }
    if (notification.logId != null && notification.logId! > 0) {
      add('log', notification.logId);
    }
    add('dedupe', notification.dedupeKey);

    if (keys.isEmpty) {
      add(
        'fallback',
        [
          notification.title.trim(),
          notification.message.trim(),
          notification.createdAt?.toUtc().toIso8601String() ?? '',
          notification.contextLabel?.trim() ?? '',
        ].join('|'),
      );
    }

    return keys;
  }

  int _compareAlertsNewestFirst(AppNotification left, AppNotification right) {
    final leftCreatedAt = left.createdAt;
    final rightCreatedAt = right.createdAt;
    if (leftCreatedAt != null && rightCreatedAt != null) {
      final createdAtCompare = rightCreatedAt.compareTo(leftCreatedAt);
      if (createdAtCompare != 0) {
        return createdAtCompare;
      }
    } else if (leftCreatedAt != null) {
      return -1;
    } else if (rightCreatedAt != null) {
      return 1;
    }

    return right.id.compareTo(left.id);
  }

  // -------------------------------------------------------------------------
  // Vehicle baseline + merge (preserved from working Superadmin controller)
  // -------------------------------------------------------------------------

  void _replaceBaselineVehicles(Iterable<VehicleSummary> vehicles) {
    final updatedVehicles = <String, VehicleSummary>{};
    final updatedAliases = <String, String>{};
    for (final vehicle in vehicles) {
      _upsertVehicle(
        updatedVehicles,
        updatedAliases,
        vehicle,
        aliases: _identityAliasesForVehicle(vehicle),
        allowCreate: true,
      );
    }

    _vehiclesByKey = updatedVehicles;
    _vehicleKeyByAlias = updatedAliases;
  }

  bool _upsertVehicle(
    Map<String, VehicleSummary> vehiclesByKey,
    Map<String, String> vehicleKeyByAlias,
    VehicleSummary vehicle, {
    required List<String> aliases,
    required bool allowCreate,
  }) {
    final stableAliases = _normalizeStableIdentityAliases(aliases);
    final storageKey = _resolveStorageKey(
      vehiclesByKey,
      vehicleKeyByAlias,
      aliases: stableAliases,
      allowCreate: allowCreate,
    );
    if (storageKey == null || storageKey.isEmpty) {
      return false;
    }

    final current = vehiclesByKey[storageKey];
    final mergedVehicle = current == null
        ? vehicle
        : _mergeVehicle(current, vehicle);

    if (current != null && _isSameVehicleSnapshot(current, mergedVehicle)) {
      for (final alias in stableAliases) {
        vehicleKeyByAlias[alias] = storageKey;
      }
      return false;
    }

    vehiclesByKey[storageKey] = mergedVehicle;

    for (final alias in stableAliases) {
      vehicleKeyByAlias[alias] = storageKey;
    }

    for (final alias in _identityAliasesForVehicle(mergedVehicle)) {
      vehicleKeyByAlias[alias] = storageKey;
    }

    return true;
  }

  String? _resolveStorageKey(
    Map<String, VehicleSummary> vehiclesByKey,
    Map<String, String> vehicleKeyByAlias, {
    required List<String> aliases,
    required bool allowCreate,
  }) {
    final stableAliases = _normalizeStableIdentityAliases(aliases);
    for (final alias in stableAliases) {
      final existingKey = vehicleKeyByAlias[alias];
      if (existingKey != null && vehiclesByKey.containsKey(existingKey)) {
        return existingKey;
      }
    }

    if (!allowCreate || stableAliases.isEmpty) {
      return null;
    }

    return stableAliases.first;
  }

  VehicleSummary _mergeVehicle(
    VehicleSummary current,
    VehicleSummary incoming,
  ) {
    if (current.licenseBlocked) return current;
    final currentTime = liveVehicleReceiveTime(current);
    final incomingTime = liveVehicleReceiveTime(incoming);
    if (currentTime != null &&
        incomingTime != null &&
        incomingTime.isBefore(currentTime)) {
      return current;
    }
    final useIncomingLocation = _shouldUseIncomingLocation(current, incoming);
    final today = current.withTodayDistanceFrom(incoming, now: _now());
    return current.copyWith(
      id: current.id.isNotEmpty ? current.id : incoming.id,
      imei: incoming.imei.isNotEmpty ? incoming.imei : current.imei,
      name: incoming.name.trim().isEmpty ? current.name : incoming.name,
      plateNumber: incoming.plateNumber.isNotEmpty
          ? incoming.plateNumber
          : current.plateNumber,
      deviceTypeId: incoming.deviceTypeId ?? current.deviceTypeId,
      vehicleTypeSlug: current.vehicleTypeSlug ?? incoming.vehicleTypeSlug,
      status: incoming.status == 'unknown' ? current.status : incoming.status,
      speed: incoming.speed,
      latitude: useIncomingLocation ? incoming.latitude : current.latitude,
      longitude: useIncomingLocation ? incoming.longitude : current.longitude,
      hasValidLocation: useIncomingLocation
          ? incoming.hasValidLocation
          : current.hasValidLocation,
      // Never fabricate a timestamp to animate a location. A stationary
      // packet must update its receive/device times and speed immediately.
      updatedAt: incoming.updatedAt ?? current.updatedAt,
      serverTime: incoming.serverTime ?? current.serverTime,
      deviceTime: incoming.deviceTime ?? current.deviceTime,
      distanceKm: today.distanceKm,
      browserDayKey: today.browserDayKey,
      browserDayStart: today.browserDayStart,
      browserDayBaseOdometer: today.browserDayBaseOdometer,
      odometerKm: today.odometerKm,
      engineHoursToday: incoming.engineHoursToday ?? current.engineHoursToday,
      engineHours: incoming.engineHours ?? current.engineHours,
      totalEngineHours: incoming.totalEngineHours ?? current.totalEngineHours,
      satellites: incoming.satellites ?? current.satellites,
      headingDegrees: incoming.headingDegrees ?? current.headingDegrees,
      ignition: incoming.ignition ?? current.ignition,
      acc: incoming.acc ?? current.acc,
      deviceConnectionStatus:
          incoming.deviceConnectionStatus ?? current.deviceConnectionStatus,
      lastSeenAt:
          current.lastSeenAt != null &&
              incoming.lastSeenAt != null &&
              incoming.lastSeenAt!.isBefore(current.lastSeenAt!)
          ? current.lastSeenAt
          : incoming.lastSeenAt ?? current.lastSeenAt,
      motionState: incoming.motionState,
      motionStateSince: incoming.motionStateSince,
      pendingMotionState: incoming.pendingMotionState,
      pendingMotionStateSince: incoming.pendingMotionStateSince,
    );
  }

  bool _shouldUseIncomingLocation(
    VehicleSummary current,
    VehicleSummary incoming,
  ) {
    if (!incoming.hasValidLocation) {
      return false;
    }

    if (!current.hasValidLocation) {
      return true;
    }

    final distanceMeters = _coordinateDistanceMeters(
      fromLatitude: current.latitude,
      fromLongitude: current.longitude,
      toLatitude: incoming.latitude,
      toLongitude: incoming.longitude,
    );

    if (distanceMeters < _minCoordinateMoveMeters) {
      return false;
    }

    if (incoming.speed < _stationaryDriftSpeedKph &&
        distanceMeters < _stationaryDriftDistanceMeters) {
      return false;
    }

    final currentTime = liveVehicleReceiveTime(current);
    final incomingTime = liveVehicleReceiveTime(incoming);
    if (currentTime != null && incomingTime != null) {
      if (incomingTime.isBefore(currentTime)) {
        return false;
      }

      final elapsedSeconds = incomingTime.difference(currentTime).inSeconds;
      if (elapsedSeconds >= 2) {
        final impliedSpeedKph = (distanceMeters / elapsedSeconds) * 3.6;
        if (impliedSpeedKph > _maxPlausibleImpliedSpeedKph) {
          return false;
        }
      }
    }

    return true;
  }

  bool _isSameVehicleSnapshot(VehicleSummary left, VehicleSummary right) {
    return left.id == right.id &&
        left.imei == right.imei &&
        left.name == right.name &&
        left.plateNumber == right.plateNumber &&
        left.status == right.status &&
        left.speed == right.speed &&
        left.latitude == right.latitude &&
        left.longitude == right.longitude &&
        left.hasValidLocation == right.hasValidLocation &&
        left.updatedAt == right.updatedAt &&
        left.distanceKm == right.distanceKm &&
        left.browserDayKey == right.browserDayKey &&
        left.browserDayStart == right.browserDayStart &&
        left.browserDayBaseOdometer == right.browserDayBaseOdometer &&
        left.odometerKm == right.odometerKm &&
        left.engineHoursToday == right.engineHoursToday &&
        left.engineHours == right.engineHours &&
        left.totalEngineHours == right.totalEngineHours &&
        left.satellites == right.satellites &&
        left.headingDegrees == right.headingDegrees &&
        left.ignition == right.ignition &&
        left.acc == right.acc &&
        left.deviceConnectionStatus == right.deviceConnectionStatus &&
        left.lastSeenAt == right.lastSeenAt &&
        left.serverTime == right.serverTime &&
        left.deviceTime == right.deviceTime &&
        left.motionState == right.motionState &&
        left.motionStateSince == right.motionStateSince &&
        left.pendingMotionState == right.pendingMotionState &&
        left.pendingMotionStateSince == right.pendingMotionStateSince &&
        left.licenseBlocked == right.licenseBlocked &&
        left.vehicleTypeSlug == right.vehicleTypeSlug &&
        left.deviceTypeId == right.deviceTypeId;
  }

  List<String> _identityAliasesForPayload(
    dynamic raw, {
    VehicleSummary? fallbackVehicle,
  }) {
    return _normalizeStableIdentityAliases(
      _vehicleService.resolveVehicleIdentityAliases(
        raw,
        fallbackVehicle: fallbackVehicle,
      ),
    );
  }

  List<String> _identityAliasesForVehicle(VehicleSummary vehicle) {
    return _normalizeStableIdentityAliases(
      _vehicleService.resolveVehicleIdentityAliasesForVehicle(vehicle),
    );
  }

  List<String> _normalizeStableIdentityAliases(List<String> aliases) {
    final imeiAliases = <String>[];
    final idAliases = <String>[];
    final seen = <String>{};

    void addAlias(List<String> target, String prefix, String value) {
      final normalizedValue = value.trim().toLowerCase();
      if (normalizedValue.isEmpty) {
        return;
      }

      final alias = '$prefix:$normalizedValue';
      if (seen.add(alias)) {
        target.add(alias);
      }
    }

    for (final alias in aliases) {
      final separatorIndex = alias.indexOf(':');
      if (separatorIndex <= 0 || separatorIndex == alias.length - 1) {
        continue;
      }

      final prefix = alias.substring(0, separatorIndex).trim().toLowerCase();
      final value = alias.substring(separatorIndex + 1);
      if (prefix == 'imei') {
        addAlias(imeiAliases, prefix, value);
      } else if (prefix == 'id') {
        addAlias(idAliases, prefix, value);
      }
    }

    return <String>[...imeiAliases, ...idAliases];
  }

  void _publishMergedTelemetry({bool onlyIfChanged = false}) {
    final now = _now();
    final vehicles = <VehicleSummary>[];
    for (final entry in _vehiclesByKey.entries) {
      final today = entry.value.withTodayDistanceFrom(entry.value, now: now);
      final status = classifyLiveVehicle(today, now: now).name;
      final vehicle = today.status == status
          ? today
          : today.copyWith(status: status);
      // Reuse unchanged immutable vehicle objects on maintenance ticks.
      _vehiclesByKey[entry.key] = vehicle;
      vehicles.add(vehicle);
    }
    final running = vehicles
        .where((vehicle) => vehicle.status == 'running')
        .length;
    final inactive = vehicles
        .where((vehicle) => vehicle.status == 'inactive')
        .length;
    final telemetry = LiveMapTelemetry(
      allCount: vehicles.length,
      runningCount: running,
      stopCount: vehicles.length - running - inactive,
      inactiveCount: inactive,
      vehicles: vehicles,
    );
    if (onlyIfChanged &&
        telemetry.allCount == state.telemetry.allCount &&
        telemetry.runningCount == state.telemetry.runningCount &&
        telemetry.stopCount == state.telemetry.stopCount &&
        telemetry.inactiveCount == state.telemetry.inactiveCount &&
        telemetry.vehicles.length == state.telemetry.vehicles.length &&
        Iterable<int>.generate(telemetry.vehicles.length).every(
          (index) => _isSameVehicleSnapshot(
            telemetry.vehicles[index],
            state.telemetry.vehicles[index],
          ),
        )) {
      return;
    }
    _publishTelemetry(telemetry);
  }

  void _scheduleMergedTelemetryPublish() {
    if (!mounted) {
      return;
    }

    _hasPendingTelemetryPublish = true;
    if (_liveTelemetryPublishTimer?.isActive ?? false) {
      return;
    }

    _liveTelemetryPublishTimer = Timer(
      _liveUpdateBatchWindow,
      _flushPendingTelemetryPublish,
    );
  }

  void _flushPendingTelemetryPublish() {
    _liveTelemetryPublishTimer = null;
    if (!mounted || !_hasPendingTelemetryPublish) {
      return;
    }

    _hasPendingTelemetryPublish = false;
    _publishMergedTelemetry();
  }

  void _publishTelemetry(LiveMapTelemetry telemetry) {
    if (!mounted) {
      return;
    }

    state = state.copyWith(
      telemetry: telemetry,
      isInitialLoading: false,
      errorMessage: null,
    );
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }

    return const <String, dynamic>{};
  }

  String? _firstString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value == null) {
        continue;
      }

      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  DateTime? _firstDate(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final parsed = _asDateTime(source[key]);
      if (parsed != null) {
        return parsed;
      }
    }

    return null;
  }

  DateTime? _asDateTime(Object? value) {
    if (value is DateTime) {
      return value;
    }

    if (value is num) {
      return _dateFromEpoch(value);
    }

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }

      final parsed = DateTime.tryParse(trimmed);
      if (parsed != null) {
        return parsed;
      }

      final numeric = num.tryParse(trimmed);
      if (numeric != null) {
        return _dateFromEpoch(numeric);
      }
    }

    return null;
  }

  DateTime _dateFromEpoch(num value) {
    final raw = value.toInt();
    final milliseconds = raw.abs() < 100000000000 ? raw * 1000 : raw;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }

  double _coordinateDistanceMeters({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    const earthRadiusMeters = 6371000.0;
    final deltaLatitude = _degreesToRadians(toLatitude - fromLatitude);
    final deltaLongitude = _degreesToRadians(toLongitude - fromLongitude);
    final startLatitudeRadians = _degreesToRadians(fromLatitude);
    final endLatitudeRadians = _degreesToRadians(toLatitude);
    final haversine =
        math.pow(math.sin(deltaLatitude / 2), 2) +
        math.cos(startLatitudeRadians) *
            math.cos(endLatitudeRadians) *
            math.pow(math.sin(deltaLongitude / 2), 2);
    final arc =
        2 *
        math.atan2(
          math.sqrt(haversine.toDouble()),
          math.sqrt(1 - haversine.toDouble()),
        );
    return earthRadiusMeters * arc;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  String _localDayKey(DateTime instant) {
    final local = instant.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  String _formatError(Object? error) {
    final message = error?.toString().trim() ?? '';
    if (message.isEmpty) {
      return 'Unable to load live map data right now.';
    }

    return message;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _maintenanceTimer?.cancel();
    _liveTelemetryPublishTimer?.cancel();
    _telemetryConnection?.disconnect();
    _notificationsConnection?.disconnect();
    super.dispose();
  }
}
