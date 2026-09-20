import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/open_vts_colors.dart';
import '../../../../../../core/theme/open_vts_radius.dart';
import '../../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../../core/theme/open_vts_typography.dart';
import '../../../../models/user_report_state.dart';
import '../../../../utils/user_report_format.dart';
import '../../../../../../core/utils/unit_formatter.dart';
import '../user_report_kpi_row.dart';
import '../user_report_result_toolbar.dart';
import '../user_report_row_details_sheet.dart';

class UserDrivenReportResult extends ConsumerWidget {
  const UserDrivenReportResult(
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
    final rows = state.rows.map(DrivenRow.fromMap).toList();

    // Collect unique dates (columns) and vehicle rows
    final allDates = rows.map((r) => r.date).toSet().toList()..sort();
    final byVehicle = <String, Map<String, double>>{};
    for (final r in rows) {
      byVehicle.putIfAbsent(r.vehicleName, () => {});
      byVehicle[r.vehicleName]![r.date] = r.distanceKm;
    }

    // Daily totals for chart
    final dailyTotals = <String, double>{};
    for (final r in rows) {
      dailyTotals[r.date] = (dailyTotals[r.date] ?? 0) + r.distanceKm;
    }
    final sortedDates = dailyTotals.keys.toList()..sort();

    final totalDist = rows.fold(0.0, (s, r) => s + r.distanceKm);
    final drivenVehicles = byVehicle.keys.length;
    final avgDaily = sortedDates.isEmpty ? 0.0 : totalDist / sortedDates.length;
    final maxSingleDay = dailyTotals.isEmpty
        ? 0.0
        : dailyTotals.values.reduce((a, b) => a > b ? a : b);

    final kpis = [
      ReportKpi(label: 'Total Distance', value: uf.distance(totalDist)),
      ReportKpi(label: 'Vehicles Driven', value: '$drivenVehicles'),
      ReportKpi(label: 'Avg Daily', value: uf.distance(avgDaily)),
      ReportKpi(label: 'Peak Day', value: uf.distance(maxSingleDay)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (sortedDates.isNotEmpty) ...[
          _DailyTotalsChart(
              sortedDates: sortedDates, dailyTotals: dailyTotals, uf: uf),
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
        // Vehicle summary cards
        ...byVehicle.entries.map((entry) {
          final vehicleDays = entry.value;
          final total = vehicleDays.values.fold(0.0, (s, v) => s + v);
          final days = vehicleDays.length;
          return _DrivenVehicleCard(
            vehicleName: entry.key,
            totalKm: total,
            activeDays: days,
            allDates: allDates,
            dayValues: vehicleDays,
            uf: uf,
          );
        }),
      ],
    );
  }
}

class _DailyTotalsChart extends StatelessWidget {
  const _DailyTotalsChart(
      {required this.sortedDates, required this.dailyTotals, required this.uf});
  final List<String> sortedDates;
  final Map<String, double> dailyTotals;
  final dynamic uf;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVal = dailyTotals.values.reduce((a, b) => a > b ? a : b);
    final barColor = isDark
        ? OpenVtsColors.darkTextPrimary.withValues(alpha: 0.9)
        : OpenVtsColors.brandInk.withValues(alpha: 0.85);
    final displayDates = sortedDates.length > kDrivenMaxDayColumns
        ? sortedDates.sublist(sortedDates.length - kDrivenMaxDayColumns)
        : sortedDates;

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
          Text('Daily Distance Totals',
              style: OpenVtsTypography.label
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: OpenVtsSpacing.sm),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: maxVal * 1.15,
                barGroups: displayDates
                    .asMap()
                    .entries
                    .map((e) => BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                                toY: dailyTotals[e.value] ?? 0,
                                color: barColor,
                                width: 8,
                                borderRadius: BorderRadius.circular(2))
                          ],
                        ))
                    .toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (v, _) => Text(uf.distance(v),
                              style: OpenVtsTypography.meta
                                  .copyWith(fontSize: 8)))),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: displayDates.length <= 14,
                          reservedSize: 24,
                          getTitlesWidget: (v, _) {
                            final i = v.toInt();
                            if (i < 0 || i >= displayDates.length)
                              return const SizedBox.shrink();
                            final d = displayDates[i];
                            final label = d.length >= 10 ? d.substring(5) : d;
                            return Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(label,
                                    style: OpenVtsTypography.meta
                                        .copyWith(fontSize: 8)));
                          })),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrivenVehicleCard extends StatelessWidget {
  const _DrivenVehicleCard(
      {required this.vehicleName,
      required this.totalKm,
      required this.activeDays,
      required this.allDates,
      required this.dayValues,
      required this.uf});
  final String vehicleName;
  final double totalKm;
  final int activeDays;
  final List<String> allDates;
  final Map<String, double> dayValues;
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
                    child: Text(vehicleName,
                        style: OpenVtsTypography.label
                            .copyWith(fontWeight: FontWeight.w700))),
                Text(uf.distance(totalKm),
                    style: OpenVtsTypography.label
                        .copyWith(fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 2),
              Text('$activeDays active day${activeDays == 1 ? '' : 's'}',
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.textSecondary)),
              if (allDates.length <= 14 && allDates.isNotEmpty) ...[
                const SizedBox(height: 6),
                _DayStrip(allDates: allDates, dayValues: dayValues),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final sortedDayEntries =
        (dayValues.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    UserReportRowDetailsSheet.show(
      context,
      title: vehicleName,
      fields: [
        ('Vehicle', vehicleName),
        ('Total Distance', '${totalKm.toStringAsFixed(2)} km'),
        ('Active Days', '$activeDays'),
        ...sortedDayEntries
            .map((e) => (e.key, '${e.value.toStringAsFixed(2)} km')),
      ],
    );
  }
}

class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.allDates, required this.dayValues});
  final List<String> allDates;
  final Map<String, double> dayValues;

  @override
  Widget build(BuildContext context) {
    final maxVal = dayValues.isEmpty
        ? 1.0
        : dayValues.values.reduce((a, b) => a > b ? a : b);
    return Row(
      children: allDates.map((d) {
        final val = dayValues[d] ?? 0;
        final ratio = maxVal > 0 ? val / maxVal : 0.0;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Tooltip(
              message: '$d: ${val.toStringAsFixed(1)} km',
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  color: val > 0
                      ? OpenVtsColors.info.withValues(alpha: 0.15 + 0.7 * ratio)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                      color: OpenVtsColors.info.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
