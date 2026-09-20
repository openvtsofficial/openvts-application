import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../models/admin_vehicle_model.dart';

class AdminVehicleDetailsOverviewTab extends StatelessWidget {
  const AdminVehicleDetailsOverviewTab({
    super.key,
    required this.vehicle,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
    required this.isUpdatingStatus,
    required this.isDeleting,
  });

  final AdminVehicleDetails vehicle;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final bool isUpdatingStatus;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: _Section(
            title: 'Identity',
            items: [
              _SectionItem(label: 'Name', value: vehicle.name),
              _SectionItem(label: 'Plate Number', value: vehicle.plateNumber),
              _SectionItem(label: 'VIN', value: vehicle.vin),
              _SectionItem(
                  label: 'Type', value: vehicle.vehicleType?.name ?? '-'),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: _Section(
            title: 'Device',
            items: [
              _SectionItem(label: 'IMEI', value: vehicle.imei),
              _SectionItem(label: 'SIM', value: vehicle.simNumber),
              _SectionItem(
                label: 'Speed Variation',
                value: _num(vehicle.device?.speedVariation),
              ),
              _SectionItem(
                label: 'Distance Variation',
                value: _num(vehicle.device?.distanceVariation),
              ),
              _SectionItem(
                  label: 'Odometer', value: _num(vehicle.device?.odometer)),
              _SectionItem(
                  label: 'Engine Hours',
                  value: _num(vehicle.device?.engineHours)),
              _SectionItem(
                label: 'Ignition Source',
                value: vehicle.device?.ignitionSource ?? '-',
              ),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: _Section(
            title: 'Ownership',
            items: [
              _SectionItem(
                label: 'Primary User',
                value: vehicle.primaryUser?.displayName.isNotEmpty == true
                    ? vehicle.primaryUser!.displayName
                    : '-',
              ),
              _SectionItem(label: 'Plan', value: vehicle.plan?.name ?? '-'),
            ],
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: _Section(
            title: 'Dates',
            items: [
              _SectionItem(
                  label: 'Created At', value: _date(vehicle.createdAt)),
              _SectionItem(
                  label: 'Updated At', value: _date(vehicle.displayUpdatedAt)),
            ],
          ),
        ),
        if (vehicle.vehicleMeta.isNotEmpty) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          OpenVtsCard(
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: _Section(
              title: 'Metadata',
              items: vehicle.vehicleMeta.entries
                  .map((e) => _SectionItem(
                      label: e.key, value: e.value?.toString() ?? '-'))
                  .toList(growable: false),
            ),
          ),
        ],
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsCard(
          padding: const EdgeInsets.all(OpenVtsSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Actions', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: OpenVtsSpacing.sm),
              Wrap(
                spacing: OpenVtsSpacing.xs,
                runSpacing: OpenVtsSpacing.xs,
                children: [
                  OpenVtsButton(label: 'Edit', onPressed: onEdit),
                  OpenVtsButton(
                    label: vehicle.isActive ? 'Deactivate' : 'Activate',
                    onPressed: isUpdatingStatus ? null : onToggleStatus,
                    isLoading: isUpdatingStatus,
                    variant: OpenVtsButtonVariant.secondary,
                  ),
                  OpenVtsButton(
                    label: 'Delete',
                    onPressed: isDeleting ? null : onDelete,
                    isLoading: isDeleting,
                    variant: OpenVtsButtonVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _date(DateTime? value) {
    if (value == null) return '-';
    return value
        .toLocal()
        .toIso8601String()
        .replaceFirst('T', ' ')
        .split('.')
        .first;
  }

  String _num(num? value) => value == null ? '-' : value.toString();
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<_SectionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: OpenVtsSpacing.sm),
        ...items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : OpenVtsSpacing.xs),
            child: _LabelValueRow(
              label: entry.value.label,
              value: entry.value.value,
            ),
          );
        }),
      ],
    );
  }
}

class _SectionItem {
  const _SectionItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayValue = value.trim().isEmpty ? '-' : value;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: OpenVtsTypography.meta.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            displayValue,
            style: OpenVtsTypography.meta.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
