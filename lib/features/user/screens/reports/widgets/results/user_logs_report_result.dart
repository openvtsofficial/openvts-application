import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../models/user_report_state.dart';
import '../../../../utils/user_report_format.dart';
import '../user_report_kpi_row.dart';
import '../user_report_result_toolbar.dart';
import '../user_report_row_details_sheet.dart';

class UserLogsReportResult extends StatelessWidget {
  const UserLogsReportResult(
      {required this.state,
      required this.onLoadMore,
      required this.onExport,
      super.key});

  final UserReportWorkspaceState state;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    final rows = state.rows.map(LogRow.fromMap).toList();

    final total = rows.length;
    final byLevel = <String, int>{};
    for (final r in rows) {
      byLevel[r.level] = (byLevel[r.level] ?? 0) + 1;
    }
    final byCategory = <String, int>{};
    for (final r in rows) {
      byCategory[r.category] = (byCategory[r.category] ?? 0) + 1;
    }

    final kpis = [
      ReportKpi(label: 'Total Logs', value: '$total'),
      ReportKpi(
          label: 'Error/Critical',
          value: '${(byLevel['error'] ?? 0) + (byLevel['critical'] ?? 0)}'),
      ReportKpi(label: 'Warning', value: '${byLevel['warning'] ?? 0}'),
      ReportKpi(label: 'Categories', value: '${byCategory.length}'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (byLevel.isNotEmpty) ...[
          _LevelDonut(byLevel: byLevel),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
        if (byCategory.length > 1) ...[
          _CategoryBarChart(byCategory: byCategory),
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
        ...rows.map((r) => _LogRowCard(row: r)),
      ],
    );
  }
}

const _kLevelColors = {
  'critical': Color(0xFF8A3333),
  'error': Color(0xFFC04A4A),
  'warning': Color(0xFF8A6522),
  'info': Color(0xFF2A5270),
  'debug': Color(0xFF3A5A4A),
  'trace': Color(0xFF4A4A4A)
};
Color _levelColor(String level) =>
    _kLevelColors[level.toLowerCase()] ?? const Color(0xFF4A4A4A);

class _LevelDonut extends StatelessWidget {
  const _LevelDonut({required this.byLevel});
  final Map<String, int> byLevel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keys = byLevel.keys.toList();
    final sections = keys
        .map((k) => PieChartSectionData(
            value: byLevel[k]!.toDouble(),
            color: _levelColor(k),
            title: '${byLevel[k]}',
            radius: 42,
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
        Text('Logs by Level',
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
                                    color: _levelColor(k),
                                    borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text('${_capitalize(k)}: ${byLevel[k]}',
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

class _CategoryBarChart extends StatelessWidget {
  const _CategoryBarChart({required this.byCategory});
  final Map<String, int> byCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sorted = (byCategory.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(8)
        .toList();
    final maxVal =
        sorted.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b);
    final barColor = isDark
        ? OpenVtsColors.darkTextPrimary.withValues(alpha: 0.8)
        : OpenVtsColors.brandInk.withValues(alpha: 0.7);
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Logs by Category',
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
            height: 140,
            child: BarChart(BarChartData(
              maxY: maxVal * 1.2,
              barGroups: sorted
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
                          if (i < 0 || i >= sorted.length)
                            return const SizedBox.shrink();
                          final name = sorted[i].key;
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

class _LogRowCard extends StatelessWidget {
  const _LogRowCard({required this.row});
  final LogRow row;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final levelColor = _levelColor(row.level);
    final (:text, :truncated) = truncatePayload(row.payload, maxLength: 120);
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
                  child: Text(row.event,
                      style: OpenVtsTypography.label
                          .copyWith(fontWeight: FontWeight.w700))),
              _Badge(label: _capitalize(row.level), color: levelColor),
            ]),
            const SizedBox(height: 3),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    border:
                        Border.all(color: levelColor.withValues(alpha: 0.25))),
                child: Text(row.category,
                    style: OpenVtsTypography.meta.copyWith(fontSize: 10)),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.access_time_rounded,
                  size: 12, color: OpenVtsColors.textSecondary),
              const SizedBox(width: 3),
              Text(row.timestamp,
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.textSecondary)),
            ]),
            if (text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(text + (truncated ? '…' : ''),
                  style: OpenVtsTypography.meta.copyWith(
                      fontFamily: 'monospace',
                      color: isDark
                          ? OpenVtsColors.darkTextSecondary
                          : OpenVtsColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3),
            ],
          ]),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final (:text, :truncated) =
        truncatePayload(row.payload, maxLength: kLogPayloadMaxLength);
    UserReportRowDetailsSheet.show(
      context,
      title: '${row.event} — ${_capitalize(row.level)}',
      fields: [
        ('Event', row.event),
        ('Level', _capitalize(row.level)),
        ('Category', row.category),
        ('Time', row.timestamp),
        if (row.direction != null) ('Direction', row.direction!),
      ],
      rawPayload: row.payload != null ? text : null,
      payloadTruncated: truncated,
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

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
