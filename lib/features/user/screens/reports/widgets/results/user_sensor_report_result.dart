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

class UserSensorReportResult extends StatelessWidget {
  const UserSensorReportResult(
      {required this.state,
      required this.onLoadMore,
      required this.onExport,
      super.key});

  final UserReportWorkspaceState state;
  final VoidCallback onLoadMore;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    final rows = state.rows.map(SensorRow.fromMap).toList();

    // Determine sensor type from first row
    final firstRow = rows.isNotEmpty ? rows.first : null;
    final isBoolSensor = firstRow?.isBoolean ?? false;
    final sensorLabel = firstRow?.sensorLabel ?? 'Sensor';

    final kpis = _buildKpis(rows, isBoolSensor);

    // Downsample for chart — use real timestamp ms when available, else index.
    final hasTimestamps = rows.any((r) => r.timestampMs != null);
    final indexed = rows
        .asMap()
        .entries
        .map((e) => (
              index: e.key,
              row: e.value,
              x: hasTimestamps
                  ? (e.value.timestampMs ?? e.key.toDouble())
                  : e.key.toDouble(),
            ))
        .toList();
    final chartIndexed = downsampleLTTB(
      data: indexed,
      maxPoints: kChartMaxPoints,
      getX: (e) => e.x,
      getY: (e) => isBoolSensor
          ? ((e.row.rawValue as bool?) == true ? 1.0 : 0.0)
          : e.row.numericValue,
    );
    final chartRows = chartIndexed.map((e) => (row: e.row, x: e.x)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (chartRows.isNotEmpty) ...[
          isBoolSensor
              ? _BoolSensorChart(entries: chartRows, sensorLabel: sensorLabel)
              : _NumericSensorChart(
                  entries: chartRows,
                  sensorLabel: sensorLabel,
                  unit: firstRow?.unit,
                  hasTimestamps: hasTimestamps),
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
        ...rows.map((r) => _SensorRowCard(row: r)),
      ],
    );
  }

  List<ReportKpi> _buildKpis(List<SensorRow> rows, bool isBool) {
    if (rows.isEmpty) return [];
    if (isBool) {
      // Mirrors web BooleanSensorResult KPIs: currentState, transitions, activeDuration, lastChange
      final currentState = rows.isNotEmpty
          ? ((rows.last.rawValue == true || rows.last.rawValue == 1)
              ? 'ON'
              : 'OFF')
          : '—';
      int transitions = 0;
      double activeSec = 0;
      String lastChange = rows.isNotEmpty ? rows.first.timestamp : '—';
      for (var i = 1; i < rows.length; i++) {
        final prev = rows[i - 1].rawValue;
        final curr = rows[i].rawValue;
        if (prev != curr) {
          transitions++;
          lastChange = rows[i].timestamp;
        }
        if (curr == true || curr == 1) {
          final prevMs =
              DateTime.tryParse(rows[i - 1].timestamp)?.millisecondsSinceEpoch;
          final currMs =
              DateTime.tryParse(rows[i].timestamp)?.millisecondsSinceEpoch;
          if (prevMs != null && currMs != null) {
            activeSec +=
                ((currMs - prevMs).abs() / 1000).clamp(0, double.infinity);
          }
        }
      }
      return [
        ReportKpi(label: 'Current State', value: currentState),
        ReportKpi(label: 'Transitions', value: '$transitions'),
        ReportKpi(
            label: 'Active Duration', value: formatDurationSeconds(activeSec)),
        ReportKpi(label: 'Last Change', value: lastChange),
      ];
    } else {
      final values = rows
          .where((r) => r.rawValue is num)
          .map((r) => r.numericValue)
          .toList();
      if (values.isEmpty)
        return [ReportKpi(label: 'Readings', value: '${rows.length}')];
      // Matches web NumericSensorResult KPIs: latest, min, max, avg
      final latest = values.last;
      final minVal = values.reduce((a, b) => a < b ? a : b);
      final maxVal = values.reduce((a, b) => a > b ? a : b);
      final avg = values.fold(0.0, (s, v) => s + v) / values.length;
      return [
        ReportKpi(label: 'Latest', value: latest.toStringAsFixed(2)),
        ReportKpi(label: 'Min', value: minVal.toStringAsFixed(2)),
        ReportKpi(label: 'Max', value: maxVal.toStringAsFixed(2)),
        ReportKpi(label: 'Avg', value: avg.toStringAsFixed(2)),
      ];
    }
  }
}

class _NumericSensorChart extends StatelessWidget {
  const _NumericSensorChart(
      {required this.entries,
      required this.sensorLabel,
      required this.hasTimestamps,
      this.unit});
  final List<({SensorRow row, double x})> entries;
  final String sensorLabel;
  final bool hasTimestamps;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor =
        isDark ? OpenVtsColors.info.withValues(alpha: 0.9) : OpenVtsColors.info;
    final spots = entries
        .where((e) => e.row.rawValue is num)
        .map((e) => FlSpot(e.x, e.row.numericValue))
        .toList();
    if (spots.isEmpty) return const SizedBox.shrink();

    final yValues = spots.map((s) => s.y).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY).abs() * 0.1 + 1;

    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$sensorLabel${unit != null ? ' ($unit)' : ''}',
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
            height: 180,
            child: LineChart(LineChartData(
              minY: minY - padding,
              maxY: maxY + padding,
              lineBarsData: [
                LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.2,
                    color: lineColor,
                    barWidth: 2,
                    dotData: FlDotData(show: spots.length <= 30))
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (v, _) => Text(v.toStringAsFixed(1),
                            style:
                                OpenVtsTypography.meta.copyWith(fontSize: 8)))),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: hasTimestamps,
                        reservedSize: 22,
                        getTitlesWidget: (v, meta) {
                          if (!hasTimestamps) return const SizedBox.shrink();
                          final dt = DateTime.fromMillisecondsSinceEpoch(
                              v.toInt(),
                              isUtc: true);
                          final h = dt.hour.toString().padLeft(2, '0');
                          final m = dt.minute.toString().padLeft(2, '0');
                          return Text('$h:$m',
                              style:
                                  OpenVtsTypography.meta.copyWith(fontSize: 8));
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

class _BoolSensorChart extends StatelessWidget {
  const _BoolSensorChart({required this.entries, required this.sensorLabel});
  final List<({SensorRow row, double x})> entries;
  final String sensorLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Step-line: ON=1, OFF=0
    final spots = entries
        .map((e) => FlSpot(e.x, (e.row.rawValue as bool?) == true ? 1.0 : 0.0))
        .toList();
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
          border: Border.all(
              color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(sensorLabel,
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
            height: 120,
            child: LineChart(LineChartData(
              minY: -0.1,
              maxY: 1.2,
              lineBarsData: [
                LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: OpenVtsColors.success,
                    barWidth: 2,
                    isStepLineChart: true,
                    dotData: FlDotData(show: spots.length <= 20))
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) {
                          if (v == 1.0)
                            return Text('ON',
                                style: OpenVtsTypography.meta
                                    .copyWith(fontSize: 9));
                          if (v == 0.0)
                            return Text('OFF',
                                style: OpenVtsTypography.meta
                                    .copyWith(fontSize: 9));
                          return const SizedBox.shrink();
                        })),
                bottomTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => v == 0 || v == 1
                      ? FlLine(
                          color: isDark
                              ? OpenVtsColors.darkBorder
                              : OpenVtsColors.border,
                          strokeWidth: 0.5)
                      : FlLine(color: Colors.transparent)),
            ))),
      ]),
    );
  }
}

class _SensorRowCard extends StatelessWidget {
  const _SensorRowCard({required this.row});
  final SensorRow row;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayValue = row.isBoolean
        ? ((row.rawValue as bool?) == true ? 'ON' : 'OFF')
        : (row.rawValue is num
            ? '${row.numericValue.toStringAsFixed(2)}${row.unit != null ? ' ${row.unit}' : ''}'
            : '—');
    final valueColor = row.isBoolean
        ? ((row.rawValue as bool?) == true
            ? OpenVtsColors.success
            : OpenVtsColors.textSecondary)
        : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        onTap: () => _showDetails(context),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: OpenVtsSpacing.sm, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
            border: Border.all(
                color:
                    isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
          ),
          child: Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.sensorLabel,
                    style: OpenVtsTypography.label
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(row.timestamp,
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.textSecondary)),
              ],
            )),
            Text(displayValue,
                style: OpenVtsTypography.label
                    .copyWith(fontWeight: FontWeight.w700, color: valueColor)),
          ]),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    UserReportRowDetailsSheet.show(context, title: row.sensorLabel, fields: [
      ('Sensor', row.sensorLabel),
      ('Vehicle', row.vehicleName),
      ('Time', row.timestamp),
      if (row.isBoolean)
        ('Value', (row.rawValue as bool?) == true ? 'ON' : 'OFF'),
      if (!row.isBoolean && row.rawValue is num)
        ('Value', row.numericValue.toStringAsFixed(4)),
      if (row.unit != null) ('Unit', row.unit!),
      if (row.rawValue != null) ('Raw', row.rawValue.toString()),
    ]);
  }
}
