import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';
import 'package:open_vts/features/user/screens/landmarks/geofences/widgets/user_geofence_editor_screen.dart';
import 'package:open_vts/features/user/screens/landmarks/widgets/user_landmark_measurement_chip.dart';

class _SearchAdapter implements HttpClientAdapter {
  _SearchAdapter(this.responses);

  final Map<String, List<Map<String, dynamic>>> responses;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final query = options.queryParameters['q']?.toString() ?? '';
    return ResponseBody.fromString(
      jsonEncode(responses[query] ?? const []),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _searchDio(Map<String, List<Map<String, dynamic>>> responses) {
  return Dio()..httpClientAdapter = _SearchAdapter(responses);
}

const _existingPolygon = UserPolygonGeoData(
  coordinates: [
    UserGeoPoint(lat: 12.0, lon: 77.0),
    UserGeoPoint(lat: 12.1, lon: 77.1),
    UserGeoPoint(lat: 12.2, lon: 77.0),
  ],
);

Future<void> _pumpEditor(
  WidgetTester tester, {
  required Dio searchClient,
}) async {
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(searchClient.close);

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: UserGeofenceEditorScreen(
          initialMode: UserGeofenceEditorMode.polygon,
          initialGeodata: _existingPolygon,
          initialCenter: const LatLng(12.1, 77.05),
          searchClient: searchClient,
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField), query);
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

void main() {
  testWidgets('open results hide measurement and selection moves the map', (
    tester,
  ) async {
    final dio = _searchDio({
      'New Delhi': [
        {
          'lat': '28.6139',
          'lon': '77.2090',
          'display_name': 'New Delhi, Delhi, India',
          'address': {
            'city': 'New Delhi',
            'state': 'Delhi',
            'country': 'India',
          },
        },
      ],
    });
    await _pumpEditor(tester, searchClient: dio);

    expect(find.byType(UserLandmarkMeasurementChip), findsOneWidget);
    await _search(tester, 'New Delhi');

    expect(find.text('New Delhi'), findsNWidgets(2));
    expect(find.byType(UserLandmarkMeasurementChip), findsNothing);

    await tester.tap(find.text('New Delhi').last);
    await tester.pump();

    final map = tester.widget<FlutterMap>(find.byType(FlutterMap));
    expect(map.mapController!.camera.center.latitude, closeTo(28.6139, 1e-6));
    expect(map.mapController!.camera.center.longitude, closeTo(77.2090, 1e-6));
    expect(map.mapController!.camera.zoom, inInclusiveRange(14, 17));
    expect(find.text('New Delhi'), findsOneWidget);
    expect(find.byType(UserLandmarkMeasurementChip), findsOneWidget);
    expect(find.byIcon(Icons.search), findsNWidgets(2));
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('clear collapses results without changing existing geometry', (
    tester,
  ) async {
    final dio = _searchDio({
      'New Delhi': [
        {
          'lat': '28.6139',
          'lon': '77.2090',
          'display_name': 'New Delhi, Delhi, India',
          'address': {'city': 'New Delhi'},
        },
      ],
    });
    await _pumpEditor(tester, searchClient: dio);
    final measurementBefore = tester
        .widget<UserLandmarkMeasurementChip>(
          find.byType(UserLandmarkMeasurementChip),
        )
        .label;

    await _search(tester, 'New Delhi');
    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pump();

    expect(find.text('New Delhi'), findsNothing);
    expect(find.byType(UserLandmarkMeasurementChip), findsOneWidget);
    expect(
      tester
          .widget<UserLandmarkMeasurementChip>(
            find.byType(UserLandmarkMeasurementChip),
          )
          .label,
      measurementBefore,
    );
  });
}
