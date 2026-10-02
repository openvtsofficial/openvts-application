import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/open_vts_radius.dart';
import '../../../../core/theme/open_vts_spacing.dart';
import '../../../../core/theme/open_vts_typography.dart';
import '../../../../core/utils/date_time_formatter.dart';
import '../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_loader.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/user_providers.dart';
import '../../models/user_dashboard_model.dart';
import '../../models/user_dashboard_state.dart';
import 'widgets/user_dashboard_widget_card.dart';
import 'widgets/user_dashboard_widget_registry.dart';

const double _dashboardMaxWidth = 920;

class UserDashboardScreen extends ConsumerStatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  ConsumerState<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class _UserDashboardScreenState extends ConsumerState<UserDashboardScreen>
    with WidgetsBindingObserver {
  int _refreshTick = 0;
  bool _resumeRefreshPending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _triggerResumeRefresh();
    }
  }

  void _triggerResumeRefresh() {
    final controller = ref.read(userDashboardControllerProvider.notifier);
    // Skip if a refresh is already running (manual or a prior resume).
    if (ref.read(userDashboardControllerProvider).isRefreshing) return;
    if (_resumeRefreshPending) return;
    _resumeRefreshPending = true;
    controller.refresh().then((_) {
      if (!mounted) return;
      setState(() {
        _resumeRefreshPending = false;
        _refreshTick++;
      });
    }).catchError((_) {
      if (!mounted) return;
      setState(() => _resumeRefreshPending = false);
    });
  }

  Future<void> _refresh() async {
    await ref.read(userDashboardControllerProvider.notifier).refresh();
    if (!mounted) return;
    setState(() => _refreshTick++);
  }

  Future<void> _selectDashboard(String id) async {
    await ref
        .read(userDashboardControllerProvider.notifier)
        .selectDashboard(id);
    if (!mounted) return;
    setState(() => _refreshTick++);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userDashboardControllerProvider);
    final controller = ref.read(userDashboardControllerProvider.notifier);

    return OpenVtsPageScaffold(
      title: 'Dashboard',
      headerMode: OpenVtsPageHeaderMode.closeable,
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            OpenVtsSpacing.sm,
            OpenVtsSpacing.sm,
            OpenVtsSpacing.sm,
            OpenVtsSpacing.lg,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _dashboardMaxWidth),
                child: _DashboardBody(
                  state: state,
                  refreshTick: _refreshTick,
                  onRefresh: _refresh,
                  onSelectDashboard: _selectDashboard,
                  onRetryInitial: controller.loadInitial,
                  onRetrySelected: controller.reloadSelectedDashboard,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.state,
    required this.refreshTick,
    required this.onRefresh,
    required this.onSelectDashboard,
    required this.onRetryInitial,
    required this.onRetrySelected,
  });

  final UserDashboardState state;
  final int refreshTick;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String id) onSelectDashboard;
  final VoidCallback onRetryInitial;
  final VoidCallback onRetrySelected;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingDashboards && !state.hasDashboards) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: const OpenVtsLoader(),
      );
    }

    if (state.errorMessage != null && !state.hasDashboards) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: OpenVtsErrorView(
          message: state.errorMessage!,
          onRetry: onRetryInitial,
        ),
      );
    }

    if (!state.hasDashboards) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: const OpenVtsEmptyState(
          title: 'No dashboard configured',
          message:
              'Create a dashboard from the web application to view it here.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isRefreshing)
          const Padding(
            padding: EdgeInsets.only(bottom: OpenVtsSpacing.sm),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
            child: _DashboardInlineError(
              message: state.errorMessage!,
              onRetry: onRefresh,
            ),
          ),
        _DashboardHeader(
          state: state,
          onRefresh: onRefresh,
          onSelectDashboard: onSelectDashboard,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (state.isLoadingSelectedDashboard && !state.hasSelectedDashboard)
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.46,
            child: const OpenVtsLoader(),
          )
        else if (state.selectedDashboardError != null)
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.46,
            child: OpenVtsErrorView(
              message: state.selectedDashboardError!,
              onRetry: onRetrySelected,
            ),
          )
        else if (!state.hasOrderedWidgets)
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.46,
            child: const OpenVtsEmptyState(
              title: 'No widgets configured',
              message: 'This saved dashboard has no widgets yet.',
            ),
          )
        else
          _DashboardWidgetList(
            widgets: state.orderedWidgets,
            refreshTick: refreshTick,
          ),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.state,
    required this.onRefresh,
    required this.onSelectDashboard,
  });

  final UserDashboardState state;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String id) onSelectDashboard;

  @override
  Widget build(BuildContext context) {
    final selectedDashboard = state.selectedDashboard;
    final selectedListItem = _selectedListItem;
    final selectedName =
        selectedDashboard?.name ?? selectedListItem?.name ?? 'Dashboard';
    final updatedAt =
        selectedDashboard?.updatedAt ?? selectedListItem?.updatedAt;

    return LayoutBuilder(
      builder: (context, constraints) {
        final controls = Wrap(
          alignment: constraints.maxWidth < 560
              ? WrapAlignment.start
              : WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: OpenVtsSpacing.xs,
          runSpacing: OpenVtsSpacing.xs,
          children: [
            _UpdatedTimePill(
              updatedAt: updatedAt,
              isRefreshing: state.isRefreshing,
            ),
            if (state.dashboards.length > 1)
              _DashboardSelectorButton(
                dashboards: state.dashboards,
                selectedDashboardId: state.selectedDashboardId,
                onSelectDashboard: onSelectDashboard,
              ),
            _RefreshIconButton(
              isRefreshing: state.isRefreshing,
              onRefresh: onRefresh,
            ),
          ],
        );

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: OpenVtsTypography.titleSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              selectedName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );

        if (constraints.maxWidth < 560) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: OpenVtsSpacing.xs),
              controls,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            const SizedBox(width: OpenVtsSpacing.sm),
            Flexible(child: controls),
          ],
        );
      },
    );
  }

  UserDashboardListItem? get _selectedListItem {
    final selectedId = state.selectedDashboardId;
    if (selectedId == null) return null;
    for (final dashboard in state.dashboards) {
      if (dashboard.id == selectedId) return dashboard;
    }
    return null;
  }
}

class _UpdatedTimePill extends ConsumerWidget {
  const _UpdatedTimePill({
    required this.updatedAt,
    required this.isRefreshing,
  });

  final DateTime? updatedAt;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(appDateFormatterProvider);
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRefreshing) ...[
            SizedBox.square(
              dimension: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.xxs),
            Text(
              'Refreshing',
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ] else ...[
            Icon(
              Icons.schedule_rounded,
              size: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: OpenVtsSpacing.xxs),
            Text(
              userDashboardFormatDateTime(updatedAt, formatter: formatter),
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashboardSelectorButton extends StatelessWidget {
  const _DashboardSelectorButton({
    required this.dashboards,
    required this.selectedDashboardId,
    required this.onSelectDashboard,
  });

  final List<UserDashboardListItem> dashboards;
  final String? selectedDashboardId;
  final Future<void> Function(String id) onSelectDashboard;

  @override
  Widget build(BuildContext context) {
    final selected =
        dashboards.where((item) => item.id == selectedDashboardId).firstOrNull;

    return OutlinedButton.icon(
      onPressed: () => _openSelector(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.sm,
          vertical: 0,
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        ),
      ),
      icon: const Icon(Icons.dashboard_customize_outlined, size: 15),
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 148),
        child: Text(
          selected?.name ?? 'Dashboards',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: OpenVtsTypography.meta.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Future<void> _openSelector(BuildContext context) async {
    final selectedId = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final formatter = ref.watch(appDateFormatterProvider);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                OpenVtsSpacing.md,
                0,
                OpenVtsSpacing.md,
                OpenVtsSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select dashboard',
                    style: OpenVtsTypography.titleSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  for (final dashboard in dashboards)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        dashboard.id == selectedDashboardId
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 18,
                        color: dashboard.id == selectedDashboardId
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      title: Text(
                        dashboard.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: dashboard.updatedAt == null
                          ? null
                          : Text(userDashboardFormatDateTime(
                              dashboard.updatedAt,
                              formatter: formatter)),
                      onTap: () => Navigator.of(context).pop(dashboard.id),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (selectedId != null && selectedId != selectedDashboardId) {
      await onSelectDashboard(selectedId);
    }
  }
}

class _RefreshIconButton extends StatelessWidget {
  const _RefreshIconButton({
    required this.isRefreshing,
    required this.onRefresh,
  });

  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Refresh dashboard',
      onPressed: isRefreshing ? null : () => onRefresh(),
      style: IconButton.styleFrom(
        minimumSize: const Size.square(34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        backgroundColor: Theme.of(context).colorScheme.surface,
        disabledBackgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        disabledForegroundColor: Theme.of(context).colorScheme.outline,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        ),
      ),
      icon: const Icon(Icons.refresh_rounded, size: 17),
    );
  }
}

class _DashboardWidgetList extends StatelessWidget {
  const _DashboardWidgetList({
    required this.widgets,
    required this.refreshTick,
  });

  final List<UserDashboardWidgetConfig> widgets;
  final int refreshTick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < widgets.length; index++) ...[
          KeyedSubtree(
            key: ValueKey(widgets[index].id),
            child: buildUserDashboardWidget(
              config: widgets[index],
              refreshTick: refreshTick,
            ),
          ),
          if (index != widgets.length - 1)
            const SizedBox(height: OpenVtsSpacing.sm),
        ],
      ],
    );
  }
}

class _DashboardInlineError extends StatelessWidget {
  const _DashboardInlineError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 17,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => onRetry(),
            style: TextButton.styleFrom(
              minimumSize: const Size(52, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding:
                  const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.xs),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
