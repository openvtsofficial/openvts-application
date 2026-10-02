import 'package:flutter/material.dart';

import '../../../../../shared/widgets/open_vts_searchable_dropdown.dart';
import '../../../models/user_dashboard_model.dart';

/// Converts a [UserDashboardVehicleOption] to a searchable dropdown option.
///
/// The [searchText] field carries the IMEI and vehicle ID so the search sheet
/// can match on them even though they are not shown in the main label.
OpenVtsDropdownOption<String> userDashboardVehicleOption(
  UserDashboardVehicleOption vehicle,
) {
  final plate = vehicle.plateNumber?.trim() ?? '';
  final label = plate.isNotEmpty ? '${vehicle.name} · $plate' : vehicle.name;
  final extras = [
    if ((vehicle.imei ?? '').isNotEmpty) vehicle.imei!,
    vehicle.id,
  ].join(' ');
  return OpenVtsDropdownOption<String>(
    value: vehicle.id,
    label: label,
    subtitle: plate.isNotEmpty ? plate : null,
    searchText: extras,
  );
}

/// Reusable searchable vehicle picker for User Dashboard widgets.
///
/// Pass [includeAll] = true (default) to add an "All Vehicles" sentinel at
/// the top (sentinel value: `'all'`). Sensor History must pass false because
/// it always requires a specific vehicle.
class UserDashboardVehicleSelector extends StatelessWidget {
  const UserDashboardVehicleSelector({
    required this.vehicles,
    required this.value,
    required this.onChanged,
    this.includeAll = true,
    super.key,
  });

  final List<UserDashboardVehicleOption> vehicles;

  /// Currently selected vehicle ID, or `'all'` when [includeAll] is true and
  /// no specific vehicle is selected.
  final String? value;

  final ValueChanged<String?> onChanged;

  /// Whether to prepend an "All Vehicles" option (value `'all'`).
  final bool includeAll;

  @override
  Widget build(BuildContext context) {
    final options = [
      if (includeAll)
        const OpenVtsDropdownOption<String>(
          value: 'all',
          label: 'All Vehicles',
        ),
      for (final vehicle in vehicles) userDashboardVehicleOption(vehicle),
    ];

    return OpenVtsSearchableDropdown<String>(
      label: 'Vehicle',
      options: options,
      value: value,
      searchHintText: 'Search by name, plate, IMEI or ID',
      onChanged: onChanged,
    );
  }
}
