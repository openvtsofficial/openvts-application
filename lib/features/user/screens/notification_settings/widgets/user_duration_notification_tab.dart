import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../models/user_notification_settings_model.dart';
import 'user_notification_channel_card.dart';
import 'user_notification_compact_toggle.dart';
import 'user_notification_vehicle_card.dart';

class UserDurationNotificationTab extends StatelessWidget {
  const UserDurationNotificationTab({
    required this.preferences,
    required this.channelFlags,
    required this.onChannelChanged,
    required this.onEnabledChanged,
    required this.onLimitChanged,
    super.key,
  });

  final UserNotificationPreferences preferences;
  final UserNotificationChannelFlags channelFlags;
  final void Function(UserNotificationChannel channel, bool value)
      onChannelChanged;
  final void Function(
          int vehicleId, UserDurationNotificationKind kind, bool value)
      onEnabledChanged;
  final void Function(
          int vehicleId, UserDurationNotificationKind kind, int? minutes)
      onLimitChanged;

  @override
  Widget build(BuildContext context) {
    final rows = <int, UserDurationNotificationRow>{
      for (final row in preferences.duration) row.vehicleId: row,
    };
    return Column(children: [
      UserNotificationChannelCard(
        selectedGroup: UserNotificationGroup.duration,
        flags: channelFlags,
        onChanged: onChannelChanged,
      ),
      const SizedBox(height: OpenVtsSpacing.sm),
      if (preferences.vehicles.isEmpty)
        const OpenVtsEmptyState(
          title: 'No vehicles assigned yet.',
          message: 'Assign vehicles to configure duration notifications.',
        )
      else
        ...preferences.vehicles.map((vehicle) {
          final row = rows[vehicle.id] ??
              UserDurationNotificationRow(vehicleId: vehicle.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
            child: UserNotificationVehicleCard(
              vehicleName:
                  userNotificationVehicleName(vehicle.name, vehicle.id),
              plateNumber: userNotificationVehiclePlate(vehicle.plateNumber),
              child: Column(children: [
                _DurationSetting(
                  label: 'Continuous Running',
                  kind: UserDurationNotificationKind.running,
                  enabled: row.runningEnabled,
                  minutes: row.runningLimitMinutes,
                  onEnabled: (value) => onEnabledChanged(
                      vehicle.id, UserDurationNotificationKind.running, value),
                  onMinutes: (value) => onLimitChanged(
                      vehicle.id, UserDurationNotificationKind.running, value),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                _DurationSetting(
                  label: 'Continuous Stop',
                  kind: UserDurationNotificationKind.stop,
                  enabled: row.stopEnabled,
                  minutes: row.stopLimitMinutes,
                  onEnabled: (value) => onEnabledChanged(
                      vehicle.id, UserDurationNotificationKind.stop, value),
                  onMinutes: (value) => onLimitChanged(
                      vehicle.id, UserDurationNotificationKind.stop, value),
                ),
                const SizedBox(height: OpenVtsSpacing.sm),
                _DurationSetting(
                  label: 'Continuous Idle',
                  kind: UserDurationNotificationKind.idle,
                  enabled: row.idleEnabled,
                  minutes: row.idleLimitMinutes,
                  onEnabled: (value) => onEnabledChanged(
                      vehicle.id, UserDurationNotificationKind.idle, value),
                  onMinutes: (value) => onLimitChanged(
                      vehicle.id, UserDurationNotificationKind.idle, value),
                ),
              ]),
            ),
          );
        }),
    ]);
  }
}

class _DurationSetting extends StatelessWidget {
  const _DurationSetting({
    required this.label,
    required this.kind,
    required this.enabled,
    required this.minutes,
    required this.onEnabled,
    required this.onMinutes,
  });

  final String label;
  final UserDurationNotificationKind kind;
  final bool enabled;
  final int? minutes;
  final ValueChanged<bool> onEnabled;
  final ValueChanged<int?> onMinutes;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      UserNotificationCompactToggle(
        label: label,
        icon: switch (kind) {
          UserDurationNotificationKind.running => Icons.route_rounded,
          UserDurationNotificationKind.stop => Icons.stop_circle_outlined,
          UserDurationNotificationKind.idle => Icons.hourglass_empty_rounded,
        },
        semanticsLabel: '$label notification',
        value: enabled,
        onChanged: onEnabled,
      ),
      const SizedBox(height: OpenVtsSpacing.xs),
      TextFormField(
        initialValue: minutes?.toString() ?? '',
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Minutes',
          hintText: '1–10080',
          isDense: true,
        ),
        style: OpenVtsTypography.body,
        onChanged: (value) => onMinutes(int.tryParse(value.trim())),
      ),
    ]);
  }
}
