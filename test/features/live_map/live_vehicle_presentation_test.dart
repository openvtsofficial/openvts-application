import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/utils/telemetry_timestamp.dart';
import 'package:open_vts/features/superadmin/models/superadmin_vehicle_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_vehicle_service.dart';
import 'package:open_vts/shared/models/vehicle_summary.dart';
import 'package:open_vts/shared/utils/live_vehicle_icon.dart';
import 'package:open_vts/shared/utils/live_vehicle_presentation.dart';

void main() {
  final now = DateTime.utc(2026, 10, 6, 10, 30, 45);
  VehicleSummary vehicle({double speed = 45, DateTime? receiveTime}) =>
      VehicleSummary(
        id: '42',
        name: 'Vehicle 42',
        plateNumber: 'ABC-42',
        status: 'running',
        speed: speed,
        latitude: 28.61,
        longitude: 77.2,
        serverTime: receiveTime ?? now,
      );

  test(
    'map uses speed threshold, not stale status or engine/connection flags',
    () {
      for (final speed in [0.0, 1.0, 3.0]) {
        final stopped = vehicle(speed: speed).copyWith(
          ignition: true,
          acc: true,
          deviceConnectionStatus: 'CONNECTED',
        );
        expect(classifyLiveVehicle(stopped, now: now), LiveVehicleStatus.stop);
      }
      expect(
        classifyLiveVehicle(vehicle(speed: 3.001), now: now),
        LiveVehicleStatus.running,
      );
      expect(
        classifyLiveVehicle(
          vehicle().copyWith(deviceConnectionStatus: 'DISCONNECTED'),
          now: now,
        ),
        LiveVehicleStatus.running,
      );
    },
  );

  test('exact two-minute and 48-hour boundaries match the web', () {
    expect(
      classifyLiveVehicle(
        vehicle(
          receiveTime: now.subtract(const Duration(milliseconds: 119999)),
        ),
        now: now,
      ),
      LiveVehicleStatus.running,
    );
    expect(
      classifyLiveVehicle(
        vehicle(receiveTime: now.subtract(const Duration(minutes: 2))),
        now: now,
      ),
      LiveVehicleStatus.stop,
    );
    expect(
      classifyLiveVehicle(
        vehicle(
          receiveTime: now.subtract(
            const Duration(hours: 48) - const Duration(milliseconds: 1),
          ),
        ),
        now: now,
      ),
      LiveVehicleStatus.stop,
    );
    expect(
      classifyLiveVehicle(
        vehicle(receiveTime: now.subtract(const Duration(hours: 48))),
        now: now,
      ),
      LiveVehicleStatus.inactive,
    );
  });

  test('GPS, metadata and heartbeat cannot establish fresh tracking', () {
    final noTelemetry = vehicle().copyWith(
      serverTime: null,
      deviceTime: now,
      updatedAt: now,
      lastSeenAt: now,
      deviceConnectionStatus: 'CONNECTED',
    );
    expect(
      classifyLiveVehicle(noTelemetry, now: now),
      LiveVehicleStatus.inactive,
    );
    expect(isLiveVehicleStale(noTelemetry, now: now), isTrue);
    expect(
      classifyLiveVehicle(
        vehicle().copyWith(deviceTime: now.subtract(const Duration(days: 7))),
        now: now,
      ),
      LiveVehicleStatus.running,
    );
  });

  test(
    'a confirmed pending stop stays green only for the web debounce interval',
    () {
      final pending = vehicle(speed: 0).copyWith(
        motionState: 'running',
        pendingMotionState: 'stop',
        pendingMotionStateSince: now.subtract(const Duration(seconds: 29)),
      );
      expect(classifyLiveVehicle(pending, now: now), LiveVehicleStatus.running);
      expect(
        classifyLiveVehicle(pending, now: now.add(const Duration(seconds: 1))),
        LiveVehicleStatus.stop,
      );
      expect(
        classifyLiveVehicle(
          pending.copyWith(pendingMotionState: null),
          now: now,
        ),
        LiveVehicleStatus.stop,
      );
      expect(
        classifyLiveVehicle(
          pending.copyWith(
            serverTime: now.subtract(const Duration(minutes: 2)),
          ),
          now: now,
        ),
        LiveVehicleStatus.stop,
      );
    },
  );

  test(
    'silence suppresses stale speed but preserves last reported ignition',
    () {
      final raw = vehicle(
        receiveTime: now.subtract(const Duration(minutes: 2)),
      ).copyWith(ignition: true, acc: false, satellites: 9);
      final shown = effectiveLiveVehicle(raw, now: now);
      expect(shown.speed, 0);
      expect(shown.status, 'stop');
      expect(shown.ignition, isTrue);
      expect(shown.acc, isFalse);
      expect(shown.satellites, 9);
      expect(shown.serverTime, raw.serverTime);
      expect(raw.speed, 45);
    },
  );

  test(
    'stationary packet changes repaint color without moving the coordinates',
    () {
      final moving = vehicle();
      final stopped = moving.copyWith(
        speed: 0,
        serverTime: now.add(const Duration(seconds: 1)),
      );
      expect(stopped.latitude, moving.latitude);
      expect(stopped.longitude, moving.longitude);
      expect(
        classifyLiveVehicle(stopped, now: now.add(const Duration(seconds: 1))),
        LiveVehicleStatus.stop,
      );
      expect(
        liveVehicleIconAsset('car', classifyLiveVehicle(moving, now: now)),
        endsWith('carGreen.png'),
      );
      expect(
        liveVehicleIconAsset(
          'car',
          classifyLiveVehicle(
            stopped,
            now: now.add(const Duration(seconds: 1)),
          ),
        ),
        endsWith('carRed.png'),
      );
    },
  );

  test('blocked vehicle remains inactive and no stale movement is shown', () {
    final blocked = vehicle().copyWith(licenseBlocked: true);
    expect(classifyLiveVehicle(blocked, now: now), LiveVehicleStatus.inactive);
    expect(effectiveLiveVehicle(blocked, now: now).speed, 0);
    expect(effectiveLiveVehicle(blocked, now: now).status, 'license_blocked');
  });

  test('nonfinite speed cannot make a vehicle running', () {
    expect(
      classifyLiveVehicle(vehicle(speed: double.nan), now: now),
      LiveVehicleStatus.stop,
    );
    expect(
      classifyLiveVehicle(vehicle(speed: double.infinity), now: now),
      LiveVehicleStatus.stop,
    );
    expect(effectiveLiveVehicle(vehicle(speed: double.nan), now: now).speed, 0);
  });

  test(
    'existing icons preserve vehicle type, white inactive and web fallback',
    () {
      for (final state in LiveVehicleStatus.values) {
        final icon = liveVehicleIconAsset('mini-truck', state);
        expect(File(icon).existsSync(), isTrue);
      }
      expect(
        liveVehicleIconAsset('School Bus', LiveVehicleStatus.running),
        endsWith('schoolbusGreen.png'),
      );
      expect(
        liveVehicleIconAsset('bike', LiveVehicleStatus.inactive),
        endsWith('bikeWhite.png'),
      );
      expect(
        liveVehicleIconAsset('truck', LiveVehicleStatus.stop),
        endsWith('truckRed.png'),
      );
      expect(
        liveVehicleIconAsset('cat', LiveVehicleStatus.inactive),
        endsWith('default.png'),
      );
      expect(
        liveVehicleIconAsset('spaceship', LiveVehicleStatus.running),
        endsWith('default.png'),
      );
    },
  );

  test(
    'numeric timestamps parse seconds, milliseconds, micros and nanos to one instant',
    () {
      final ms = now.millisecondsSinceEpoch;
      for (final value in [
        ms ~/ 1000,
        '$ms',
        ms,
        ms * 1000,
        '${ms * 1000000}',
      ]) {
        expect(parseTelemetryTimestamp(value), now);
      }
      expect(parseTelemetryTimestamp('${ms / 1000}'), now);
      expect(parseTelemetryTimestamp(double.nan), isNull);
      expect(parseTelemetryTimestamp(double.infinity), isNull);
      expect(parseTelemetryTimestamp('bad date'), isNull);
      expect(parseTelemetryTimestamp('2026-10-06T16:00:45+05:30'), now);
    },
  );

  test(
    'nested live telemetry overrides stale root metrics and metadata time',
    () {
      final service = SuperadminVehicleService(ApiClient(Dio()));
      final parsed = service.parseTelemetryVehiclePayload({
        'vehicleId': 42,
        'vehicleName': 'Vehicle 42',
        'imei': '123456789012345',
        'updatedAt': now.add(const Duration(days: 1)).toIso8601String(),
        'speedKph': 80,
        'latitude': 29.0,
        'longitude': 78.0,
        'vehicleTypeSlug': 'truck',
        'status': 'running',
        'telemetry': {
          'serverTime': now.toIso8601String(),
          'deviceTime': now
              .subtract(const Duration(seconds: 5))
              .toIso8601String(),
          'speedKph': 0,
          'latitude': 28.61,
          'longitude': 77.2,
          'ignition': true,
          'distanceToday': 12,
        },
        '_deviceStatus': {
          'motionState': 'running',
          'pendingMotionState': 'stop',
          'pendingMotionStateSince': now
              .subtract(const Duration(seconds: 31))
              .toIso8601String(),
        },
      })!;
      expect(parsed.speed, 0);
      expect(parsed.latitude, 28.61);
      expect(parsed.serverTime, now);
      expect(parsed.updatedAt, now);
      expect(parsed.deviceTime, now.subtract(const Duration(seconds: 5)));
      expect(parsed.vehicleTypeSlug, 'truck');
      expect(classifyLiveVehicle(parsed, now: now), LiveVehicleStatus.stop);
    },
  );

  test(
    'legacy pendingStopSince telemetry aliases retain bounded stop debounce',
    () {
      final service = SuperadminVehicleService(ApiClient(Dio()));
      final parsed = service.parseTelemetryVehiclePayload({
        'vehicleId': 42,
        'serverTime': now.toIso8601String(),
        'speedKph': 0,
        'motionState': 'running',
        'pendingStopSince': now
            .subtract(const Duration(seconds: 10))
            .toIso8601String(),
      })!;
      expect(parsed.pendingMotionState, 'stop');
      expect(classifyLiveVehicle(parsed, now: now), LiveVehicleStatus.running);
    },
  );

  test(
    'log timeline prefers timeline/GPS event time while dedupe keeps receive identity',
    () {
      final received = now.add(const Duration(seconds: 12));
      final log = SuperadminVehicleLog.tryParse({
        'serverTime': received.toIso8601String(),
        'deviceTime': now.toIso8601String(),
        'packetType': 'LOCATION',
      })!;
      expect(log.displayTime, now);
      expect(log.dedupeKey, '${received.toIso8601String()}|LOCATION');
      final timeline = now.subtract(const Duration(seconds: 2));
      final canonical = SuperadminVehicleLog.tryParse({
        'serverTime': received.toIso8601String(),
        'deviceTime': now.toIso8601String(),
        'timelineTime': timeline.toIso8601String(),
      })!;
      expect(canonical.displayTime, timeline);
    },
  );
}
