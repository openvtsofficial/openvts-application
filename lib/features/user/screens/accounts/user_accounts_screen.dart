import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';

class UserAccountsScreen extends ConsumerWidget {
  const UserAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubuser = ref.watch(
      authControllerProvider.select((state) => state.user?.isSubuser == true),
    );
    return OpenVtsPageScaffold(
      title: 'Accounts',
      headerMode: OpenVtsPageHeaderMode.closeable,
      padding: const EdgeInsets.fromLTRB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.xs,
        OpenVtsSpacing.sm,
        0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth >= 760;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: OpenVtsSpacing.lg),
                children: [
                  const _AccountsHeaderCard(),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  if (useTwoColumns)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: _AccountsOptionCard(
                            icon: Icons.badge_outlined,
                            title: 'Drivers',
                            description:
                                'Create drivers, manage assigned vehicles, documents, and driver activity.',
                            ctaLabel: 'Open Drivers',
                            route: RoutePaths.userDrivers,
                          ),
                        ),
                        if (!isSubuser) ...[
                          const SizedBox(width: OpenVtsSpacing.sm),
                          const Expanded(
                            child: _AccountsOptionCard(
                              icon: Icons.groups_2_outlined,
                              title: 'Sub Users',
                              description:
                                  'Create sub users and control which vehicles they can access.',
                              ctaLabel: 'Open Sub Users',
                              route: RoutePaths.userSubUsers,
                            ),
                          ),
                        ],
                      ],
                    )
                  else
                    Column(
                      children: [
                        const _AccountsOptionCard(
                          icon: Icons.badge_outlined,
                          title: 'Drivers',
                          description:
                              'Create drivers, manage assigned vehicles, documents, and driver activity.',
                          ctaLabel: 'Open Drivers',
                          route: RoutePaths.userDrivers,
                        ),
                        if (!isSubuser) ...[
                          const SizedBox(height: OpenVtsSpacing.sm),
                          const _AccountsOptionCard(
                            icon: Icons.groups_2_outlined,
                            title: 'Sub Users',
                            description:
                                'Create sub users and control which vehicles they can access.',
                            ctaLabel: 'Open Sub Users',
                            route: RoutePaths.userSubUsers,
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AccountsHeaderCard extends StatelessWidget {
  const _AccountsHeaderCard();

  @override
  Widget build(BuildContext context) {
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            ),
            child: Icon(
              Icons.manage_accounts_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accounts',
                  style: OpenVtsTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: OpenVtsSpacing.xxs),
                Text(
                  'Manage the accounts linked to your fleet.',
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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

class _AccountsOptionCard extends StatelessWidget {
  const _AccountsOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.ctaLabel,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String description;
  final String ctaLabel;
  final String route;

  @override
  Widget build(BuildContext context) {
    void openRoute() => context.push(route);

    return OpenVtsCard(
      onTap: openRoute,
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: OpenVtsTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Text(
            description,
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsButton(
            label: ctaLabel,
            variant: OpenVtsButtonVariant.secondary,
            height: 40,
            trailingIcon: Icons.chevron_right_rounded,
            onPressed: openRoute,
          ),
        ],
      ),
    );
  }
}
