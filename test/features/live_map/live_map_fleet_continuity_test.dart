import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/socket/socket_service.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/live_map/controllers/live_map_controller.dart';
import 'package:open_vts/features/live_map/models/live_map_role_config.dart';
import 'package:open_vts/features/live_map/services/live_map_events_service.dart';
import 'package:open_vts/features/live_map/services/live_map_vehicle_service.dart';
import 'package:open_vts/features/notifications/models/notification_page.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false'));

  for (final config in [
    LiveMapRoleConfig.superadmin(),
    LiveMapRoleConfig.admin(), // Team uses the same authorized Admin endpoints.
    LiveMapRoleConfig.user(), // Subuser uses its authorized User endpoints.
  ]) {
    test(
      '${config.role.name}: loads all 220 vehicles over all cursor pages',
      () async {
        final requests = <RequestOptions>[];
        final clock = DateTime.now().toUtc();
        final service = LiveMapVehicleService(
          apiClient: ApiClient(
            _dio((request) {
              requests.add(request);
              final start =
                  int.tryParse('${request.queryParameters['cursor']}') ?? 0;
              final end = (start + 100).clamp(0, 220);
              return {
                'items': List.generate(
                  end - start,
                  (i) => _record(
                    '${start + i + 1}',
                    clock,
                    speed: (start + i) < 110 ? 32 : 0,
                    inactive: (start + i) >= 165,
                  ),
                ),
                'hasMore': end < 220,
                'nextCursor': end < 220 ? '$end' : null,
              };
            }),
          ),
          config: config,
        );
        final result = await service.getMapTelemetry(
          refreshKey: 'same-snapshot',
        );
        expect(result.vehicles, hasLength(220));
        expect(result.allCount, 220);
        expect(result.runningCount, 110);
        expect(result.stopCount, 55);
        expect(result.inactiveCount, 55);
        expect(requests, hasLength(3));
        expect(requests.map((r) => r.queryParameters['cursor']), [
          null,
          '100',
          '200',
        ]);
        expect(
          requests.every((r) => r.queryParameters['limit'] == 500),
          isTrue,
        );
        expect(
          requests.map((r) => r.queryParameters['dayStart']).toSet(),
          hasLength(1),
        );
        expect(requests.map((r) => r.queryParameters['rk']).toSet(), {
          'same-snapshot',
        });
        expect(
          requests.every(
            (r) => r.uri.path == '/api${config.mapTelemetryEndpoint}',
          ),
          isTrue,
        );
      },
    );
  }

  test(
    'legacy array response remains supported and deduplicates row identities',
    () async {
      final clock = DateTime.now().toUtc();
      final service = LiveMapVehicleService(
        apiClient: ApiClient(
          _dio(
            (_) => [
              _record('1', clock),
              _record('1', clock),
              _record('2', clock),
            ],
          ),
        ),
        config: LiveMapRoleConfig.user(),
      );
      expect((await service.getMapTelemetry()).allCount, 2);
    },
  );

  test('later page failure never returns a silently truncated fleet', () async {
    var calls = 0;
    final service = LiveMapVehicleService(
      apiClient: ApiClient(
        _dio((request) {
          calls++;
          if (calls > 1) throw StateError('network interrupted');
          return {
            'items': [_record('1', DateTime.now().toUtc())],
            'hasMore': true,
            'nextCursor': '1',
          };
        }),
      ),
      config: LiveMapRoleConfig.superadmin(),
    );
    await expectLater(service.getMapTelemetry(), throwsA(isA<DioException>()));
    expect(calls, 2);
  });

  test(
    'account switch during pagination aborts before requesting another page',
    () async {
      var user = const CurrentUser(
        id: 'first',
        name: 'First',
        email: '',
        role: UserRole.user,
      );
      var calls = 0;
      final service = LiveMapVehicleService(
        apiClient: ApiClient(
          _dio((_) {
            calls++;
            user = const CurrentUser(
              id: 'second',
              name: 'Second',
              email: '',
              role: UserRole.user,
            );
            return {
              'items': [_record('1', DateTime.now().toUtc())],
              'hasMore': true,
              'nextCursor': '1',
            };
          }),
          activeUser: () => user,
        ),
        config: LiveMapRoleConfig.user(),
      );
      await expectLater(service.getMapTelemetry(), throwsStateError);
      expect(calls, 1);
    },
  );

  test(
    'hasMore without a cursor fails rather than hiding remaining vehicles',
    () async {
      final service = LiveMapVehicleService(
        apiClient: ApiClient(
          _dio(
            (_) => {
              'items': [_record('1', DateTime.now().toUtc())],
              'hasMore': true,
            },
          ),
        ),
        config: LiveMapRoleConfig.admin(),
      );
      await expectLater(service.getMapTelemetry(), throwsStateError);
    },
  );

  for (final config in [
    LiveMapRoleConfig.superadmin(),
    LiveMapRoleConfig.admin(),
    LiveMapRoleConfig.user(),
  ]) {
    _testMapWidgets(
      '${config.role.name}: stationary speed zero changes state and times at identical coordinates',
      (tester) async {
        final harness = _Harness(config);
        harness.initialize();
        await _flush(tester);
        harness.socket.telemetry.single.connect();
        final connection = harness.socket.telemetry.single;
        harness.clock = harness.clock.add(const Duration(seconds: 1));
        connection.event('telemetry:update', _packet(harness.clock, speed: 0));
        await _flush(tester);
        final vehicle = harness.controller.state.telemetry.vehicles.single;
        expect(vehicle.speed, 0);
        expect(vehicle.status, 'stop');
        expect(vehicle.latitude, 40.7);
        expect(vehicle.name, 'Vehicle 1');
        expect(vehicle.id, '1');
        expect(vehicle.serverTime, harness.clock);
        expect(harness.controller.state.telemetry.runningCount, 0);
        expect(harness.controller.state.telemetry.stopCount, 1);
        final subscription =
            connection.emits
                    .singleWhere((e) => e.$1 == 'telemetry:subscribe')
                    .$2
                as Map;
        expect(subscription['snapshot'], isFalse);
        if (config.role != LiveMapRole.superadmin) {
          expect(subscription['imeis'], ['imei-1']);
          expect(subscription['delivery'], 'batch');
        }
      },
    );
  }

  _testMapWidgets(
    'large fleet chunks every IMEI and merges a complete batch once',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.admin());
      h.service.rows = List.generate(
        10001,
        (index) => _record('${index + 1}', h.clock),
      );
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      final subscriptions = socket.emits
          .where((event) => event.$1 == 'telemetry:subscribe')
          .map((event) => event.$2 as Map)
          .toList();
      expect(subscriptions, hasLength(3));
      expect(subscriptions.map((event) => (event['imeis'] as List).length), [
        5000,
        5000,
        1,
      ]);
      expect(
        subscriptions.expand((event) => event['imeis'] as List).toSet(),
        hasLength(10001),
      );
      h.clock = h.clock.add(const Duration(seconds: 1));
      socket.event('telemetry:update:batch', {
        'records': List.generate(
          220,
          (index) => {
            ..._packet(h.clock, speed: 0),
            'imei': 'imei-${index + 1}',
          },
        ),
      });
      await _flush(tester);
      expect(h.controller.state.telemetry.allCount, 10001);
      expect(h.controller.state.telemetry.stopCount, 220);
      expect(h.controller.state.telemetry.runningCount, 9781);
    },
  );

  _testMapWidgets(
    'older packet cannot regress speed, status, coordinates, or receive time',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      final original = h.controller.state.telemetry.vehicles.single;
      socket.event('telemetry:update', {
        ..._packet(h.clock.subtract(const Duration(minutes: 1)), speed: 0),
        'latitude': 40.71,
      });
      await _flush(tester);
      final vehicle = h.controller.state.telemetry.vehicles.single;
      expect(vehicle.speed, original.speed);
      expect(vehicle.status, 'running');
      expect(vehicle.latitude, original.latitude);
      expect(vehicle.serverTime, original.serverTime);
    },
  );

  _testMapWidgets(
    'sparse telemetry preserves missing speed, name, ID and existing metrics',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      h.clock = h.clock.add(const Duration(seconds: 1));
      socket.event('telemetry:update', {
        'imei': 'imei-1',
        'serverTime': h.clock.toIso8601String(),
        'ignition': false,
      });
      await _flush(tester);
      final vehicle = h.controller.state.telemetry.vehicles.single;
      expect(vehicle.speed, 32);
      expect(vehicle.name, 'Vehicle 1');
      expect(vehicle.id, '1');
      expect(vehicle.ignition, isFalse);
      expect(vehicle.latitude, 40.7);
      expect(vehicle.status, 'running');
    },
  );

  _testMapWidgets(
    'reconnect resubscribes and catches updates missed during outage',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.admin());
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      socket.drop();
      h.clock = h.clock.add(const Duration(seconds: 3));
      h.service.rows = [_record('1', h.clock, speed: 0)];
      socket.connect();
      await _flush(tester);
      expect(h.service.calls, 2);
      expect(
        socket.emits.where((e) => e.$1 == 'telemetry:subscribe'),
        hasLength(2),
      );
      expect(h.controller.state.telemetry.stopCount, 1);
    },
  );

  _testMapWidgets(
    'resume recovers disconnected snapshot and does not poll while backgrounded',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      h.controller.didChangeAppLifecycleState(AppLifecycleState.paused);
      h.clock = h.clock.add(const Duration(minutes: 2));
      await tester.pump(const Duration(seconds: 35));
      expect(h.service.calls, 1);
      h.service.rows = [_record('1', h.clock, speed: 0)];
      h.controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await _flush(tester);
      expect(h.service.calls, 2);
      expect(h.controller.state.telemetry.stopCount, 1);
    },
  );

  _testMapWidgets(
    'silent running telemetry ages into stop without another packet',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      h.clock = h.clock.add(const Duration(minutes: 2));
      await tester.pump(const Duration(seconds: 5));
      await _flush(tester);
      expect(h.controller.state.telemetry.runningCount, 0);
      expect(h.controller.state.telemetry.stopCount, 1);
    },
  );

  _testMapWidgets(
    'device heartbeat cannot resurrect stale motion or rewind receive time',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      final receiveTime = h.clock;
      h.clock = h.clock.add(const Duration(minutes: 3));
      socket.event('devicestatus:update', {
        'imei': 'imei-1',
        'status': 'CONNECTED',
        'lastSeenAt': h.clock.toIso8601String(),
        'updatedAt': h.clock.toIso8601String(),
      });
      await _flush(tester);
      expect(
        h.controller.state.telemetry.vehicles.single.serverTime,
        receiveTime,
      );
      expect(h.controller.state.telemetry.stopCount, 1);
    },
  );

  _testMapWidgets(
    'pending stop expires without packets and old motion events are ignored',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      socket.event('telemetry:update', _packet(h.clock, speed: 0));
      socket.event('devicestatus:update', {
        'imei': 'imei-1',
        'motionState': 'running',
        'pendingMotionState': 'stop',
        'pendingMotionStateSince': h.clock.toIso8601String(),
        'updatedAt': h.clock.toIso8601String(),
      });
      await _flush(tester);
      expect(h.controller.state.telemetry.runningCount, 1);
      h.service.rows = [_record('1', h.clock, speed: 0)];
      h.clock = h.clock.add(const Duration(seconds: 31));
      await tester.pump(const Duration(seconds: 5));
      expect(h.controller.state.telemetry.stopCount, 1);
      socket.event('devicestatus:update', {
        'imei': 'imei-1',
        'motionState': 'running',
        'pendingMotionState': 'stop',
        'pendingMotionStateSince': h.clock.toIso8601String(),
        'updatedAt': h.clock
            .subtract(const Duration(minutes: 1))
            .toIso8601String(),
      });
      await _flush(tester);
      expect(h.controller.state.telemetry.stopCount, 1);
    },
  );

  _testMapWidgets(
    'a refresh preserves newer in-flight socket data and applies scoped membership',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      final socket = h.socket.telemetry.single..connect();
      final request = Completer<LiveMapTelemetry>();
      h.service.pending = request;
      final refresh = h.controller.refreshTelemetry();
      final oldClock = h.clock;
      h.clock = h.clock.add(const Duration(seconds: 2));
      socket.event('telemetry:update', _packet(h.clock, speed: 0));
      request.complete(
        h.service.parseMapTelemetryPayload([
          _record('1', oldClock, speed: 32),
          _record('2', oldClock, speed: 32),
        ]),
      );
      await refresh;
      await _flush(tester);
      expect(h.controller.state.telemetry.allCount, 2);
      expect(
        h.controller.state.telemetry.vehicles
            .firstWhere((v) => v.id == '1')
            .speed,
        0,
      );
      h.service.pending = null;
      h.service.rows = [_record('2', h.clock, speed: 32)];
      await h.controller.refreshTelemetry();
      await _flush(tester);
      expect(h.controller.state.telemetry.vehicles.map((v) => v.id), ['2']);
      expect(socket.disconnected, isTrue);
      socket.event('telemetry:update', _packet(h.clock, speed: 99));
      await _flush(tester);
      expect(h.controller.state.telemetry.vehicles.map((v) => v.id), ['2']);
    },
  );

  _testMapWidgets(
    'initial offline load retries and closed socket is replaced without stale callbacks',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.service.fail = true;
      h.initialize();
      await _flush(tester);
      expect(h.controller.state.telemetry.allCount, 0);
      expect(h.socket.telemetry, isEmpty);
      h.service.fail = false;
      h.clock = h.clock.add(const Duration(seconds: 31));
      await tester.pump(const Duration(seconds: 5));
      await _flush(tester);
      expect(h.controller.state.telemetry.allCount, 1);
      final old = h.socket.telemetry.single..connect();
      old.drop();
      h.clock = h.clock.add(const Duration(seconds: 31));
      await tester.pump(const Duration(seconds: 5));
      await _flush(tester);
      expect(old.disconnected, isTrue);
      expect(h.socket.telemetry, hasLength(2));
      h.socket.telemetry.last.connect();
      old.event(
        'telemetry:update',
        _packet(h.clock.add(const Duration(seconds: 2)), speed: 0),
      );
      old.drop();
      await _flush(tester);
      expect(h.controller.state.isTelemetryConnected, isTrue);
      expect(h.controller.state.telemetry.vehicles.single.speed, 32);
    },
  );

  _testMapWidgets(
    'failed refresh retains the complete previous baseline and disposed request cannot publish',
    (tester) async {
      final h = _Harness(LiveMapRoleConfig.user());
      h.initialize();
      await _flush(tester);
      h.service.fail = true;
      await h.controller.refreshTelemetry();
      expect(h.controller.state.telemetry.allCount, 1);
      expect(h.controller.state.errorMessage, contains('offline'));
      h.service.fail = false;
      final pending = Completer<LiveMapTelemetry>();
      h.service.pending = pending;
      final refresh = h.controller.refreshTelemetry();
      h.controller.dispose();
      pending.complete(
        h.service.parseMapTelemetryPayload([_record('2', h.clock)]),
      );
      await refresh;
      expect(h.socket.telemetry.single.disconnected, isTrue);
    },
  );
}

Map<String, dynamic> _record(
  String id,
  DateTime clock, {
  double speed = 32,
  bool inactive = false,
}) => {
  'vehicleId': id,
  'vehicleName': 'Vehicle $id',
  'imei': 'imei-$id',
  'status': inactive ? 'inactive' : 'running',
  'telemetry': inactive
      ? null
      : {
          'imei': 'imei-$id',
          'serverTime': clock.toIso8601String(),
          'deviceTime': clock
              .subtract(const Duration(seconds: 10))
              .toIso8601String(),
          'latitude': 40.7,
          'longitude': -74.0,
          'speedKph': speed,
          'ignition': true,
        },
};
Map<String, dynamic> _packet(DateTime clock, {double speed = 32}) => {
  'imei': 'imei-1',
  'serverTime': clock.toIso8601String(),
  'deviceTime': clock.subtract(const Duration(seconds: 10)).toIso8601String(),
  'latitude': 40.7,
  'longitude': -74.0,
  'speedKph': speed,
};
Dio _dio(dynamic Function(RequestOptions) reply) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        try {
          handler.resolve(
            Response<dynamic>(
              requestOptions: request,
              statusCode: 200,
              data: {'action': true, 'data': reply(request)},
            ),
          );
        } catch (error) {
          handler.reject(DioException(requestOptions: request, error: error));
        }
      },
    ),
  );
  return dio;
}

Future<void> _flush(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 125));
  await tester.pump();
}

class _Harness {
  _Harness(this.config) {
    service = _FleetService(config, [_record('1', clock)]);
    socket = _SocketService();
    controller = LiveMapController(
      vehicleService: service,
      mapEventsService: _EventsService(config),
      socketService: socket,
      config: config,
      now: () => clock,
    );
    _activeControllers.add(controller);
  }
  final LiveMapRoleConfig config;
  DateTime clock = DateTime.now().toUtc();
  late final _FleetService service;
  late final _SocketService socket;
  late final LiveMapController controller;
  void initialize() => controller.initialize();
}

class _FleetService extends LiveMapVehicleService {
  _FleetService(LiveMapRoleConfig config, this.rows)
    : super(apiClient: ApiClient(Dio()), config: config);
  List<dynamic> rows;
  Completer<LiveMapTelemetry>? pending;
  int calls = 0;
  bool fail = false;
  @override
  Future<LiveMapTelemetry> getMapTelemetry({String? refreshKey}) async {
    calls++;
    if (fail) throw StateError('offline');
    if (pending != null) return pending!.future;
    return parseMapTelemetryPayload(rows);
  }
}

class _EventsService extends LiveMapEventsService {
  _EventsService(LiveMapRoleConfig config)
    : super(apiClient: ApiClient(Dio()), config: config);
  @override
  Future<NotificationPage> getMapEvents({
    int limit = 50,
    String? beforeId,
    String? from,
    String? to,
    String? source,
    String? severity,
  }) async => const NotificationPage(items: [], hasMore: false, unreadCount: 0);
}

class _SocketService extends SocketService {
  _SocketService()
    : super(
        TokenStorage(const FlutterSecureStorage()),
        apiBaseUrl: 'https://example.test/api',
      );
  final telemetry = <_Connection>[];
  @override
  Future<SocketConnection> connect(
    String namespace, {
    bool authenticated = true,
  }) async {
    final connection = _Connection();
    if (namespace == '/telemetry') telemetry.add(connection);
    return connection;
  }
}

class _Connection implements SocketConnection {
  final handlers = <String, List<SocketEventHandler>>{};
  final connects = <void Function()>[];
  final disconnects = <SocketEventHandler>[];
  final emits = <(String, dynamic)>[];
  bool disconnected = false;
  @override
  bool isConnected = false;
  @override
  void emit(String name, [dynamic data]) => emits.add((name, data));
  @override
  void on(String name, SocketEventHandler callback) =>
      handlers.putIfAbsent(name, () => []).add(callback);
  @override
  void off(String name, [SocketEventHandler? callback]) {
    if (callback == null) {
      handlers.remove(name);
    } else {
      handlers[name]?.remove(callback);
    }
  }

  @override
  void onConnect(void Function() callback) => connects.add(callback);
  @override
  void onDisconnect(SocketEventHandler callback) => disconnects.add(callback);
  @override
  void onError(SocketEventHandler callback) {}
  @override
  void disconnect() {
    disconnected = true;
    drop();
  }

  void connect() {
    isConnected = true;
    for (final callback in connects) {
      callback();
    }
  }

  void drop() {
    isConnected = false;
    for (final callback in disconnects) {
      callback('disconnect');
    }
  }

  void event(String name, dynamic data) {
    for (final callback in handlers[name] ?? <SocketEventHandler>[]) {
      callback(data);
    }
  }
}

final _activeControllers = <LiveMapController>[];
void _testMapWidgets(String name, Future<void> Function(WidgetTester) body) {
  testWidgets(name, (tester) async {
    try {
      await body(tester);
    } finally {
      for (final controller in _activeControllers) {
        if (controller.mounted) controller.dispose();
      }
      _activeControllers.clear();
      await tester.pump();
    }
  });
}
