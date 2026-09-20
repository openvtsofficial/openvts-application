import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_status_chip.dart';
import '../../../models/admin_logs_model.dart';

const _fmt = DateTimeFormatter();

class AdminVehicleEventLogCard extends StatelessWidget {
  const AdminVehicleEventLogCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final AdminVehicleEventLogItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: OpenVtsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.title.isEmpty ? 'Vehicle Event' : item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.label
                          .copyWith(fontWeight: FontWeight.w700)),
                ),
                OpenVtsStatusChip(
                  label: item.severity,
                  type: item.severity == 'CRITICAL'
                      ? OpenVtsStatusType.error
                      : item.severity == 'WARNING'
                          ? OpenVtsStatusType.warning
                          : OpenVtsStatusType.info,
                ),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            Text(item.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.body.copyWith(fontSize: 13)),
            const SizedBox(height: OpenVtsSpacing.xs),
            _InfoRow(
              icon: Icons.directions_car_outlined,
              label: 'Vehicle',
              value:
                  '${item.vehicleName.isEmpty ? '-' : item.vehicleName}${item.plateNumber.isEmpty ? '' : ' (${item.plateNumber})'}',
            ),
            _InfoRow(
              icon: Icons.hub_outlined,
              label: 'Source',
              value: item.source.isEmpty ? '-' : item.source,
            ),
            _InfoRow(
              icon: Icons.person_outline,
              label: 'User',
              value: item.userName.isEmpty ? '-' : item.userName,
            ),
            _InfoRow(
              icon: Icons.schedule_outlined,
              label: '',
              value: item.createdAt == null
                  ? '-'
                  : _fmt.formatDateTime(item.createdAt!.toLocal()),
            ),
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
