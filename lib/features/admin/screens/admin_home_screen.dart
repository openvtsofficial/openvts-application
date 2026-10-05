import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_preferences_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/utils/permission_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/user_role.dart';
import '../../../shared/widgets/open_vts_role_home.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/admin_providers.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  List<OpenVtsRoleHomeItem> _items(AppLocalizations l10n) => [
    OpenVtsRoleHomeItem(
      label: l10n.dashboard,
      icon: Icons.dashboard_outlined,
      route: RoutePaths.adminDashboard,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.users,
      icon: Icons.people_outline_rounded,
      route: RoutePaths.adminUsers,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.vehicles,
      icon: Icons.local_shipping_outlined,
      route: RoutePaths.adminVehicles,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.drivers,
      icon: Icons.badge_outlined,
      route: RoutePaths.adminDrivers,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.team,
      icon: Icons.groups_2_outlined,
      route: RoutePaths.adminTeam,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.inventory,
      icon: Icons.inventory_2_outlined,
      route: RoutePaths.adminInventory,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.map,
      icon: Icons.map_outlined,
      route: RoutePaths.adminMap,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.payments,
      icon: Icons.payments_outlined,
      route: RoutePaths.adminPayments,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.support,
      icon: Icons.support_agent_outlined,
      route: RoutePaths.adminSupport,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.calendar,
      icon: Icons.calendar_month_outlined,
      route: RoutePaths.adminCalendar,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.logs,
      icon: Icons.description_outlined,
      route: RoutePaths.adminLogs,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.plans,
      icon: Icons.sell_outlined,
      route: RoutePaths.adminPlans,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.settings,
      icon: Icons.settings_outlined,
      route: RoutePaths.adminSettings,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.transactions,
      icon: Icons.receipt_long_outlined,
      route: RoutePaths.adminTransactions,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final baseUrl = ref.watch(apiBaseUrlProvider);
    final canNotify = PermissionHelper.canAccessUserPath(
      user,
      RoutePaths.adminNotifications,
    );
    final unreadCount = canNotify
        ? ref
              .watch(adminNotificationUnreadBadgeProvider)
              .maybeWhen(data: (v) => v, orElse: () => 0)
        : 0;

    return OpenVtsRoleHome(
      displayName: user?.name.isNotEmpty == true ? user!.name : l10n.adminRole,
      roleLabel: user?.role == UserRole.team ? l10n.team : l10n.adminRole,
      accessAvailable: user?.accessLoaded ?? false,
      onRefresh: () =>
          ref.read(authControllerProvider.notifier).refreshAccess(),
      profileImageUrl: resolveProfileImageUrl(baseUrl, user?.profileUrl),
      items: _items(l10n)
          .where((item) => PermissionHelper.canAccessUserPath(user, item.route))
          .toList(),
      onToggleTheme: () async {
        await ref.read(themeModeProvider.notifier).toggle();
        ref.invalidate(appLocalizationPreferencesProvider);
      },
      notificationBadgeCount: unreadCount,
      onNotificationsPressed: !canNotify
          ? null
          : () {
              ref.invalidate(adminNotificationUnreadBadgeProvider);
              context.push(RoutePaths.adminNotifications);
            },
      onProfilePressed: () => context.push(RoutePaths.adminProfile),
    );
  }
}
