import 'package:flutter/material.dart';

import 'open_vts_colors.dart';
import 'open_vts_radius.dart';
import 'open_vts_typography.dart';

class OpenVtsTheme {
  const OpenVtsTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(useMaterial3: true, brightness: brightness);
    final foreground = isDark
        ? OpenVtsColors.darkTextPrimary
        : OpenVtsColors.textPrimary;
    final background = isDark
        ? OpenVtsColors.darkBackground
        : OpenVtsColors.background;
    final border = isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border;
    final scheme = isDark
        ? const ColorScheme.dark(
            primary: OpenVtsColors.white,
            onPrimary: OpenVtsColors.brandInk,
            secondary: OpenVtsColors.darkTextSecondary,
            surface: OpenVtsColors.darkSurface,
            onSurface: OpenVtsColors.darkTextPrimary,
            onSurfaceVariant: OpenVtsColors.darkTextSecondary,
            outline: OpenVtsColors.darkTextSecondary,
            outlineVariant: OpenVtsColors.darkBorder,
            error: Color(0xFFFF8A80),
          )
        : const ColorScheme.light(
            primary: OpenVtsColors.brandInk,
            onPrimary: OpenVtsColors.white,
            secondary: OpenVtsColors.brandInkSoft,
            surface: OpenVtsColors.surfaceElevated,
            onSurface: OpenVtsColors.textPrimary,
            onSurfaceVariant: OpenVtsColors.textSecondary,
            outline: OpenVtsColors.textSecondary,
            outlineVariant: OpenVtsColors.border,
            error: OpenVtsColors.error,
          );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(OpenVtsRadius.button),
    );
    final sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(OpenVtsRadius.xl),
    );
    final textTheme = base.textTheme.apply(
      fontFamily: OpenVtsTypography.primaryFontFamily,
      fontFamilyFallback: OpenVtsTypography.fontFallback,
      bodyColor: foreground,
      displayColor: foreground,
    );
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      shape: WidgetStatePropertyAll(buttonShape),
      textStyle: const WidgetStatePropertyAll(OpenVtsTypography.label),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: scheme,
      textTheme: textTheme,
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: OpenVtsTypography.titleSmall.copyWith(
          color: foreground,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: inputBorder(border),
        enabledBorder: inputBorder(border),
        disabledBorder: inputBorder(border),
        focusedBorder: inputBorder(scheme.primary, 1.5),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 1.5),
        errorMaxLines: 4,
        helperMaxLines: 4,
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: buttonStyle.copyWith(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? scheme.onSurface.withValues(alpha: 0.08)
                : scheme.primary,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? scheme.onSurface.withValues(alpha: 0.38)
                : scheme.onPrimary,
          ),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: buttonStyle.copyWith(
          side: WidgetStatePropertyAll(BorderSide(color: border)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(style: buttonStyle),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: sheetShape,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        constraints: const BoxConstraints(maxWidth: 640),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(OpenVtsRadius.xl),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        ),
      ),
      listTileTheme: ListTileThemeData(iconColor: scheme.onSurfaceVariant),
    );
  }
}
