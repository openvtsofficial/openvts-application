import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../shared/widgets/open_vts_map_layer_selector.dart';
import '../../../../controllers/user_providers.dart';
import '../../../../models/user_report_model.dart';
import '../../../../models/user_report_state.dart';
import '../../../../utils/user_report_format.dart';
import '../../../../../../core/utils/unit_formatter.dart';
import '../user_report_kpi_row.dart';
import '../user_report_result_toolbar.dart';
import '../user_report_row_details_sheet.dart';

@visibleForTesting
const String kTimelineMapTileUserAgent = 'com.openvts.mobile';

class UserTimelineReportResult extends ConsumerWidget {
  const UserTimelineReportResult(
      {required this.state,
      required this.onLoadMore,
      required this.onExport,
      super.key});

  final UserReportWorkspaceState state;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uf = ref.watch(unitFormatterProvider);
    final rows = state.rows.map(TimelineRow.fromMap).toList();

    final running = rows.where((r) => r.isRunning);
    final stopped = rows.where((r) => !r.isRunning);
    final runDur = running.fold(0.0, (s, r) => s + r.durationSeconds);
    final stopDur = stopped.fold(0.0, (s, r) => s + r.durationSeconds);
    final dist = running.fold(0.0, (s, r) => s + (r.distanceKm ?? 0));
    final stopCount = stopped.length;

    final kpis = [
      ReportKpi(
          label: 'Running Duration', value: formatDurationSeconds(runDur)),
      ReportKpi(
          label: 'Stopped Duration', value: formatDurationSeconds(stopDur)),
      ReportKpi(label: 'Movement Distance', value: uf.distance(dist)),
      ReportKpi(label: 'Stop Count', value: '$stopCount'),
    ];

    final total = runDur + stopDur;
    final hasDonut = total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (hasDonut) ...[
          _RunStopDonut(runDur: runDur, stopDur: stopDur),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
        UserReportResultToolbar(
          rowCount: rows.length,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          onLoadMore: onLoadMore,
          generatedAt: state.generatedAt,
          warning: state.warning,
          source: state.source,
          loadMoreError: state.loadMoreError,
          reportKey: state.reportKey,
          onExport: onExport,
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        ...rows.map((r) => _TimelineRowCard(row: r, uf: uf)),
      ],
    );
  }
}

class _RunStopDonut extends StatelessWidget {
  const _RunStopDonut({required this.runDur, required this.stopDur});
  final double runDur;
  final double stopDur;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Running vs Stopped',
              style: OpenVtsTypography.label
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: OpenVtsSpacing.sm),
          SizedBox(
            height: 120,
            child: Row(children: [
              SizedBox(
                  width: 120,
                  child: PieChart(PieChartData(sections: [
                    PieChartSectionData(
                        value: runDur,
                        color: OpenVtsColors.success,
                        title: 'Run',
                        radius: 42,
                        titleStyle: OpenVtsTypography.meta
                            .copyWith(fontSize: 9, color: OpenVtsColors.white)),
                    PieChartSectionData(
                        value: stopDur,
                        color: OpenVtsColors.textSecondary,
                        title: 'Stop',
                        radius: 42,
                        titleStyle: OpenVtsTypography.meta
                            .copyWith(fontSize: 9, color: OpenVtsColors.white)),
                  ], centerSpaceRadius: 24, sectionsSpace: 2))),
              const SizedBox(width: OpenVtsSpacing.sm),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Legend(
                        color: OpenVtsColors.success,
                        label: 'Running: ${formatDurationSeconds(runDur)}'),
                    const SizedBox(height: 4),
                    _Legend(
                        color: OpenVtsColors.textSecondary,
                        label: 'Stopped: ${formatDurationSeconds(stopDur)}'),
                  ]),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
          border: Border.all(color: color.withValues(alpha: 0.35))),
      child: Text(label,
          style: OpenVtsTypography.meta
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 6),
      Text(label, style: OpenVtsTypography.meta),
    ]);
  }
}

class _TimelineRowCard extends ConsumerStatefulWidget {
  const _TimelineRowCard({required this.row, required this.uf});
  final TimelineRow row;
  final dynamic uf;

  @override
  ConsumerState<_TimelineRowCard> createState() => _TimelineRowCardState();
}

class _TimelineRowCardState extends ConsumerState<_TimelineRowCard> {
  bool _mapExpanded = false;
  List<UserTimelinePoint>? _points;
  bool _loadingMap = false;
  String? _mapError;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = widget.row;
    final stateColor =
        r.isRunning ? OpenVtsColors.success : OpenVtsColors.textSecondary;
    final stateLabel = r.isRunning ? 'Running' : 'Stopped';
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(OpenVtsRadius.lg),
                  topRight: Radius.circular(OpenVtsRadius.lg),
                  bottomLeft: _mapExpanded
                      ? Radius.zero
                      : Radius.circular(OpenVtsRadius.lg),
                  bottomRight: _mapExpanded
                      ? Radius.zero
                      : Radius.circular(OpenVtsRadius.lg)),
              onTap: () => _showDetails(context),
              child: Padding(
                padding: const EdgeInsets.all(OpenVtsSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(r.vehicleName,
                              style: OpenVtsTypography.label
                                  .copyWith(fontWeight: FontWeight.w700))),
                      _Badge(label: stateLabel, color: stateColor),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: OpenVtsColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                              '${r.startedAt}${r.endedAt != null ? ' → ${r.endedAt}' : ''}',
                              style: OpenVtsTypography.meta.copyWith(
                                  color: OpenVtsColors.textSecondary))),
                      Text(formatDurationSeconds(r.durationSeconds),
                          style: OpenVtsTypography.meta
                              .copyWith(color: OpenVtsColors.textSecondary)),
                    ]),
                    if (r.distanceKm != null && r.isRunning) ...[
                      const SizedBox(height: 2),
                      Text(widget.uf.distance(r.distanceKm!),
                          style: OpenVtsTypography.meta
                              .copyWith(color: OpenVtsColors.textSecondary)),
                    ],
                    const SizedBox(height: OpenVtsSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _toggleMap,
                          icon: Icon(
                              _mapExpanded
                                  ? Icons.map_rounded
                                  : Icons.map_outlined,
                              size: 14),
                          label: Text(_mapExpanded ? 'Hide Map' : 'View Map',
                              style: OpenVtsTypography.meta),
                          style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_mapExpanded) ...[
              const Divider(height: 1),
              _MapSection(
                  points: _points,
                  loading: _loadingMap,
                  error: _mapError,
                  startLat: r.startLat,
                  startLon: r.startLon),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleMap() {
    if (_mapExpanded) {
      setState(() => _mapExpanded = false);
      return;
    }
    setState(() => _mapExpanded = true);
    if (_points == null && !_loadingMap) {
      unawaited(_fetchMap());
    }
  }

  Future<void> _fetchMap() async {
    final r = widget.row;
    if (!r.isRunning || r.startedAt.isEmpty) {
      setState(() {
        _mapError = 'No GPS data for stopped segments.';
      });
      return;
    }
    final vehicleId = r.vehicleId;
    if (vehicleId.isEmpty) {
      setState(() {
        _mapError = 'No vehicle ID in row.';
      });
      return;
    }
    setState(() {
      _loadingMap = true;
      _mapError = null;
    });
    try {
      final ctrl = ref.read(userReportControllerProvider);
      final from = DateTime.tryParse(r.startedAt) ??
          DateTime.now().subtract(const Duration(hours: 1));
      final to = r.endedAt != null
          ? (DateTime.tryParse(r.endedAt!) ?? DateTime.now())
          : DateTime.now();
      final points =
          await ctrl.getTimelineMap(vehicleId: vehicleId, from: from, to: to);
      if (mounted)
        setState(() {
          _points = points;
          _loadingMap = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _loadingMap = false;
          _mapError = e.toString();
        });
    }
  }

  void _showDetails(BuildContext context) {
    final r = widget.row;
    UserReportRowDetailsSheet.show(context,
        title: '${r.vehicleName} — ${r.isRunning ? 'Running' : 'Stopped'}',
        fields: [
          ('Vehicle', r.vehicleName),
          ('State', r.isRunning ? 'Running' : 'Stopped'),
          if (r.date != null) ('Date', r.date!),
          ('Start Time', r.startedAt),
          if (r.endedAt != null) ('End Time', r.endedAt!),
          ('Duration', formatDurationSeconds(r.durationSeconds)),
          if (r.distanceKm != null)
            ('Distance', '${r.distanceKm!.toStringAsFixed(2)} km'),
          if (r.engineHoursSeconds != null)
            ('Engine Hours', formatDurationSeconds(r.engineHoursSeconds!)),
          if (r.maxSpeedKmh != null)
            ('Max Speed', '${r.maxSpeedKmh!.toStringAsFixed(1)} km/h'),
          if (r.avgSpeedKmh != null)
            ('Avg Speed', '${r.avgSpeedKmh!.toStringAsFixed(1)} km/h'),
          if (r.startAddress != null) ('Start Address', r.startAddress!),
          if (r.endAddress != null) ('End Address', r.endAddress!),
          if (r.startLat != null && r.startLon != null)
            ('Start Location', formatCoordinate(r.startLat, r.startLon)),
          if (r.endLat != null && r.endLon != null)
            ('End Location', formatCoordinate(r.endLat, r.endLon)),
        ]);
  }
}

class _MapSection extends StatefulWidget {
  const _MapSection(
      {required this.points,
      required this.loading,
      required this.error,
      this.startLat,
      this.startLon});
  final List<UserTimelinePoint>? points;
  final bool loading;
  final String? error;
  final double? startLat;
  final double? startLon;

  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  final MapController _mapController = MapController();
  String _selectedLayerId = 'google-road';

  MapLayerOption _getSelectedLayer() =>
      mapLayerOptionById(_selectedLayerId) ?? primaryMapLayerOptions.first;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    if (widget.error != null) {
      return Padding(
          padding: const EdgeInsets.all(12),
          child: Text(widget.error!,
              style:
                  OpenVtsTypography.meta.copyWith(color: OpenVtsColors.error)));
    }
    if (widget.points == null) return const SizedBox.shrink();
    if (widget.points!.isEmpty) {
      return const Padding(
          padding: EdgeInsets.all(12),
          child: Text('No valid GPS location', style: OpenVtsTypography.body));
    }

    final polyLatLngs = widget.points!
        .where((p) => p.isValid)
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    if (polyLatLngs.isEmpty) {
      return const Padding(
          padding: EdgeInsets.all(12),
          child: Text('No valid GPS location', style: OpenVtsTypography.body));
    }

    final center = polyLatLngs.length == 1
        ? polyLatLngs.first
        : LatLng(widget.startLat ?? polyLatLngs.first.latitude,
            widget.startLon ?? polyLatLngs.first.longitude);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(OpenVtsRadius.lg)),
      child: SizedBox(
        height: 280,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: polyLatLngs.length == 1 ? 15 : 13,
                onMapReady: () {
                  if (polyLatLngs.length >= 2) {
                    _mapController.fitCamera(
                      CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(polyLatLngs),
                        padding: const EdgeInsets.all(32),
                        maxZoom: 17,
                      ),
                    );
                  }
                },
              ),
              children: [
                TileLayer(
                  key: ValueKey<String>(_selectedLayerId),
                  urlTemplate: _getSelectedLayer().url,
                  subdomains: _getSelectedLayer().subdomains,
                  userAgentPackageName: kTimelineMapTileUserAgent,
                ),
                if (polyLatLngs.length > 1)
                  PolylineLayer(polylines: [
                    Polyline(
                        points: polyLatLngs,
                        strokeWidth: 3,
                        color: OpenVtsColors.info)
                  ]),
                MarkerLayer(markers: [
                  Marker(
                      point: polyLatLngs.first,
                      width: 20,
                      height: 20,
                      child: const Icon(Icons.trip_origin_rounded,
                          size: 20, color: OpenVtsColors.success)),
                  if (polyLatLngs.length > 1)
                    Marker(
                        point: polyLatLngs.last,
                        width: 20,
                        height: 20,
                        child: const Icon(Icons.location_on_rounded,
                            size: 20, color: OpenVtsColors.error)),
                ]),
              ],
            ),
            Positioned(
              top: OpenVtsSpacing.xs,
              right: OpenVtsSpacing.xs,
              child: OpenVtsMapLayerSelectorButton(
                selectedLayerId: _selectedLayerId,
                onLayerSelected: (layer) {
                  setState(() => _selectedLayerId = layer.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
