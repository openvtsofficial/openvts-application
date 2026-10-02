import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/controllers/user_share_track_link_controller.dart';
import 'package:open_vts/features/user/models/user_share_track_link_model.dart';
import 'package:open_vts/features/user/screens/track_links/widgets/user_share_track_link_form_sheet.dart';
import 'package:open_vts/features/user/services/user_share_track_link_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final count in const [5, 50, 500]) {
    testWidgets('$count vehicles stay in a bounded selection region',
        (tester) async {
      await _pumpSheet(tester, _vehicles(count));

      expect(
        tester
            .getSize(find.byKey(const Key('track-link-vehicle-list-frame')))
            .height,
        lessThanOrEqualTo(280),
      );
      expect(find.text('Expiry Date/Time'), findsOneWidget);
      final formScrollable = find.descendant(
        of: find.byKey(const Key('track-link-form-scroll')),
        matching: find.byType(Scrollable),
      );
      tester.state<ScrollableState>(formScrollable.first).position.jumpTo(500);
      await tester.pump();
      expect(find.text('Options'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('large list scrolls internally and preserves multi-selection',
      (tester) async {
    await _pumpSheet(tester, _vehicles(500));

    final list = find.byKey(const Key('track-link-vehicle-list'));
    final scrollable = find.descendant(
      of: list,
      matching: find.byType(Scrollable),
    );
    final before = tester.state<ScrollableState>(scrollable).position.pixels;

    await tester.drag(list, const Offset(0, -600));
    await tester.pumpAndSettle();

    final after = tester.state<ScrollableState>(scrollable).position.pixels;
    expect(after, greaterThan(before));

    await tester.enterText(find.byType(TextField), 'Vehicle 499');
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('track-link-vehicle-500')),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Vehicle 42');
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('track-link-vehicle-43')),
    );
    await tester.pump();

    expect(find.text('2 selected'), findsOneWidget);
  });

  testWidgets('search filters vehicles and blocked licence remains disabled',
      (tester) async {
    final vehicles = _vehicles(50).toList();
    vehicles[17] = const UserShareTrackVehicle(
      id: '18',
      name: 'Blocked Truck',
      plateNumber: 'BLOCK-18',
      isLicenseBlocked: true,
    );
    await _pumpSheet(tester, vehicles);

    await tester.enterText(find.byType(TextField), 'BLOCK-18');
    await tester.pumpAndSettle();

    expect(find.text('Blocked Truck'), findsOneWidget);
    final row = find.byKey(const ValueKey('track-link-vehicle-18'));
    final checkbox = tester.widget<Checkbox>(
      find.descendant(of: row, matching: find.byType(Checkbox)),
    );
    expect(checkbox.onChanged, isNull);

    await tester.tap(row);
    await tester.pump();
    expect(find.text('0 selected'), findsOneWidget);
  });
}

Future<void> _pumpSheet(
  WidgetTester tester,
  List<UserShareTrackVehicle> vehicles,
) async {
  final service = _VehicleService(vehicles);
  final controller = UserShareTrackLinkController(service: service);
  final scrollController = ScrollController();
  addTearDown(scrollController.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userShareTrackLinkControllerProvider.overrideWith((ref) => controller),
        appDateFormatterProvider.overrideWithValue(
          const AppDateFormatter(
            datePattern: 'DD MMM YYYY',
            use24Hour: false,
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 800,
            child: UserShareTrackLinkFormSheet(
              scrollController: scrollController,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

List<UserShareTrackVehicle> _vehicles(int count) {
  return List.generate(
    count,
    (index) => UserShareTrackVehicle(
      id: '${index + 1}',
      name: 'Vehicle $index',
      plateNumber: 'PLATE-$index',
      isLicenseBlocked: false,
    ),
  );
}

class _VehicleService extends UserShareTrackLinkService {
  _VehicleService(this.vehicles) : super(ApiClient(Dio()));

  final List<UserShareTrackVehicle> vehicles;

  @override
  Future<List<UserShareTrackVehicle>> getVehicles() async => vehicles;
}
