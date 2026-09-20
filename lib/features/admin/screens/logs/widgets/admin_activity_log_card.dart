import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/admin_logs_model.dart';

const _fmt = DateTimeFormatter();

class AdminActivityLogCard extends StatelessWidget {
  const AdminActivityLogCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final AdminActivityLogItem item;
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
            Text(item.humanAction,
                style: OpenVtsTypography.label
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: OpenVtsSpacing.xxs),
            Text(item.action,
                style: OpenVtsTypography.meta
                    .copyWith(color: OpenVtsColors.textSecondary)),
            const SizedBox(height: OpenVtsSpacing.xs),
            if (item.entity.isNotEmpty)
              _InfoRow(
                icon: Icons.category_outlined,
                label: 'Entity',
                value:
                    '${item.entity}${item.entityId.isEmpty ? '' : ' • ${item.entityId}'}',
              ),
            _InfoRow(
              icon: Icons.person_outline,
              label: 'By',
              value:
                  '${item.actorDisplay}${item.userLoginType.isEmpty ? '' : ' • ${item.userLoginType}'}',
            ),
            if (item.ip.isNotEmpty ||
                item.browser.isNotEmpty ||
                item.platform.isNotEmpty)
              _InfoRow(
                icon: Icons.devices_outlined,
                label: 'Device',
                value:
                    '${item.ip.isEmpty ? '-' : item.ip} • ${item.browser.isEmpty ? '-' : item.browser}',
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
