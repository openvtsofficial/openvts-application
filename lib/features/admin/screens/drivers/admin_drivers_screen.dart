import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/open_vts_colors.dart';
import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_list_page_header.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/admin_drivers_controller.dart';
import '../../controllers/admin_providers.dart';
import '../../models/admin_drivers_model.dart';
import '../../models/admin_drivers_state.dart';
import '../../models/admin_users_model.dart';
import '../../utils/location_label_resolver.dart';
import 'widgets/admin_driver_card.dart';
import 'widgets/admin_driver_create_sheet.dart';

class AdminDriversScreen extends ConsumerWidget {
  const AdminDriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDriversControllerProvider);
    final controller = ref.read(adminDriversControllerProvider.notifier);

    return OpenVtsPageScaffold(
      title: 'Drivers',
      headerMode: OpenVtsPageHeaderMode.closeable,
      actions: [
        IconButton(
          tooltip: 'Refresh drivers',
          onPressed: controller.refresh,
          icon: state.isRefreshing
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                )
              : const Icon(Icons.refresh_rounded, size: 20),
        ),
      ],
      padding: const EdgeInsetsDirectional.fromSTEB(
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
        OpenVtsSpacing.sm,
      ),
      body: state.isLoading && !state.hasDrivers
          ? const OpenVtsLoader()
          : state.errorMessage != null && !state.hasDrivers
              ? OpenVtsErrorView(
                  message: state.errorMessage ?? 'Drivers could not be loaded.',
                  onRetry: controller.refresh,
                )
              : _DriversBody(
                  state: state,
                  controller: controller,
                  onCreate: () => _showCreateDriverSheet(context),
                  onOpenFilters: () => _showFilterSheet(context, ref),
                  onOpenSort: () => _showSortSheet(context, ref),
                  onOpenDetails: (driver) => _openDriverDetails(
                    context,
                    driver,
                    ref.read(adminDriversControllerProvider.notifier),
                  ),
                ),
    );
  }

  Future<void> _openDriverDetails(
    BuildContext context,
    AdminDriverListItem driver,
    AdminDriversController controller,
  ) async {
    await context.push(
      RoutePaths.adminDriverDetailsPath(driver.id),
      extra: driver,
    );
    if (context.mounted) {
      await controller.refresh();
    }
  }

  Future<void> _showCreateDriverSheet(BuildContext context) {
    return showDriverCreateSheet(
      context: context,
      provider: adminDriversControllerProvider,
    );
  }

  Future<void> _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = ref.read(adminDriversControllerProvider.notifier);
    final state = ref.read(adminDriversControllerProvider);

    // Ensure country options are cached (no-op if already loaded).
    await ref
        .read(adminUsersControllerProvider.notifier)
        .ensureCountryOptionsLoaded();
    final cachedCountryOptions =
        ref.read(adminUsersControllerProvider).countryOptions;

    if (!context.mounted) return;

    var selectedStatus = state.statusFilter;
    var selectedVerified = state.verifiedFilter;
    var selectedCountry = state.countryFilter;
    final countryOptions = _countryOptions(state.drivers, cachedCountryOptions);

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
            return OpenVtsListPageOptionsSheet(
              title: 'Filter drivers',
              sections: [
                OpenVtsListPageOptionsSection(
                  label: 'Status',
                  child: _PillSegmentedControl(
                    children: AdminDriverStatusFilter.values
                        .map(
                          (option) => _PillSegment(
                            label: switch (option) {
                              AdminDriverStatusFilter.all => 'All',
                              AdminDriverStatusFilter.active => 'Active',
                              AdminDriverStatusFilter.inactive => 'Inactive',
                            },
                            selected: selectedStatus == option,
                            onTap: () =>
                                setSheetState(() => selectedStatus = option),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
                OpenVtsListPageOptionsSection(
                  label: 'Verification',
                  child: _PillSegmentedControl(
                    children: AdminDriverVerifiedFilter.values
                        .map(
                          (option) => _PillSegment(
                            label: switch (option) {
                              AdminDriverVerifiedFilter.all => 'All',
                              AdminDriverVerifiedFilter.verified => 'Verified',
                              AdminDriverVerifiedFilter.unverified =>
                                'Unverified',
                            },
                            selected: selectedVerified == option,
                            onTap: () =>
                                setSheetState(() => selectedVerified = option),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
                OpenVtsListPageOptionsSection(
                  label: 'Country',
                  child: Wrap(
                    spacing: OpenVtsSpacing.xs,
                    runSpacing: OpenVtsSpacing.xs,
                    children: [
                      _PillSegment(
                        label: 'All Countries',
                        selected: selectedCountry == null,
                        onTap: () =>
                            setSheetState(() => selectedCountry = null),
                      ),
                      for (final option in countryOptions)
                        _PillSegment(
                          label: option.label,
                          selected: selectedCountry == option.value,
                          onTap: () => setSheetState(
                            () => selectedCountry = option.value,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              primaryActionLabel: 'Apply filters',
              onPrimaryAction: () {
                controller.setStatusFilter(selectedStatus);
                controller.setVerifiedFilter(selectedVerified);
                controller.setCountryFilter(selectedCountry);
                Navigator.of(sheetContext).pop();
              },
              secondaryActionLabel: 'Reset',
              onSecondaryAction: () {
                setSheetState(() {
                  selectedStatus = AdminDriverStatusFilter.all;
                  selectedVerified = AdminDriverVerifiedFilter.all;
                  selectedCountry = null;
                });
              },
            );
          },
        );
      },
    );
  }

  Future<void> _showSortSheet(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(adminDriversControllerProvider.notifier);
    final state = ref.read(adminDriversControllerProvider);

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
        return OpenVtsListPageOptionsSheet(
          title: 'Sort drivers',
          sections: [
            OpenVtsListPageOptionsSection(
              label: 'Order by',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: AdminDriversSortOption.values
                    .map(
                      (option) => OpenVtsListPageRadioRow(
                        label: switch (option) {
                          AdminDriversSortOption.newest => 'Newest',
                          AdminDriversSortOption.nameAsc => 'Name A-Z',
                          AdminDriversSortOption.activeFirst => 'Active first',
                        },
                        selected: state.sortOption == option,
                        onTap: () {
                          controller.setSortOption(option);
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

  List<AdminUserCountryOption> _countryOptions(
    List<AdminDriverListItem> drivers,
    List<AdminUserCountryOption> cachedOptions,
  ) {
    final codes = <String>{
      for (final driver in drivers)
        if (driver.countryCode.trim().isNotEmpty &&
            driver.countryCode.trim() != '-')
          driver.countryCode.trim().toUpperCase(),
    };
    return LocationLabelResolver.resolvedCountryOptions(
      codes,
      apiOptions: cachedOptions,
    );
  }
}

class _DriversBody extends ConsumerWidget {
  const _DriversBody({
    required this.state,
    required this.controller,
    required this.onCreate,
    required this.onOpenFilters,
    required this.onOpenSort,
    required this.onOpenDetails,
  });

  final AdminDriversState state;
  final AdminDriversController controller;
  final VoidCallback onCreate;
  final VoidCallback onOpenFilters;
  final VoidCallback onOpenSort;
  final void Function(AdminDriverListItem) onOpenDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredCount = state.filteredCount;
    final visible = state.visibleDrivers;

    return Column(
      children: [
        OpenVtsListPageHeaderCard(
          icon: Icons.badge_outlined,
          countLabel: '$filteredCount Driver${filteredCount == 1 ? '' : 's'}',
          createLabel: 'Add Driver',
          onCreate: onCreate,
          isCreateLoading: state.isCreating,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        OpenVtsListPageToolbar(
          searchQuery: state.searchQuery,
          hintText: 'Search by name, email\u2026',
          hasActiveFilters: state.hasActiveFilters,
          onSearchChanged: controller.setSearchQuery,
          onOpenFilters: onOpenFilters,
          filterTooltip: 'Filter drivers',
          onOpenSort: onOpenSort,
          sortTooltip: 'Sort drivers',
          recordsPerPage: state.recordsPerPage,
          onRecordsChanged: controller.setRecordsPerPage,
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          _InlineErrorBanner(message: state.errorMessage!),
        ],
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refresh,
            child: filteredCount == 0
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: OpenVtsSpacing.section),
                      OpenVtsEmptyState(
                        title: 'No drivers found',
                        message: state.hasActiveFilters
                            ? 'Try a different search or filter.'
                            : 'Create a driver to get started.',
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: visible.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: OpenVtsSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index == visible.length) {
                        return OpenVtsListPagePaginationFooter(
                          currentPage: state.safeCurrentPage,
                          pageCount: state.pageCount,
                          showingCount: visible.length,
                          totalCount: filteredCount,
                          onPrev: () =>
                              controller.goToPage(state.safeCurrentPage - 1),
                          onNext: () =>
                              controller.goToPage(state.safeCurrentPage + 1),
                        );
                      }

                      final driver = visible[index];
                      final isUpdatingStatus =
                          state.updatingDriverIds.contains(driver.id);
                      return AdminDriverCard(
                        driver: driver,
                        onTap: () => onOpenDetails(driver),
                        isUpdatingStatus: isUpdatingStatus,
                        onStatusChanged: isUpdatingStatus
                            ? null
                            : (nextValue) {
                                _onDriverStatusChanged(
                                  context,
                                  driver.id,
                                  nextValue,
                                  ref,
                                );
                              },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _onDriverStatusChanged(
    BuildContext context,
    String driverId,
    bool nextValue,
    WidgetRef ref,
  ) async {
    try {
      await controller.updateDriverStatus(driverId, nextValue);
    } catch (_) {
      if (context.mounted) {
        final errorMsg =
            ref.read(adminDriversControllerProvider).errorMessage ??
                'Unable to update driver status.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: OpenVtsSpacing.md,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.error),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: OpenVtsColors.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillSegmentedControl extends StatelessWidget {
  const _PillSegmentedControl({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : OpenVtsColors.white;
    final borderColor = isDark ? Colors.white : OpenVtsColors.border;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _PillSegment extends StatelessWidget {
  const _PillSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = selected
        ? (isDark ? Colors.black : OpenVtsColors.white)
        : Colors.transparent;
    final textColor = isDark ? Colors.white : OpenVtsColors.brandInk;
    final borderColor = isDark ? Colors.white : OpenVtsColors.border;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: OpenVtsSpacing.sm,
            vertical: OpenVtsSpacing.xs,
          ),
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                  border: Border.all(color: borderColor, width: 1),
                )
              : null,
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
