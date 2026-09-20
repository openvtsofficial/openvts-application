import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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

class UserDistanceReportResult extends ConsumerWidget {
  const UserDistanceReportResult(
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
    final rows = state.rows.map(DistanceRow.fromMap).toList();

    final totalDist = rows.fold(0.0, (s, r) => s + r.distanceKm);
    final totalEh = rows.fold(0.0, (s, r) => s + r.engineHoursSeconds);
    final activeVehicles = rows.map((r) => r.vehicleName).toSet().length;
    final avgDist = activeVehicles > 0 ? totalDist / activeVehicles : 0.0;

    final kpis = [
      ReportKpi(label: 'Total Distance', value: uf.distance(totalDist)),
      ReportKpi(label: 'Engine Hours', value: formatDurationSeconds(totalEh)),
      ReportKpi(label: 'Active Vehicles', value: '$activeVehicles'),
      ReportKpi(label: 'Avg Distance', value: uf.distance(avgDist)),
    ];

    // Chart: top 8 vehicles by distance
    final byVehicle = <String, double>{};
    for (final r in rows) {
      byVehicle[r.vehicleName] = (byVehicle[r.vehicleName] ?? 0) + r.distanceKm;
    }
    final chartEntries = (byVehicle.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(8)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (chartEntries.isNotEmpty) ...[
          _DistanceBarChart(entries: chartEntries, uf: uf),
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
        ...rows.map((r) => _DistanceRowCard(row: r, uf: uf)),
      ],
    );
  }
}

class _DistanceBarChart extends StatelessWidget {
  const _DistanceBarChart({required this.entries, required this.uf});
  final List<MapEntry<String, double>> entries;
  final UnitFormatter uf;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark
        ? OpenVtsColors.darkTextPrimary.withValues(alpha: 0.9)
        : OpenVtsColors.brandInk.withValues(alpha: 0.85);
    return _ChartCard(
      title: 'Distance by Vehicle (top ${entries.length})',
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY:
                (entries.map((e) => e.value).reduce((a, b) => a > b ? a : b)) *
                    1.15,
            barGroups: entries
                .asMap()
                .entries
                .map((e) => BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                          toY: e.value.value,
                          color: barColor,
                          width: 14,
                          borderRadius: BorderRadius.circular(3))
                    ]))
                .toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      getTitlesWidget: (v, meta) => Text(uf.distance(v),
                          style:
                              OpenVtsTypography.meta.copyWith(fontSize: 9)))),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, meta) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= entries.length)
                          return const SizedBox.shrink();
                        final name = entries[idx].key;
                        final short =
                            name.length > 8 ? '${name.substring(0, 7)}…' : name;
                        return Padding(
                            padding: const EdgeInsets.only(top: 4),
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
          ),
        ),
      ),
    );
  }
}

class _DistanceRowCard extends StatelessWidget {
  const _DistanceRowCard({required this.row, required this.uf});
  final DistanceRow row;
  final UnitFormatter uf;

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
                    child: Text(row.vehicleName,
                        style: OpenVtsTypography.label
                            .copyWith(fontWeight: FontWeight.w700))),
                Text(uf.distance(row.distanceKm),
                    style: OpenVtsTypography.label
                        .copyWith(fontWeight: FontWeight.w700)),
              ]),
              if (row.date.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(row.date,
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.textSecondary)),
              ],
              if (row.startAddress != null || row.endAddress != null) ...[
                const SizedBox(height: 4),
                _AddressRow(
                    start: row.startAddress,
                    end: row.endAddress,
                    startLat: row.startLat,
                    startLon: row.startLon,
                    endLat: row.endLat,
                    endLon: row.endLon),
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
      title: '${row.vehicleName} — ${row.date}',
      fields: [
        ('Vehicle', row.vehicleName),
        if (row.vehicleNumber.isNotEmpty) ('Vehicle #', row.vehicleNumber),
        ('Date', row.date),
        if (row.firstMovement != null) ('First Movement', row.firstMovement!),
        if (row.lastMovement != null) ('Last Movement', row.lastMovement!),
        ('Distance', UnitFormatterHelper.distance(row.distanceKm)),
        ('Engine Hours', formatDurationSeconds(row.engineHoursSeconds)),
        if (row.startAddress != null) ('Start Address', row.startAddress!),
        if (row.endAddress != null) ('End Address', row.endAddress!),
        if (row.startLat != null && row.startLon != null)
          ('Start Location', formatCoordinate(row.startLat, row.startLon)),
        if (row.endLat != null && row.endLon != null)
          ('End Location', formatCoordinate(row.endLat, row.endLon)),
        if (row.odometerStartKm != null)
          (
            'Odometer Start',
            UnitFormatterHelper.distance(row.odometerStartKm!)
          ),
        if (row.odometerEndKm != null)
          ('Odometer End', UnitFormatterHelper.distance(row.odometerEndKm!)),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow(
      {this.start,
      this.end,
      this.startLat,
      this.startLon,
      this.endLat,
      this.endLon});
  final String? start;
  final String? end;
  final double? startLat;
  final double? startLon;
  final double? endLat;
  final double? endLon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (start != null)
          Expanded(
              child: _LocationLink(
                  label: start!,
                  lat: startLat,
                  lon: startLon,
                  icon: Icons.trip_origin_rounded)),
        if (start != null && end != null)
          const Icon(Icons.arrow_forward_rounded, size: 12),
        if (end != null)
          Expanded(
              child: _LocationLink(
                  label: end!,
                  lat: endLat,
                  lon: endLon,
                  icon: Icons.location_on_rounded)),
      ],
    );
  }
}

class _LocationLink extends StatelessWidget {
  const _LocationLink(
      {required this.label, required this.icon, this.lat, this.lon});
  final String label;
  final IconData icon;
  final double? lat;
  final double? lon;

  @override
  Widget build(BuildContext context) {
    final uri = geoUri(lat, lon);
    return GestureDetector(
      onTap: uri == null ? null : () => launchUrl(Uri.parse(uri)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: OpenVtsColors.textSecondary),
        const SizedBox(width: 2),
        Flexible(
            child: Text(label,
                style: OpenVtsTypography.meta.copyWith(
                    color: uri != null
                        ? OpenVtsColors.info
                        : OpenVtsColors.textSecondary),
                overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;

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
          Text(title,
              style: OpenVtsTypography.label
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: OpenVtsSpacing.sm),
          child,
        ],
      ),
    );
  }
}

// Stateless unit format helper for detail sheets (no ref available)
class UnitFormatterHelper {
  static String distance(double km) => '${km.toStringAsFixed(2)} km';
  static String speed(double kph) => '${kph.toStringAsFixed(1)} km/h';
}
