import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../models/user_report_state.dart';
import '../../../../utils/user_report_format.dart';
import '../user_report_kpi_row.dart';
import '../user_report_result_toolbar.dart';
import '../user_report_row_details_sheet.dart';

class UserGeofenceReportResult extends StatelessWidget {
  const UserGeofenceReportResult(
      {required this.state,
      required this.onLoadMore,
      required this.onExport,
      super.key});

  final UserReportWorkspaceState state;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    final rows = state.rows.map(GeofenceRow.fromMap).toList();

    final entries = rows
        .where((r) =>
            r.event.toLowerCase().contains('enter') ||
            r.event.toLowerCase().contains('entry'))
        .length;
    final exits =
        rows.where((r) => r.event.toLowerCase().contains('exit')).length;
    final geofences = rows.map((r) => r.geofenceName).toSet().length;
    final vehicles = rows.map((r) => r.vehicleName).toSet().length;

    final kpis = [
      ReportKpi(label: 'Total Events', value: '${rows.length}'),
      ReportKpi(label: 'Entries', value: '$entries'),
      ReportKpi(label: 'Exits', value: '$exits'),
      ReportKpi(label: 'Geofences', value: '$geofences / $vehicles veh.'),
    ];

    // Donut by event type
    final byType = <String, int>{};
    for (final r in rows) {
      byType[r.event] = (byType[r.event] ?? 0) + 1;
    }

    // Bar chart: events per geofence
    final byGeofence = <String, int>{};
    for (final r in rows) {
      byGeofence[r.geofenceName] = (byGeofence[r.geofenceName] ?? 0) + 1;
    }
    final topGeofences = (byGeofence.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(8)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (byType.isNotEmpty) ...[
          _EventTypeDonut(byType: byType),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
        if (topGeofences.isNotEmpty) ...[
          _GeofenceBarChart(topGeofences: topGeofences),
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
        ...rows.map((r) => _GeofenceRowCard(row: r)),
      ],
    );
  }
}

const _kEntryColors = [
  Color(0xFF2F6B4F),
  Color(0xFF8A3333),
  Color(0xFF435A6B),
  Color(0xFF8A6522),
  Color(0xFF4A2D6B)
];

class _EventTypeDonut extends StatelessWidget {
  const _EventTypeDonut({required this.byType});
  final Map<String, int> byType;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final types = byType.keys.toList();
    final sections = types.asMap().entries.map((e) {
      final color = _kEntryColors[e.key % _kEntryColors.length];
      return PieChartSectionData(
          value: byType[e.value]!.toDouble(),
          color: color,
          title: '${byType[e.value]}',
          radius: 44,
          titleStyle: OpenVtsTypography.meta
              .copyWith(fontSize: 9, color: OpenVtsColors.white));
    }).toList();
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Events by Type',
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
            height: 130,
            child: Row(children: [
              SizedBox(
                  width: 130,
                  child: PieChart(PieChartData(
                      sections: sections,
                      centerSpaceRadius: 28,
                      sectionsSpace: 2))),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: types
                    .asMap()
                    .entries
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(children: [
                            Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: _kEntryColors[
                                        e.key % _kEntryColors.length],
                                    borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text('${e.value}: ${byType[e.value]}',
                                    style: OpenVtsTypography.meta,
                                    overflow: TextOverflow.ellipsis)),
                          ]),
                        ))
                    .toList(),
              )),
            ])),
      ]),
    );
  }
}

class _GeofenceBarChart extends StatelessWidget {
  const _GeofenceBarChart({required this.topGeofences});
  final List<MapEntry<String, int>> topGeofences;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark
        ? OpenVtsColors.darkTextPrimary.withValues(alpha: 0.8)
        : OpenVtsColors.brandInk.withValues(alpha: 0.75);
    final maxVal = topGeofences
        .map((e) => e.value.toDouble())
        .reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Events by Geofence (top ${topGeofences.length})',
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
            height: 160,
            child: BarChart(BarChartData(
              maxY: maxVal * 1.2,
              barGroups: topGeofences
                  .asMap()
                  .entries
                  .map((e) => BarChartGroupData(x: e.key, barRods: [
                        BarChartRodData(
                            toY: e.value.value.toDouble(),
                            color: barColor,
                            width: 14,
                            borderRadius: BorderRadius.circular(3))
                      ]))
                  .toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}',
                            style:
                                OpenVtsTypography.meta.copyWith(fontSize: 9)))),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= topGeofences.length)
                            return const SizedBox.shrink();
                          final name = topGeofences[i].key;
                          final short = name.length > 8
                              ? '${name.substring(0, 7)}…'
                              : name;
                          return Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(short,
                                  style: OpenVtsTypography.meta
                                      .copyWith(fontSize: 9)));
                        })),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                      color: isDark
                          ? OpenVtsColors.darkBorder
                          : OpenVtsColors.border,
                      strokeWidth: 0.5)),
            ))),
      ]),
    );
  }
}

class _GeofenceRowCard extends StatelessWidget {
  const _GeofenceRowCard({required this.row});
  final GeofenceRow row;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEntry = row.event.toLowerCase().contains('enter') ||
        row.event.toLowerCase().contains('entry');
    final eventColor = isEntry ? OpenVtsColors.success : OpenVtsColors.error;
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(row.vehicleName,
                      style: OpenVtsTypography.label
                          .copyWith(fontWeight: FontWeight.w700))),
              _Badge(label: row.event, color: eventColor),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_city_rounded,
                  size: 13, color: OpenVtsColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(row.geofenceName,
                      style: OpenVtsTypography.body,
                      overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: OpenVtsColors.textSecondary),
              const SizedBox(width: 4),
              Text(row.timestamp,
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.textSecondary)),
            ]),
            if (row.address != null || row.lat != null) ...[
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  final uri = geoUri(row.lat, row.lon);
                  if (uri != null) launchUrl(Uri.parse(uri));
                },
                child: Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 13, color: OpenVtsColors.info),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(
                          row.address ?? formatCoordinate(row.lat, row.lon),
                          style: OpenVtsTypography.meta
                              .copyWith(color: OpenVtsColors.info),
                          overflow: TextOverflow.ellipsis)),
                ]),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    UserReportRowDetailsSheet.show(context,
        title: '${row.vehicleName} — ${row.event}',
        fields: [
          ('Vehicle', row.vehicleName),
          ('Geofence', row.geofenceName),
          ('Event', row.event),
          ('Time', row.timestamp),
          if (row.durationSeconds != null)
            ('Duration Inside', formatDurationSeconds(row.durationSeconds!)),
          if (row.address != null) ('Address', row.address!),
          if (row.lat != null && row.lon != null)
            ('Location', formatCoordinate(row.lat, row.lon)),
        ]);
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
