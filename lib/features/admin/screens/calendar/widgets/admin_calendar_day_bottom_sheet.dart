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
import '../../../controllers/admin_calendar_controller.dart';
import '../../../models/admin_calendar_model.dart';

class AdminCalendarDayBottomSheet extends ConsumerStatefulWidget {
  const AdminCalendarDayBottomSheet({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<AdminCalendarDayBottomSheet> createState() =>
      _AdminCalendarDayBottomSheetState();
}

class _AdminCalendarDayBottomSheetState
    extends ConsumerState<AdminCalendarDayBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final detailsAsync =
        ref.watch(adminCalendarDayDetailsProvider(widget.date));

    return detailsAsync.when(
      loading: () => const Center(child: OpenVtsLoader()),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        child: OpenVtsErrorView(
          message: 'Failed to load details',
          onRetry: () =>
              ref.refresh(adminCalendarDayDetailsProvider(widget.date)),
        ),
      ),
      data: (details) {
        if (details.isEmpty) {
          return const OpenVtsEmptyState(
            title: 'No Data',
            message: 'There are no events on this day',
          );
        }

        final linkedDetails = <String, AdminCalendarLinkedDetail?>{};
        if (_searchQuery.isNotEmpty) {
          for (final detail in details) {
            final linked = detail.isUser
                ? ref
                    .watch(adminCalendarUserDetailsProvider(detail.userId!))
                    .asData
                    ?.value
                : detail.isVehicle
                    ? ref
                        .watch(adminCalendarVehicleDetailsProvider(
                            detail.vehicleId!))
                        .asData
                        ?.value
                    : null;
            linkedDetails[detail.id] = linked;
          }
        }
        final filtered = filterAdminCalendarDayDetails(
          details,
          linkedDetails,
          _searchQuery,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            OpenVtsSpacing.md,
            OpenVtsSpacing.md,
            OpenVtsSpacing.md,
            0,
          ),
          child: Column(
            children: [
              OpenVtsSearchField(
                hintText: 'Search daily records...',
                onChanged: (value) => setState(
                  () => _searchQuery = value.trim().toLowerCase(),
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.sm),
              Expanded(
                child: filtered.isEmpty
                    ? const OpenVtsEmptyState(
                        title: 'No matching records',
                        message: 'Try a different search term.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: OpenVtsSpacing.lg,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: OpenVtsSpacing.sm),
                        itemBuilder: (context, index) =>
                            _CalendarDayEventTile(detail: filtered[index]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

List<AdminCalendarDayDetail> filterAdminCalendarDayDetails(
  List<AdminCalendarDayDetail> details,
  Map<String, AdminCalendarLinkedDetail?> linkedDetails,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return details;
  }
  return details
      .where(
        (detail) => detail.matchesQuery(
          normalized,
          linkedDetails[detail.id],
        ),
      )
      .toList(growable: false);
}

class _CalendarDayEventTile extends ConsumerWidget {
  const _CalendarDayEventTile({required this.detail});

  final AdminCalendarDayDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final linkedDetailAsync = detail.isUser
        ? ref.watch(adminCalendarUserDetailsProvider(detail.userId!))
        : detail.isVehicle
            ? ref.watch(adminCalendarVehicleDetailsProvider(detail.vehicleId!))
            : const AsyncValue<AdminCalendarLinkedDetail?>.data(null);

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
    AdminCalendarDayDetail detail,
    AdminCalendarLinkedDetail? linkedDetail,
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
    AdminCalendarDayDetail detail,
    AdminCalendarLinkedDetail? linkedDetail,
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
            ? OpenVtsColors.white.withValues(alpha: 0.18)
            : OpenVtsColors.brandInk.withValues(alpha: 0.15),
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
