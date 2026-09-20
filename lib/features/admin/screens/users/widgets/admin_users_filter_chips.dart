import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../models/admin_users_model.dart';
import '../../../models/admin_users_state.dart';

class AdminUsersFilterChips extends StatelessWidget {
  const AdminUsersFilterChips({
    required this.statusFilter,
    required this.verifiedFilter,
    required this.countryFilter,
    required this.countryOptions,
    required this.onStatusChanged,
    required this.onVerifiedChanged,
    required this.onCountryChanged,
    super.key,
  });

  final AdminUserStatusFilter statusFilter;
  final AdminUserVerifiedFilter verifiedFilter;

  /// The currently selected country code (canonical, e.g. "IN"), or null.
  final String? countryFilter;

  /// Resolved [AdminUserCountryOption] list — value is the canonical code,
  /// label is the readable name. Built once by the screen and passed down.
  final List<AdminUserCountryOption> countryOptions;

  final ValueChanged<AdminUserStatusFilter> onStatusChanged;
  final ValueChanged<AdminUserVerifiedFilter> onVerifiedChanged;
  final ValueChanged<String?> onCountryChanged;

  @override
  Widget build(BuildContext context) {
    final showCountryFilters = countryOptions.length > 1;

    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          _AdminFilterChip(
            label: 'All',
            selected: statusFilter == AdminUserStatusFilter.all,
            onTap: () => onStatusChanged(AdminUserStatusFilter.all),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _AdminFilterChip(
            label: 'Active',
            selected: statusFilter == AdminUserStatusFilter.active,
            onTap: () => onStatusChanged(AdminUserStatusFilter.active),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _AdminFilterChip(
            label: 'Inactive',
            selected: statusFilter == AdminUserStatusFilter.inactive,
            onTap: () => onStatusChanged(AdminUserStatusFilter.inactive),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _AdminFilterChip(
            label: 'All',
            selected: verifiedFilter == AdminUserVerifiedFilter.all,
            onTap: () => onVerifiedChanged(AdminUserVerifiedFilter.all),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _AdminFilterChip(
            label: 'Verified',
            selected: verifiedFilter == AdminUserVerifiedFilter.verified,
            onTap: () => onVerifiedChanged(AdminUserVerifiedFilter.verified),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _AdminFilterChip(
            label: 'Unverified',
            selected: verifiedFilter == AdminUserVerifiedFilter.unverified,
            onTap: () => onVerifiedChanged(AdminUserVerifiedFilter.unverified),
          ),
          if (showCountryFilters) ...[
            const SizedBox(width: OpenVtsSpacing.xs),
            _CountryFilterChip(
              countryFilter: countryFilter,
              countryOptions: countryOptions,
              onCountryChanged: onCountryChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _CountryFilterChip extends StatelessWidget {
  const _CountryFilterChip({
    required this.countryFilter,
    required this.countryOptions,
    required this.onCountryChanged,
  });

  /// Canonical country code currently selected, or null for "All Countries".
  final String? countryFilter;

  /// Resolved options: [AdminUserCountryOption.value] is the canonical code,
  /// [AdminUserCountryOption.label] is the readable name.
  final List<AdminUserCountryOption> countryOptions;

  final ValueChanged<String?> onCountryChanged;

  @override
  Widget build(BuildContext context) {
    final selected = countryFilter != null;

    // Display the readable label for the selected code; fall back to the
    // code itself if for some reason no option matches.
    String label;
    if (selected) {
      final match = countryOptions.where(
        (o) => o.value == countryFilter,
      );
      label = match.isNotEmpty ? match.first.label : countryFilter!;
    } else {
      label = 'All Countries';
    }

    return PopupMenuButton<String>(
      tooltip: 'Country filter',
      onSelected: (value) => onCountryChanged(value.isEmpty ? null : value),
      itemBuilder: (context) {
        return [
          _menuItem('', 'All Countries', countryFilter == null),
          for (final option in countryOptions)
            _menuItem(
                option.value, option.label, countryFilter == option.value),
        ];
      },
      child: Material(
        color: selected
            ? (Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : OpenVtsColors.white)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          side: selected
              ? BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : OpenVtsColors.border,
                  width: 1,
                )
              : BorderSide.none,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 34),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: OpenVtsSpacing.sm,
              vertical: OpenVtsSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.public_rounded,
                  size: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : OpenVtsColors.brandInk,
                ),
                const SizedBox(width: OpenVtsSpacing.xxs),
                Text(
                  label,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : OpenVtsColors.brandInk,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xxs),
                Icon(
                  Icons.expand_more_rounded,
                  size: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : OpenVtsColors.brandInk,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(
    String value,
    String label,
    bool selected,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_rounded : Icons.public_rounded,
            size: 18,
            color: OpenVtsColors.textSecondary,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Text(label, style: OpenVtsTypography.label),
        ],
      ),
    );
  }
}

class _AdminFilterChip extends StatelessWidget {
  const _AdminFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        selected ? (isDark ? Colors.black : Colors.white) : Colors.transparent;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor =
        isDark ? Colors.white : Colors.black.withValues(alpha: 0.2);

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        side: selected
            ? BorderSide(color: borderColor, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 34),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: OpenVtsSpacing.sm,
              vertical: OpenVtsSpacing.xs,
            ),
            child: Text(
              label,
              style: OpenVtsTypography.meta.copyWith(
                color: textColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
