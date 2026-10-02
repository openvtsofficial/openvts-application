import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/router/route_paths.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../models/admin_dashboard_model.dart';
import 'admin_dashboard_list_card.dart';

class AdminRecentUsersCard extends ConsumerWidget {
  const AdminRecentUsersCard({required this.users, super.key});

  final List<AdminRecentUser> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(appDateFormatterProvider);

    return AdminDashboardListCard(
      title: 'Recent Users',
      icon: Icons.people_outline_rounded,
      viewAllRoute: RoutePaths.adminUsers,
      emptyTitle: 'No recent users',
      emptyMessage: 'New users will appear here.',
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _RecentUserRow(user: users[index], formatter: formatter);
      },
    );
  }
}

class _RecentUserRow extends StatelessWidget {
  const _RecentUserRow({required this.user, required this.formatter});

  final AdminRecentUser user;
  final AppDateFormatter formatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.md,
        vertical: OpenVtsSpacing.sm,
      ),
      child: Row(
        children: [
          AdminDashboardInitialsAvatar(name: user.name),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  adminDashboardContactLabel(
                    email: user.email,
                    username: user.username,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 92),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.vehicleCount != null)
                  Text(
                    '${user.vehicleCount} ${user.vehicleCount == 1 ? 'vehicle' : 'vehicles'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: OpenVtsTypography.meta.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  adminDashboardRelativeDate(user.createdAt,
                      formatter: formatter),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
