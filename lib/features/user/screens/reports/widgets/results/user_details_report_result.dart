import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../../../core/utils/unit_formatter.dart';
import '../../../../models/user_report_state.dart';
import '../../../../utils/user_report_format.dart';
import '../user_report_kpi_row.dart';
import '../user_report_result_toolbar.dart';
import '../user_report_row_details_sheet.dart';

class UserDetailsReportResult extends ConsumerWidget {
  const UserDetailsReportResult(
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
    final rows = state.rows.map(DetailsRow.fromMap).toList();

    final totalDist = rows.fold(0.0, (s, r) => s + r.distanceKm);
    final totalEh = rows.fold(0.0, (s, r) => s + r.engineHoursSeconds);
    final totalTrips = rows.fold(0, (s, r) => s + r.totalTrips);

    final maxSpeed =
        rows.fold(0.0, (s, r) => r.maxSpeedKmh > s ? r.maxSpeedKmh : s);

    final kpis = [
      ReportKpi(label: 'Total Distance', value: uf.distance(totalDist)),
      ReportKpi(label: 'Engine Hours', value: formatDurationSeconds(totalEh)),
      ReportKpi(label: 'Trips', value: '$totalTrips'),
      ReportKpi(label: 'Max Speed', value: uf.speed(maxSpeed)),
    ];

    final dayDist = rows.fold(0.0, (s, r) => s + r.dayDistanceKm);
    final nightDist = rows.fold(0.0, (s, r) => s + r.nightDistanceKm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (dayDist + nightDist > 0) ...[
          _DayNightDonut(dayDist: dayDist, nightDist: nightDist, uf: uf),
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
        ...rows.map((r) => _DetailsRowCard(row: r, uf: uf)),
      ],
    );
  }
}

class _DayNightDonut extends StatelessWidget {
  const _DayNightDonut(
      {required this.dayDist, required this.nightDist, required this.uf});
  final double dayDist;
  final double nightDist;
  final dynamic uf;

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
          Text('Day vs Night Driving',
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
                        value: dayDist,
                        color: OpenVtsColors.warning,
                        title: 'Day',
                        radius: 42,
                        titleStyle: OpenVtsTypography.meta
                            .copyWith(fontSize: 9, color: OpenVtsColors.white)),
                    PieChartSectionData(
                        value: nightDist,
                        color: OpenVtsColors.info,
                        title: 'Night',
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
                        color: OpenVtsColors.warning,
                        label: 'Day: ${uf.distance(dayDist)}'),
                    const SizedBox(height: 4),
                    _Legend(
                        color: OpenVtsColors.info,
                        label: 'Night: ${uf.distance(nightDist)}'),
                  ]),
            ]),
          ),
        ],
      ),
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

class _DetailsRowCard extends StatelessWidget {
  const _DetailsRowCard({required this.row, required this.uf});
  final DetailsRow row;
  final dynamic uf;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        onTap: () => _showDetails(context),
        child: Container(
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
            border: Border.all(
                color:
                    isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.vehicleName,
                        style: OpenVtsTypography.label
                            .copyWith(fontWeight: FontWeight.w700)),
                    Text(row.date,
                        style: OpenVtsTypography.meta
                            .copyWith(color: OpenVtsColors.textSecondary)),
                  ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(uf.distance(row.distanceKm),
                        style: OpenVtsTypography.label
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(formatDurationSeconds(row.engineHoursSeconds),
                        style: OpenVtsTypography.meta
                            .copyWith(color: OpenVtsColors.textSecondary)),
                  ],
                ),
              ]),
              const SizedBox(height: 6),
              _InfoRow(
                  icon: Icons.route_rounded,
                  label:
                      '${row.totalTrips} trip${row.totalTrips == 1 ? '' : 's'}'),
              _InfoRow(
                  icon: Icons.speed_rounded,
                  label: 'Max ${row.maxSpeedKmh.toStringAsFixed(1)} km/h'),
              if (row.startAddress != null || row.startLat != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    final uri = geoUri(row.startLat, row.startLon);
                    if (uri != null) launchUrl(Uri.parse(uri));
                  },
                  child: Row(children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: OpenVtsColors.info),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(
                            row.startAddress ??
                                formatCoordinate(row.startLat, row.startLon),
                            style: OpenVtsTypography.meta
                                .copyWith(color: OpenVtsColors.info),
                            overflow: TextOverflow.ellipsis)),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    UserReportRowDetailsSheet.show(
      context,
      title: row.vehicleName,
      fields: [
        ('Vehicle', row.vehicleName),
        ('Date', row.date),
        ('Distance', '${row.distanceKm.toStringAsFixed(2)} km'),
        ('Day Distance', '${row.dayDistanceKm.toStringAsFixed(2)} km'),
        ('Night Distance', '${row.nightDistanceKm.toStringAsFixed(2)} km'),
        ('Engine Hours', formatDurationSeconds(row.engineHoursSeconds)),
        ('Day Engine Hours', formatDurationSeconds(row.dayEngineHoursSeconds)),
        (
          'Night Engine Hours',
          formatDurationSeconds(row.nightEngineHoursSeconds)
        ),
        ('Max Speed', '${row.maxSpeedKmh.toStringAsFixed(1)} km/h'),
        ('Avg Speed', '${row.avgSpeedKmh.toStringAsFixed(1)} km/h'),
        ('Trips', '${row.totalTrips}'),
        if (row.startAddress != null) ('Start Address', row.startAddress!),
        if (row.endAddress != null) ('End Address', row.endAddress!),
        if (row.startLat != null && row.startLon != null)
          ('Start Location', formatCoordinate(row.startLat, row.startLon)),
        if (row.endLat != null && row.endLon != null)
          ('End Location', formatCoordinate(row.endLat, row.endLon)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(children: [
        Icon(icon, size: 13, color: OpenVtsColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
            child: Text(label,
                style: OpenVtsTypography.meta
                    .copyWith(color: OpenVtsColors.textSecondary),
                overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
