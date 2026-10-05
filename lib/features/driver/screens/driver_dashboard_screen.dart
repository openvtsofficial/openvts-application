import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/unit_formatter.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_providers.dart';
import '../models/driver_workspace_models.dart';
import 'driver_messages_screen.dart';
import 'driver_notifications_screen.dart';
import 'driver_trips_screen.dart';
import 'driver_widgets.dart';

class DriverDashboardScreen extends ConsumerWidget {
  const DriverDashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(driverDashboardProvider);
    final unread = driverInt(
      ref.watch(driverNotificationsProvider).valueOrNull?['unreadCount'],
    );
    final units = ref.watch(unitFormatterProvider),
        dates = ref.watch(appDateFormatterProvider);
    void refresh() {
      ref.invalidate(driverDashboardProvider);
      ref.invalidate(driverNotificationsProvider);
    }

    return DriverRefreshScope(
      onRefresh: refresh,
      child: OpenVtsPageScaffold(
        title: context.mobileText('Driver workspace'),
        actions: [
          IconButton(
            tooltip: context.mobileText('Messages'),
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DriverMessagesScreen(),
              ),
            ),
          ),
          IconButton(
            tooltip: context.mobileText('Notifications'),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DriverNotificationsScreen(),
              ),
            ),
          ),
        ],
        body: DriverAsyncBody(
          value: dashboard,
          onRetry: refresh,
          builder: (data) {
            final metrics = driverMap(data['metrics']),
                vehicle = driverMap(data['vehicle']),
                activeData = driverMap(data['activeAssignment']);
            final telemetry = driverMap(vehicle['telemetry']);
            final active = activeData.isEmpty
                ? null
                : DriverTrip.fromJson(activeData);
            return RefreshIndicator(
              onRefresh: () async {
                refresh();
                await ref.read(driverDashboardProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.mobileText('Your day'),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          DriverStatus(driverText(data['operationalStatus'])),
                          if (vehicle.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              driverText(vehicle['name']),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(driverText(vehicle['plateNumber'])),
                          ],
                          if (telemetry['speedKph'] != null)
                            Text(
                              units.speed(driverNumber(telemetry['speedKph'])),
                            ),
                          if (telemetry['lastUpdatedAt'] != null)
                            Text(
                              context.mobileText("Last update {value1}", {
                                'value1': (dates.formatDateTime(
                                  DateTime.tryParse(
                                    driverText(telemetry['lastUpdatedAt']),
                                  ),
                                )).toString(),
                              }),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final metric in <(String, String)>[
                          (
                            'Assignments today',
                            '${driverInt(metrics['assignmentsToday'])}',
                          ),
                          (
                            'Completed trips',
                            '${driverInt(metrics['completedTrips'])}',
                          ),
                          (
                            'Completed stops',
                            '${driverInt(metrics['completedStops'])}',
                          ),
                          (
                            'Pending stops',
                            '${driverInt(metrics['pendingStops'])}',
                          ),
                        ])
                          SizedBox(
                            width: (constraints.maxWidth - 8) / 2,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      metric.$2,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(metric.$1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      context.mobileText("Distance today: {value1}", {
                        'value1': (units.distance(
                          driverNumber(metrics['distanceKm']),
                        )).toString(),
                      }),
                    ),
                  ),
                  Text(
                    context.mobileText('Current assignment'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (active == null)
                    DriverEmpty(
                      context.mobileText(
                        'No active assignment. New trips appear here when dispatch assigns them.',
                      ),
                    )
                  else
                    DriverTripCard(
                      trip: active,
                      onTap: () => openDriverTrip(context, active.id),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DriverTripsScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.route_outlined),
                    label: Text(context.mobileText('View all trips')),
                  ),
                  if (driverItems(data['recentEvents']).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      context.mobileText('Recent activity'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    for (final event in driverItems(
                      data['recentEvents'],
                    ).take(5))
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(driverText(event['title'])),
                          subtitle: Text(driverText(event['detail'])),
                          onTap: driverText(event['assignmentId']).isEmpty
                              ? null
                              : () => openDriverTrip(
                                  context,
                                  driverText(event['assignmentId']),
                                ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
