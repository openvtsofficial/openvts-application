import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/open_vts_spacing.dart';
import '../../core/theme/open_vts_typography.dart';
import '../../core/utils/unit_formatter.dart';
import '../models/vehicle_summary.dart';
import 'open_vts_card.dart';
import 'open_vts_status_chip.dart';

class VehicleCard extends ConsumerWidget {
  const VehicleCard({
    required this.vehicle,
    this.onTap,
    super.key,
  });

  final VehicleSummary vehicle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusType = switch (vehicle.status.toLowerCase()) {
      'online' || 'moving' => OpenVtsStatusType.success,
      'idle' => OpenVtsStatusType.warning,
      'offline' => OpenVtsStatusType.neutral,
      _ => OpenVtsStatusType.info,
    };

    return OpenVtsCard(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined, size: 24),
          const SizedBox(width: OpenVtsSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.name, style: OpenVtsTypography.titleSmall),
                const SizedBox(height: OpenVtsSpacing.xxs),
                Text(vehicle.plateNumber, style: OpenVtsTypography.meta),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OpenVtsStatusChip(label: vehicle.status, type: statusType),
              const SizedBox(height: OpenVtsSpacing.xs),
              Text(ref.watch(unitFormatterProvider).speed(vehicle.speed),
                  style: OpenVtsTypography.meta),
            ],
          ),
        ],
      ),
    );
  }
}
