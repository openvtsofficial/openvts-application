import 'package:flutter/material.dart';

import '../../core/theme/open_vts_colors.dart';
import '../../core/theme/open_vts_radius.dart';
import '../../core/theme/open_vts_spacing.dart';

class OpenVtsCard extends StatelessWidget {
  const OpenVtsCard({
    required this.child,
    this.padding = const EdgeInsets.all(OpenVtsSpacing.md),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = Padding(padding: padding, child: child);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OpenVtsRadius.lg),
        side: BorderSide(
          color: isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: onTap == null ? content : InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
