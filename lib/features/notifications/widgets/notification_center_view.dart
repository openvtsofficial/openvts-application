import 'package:flutter/material.dart';

import '../../../core/theme/open_vts_colors.dart';
import '../../../core/theme/open_vts_radius.dart';
import '../../../core/theme/open_vts_spacing.dart';
import '../../../core/theme/open_vts_typography.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/widgets/open_vts_empty_state.dart';
import '../../../shared/widgets/open_vts_error_view.dart';
import '../../../shared/widgets/open_vts_loader.dart';
import '../models/app_notification.dart';
import '../models/notification_center_state.dart';

class NotificationCenterView extends StatelessWidget {
  const NotificationCenterView({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onUnreadOnlyChanged,
    required this.onMarkAllAsRead,
    required this.onMarkAsRead,
    super.key,
  });

  final NotificationCenterState state;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onRetry;
  final Future<void> Function() onLoadMore;
  final ValueChanged<bool> onUnreadOnlyChanged;
  final Future<void> Function() onMarkAllAsRead;
  final Future<void> Function(int id) onMarkAsRead;

  static const _formatter = DateTimeFormatter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state.isInitialLoading && !state.hasItems) {
      return const OpenVtsLoader();
    }

    if (state.errorMessage != null && !state.hasItems) {
      return OpenVtsErrorView(
        message: state.errorMessage!,
        onRetry: () {
          onRetry();
        },
      );
    }

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
        child: _InboxSummaryCard(
          unreadCount: state.unreadCount,
          unreadOnly: state.unreadOnly,
          isMarkingAllRead: state.isMarkingAllRead,
          onUnreadOnlyChanged: onUnreadOnlyChanged,
          onMarkAllAsRead: onMarkAllAsRead,
        ),
      ),
      if (state.errorMessage != null)
        Padding(
          padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
          child: Text(
            state.errorMessage!,
            style: OpenVtsTypography.meta.copyWith(
              color: isDark ? OpenVtsColors.white : theme.colorScheme.error,
            ),
          ),
        ),
      if (!state.hasItems)
        Padding(
          padding: const EdgeInsets.only(top: OpenVtsSpacing.xl),
          child: OpenVtsEmptyState(
            title: state.unreadOnly
                ? 'No unread notifications'
                : 'No notifications yet',
            message: state.unreadOnly
                ? 'Everything is marked as read. New alerts will appear here as they arrive.'
                : 'Vehicle alerts, system events, and operational updates will appear here.',
          ),
        )
      else
        ...state.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
            child: _NotificationListItem(
              notification: item,
              formatter: _formatter,
              onMarkAsRead: item.isRead
                  ? null
                  : () {
                      onMarkAsRead(item.id);
                    },
            ),
          ),
        ),
      if (state.isLoadingMore)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: OpenVtsSpacing.md),
          child: OpenVtsLoader(),
        ),
      const SizedBox(height: OpenVtsSpacing.lg),
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 240 &&
            state.hasMore &&
            !state.isLoadingMore &&
            !state.isInitialLoading) {
          onLoadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Container(
          color: isDark ? Colors.black : theme.colorScheme.surface,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: children,
          ),
        ),
      ),
    );
  }
}

class _InboxSummaryCard extends StatelessWidget {
  const _InboxSummaryCard({
    required this.unreadCount,
    required this.unreadOnly,
    required this.isMarkingAllRead,
    required this.onUnreadOnlyChanged,
    required this.onMarkAllAsRead,
  });

  final int unreadCount;
  final bool unreadOnly;
  final bool isMarkingAllRead;
  final ValueChanged<bool> onUnreadOnlyChanged;
  final Future<void> Function() onMarkAllAsRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor =
        isDark ? OpenVtsColors.white : theme.colorScheme.onSurface;
    final secondaryColor = isDark
        ? OpenVtsColors.white.withValues(alpha: 0.7)
        : theme.colorScheme.onSurface.withValues(alpha: 0.62);
    final borderColor = isDark
        ? OpenVtsColors.white
        : theme.colorScheme.onSurface.withValues(alpha: 0.10);
    final accentColor = theme.colorScheme.primary;
    final unreadLabel = unreadCount == 1
        ? '1 unread notification needs attention.'
        : '$unreadCount unread notifications need attention.';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
          color: borderColor,
        ),
      ),
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inbox',
                        style: OpenVtsTypography.titleSmall.copyWith(
                          color: headingColor,
                        )),
                    const SizedBox(height: OpenVtsSpacing.xxs),
                    Text(
                      unreadLabel,
                      style: OpenVtsTypography.meta.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox.shrink(),
              _NotificationStatusPill(
                label: unreadCount == 0 ? 'All read' : '$unreadCount unread',
                textColor: unreadCount == 0 ? secondaryColor : accentColor,
                borderColor: unreadCount == 0
                    ? borderColor
                    : accentColor.withValues(alpha: 0.20),
                backgroundColor: unreadCount == 0
                    ? Colors.transparent
                    : accentColor.withValues(alpha: 0.08),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              _NotificationFilterPill(
                label: 'All',
                selected: !unreadOnly,
                onTap: () => onUnreadOnlyChanged(false),
              ),
              _NotificationFilterPill(
                label: 'Unread',
                selected: unreadOnly,
                onTap: () => onUnreadOnlyChanged(true),
              ),
              if (unreadCount > 0 || isMarkingAllRead)
                _NotificationActionPill(
                  label: isMarkingAllRead ? 'Marking…' : 'Mark all read',
                  onTap: isMarkingAllRead
                      ? null
                      : () {
                          onMarkAllAsRead();
                        },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationFilterPill extends StatelessWidget {
  const _NotificationFilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = selected
        ? (isDark ? Colors.black : OpenVtsColors.white)
        : Colors.transparent;
    final textColor = isDark ? Colors.white : OpenVtsColors.brandInk;
    final borderColor = isDark ? Colors.white : OpenVtsColors.border;

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
          child: Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              height: 1,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationListItem extends StatelessWidget {
  const _NotificationListItem({
    required this.notification,
    required this.formatter,
    this.onMarkAsRead,
  });

  final AppNotification notification;
  final DateTimeFormatter formatter;
  final VoidCallback? onMarkAsRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor =
        isDark ? OpenVtsColors.white : theme.colorScheme.onSurface;
    final secondaryColor = isDark
        ? OpenVtsColors.white.withValues(alpha: 0.7)
        : theme.colorScheme.onSurface.withValues(alpha: 0.62);
    final borderColor = isDark
        ? OpenVtsColors.white
        : theme.colorScheme.onSurface.withValues(alpha: 0.10);
    final accentColor = theme.colorScheme.primary;
    final metaParts = <String>[
      if (notification.contextLabel != null &&
          notification.contextLabel!.isNotEmpty)
        notification.contextLabel!,
      if (notification.createdAt != null)
        formatter.formatDateTime(notification.createdAt!.toLocal()),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
          color: borderColor,
        ),
      ),
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black
                      : theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  border: Border.all(
                    color: isDark
                        ? OpenVtsColors.white
                        : (isDark ? OpenVtsColors.white : OpenVtsColors.border),
                  ),
                ),
                child: Icon(
                  _notificationIcon(notification),
                  size: 16,
                  color: isDark
                      ? OpenVtsColors.white
                      : theme.colorScheme.onSurface.withValues(alpha: 0.82),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!notification.isRead)
                          Container(
                            width: 6,
                            height: 6,
                            margin:
                                const EdgeInsets.only(right: OpenVtsSpacing.xs),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: OpenVtsTypography.label.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: headingColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: OpenVtsSpacing.xxs),
                    Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.body.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              if (onMarkAsRead != null)
                _NotificationActionPill(
                  label: 'Mark read',
                  onTap: onMarkAsRead!,
                )
              else
                _NotificationStatusPill(
                  label: 'Read',
                  textColor: secondaryColor,
                  borderColor: borderColor,
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (notification.category != null &&
                  notification.category!.isNotEmpty)
                _NotificationStatusPill(
                  label: notification.category!,
                  textColor: secondaryColor,
                  borderColor: borderColor,
                  backgroundColor: isDark
                      ? Colors.black
                      : theme.colorScheme.onSurface.withValues(alpha: 0.03),
                ),
              if (metaParts.isNotEmpty)
                Text(
                  metaParts.join(' • '),
                  style: OpenVtsTypography.meta.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationStatusPill extends StatelessWidget {
  const _NotificationStatusPill({
    required this.label,
    required this.textColor,
    required this.borderColor,
    required this.backgroundColor,
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

class _NotificationActionPill extends StatelessWidget {
  const _NotificationActionPill({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: OpenVtsSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: onTap == null
                ? Colors.transparent
                : (isDark
                    ? Colors.black
                    : theme.colorScheme.primary.withValues(alpha: 0.06)),
            borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
            border: Border.all(
              color: isDark ? OpenVtsColors.white : OpenVtsColors.border,
            ),
          ),
          child: Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color: isDark
                  ? OpenVtsColors.white
                  : (onTap == null
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.78)),
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

IconData _notificationIcon(AppNotification notification) {
  final key = [notification.severity, notification.category]
      .whereType<String>()
      .join(' ')
      .toLowerCase();

  if (key.contains('security') || key.contains('login')) {
    return Icons.shield_outlined;
  }

  if (key.contains('vehicle') ||
      key.contains('speed') ||
      key.contains('idle')) {
    return Icons.directions_car_outlined;
  }

  if (key.contains('maintenance')) {
    return Icons.build_outlined;
  }

  if (key.contains('connect') ||
      key.contains('telemetry') ||
      key.contains('network')) {
    return Icons.wifi_tethering_off_rounded;
  }

  return Icons.notifications_none_rounded;
}
