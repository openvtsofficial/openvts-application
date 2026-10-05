import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/road_routing_client.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';
import 'package:open_vts/features/user/models/user_route_stop.dart';
import 'package:open_vts/features/user/services/user_landmark_service.dart';
import 'package:open_vts/features/user/services/user_route_builder_service.dart';
import 'package:open_vts/features/user/services/user_route_optimizer.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);
  final dynamic Function(RequestOptions) respond;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final payload = respond(options);
    if (options.uri.path.contains('/route/v1/driving/') &&
        payload is Map &&
        payload['code'] == 'Ok') {
      final coordinates = options.uri.path
          .split('/')
          .last
          .split(';')
          .map((p) => p.split(',').map(double.parse).toList())
          .toList();
      payload.putIfAbsent(
        'waypoints',
        () => coordinates.map((p) => {'location': p}).toList(),
      );
      if (payload['routes'] is List) {
        for (final route in payload['routes'] as List) {
          if (route is Map) {
            route.putIfAbsent(
              'legs',
              () => List.filled(coordinates.length - 1, <String, dynamic>{}),
            );
          }
        }
      }
    }
    return ResponseBody.fromString(
      jsonEncode(payload),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

UserRouteStop point(
  String name,
  double lat,
  double lon, {
  String source = 'MANUAL',
  String? id,
}) => UserRouteStop(
  name: name,
  latitude: lat,
  longitude: lon,
  sourceType: source,
  sourceId: id,
);

void main() {
  test(
    'route API preserves source IDs, stop order and GeoJSON longitude/latitude',
    () async {
      final adapter = _Adapter(
        (options) => {
          'action': true,
          'route': {'id': 73, ...options.data as Map},
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'))
        ..httpClientAdapter = adapter;
      final service = UserLandmarkService(ApiClient(dio));
      final stops = routeStopsForSave([
        point('गोदाम', 12.3, 77.1, source: 'GEOFENCE', id: '41'),
        point('Delivery 🚚', 12.4, 77.2, source: 'POI', id: '22'),
      ], roundTrip: false);
      final request = CreateUserRouteRequest(
        name: 'Morning route',
        geodata: const UserLineGeoData(
          coordinates: [
            UserGeoPoint(lat: 12.3, lon: 77.1),
            UserGeoPoint(lat: 12.4, lon: 77.2),
          ],
        ),
        stops: stops,
      );
      final result = await service.createRoute(request);
      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.uri.path, '/api/user/routes');
      expect(
        (adapter.requests.single.data as Map)['stops'][0],
        containsPair('sourceId', '41'),
      );
      expect(result.id, '73');
      expect(result.stops.map((s) => s.type), ['ORIGIN', 'DESTINATION']);
      expect(result.stops.first.name, 'गोदाम');
      expect(result.geodata!.coordinates.first.lat, 12.3);
      expect(result.geodata!.coordinates.first.lon, 77.1);
      await service.updateRoute(
        result.id,
        UpdateUserRouteRequest(stops: stops, name: 'Evening route'),
      );
      expect(adapter.requests.last.method, 'PATCH');
      expect(adapter.requests.last.uri.path, '/api/user/routes/73');
      expect(
        (adapter.requests.last.data as Map).containsKey('description'),
        false,
      );
      dio.close();
    },
  );

  test('round trip closes origin and keeps VIA as shaping only', () {
    final source = [
      point('Start', 10, 20),
      point('Shape', 10.2, 20.2, source: 'VIA'),
      point('Delivery', 11, 21),
    ];
    final stops = routeStopsForSave(source, roundTrip: true);
    expect(stops.length, 4);
    expect(stops.map((s) => s.type), [
      'ORIGIN',
      'WAYPOINT',
      'WAYPOINT',
      'DESTINATION',
    ]);
    expect(stops.where((s) => !s.isVia).length, 3);
    expect(stops.last.latitude, stops.first.latitude);
    expect(stops.last.sourceType, stops.first.sourceType);
  });

  test(
    'invalid coordinates, stop sizes and duplicate-only trips fail before HTTP',
    () {
      expect(
        () => routeStopsForSave([
          point('A', 0, 0),
          point('B', 0, 0),
        ], roundTrip: false),
        throwsArgumentError,
      );
      expect(
        () => validateUserRouteStops([
          point('A', double.nan, 0),
          point('B', 0, 0),
        ]),
        throwsArgumentError,
      );
      expect(
        () => validateUserRouteStops([point('A', 91, 0), point('B', 0, 0)]),
        throwsArgumentError,
      );
      expect(
        () => routeStopsForSave(
          List.generate(100, (i) => point('$i', 10 + i / 1000, 20)),
          roundTrip: true,
        ),
        throwsArgumentError,
      );
      expect(
        () => validateUserRouteStops([
          point('A', 10, 20),
          const UserRouteStop(
            name: 'B',
            latitude: 11,
            longitude: 21,
            geofenceRadiusMeters: 49,
          ),
        ]),
        throwsArgumentError,
      );
    },
  );

  test(
    'exact optimizer preserves endpoints, visits once, removes VIA and untangles path',
    () {
      final source = [
        point('Start', 0, 0),
        point('Far', 0, 3),
        point('Near', 0, 1),
        point('Middle', 0, 2),
        point('End', 0, 4),
        point('Shape', 0, 2.5, source: 'VIA'),
      ];
      final optimized = optimizeUserRouteStops(source, roundTrip: false);
      expect(optimized.map((s) => s.name), [
        'Start',
        'Near',
        'Middle',
        'Far',
        'End',
      ]);
      final cycle = optimizeUserRouteStops(source, roundTrip: true);
      expect(cycle.first.name, 'Start');
      expect(cycle.map((s) => s.name).toSet().length, 5);
    },
  );

  test(
    'larger heuristic keeps start and destination without losing a stop',
    () {
      final source = List.generate(
        20,
        (i) => point('$i', 10 + (i * 7 % 20) / 10, 20 + i / 10),
      );
      final result = optimizeUserRouteStops(source, roundTrip: false);
      expect(result.first, source.first);
      expect(result.last, source.last);
      expect(result.toSet(), source.toSet());
    },
  );

  test(
    'OSRM contract uses lon,lat and accepts only real LineString geometry',
    () async {
      final adapter = _Adapter(
        (_) => {
          'code': 'Ok',
          'routes': [
            {
              'distance': 1250,
              'duration': 200,
              'geometry': {
                'type': 'LineString',
                'coordinates': [
                  [77.1, 12.3],
                  [77.14, 12.31],
                  [77.2, 12.4],
                ],
              },
            },
          ],
        },
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final service = UserRoadRouteService(
        routingClient: RoadRoutingClient(client: dio),
      );
      final result = await service.route([
        point('A', 12.3, 77.1),
        point('B', 12.4, 77.2),
      ]);
      final request = adapter.requests.single;
      expect(request.uri.path, '/route/v1/driving/77.1,12.3;77.2,12.4');
      expect(request.queryParameters['geometries'], 'geojson');
      expect(request.queryParameters['radiuses'], '50;50');
      expect(
        request.headers.keys.map((k) => k.toLowerCase()),
        isNot(contains('authorization')),
      );
      expect(result.points[1].lat, 12.31);
      expect(result.points[1].lon, 77.14);
      expect(result.distanceMeters, 1250);
      expect(result.durationSeconds, 200);
      dio.close();
    },
  );

  for (final payload in [
    {'code': 'NoRoute'},
    {'code': 'Ok', 'routes': []},
    {
      'code': 'Ok',
      'routes': [
        {
          'distance': 10,
          'duration': 1,
          'geometry': {
            'type': 'LineString',
            'coordinates': [
              [20, 10],
              [20, 95],
            ],
          },
        },
      ],
    },
    {
      'code': 'Ok',
      'routes': [
        {
          'distance': 10,
          'duration': 1,
          'geometry': {
            'type': 'Point',
            'coordinates': [
              [20, 10],
              [21, 11],
            ],
          },
        },
      ],
    },
  ]) {
    test(
      'unavailable or malformed routing never fabricates a straight-line fallback ${payload.hashCode}',
      () async {
        final dio = Dio()..httpClientAdapter = _Adapter((_) => payload);
        await expectLater(
          UserRoadRouteService(
            routingClient: RoadRoutingClient(client: dio),
          ).route([point('A', 10, 20), point('B', 11, 21)]),
          throwsA(isA<UserRoadRouteException>()),
        );
        dio.close();
      },
    );
  }

  test(
    'long route batches overlap at one point and preserve continuity',
    () async {
      final adapter = _Adapter((options) {
        final pairs = options.uri.path
            .split('/')
            .last
            .split(';')
            .map((pair) => pair.split(',').map(double.parse).toList())
            .toList();
        return {
          'code': 'Ok',
          'routes': [
            {
              'distance': 10,
              'duration': 1,
              'geometry': {'type': 'LineString', 'coordinates': pairs},
            },
          ],
        };
      });
      final dio = Dio()..httpClientAdapter = adapter;
      final result = await UserRoadRouteService(
        routingClient: RoadRoutingClient(client: dio),
      ).route(List.generate(100, (i) => point('$i', 10 + i / 1000, 20)));
      expect(adapter.requests.length, 2);
      expect(result.points.length, 100);
      expect(result.distanceMeters, 20);
      final a = adapter.requests[0].uri.path.split('/').last.split(';');
      final b = adapter.requests[1].uri.path.split('/').last.split(';');
      expect(a.last, b.first);
      dio.close();
    },
  );

  test('shape controls cannot become an operational origin or destination', () {
    final via = point('Shape', 10.2, 20.2, source: 'VIA');
    expect(
      () => routeStopsForSave([
        via,
        point('A', 10, 20),
        point('B', 11, 21),
      ], roundTrip: false),
      throwsArgumentError,
    );
    expect(
      () => routeStopsForSave([
        point('A', 10, 20),
        point('B', 11, 21),
        via,
      ], roundTrip: false),
      throwsArgumentError,
    );
    expect(
      routeStopsForSave([
        point('A', 10, 20),
        point('B', 11, 21),
        via,
      ], roundTrip: true).last.type,
      'DESTINATION',
    );
  });

  test('99-stop round trip fits the backend 100-stop limit', () {
    final source = List.generate(99, (i) => point('$i', 10 + i / 1000, 20));
    final result = routeStopsForSave(source, roundTrip: true);
    expect(result.length, 100);
    expect(result.last.type, 'DESTINATION');
  });

  test(
    'routing rejects far snapping and geometry mismatched to snapped endpoints',
    () async {
      for (final farSnap in [true, false]) {
        final adapter = _Adapter(
          (_) => {
            'code': 'Ok',
            'waypoints': [
              {
                'location': [20, farSnap ? 12 : 10],
              },
              {
                'location': [21, 11],
              },
            ],
            'routes': [
              {
                'distance': 10,
                'duration': 2,
                'geometry': {
                  'type': 'LineString',
                  'coordinates': [
                    [20, 12],
                    [21, 11],
                  ],
                },
              },
            ],
          },
        );
        final dio = Dio()..httpClientAdapter = adapter;
        await expectLater(
          UserRoadRouteService(
            routingClient: RoadRoutingClient(client: dio),
          ).route([point('A', 10, 20), point('B', 11, 21)]),
          throwsA(isA<UserRoadRouteException>()),
        );
        dio.close();
      }
    },
  );

  test(
    'public routing base rejects credentials, query and non-HTTPS schemes',
    () {
      for (final value in [
        'http://routing.test',
        'https://user:secret@routing.test',
        'https://routing.test?token=x',
        'https://routing.test#fragment',
      ]) {
        expect(() => RoadRoutingClient(baseUrl: value), throwsArgumentError);
      }
    },
  );

  test('cancelled road requests do not start or return geometry', () async {
    final adapter = _Adapter((_) => throw StateError('must not call network'));
    final dio = Dio()..httpClientAdapter = adapter;
    final token = RoadRoutingRequest()..cancel();
    await expectLater(
      UserRoadRouteService(
        routingClient: RoadRoutingClient(client: dio),
      ).route([point('A', 10, 20), point('B', 11, 21)], request: token),
      throwsA(isA<RoadRoutingCancelledException>()),
    );
    expect(adapter.requests, isEmpty);
    dio.close();
  });
}
