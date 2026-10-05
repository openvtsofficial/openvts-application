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
import '../controllers/user_providers.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  List<OpenVtsRoleHomeItem> _items(AppLocalizations l10n) => [
    OpenVtsRoleHomeItem(
      label: l10n.dashboard,
      icon: Icons.bar_chart_outlined,
      route: RoutePaths.userDashboard,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.vehicles,
      icon: Icons.sync_alt_rounded,
      route: RoutePaths.userVehicles,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.map,
      icon: Icons.map_outlined,
      route: RoutePaths.userMap,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.reportsTitle,
      icon: Icons.analytics_outlined,
      route: RoutePaths.userReports,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.landmarksStudio,
      icon: Icons.place_outlined,
      route: RoutePaths.userLandmarksStudio,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.trackLinks,
      icon: Icons.share_outlined,
      route: RoutePaths.userTrackLinks,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.support,
      icon: Icons.help_outline_rounded,
      route: RoutePaths.userSupport,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.messages,
      icon: Icons.chat_bubble_outline,
      route: RoutePaths.userMessages,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.transactions,
      icon: Icons.receipt_long_outlined,
      route: RoutePaths.userTransactions,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.settings,
      icon: Icons.settings_outlined,
      route: RoutePaths.userSettings,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.accounts,
      icon: Icons.people_outline_rounded,
      route: RoutePaths.userAccounts,
    ),
    OpenVtsRoleHomeItem(
      label: l10n.notifications,
      icon: Icons.notifications_none_rounded,
      route: RoutePaths.userNotifications,
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
      RoutePaths.userNotificationCenter,
    );
    final unreadCount = canNotify
        ? ref
              .watch(userNotificationUnreadBadgeProvider)
              .maybeWhen(data: (v) => v, orElse: () => 0)
        : 0;

    return OpenVtsRoleHome(
      displayName: user?.name.isNotEmpty == true ? user!.name : l10n.userRole,
      roleLabel: authState.isDemo
          ? l10n.demoReadOnly
          : user?.role == UserRole.subuser
          ? l10n.subuserRole
          : l10n.userRole,
      accessAvailable: user?.accessLoaded ?? false,
      onRefresh: () =>
          ref.read(authControllerProvider.notifier).refreshAccess(),
      profileImageUrl: resolveProfileImageUrl(baseUrl, user?.profileUrl),
      items:
          [
                ..._items(l10n),
                OpenVtsRoleHomeItem(
                  label: l10n.operations,
                  icon: Icons.route_outlined,
                  route: RoutePaths.userOperations,
                ),
              ]
              .where(
                (item) => PermissionHelper.canAccessUserPath(user, item.route),
              )
              .toList(),
      onToggleTheme: () async {
        await ref.read(themeModeProvider.notifier).toggle();
        ref.invalidate(appLocalizationPreferencesProvider);
      },
      notificationBadgeCount: unreadCount,
      onNotificationsPressed: !canNotify
          ? null
          : () {
              ref.invalidate(userNotificationUnreadBadgeProvider);
              context.push(RoutePaths.userNotificationCenter);
            },
      onProfilePressed: () => context.push(RoutePaths.userProfile),
    );
  }
}
