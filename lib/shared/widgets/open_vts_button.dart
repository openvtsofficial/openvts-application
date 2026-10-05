import 'package:flutter/material.dart';

import '../../core/theme/open_vts_radius.dart';
import '../../core/theme/open_vts_typography.dart';

class OpenVtsButton extends StatelessWidget {
  const OpenVtsButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = OpenVtsButtonVariant.primary,
    this.trailingIcon,
    this.height = 48,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final OpenVtsButtonVariant variant;
  final IconData? trailingIcon;

  /// Preferred minimum height. Labels remain free to grow with text scaling.
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = variant == OpenVtsButtonVariant.primary;
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(48, height < 48 ? 48 : height),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 0,
        backgroundColor: primary ? scheme.primary : scheme.surface,
        foregroundColor: primary ? scheme.onPrimary : scheme.onSurface,
        disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.08),
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.button),
          side: primary
              ? BorderSide.none
              : BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: OpenVtsTypography.label,
            ),
          ),
          if (isLoading || trailingIcon != null) ...[
            const SizedBox(width: 8),
            if (isLoading)
              SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              Icon(trailingIcon, size: 18),
          ],
        ],
      ),
    );
  }
}

enum OpenVtsButtonVariant { primary, secondary }
