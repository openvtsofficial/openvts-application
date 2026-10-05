import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/permission_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/open_vts_role_home.dart';
import '../../auth/controllers/auth_controller.dart';

class DriverHomeScreen extends ConsumerWidget {
  const DriverHomeScreen({super.key});
  List<OpenVtsRoleHomeItem> _items(AppLocalizations l10n) => [
    OpenVtsRoleHomeItem(
      label: l10n.dashboard,
      icon: Icons.dashboard_outlined,
      route: RoutePaths.driverDashboard,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.trips,
      icon: Icons.route_outlined,
      route: RoutePaths.driverTrips,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.calendar,
      icon: Icons.calendar_month_outlined,
      route: RoutePaths.driverCalendar,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.documents,
      icon: Icons.folder_outlined,
      route: RoutePaths.driverDocuments,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.settings,
      icon: Icons.settings_outlined,
      route: RoutePaths.driverSettings,
    ),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider).user;
    return OpenVtsRoleHome(
      displayName: user?.name ?? l10n.driverRole,
      roleLabel: l10n.driverRole,
      profileImageUrl: resolveProfileImageUrl(
        ref.watch(apiBaseUrlProvider),
        user?.profileUrl,
      ),
      accessAvailable: user?.accessLoaded ?? false,
      onRefresh: () =>
          ref.read(authControllerProvider.notifier).refreshAccess(),
      items: _items(l10n)
          .where((item) => PermissionHelper.canAccessUserPath(user, item.route))
          .toList(),
      onToggleTheme: () async {
        await ref.read(themeModeProvider.notifier).toggle();
        ref.invalidate(appLocalizationPreferencesProvider);
      },
      onNotificationsPressed: () =>
          context.push(RoutePaths.driverNotifications),
      onProfilePressed: () => context.push(RoutePaths.driverProfile),
    );
  }
}
