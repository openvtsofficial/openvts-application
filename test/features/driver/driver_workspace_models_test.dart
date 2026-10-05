import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/driver/models/driver_workspace_models.dart';

DriverTrip trip(String status) => DriverTrip.fromJson({
      'id': 'id',
      'status': status,
      'progress': {'percent': 125},
      'stops': [
        {
          'id': '9223372036854775806',
          'sequence': 3,
          'status': 'PENDING',
          'latitude': 23,
          'longitude': 73
        },
        {
          'id': '21',
          'sequence': 1,
          'status': 'COMPLETED',
          'latitude': 21,
          'longitude': 71
        },
        {
          'id': '22',
          'sequence': 2,
          'status': 'ARRIVED',
          'latitude': 22,
          'longitude': 72
        },
      ]
    });
void main() {
  test(
      'only first outstanding stop is completable and IDs preserve bigint precision',
      () {
    final value = trip('IN_PROGRESS');
    expect(value.currentStop!.id, '22');
    expect(value.stops.map((s) => s.sequence), [1, 2, 3]);
    expect(value.canComplete(value.stops[1]), isTrue);
    expect(value.canComplete(value.stops[2]), isFalse);
    expect(value.stops.last.id, '9223372036854775806');
    expect(value.progress, 1);
  });
  test('terminal and assigned trips cannot manually complete a stop', () {
    for (final status in [
      'ASSIGNED',
      'ACKNOWLEDGED',
      'COMPLETED',
      'CANCELLED',
      'FAILED'
    ]) {
      final value = trip(status);
      expect(value.canComplete(value.stops[1]), isFalse, reason: status);
    }
  });
  test('acknowledge/start/proof states match driver API guards', () {
    expect(trip('ASSIGNED').canAcknowledge, isTrue);
    expect(trip('ACKNOWLEDGED').canAcknowledge, isFalse);
    expect(trip('ACKNOWLEDGED').canStart, isTrue);
    expect(trip('IN_PROGRESS').canStart, isFalse);
    expect(trip('COMPLETED').canUploadProof, isTrue);
    expect(trip('CANCELLED').canUploadProof, isFalse);
  });
  test(
      'navigation never launches arbitrary server URL and retains route stop order',
      () {
    final value = trip('ASSIGNED');
    expect(value.navigationUri!.scheme, 'https');
    expect(value.navigationUri!.host, 'www.google.com');
    expect(value.navigationUri!.queryParameters['origin'], '21.0,71.0');
    expect(value.navigationUri!.queryParameters['waypoints'], '22.0,72.0');
  });
  test('missing or invalid coordinates disable external navigation', () {
    for (final coordinate in [null, 91, double.nan]) {
      final value = DriverTrip.fromJson({
        'stops': [
          {'latitude': coordinate, 'longitude': 0}
        ]
      });
      expect(value.navigationUri, isNull);
    }
  });
  test('trip query is value-equal for stable provider cache keys', () {
    expect(const DriverTripsQuery(scope: 'history', page: 2, search: 'x'),
        const DriverTripsQuery(scope: 'history', page: 2, search: 'x'));
    expect(const DriverTripsQuery(page: 1),
        isNot(const DriverTripsQuery(page: 2)));
  });
}
