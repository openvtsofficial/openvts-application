import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_card.dart';

class UserNotificationVehicleCard extends StatelessWidget {
  const UserNotificationVehicleCard({
    required this.vehicleName,
    required this.plateNumber,
    required this.child,
    super.key,
  });

  final String vehicleName;
  final String plateNumber;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : OpenVtsColors.surface,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  border: Border.all(
                    color: isDark ? OpenVtsColors.white : OpenVtsColors.border,
                  ),
                ),
                child: Icon(
                  Icons.directions_car_outlined,
                  size: 14,
                  color: isDark
                      ? OpenVtsColors.white.withValues(alpha: 0.7)
                      : OpenVtsColors.textSecondary,
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleName,
                      style: OpenVtsTypography.body.copyWith(
                        color: isDark
                            ? OpenVtsColors.white
                            : OpenVtsColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      plateNumber,
                      style: OpenVtsTypography.meta.copyWith(
                        color: isDark
                            ? OpenVtsColors.white.withValues(alpha: 0.7)
                            : OpenVtsColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          child,
        ],
      ),
    );
  }
}

String userNotificationVehicleName(String name, int vehicleId) {
  final normalized = name.trim();
  if (normalized.isNotEmpty) {
    return normalized;
  }

  return 'Vehicle #$vehicleId';
}

String userNotificationVehiclePlate(String plateNumber) {
  final normalized = plateNumber.trim();
  return normalized.isEmpty ? 'No plate' : normalized;
}
