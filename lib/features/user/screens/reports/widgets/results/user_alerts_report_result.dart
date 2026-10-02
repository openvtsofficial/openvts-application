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

class UserAlertsReportResult extends StatelessWidget {
  const UserAlertsReportResult(
      {required this.state,
      required this.onLoadMore,
      required this.onExport,
      super.key});

  final UserReportWorkspaceState state;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    final rows = state.rows.map(AlertRow.fromMap).toList();

    final total = rows.length;
    final critical =
        rows.where((r) => r.severity.toLowerCase() == 'critical').length;
    final acknowledged = rows.where((r) => r.acknowledged).length;
    final vehicles = rows.map((r) => r.vehicleName).toSet().length;

    final kpis = [
      ReportKpi(label: 'Total Alerts', value: '$total'),
      ReportKpi(label: 'Critical', value: '$critical'),
      ReportKpi(label: 'Acknowledged', value: '$acknowledged'),
      ReportKpi(label: 'Vehicles Affected', value: '$vehicles'),
    ];

    final bySeverity = <String, int>{};
    for (final r in rows) {
      bySeverity[r.severity] = (bySeverity[r.severity] ?? 0) + 1;
    }

    final byType = <String, int>{};
    for (final r in rows) {
      byType[r.alertType] = (byType[r.alertType] ?? 0) + 1;
    }
    final topTypes = (byType.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(8)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (bySeverity.isNotEmpty) ...[
          _SeverityDonut(bySeverity: bySeverity),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
        if (topTypes.isNotEmpty) ...[
          _AlertTypeBarChart(topTypes: topTypes),
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
        ...rows.map((r) => _AlertRowCard(row: r)),
      ],
    );
  }
}

const _kSeverityColors = {
  'critical': Color(0xFF8A3333),
  'high': Color(0xFF8A6522),
  'medium': Color(0xFF435A6B),
  'low': Color(0xFF2F6B4F),
  'info': Color(0xFF2A5270)
};

Color _sevColor(String sev) =>
    _kSeverityColors[sev.toLowerCase()] ?? const Color(0xFF435A6B);

class _SeverityDonut extends StatelessWidget {
  const _SeverityDonut({required this.bySeverity});
  final Map<String, int> bySeverity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keys = bySeverity.keys.toList();
    final sections = keys
        .map((k) => PieChartSectionData(
            value: bySeverity[k]!.toDouble(),
            color: _sevColor(k),
            title: '${bySeverity[k]}',
            radius: 44,
            titleStyle: OpenVtsTypography.meta
                .copyWith(fontSize: 9, color: OpenVtsColors.white)))
        .toList();
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Alerts by Severity',
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
                children: keys
                    .map((k) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(children: [
                            Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: _sevColor(k),
                                    borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text(
                                    '${_capitalize(k)}: ${bySeverity[k]}',
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

class _AlertTypeBarChart extends StatelessWidget {
  const _AlertTypeBarChart({required this.topTypes});
  final List<MapEntry<String, int>> topTypes;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark
        ? OpenVtsColors.warning.withValues(alpha: 0.8)
        : OpenVtsColors.warning.withValues(alpha: 0.75);
    final maxVal =
        topTypes.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Alert Types (top ${topTypes.length})',
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
            height: 150,
            child: BarChart(BarChartData(
              maxY: maxVal * 1.2,
              barGroups: topTypes
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
                          if (i < 0 || i >= topTypes.length)
                            return const SizedBox.shrink();
                          final name = topTypes[i].key;
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

class _AlertRowCard extends StatelessWidget {
  const _AlertRowCard({required this.row});
  final AlertRow row;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sevColor = _sevColor(row.severity);
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
              if (row.acknowledged)
                Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(Icons.check_circle_outline_rounded,
                        size: 14, color: OpenVtsColors.success)),
              _Badge(label: _capitalize(row.severity), color: sevColor),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.notifications_rounded,
                  size: 13, color: OpenVtsColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(row.alertType,
                      style: OpenVtsTypography.body,
                      overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 2),
            if (row.message?.isNotEmpty ?? false) ...[
              Text(row.message ?? '',
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
            ],
            Row(children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: OpenVtsColors.textSecondary),
              const SizedBox(width: 4),
              Text(row.eventTime,
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
        title: '${row.vehicleName} — ${row.alertType}',
        fields: [
          ('Vehicle', row.vehicleName),
          ('Type', row.alertType),
          ('Severity', _capitalize(row.severity)),
          if (row.message != null) ('Message', row.message!),
          ('Time', row.eventTime),
          ('Acknowledged', row.acknowledged ? 'Yes' : 'No'),
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

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
