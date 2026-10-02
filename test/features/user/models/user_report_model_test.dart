import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_report_model.dart';

void main() {
  test('parses bounded report metadata and dynamic rows', () {
    final page = UserReportPage.fromJson(
      <String, dynamic>{
        'rows': [
          <String, dynamic>{
            'vehicleId': '12',
            'vehicleName': 'Truck 12',
            'distanceKm': 18.5,
          },
        ],
        'meta': <String, dynamic>{
          'generatedAt': '2026-07-26T10:00:00.000Z',
          'hasMore': true,
          'nextCursor': 'cursor-2',
          'source': 'bounded-query',
        },
      },
    );

    expect(page.rows, hasLength(1));
    expect(page.rows.single['distanceKm'], 18.5);
    expect(page.hasMore, isTrue);
    expect(page.nextCursor, 'cursor-2');
    expect(page.generatedAt?.isUtc, isTrue);
  });

  test('report catalog mirrors backend range and vehicle constraints', () {
    expect(UserReportKey.overspeed.maxDays, 7);
    expect(UserReportKey.alerts.maxDays, 90);
    expect(UserReportKey.sensor.requiresSingleVehicle, isTrue);
    expect(UserReportKey.logs.requiresSingleVehicle, isTrue);
    expect(UserReportKey.timeline.usesDateOnly, isTrue);
    expect(UserReportKey.driven.usesDateOnly, isFalse);
    expect(UserReportKey.alerts.chartCategory, 'severity');
    expect(UserReportKey.distance.chartMetric, 'distanceKm');
  });

  test('rejects invalid timeline coordinates at the model boundary', () {
    final valid = UserTimelinePoint.fromJson(
      const <String, dynamic>{
        't': '2026-07-26T10:00:00Z',
        'lat': 28.61,
        'lon': 77.2,
      },
    );
    final invalid = UserTimelinePoint.fromJson(
      const <String, dynamic>{
        't': '2026-07-26T10:00:00Z',
        'lat': 999,
        'lon': 77.2,
      },
    );

    expect(valid.isValid, isTrue);
    expect(invalid.isValid, isFalse);
  });
}
