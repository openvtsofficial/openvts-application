import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';

/// Generic row details bottom sheet.
/// [fields] is an ordered list of (label, value) pairs.
/// [rawPayload] shows a copyable raw payload section when non-null.
class UserReportRowDetailsSheet extends StatelessWidget {
  const UserReportRowDetailsSheet({
    required this.title,
    required this.fields,
    this.rawPayload,
    this.payloadTruncated = false,
    super.key,
  });

  final String title;
  final List<(String label, String value)> fields;
  final String? rawPayload;
  final bool payloadTruncated;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<(String label, String value)> fields,
    String? rawPayload,
    bool payloadTruncated = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(OpenVtsRadius.xl))),
      builder: (_) => UserReportRowDetailsSheet(
        title: title,
        fields: fields,
        rawPayload: rawPayload,
        payloadTruncated: payloadTruncated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.92,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: OpenVtsSpacing.sm),
          Center(
              child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: OpenVtsSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
            child: Row(
              children: [
                Expanded(
                    child: Text(title, style: OpenVtsTypography.titleSmall)),
                IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).maybePop()),
              ],
            ),
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(OpenVtsSpacing.md),
              children: [
                _FieldGrid(fields: fields),
                if (rawPayload != null && rawPayload!.isNotEmpty) ...[
                  const SizedBox(height: OpenVtsSpacing.md),
                  _RawPayloadSection(
                      payload: rawPayload!,
                      truncated: payloadTruncated,
                      isDark: isDark),
                ],
                const SizedBox(height: OpenVtsSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.fields});
  final List<(String, String)> fields;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nonEmpty =
        fields.where((f) => f.$2.isNotEmpty && f.$2 != '—').toList();
    if (nonEmpty.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: OpenVtsSpacing.sm,
      runSpacing: OpenVtsSpacing.sm,
      children: nonEmpty
          .map((f) => _FieldTile(label: f.$1, value: f.$2, isDark: isDark))
          .toList(),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile(
      {required this.label, required this.value, required this.isDark});
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? OpenVtsColors.darkSurface : OpenVtsColors.surface,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(
            color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: OpenVtsTypography.meta
                  .copyWith(color: OpenVtsColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style:
                  OpenVtsTypography.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RawPayloadSection extends StatefulWidget {
  const _RawPayloadSection(
      {required this.payload, required this.truncated, required this.isDark});
  final String payload;
  final bool truncated;
  final bool isDark;

  @override
  State<_RawPayloadSection> createState() => _RawPayloadSectionState();
}

class _RawPayloadSectionState extends State<_RawPayloadSection> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text('Raw Payload',
                    style: OpenVtsTypography.label
                        .copyWith(fontWeight: FontWeight.w700))),
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.payload));
                if (!mounted) return;
                setState(() => _copied = true);
                await Future<void>.delayed(const Duration(seconds: 2));
                if (mounted) setState(() => _copied = false);
              },
              icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: 14),
              label: Text(_copied ? 'Copied' : 'Copy',
                  style: OpenVtsTypography.meta),
            ),
          ],
        ),
        if (widget.truncated)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('— payload truncated for display —',
                style: OpenVtsTypography.meta
                    .copyWith(color: OpenVtsColors.textSecondary)),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A0A0A) : OpenVtsColors.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
            border: Border.all(
                color:
                    isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border),
          ),
          child: SelectableText(
            widget.payload,
            style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: isDark
                    ? OpenVtsColors.darkTextPrimary
                    : OpenVtsColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
