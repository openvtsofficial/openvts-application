import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_actions_controller.dart';
import '../controllers/driver_providers.dart';
import '../models/driver_workspace_models.dart';
import 'driver_trips_screen.dart';
import 'driver_widgets.dart';

class DriverNotificationsScreen extends ConsumerStatefulWidget {
  const DriverNotificationsScreen({super.key});
  @override
  ConsumerState<DriverNotificationsScreen> createState() =>
      _DriverNotificationsScreenState();
}

class _DriverNotificationsScreenState
    extends ConsumerState<DriverNotificationsScreen> {
  bool _busy = false;
  Future<void> _markAll() async {
    setState(() => _busy = true);
    try {
      await ref.read(driverActionsControllerProvider).readAllNotifications();
      if (mounted) ref.invalidate(driverNotificationsProvider);
    } catch (error) {
      if (mounted) driverToast(context, ErrorMapper.from(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(driverNotificationsProvider),
        formatter = ref.watch(appDateFormatterProvider);
    return DriverRefreshScope(
      onRefresh: () => ref.invalidate(driverNotificationsProvider),
      child: OpenVtsPageScaffold(
        title: context.mobileText('Notifications'),
        actions: [
          TextButton(
            onPressed: _busy ? null : _markAll,
            child: Text(context.mobileText('Read all')),
          ),
        ],
        body: DriverAsyncBody(
          value: notifications,
          onRetry: () => ref.invalidate(driverNotificationsProvider),
          builder: (data) {
            final items = driverItems(data['items']);
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(driverNotificationsProvider);
                await ref.read(driverNotificationsProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      context.mobileText(
                        "{value1} unread · Latest {value2} notifications",
                        {
                          'value1': (driverInt(data['unreadCount'])).toString(),
                          'value2': (items.length).toString(),
                        },
                      ),
                    ),
                  ),
                  if (items.isEmpty)
                    DriverEmpty(
                      context.mobileText('You are all caught up.'),
                      icon: Icons.notifications_none,
                    ),
                  for (final item in items)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          item['isRead'] == true
                              ? Icons.notifications_none
                              : Icons.notifications_active_outlined,
                        ),
                        title: Text(driverText(item['title'])),
                        subtitle: Text(
                          '${driverText(item['detail'])}\n${formatter.formatDateTime(DateTime.tryParse(driverText(item['createdAt'])))}',
                        ),
                        isThreeLine: true,
                        onTap: () async {
                          try {
                            await ref
                                .read(driverActionsControllerProvider)
                                .readNotification(driverText(item['id']));
                            if (!context.mounted) return;
                            ref.invalidate(driverNotificationsProvider);
                            final id = driverText(item['assignmentId']);
                            if (id.isNotEmpty) {
                              await openDriverTrip(context, id);
                            }
                          } catch (error) {
                            if (context.mounted) {
                              driverToast(
                                context,
                                ErrorMapper.from(error).message,
                              );
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
