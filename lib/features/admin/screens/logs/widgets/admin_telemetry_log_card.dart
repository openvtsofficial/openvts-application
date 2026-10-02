import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/admin_logs_model.dart';

const _fmt = DateTimeFormatter();

class AdminTelemetryLogCard extends StatelessWidget {
  const AdminTelemetryLogCard({
    super.key,
    required this.item,
    required this.vehicleLabel,
    required this.onTap,
  });

  final AdminTelemetryLogItem item;
  final String vehicleLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lat = item.latitude?.toStringAsFixed(5) ?? '-';
    final lng = item.longitude?.toStringAsFixed(5) ?? '-';
    final speedDisplay = item.speedKph?.toStringAsFixed(1) ?? '-';
    final ignitionDisplay =
        item.ignition == null ? '-' : (item.ignition! ? 'On' : 'Off');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: OpenVtsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${item.packetType} • ${vehicleLabel.isEmpty ? item.imei : vehicleLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.label
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: OpenVtsSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    icon: Icons.cloud_outlined,
                    label: 'Server',
                    value: item.serverTime == null
                        ? '-'
                        : _fmt.formatDateTime(item.serverTime!.toLocal()),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                Expanded(
                  child: _InfoRow(
                    icon: Icons.devices_outlined,
                    label: 'Device',
                    value: item.deviceTime == null
                        ? '-'
                        : _fmt.formatDateTime(item.deviceTime!.toLocal()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    icon: Icons.speed_outlined,
                    label: 'Speed',
                    value: '$speedDisplay kph',
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.xs),
                Expanded(
                  child: _InfoRow(
                    icon: Icons.power_outlined,
                    label: 'Ignition',
                    value: ignitionDisplay,
                  ),
                ),
              ],
            ),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: '$lat, $lng',
            ),
            if (item.distance != null || item.engineHours != null)
              _InfoRow(
                icon: Icons.route_outlined,
                label: 'Distance/Hours',
                value:
                    '${item.distance?.toStringAsFixed(2) ?? '-'} km • ${item.engineHours?.toStringAsFixed(2) ?? '-'} hrs',
              ),
            if (item.attributes.isNotEmpty) ...[
              const SizedBox(height: OpenVtsSpacing.xxs),
              Text(
                'Attributes: ${prettyJson(item.attributes).replaceAll('\n', ' ')}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.meta
                    .copyWith(color: OpenVtsColors.textSecondary),
              ),
            ],
            if (item.raw.trim().isNotEmpty) ...[
              const SizedBox(height: OpenVtsSpacing.xxs),
              Text(
                'Raw: ${item.raw}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.meta
                    .copyWith(color: OpenVtsColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: OpenVtsSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: OpenVtsColors.textSecondary),
          const SizedBox(width: OpenVtsSpacing.xs),
          if (label.isNotEmpty) ...[
            Text('$label: ',
                style: OpenVtsTypography.meta.copyWith(
                    color: OpenVtsColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ],
          Expanded(
            child: Text(
              value.trim().isEmpty ? '—' : value.trim(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
