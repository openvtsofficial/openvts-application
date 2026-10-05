import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_role_home.dart';

const _homeRoute = '/home';
const _footerText = '© 2026 Open VTS All rights reserved.';
const _launcherItems = [
  OpenVtsRoleHomeItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    route: '/dashboard',
  ),
  OpenVtsRoleHomeItem(
    label: 'Vehicles',
    icon: Icons.local_shipping_outlined,
    route: '/vehicles',
  ),
  OpenVtsRoleHomeItem(label: 'Maps', icon: Icons.map_outlined, route: '/maps'),
  OpenVtsRoleHomeItem(
    label: 'Landmarks Studio',
    icon: Icons.place_outlined,
    route: '/landmarks-studio',
  ),
  OpenVtsRoleHomeItem(
    label: 'Route Optimisation',
    icon: Icons.alt_route_outlined,
    route: '/route-optimisation',
  ),
  OpenVtsRoleHomeItem(
    label: 'Notifications',
    icon: Icons.notifications_none_rounded,
    route: '/notifications',
  ),
  OpenVtsRoleHomeItem(
    label: 'Support',
    icon: Icons.support_agent_outlined,
    route: '/support',
  ),
  OpenVtsRoleHomeItem(
    label: 'Transactions',
    icon: Icons.receipt_long_outlined,
    route: '/transactions',
  ),
  OpenVtsRoleHomeItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    route: '/settings',
  ),
];

Future<void> _pumpRoleHome(
  WidgetTester tester, {
  required double width,
  double height = 900,
  ThemeMode themeMode = ThemeMode.light,
  List<OpenVtsRoleHomeItem> items = _launcherItems,
  int notificationBadgeCount = 7,
  double textScale = 1,
  bool accessAvailable = true,
  bool notificationsAllowed = true,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  final router = GoRouter(
    initialLocation: _homeRoute,
    routes: [
      GoRoute(
        path: _homeRoute,
        builder: (context, state) {
          return OpenVtsRoleHome(
            displayName: 'Quality Reviewer',
            roleLabel: 'User',
            items: items,
            notificationBadgeCount: notificationBadgeCount,
            onToggleTheme: () {},
            onNotificationsPressed: notificationsAllowed ? () {} : null,
            accessAvailable: accessAvailable,
            onProfilePressed: () {},
          );
        },
      ),
      for (final item in items)
        GoRoute(
          path: item.route,
          builder: (context, state) {
            return Scaffold(
              body: Center(child: Text('Destination ${item.route}')),
            );
          },
        ),
    ],
  );

  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
      routerConfig: router,
    ),
  );
  await tester.pumpAndSettle();
}

void _expectGridColumns(WidgetTester tester, int columnCount) {
  final labels = _launcherItems.map((item) => item.label).toList();
  final firstTile = find.ancestor(
    of: find.text(labels.first),
    matching: find.byType(InkWell),
  );
  final firstRowY = tester.getTopLeft(firstTile).dy;

  for (var index = 0; index < columnCount; index++) {
    final tileFinder = find.ancestor(
      of: find.text(labels[index]),
      matching: find.byType(InkWell),
    );
    final tileY = tester.getTopLeft(tileFinder).dy;
    expect((tileY - firstRowY).abs(), lessThan(2.0));
  }

  final nextRowTile = find.ancestor(
    of: find.text(labels[columnCount]),
    matching: find.byType(InkWell),
  );
  final nextRowY = tester.getTopLeft(nextRowTile).dy;
  expect(nextRowY, greaterThan(firstRowY + 8));
}

void main() {
  group('resolveProfileImageUrl', () {
    test('resolves relative paths against the API base path', () {
      final resolved = resolveProfileImageUrl(
        'https://app.openvts.io/api',
        'uploads/profile.jpg',
      );

      expect(resolved, 'https://app.openvts.io/api/uploads/profile.jpg');
    });

    test('resolves absolute-path URLs against the origin root', () {
      final resolved = resolveProfileImageUrl(
        'https://app.openvts.io/api',
        '/uploads/profile.jpg',
      );

      expect(resolved, 'https://app.openvts.io/uploads/profile.jpg');
    });

    test('preserves fully qualified URLs', () {
      final resolved = resolveProfileImageUrl(
        'https://app.openvts.io/api',
        'https://cdn.openvts.io/profile.jpg',
      );

      expect(resolved, 'https://cdn.openvts.io/profile.jpg');
    });
  });

  group('OpenVtsRoleHome launcher layout', () {
    for (final viewport in const <int, int>{
      320: 3,
      360: 3,
      390: 3,
      412: 3,
      430: 3,
      520: 4,
      768: 5,
      980: 6,
      1024: 6,
    }.entries) {
      testWidgets(
        'shows ${viewport.value} columns at ${viewport.key.toInt()} width',
        (tester) async {
          await _pumpRoleHome(tester, width: viewport.key.toDouble());
          _expectGridColumns(tester, viewport.value);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('large text keeps compact icons with enough space for labels', (
      tester,
    ) async {
      await _pumpRoleHome(tester, width: 390, textScale: 2);
      _expectGridColumns(tester, 2);
      await tester.scrollUntilVisible(
        find.text(_footerText),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(_footerText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps long labels capped to two lines on mobile', (
      tester,
    ) async {
      await _pumpRoleHome(tester, width: 360);

      final routeOptimisation = tester.widget<Text>(
        find.text('Route Optimisation'),
      );
      final landmarksStudio = tester.widget<Text>(
        find.text('Landmarks Studio'),
      );

      expect(routeOptimisation.maxLines, 2);
      expect(routeOptimisation.overflow, TextOverflow.ellipsis);
      expect(landmarksStudio.maxLines, 2);
      expect(landmarksStudio.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps launcher icon targets at least 44dp on mobile', (
      tester,
    ) async {
      await _pumpRoleHome(tester, width: 320);

      final iconBoxSize = tester.getSize(
        find.ancestor(
          of: find.text('Dashboard'),
          matching: find.byType(InkWell),
        ),
      );

      expect(iconBoxSize.width, greaterThanOrEqualTo(44));
      expect(iconBoxSize.height, greaterThanOrEqualTo(44));
    });

    testWidgets(
      'renders notification badge, avatar fallback, and light theme',
      (tester) async {
        await _pumpRoleHome(tester, width: 390, notificationBadgeCount: 7);

        expect(find.text('7'), findsOneWidget);
        expect(find.text('QR'), findsOneWidget);
        expect(find.byTooltip('Profile'), findsOneWidget);
        expect(find.text('User workspace'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('renders cleanly in dark theme', (tester) async {
      await _pumpRoleHome(tester, width: 390, themeMode: ThemeMode.dark);

      expect(find.text('User workspace'), findsOneWidget);
      expect(find.byTooltip('Light mode'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(_footerText),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(_footerText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('exposes launcher icons as accessible buttons', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await _pumpRoleHome(tester, width: 390);
        expect(find.bySemanticsLabel(RegExp('Dashboard')), findsOneWidget);
        final node = tester.getSemantics(
          find.bySemanticsLabel(RegExp('Dashboard')),
        );
        expect(
          node,
          matchesSemantics(
            isButton: true,
            hasTapAction: true,
            hasFocusAction: true,
            isFocusable: true,
            label: 'Dashboard',
          ),
        );
      } finally {
        semantics.dispose();
      }
    });

    testWidgets(
      'shows only supplied permitted items and hides unauthorized notifications',
      (tester) async {
        await _pumpRoleHome(
          tester,
          width: 390,
          items: [_launcherItems.first],
          notificationsAllowed: false,
        );
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Vehicles'), findsNothing);
        expect(find.byTooltip('Notifications'), findsNothing);
      },
    );

    testWidgets('unavailable access explains how to retry an empty workspace', (
      tester,
    ) async {
      await _pumpRoleHome(
        tester,
        width: 390,
        items: [],
        accessAvailable: false,
      );
      expect(
        find.text(
          'Workspace access could not be refreshed. Pull down to retry.',
        ),
        findsOneWidget,
      );
      expect(find.text('Dashboard'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'header keeps Language, theme, notifications, profile order and 48dp targets',
      (tester) async {
        await _pumpRoleHome(tester, width: 320, height: 568);
        final keys = [
          'home-language',
          'home-theme',
          'home-notifications',
          'home-profile',
        ];
        double previousEnd = 0;
        for (final key in keys) {
          final action = find.byKey(ValueKey(key));
          final rect = tester.getRect(action);
          expect(rect.left, greaterThanOrEqualTo(previousEnd));
          expect(rect.width, greaterThanOrEqualTo(48));
          expect(rect.height, greaterThanOrEqualTo(48));
          previousEnd = rect.right;
        }
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'extreme accessibility text scrolls without overflow on a narrow phone',
      (tester) async {
        await _pumpRoleHome(tester, width: 320, height: 568, textScale: 3);
        _expectGridColumns(tester, 1);
        await tester.scrollUntilVisible(
          find.text(_footerText),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'restores centered icon boxes and labels instead of dashboard cards',
      (tester) async {
        await _pumpRoleHome(tester, width: 390);
        final icon = find.byIcon(Icons.dashboard_outlined);
        final label = find.text('Dashboard');
        expect(
          tester.getCenter(icon).dx,
          closeTo(tester.getCenter(label).dx, 1),
        );
        expect(
          tester.getBottomLeft(icon).dy,
          lessThan(tester.getTopLeft(label).dy),
        );
        final iconBox = find.ancestor(
          of: icon,
          matching: find.byType(AnimatedContainer),
        );
        expect(tester.getSize(iconBox), const Size(54, 54));
        expect(find.byIcon(Icons.arrow_outward_rounded), findsNothing);
      },
    );

    testWidgets('navigates when a launcher item is tapped', (tester) async {
      await _pumpRoleHome(tester, width: 390);

      await tester.tap(find.text('Landmarks Studio'));
      await tester.pumpAndSettle();

      expect(find.text('Destination /landmarks-studio'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('scrolls long launcher lists and reaches the footer', (
      tester,
    ) async {
      final items = List<OpenVtsRoleHomeItem>.generate(18, (index) {
        return OpenVtsRoleHomeItem(
          label: 'Item ${index + 1}',
          icon: Icons.apps_outlined,
          route: '/item-${index + 1}',
        );
      });

      await _pumpRoleHome(tester, width: 320, height: 640, items: items);

      await tester.scrollUntilVisible(
        find.text(_footerText),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text(_footerText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps footer below the grid on wide layouts', (tester) async {
      await _pumpRoleHome(tester, width: 1024);

      final footerTop = tester.getTopLeft(find.text(_footerText)).dy;
      final lastGridLabelBottom = tester
          .getBottomLeft(find.text('Settings'))
          .dy;

      expect(footerTop, greaterThan(lastGridLabelBottom));
      expect(tester.takeException(), isNull);
    });
  });
}
