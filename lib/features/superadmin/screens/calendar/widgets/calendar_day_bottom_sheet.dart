import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../../../shared/widgets/open_vts_search_field.dart';
import '../../../controllers/superadmin_calendar_controller.dart';
import '../../../models/superadmin_calendar_model.dart';

class CalendarDayBottomSheet extends ConsumerStatefulWidget {
  final DateTime date;

  const CalendarDayBottomSheet({super.key, required this.date});

  @override
  ConsumerState<CalendarDayBottomSheet> createState() =>
      _CalendarDayBottomSheetState();
}

class _CalendarDayBottomSheetState
    extends ConsumerState<CalendarDayBottomSheet> {
  String _query = '';

  void _onSearchChanged(String value) {
    setState(() => _query = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(calendarDayDetailsProvider(widget.date));

    return detailsAsync.when(
      loading: () => const Center(child: OpenVtsLoader()),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        child: OpenVtsErrorView(
          message: 'Failed to load details',
          onRetry: () => ref.refresh(calendarDayDetailsProvider(widget.date)),
        ),
      ),
      data: (details) {
        if (details.isEmpty) {
          return const OpenVtsEmptyState(
            title: 'No Data',
            message: 'There are no events on this day',
          );
        }

        final filtered = _query.isEmpty
            ? details
            : details.where((d) {
                final linkedDetail = d.isUser
                    ? ref
                        .read(calendarUserDetailsProvider(d.userId!))
                        .asData
                        ?.value
                    : d.isVehicle
                        ? ref
                            .read(calendarVehicleDetailsProvider(d.vehicleId!))
                            .asData
                            ?.value
                        : null;
                return d.matchesQuery(_query, linkedDetail);
              }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
                OpenVtsSpacing.sm,
              ),
              child: OpenVtsSearchField(
                hintText: 'Search users, vehicles…',
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const OpenVtsEmptyState(
                      title: 'No matching records',
                      message: 'Try a different search term',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        OpenVtsSpacing.md,
                        0,
                        OpenVtsSpacing.md,
                        OpenVtsSpacing.lg,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: OpenVtsSpacing.sm),
                      itemBuilder: (context, index) =>
                          _CalendarDayEventTile(detail: filtered[index]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CalendarDayEventTile extends ConsumerWidget {
  const _CalendarDayEventTile({required this.detail});

  final CalendarDayDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final linkedDetailAsync = detail.isUser
        ? ref.watch(calendarUserDetailsProvider(detail.userId!))
        : detail.isVehicle
            ? ref.watch(calendarVehicleDetailsProvider(detail.vehicleId!))
            : const AsyncValue<CalendarLinkedDetail?>.data(null);

    final linkedDetail = linkedDetailAsync.asData?.value;
    final title = _resolveTitle(detail, linkedDetail);
    final subtitle = _resolveSubtitle(detail, linkedDetail);
    final metadata = linkedDetail?.metadata ?? const <String>[];

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EventTypeIcon(type: detail.type),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: OpenVtsTypography.label.copyWith(
                          color: isDark
                              ? OpenVtsColors.darkTextPrimary
                              : OpenVtsColors.textPrimary,
                        ),
                      ),
                    ),
                    if (detail.count > 1) _CountBadge(count: detail.count),
                  ],
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: OpenVtsTypography.meta.copyWith(
                      color: isDark
                          ? OpenVtsColors.darkTextSecondary
                          : OpenVtsColors.textSecondary,
                    ),
                  ),
                ],
                if (metadata.isNotEmpty) ...[
                  const SizedBox(height: OpenVtsSpacing.xs),
                  for (final item in metadata.take(2))
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item,
                        style: OpenVtsTypography.meta.copyWith(
                          color: isDark
                              ? OpenVtsColors.darkTextSecondary
                                  .withValues(alpha: 0.7)
                              : OpenVtsColors.textTertiary,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (linkedDetailAsync.isLoading)
            const Padding(
              padding: EdgeInsetsDirectional.only(start: OpenVtsSpacing.sm),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 1.6),
              ),
            ),
        ],
      ),
    );
  }

  String _resolveTitle(
    CalendarDayDetail detail,
    CalendarLinkedDetail? linkedDetail,
  ) {
    if (detail.title.trim().isNotEmpty &&
        detail.title != 'Users' &&
        detail.title != 'Vehicle') {
      return detail.title;
    }
    if (linkedDetail != null && linkedDetail.title.trim().isNotEmpty) {
      return linkedDetail.title;
    }
    return detail.title;
  }

  String _resolveSubtitle(
    CalendarDayDetail detail,
    CalendarLinkedDetail? linkedDetail,
  ) {
    if (detail.subtitle.trim().isNotEmpty) {
      return detail.subtitle;
    }
    return linkedDetail?.subtitle ?? '';
  }
}

class _EventTypeIcon extends StatelessWidget {
  const _EventTypeIcon({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    late final IconData icon;
    late final Color color;

    switch (type) {
      case 'vehicle':
        icon = Icons.directions_car_outlined;
        color = OpenVtsColors.success;
      case 'expiry':
        icon = Icons.warning_amber_rounded;
        color = OpenVtsColors.error;
      case 'users':
      default:
        icon = Icons.person_outline_rounded;
        color = isDark ? OpenVtsColors.darkTextPrimary : OpenVtsColors.brandInk;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? OpenVtsColors.white.withValues(alpha: 0.1)
            : OpenVtsColors.brandInk.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: OpenVtsTypography.meta.copyWith(
          color: isDark
              ? OpenVtsColors.darkTextPrimary
              : OpenVtsColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
