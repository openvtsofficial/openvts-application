import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/app_preferences_provider.dart';
import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';

class AdminInventoryRoundedSurface extends StatelessWidget {
  const AdminInventoryRoundedSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(color: inventorySoftBorderColor(context)),
      ),
      child: child,
    );
  }
}

class AdminInventoryCardHeader extends StatelessWidget {
  const AdminInventoryCardHeader({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onEdit,
    required this.isEditing,
    this.showActiveBadge = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onEdit;
  final bool isEditing;
  final bool showActiveBadge;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: inventorySoftSurfaceColor(context),
            shape: BoxShape.circle,
            border: Border.all(color: inventorySoftBorderColor(context)),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 22,
            color: inventoryPrimaryInkColor(context),
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: inventoryPrimaryInkColor(context),
                ),
          ),
        ),
        AdminInventoryEditButton(
          onPressed: isEditing ? null : onEdit,
          isLoading: isEditing,
        ),
        if (showActiveBadge) ...[
          const SizedBox(width: OpenVtsSpacing.xxs),
          AdminInventoryStatusBadge(
            label: isActive ? 'Active' : 'Inactive',
          ),
        ],
      ],
    );
  }
}

class AdminInventoryEditButton extends StatelessWidget {
  const AdminInventoryEditButton({
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        onPressed: onPressed,
        tooltip: 'Edit',
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.edit_outlined,
                size: 18,
                color: inventoryPrimaryInkColor(context),
              ),
      ),
    );
  }
}

class AdminInventoryStatusBadge extends StatelessWidget {
  const AdminInventoryStatusBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: inventorySoftSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: inventorySoftBorderColor(context)),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.label.copyWith(
          color: inventoryPrimaryInkColor(context),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AdminInventoryInfoField extends StatelessWidget {
  const AdminInventoryInfoField({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final resolved = value.trim().isEmpty ? '—' : value.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        Expanded(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: OpenVtsTypography.label.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '${label.toUpperCase()} : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: resolved,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AdminInventoryInfoGrid extends StatelessWidget {
  const AdminInventoryInfoGrid({
    required this.leftTop,
    required this.leftBottom,
    required this.rightTop,
    required this.rightBottom,
    super.key,
  });

  final AdminInventoryInfoField leftTop;
  final AdminInventoryInfoField leftBottom;
  final AdminInventoryInfoField rightTop;
  final AdminInventoryInfoField rightBottom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftTop,
              const SizedBox(height: OpenVtsSpacing.xs),
              leftBottom,
              const SizedBox(height: OpenVtsSpacing.xs),
              rightTop,
              const SizedBox(height: OpenVtsSpacing.xs),
              rightBottom,
            ],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftTop),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(child: rightTop),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftBottom),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(child: rightBottom),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AdminInventoryCardFooter extends ConsumerWidget {
  const AdminInventoryCardFooter({
    required this.createdAt,
    required this.statusLabel,
    super.key,
  });

  final DateTime? createdAt;
  final String statusLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appLocalizationPreferencesProvider);
    final formatter = AppDateFormatter(
      datePattern: prefs.dateFormat,
      use24Hour: prefs.use24Hour,
      timezone: prefs.timezone,
    );
    final createdValue =
        createdAt != null ? formatter.formatDateTime(createdAt) : '-';

    return Row(
      children: [
        Expanded(
          child: _CreatedPill(createdValue: createdValue),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        _StockStatusPill(label: statusLabel),
      ],
    );
  }
}

class _CreatedPill extends StatelessWidget {
  const _CreatedPill({required this.createdValue});

  final String createdValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: inventorySoftSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: inventorySoftBorderColor(context)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: OpenVtsTypography.label.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.3,
                  fontSize: 12,
                ),
                children: [
                  const TextSpan(
                    text: 'Created : ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: createdValue,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminInventorySimCardFooter extends StatelessWidget {
  const AdminInventorySimCardFooter({
    required this.isActive,
    required this.statusLabel,
    super.key,
  });

  final bool isActive;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActivePill(isActive: isActive),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        _StockStatusPill(label: statusLabel),
      ],
    );
  }
}

class _ActivePill extends StatelessWidget {
  const _ActivePill({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final label = isActive ? 'Active' : 'Inactive';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: inventorySoftSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: inventorySoftBorderColor(context)),
      ),
      child: Row(
        children: [
          Icon(
            isActive
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: OpenVtsTypography.label.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.3,
                  fontSize: 12,
                ),
                children: [
                  const TextSpan(
                    text: 'Status : ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockStatusPill extends StatelessWidget {
  const _StockStatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 108),
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.md,
        vertical: OpenVtsSpacing.xs + 2,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: inventorySoftSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: inventorySoftBorderColor(context)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: OpenVtsTypography.label.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String formatInventoryStatusLabel(String rawLabel) {
  final normalized = rawLabel.trim().toLowerCase();
  if (normalized.isEmpty) {
    return 'Unknown';
  }

  return normalized
      .split(RegExp(r'\s+'))
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}

Color inventorySoftSurfaceColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkSurface
      : OpenVtsColors.background;
}

Color inventorySoftBorderColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkBorder
      : OpenVtsColors.border;
}

Color inventoryPrimaryInkColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkTextPrimary
      : OpenVtsColors.brandInk;
}
