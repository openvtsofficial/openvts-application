import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../models/user_vehicle_state.dart';

class UserVehicleStatusSegment extends StatelessWidget {
  const UserVehicleStatusSegment({
    required this.current,
    required this.onChanged,
    this.counts,
    super.key,
  });

  final UserVehicleStatusFilter current;
  final ValueChanged<UserVehicleStatusFilter> onChanged;
  final Map<UserVehicleStatusFilter, int>? counts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: UserVehicleStatusFilter.values.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: OpenVtsSpacing.xs),
        itemBuilder: (context, index) {
          final filter = UserVehicleStatusFilter.values[index];
          return _TabChip(
            filter: filter,
            isSelected: filter == current,
            count: counts?[filter],
            onTap: () => onChanged(filter),
          );
        },
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.filter,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  final UserVehicleStatusFilter filter;
  final bool isSelected;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isSelected
        ? OpenVtsColors.brandInk
        : Theme.of(context).colorScheme.surface;
    final foreground = isSelected
        ? (isDark ? OpenVtsColors.darkTextPrimary : OpenVtsColors.white)
        : Theme.of(context).colorScheme.onSurface;
    final borderColor = isSelected
        ? OpenVtsColors.brandInk
        : Theme.of(context).colorScheme.outlineVariant;

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (filter.icon != null) ...[
                Icon(filter.icon, size: 14, color: foreground),
                const SizedBox(width: 5),
              ],
              Text(
                filter.label,
                style: OpenVtsTypography.meta.copyWith(
                  color: foreground,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(width: 5),
                _CountBadge(
                  count: count!,
                  isSelected: isSelected,
                  foreground: foreground,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.count,
    required this.isSelected,
    required this.foreground,
  });

  final int count;
  final bool isSelected;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
      ),
      child: Text(
        count.toString(),
        style: OpenVtsTypography.meta.copyWith(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}

extension UserVehicleStatusFilterX on UserVehicleStatusFilter {
  String get label {
    return switch (this) {
      UserVehicleStatusFilter.all => 'All',
      UserVehicleStatusFilter.active => 'Active',
      UserVehicleStatusFilter.inactive => 'Inactive',
      UserVehicleStatusFilter.licenseBlocked => 'License Blocked',
    };
  }

  IconData? get icon {
    return switch (this) {
      UserVehicleStatusFilter.all => Icons.check_circle_outline,
      UserVehicleStatusFilter.active => Icons.check_circle,
      UserVehicleStatusFilter.inactive => Icons.cancel_outlined,
      UserVehicleStatusFilter.licenseBlocked => Icons.block_outlined,
    };
  }
}
