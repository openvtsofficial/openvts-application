import '../models/vehicle_summary.dart';

/// The same three map states and thresholds as the current web application.
enum LiveVehicleStatus { running, stop, inactive }

const liveVehicleStaleThreshold = Duration(minutes: 2);
const liveVehicleInactiveThreshold = Duration(hours: 48);
const liveVehicleStopDebounce = Duration(seconds: 30);
const liveVehicleRunningSpeedThreshold = 3.0;

/// Receive time, never GPS event time or a connection heartbeat.
DateTime? liveVehicleReceiveTime(VehicleSummary vehicle) => vehicle.serverTime;

LiveVehicleStatus classifyLiveVehicle(VehicleSummary vehicle, {DateTime? now}) {
  if (vehicle.licenseBlocked) return LiveVehicleStatus.inactive;
  final timestamp = liveVehicleReceiveTime(vehicle);
  if (timestamp == null) return LiveVehicleStatus.inactive;
  final instant = now ?? DateTime.now();
  final age = instant.difference(timestamp);
  if (age >= liveVehicleInactiveThreshold) return LiveVehicleStatus.inactive;
  if (age >= liveVehicleStaleThreshold) return LiveVehicleStatus.stop;
  if (vehicle.speed.isFinite &&
      vehicle.speed > liveVehicleRunningSpeedThreshold) {
    return LiveVehicleStatus.running;
  }
  final pendingSince = vehicle.pendingMotionStateSince;
  if (vehicle.speed.isFinite &&
      vehicle.speed <= liveVehicleRunningSpeedThreshold &&
      vehicle.motionState == 'running' &&
      vehicle.pendingMotionState == 'stop' &&
      pendingSince != null &&
      instant.difference(pendingSince) < liveVehicleStopDebounce) {
    return LiveVehicleStatus.running;
  }
  return LiveVehicleStatus.stop;
}

bool isLiveVehicleStale(VehicleSummary vehicle, {DateTime? now}) {
  if (vehicle.licenseBlocked) return true;
  final timestamp = liveVehicleReceiveTime(vehicle);
  return timestamp == null ||
      (now ?? DateTime.now()).difference(timestamp) >=
          liveVehicleStaleThreshold;
}

/// Suppress stale movement while retaining the last reported ignition/ACC.
/// Silence cannot prove the engine is off. This is presentation-only data.
VehicleSummary effectiveLiveVehicle(VehicleSummary vehicle, {DateTime? now}) {
  final status = vehicle.licenseBlocked
      ? 'license_blocked'
      : classifyLiveVehicle(vehicle, now: now).name;
  final speed = isLiveVehicleStale(vehicle, now: now) || !vehicle.speed.isFinite
      ? 0.0
      : vehicle.speed;
  if (status == vehicle.status && speed == vehicle.speed) return vehicle;
  return vehicle.copyWith(status: status, speed: speed);
}
