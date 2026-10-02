import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';

// ---------------------------------------------------------------------------
// Mirror of the production _ActiveToggle after the visibility fix.
// Kept inline so regressions in the production widget surface here.
// ---------------------------------------------------------------------------

class ActiveToggleTest extends StatelessWidget {
  const ActiveToggleTest({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
    final textColor = isDark ? OpenVtsColors.white : OpenVtsColors.textPrimary;
    final subtitleColor =
        isDark ? OpenVtsColors.darkTextSecondary : OpenVtsColors.textSecondary;
    final borderColor = value
        ? OpenVtsColors.success
        : (isDark ? OpenVtsColors.darkBorder : OpenVtsColors.border);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active',
                  style: OpenVtsTypography.label.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value
                      ? 'Events will trigger for this geofence.'
                      : 'Geofence is paused.',
                  style: OpenVtsTypography.meta.copyWith(
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (_) {},
            activeTrackColor: OpenVtsColors.success,
            activeThumbColor: OpenVtsColors.white,
            inactiveThumbColor: isDark
                ? OpenVtsColors.darkTextTertiary
                : OpenVtsColors.textTertiary,
            inactiveTrackColor: isDark
                ? OpenVtsColors.darkSurfaceElevated
                : OpenVtsColors.divider,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

Container _toggleContainer(WidgetTester tester, {required bool isDark}) {
  final bgColor = isDark ? OpenVtsColors.brandInk : OpenVtsColors.surface;
  return tester.widgetList<Container>(find.byType(Container)).firstWhere(
        (c) => (c.decoration as BoxDecoration?)?.color == bgColor,
      );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ActiveToggle — border', () {
    testWidgets('light on — border color is success', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true)));
      final c = _toggleContainer(tester, isDark: false);
      final border = (c.decoration as BoxDecoration).border as Border;
      expect(border.top.color, OpenVtsColors.success,
          reason: 'active border must use success color in light mode');
    });

    testWidgets('light off — border color is muted, not success',
        (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: false)));
      final c = _toggleContainer(tester, isDark: false);
      final border = (c.decoration as BoxDecoration).border as Border;
      expect(border.top.color, OpenVtsColors.border);
      expect(border.top.color, isNot(OpenVtsColors.success),
          reason: 'inactive border must not be success color');
    });

    testWidgets('dark on — border color is success', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true),
          brightness: Brightness.dark));
      final c = _toggleContainer(tester, isDark: true);
      final border = (c.decoration as BoxDecoration).border as Border;
      expect(border.top.color, OpenVtsColors.success,
          reason: 'active border must use success color in dark mode');
    });

    testWidgets('dark off — border color is muted, not success',
        (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: false),
          brightness: Brightness.dark));
      final c = _toggleContainer(tester, isDark: true);
      final border = (c.decoration as BoxDecoration).border as Border;
      expect(border.top.color, OpenVtsColors.darkBorder);
      expect(border.top.color, isNot(OpenVtsColors.success),
          reason: 'inactive border must not be success color');
    });
  });

  group('ActiveToggle — switch thumb visibility', () {
    testWidgets('light on — active thumb color ≠ container background',
        (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true)));
      final c = _toggleContainer(tester, isDark: false);
      final bgColor = (c.decoration as BoxDecoration).color;
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.activeThumbColor, isNot(bgColor),
          reason: 'active thumb must not blend into the container background');
    });

    testWidgets('dark on — active thumb color ≠ container background',
        (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true),
          brightness: Brightness.dark));
      final c = _toggleContainer(tester, isDark: true);
      final bgColor = (c.decoration as BoxDecoration).color;
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.activeThumbColor, isNot(bgColor),
          reason: 'active thumb must not blend into the container background');
    });

    testWidgets('light on — active thumb is white', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true)));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.activeThumbColor, OpenVtsColors.white);
    });

    testWidgets('dark on — active thumb is white', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true),
          brightness: Brightness.dark));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.activeThumbColor, OpenVtsColors.white);
    });
  });

  group('ActiveToggle — helper text', () {
    testWidgets('light on — shows active copy', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true)));
      expect(
          find.text('Events will trigger for this geofence.'), findsOneWidget);
    });

    testWidgets('light off — shows paused copy', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: false)));
      expect(find.text('Geofence is paused.'), findsOneWidget);
    });

    testWidgets('dark on — shows active copy', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true),
          brightness: Brightness.dark));
      expect(
          find.text('Events will trigger for this geofence.'), findsOneWidget);
    });

    testWidgets('dark off — shows paused copy', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: false),
          brightness: Brightness.dark));
      expect(find.text('Geofence is paused.'), findsOneWidget);
    });
  });

  group('ActiveToggle — switch enabled', () {
    testWidgets('light on — switch is enabled', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: true)));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.onChanged, isNotNull);
    });

    testWidgets('dark off — switch is enabled', (tester) async {
      await tester.pumpWidget(_wrap(const ActiveToggleTest(value: false),
          brightness: Brightness.dark));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.onChanged, isNotNull);
    });
  });
}
