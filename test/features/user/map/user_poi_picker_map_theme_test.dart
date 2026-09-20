import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/features/user/screens/landmarks/pois/widgets/user_poi_picker_map.dart';

class _DeferredSearchAdapter implements HttpClientAdapter {
  final response = Completer<ResponseBody>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return response.future;
  }

  void completeWithResult() {
    response.complete(
      ResponseBody.fromString(
        jsonEncode([
          {
            'lat': '28.6139',
            'lon': '77.2090',
            'display_name': 'New Delhi, Delhi, India',
          },
        ]),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<void> _pumpPicker(
  WidgetTester tester, {
  required ThemeMode themeMode,
  required Dio searchClient,
  LatLng? initialPoint,
  double? initialTolerance,
}) async {
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(searchClient.close);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: UserPoiPickerMap(
        initialPoint: initialPoint,
        initialToleranceM: initialTolerance,
        searchClient: searchClient,
      ),
    ),
  );
  await tester.pump();
}

TextField _fieldWithLabel(WidgetTester tester, String label) {
  return tester.widget<TextField>(
    find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == label,
    ),
  );
}

TextField _toleranceField(WidgetTester tester) {
  return tester.widgetList<TextField>(find.byType(TextField)).firstWhere(
        (f) => f.decoration?.hintText == '0',
      );
}

// Reproduce the app's global InputDecorationTheme so that the fill-
// inheritance bug can be observed when filled: false is absent.
ThemeData _appLikeLight() => ThemeData.light().copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ),
    );

ThemeData _appLikeDark() => ThemeData.dark().copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OpenVtsColors.darkSurface,
      ),
    );

Future<void> _pumpPickerWithTheme(
  WidgetTester tester, {
  required ThemeData theme,
  Dio? searchClient,
}) async {
  final dio =
      searchClient ?? (Dio()..httpClientAdapter = _DeferredSearchAdapter());
  tester.view.physicalSize = const Size(900, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(dio.close);
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: UserPoiPickerMap(searchClient: dio),
    ),
  );
  await tester.pump();
}

void main() {
  for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
    final themeName = themeMode.name;

    testWidgets('$themeName empty controls and disabled save stay readable', (
      tester,
    ) async {
      final dio = Dio()..httpClientAdapter = _DeferredSearchAdapter();
      await _pumpPicker(
        tester,
        themeMode: themeMode,
        searchClient: dio,
      );

      final search = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Search place...'),
      );
      expect(search.style?.color, OpenVtsColors.white);
      expect(_fieldWithLabel(tester, 'Latitude').style?.color,
          OpenVtsColors.white);
      expect(_fieldWithLabel(tester, 'Longitude').style?.color,
          OpenVtsColors.white);
      expect(find.text('Tap map to place POI'), findsOneWidget);
      expect(find.text('Tolerance'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$themeName loading, results and selected values are readable',
        (
      tester,
    ) async {
      final adapter = _DeferredSearchAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      await _pumpPicker(
        tester,
        themeMode: themeMode,
        searchClient: dio,
        initialPoint: const LatLng(12.100001, 77.050001),
        initialTolerance: 75,
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Search place...'),
        'New Delhi',
      );
      await tester.pump();

      final spinner = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(
        spinner.valueColor?.value,
        OpenVtsColors.white.withValues(alpha: 0.85),
      );

      await tester.runAsync(() async {
        adapter.completeWithResult();
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final result = tester.widget<Text>(find.text('New Delhi, Delhi, India'));
      expect(result.style?.color, OpenVtsColors.white);
      await tester.tap(find.text('New Delhi, Delhi, India'));
      await tester.pump();

      expect(_fieldWithLabel(tester, 'Latitude').controller?.text, '28.613900');
      expect(
        _fieldWithLabel(tester, 'Longitude').controller?.text,
        '77.209000',
      );
      expect(find.text('75'), findsOneWidget);
      expect(find.text('Use this location'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  // ---------------------------------------------------------------
  // Fill-inheritance fix: dark-panel fields must block the
  // global Light-theme "filled: true, fillColor: white" so that
  // white foreground text is not rendered on a white background.
  // ---------------------------------------------------------------

  group('fill-inheritance fix', () {
    for (final entry in <Map<String, dynamic>>[
      {'name': 'light-with-white-fill', 'theme': _appLikeLight()},
      {'name': 'dark-with-dark-fill', 'theme': _appLikeDark()},
    ]) {
      final themeName = entry['name'] as String;
      final theme = entry['theme'] as ThemeData;

      testWidgets('$themeName: search field has filled:false and white cursor',
          (tester) async {
        await _pumpPickerWithTheme(tester, theme: theme);
        final field = tester.widget<TextField>(
          find.widgetWithText(TextField, 'Search place...'),
        );
        expect(
          field.decoration?.filled,
          isFalse,
          reason: 'search field must override inherited white fill',
        );
        expect(field.cursorColor, OpenVtsColors.white);
        expect(field.style?.color, OpenVtsColors.white);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          '$themeName: typed search text stays white (no white-on-white)',
          (tester) async {
        final adapter = _DeferredSearchAdapter();
        final dio = Dio()..httpClientAdapter = adapter;
        await _pumpPickerWithTheme(tester, theme: theme, searchClient: dio);
        await tester.enterText(
          find.widgetWithText(TextField, 'Search place...'),
          'Delhi',
        );
        await tester.pump();
        final field = tester.widget<TextField>(
          find.widgetWithText(TextField, 'Delhi'),
        );
        expect(field.decoration?.filled, isFalse);
        expect(field.style?.color, OpenVtsColors.white);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$themeName: loading spinner is visible', (tester) async {
        final adapter = _DeferredSearchAdapter();
        final dio = Dio()..httpClientAdapter = adapter;
        await _pumpPickerWithTheme(tester, theme: theme, searchClient: dio);
        await tester.enterText(
          find.widgetWithText(TextField, 'Search place...'),
          'New Delhi',
        );
        await tester.pump();
        final spinner = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        expect(
          spinner.valueColor?.value,
          OpenVtsColors.white.withValues(alpha: 0.85),
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('$themeName: latitude field has filled:false and white cursor',
          (tester) async {
        await _pumpPickerWithTheme(tester, theme: theme);
        final field = _fieldWithLabel(tester, 'Latitude');
        expect(
          field.decoration?.filled,
          isFalse,
          reason: 'latitude field must override inherited white fill',
        );
        expect(field.cursorColor, OpenVtsColors.white);
        expect(field.style?.color, OpenVtsColors.white);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          '$themeName: longitude field has filled:false and white cursor',
          (tester) async {
        await _pumpPickerWithTheme(tester, theme: theme);
        final field = _fieldWithLabel(tester, 'Longitude');
        expect(
          field.decoration?.filled,
          isFalse,
          reason: 'longitude field must override inherited white fill',
        );
        expect(field.cursorColor, OpenVtsColors.white);
        expect(field.style?.color, OpenVtsColors.white);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          '$themeName: tolerance field has filled:false and white cursor',
          (tester) async {
        await _pumpPickerWithTheme(tester, theme: theme);
        final field = _toleranceField(tester);
        expect(
          field.decoration?.filled,
          isFalse,
          reason: 'tolerance field must override inherited white fill',
        );
        expect(field.cursorColor, OpenVtsColors.white);
        expect(field.style?.color, OpenVtsColors.white);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$themeName: focused coord field border uses white outline',
          (tester) async {
        await _pumpPickerWithTheme(tester, theme: theme);
        final field = _fieldWithLabel(tester, 'Latitude');
        final focused = field.decoration?.focusedBorder as OutlineInputBorder?;
        expect(focused?.borderSide.color, OpenVtsColors.white);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
