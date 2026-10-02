import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/user/controllers/user_report_controller.dart';
import 'package:open_vts/features/user/controllers/user_report_workspace_notifier.dart';
import 'package:open_vts/features/user/models/user_report_model.dart';
import 'package:open_vts/features/user/models/user_report_state.dart';
import 'package:open_vts/features/user/models/user_vehicle_model.dart';
import 'package:open_vts/features/user/services/user_landmark_service.dart';
import 'package:open_vts/features/user/services/user_report_service.dart';
import 'package:open_vts/features/user/services/user_vehicle_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('sensor report workspace', () {
    test('loads sensors once per vehicle change and resets old selection',
        () async {
      final controller = _FakeReportController();
      final notifier = _notifier(controller);
      addTearDown(notifier.dispose);
      await _flush();

      notifier.setSensorFilters(const SensorFilters(sensorIds: ['old']));
      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));
      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));

      expect(controller.sensorCalls, ['vehicle-1']);
      expect(notifier.state.sensorFilters.sensorIds, isEmpty);
      expect(notifier.state.isLoadingSensors, isTrue);

      controller.completeSensors('vehicle-1', [_sensor('sensor-1')]);
      await _flush();
      expect(notifier.state.sensors.single.id, 'sensor-1');
      expect(notifier.state.isLoadingSensors, isFalse);
    });

    test('ignores stale sensor responses after rapid vehicle switching',
        () async {
      final controller = _FakeReportController();
      final notifier = _notifier(controller);
      addTearDown(notifier.dispose);
      await _flush();

      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));
      notifier.setScope(const ReportVehicleScope.single('vehicle-2'));
      controller.completeSensors('vehicle-2', [_sensor('sensor-2')]);
      await _flush();
      controller.completeSensors('vehicle-1', [_sensor('sensor-1')]);
      await _flush();

      expect(notifier.state.scope.vehicleId, 'vehicle-2');
      expect(notifier.state.sensors.map((sensor) => sensor.id), ['sensor-2']);
    });

    test('surfaces sensor-list errors and retries for the same vehicle',
        () async {
      final controller = _FakeReportController();
      final notifier = _notifier(controller);
      addTearDown(notifier.dispose);
      await _flush();

      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));
      controller.failSensors('vehicle-1', StateError('sensor API failed'));
      await _flush();
      expect(notifier.state.sensorLoadError, contains('sensor API failed'));

      final retry = notifier.retrySensorLoad();
      expect(controller.sensorCalls, ['vehicle-1', 'vehicle-1']);
      controller.completeSensors('vehicle-1', []);
      await retry;
      expect(notifier.state.sensorLoadError, isNull);
      expect(notifier.state.sensors, isEmpty);
    });

    test('valid selection generates exact payload and reaches success',
        () async {
      final controller = _FakeReportController();
      final notifier = _notifier(controller);
      addTearDown(notifier.dispose);
      await _flush();

      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));
      controller.completeSensors('vehicle-1', [_sensor('sensor-1')]);
      await _flush();
      notifier.setSensorFilters(const SensorFilters(sensorIds: ['sensor-1']));
      controller.nextReport = _page([
        {'value': 42, 'sensorId': 'sensor-1'}
      ]);

      await notifier.generate();

      expect(controller.generatedVehicleScope,
          {'mode': 'single', 'vehicleId': 'vehicle-1'});
      expect(controller.generatedFilters, {
        'sensorIds': ['sensor-1']
      });
      expect(notifier.state.genStatus, ReportGenStatus.success);
    });

    test('empty and API error responses reach explicit terminal states',
        () async {
      final controller = _FakeReportController();
      final notifier = _notifier(controller);
      addTearDown(notifier.dispose);
      await _flush();

      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));
      controller.completeSensors('vehicle-1', [_sensor('sensor-1')]);
      await _flush();
      notifier.setSensorFilters(const SensorFilters(sensorIds: ['sensor-1']));

      controller.nextReport = _page([]);
      await notifier.generate();
      expect(notifier.state.genStatus, ReportGenStatus.empty);

      controller.generateError = StateError('report API failed');
      await notifier.generate();
      expect(notifier.state.genStatus, ReportGenStatus.error);
      expect(notifier.state.genError, contains('report API failed'));
      expect(notifier.state.scope.vehicleId, 'vehicle-1');
      expect(notifier.state.sensorFilters.sensorIds, ['sensor-1']);
    });

    test('invalid or multiple sensor IDs prevent report requests', () async {
      final controller = _FakeReportController();
      final notifier = _notifier(controller);
      addTearDown(notifier.dispose);
      await _flush();

      notifier.setScope(const ReportVehicleScope.single('vehicle-1'));
      controller.completeSensors('vehicle-1', [_sensor('sensor-1')]);
      await _flush();
      notifier.setSensorFilters(
          const SensorFilters(sensorIds: ['sensor-1', 'sensor-2']));

      await notifier.generate();
      expect(controller.generateCalls, 0);
      expect(notifier.state.validationErrors['sensorSensor'], isNotNull);
    });
  });
}

UserReportWorkspaceNotifier _notifier(_FakeReportController controller) =>
    UserReportWorkspaceNotifier(
      initialKey: UserReportKey.sensor,
      controller: controller,
    );

Future<void> _flush() => Future<void>.delayed(Duration.zero);

UserVehicleSensor _sensor(String id) => UserVehicleSensor.fromJson({
      'id': id,
      'name': id,
      'code': id,
    });

UserReportPage _page(List<Map<String, dynamic>> rows) => UserReportPage(
      rows: rows,
      generatedAt: DateTime.utc(2026, 8, 12),
      hasMore: false,
    );

class _FakeReportController extends UserReportController {
  _FakeReportController()
      : super(
          reportService: UserReportService(ApiClient(Dio())),
          vehicleService: UserVehicleService(ApiClient(Dio())),
          landmarkService: UserLandmarkService(ApiClient(Dio())),
        );

  final List<String> sensorCalls = [];
  final Map<String, List<Completer<UserVehicleSensorPage>>> _sensorRequests =
      {};
  UserReportPage nextReport = _page([]);
  Object? generateError;
  int generateCalls = 0;
  Map<String, dynamic>? generatedVehicleScope;
  Map<String, dynamic>? generatedFilters;

  @override
  Future<UserReportOptions> getOptions() async =>
      const UserReportOptions(vehicles: [], groups: []);

  @override
  Future<UserVehicleSensorPage> getSensors(String vehicleId) {
    sensorCalls.add(vehicleId);
    final completer = Completer<UserVehicleSensorPage>();
    _sensorRequests.putIfAbsent(vehicleId, () => []).add(completer);
    return completer.future;
  }

  void completeSensors(String vehicleId, List<UserVehicleSensor> sensors) {
    _sensorRequests[vehicleId]!.removeAt(0).complete(UserVehicleSensorPage(
          items: sensors,
          page: 1,
          limit: 100,
          total: sensors.length,
        ));
  }

  void failSensors(String vehicleId, Object error) {
    _sensorRequests[vehicleId]!.removeAt(0).completeError(error);
  }

  @override
  Future<UserReportPage> generate({
    required UserReportKey reportKey,
    required Map<String, dynamic> vehicleScope,
    required Map<String, dynamic> dateRange,
    required Map<String, dynamic> filters,
    required String timeZone,
    required DateTime from,
    required DateTime to,
    String? cursor,
  }) async {
    generateCalls++;
    generatedVehicleScope = vehicleScope;
    generatedFilters = filters;
    final error = generateError;
    if (error != null) throw error;
    return nextReport;
  }
}
