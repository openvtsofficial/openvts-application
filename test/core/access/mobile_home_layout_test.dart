import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_role_home.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('mobile workspace fits a 320px screen at text scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => OpenVtsRoleHome(
              displayName: 'Open VTS Workspace',
              roleLabel: 'Team',
              items: const [
                OpenVtsRoleHomeItem(
                  label: 'Vehicles',
                  icon: Icons.local_shipping_outlined,
                  route: '/admin/vehicles',
                ),
                OpenVtsRoleHomeItem(
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  route: '/admin/settings',
                ),
              ],
              onToggleTheme: () {},
              onProfilePressed: () {},
              onNotificationsPressed: () {},
              notificationBadgeCount: 105,
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          theme: ThemeData(useMaterial3: true),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Vehicles'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('99+'), findsOneWidget);
    });
  }
}
