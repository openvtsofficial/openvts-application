import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/user/models/user_operation_attachment.dart';
import 'package:open_vts/features/user/models/user_operation_map.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_route_map.dart';
import 'package:open_vts/features/user/services/user_operations_service.dart';
import 'package:open_vts/shared/models/user_role.dart';

const _tripId = 'b0c44995-79d4-41b5-a9ad-b520e74ed084';
const _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+ahtsAAAAASUVORK5CYII=';
final _png = base64Decode(_pngBase64);
UserOperationProof _proof() => UserOperationProof.fromJson(_tripId, {
      'id': '9007199254740993',
      'assignmentId': _tripId,
      'originalFileName': '../../receipt.png',
      'mimeType': 'image/png',
      'sizeBytes': _png.length,
    });
CurrentUser _user(
        {String id = '12',
        UserRole role = UserRole.user,
        bool allowed = true}) =>
    CurrentUser(
      id: id,
      name: 'Account',
      email: '',
      role: role,
      access:
          MobileAccess(loaded: true, features: {'routeOptimization': allowed}),
    );

void main() {
  test(
      'Proof download is authenticated API bytes and preserves bigint identifier',
      () async {
    final dio = Dio(BaseOptions(
        baseUrl: 'https://fleet.example/api',
        headers: {'Authorization': 'Bearer test-only'}));
    late RequestOptions request;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(
          Response(requestOptions: options, statusCode: 200, data: _png));
    }));
    final bytes =
        await UserOperationsService(ApiClient(dio, activeUser: () => _user()))
            .proofContent(_proof());
    expect(bytes, _png);
    expect(request.uri.toString(),
        'https://fleet.example/api/user/operations/trips/$_tripId/proofs/9007199254740993/content');
    expect(request.queryParameters, isEmpty);
    expect(request.responseType, ResponseType.bytes);
    expect(request.headers['Authorization'], 'Bearer test-only');
    expect(_proof().safeName, isNot(contains('/')));
  });

  test('Subuser, denied and missing sessions cannot request proof bytes',
      () async {
    var networkCalls = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://fleet.example/api'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      networkCalls++;
      handler.resolve(
          Response(requestOptions: options, statusCode: 200, data: _png));
    }));
    for (final user in <CurrentUser?>[
      _user(role: UserRole.subuser),
      _user(allowed: false),
      null
    ]) {
      await expectLater(
          UserOperationsService(ApiClient(dio, activeUser: () => user))
              .proofContent(_proof()),
          throwsA(
              isA<ApiException>().having((e) => e.statusCode, 'status', 403)));
    }
    expect(networkCalls, 0);
  });

  test(
      'Proof bytes from a completed request are discarded when account changes',
      () async {
    CurrentUser? active = _user();
    final pending = Completer<void>();
    final dio = Dio(BaseOptions(baseUrl: 'https://fleet.example/api'));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      await pending.future;
      handler.resolve(
          Response(requestOptions: options, statusCode: 200, data: _png));
    }));
    final download =
        UserOperationsService(ApiClient(dio, activeUser: () => active))
            .proofContent(_proof());
    active = _user(id: '99');
    pending.complete();
    await expectLater(
        download,
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 403)));
  });

  test('HTTP forbidden binary payload never becomes a successful proof',
      () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://fleet.example/api'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.resolve(
          Response(requestOptions: options, statusCode: 403, data: _png));
    }));
    await expectLater(
        UserOperationsService(ApiClient(dio, activeUser: () => _user()))
            .proofContent(_proof()),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 403)));
  });

  test(
      'Proof metadata rejects other assignments, path injection and unsupported files',
      () {
    for (final input in [
      {'id': '../2', 'mimeType': 'image/png', 'sizeBytes': _png.length},
      {'id': '1', 'mimeType': 'text/html', 'sizeBytes': 100},
      {'id': '1', 'mimeType': 'image/png', 'sizeBytes': 6000000},
      {'id': '1', 'mimeType': 'image/png', 'sizeBytes': 'bad'},
      {
        'id': '1',
        'mimeType': 'image/png',
        'sizeBytes': _png.length,
        'assignmentId': 'other'
      },
    ]) {
      expect(() => UserOperationProof.fromJson(_tripId, input),
          throwsFormatException);
    }
    expect(() => _proof().validateContent(Uint8List(_png.length)),
        throwsFormatException);
    expect(() => _proof().validateContent(_png.sublist(0, 5)),
        throwsFormatException);
  });

  test(
      'Current Operations schema uses nested GeoJSON and labels stale vehicle position',
      () {
    final result = UserOperationMapData.fromJson(_trip());
    expect(result.route.first, const LatLng(28.61, 77.20));
    expect(result.stops.single.sequence, 1);
    expect(result.position, const LatLng(28.615, 77.205));
    expect(result.exactRoute, true);
    expect(result.trackingStatus, 'STALE');
    expect(result.recordedAt, DateTime.utc(2026, 10, 2, 9));
  });

  test('Invalid route vertices are not joined into invented segments', () {
    final trip = _trip();
    trip['route'] = {
      'exact': false,
      'source': 'STOP_SEQUENCE',
      'geometry': {
        'type': 'LineString',
        'coordinates': [
          [77.2, 28.6],
          ['NaN', 28.7],
          [77.4, 28.8]
        ]
      }
    };
    final result = UserOperationMapData.fromJson(trip);
    expect(result.route, isEmpty);
    expect(result.stops, hasLength(1));
    expect(result.exactRoute, false);
  });

  testWidgets(
      'Phone route map renders stops, routed line and stale tracking label',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
      padding: const EdgeInsets.all(16),
      child: UserOperationRouteMap(
          data: UserOperationMapData.fromJson(_trip()),
          tileProvider: _MemoryTileProvider()),
    )))));
    await tester.pumpAndSettle();
    expect(find.byType(PolylineLayer), findsOneWidget);
    expect(find.textContaining('Vehicle GPS: Stale'), findsOneWidget);
    expect(find.byTooltip('1. Warehouse • Pending'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Map<String, dynamic> _trip() => {
      'route': {
        'source': 'OPTIMIZED_ROUTE',
        'exact': true,
        'geometry': {
          'type': 'LineString',
          'coordinates': [
            [77.20, 28.61],
            [77.21, 28.62]
          ]
        }
      },
      'stops': [
        {
          'sequence': 1,
          'name': 'Warehouse',
          'status': 'PENDING',
          'latitude': 28.61,
          'longitude': 77.20
        }
      ],
      'currentPosition': {
        'latitude': 28.615,
        'longitude': 77.205,
        'recordedAt': '2026-10-02T09:00:00Z'
      },
      'tracking': {'status': 'STALE', 'lastPositionAt': '2026-10-02T09:00:00Z'},
    };

class _MemoryTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      MemoryImage(_png);
}
