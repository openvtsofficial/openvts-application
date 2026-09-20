import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../controllers/user_providers.dart';
import '../../../models/user_dashboard_model.dart';
import 'user_dashboard_widget_card.dart';

class UserTopPerformingAssetsWidget extends ConsumerStatefulWidget {
  const UserTopPerformingAssetsWidget({
    required this.config,
    required this.refreshTick,
    super.key,
  });

  final UserDashboardWidgetConfig config;
  final int refreshTick;

  @override
  ConsumerState<UserTopPerformingAssetsWidget> createState() =>
      _UserTopPerformingAssetsWidgetState();
}

class _UserTopPerformingAssetsWidgetState
    extends ConsumerState<UserTopPerformingAssetsWidget> {
  _TopAssetsRange _range = _TopAssetsRange.today;
  int _refreshKey = 0;

  // Resolved once per range selection / refresh so build() never calls
  // DateTime.now() and accidentally shifts the provider identity.
  late DateTime _resolvedFrom;
  late DateTime _resolvedTo;

  @override
  void initState() {
    super.initState();
    final r = _range.resolve();
    _resolvedFrom = r.from;
    _resolvedTo = r.to;
  }

  @override
  void didUpdateWidget(covariant UserTopPerformingAssetsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTick != widget.refreshTick ||
        oldWidget.config.id != widget.config.id) {
      _reload();
    }
  }

  void _reload() {
    final r = _range.resolve();
    setState(() {
      _resolvedFrom = r.from;
      _resolvedTo = r.to;
      _refreshKey++;
    });
  }

  void _changeRange(Set<_TopAssetsRange> value) {
    if (value.isEmpty) return;
    final r = value.first.resolve();
    setState(() {
      _range = value.first;
      _resolvedFrom = r.from;
      _resolvedTo = r.to;
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      userDashboardTopAssetsProvider(
        UserDashboardTopAssetsArgs(
          widgetId: widget.config.id,
          refreshKey: _refreshKey,
          from: _resolvedFrom,
          to: _resolvedTo,
          limit:
              userDashboardPropInt(widget.config.props, const ['limit']) ?? 10,
        ),
      ),
    );
    return UserDashboardWidgetCard(
      title: widget.config.title,
      icon: Icons.leaderboard_outlined,
      isLoading: state.isLoading,
      onRefresh: _reload,
      child: _buildBody(state),
    );
  }

  Widget _buildBody(AsyncValue<UserDashboardTopAssets> state) {
    if (state.hasError) {
      return UserDashboardWidgetError(
        message: state.error.toString(),
        onRetry: _reload,
      );
    }

    final data = state.valueOrNull;
    if (data == null) {
      return const _TopAssetsSkeleton();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<_TopAssetsRange>(
          segments: const [
            ButtonSegment(value: _TopAssetsRange.today, label: Text('Today')),
            ButtonSegment(
                value: _TopAssetsRange.last7Days, label: Text('Last 7 Days')),
            ButtonSegment(
                value: _TopAssetsRange.last30Days, label: Text('Last 30 Days')),
          ],
          selected: {_range},
          showSelectedIcon: false,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStatePropertyAll(
              OpenVtsTypography.meta.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          onSelectionChanged: _changeRange,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (data.items.isEmpty)
          const UserDashboardWidgetEmpty(
            message: 'No top assets for this range.',
            icon: Icons.leaderboard_outlined,
          )
        else
          _TopAssetsList(items: data.items.take(10).toList(growable: false)),
      ],
    );
  }
}

class _TopAssetsList extends StatelessWidget {
  const _TopAssetsList({required this.items});

  final List<UserDashboardTopAssetItem> items;

  @override
  Widget build(BuildContext context) {
    final maxKm = items.fold<double>(
      0,
      (max, item) => math.max(max, item.drivenKm),
    );

    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _TopAssetRow(
            rank: index + 1,
            item: items[index],
            maxKm: maxKm,
          ),
          if (index != items.length - 1)
            const SizedBox(height: OpenVtsSpacing.sm),
        ],
      ],
    );
  }
}

class _TopAssetRow extends StatelessWidget {
  const _TopAssetRow({
    required this.rank,
    required this.item,
    required this.maxKm,
  });

  final int rank;
  final UserDashboardTopAssetItem item;
  final double maxKm;

  @override
  Widget build(BuildContext context) {
    final percent = (item.drivenKm / math.max(maxKm, 1)).clamp(0.0, 1.0);
    final subtitle = [
      if (item.plateNumber?.trim().isNotEmpty ?? false) item.plateNumber!,
      if (item.imei.trim().isNotEmpty) item.imei,
    ].join(' · ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Text(
            '$rank',
            style: OpenVtsTypography.meta.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.vehicleName.trim().isEmpty
                          ? 'Vehicle ${item.vehicleId}'
                          : item.vehicleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.label.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.sm),
                  Text(
                    userDashboardFormatDistance(item.drivenKm),
                    style: OpenVtsTypography.meta.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 7,
                  color: OpenVtsColors.brandInk,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopAssetsSkeleton extends StatelessWidget {
  const _TopAssetsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SkeletonBlock(height: 40),
        const SizedBox(height: OpenVtsSpacing.sm),
        for (var index = 0; index < 5; index++) ...[
          const _SkeletonBlock(height: 42),
          if (index != 4) const SizedBox(height: OpenVtsSpacing.sm),
        ],
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}

enum _TopAssetsRange {
  today,
  last7Days,
  last30Days;

  _ResolvedRange resolve() {
    final now = DateTime.now();
    switch (this) {
      case _TopAssetsRange.today:
        return _ResolvedRange(
          from: DateTime(now.year, now.month, now.day),
          to: now,
        );
      case _TopAssetsRange.last7Days:
        return _ResolvedRange(
          from: now.subtract(const Duration(days: 7)),
          to: now,
        );
      case _TopAssetsRange.last30Days:
        return _ResolvedRange(
          from: now.subtract(const Duration(days: 30)),
          to: now,
        );
    }
  }
}

class _ResolvedRange {
  const _ResolvedRange({required this.from, required this.to});

  final DateTime from;
  final DateTime to;
}
