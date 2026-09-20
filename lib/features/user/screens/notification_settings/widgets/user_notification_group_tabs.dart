import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/user_notification_settings_model.dart';

class UserNotificationGroupTabs extends StatelessWidget {
  const UserNotificationGroupTabs({
    required this.selectedGroup,
    required this.onChanged,
    super.key,
  });

  final UserNotificationGroup selectedGroup;
  final ValueChanged<UserNotificationGroup> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = <_GroupTabItem>[
      const _GroupTabItem(
        group: UserNotificationGroup.basic,
        label: 'Basic',
        icon: Icons.bolt_rounded,
      ),
      const _GroupTabItem(
        group: UserNotificationGroup.overspeed,
        label: 'Overspeed',
        icon: Icons.speed_rounded,
      ),
      const _GroupTabItem(
        group: UserNotificationGroup.duration,
        label: 'Duration',
        icon: Icons.timer_outlined,
      ),
      const _GroupTabItem(
        group: UserNotificationGroup.geofence,
        label: 'Geofence',
        icon: Icons.location_on_outlined,
      ),
      const _GroupTabItem(
        group: UserNotificationGroup.route,
        label: 'Route',
        icon: Icons.alt_route_rounded,
      ),
    ];

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.xs),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chips = tabs
              .map(
                (item) => _GroupChoiceChip(
                  item: item,
                  selected: selectedGroup == item.group,
                  onTap: () => onChanged(item.group),
                ),
              )
              .toList(growable: false);

          if (constraints.maxWidth < 360) {
            return Wrap(
              spacing: OpenVtsSpacing.xs,
              runSpacing: OpenVtsSpacing.xs,
              children: chips,
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips
                  .map(
                    (chip) => Padding(
                      padding: const EdgeInsets.only(right: OpenVtsSpacing.xs),
                      child: chip,
                    ),
                  )
                  .toList(growable: false),
            ),
          );
        },
      ),
    );
  }
}

class _GroupChoiceChip extends StatelessWidget {
  const _GroupChoiceChip({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _GroupTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        selected ? (isDark ? Colors.black : Colors.white) : Colors.transparent;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor =
        isDark ? Colors.white : Colors.black.withValues(alpha: 0.2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: OpenVtsSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 15,
                color: textColor,
              ),
              const SizedBox(width: OpenVtsSpacing.xxs),
              Text(
                item.label,
                style: OpenVtsTypography.meta.copyWith(
                  height: 1,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupTabItem {
  const _GroupTabItem({
    required this.group,
    required this.label,
    required this.icon,
  });

  final UserNotificationGroup group;
  final String label;
  final IconData icon;
}
