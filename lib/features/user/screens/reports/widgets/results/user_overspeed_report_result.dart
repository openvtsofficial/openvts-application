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

class UserOverspeedReportResult extends ConsumerWidget {
  const UserOverspeedReportResult(
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
    final rows = state.rows.map(OverspeedRow.fromMap).toList();

    final violations = rows.length;
    final affected = rows.map((r) => r.vehicleName).toSet().length;
    final highest = rows.isEmpty
        ? 0.0
        : rows.map((r) => r.maxSpeedKmh).reduce((a, b) => a > b ? a : b);
    final totalDuration = rows.fold(0.0, (s, r) => s + r.durationSeconds);

    final kpis = [
      ReportKpi(label: 'Violations', value: '$violations'),
      ReportKpi(label: 'Affected Vehicles', value: '$affected'),
      ReportKpi(label: 'Highest Speed', value: uf.speed(highest)),
      ReportKpi(
          label: 'Total Duration', value: formatDurationSeconds(totalDuration)),
    ];

    // Donut: severity distribution
    final sevCount = <OverspeedSeverity, int>{};
    for (final r in rows) {
      final sev = getOverspeedSeverity(r.excessKmh);
      sevCount[sev] = (sevCount[sev] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserReportKpiRow(kpis: kpis),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (sevCount.isNotEmpty) ...[
          _SeverityDonut(sevCount: sevCount),
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
        ...rows.map((r) => _OverspeedRowCard(row: r, uf: uf)),
      ],
    );
  }
}

class _SeverityDonut extends StatelessWidget {
  const _SeverityDonut({required this.sevCount});
  final Map<OverspeedSeverity, int> sevCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const colors = {
      OverspeedSeverity.critical: Color(0xFF8A3333),
      OverspeedSeverity.high: Color(0xFF8A6522),
      OverspeedSeverity.medium: Color(0xFF435A6B),
      OverspeedSeverity.low: Color(0xFF2F6B4F)
    };
    const labels = {
      OverspeedSeverity.critical: 'Critical',
      OverspeedSeverity.high: 'High',
      OverspeedSeverity.medium: 'Medium',
      OverspeedSeverity.low: 'Low'
    };
    final sections = sevCount.entries
        .map((e) => PieChartSectionData(
            value: e.value.toDouble(),
            color: colors[e.key],
            title: labels[e.key] ?? '',
            radius: 48,
            titleStyle: OpenVtsTypography.meta
                .copyWith(fontSize: 9, color: OpenVtsColors.white)))
        .toList();
    return _ChartCard(
      title: 'Violations by Severity',
      isDark: isDark,
      child: SizedBox(
          height: 140,
          child: Row(children: [
            SizedBox(
                width: 140,
                child: PieChart(PieChartData(
                    sections: sections,
                    centerSpaceRadius: 30,
                    sectionsSpace: 2))),
            const SizedBox(width: OpenVtsSpacing.sm),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sevCount.entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: colors[e.key],
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 6),
                          Text('${labels[e.key]}: ${e.value}',
                              style: OpenVtsTypography.meta),
                        ]),
                      ))
                  .toList(),
            ),
          ])),
    );
  }
}

class _OverspeedRowCard extends StatelessWidget {
  const _OverspeedRowCard({required this.row, required this.uf});
  final OverspeedRow row;
  final dynamic uf;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sev = getOverspeedSeverity(row.excessKmh);
    final (sevColor, sevLabel) = switch (sev) {
      OverspeedSeverity.critical => (OpenVtsColors.error, 'Critical'),
      OverspeedSeverity.high => (OpenVtsColors.warning, 'High'),
      OverspeedSeverity.medium => (OpenVtsColors.info, 'Medium'),
      OverspeedSeverity.low => (OpenVtsColors.success, 'Low'),
    };
    final location = resolveOverspeedLocation(row.address, row.lat, row.lon);
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
                _Badge(label: sevLabel, color: sevColor),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.speed_rounded,
                    size: 13, color: OpenVtsColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                    '${row.maxSpeedKmh.toStringAsFixed(0)} km/h (limit ${row.configuredLimitKmh.toStringAsFixed(0)})',
                    style: OpenVtsTypography.body),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.access_time_rounded,
                    size: 13, color: OpenVtsColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                    row.startedAt.isNotEmpty ? row.startedAt : (row.date ?? ''),
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.textSecondary)),
                const Spacer(),
                Text(formatDurationSeconds(row.durationSeconds),
                    style: OpenVtsTypography.meta
                        .copyWith(color: OpenVtsColors.textSecondary)),
              ]),
              if (location != '-') ...[
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
                        child: Text(location,
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
      title: '${row.vehicleName} — Overspeed',
      fields: [
        ('Vehicle', row.vehicleName),
        if (row.date != null) ('Date', row.date!),
        ('Start Time', row.startedAt),
        if (row.endedAt != null) ('End Time', row.endedAt!),
        ('Duration', formatDurationSeconds(row.durationSeconds)),
        ('Observed Speed', '${row.maxSpeedKmh.toStringAsFixed(1)} km/h'),
        (
          'Configured Limit',
          '${row.configuredLimitKmh.toStringAsFixed(1)} km/h'
        ),
        ('Excess', '${row.excessKmh.toStringAsFixed(1)} km/h'),
        ('Address', resolveOverspeedLocation(row.address, row.lat, row.lon)),
        if (row.lat != null && row.lon != null)
          ('Coordinates', formatCoordinate(row.lat, row.lon)),
      ],
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

class _ChartCard extends StatelessWidget {
  const _ChartCard(
      {required this.title, required this.child, required this.isDark});
  final String title;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style:
                OpenVtsTypography.label.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: OpenVtsSpacing.sm),
        child,
      ]),
    );
  }
}
