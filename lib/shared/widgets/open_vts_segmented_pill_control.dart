import 'package:flutter/material.dart';

import '../../core/theme/open_vts_colors.dart';
import '../../core/theme/open_vts_radius.dart';
import '../../core/theme/open_vts_spacing.dart';
import '../../core/theme/open_vts_typography.dart';

/// A segment in the segmented pill control.
class OpenVtsSegmentedPillSegment<T> {
  const OpenVtsSegmentedPillSegment({
    required this.value,
    required this.label,
    this.icon,
    this.badgeCount,
    this.showDot = false,
  });

  /// The value this segment represents.
  final T value;

  /// The display label for the segment.
  final String label;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Optional badge count to display after the label.
  final int? badgeCount;

  /// Whether to show a dot indicator.
  final bool showDot;
}

/// A pill-shaped segmented control with consistent dark mode styling.
///
/// Visual format:
/// - Black background with white border
/// - Selected segment: black background with white border, white text/icon
/// - Unselected segment: transparent background, white text/icon
/// - Optional badges: black background, white border, white text
/// - Optional dot indicators: white dot or bordered white dot
///
/// Supports dynamic segment counts with optional equal width distribution
/// and horizontal scroll for overflow scenarios.
class OpenVtsSegmentedPillControl<T> extends StatelessWidget {
  const OpenVtsSegmentedPillControl({
    required this.segments,
    required this.selectedValue,
    required this.onChanged,
    this.equalWidth = false,
    this.allowHorizontalScroll = false,
    super.key,
  });

  /// The list of segments to display.
  final List<OpenVtsSegmentedPillSegment<T>> segments;

  /// The currently selected value.
  final T selectedValue;

  /// Callback when a segment is tapped.
  final ValueChanged<T> onChanged;

  /// Whether segments should expand equally (recommended for exactly 3 segments).
  final bool equalWidth;

  /// Whether to allow horizontal scroll when segments overflow.
  final bool allowHorizontalScroll;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final outerBackgroundColor =
        isDark ? OpenVtsColors.darkSurface : OpenVtsColors.background;
    final outerBorderColor =
        isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border;

    final Widget segmentRow = Row(
      mainAxisSize: equalWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        for (int i = 0; i < segments.length; i++) ...[
          if (equalWidth)
            Expanded(
              child: _buildSegment(context, segments[i], isDark),
            )
          else
            _buildSegment(context, segments[i], isDark),
          if (i < segments.length - 1)
            Container(
              width: 1,
              height: 32,
              color: outerBorderColor,
            ),
        ],
      ],
    );

    final Widget content = Container(
      decoration: BoxDecoration(
        color: outerBackgroundColor,
        border: Border.all(color: outerBorderColor, width: 1),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        child: segmentRow,
      ),
    );

    if (allowHorizontalScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: content,
      );
    }

    return content;
  }

  Widget _buildSegment(
    BuildContext context,
    OpenVtsSegmentedPillSegment<T> segment,
    bool isDark,
  ) {
    final isSelected = segment.value == selectedValue;

    final backgroundColor = isSelected
        ? (isDark ? OpenVtsColors.darkSurface : OpenVtsColors.brandInk)
        : Colors.transparent;

    final textColor = isSelected
        ? (isDark ? OpenVtsColors.darkTextPrimary : OpenVtsColors.white)
        : (isDark
            ? OpenVtsColors.darkTextPrimary
            : OpenVtsColors.textSecondary);

    final borderColor = isDark
        ? OpenVtsColors.darkBorder
        : (isSelected ? OpenVtsColors.brandInk : OpenVtsColors.border);

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () => onChanged(segment.value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: OpenVtsSpacing.xs,
          ),
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(OpenVtsRadius.pill - 1),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (segment.icon != null) ...[
                Icon(
                  segment.icon,
                  size: 16,
                  color: textColor,
                ),
                const SizedBox(width: OpenVtsSpacing.xxs),
              ],
              if (segment.showDot) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark
                        ? OpenVtsColors.darkTextPrimary
                        : OpenVtsColors.textPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? OpenVtsColors.darkTextPrimary
                          : OpenVtsColors.textPrimary,
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xxs),
              ],
              Flexible(
                child: Text(
                  segment.label,
                  style: OpenVtsTypography.meta.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (segment.badgeCount != null && segment.badgeCount! > 0) ...[
                const SizedBox(width: OpenVtsSpacing.xxs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.xxs,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? OpenVtsColors.darkSurface
                        : OpenVtsColors.surface,
                    border: Border.all(
                      color: isDark
                          ? OpenVtsColors.darkBorder
                          : OpenVtsColors.border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  ),
                  child: Text(
                    segment.badgeCount.toString(),
                    style: OpenVtsTypography.meta.copyWith(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
