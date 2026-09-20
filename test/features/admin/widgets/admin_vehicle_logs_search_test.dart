import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/core/utils/unit_formatter.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_state.dart';
import 'package:open_vts/features/admin/screens/vehicles/widgets/admin_vehicle_logs_tab.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';

AdminVehicleLogItem _log({
  required String id,
  required String imei,
  required String packetType,
  required String protocol,
  required String rawPacket,
  required Object attributes,
  required bool ignition,
  required bool acc,
}) {
  return AdminVehicleLogItem(
    id: id,
    source: SuperadminVehicleLogSource.api,
    imei: imei,
    serverTime: DateTime.utc(2026, 1, 1),
    deviceTime: null,
    packetType: packetType,
    protocol: protocol,
    speedKph: 0,
    course: 0,
    ignition: ignition,
    acc: acc,
    latitude: 12,
    longitude: 77,
    altitude: 0,
    satellites: 8,
    valid: true,
    odometer: 0,
    distance: 0,
    engineHours: 0,
    totalEngineHours: 0,
    rawPacket: rawPacket,
    attributes: attributes,
    createdAt: null,
  );
}

final _positionLog = _log(
  id: 'log-position',
  imei: '111222333444555',
  packetType: 'Position',
  protocol: 'GT06',
  rawPacket: 'CAFEBABE',
  attributes: const {'driverName': 'Asha'},
  ignition: false,
  acc: true,
);

final _alarmLog = _log(
  id: 'log-alarm',
  imei: '999888777666555',
  packetType: 'Alarm',
  protocol: 'Teltonika',
  rawPacket: 'DEADBEEF',
  attributes: const {'event': 'overspeed'},
  ignition: true,
  acc: false,
);

class _LogsHarness extends StatefulWidget {
  const _LogsHarness();

  @override
  State<_LogsHarness> createState() => _LogsHarnessState();
}

class _LogsHarnessState extends State<_LogsHarness> {
  var _logs = <AdminVehicleLogItem>[_positionLog, _alarmLog];
  var _query = '';

  AdminVehicleDetailsState get _state =>
      AdminVehicleDetailsState.initial(vehicleId: 'vehicle-1').copyWith(
        logs: _logs,
        logSearchQuery: _query,
      );

  @override
  Widget build(BuildContext context) {
    final state = _state;
    return ProviderScope(
      overrides: [
        unitFormatterProvider.overrideWithValue(
          const UnitFormatter(units: 'KM'),
        ),
        appDateFormatterProvider.overrideWithValue(
          const AppDateFormatter(datePattern: 'YYYY-MM-DD', use24Hour: true),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AdminVehicleLogsTab(
              imei: '111222333444555',
              logs: state.filteredLogs,
              hasLoadedLogs: state.logs.isNotEmpty,
              searchQuery: state.logSearchQuery,
              nextCursor: 'older-cursor',
              isLoading: false,
              isLoadingMore: false,
              onLoad: () async {},
              onLoadMore: () async {
                setState(() {
                  _logs = [
                    ..._logs,
                    _log(
                      id: 'log-older',
                      imei: '111222333444555',
                      packetType: 'History',
                      protocol: 'older-protocol',
                      rawPacket: '0011',
                      attributes: const {'source': 'archive'},
                      ignition: false,
                      acc: false,
                    ),
                  ];
                });
              },
              onApplyRange: (_, __) async {},
              onSearchChanged: (value) => setState(() => _query = value),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  test('filters loaded rows without mutating logs or pagination state', () {
    final base =
        AdminVehicleDetailsState.initial(vehicleId: 'vehicle-1').copyWith(
      logs: [_positionLog, _alarmLog],
      logNextCursor: 'cursor-2',
    );

    final cases = {
      '111222': 'log-position',
      'alarm': 'log-alarm',
      'gt06': 'log-position',
      'cafebabe': 'log-position',
      'asha': 'log-position',
      'ignition off': 'log-position',
      'acc off': 'log-alarm',
    };

    for (final entry in cases.entries) {
      final searched = base.copyWith(logSearchQuery: entry.key.toUpperCase());
      expect(searched.filteredLogs.single.id, entry.value);
      expect(searched.logs, same(base.logs));
      expect(searched.logNextCursor, 'cursor-2');
    }

    expect(base.copyWith(logSearchQuery: '').filteredLogs, base.logs);
  });

  testWidgets('no match can load older rows and clearing restores all logs', (
    tester,
  ) async {
    await tester.pumpWidget(const _LogsHarness());

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'older-protocol');
    await tester.pump();

    expect(find.text('No matching logs'), findsOneWidget);
    expect(find.text('Load older'), findsOneWidget);

    await tester.tap(find.text('Load older'));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsOneWidget);
    expect(find.text('No matching logs'), findsNothing);

    await tester.enterText(searchField, '');
    await tester.pump();
    expect(find.text('Position'), findsOneWidget);
    expect(find.text('Alarm'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
