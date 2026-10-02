import 'package:flutter/material.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';
import 'package:open_vts/features/user/models/user_support_model.dart';
import 'package:open_vts/features/user/models/user_support_state.dart';
import 'package:open_vts/features/user/screens/support/widgets/user_support_status_segment.dart';
import 'package:open_vts/features/user/screens/support/widgets/user_support_ticket_card.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';
import 'package:open_vts/shared/widgets/open_vts_card.dart';
import 'package:open_vts/shared/widgets/open_vts_error_view.dart';
import 'package:open_vts/shared/widgets/open_vts_search_field.dart';

typedef UserSupportTicketPreviewBuilder = String? Function(
    UserSupportTicketListItem ticket, UserSupportState state);

class UserSupportTicketListView extends StatelessWidget {
  const UserSupportTicketListView({
    required this.state,
    required this.activeTicketId,
    required this.onCreatePressed,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onRefresh,
    required this.onOpenTicket,
    required this.lastMessagePreview,
    super.key,
  });

  final UserSupportState state;
  final String? activeTicketId;
  final VoidCallback onCreatePressed;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UserSupportTicketStatus?> onStatusChanged;
  final Future<void> Function() onRefresh;
  final ValueChanged<UserSupportTicketListItem> onOpenTicket;
  final UserSupportTicketPreviewBuilder lastMessagePreview;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _SupportHeader(
              visibleCount: state.filteredTickets.length,
              totalCount: state.tickets.length,
              hasActiveFilters: state.hasActiveFilters,
              isCreating: state.isCreating,
              onCreatePressed: onCreatePressed,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: OpenVtsSpacing.xs)),
          SliverToBoxAdapter(
            child: UserSupportStatusSegment(
              selected: state.selectedStatusFilter,
              onChanged: onStatusChanged,
              counts: _calculateStatusCounts(state.tickets),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: OpenVtsSpacing.xs)),
          SliverToBoxAdapter(
            child: OpenVtsCard(
              padding: const EdgeInsets.symmetric(
                horizontal: OpenVtsSpacing.sm,
                vertical: OpenVtsSpacing.xxs,
              ),
              child: OpenVtsSearchField(
                hintText: 'Search subject, number, status',
                onChanged: onSearchChanged,
              ),
            ),
          ),
          if (state.errorMessage != null && state.hasTickets) ...[
            const SliverToBoxAdapter(
              child: SizedBox(height: OpenVtsSpacing.sm),
            ),
            SliverToBoxAdapter(
              child: _InlineErrorBanner(message: state.errorMessage!),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: OpenVtsSpacing.xs)),
          if (state.isLoadingList && !state.hasTickets)
            const _TicketListSkeleton()
          else if (state.errorMessage != null && !state.hasTickets)
            SliverFillRemaining(
              hasScrollBody: false,
              child: OpenVtsErrorView(
                message: state.errorMessage!,
                onRetry: onRefresh,
              ),
            )
          else if (state.filteredTickets.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _SupportEmptyState(
                hasActiveFilters: state.hasActiveFilters,
                onCreatePressed: onCreatePressed,
              ),
            )
          else
            SliverList.separated(
              itemCount: state.filteredTickets.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: OpenVtsSpacing.xs),
              itemBuilder: (context, index) {
                final ticket = state.filteredTickets[index];
                return UserSupportTicketCard(
                  ticket: ticket,
                  isSelected: activeTicketId == ticket.id,
                  lastMessagePreview: lastMessagePreview(ticket, state),
                  onTap: () => onOpenTicket(ticket),
                );
              },
            ),
          const SliverToBoxAdapter(child: SizedBox(height: OpenVtsSpacing.lg)),
        ],
      ),
    );
  }
}

class _SupportHeader extends StatelessWidget {
  const _SupportHeader({
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveFilters,
    required this.isCreating,
    required this.onCreatePressed,
  });

  final int visibleCount;
  final int totalCount;
  final bool hasActiveFilters;
  final bool isCreating;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final countLabel = _countLabel(
          visibleCount: visibleCount,
          totalCount: totalCount,
          hasActiveFilters: hasActiveFilters,
        );

        final createButton = FilledButton.icon(
          onPressed: isCreating ? null : onCreatePressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 34),
            backgroundColor: OpenVtsColors.brandInk,
            foregroundColor: OpenVtsColors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
            ),
          ),
          icon: isCreating
              ? const SizedBox.square(
                  dimension: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_rounded, size: 17),
          label: const Text('Create'),
        );

        final colorScheme = Theme.of(context).colorScheme;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                countLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.meta.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            createButton,
          ],
        );
      },
    );
  }

  String _countLabel({
    required int visibleCount,
    required int totalCount,
    required bool hasActiveFilters,
  }) {
    if (hasActiveFilters) {
      if (visibleCount == totalCount) {
        return '$visibleCount ${visibleCount == 1 ? 'result' : 'results'}';
      }
      return '$visibleCount of $totalCount tickets';
    }

    return '$totalCount ${totalCount == 1 ? 'ticket' : 'tickets'}';
  }
}

Map<UserSupportTicketStatus?, int> _calculateStatusCounts(
  List<UserSupportTicketListItem> tickets,
) {
  final counts = <UserSupportTicketStatus?, int>{
    null: tickets.length, // All tickets
  };

  for (final status in UserSupportTicketStatus.values) {
    counts[status] = tickets.where((ticket) => ticket.status == status).length;
  }

  return counts;
}

class _SupportEmptyState extends StatelessWidget {
  const _SupportEmptyState({
    required this.hasActiveFilters,
    required this.onCreatePressed,
  });

  final bool hasActiveFilters;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              ),
              child: Icon(
                Icons.support_agent_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            Text(
              hasActiveFilters ? 'No matching tickets' : 'No tickets',
              textAlign: TextAlign.center,
              style: OpenVtsTypography.titleSmall.copyWith(fontSize: 16),
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Text(
              hasActiveFilters
                  ? 'Try a different search or status filter.'
                  : 'Create a ticket and the team will follow up here.',
              textAlign: TextAlign.center,
              style: OpenVtsTypography.body.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (!hasActiveFilters) ...[
              const SizedBox(height: OpenVtsSpacing.md),
              SizedBox(
                width: 172,
                child: OpenVtsButton(
                  label: 'Create ticket',
                  onPressed: onCreatePressed,
                  trailingIcon: Icons.add_rounded,
                  height: 40,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TicketListSkeleton extends StatelessWidget {
  const _TicketListSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: OpenVtsSpacing.sm),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const OpenVtsCard(
      padding: EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonLine(widthFactor: 0.66, height: 14),
          SizedBox(height: OpenVtsSpacing.sm),
          Row(
            children: [
              Expanded(child: _SkeletonLine(height: 10)),
              SizedBox(width: OpenVtsSpacing.sm),
              Expanded(child: _SkeletonLine(height: 10)),
            ],
          ),
          SizedBox(height: OpenVtsSpacing.xs),
          _SkeletonLine(widthFactor: 0.38, height: 10),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({this.widthFactor = 1, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        ),
      ),
    );
  }
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.35)),
        color: colorScheme.error.withValues(alpha: 0.15),
      ),
      child: Text(
        message,
        style: OpenVtsTypography.body.copyWith(color: colorScheme.error),
      ),
    );
  }
}
