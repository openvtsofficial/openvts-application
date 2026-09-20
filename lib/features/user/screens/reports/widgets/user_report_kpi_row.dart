import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';

/// A row of KPI cards. Lays 2 per row on narrow screens, 4 on wide.
class UserReportKpiRow extends StatelessWidget {
  const UserReportKpiRow({required this.kpis, super.key});

  final List<ReportKpi> kpis;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossCount = width >= 600 ? 4 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: OpenVtsSpacing.sm,
        crossAxisSpacing: OpenVtsSpacing.sm,
        childAspectRatio: width >= 600 ? 2.0 : 1.8,
      ),
      itemCount: kpis.length,
      itemBuilder: (_, i) => _KpiCard(kpi: kpis[i]),
    );
  }
}

class ReportKpi {
  const ReportKpi({required this.label, required this.value, this.caption});
  final String label;
  final String value;
  final String? caption;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.kpi});
  final ReportKpi kpi;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.sm, vertical: OpenVtsSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(kpi.label,
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(kpi.value,
              style: OpenVtsTypography.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (kpi.caption != null) ...[
            const SizedBox(height: 2),
            Text(kpi.caption!,
                style: OpenVtsTypography.meta
                    .copyWith(color: OpenVtsColors.textTertiary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}
