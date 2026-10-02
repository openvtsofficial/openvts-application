import 'package:flutter/material.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../models/user_report_model.dart';
import '../../../../models/user_report_state.dart';

/// Vehicle scope selector — supports All / Single / Multiple / Group modes.
/// Opens a bottom sheet picker for single/multiple/group vehicle selection.
class UserReportVehicleScopeSelector extends StatelessWidget {
  const UserReportVehicleScopeSelector({
    required this.scope,
    required this.options,
    required this.onScopeChanged,
    this.forceSingle = false,
    this.disabled = false,
    this.error,
    super.key,
  });

  final ReportVehicleScope scope;
  final UserReportOptions options;
  final ValueChanged<ReportVehicleScope> onScopeChanged;
  final bool forceSingle;
  final bool disabled;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!forceSingle) ...[
          _ScopeModeRow(
              scope: scope, onChanged: onScopeChanged, disabled: disabled),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
        _ScopeDetailWidget(
            scope: scope,
            options: options,
            onScopeChanged: onScopeChanged,
            forceSingle: forceSingle,
            disabled: disabled,
            isDark: isDark),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(error!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)),
        ],
      ],
    );
  }
}

class _ScopeModeRow extends StatelessWidget {
  const _ScopeModeRow(
      {required this.scope, required this.onChanged, required this.disabled});
  final ReportVehicleScope scope;
  final ValueChanged<ReportVehicleScope> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    const modes = [
      (ReportScopeMode.all, 'All'),
      (ReportScopeMode.single, 'Single'),
      (ReportScopeMode.multiple, 'Multiple'),
      (ReportScopeMode.group, 'Group'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: modes.map((m) {
          final isSelected = scope.mode == m.$1;
          return Padding(
            padding: const EdgeInsets.only(right: OpenVtsSpacing.xs),
            child: _ModeChip(
                label: m.$2,
                selected: isSelected,
                onTap: disabled
                    ? null
                    : () {
                        switch (m.$1) {
                          case ReportScopeMode.all:
                            onChanged(const ReportVehicleScope.all());
                          case ReportScopeMode.single:
                            onChanged(const ReportVehicleScope.single(''));
                          case ReportScopeMode.multiple:
                            onChanged(const ReportVehicleScope.multiple([]));
                          case ReportScopeMode.group:
                            onChanged(const ReportVehicleScope.group(''));
                        }
                      }),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                  ? OpenVtsColors.darkTextPrimary
                  : OpenVtsColors.brandInk)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
        ),
        child: Text(
          label,
          style: OpenVtsTypography.meta.copyWith(
            color: selected
                ? (isDark ? OpenVtsColors.brandInk : OpenVtsColors.white)
                : (isDark
                    ? OpenVtsColors.darkTextSecondary
                    : OpenVtsColors.textSecondary),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ScopeDetailWidget extends StatelessWidget {
  const _ScopeDetailWidget(
      {required this.scope,
      required this.options,
      required this.onScopeChanged,
      required this.forceSingle,
      required this.disabled,
      required this.isDark});
  final ReportVehicleScope scope;
  final UserReportOptions options;
  final ValueChanged<ReportVehicleScope> onScopeChanged;
  final bool forceSingle;
  final bool disabled;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final mode = forceSingle ? ReportScopeMode.single : scope.mode;
    return switch (mode) {
      ReportScopeMode.all =>
        _AllDescription(count: options.vehicles.length, isDark: isDark),
      ReportScopeMode.single => _SingleVehiclePicker(
          selected: scope.vehicleId,
          vehicles: options.vehicles,
          onChanged: (id) =>
              onScopeChanged(ReportVehicleScope.single(id ?? '')),
          disabled: disabled),
      ReportScopeMode.multiple => _MultiVehiclePicker(
          selected: scope.vehicleIds,
          vehicles: options.vehicles,
          onChanged: (ids) => onScopeChanged(ReportVehicleScope.multiple(ids)),
          disabled: disabled),
      ReportScopeMode.group => _GroupPicker(
          selected: scope.groupId,
          groups: options.groups,
          onChanged: (id) => onScopeChanged(ReportVehicleScope.group(id ?? '')),
          disabled: disabled),
    };
  }
}

class _AllDescription extends StatelessWidget {
  const _AllDescription({required this.count, required this.isDark});
  final int count;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car_rounded, size: 16),
          const SizedBox(width: OpenVtsSpacing.xs),
          Text('All $count vehicles will be included',
              style: OpenVtsTypography.body),
        ],
      ),
    );
  }
}

class _SingleVehiclePicker extends StatelessWidget {
  const _SingleVehiclePicker(
      {required this.selected,
      required this.vehicles,
      required this.onChanged,
      required this.disabled});
  final String? selected;
  final List<UserReportVehicleOption> vehicles;
  final ValueChanged<String?> onChanged;
  final bool disabled;

  UserReportVehicleOption? get _selectedVehicle =>
      selected == null || selected!.isEmpty
          ? null
          : vehicles.firstWhereOrNull((v) => v.id == selected);

  @override
  Widget build(BuildContext context) {
    final vehicle = _selectedVehicle;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: disabled ? null : () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.all(OpenVtsSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_car_outlined, size: 16),
            const SizedBox(width: OpenVtsSpacing.xs),
            Expanded(
                child: Text(vehicle?.displayName ?? 'Select a vehicle',
                    style: OpenVtsTypography.body.copyWith(
                        color: vehicle == null
                            ? (isDark
                                ? OpenVtsColors.darkTextSecondary
                                : OpenVtsColors.textSecondary)
                            : null))),
            const Icon(Icons.unfold_more_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final id = await _VehiclePickerSheet.show(context,
        vehicles: vehicles,
        selectedIds:
            selected != null && selected!.isNotEmpty ? {selected!} : {},
        multi: false);
    if (id != null && id.isNotEmpty) onChanged(id.first);
  }
}

class _MultiVehiclePicker extends StatelessWidget {
  const _MultiVehiclePicker(
      {required this.selected,
      required this.vehicles,
      required this.onChanged,
      required this.disabled});
  final List<String> selected;
  final List<UserReportVehicleOption> vehicles;
  final ValueChanged<List<String>> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: disabled ? null : () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.all(OpenVtsSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.checklist_rounded, size: 16),
            const SizedBox(width: OpenVtsSpacing.xs),
            Expanded(
                child: Text(
                    selected.isEmpty
                        ? 'Select vehicles'
                        : '${selected.length} vehicle${selected.length == 1 ? '' : 's'} selected',
                    style: OpenVtsTypography.body)),
            if (selected.isNotEmpty) ...[
              GestureDetector(
                  onTap: () => onChanged([]),
                  child: const Icon(Icons.close_rounded, size: 16)),
              const SizedBox(width: 4),
            ],
            const Icon(Icons.unfold_more_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final ids = await _VehiclePickerSheet.show(context,
        vehicles: vehicles,
        selectedIds: Set<String>.from(selected),
        multi: true);
    if (ids != null) onChanged(ids.toList());
  }
}

class _GroupPicker extends StatelessWidget {
  const _GroupPicker(
      {required this.selected,
      required this.groups,
      required this.onChanged,
      required this.disabled});
  final String? selected;
  final List<UserReportGroupOption> groups;
  final ValueChanged<String?> onChanged;
  final bool disabled;

  UserReportGroupOption? get _selectedGroup =>
      selected == null || selected!.isEmpty
          ? null
          : groups.firstWhereOrNull((g) => g.id == selected);

  @override
  Widget build(BuildContext context) {
    final group = _selectedGroup;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: disabled ? null : () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.all(OpenVtsSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.white,
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.folder_outlined, size: 16),
            const SizedBox(width: OpenVtsSpacing.xs),
            Expanded(
                child: Text(
                    group != null
                        ? '${group.name} (${group.vehicleCount})'
                        : 'Select a vehicle group',
                    style: OpenVtsTypography.body.copyWith(
                        color: group == null
                            ? (isDark
                                ? OpenVtsColors.darkTextSecondary
                                : OpenVtsColors.textSecondary)
                            : null))),
            const Icon(Icons.unfold_more_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl))),
      builder: (_) => _GroupPickerSheet(
          groups: groups, selectedId: selected, onChanged: onChanged),
    );
  }
}

// ---------------------------------------------------------------------------
// Vehicle picker bottom sheet
// ---------------------------------------------------------------------------

class _VehiclePickerSheet extends StatefulWidget {
  const _VehiclePickerSheet(
      {required this.vehicles, required this.selectedIds, required this.multi});
  final List<UserReportVehicleOption> vehicles;
  final Set<String> selectedIds;
  final bool multi;

  static Future<Set<String>?> show(BuildContext context,
      {required List<UserReportVehicleOption> vehicles,
      required Set<String> selectedIds,
      required bool multi}) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl))),
      builder: (_) => _VehiclePickerSheet(
          vehicles: vehicles, selectedIds: Set.from(selectedIds), multi: multi),
    );
  }

  @override
  State<_VehiclePickerSheet> createState() => _VehiclePickerSheetState();
}

class _VehiclePickerSheetState extends State<_VehiclePickerSheet> {
  late Set<String> _selected;
  String _query = '';
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedIds);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<UserReportVehicleOption> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.vehicles;
    return widget.vehicles.where((v) {
      return v.name.toLowerCase().contains(q) ||
          (v.plateNumber?.toLowerCase().contains(q) ?? false) ||
          v.imei.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Column(
        children: [
          const SizedBox(height: OpenVtsSpacing.sm),
          Center(
              child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: OpenVtsSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        widget.multi ? 'Select Vehicles' : 'Select Vehicle',
                        style: OpenVtsTypography.titleSmall)),
                if (widget.multi && _selected.isNotEmpty)
                  TextButton(
                      onPressed: () => setState(() => _selected.clear()),
                      child: Text('Clear', style: OpenVtsTypography.meta)),
                if (widget.multi)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: Text('Done (${_selected.length})',
                        style: OpenVtsTypography.label
                            .copyWith(fontWeight: FontWeight.w700)),
                  )
                else
                  IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).maybePop()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: _SearchField(
                controller: _controller,
                onChanged: (q) => setState(() => _query = q)),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Divider(
              height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          if (widget.multi) ...[
            ListTile(
              dense: true,
              leading: Checkbox(
                  value: _selected.length == filtered.length &&
                      filtered.isNotEmpty,
                  onChanged: (v) => setState(() {
                        if (v == true) {
                          _selected.addAll(filtered.map((v) => v.id));
                        } else {
                          _selected.removeAll(filtered.map((v) => v.id));
                        }
                      }),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
              title: Text('Select all visible (${filtered.length})',
                  style: OpenVtsTypography.body),
              onTap: () => setState(() {
                if (_selected.length == filtered.length) {
                  _selected.clear();
                } else {
                  _selected.addAll(filtered.map((v) => v.id));
                }
              }),
            ),
            Divider(
                height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          ],
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No vehicles found',
                            style: OpenVtsTypography.body)))
                : ListView.builder(
                    controller: scrollCtrl,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final v = filtered[i];
                      final isSelected = _selected.contains(v.id);
                      return ListTile(
                        leading: widget.multi
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (_) => _toggle(v.id),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap)
                            : Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_off_rounded,
                                size: 20,
                                color: isSelected
                                    ? (isDark
                                        ? OpenVtsColors.darkTextPrimary
                                        : OpenVtsColors.brandInk)
                                    : Theme.of(context).colorScheme.outline),
                        title: Text(v.displayName,
                            style: OpenVtsTypography.body.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400)),
                        subtitle: v.imei.isNotEmpty
                            ? Text(v.imei,
                                style: OpenVtsTypography.meta.copyWith(
                                    color: OpenVtsColors.textSecondary))
                            : null,
                        onTap: () {
                          if (widget.multi) {
                            _toggle(v.id);
                          } else {
                            Navigator.of(context).pop({v.id});
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _toggle(String id) => setState(() {
        if (_selected.contains(id)) {
          _selected.remove(id);
        } else {
          _selected.add(id);
        }
      });
}

class _GroupPickerSheet extends StatefulWidget {
  const _GroupPickerSheet(
      {required this.groups,
      required this.selectedId,
      required this.onChanged});
  final List<UserReportGroupOption> groups;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  @override
  State<_GroupPickerSheet> createState() => _GroupPickerSheetState();
}

class _GroupPickerSheetState extends State<_GroupPickerSheet> {
  String _query = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<UserReportGroupOption> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.groups;
    return widget.groups
        .where((g) => g.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Column(
        children: [
          const SizedBox(height: OpenVtsSpacing.sm),
          Center(
              child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: OpenVtsSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: Row(
              children: [
                const Expanded(
                    child: Text('Select Group',
                        style: OpenVtsTypography.titleSmall)),
                IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).maybePop()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: _SearchField(
                controller: _controller,
                onChanged: (q) => setState(() => _query = q)),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Divider(
              height: 1, color: Theme.of(context).colorScheme.outlineVariant),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child:
                        Text('No groups found', style: OpenVtsTypography.body))
                : ListView.builder(
                    controller: ctrl,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final g = filtered[i];
                      final isSelected = widget.selectedId == g.id;
                      return ListTile(
                        leading: Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.folder_outlined,
                            size: 20,
                            color: isSelected
                                ? (isDark
                                    ? OpenVtsColors.darkTextPrimary
                                    : OpenVtsColors.brandInk)
                                : null),
                        title: Text(g.name,
                            style: OpenVtsTypography.body.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400)),
                        subtitle: Text(
                            '${g.vehicleCount} vehicle${g.vehicleCount == 1 ? '' : 's'}',
                            style: OpenVtsTypography.meta
                                .copyWith(color: OpenVtsColors.textSecondary)),
                        onTap: () {
                          widget.onChanged(g.id);
                          Navigator.of(context).maybePop();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 16),
          hintText: 'Search…',
          hintStyle: OpenVtsTypography.body.copyWith(
              color: isDark
                  ? OpenVtsColors.darkTextSecondary
                  : OpenVtsColors.textSecondary),
          isDense: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              borderSide: BorderSide(
                  color: isDark
                      ? OpenVtsColors.darkBorder
                      : OpenVtsColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              borderSide: BorderSide(
                  color: isDark
                      ? OpenVtsColors.darkBorder
                      : OpenVtsColors.border)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

extension _ListWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
