import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/services/superadmin_vehicle_service.dart';
import 'package:open_vts/shared/models/vehicle_summary.dart';

void main() {
  final day = DateTime(2026, 9, 20);
  final now = DateTime(2026, 9, 20, 12);
  final parser = SuperadminVehicleService(ApiClient(Dio()));

  VehicleSummary summary({
    double? today, double? odometer, String? key,
    DateTime? start, double? baseline, DateTime? timestamp,
  }) => VehicleSummary(
    id: '1', imei: '123456789012345', name: 'Truck', plateNumber: 'ABC123',
    status: 'running', speed: 35, latitude: 40, longitude: -74,
    distanceKm: today, odometerKm: odometer, browserDayKey: key,
    browserDayStart: start, browserDayBaseOdometer: baseline,
    updatedAt: timestamp,
  );

  test('Today never falls back to a trip increment or lifetime mileage', () {
    final payload = <String, dynamic>{
      'id': '1', 'imei': '123456789012345', 'latitude': 40, 'longitude': -74,
      'distance': 0.25, 'tripDistance': 15, 'distanceKm': 50000,
      'odometer': 60000,
    };
    expect(VehicleSummary.fromJson(payload).distanceKm, isNull);
    expect(parser.parseTelemetryVehiclePayload(payload)!.distanceKm, isNull);
    expect(parser.parseVehicleDetailsPayload(payload).distanceKm, isNull);
  });

  test('nested HTTP telemetry retains the local-day baseline and zero odometer', () {
    final vehicle = parser.parseTelemetryVehiclePayload({
      'vehicleId': 1, 'imei': '123456789012345',
      'telemetry': {
        'latitude': 40, 'longitude': -74, 'distanceToday': 0, 'odometer': 0,
        'browserDayKey': '2026-09-20',
        'browserDayStart': day.toUtc().toIso8601String(),
        'browserDayBaseOdometer': 0,
      },
    })!;
    expect(vehicle.distanceKm, 0);
    expect(vehicle.odometerKm, 0);
    expect(vehicle.browserDayKey, '2026-09-20');
    expect(vehicle.browserDayStart!.isAtSameMomentAs(day), isTrue);
    expect(vehicle.browserDayBaseOdometer, 0);
  });

  test('socket owner-day counter cannot replace local-day distance', () {
    final current = summary(today: 10, odometer: 110, key: '2026-09-20',
        start: day, baseline: 100, timestamp: now);
    final merged = current.withTodayDistanceFrom(
      summary(today: 999, odometer: 112.5,
          timestamp: now.add(const Duration(seconds: 5))), now: now,
    );
    expect(merged.distanceKm, 12.5);
    expect(merged.browserDayBaseOdometer, 100);
    expect(merged.latitude, current.latitude);
  });

  test('stale socket odometer cannot regress Today', () {
    final current = summary(today: 12.5, odometer: 112.5, key: '2026-09-20',
        start: day, baseline: 100, timestamp: now);
    final merged = current.withTodayDistanceFrom(
      summary(today: 999, odometer: 110,
          timestamp: now.subtract(const Duration(seconds: 10))), now: now,
    );
    expect(merged.distanceKm, 12.5);
    expect(merged.odometerKm, 112.5);
  });

  test('socket without odometer preserves local-day total', () {
    final current = summary(today: 10, key: '2026-09-20', start: day);
    expect(current.withTodayDistanceFrom(summary(today: 999), now: now)
        .distanceKm, 10);
  });

  test('midnight clears yesterday until authoritative HTTP baseline arrives', () {
    final current = summary(today: 10, odometer: 110, key: '2026-09-19',
        start: DateTime(2026, 9, 19), baseline: 100);
    final waiting = current.withTodayDistanceFrom(
      summary(today: 999, odometer: 111), now: now,
    );
    expect(waiting.distanceKm, isNull);
    expect(waiting.browserDayKey, '2026-09-20');
    expect(waiting.browserDayBaseOdometer, isNull);
    final updated = waiting.withTodayDistanceFrom(
      summary(today: 2, odometer: 111, key: '2026-09-20',
          start: day, baseline: 109), now: now, authoritativeBaseline: true,
    );
    expect(updated.distanceKm, 2);
  });

  test('slow HTTP baseline keeps latest odometer and live coordinates', () {
    final current = summary(today: 3, odometer: 113, key: '2026-09-20',
        start: day, baseline: 110, timestamp: now);
    final http = summary(today: 2, odometer: 112, key: '2026-09-20',
        start: day, baseline: 110,
        timestamp: now.subtract(const Duration(seconds: 10)))
        .copyWith(latitude: 1, longitude: 2);
    final updated = current.withTodayDistanceFrom(http,
        now: now, authoritativeBaseline: true);
    expect(updated.distanceKm, 3);
    expect(updated.latitude, 40);
    expect(updated.longitude, -74);
  });

  test('authoritative day correction can replace same-day baseline', () {
    final current = summary(today: 12, odometer: 112, key: '2026-09-20',
        start: day, baseline: 100);
    final updated = current.withTodayDistanceFrom(
      summary(today: 7, odometer: 112, key: '2026-09-20',
          start: day, baseline: 105), now: now, authoritativeBaseline: true,
    );
    expect(updated.distanceKm, 7);
    expect(updated.browserDayBaseOdometer, 105);
  });
  test('newer authoritative odometer reset replaces the previous counter', () {
    final current = summary(today: 100, odometer: 10000, key: '2026-09-20',
        start: day, baseline: 9900, timestamp: now);
    final updated = current.withTodayDistanceFrom(
      summary(today: 5, odometer: 5, key: '2026-09-20', start: day,
          baseline: 0, timestamp: now.add(const Duration(seconds: 5))),
      now: now, authoritativeBaseline: true,
    );
    expect(updated.distanceKm, 5);
    expect(updated.odometerKm, 5);
    expect(updated.browserDayBaseOdometer, 0);
  });

  test('newer socket odometer reset invalidates the previous day baseline', () {
    final current = summary(today: 100, odometer: 10000, key: '2026-09-20',
        start: day, baseline: 9900, timestamp: now);
    final updated = current.withTodayDistanceFrom(
      summary(odometer: 5, timestamp: now.add(const Duration(seconds: 5))),
      now: now,
    );
    expect(updated.distanceKm, isNull);
    expect(updated.odometerKm, 5);
    expect(updated.browserDayBaseOdometer, isNull);
  });

  test('HTTP without local-day analytics never exposes the owner-day fallback', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
    Map<String, dynamic>? requestedDay;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      requestedDay = options.queryParameters;
      handler.resolve(Response<dynamic>(
        requestOptions: options, statusCode: 200,
        data: {'items': [
          {'vehicleId': 1, 'imei': '123456789012345', 'telemetry': {
            'latitude': 40, 'longitude': -74, 'odometer': 1000,
            'distanceToday': 999,
          }},
        ], 'hasMore': false},
      ));
    }));
    final result = await SuperadminVehicleService(ApiClient(dio))
        .loadMapTelemetryEndpoint('/user/map-telemetry');
    final vehicle = result.vehicles.single;
    expect(vehicle.distanceKm, isNull);
    expect(vehicle.browserDayKey, requestedDay!['dayKey']);
    expect(vehicle.browserDayStart!.toUtc().toIso8601String(),
        requestedDay!['dayStart']);
    expect(vehicle.browserDayBaseOdometer, isNull);
  });

}
