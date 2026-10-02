import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../models/user_report_model.dart';

/// Toolbar shown above the result list: count, generated-at, warning, load-more.
class UserReportResultToolbar extends StatelessWidget {
  const UserReportResultToolbar({
    required this.rowCount,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.reportKey,
    this.generatedAt,
    this.warning,
    this.source,
    this.loadMoreError,
    this.onExport,
    super.key,
  });

  final int rowCount;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final UserReportKey reportKey;
  final DateTime? generatedAt;
  final String? warning;
  final String? source;
  final String? loadMoreError;
  final ValueChanged<String>? onExport;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$rowCount result${rowCount == 1 ? '' : 's'}',
                      style: OpenVtsTypography.label
                          .copyWith(fontWeight: FontWeight.w700)),
                  if (generatedAt != null)
                    Text(
                      'Generated at ${_formatTime(generatedAt!)}',
                      style: OpenVtsTypography.meta
                          .copyWith(color: OpenVtsColors.textSecondary),
                    ),
                ],
              ),
            ),
            if (onExport != null)
              IconButton(
                tooltip: 'Export',
                icon: const Icon(Icons.download_rounded, size: 20),
                onPressed: () => ReportExportSheet.show(
                  context,
                  reportKey: reportKey,
                  onFormat: onExport!,
                ),
              ),
          ],
        ),
        if (source != null && source!.isNotEmpty) ...[
          const SizedBox(height: 4),
          _MetaChip(label: source!, isDark: isDark),
        ],
        if (warning != null && warning!.isNotEmpty) ...[
          const SizedBox(height: OpenVtsSpacing.xs),
          _WarningBanner(message: warning!),
        ],
        if (loadMoreError != null) ...[
          const SizedBox(height: OpenVtsSpacing.xs),
          _ErrorBanner(message: loadMoreError!),
        ],
        if (hasMore) ...[
          const SizedBox(height: OpenVtsSpacing.sm),
          isLoadingMore
              ? const Center(
                  child: Padding(
                      padding: EdgeInsets.all(8), child: OpenVtsLoader()))
              : OpenVtsButton(
                  label: 'Load more',
                  onPressed: onLoadMore,
                  variant: OpenVtsButtonVariant.secondary),
        ],
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.xs, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Text(label,
          style: OpenVtsTypography.meta
              .copyWith(color: OpenVtsColors.textSecondary)),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: OpenVtsColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border:
            Border.all(color: OpenVtsColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 16, color: OpenVtsColors.warning),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
              child: Text(message,
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.warning))),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: OpenVtsColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: OpenVtsColors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              size: 16, color: OpenVtsColors.error),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
              child: Text(message,
                  style: OpenVtsTypography.meta
                      .copyWith(color: OpenVtsColors.error))),
        ],
      ),
    );
  }
}

/// Export format picker bottom sheet
class ReportExportSheet extends StatelessWidget {
  const ReportExportSheet(
      {required this.reportKey, required this.onFormat, super.key});

  final UserReportKey reportKey;
  final ValueChanged<String> onFormat;

  static Future<void> show(BuildContext context,
      {required UserReportKey reportKey,
      required ValueChanged<String> onFormat}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl))),
      builder: (_) =>
          ReportExportSheet(reportKey: reportKey, onFormat: onFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    const formats = [
      ('csv', Icons.table_view_rounded, 'CSV'),
      ('xlsx', Icons.grid_on_rounded, 'Excel (XLSX)'),
      ('json', Icons.data_object_rounded, 'JSON'),
      ('pdf', Icons.picture_as_pdf_rounded, 'PDF'),
      ('html', Icons.html_rounded, 'HTML'),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: OpenVtsSpacing.sm),
          Center(
              child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: OpenVtsSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: Row(
              children: [
                Expanded(
                    child: Text('Export ${reportKey.label} Report',
                        style: OpenVtsTypography.titleSmall)),
                IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).maybePop()),
              ],
            ),
          ),
          const Divider(height: 1),
          ...formats.map((f) => ListTile(
                leading: Icon(f.$2),
                title: Text(f.$3, style: OpenVtsTypography.body),
                onTap: () {
                  Navigator.of(context).maybePop();
                  onFormat(f.$1);
                },
              )),
          const SizedBox(height: OpenVtsSpacing.sm),
        ],
      ),
    );
  }
}
