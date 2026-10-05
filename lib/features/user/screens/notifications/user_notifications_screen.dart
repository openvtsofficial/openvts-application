import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/helpers/mobile_text.dart';
import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../../notifications/widgets/notification_center_view.dart';
import '../../controllers/user_providers.dart';

class UserNotificationsScreen extends ConsumerWidget {
  const UserNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userNotificationCenterProvider);
    final controller = ref.read(userNotificationCenterProvider.notifier);

    return OpenVtsPageScaffold(
      title: context.mobileText('Notifications'),
      headerMode: OpenVtsPageHeaderMode.closeable,
      body: NotificationCenterView(
        state: state,
        onRefresh: controller.refresh,
        onRetry: controller.load,
        onLoadMore: controller.loadMore,
        onUnreadOnlyChanged: controller.setUnreadOnly,
        onMarkAllAsRead: () async {
          try {
            final unreadCount = ref.read(
              userNotificationCenterProvider.select(
                (value) => value.unreadCount,
              ),
            );
            await controller.markAllAsRead();
            if (!context.mounted) return;
            if (unreadCount > 0) {
              ToastHelper.showSuccess(
                context.mobileText('All notifications marked as read.'),
              );
            }
          } catch (_) {
            if (!context.mounted) return;
            final message =
                ref.read(
                  userNotificationCenterProvider.select(
                    (value) => value.errorMessage,
                  ),
                ) ??
                'Unable to mark notifications as read.';
            ToastHelper.showError(message);
          }
        },
        onMarkAsRead: (id) async {
          try {
            await controller.markAsRead(id);
          } catch (_) {
            if (!context.mounted) return;
            final message =
                ref.read(
                  userNotificationCenterProvider.select(
                    (value) => value.errorMessage,
                  ),
                ) ??
                'Unable to mark this notification as read.';
            ToastHelper.showError(message);
          }
        },
      ),
    );
  }
}
