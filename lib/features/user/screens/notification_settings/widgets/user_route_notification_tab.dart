import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../models/user_notification_settings_model.dart';
import 'user_notification_channel_card.dart';
import 'user_notification_compact_toggle.dart';
import 'user_notification_vehicle_card.dart';

class UserRouteNotificationTab extends StatelessWidget {
  const UserRouteNotificationTab({
    required this.preferences,
    required this.channelFlags,
    required this.onChannelChanged,
    required this.onRouteToggle,
    super.key,
  });

  final UserNotificationPreferences preferences;
  final UserNotificationChannelFlags channelFlags;
  final void Function(UserNotificationChannel channel, bool value)
      onChannelChanged;
  final void Function(int vehicleId, int routeId, bool value) onRouteToggle;

  @override
  Widget build(BuildContext context) {
    final enabled = <String, bool>{
      for (final row in preferences.routeMatrix)
        '${row.vehicleId}:${row.routeId}': row.enabled,
    };
    return Column(children: [
      UserNotificationChannelCard(
        selectedGroup: UserNotificationGroup.route,
        flags: channelFlags,
        onChanged: onChannelChanged,
      ),
      const SizedBox(height: OpenVtsSpacing.sm),
      if (preferences.routes.isEmpty)
        const OpenVtsEmptyState(
          title: 'No routes available.',
          message: 'Create routes to configure route deviation notifications.',
        )
      else if (preferences.vehicles.isEmpty)
        const OpenVtsEmptyState(
          title: 'No vehicles assigned yet.',
          message: 'Assign vehicles to configure route notifications.',
        )
      else
        ...preferences.vehicles.map((vehicle) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
              child: UserNotificationVehicleCard(
                vehicleName:
                    userNotificationVehicleName(vehicle.name, vehicle.id),
                plateNumber: userNotificationVehiclePlate(vehicle.plateNumber),
                child: Column(
                  children: preferences.routes.map((route) {
                    final tolerance = route.toleranceMeters == null
                        ? null
                        : '${route.toleranceMeters!.round()} m tolerance';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserNotificationCompactToggle(
                            label: route.name.trim().isEmpty
                                ? 'Route #${route.id}'
                                : route.name.trim(),
                            icon: Icons.alt_route_rounded,
                            semanticsLabel:
                                'Route deviation ${route.name} for ${vehicle.name}',
                            value:
                                enabled['${vehicle.id}:${route.id}'] ?? false,
                            enabled: route.isActive,
                            onChanged: (value) =>
                                onRouteToggle(vehicle.id, route.id, value),
                          ),
                          if (tolerance != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 36),
                              child: Text(tolerance,
                                  style: OpenVtsTypography.meta),
                            ),
                        ],
                      ),
                    );
                  }).toList(growable: false),
                ),
              ),
            )),
    ]);
  }
}
