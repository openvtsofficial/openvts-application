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
import '../controllers/superadmin_providers.dart';

class SuperadminHomeScreen extends ConsumerWidget {
  const SuperadminHomeScreen({super.key});

  List<OpenVtsRoleHomeItem> _items(AppLocalizations l10n) => [
    OpenVtsRoleHomeItem(
      label: l10n.dashboard,
      icon: Icons.dashboard_outlined,
      route: RoutePaths.superadminDashboard,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.administrators,
      icon: Icons.admin_panel_settings_outlined,
      route: RoutePaths.superadminAdministrators,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.vehicles,
      icon: Icons.local_shipping_outlined,
      route: RoutePaths.superadminVehicles,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.map,
      icon: Icons.map_outlined,
      route: RoutePaths.superadminMap,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.calendar,
      icon: Icons.calendar_month_outlined,
      route: RoutePaths.superadminCalendar,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.server,
      icon: Icons.dns_outlined,
      route: RoutePaths.superadminServer,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.support,
      icon: Icons.support_agent_outlined,
      route: RoutePaths.superadminSupport,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.payments,
      icon: Icons.payments_outlined,
      route: RoutePaths.superadminPayments,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.settings,
      icon: Icons.settings_outlined,
      route: RoutePaths.superadminSettings,
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
      RoutePaths.superadminNotifications,
    );
    final unreadCount = canNotify
        ? ref
              .watch(superadminNotificationUnreadBadgeProvider)
              .maybeWhen(data: (v) => v, orElse: () => 0)
        : 0;

    return OpenVtsRoleHome(
      displayName: user?.name.isNotEmpty == true
          ? user!.name
          : l10n.superadminRole,
      roleLabel: l10n.superadminRole,
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
              ref.invalidate(superadminNotificationUnreadBadgeProvider);
              context.push(RoutePaths.superadminNotifications);
            },
      onProfilePressed: () => context.push(RoutePaths.superadminProfile),
    );
  }
}
