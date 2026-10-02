import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../core/utils/date_time_formatter.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../../shared/widgets/open_vts_card.dart';
import '../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/superadmin_providers.dart';
import '../../models/superadmin_vehicle_model.dart';

const DateTimeFormatter _vehicleFmt = DateTimeFormatter();
const List<int> _recordsPerPageOptions = <int>[10, 25, 50, 100];

enum _VehicleStatusFilter {
  all,
  active,
  inactive;

  String get label {
    switch (this) {
      case _VehicleStatusFilter.all:
        return 'All statuses';
      case _VehicleStatusFilter.active:
        return 'Active';
      case _VehicleStatusFilter.inactive:
        return 'Inactive';
    }
  }
}

enum _VehicleSortOption {
  newest,
  oldest,
  nameAscending,
  nameDescending,
  activeFirst;

  String get label {
    switch (this) {
      case _VehicleSortOption.newest:
        return 'Newest first';
      case _VehicleSortOption.oldest:
        return 'Oldest first';
      case _VehicleSortOption.nameAscending:
        return 'Name A-Z';
      case _VehicleSortOption.nameDescending:
        return 'Name Z-A';
      case _VehicleSortOption.activeFirst:
        return 'Active first';
    }
  }
}

class SuperadminVehiclesScreen extends ConsumerStatefulWidget {
  const SuperadminVehiclesScreen({super.key});

  @override
  ConsumerState<SuperadminVehiclesScreen> createState() =>
      _SuperadminVehiclesScreenState();
}

class _SuperadminVehiclesScreenState
    extends ConsumerState<SuperadminVehiclesScreen> {
  String _searchQuery = '';
  _VehicleStatusFilter _statusFilter = _VehicleStatusFilter.all;
  _VehicleSortOption _sortOption = _VehicleSortOption.newest;
  bool _isRefreshing = false;
  int _recordsPerPage = 10;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(superadminVehiclePageProvider);

    return OpenVtsPageScaffold(
      title: 'Vehicles',
      headerMode: OpenVtsPageHeaderMode.closeable,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: OpenVtsSpacing.xs),
          child: IconButton(
            tooltip: 'Refresh vehicles',
            onPressed: _isRefreshing ? null : _refreshVehicles,
            icon: _isRefreshing
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded, size: 20),
          ),
        ),
      ],
      padding: const EdgeInsetsDirectional.fromSTEB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
      ),
      body: state.when(
        skipLoadingOnRefresh: true,
        loading: () => const OpenVtsLoader(),
        error: (error, stackTrace) => OpenVtsErrorView(
          message: 'Vehicles could not be loaded.',
          onRetry: _refreshVehicles,
        ),
        data: _buildLoadedState,
      ),
    );
  }

  Widget _buildLoadedState(SuperadminVehiclePage page) {
    final filteredVehicles = _applyFilters(page.items);
    final pageCount = filteredVehicles.isEmpty
        ? 1
        : (filteredVehicles.length / _recordsPerPage).ceil();
    final safeCurrentPage = _currentPage < 1
        ? 1
        : (_currentPage > pageCount ? pageCount : _currentPage);
    final start = (safeCurrentPage - 1) * _recordsPerPage;
    final visibleVehicles = start >= filteredVehicles.length
        ? const <SuperadminVehicleRecord>[]
        : filteredVehicles
            .skip(start)
            .take(_recordsPerPage)
            .toList(growable: false);
    final hasActiveFilters = _statusFilter != _VehicleStatusFilter.all;

    return Column(
      children: [
        _VehiclesToolbar(
          searchQuery: _searchQuery,
          recordsPerPage: _recordsPerPage,
          hasActiveFilters: hasActiveFilters,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
              _currentPage = 1;
            });
          },
          onOpenFilters: () => _openFiltersSheet(context),
          onOpenSort: () => _openSortSheet(context),
          onRecordsChanged: (value) {
            setState(() {
              _recordsPerPage = value;
              _currentPage = 1;
            });
          },
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshVehicles,
            child: filteredVehicles.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: OpenVtsSpacing.section),
                      OpenVtsEmptyState(
                        title: 'No vehicles found',
                        message: 'Try a different search or filter.',
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: visibleVehicles.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: OpenVtsSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index == visibleVehicles.length) {
                        return _PaginationFooter(
                          currentPage: safeCurrentPage,
                          pageCount: pageCount,
                          showingCount: visibleVehicles.length,
                          totalCount: filteredVehicles.length,
                          onPrev: () {
                            setState(() {
                              _currentPage = safeCurrentPage - 1;
                            });
                          },
                          onNext: () {
                            setState(() {
                              _currentPage = safeCurrentPage + 1;
                            });
                          },
                        );
                      }

                      return _VehicleCard(vehicle: visibleVehicles[index]);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _openFiltersSheet(BuildContext context) async {
    var selectedStatus = _statusFilter;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(OpenVtsRadius.xl),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _OptionsSheet(
              title: 'Filter vehicles',
              sections: [
                _OptionsSheetSection(
                  label: 'Status',
                  child: Wrap(
                    spacing: OpenVtsSpacing.xs,
                    runSpacing: OpenVtsSpacing.xs,
                    children: _VehicleStatusFilter.values
                        .map(
                          (option) => _ChoiceChip(
                            label: option.label,
                            selected: selectedStatus == option,
                            onSelected: () => setSheetState(
                              () => selectedStatus = option,
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ],
              primaryActionLabel: 'Apply filters',
              onPrimaryAction: () {
                setState(() {
                  _statusFilter = selectedStatus;
                  _currentPage = 1;
                });
                Navigator.of(sheetContext).pop();
              },
              secondaryActionLabel: 'Reset',
              onSecondaryAction: () {
                setSheetState(() {
                  selectedStatus = _VehicleStatusFilter.all;
                });
              },
            );
          },
        );
      },
    );
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final selectedSort = _sortOption;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(OpenVtsRadius.xl),
        ),
      ),
      builder: (sheetContext) {
        return _OptionsSheet(
          title: 'Sort vehicles',
          sections: [
            _OptionsSheetSection(
              label: 'Order by',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _VehicleSortOption.values
                    .map(
                      (option) => _RadioRow(
                        label: option.label,
                        selected: selectedSort == option,
                        onTap: () {
                          setState(() {
                            _sortOption = option;
                            _currentPage = 1;
                          });
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshVehicles() async {
    if (_isRefreshing) {
      return;
    }

    setState(() {
      _isRefreshing = true;
    });

    try {
      ref.invalidate(superadminVehiclePageProvider);
      await ref.read(superadminVehiclePageProvider.future);
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  List<SuperadminVehicleRecord> _applyFilters(
    List<SuperadminVehicleRecord> vehicles,
  ) {
    final normalizedQuery = _searchQuery.toLowerCase();
    final filtered = vehicles.where((vehicle) {
      final matchesSearch = normalizedQuery.isEmpty ||
          vehicle.searchContent.contains(normalizedQuery);
      final normalizedStatus = vehicle.status.trim().toLowerCase();
      final matchesStatus = switch (_statusFilter) {
        _VehicleStatusFilter.all => true,
        _VehicleStatusFilter.active => normalizedStatus == 'active',
        _VehicleStatusFilter.inactive => normalizedStatus == 'inactive',
      };

      return matchesSearch && matchesStatus;
    }).toList();

    filtered.sort((left, right) {
      switch (_sortOption) {
        case _VehicleSortOption.newest:
          return _vehicleDate(right).compareTo(_vehicleDate(left));
        case _VehicleSortOption.oldest:
          return _vehicleDate(left).compareTo(_vehicleDate(right));
        case _VehicleSortOption.nameAscending:
          return left.name.toLowerCase().compareTo(right.name.toLowerCase());
        case _VehicleSortOption.nameDescending:
          return right.name.toLowerCase().compareTo(left.name.toLowerCase());
        case _VehicleSortOption.activeFirst:
          final statusComparison = _statusRank(left).compareTo(
            _statusRank(right),
          );
          if (statusComparison != 0) {
            return statusComparison;
          }
          return _vehicleDate(right).compareTo(_vehicleDate(left));
      }
    });
    return filtered;
  }

  DateTime _vehicleDate(SuperadminVehicleRecord vehicle) {
    return vehicle.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  int _statusRank(SuperadminVehicleRecord vehicle) {
    switch (vehicle.status.trim().toLowerCase()) {
      case 'active':
        return 0;
      case 'idle':
        return 1;
      case 'inactive':
        return 2;
      case 'offline':
        return 3;
      default:
        return 4;
    }
  }
}

// ---------------------------------------------------------------------------
// Toolbar (search + filter + sort + records-per-page)
// ---------------------------------------------------------------------------

class _VehiclesToolbar extends StatefulWidget {
  const _VehiclesToolbar({
    required this.searchQuery,
    required this.recordsPerPage,
    required this.hasActiveFilters,
    required this.onSearchChanged,
    required this.onOpenFilters,
    required this.onOpenSort,
    required this.onRecordsChanged,
  });

  final String searchQuery;
  final int recordsPerPage;
  final bool hasActiveFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onOpenFilters;
  final VoidCallback onOpenSort;
  final ValueChanged<int> onRecordsChanged;

  @override
  State<_VehiclesToolbar> createState() => _VehiclesToolbarState();
}

class _VehiclesToolbarState extends State<_VehiclesToolbar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant _VehiclesToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _searchController.text) {
      _searchController.value = TextEditingValue(
        text: widget.searchQuery,
        selection: TextSelection.collapsed(offset: widget.searchQuery.length),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RoundedSurface(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: _SearchInput(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
            ),
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _SquareIconButton(
            icon: Icons.filter_alt_outlined,
            tooltip: 'Filter vehicles',
            onPressed: widget.onOpenFilters,
            showDot: widget.hasActiveFilters,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _SquareIconButton(
            icon: Icons.swap_vert_rounded,
            tooltip: 'Sort vehicles',
            onPressed: widget.onOpenSort,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          _RecordsPerPageDropdown(
            value: widget.recordsPerPage,
            onChanged: widget.onRecordsChanged,
          ),
        ],
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const double _height = 40;

  static const TextStyle _baseStyle = TextStyle(
    fontFamily: OpenVtsTypography.primaryFontFamily,
    fontFamilyFallback: OpenVtsTypography.fontFallback,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    leadingDistribution: TextLeadingDistribution.even,
  );

  @override
  Widget build(BuildContext context) {
    final fillColor = _softSurfaceColor(context);
    final borderColor = _softBorderColor(context);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(OpenVtsRadius.md),
      borderSide: BorderSide(color: borderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(OpenVtsRadius.md),
      borderSide: BorderSide(color: _primaryInkColor(context), width: 1.2),
    );

    return SizedBox(
      height: _height,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final hasText = value.text.isNotEmpty;
          return TextField(
            controller: controller,
            onChanged: onChanged,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: _primaryInkColor(context),
            cursorWidth: 1.4,
            style: _baseStyle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? OpenVtsColors.darkTextPrimary
                  : OpenVtsColors.textPrimary,
            ),
            strutStyle: const StrutStyle(
              fontFamily: OpenVtsTypography.primaryFontFamily,
              fontFamilyFallback: OpenVtsTypography.fontFallback,
              fontSize: 14,
              height: 1.2,
              leading: 0,
              forceStrutHeight: true,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              isDense: true,
              isCollapsed: false,
              hintText: 'Search by name, plate, IMEI…',
              hintStyle: _baseStyle.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? OpenVtsColors.darkTextSecondary.withValues(alpha: 0.6)
                    : OpenVtsColors.textTertiary,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: OpenVtsSpacing.sm,
                  end: OpenVtsSpacing.xs,
                ),
                child: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? OpenVtsColors.darkTextSecondary
                      : OpenVtsColors.textSecondary,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: _height,
              ),
              suffixIcon: !hasText
                  ? null
                  : Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: OpenVtsSpacing.xxs,
                      ),
                      child: IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                        splashRadius: 16,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? OpenVtsColors.darkTextSecondary
                              : OpenVtsColors.textSecondary,
                        ),
                      ),
                    ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: _height,
              ),
              contentPadding: const EdgeInsetsDirectional.only(
                end: OpenVtsSpacing.sm,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: focusedBorder,
            ),
          );
        },
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.showDot = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: _softSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OpenVtsRadius.md),
                  border: Border.all(color: _softBorderColor(context)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 18,
                  color: _primaryInkColor(context),
                ),
              ),
              if (showDot)
                PositionedDirectional(
                  top: -2,
                  end: -2,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: OpenVtsColors.brandInk,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordsPerPageDropdown extends StatelessWidget {
  const _RecordsPerPageDropdown({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <int>[
      ..._recordsPerPageOptions,
      if (!_recordsPerPageOptions.contains(value)) value,
    ]..sort();

    return Container(
      height: 40,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: OpenVtsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _softSurfaceColor(context),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isDense: true,
          icon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 2),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? OpenVtsColors.darkTextSecondary
                  : OpenVtsColors.textSecondary,
            ),
          ),
          style: OpenVtsTypography.label.copyWith(
            color: _primaryInkColor(context),
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          items: options
              .map(
                (option) => DropdownMenuItem<int>(
                  value: option,
                  child: Text('$option'),
                ),
              )
              .toList(growable: false),
          onChanged: (next) {
            if (next != null) {
              onChanged(next);
            }
          },
        ),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.currentPage,
    required this.pageCount,
    required this.showingCount,
    required this.totalCount,
    required this.onPrev,
    required this.onNext,
  });

  final int currentPage;
  final int pageCount;
  final int showingCount;
  final int totalCount;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final canPrev = currentPage > 1;
    final canNext = currentPage < pageCount;

    return Padding(
      padding: const EdgeInsets.only(top: OpenVtsSpacing.xs),
      child: Column(
        children: [
          Text(
            'Showing $showingCount of $totalCount',
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? OpenVtsColors.darkTextSecondary
                  : OpenVtsColors.textSecondary,
            ),
          ),
          if (pageCount > 1) ...[
            const SizedBox(height: OpenVtsSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PageButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: canPrev ? onPrev : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.sm,
                  ),
                  child: Text(
                    'Page $currentPage of $pageCount',
                    style: OpenVtsTypography.label.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _PageButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: canNext ? onNext : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: enabled
          ? _softSurfaceColor(context)
          : _softSurfaceColor(context).withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(OpenVtsRadius.md),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            border: Border.all(color: _softBorderColor(context)),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: enabled
                ? _primaryInkColor(context)
                : (Theme.of(context).brightness == Brightness.dark
                    ? OpenVtsColors.darkTextSecondary.withValues(alpha: 0.5)
                    : OpenVtsColors.textTertiary),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Options sheet (filter/sort)
// ---------------------------------------------------------------------------

class _OptionsSheet extends StatelessWidget {
  const _OptionsSheet({
    required this.title,
    required this.sections,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final List<_OptionsSheetSection> sections;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          OpenVtsSpacing.md,
          OpenVtsSpacing.sm,
          OpenVtsSpacing.md,
          OpenVtsSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            for (final section in sections) ...[
              Text(
                section.label,
                style: OpenVtsTypography.label.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              section.child,
              const SizedBox(height: OpenVtsSpacing.md),
            ],
            if (primaryActionLabel != null || secondaryActionLabel != null) ...[
              const SizedBox(height: OpenVtsSpacing.xs),
              Row(
                children: [
                  if (secondaryActionLabel != null) ...[
                    Expanded(
                      child: OpenVtsButton(
                        label: secondaryActionLabel!,
                        variant: OpenVtsButtonVariant.secondary,
                        onPressed: onSecondaryAction,
                      ),
                    ),
                    const SizedBox(width: OpenVtsSpacing.sm),
                  ],
                  if (primaryActionLabel != null)
                    Expanded(
                      child: OpenVtsButton(
                        label: primaryActionLabel!,
                        onPressed: onPrimaryAction,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionsSheetSection {
  const _OptionsSheetSection({required this.label, required this.child});

  final String label;
  final Widget child;
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        selected ? (isDark ? Colors.black : Colors.white) : Colors.transparent;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor =
        isDark ? Colors.white : Colors.black.withValues(alpha: 0.2);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: OpenVtsSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
            border: Border.all(
              color: selected
                  ? (isDark ? Colors.white : Colors.black)
                  : borderColor,
            ),
          ),
          child: Text(
            label,
            style: OpenVtsTypography.label.copyWith(
              color: textColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(OpenVtsRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.xs,
          vertical: OpenVtsSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 18,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: OpenVtsTypography.label.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundedSurface extends StatelessWidget {
  const _RoundedSurface({
    required this.child,
    this.padding = const EdgeInsets.all(OpenVtsSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(color: _softBorderColor(context)),
      ),
      child: child,
    );
  }
}

Color _softSurfaceColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkSurface
      : OpenVtsColors.background;
}

Color _softBorderColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkBorder
      : OpenVtsColors.border;
}

Color _primaryInkColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? OpenVtsColors.darkTextPrimary
      : OpenVtsColors.brandInk;
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle});

  final SuperadminVehicleRecord vehicle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _VehicleIconBadge(type: vehicle.type),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            vehicle.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: OpenVtsTypography.body.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        if (vehicle.plateNumber != '—') ...[
                          const SizedBox(width: OpenVtsSpacing.xs),
                          _PlateChip(label: vehicle.plateNumber),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle.type,
                      style: OpenVtsTypography.meta.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (vehicle.status != 'Unknown') ...[
                const SizedBox(width: OpenVtsSpacing.xs),
                _StatusChip(label: vehicle.status),
              ],
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          _VehicleDetailsPanel(vehicle: vehicle),
        ],
      ),
    );
  }
}

class _VehicleDetailsPanel extends StatelessWidget {
  const _VehicleDetailsPanel({required this.vehicle});

  final SuperadminVehicleRecord vehicle;

  @override
  Widget build(BuildContext context) {
    final localDateTime = vehicle.createdAt?.toLocal();
    final createdLabel = localDateTime == null
        ? '—'
        : '${_vehicleFmt.formatDate(localDateTime)}  ${_vehicleFmt.formatTime(localDateTime)}';
    final primaryExpiryLabel = _formatExpiryDate(vehicle.primaryExpiry);

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumn = constraints.maxWidth >= 400;

        if (twoColumn) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _VehicleInfoRow(
                      icon: Icons.barcode_reader,
                      label: 'IMEI',
                      value: vehicle.imei,
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.md),
                  Expanded(
                    child: _VehicleInfoRow(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'ADDED BY',
                      value: vehicle.addedBy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _VehicleInfoRow(
                      icon: Icons.sim_card_outlined,
                      label: 'SIM',
                      value: vehicle.sim,
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.md),
                  Expanded(
                    child: _VehicleInfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'PRIMARY USER',
                      value: vehicle.primaryUser,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _VehicleInfoRow(
                  icon: Icons.event_available_outlined,
                  label: 'PRIMARY EXPIRY',
                  value: primaryExpiryLabel,
                ),
              ),
              const SizedBox(height: OpenVtsSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _VehicleInfoRow(
                  icon: Icons.schedule_rounded,
                  label: 'Created',
                  value: createdLabel,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VehicleInfoRow(
              icon: Icons.barcode_reader,
              label: 'IMEI',
              value: vehicle.imei,
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            _VehicleInfoRow(
              icon: Icons.sim_card_outlined,
              label: 'SIM',
              value: vehicle.sim,
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            _VehicleInfoRow(
              icon: Icons.person_add_alt_1_outlined,
              label: 'ADDED BY',
              value: vehicle.addedBy,
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            _VehicleInfoRow(
              icon: Icons.person_outline_rounded,
              label: 'PRIMARY USER',
              value: vehicle.primaryUser,
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            _VehicleInfoRow(
              icon: Icons.event_available_outlined,
              label: 'PRIMARY EXPIRY',
              value: primaryExpiryLabel,
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            _VehicleInfoRow(
              icon: Icons.schedule_rounded,
              label: 'Created',
              value: createdLabel,
            ),
          ],
        );
      },
    );
  }
}

String _formatExpiryDate(DateTime? value) {
  return value == null ? '—' : _vehicleFmt.formatDate(value);
}

class _VehicleInfoRow extends StatelessWidget {
  const _VehicleInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: OpenVtsSpacing.xs),
        Text(
          '$label :  ',
          style: OpenVtsTypography.meta.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: OpenVtsTypography.meta.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _VehicleIconBadge extends StatelessWidget {
  const _VehicleIconBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        border: isDark ? Border.all(color: Colors.white, width: 1) : null,
      ),
      child: Icon(
        _vehicleIcon(type),
        color: isDark ? Colors.white : Theme.of(context).colorScheme.onPrimary,
        size: 20,
      ),
    );
  }
}

class _PlateChip extends StatelessWidget {
  const _PlateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: scheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final backgroundColor = switch (label) {
      'Active' => scheme.surfaceContainer,
      'Idle' => scheme.tertiary.withValues(alpha: 0.14),
      'Inactive' => scheme.onSurfaceVariant.withValues(alpha: 0.16),
      'Offline' => scheme.error.withValues(alpha: 0.12),
      _ => scheme.tertiary.withValues(alpha: 0.12),
    };

    final foregroundColor = switch (label) {
      'Active' => scheme.onSurface,
      'Idle' => scheme.tertiary,
      'Inactive' => scheme.onSurfaceVariant,
      'Offline' => scheme.error,
      _ => scheme.tertiary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: foregroundColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/*
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;

              final titleSection = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: OpenVtsSpacing.xs,
                    runSpacing: OpenVtsSpacing.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        vehicle.name,
                        style: OpenVtsTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (vehicle.plateNumber != '—')
                        _PlateChip(label: vehicle.plateNumber),
                    ],
                  ),
                  const SizedBox(height: OpenVtsSpacing.xxs),
                  Wrap(
                    spacing: OpenVtsSpacing.xs,
                    runSpacing: OpenVtsSpacing.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        vehicle.type,
                        style: OpenVtsTypography.body.copyWith(
                          color: OpenVtsColors.textSecondary,
                        ),
                      ),
                      if (vehicle.status != 'Unknown') ...[
                        Text(
                          '•',
                          style: OpenVtsTypography.body.copyWith(
                            color: OpenVtsColors.textTertiary,
                          ),
                        ),
                        _StatusChip(label: vehicle.status),
                      ],
                    ],
                  ),
                ],
              );

              final timestamp = _VehicleTimestamp(createdAt: vehicle.createdAt);

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _VehicleIconBadge(type: vehicle.type),
                        const SizedBox(width: OpenVtsSpacing.sm),
                        Expanded(child: titleSection),
                      ],
                    ),
                    const SizedBox(height: OpenVtsSpacing.xs),
                    timestamp,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VehicleIconBadge(type: vehicle.type),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Expanded(child: titleSection),
                  const SizedBox(width: OpenVtsSpacing.md),
                  timestamp,
                ],
              );
            },
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          const Divider(height: 1, color: OpenVtsColors.border),
          const SizedBox(height: OpenVtsSpacing.xs),
          _VehicleDetailsPanel(vehicle: vehicle),
        ],
      ),
    );
  }
}

class _VehicleIconBadge extends StatelessWidget {
  const _VehicleIconBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: OpenVtsColors.background,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: OpenVtsColors.border),
      ),
      child: Icon(
        _vehicleIcon(type),
        color: OpenVtsColors.textPrimary,
        size: 22,
      ),
    );
  }
}

class _VehicleTimestamp extends StatelessWidget {
  const _VehicleTimestamp({required this.createdAt});

  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final localDateTime = createdAt?.toLocal();
    final dateLabel = localDateTime == null
        ? '—'
        : _vehicleFmt.formatDate(localDateTime);
    final timeLabel = localDateTime == null
        ? '—'
        : _vehicleFmt.formatTime(localDateTime);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 16,
          color: OpenVtsColors.textSecondary,
        ),
        const SizedBox(width: OpenVtsSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateLabel,
              style: OpenVtsTypography.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              timeLabel,
              style: OpenVtsTypography.meta.copyWith(
                color: OpenVtsColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VehicleDetailsPanel extends StatelessWidget {
  const _VehicleDetailsPanel({required this.vehicle});

  final SuperadminVehicleRecord vehicle;

  @override
  Widget build(BuildContext context) {
    final deviceSection = _VehicleMetaSection(
      title: 'Device',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VehicleMetaLine(label: 'IMEI', value: vehicle.imei),
          const SizedBox(height: OpenVtsSpacing.xs),
          _VehicleMetaLine(label: 'SIM', value: vehicle.sim),
        ],
      ),
    );
    final primaryUserSection = _VehicleMetaSection(
      title: 'Primary user',
      child: Text(
        vehicle.primaryUser,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: OpenVtsTypography.body.copyWith(
          color: OpenVtsColors.textPrimary,
        ),
      ),
    );
    final addedBySection = _VehicleMetaSection(
      title: 'Added by',
      child: Text(
        vehicle.addedBy,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: OpenVtsTypography.body.copyWith(
          color: OpenVtsColors.textPrimary,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 860) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: deviceSection),
              const _VehicleSectionDivider(),
              Expanded(child: primaryUserSection),
              const _VehicleSectionDivider(),
              Expanded(child: addedBySection),
            ],
          );
        }

        if (constraints.maxWidth >= 560) {
          final itemWidth = (constraints.maxWidth - OpenVtsSpacing.xs) / 2;
          return Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              SizedBox(width: itemWidth, child: deviceSection),
              SizedBox(width: itemWidth, child: primaryUserSection),
              SizedBox(width: itemWidth, child: addedBySection),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            deviceSection,
            const SizedBox(height: OpenVtsSpacing.xs),
            const Divider(height: 1, color: OpenVtsColors.border),
            const SizedBox(height: OpenVtsSpacing.xs),
            primaryUserSection,
            const SizedBox(height: OpenVtsSpacing.xs),
            const Divider(height: 1, color: OpenVtsColors.border),
            const SizedBox(height: OpenVtsSpacing.xs),
            addedBySection,
          ],
        );
      },
    );
  }
}

class _VehicleMetaSection extends StatelessWidget {
  const _VehicleMetaSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: OpenVtsTypography.meta.copyWith(
            color: OpenVtsColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.xxs),
        child,
      ],
    );
  }
}

class _VehicleMetaLine extends StatelessWidget {
  const _VehicleMetaLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: OpenVtsTypography.body.copyWith(
          color: OpenVtsColors.textPrimary,
        ),
        children: [
          TextSpan(
            text: '$label  ',
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _VehicleSectionDivider extends StatelessWidget {
  const _VehicleSectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.sm),
      color: OpenVtsColors.border,
    );
  }
}

class _PlateChip extends StatelessWidget {
  const _PlateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: OpenVtsColors.background,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: OpenVtsColors.border),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: OpenVtsColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (label) {
      'Active' => OpenVtsColors.success.withValues(alpha: 0.12),
      'Idle' => OpenVtsColors.warning.withValues(alpha: 0.14),
      'Inactive' => OpenVtsColors.textTertiary.withValues(alpha: 0.16),
      'Offline' => OpenVtsColors.error.withValues(alpha: 0.12),
      _ => OpenVtsColors.info.withValues(alpha: 0.12),
    };

    final foregroundColor = switch (label) {
      'Active' => OpenVtsColors.success,
      'Idle' => OpenVtsColors.warning,
      'Inactive' => OpenVtsColors.textSecondary,
      'Offline' => OpenVtsColors.error,
      _ => OpenVtsColors.info,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      ),
      child: Text(
        label,
        style: OpenVtsTypography.meta.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

*/

IconData _vehicleIcon(String type) {
  switch (type) {
    case 'Truck':
      return Icons.local_shipping_outlined;
    case 'Bike':
      return Icons.pedal_bike_outlined;
    case 'Bus':
      return Icons.directions_bus_outlined;
    case 'Van':
      return Icons.airport_shuttle_outlined;
    default:
      return Icons.directions_car_outlined;
  }
}
