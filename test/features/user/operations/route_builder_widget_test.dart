import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/road_routing_client.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/controllers/user_route_builder_controller.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';
import 'package:open_vts/features/user/models/user_route_stop.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_route_builder_screen.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_route_inputs.dart';
import 'package:open_vts/features/user/services/user_landmark_service.dart';
import 'package:open_vts/features/user/services/user_route_builder_service.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';

class _Auth extends StateNotifier<AuthState> implements AuthController {
  _Auth({bool allowed = true})
    : super(
        AuthState.authenticated(
          CurrentUser(
            id: '3',
            name: 'Planner',
            email: '',
            role: UserRole.user,
            access: MobileAccess(
              loaded: true,
              features: {'routeOptimization': allowed, 'landmarks': allowed},
            ),
          ),
        ),
      );
  void revoke() {
    state = AuthState.authenticated(
      state.user!.copyWith(access: const MobileAccess.unavailable()),
    );
  }

  void switchAccount() {
    state = AuthState.authenticated(state.user!.copyWith(id: 'another-user'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UserRouteLandmark _route({bool geometry = false}) =>
    UserRouteLandmark.fromJson({
      'id': 9,
      'name': 'Delivery route',
      'isActive': true,
      'stops': [
        {
          'sequence': 1,
          'name': 'Start',
          'type': 'ORIGIN',
          'latitude': 10,
          'longitude': 20,
          'sourceType': 'POI',
          'sourceId': '3',
        },
        {
          'sequence': 2,
          'name': 'Finish',
          'type': 'DESTINATION',
          'latitude': 11,
          'longitude': 21,
          'sourceType': 'MANUAL',
        },
      ],
      if (geometry)
        'geodata': {
          'kind': 'LINE',
          'geometry': {
            'type': 'LineString',
            'coordinates': [
              [20, 10],
              [20.2, 10.5],
              [21, 11],
            ],
          },
        },
    });

class _LandmarkService extends UserLandmarkService {
  _LandmarkService(this.route) : super(ApiClient(Dio()));
  final UserRouteLandmark route;
  UpdateUserRouteRequest? update;
  @override
  Future<UserRouteLandmark> fetchRouteById(String id) async => route;
  @override
  Future<UserRouteLandmark> updateRoute(
    String id,
    UpdateUserRouteRequest request,
  ) async {
    update = request;
    return _route(geometry: true);
  }
}

class _RoadService extends UserRoadRouteService {
  _RoadService({this.fail = false});
  final bool fail;
  int calls = 0;
  @override
  Future<UserRoadRoute> route(
    List<UserRouteStop> stops, {
    RoadRoutingRequest? request,
  }) async {
    calls++;
    if (fail) throw const UserRoadRouteException();
    return const UserRoadRoute(
      points: [
        UserGeoPoint(lat: 10, lon: 20),
        UserGeoPoint(lat: 10.5, lon: 20.2),
        UserGeoPoint(lat: 11, lon: 21),
      ],
      distanceMeters: 2000,
      durationSeconds: 300,
    );
  }
}

class _DeferredRoadService extends UserRoadRouteService {
  final response = Completer<UserRoadRoute>();
  RoadRoutingRequest? request;
  @override
  Future<UserRoadRoute> route(
    List<UserRouteStop> stops, {
    RoadRoutingRequest? request,
  }) {
    this.request = request;
    return response.future;
  }
}

const _roadResult = UserRoadRoute(
  points: [
    UserGeoPoint(lat: 10, lon: 20),
    UserGeoPoint(lat: 10.5, lon: 20.2),
    UserGeoPoint(lat: 11, lon: 21),
  ],
  distanceMeters: 2000,
  durationSeconds: 300,
);

MaterialApp _app(
  Widget child, {
  Locale locale = const Locale('en'),
  double scale = 1,
}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: child,
);

void main() {
  testWidgets(
    'stop form rejects invalid coordinates and keeps Unicode name/source ownership',
    (tester) async {
      UserRouteStop? result;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showModalBottomSheet<UserRouteStop>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const UserOperationRouteStopForm(
                      existing: UserRouteStop(
                        name: 'गोदाम 🚚',
                        latitude: 10,
                        longitude: 20,
                        sourceType: 'POI',
                        sourceId: '72',
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(2), '91');
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(result, isNull);
      expect(find.textContaining('valid latitude'), findsOneWidget);
      await tester.enterText(fields.at(2), '10');
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(result!.name, 'गोदाम 🚚');
      expect(result!.sourceType, 'POI');
      expect(result!.sourceId, '72');
    },
  );

  testWidgets('changing saved landmark coordinates clears its source ID', (
    tester,
  ) async {
    UserRouteStop? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showModalBottomSheet<UserRouteStop>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const UserOperationRouteStopForm(
                    existing: UserRouteStop(
                      name: 'Depot',
                      latitude: 10,
                      longitude: 20,
                      sourceType: 'POI',
                      sourceId: '72',
                    ),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(3), '20.1');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(result!.sourceId, isNull);
    expect(result!.sourceType, 'MANUAL');
  });

  testWidgets('Arabic stop form fits a narrow screen at enlarged text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      _app(
        const Scaffold(body: UserOperationRouteStopForm()),
        locale: const Locale('ar'),
        scale: 1.6,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      Directionality.of(
        tester.element(find.byType(UserOperationRouteStopForm)),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets(
    'routing unavailable shows error and never saves an invented route',
    (tester) async {
      final service = _LandmarkService(_route()),
          road = _RoadService(fail: true);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith((_) => _Auth()),
            userLandmarkServiceProvider.overrideWithValue(service),
            userRoadRouteServiceProvider.overrideWithValue(road),
            userRouteBuilderMapProvider.overrideWithValue(
              (_, _) => const SizedBox(),
            ),
          ],
          child: _app(UserOperationRouteBuilderScreen(initialRoute: _route())),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump();
      expect(road.calls, 1);
      expect(service.update, isNull);
      await tester.scrollUntilVisible(
        find.textContaining('No driving route'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('No driving route'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      road.dispose();
    },
  );

  testWidgets('permission denial exposes no route controls or mutation', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((_) => _Auth(allowed: false)),
        ],
        child: _app(const UserOperationRouteBuilderScreen()),
      ),
    );
    await tester.pump();
    expect(
      find.text('You do not have permission to create or edit routes.'),
      findsOneWidget,
    );
    expect(find.text('Save'), findsNothing);
    expect(find.byType(TextFormField), findsNothing);
  });
  testWidgets(
    'successful route edit returns saved ID and persists actual road vertices',
    (tester) async {
      final service = _LandmarkService(_route()), road = _RoadService();
      UserRouteLandmark? result;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith((_) => _Auth()),
            userLandmarkServiceProvider.overrideWithValue(service),
            userRoadRouteServiceProvider.overrideWithValue(road),
            userRouteBuilderMapProvider.overrideWithValue(
              (_, _) => const SizedBox(),
            ),
          ],
          child: _app(
            Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    result = await Navigator.of(context)
                        .push<UserRouteLandmark>(
                          MaterialPageRoute(
                            builder: (_) => UserOperationRouteBuilderScreen(
                              initialRoute: _route(),
                            ),
                          ),
                        );
                  },
                  child: const Text('Open route'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open route'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(result?.id, '9');
      expect(service.update?.stops?.length, 2);
      expect(service.update?.geodata?.coordinates.length, 3);
      expect(road.calls, 1);
      expect(service.update?.stops?.first.sourceId, '3');
      await tester.pumpWidget(const SizedBox());
      road.dispose();
    },
  );

  testWidgets('closing during road calculation cancels it without saving', (
    tester,
  ) async {
    final service = _LandmarkService(_route()), road = _DeferredRoadService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((_) => _Auth()),
          userLandmarkServiceProvider.overrideWithValue(service),
          userRoadRouteServiceProvider.overrideWithValue(road),
          userRouteBuilderMapProvider.overrideWithValue(
            (_, _) => const SizedBox(),
          ),
        ],
        child: _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push<UserRouteLandmark>(
                    MaterialPageRoute(
                      builder: (_) => UserOperationRouteBuilderScreen(
                        initialRoute: _route(),
                      ),
                    ),
                  );
                },
                child: const Text('Open route'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open route'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(road.request, isNotNull);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(road.request!.isCancelled, true);
    road.response.complete(_roadResult);
    await tester.pump();
    expect(service.update, isNull);
    expect(find.text('Open route'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    road.dispose();
  });

  for (final switchAccount in [false, true]) {
    testWidgets(
      'stale route cannot be saved after ${switchAccount ? 'account switch' : 'permission revocation'}',
      (tester) async {
        final auth = _Auth(),
            service = _LandmarkService(_route()),
            road = _DeferredRoadService();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith((_) => auth),
              userLandmarkServiceProvider.overrideWithValue(service),
              userRoadRouteServiceProvider.overrideWithValue(road),
              userRouteBuilderMapProvider.overrideWithValue(
                (_, _) => const SizedBox(),
              ),
            ],
            child: _app(
              UserOperationRouteBuilderScreen(initialRoute: _route()),
            ),
          ),
        );
        await tester.pump();
        await tester.pump();
        await tester.tap(find.text('Save'));
        await tester.pump();
        if (switchAccount) {
          auth.switchAccount();
        } else {
          auth.revoke();
        }
        await tester.pump();
        expect(road.request!.isCancelled, true);
        road.response.complete(_roadResult);
        await tester.pump();
        expect(service.update, isNull);
        expect(find.text('Save'), findsNothing);
        expect(
          find.text('You do not have permission to create or edit routes.'),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox());
        road.dispose();
      },
    );
  }
}
