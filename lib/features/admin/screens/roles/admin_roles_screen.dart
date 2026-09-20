import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';

class AdminRolesScreen extends ConsumerWidget {
  const AdminRolesScreen({super.key});

  // Static mirror data copied from the current web RolesContent page.
  // TODO: Replace with backend-driven roles when Admin Roles APIs exist.
  static const List<_RoleDefinition> _roles = [
    _RoleDefinition(
      name: 'Superadmin',
      icon: Icons.workspace_premium_outlined,
      userCount: '1',
      permissionSummary: 'All Access',
      description:
          'Platform-wide owner role shown by the current hardcoded web RolesContent page.',
      permissionCategories: _permissionCategories,
    ),
    _RoleDefinition(
      name: 'Admin',
      icon: Icons.admin_panel_settings_outlined,
      userCount: '3',
      permissionSummary: '45 Permissions',
      description:
          'Tenant administration role shown by the current hardcoded web RolesContent page.',
      permissionCategories: _permissionCategories,
    ),
    _RoleDefinition(
      name: 'Moderator',
      icon: Icons.verified_user_outlined,
      userCount: '8',
      permissionSummary: '22 Permissions',
      description:
          'Operational moderation role shown by the current hardcoded web RolesContent page.',
      permissionCategories: _permissionCategories,
    ),
    _RoleDefinition(
      name: 'User',
      icon: Icons.person_outline_rounded,
      userCount: '1234',
      permissionSummary: '12 Permissions',
      description:
          'Standard user role shown by the current hardcoded web RolesContent page.',
      permissionCategories: _permissionCategories,
    ),
    _RoleDefinition(
      name: 'Viewer',
      icon: Icons.visibility_outlined,
      userCount: '567',
      permissionSummary: '5 Permissions',
      description:
          'Read-only viewer role shown by the current hardcoded web RolesContent page.',
      permissionCategories: _permissionCategories,
    ),
    _RoleDefinition(
      name: 'Guest',
      icon: Icons.person_add_alt_1_outlined,
      userCount: '89',
      permissionSummary: '2 Permissions',
      description:
          'Limited guest role shown by the current hardcoded web RolesContent page.',
      permissionCategories: _permissionCategories,
    ),
  ];

  static const List<String> _permissionCategories = [
    'User Management',
    'Vehicle Control',
    'System Settings',
    'Reports & Analytics',
    'API Access',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpenVtsPageScaffold(
      title: 'Roles & Permissions',
      headerMode: OpenVtsPageHeaderMode.closeable,
      body: ListView.separated(
        padding: const EdgeInsets.all(OpenVtsSpacing.lg),
        itemCount: _roles.length,
        separatorBuilder: (_, __) => const SizedBox(height: OpenVtsSpacing.md),
        itemBuilder: (context, index) {
          return _RoleCard(role: _roles[index]);
        },
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  const _RoleCard({required this.role});

  final _RoleDefinition role;

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white12 : OpenVtsColors.border;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(OpenVtsSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                    ),
                    child: Icon(
                      widget.role.icon,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.role.name,
                          style: OpenVtsTypography.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.role.userCount} users · ${widget.role.permissionSummary}',
                          style: OpenVtsTypography.meta.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.role.description,
                          style: OpenVtsTypography.meta.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: _expanded ? null : 2,
                          overflow: _expanded ? null : TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                0,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: borderColor, height: 1),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  Text(
                    'Permission categories',
                    style: OpenVtsTypography.meta.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: OpenVtsSpacing.xs),
                  ...widget.role.permissionCategories.map(
                    (p) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: OpenVtsSpacing.xs / 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: OpenVtsSpacing.xs),
                          Expanded(
                            child: Text(
                              p,
                              style: OpenVtsTypography.body.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _RoleDefinition {
  const _RoleDefinition({
    required this.name,
    required this.icon,
    required this.userCount,
    required this.permissionSummary,
    required this.description,
    required this.permissionCategories,
  });

  final String name;
  final IconData icon;
  final String userCount;
  final String permissionSummary;
  final String description;
  final List<String> permissionCategories;
}
