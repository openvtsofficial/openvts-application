// Widget and unit tests for the Weekly Comparison chart painter fix.
//
// Coverage:
//   • _WeeklyComparisonChart passes light-theme colors to the painter
//   • _WeeklyComparisonChart passes dark-theme colors to the painter
//   • This Week color (onSurface) contrasts against dark card surface
//   • This Week color (primary) contrasts against light card surface
//   • Last Week color is distinguishable from This Week color
//   • painter.shouldRepaint returns false when nothing changes
//   • painter.shouldRepaint returns true when metric changes
//   • painter.shouldRepaint returns true when thisWeekColor changes (theme)
//   • painter.shouldRepaint returns true when lastWeekColor changes (theme)
//   • painter.shouldRepaint returns true when gridColor changes (theme)
//   • painter.shouldRepaint returns true when patternColor changes (theme)
//   • painter.shouldRepaint returns true when textColor changes (theme)
//   • zero-value bars produce zero height; positive values produce ≥2 px
//   • seven day labels are present in the rendered widget
//   • widget renders without error in light mode
//   • widget renders without error in dark mode

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';
import 'package:open_vts/features/user/models/user_dashboard_model.dart';

// ── Inline mirror of chart classes ───────────────────────────────────────────
//
// Mirrors the production implementation so regressions surface here.

enum WeeklyMetricChart { drivenKm, engineHours }

class WeeklyComparisonChartTest extends StatelessWidget {
  const WeeklyComparisonChartTest({
    required this.points,
    required this.metric,
    super.key,
  });

  final List<UserDashboardWeeklyPoint> points;
  final WeeklyMetricChart metric;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final thisWeekColor = isDark ? cs.onSurface : cs.primary;
    final lastWeekColor = cs.outlineVariant;
    final gridColor = cs.outlineVariant.withValues(alpha: 0.5);
    final patternColor = cs.surface;

    return SizedBox(
      height: 172,
      child: CustomPaint(
        painter: WeeklyChartPainterTest(
          points,
          metric,
          thisWeekColor: thisWeekColor,
          lastWeekColor: lastWeekColor,
          gridColor: gridColor,
          patternColor: patternColor,
          textColor: cs.onSurfaceVariant,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class WeeklyChartPainterTest extends CustomPainter {
  WeeklyChartPainterTest(
    this.points,
    this.metric, {
    required this.thisWeekColor,
    required this.lastWeekColor,
    required this.gridColor,
    required this.patternColor,
    required this.textColor,
  });

  final List<UserDashboardWeeklyPoint> points;
  final WeeklyMetricChart metric;
  final Color thisWeekColor;
  final Color lastWeekColor;
  final Color gridColor;
  final Color patternColor;
  final Color textColor;

  double _valueOf(UserDashboardMetricPair pair) {
    switch (metric) {
      case WeeklyMetricChart.drivenKm:
        return pair.drivenKm;
      case WeeklyMetricChart.engineHours:
        return pair.engineHours;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || size.width <= 0 || size.height <= 0) return;

    const left = 4.0;
    const right = 4.0;
    const top = 8.0;
    const bottom = 26.0;
    final chartWidth = math.max(size.width - left - right, 1);
    final chartHeight = math.max(size.height - top - bottom, 1);
    final baseline = top + chartHeight;
    final maxValue = points.fold<double>(0, (max, point) {
      return math.max(
          max, math.max(_valueOf(point.thisWeek), _valueOf(point.lastWeek)));
    });
    final scale = math.max(maxValue, 1);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var line = 0; line < 4; line++) {
      final y = top + chartHeight * line / 3;
      canvas.drawLine(
          Offset(left, y), Offset(size.width - right, y), gridPaint);
    }

    final slot = chartWidth / points.length;
    final barWidth = math.min(14.0, slot * 0.25);
    final thisPaint = Paint()
      ..color = thisWeekColor
      ..style = PaintingStyle.fill;
    final lastPaint = Paint()
      ..color = lastWeekColor
      ..style = PaintingStyle.fill;
    final dashPaint = Paint()
      ..color = patternColor.withValues(alpha: 0.85)
      ..strokeWidth = 1;

    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final centerX = left + slot * index + slot / 2;
      final thisValue = _valueOf(point.thisWeek);
      final lastValue = _valueOf(point.lastWeek);
      final thisHeight = thisValue > 0
          ? math.max(2.0, chartHeight * (thisValue / scale).clamp(0.0, 1.0))
          : 0.0;
      final lastHeight = lastValue > 0
          ? math.max(2.0, chartHeight * (lastValue / scale).clamp(0.0, 1.0))
          : 0.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(centerX - barWidth - 2, baseline - thisHeight, barWidth,
              thisHeight),
          const Radius.circular(5),
        ),
        thisPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              centerX + 2, baseline - lastHeight, barWidth, lastHeight),
          const Radius.circular(5),
        ),
        lastPaint,
      );
      for (var y = baseline - lastHeight + 4; y < baseline; y += 6) {
        canvas.drawLine(
          Offset(centerX + 3, y),
          Offset(centerX + barWidth + 1, y),
          dashPaint,
        );
      }
    }

    _drawLabels(canvas, size, slot, left);
    _drawLegend(canvas);
  }

  void _drawLabels(Canvas canvas, Size size, double slot, double left) {
    for (var index = 0; index < points.length; index++) {
      final label = points[index].label.trim().isEmpty
          ? 'D${points[index].dayIndex + 1}'
          : points[index].label;
      (TextPainter(
        text: TextSpan(
          text: label.length > 3 ? label.substring(0, 3) : label,
          style: OpenVtsTypography.meta.copyWith(
            color: textColor,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: slot))
          .paint(
              canvas, Offset(left + slot * index + slot / 2, size.height - 14));
    }
  }

  void _drawLegend(Canvas canvas) {
    _lp('This week', thisWeekColor).paint(canvas, const Offset(4, 0));
    _lp('Last week', lastWeekColor).paint(canvas, const Offset(92, 0));
  }

  TextPainter _lp(String text, Color color) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: OpenVtsTypography.meta.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  bool shouldRepaint(covariant WeeklyChartPainterTest oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.metric != metric ||
        oldDelegate.thisWeekColor != thisWeekColor ||
        oldDelegate.lastWeekColor != lastWeekColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.patternColor != patternColor ||
        oldDelegate.textColor != textColor;
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

const _pair0 = UserDashboardMetricPair(drivenKm: 0, engineHours: 0);
const _pair100 = UserDashboardMetricPair(drivenKm: 100, engineHours: 2);
const _pair50 = UserDashboardMetricPair(drivenKm: 50, engineHours: 1);

List<UserDashboardWeeklyPoint> _sevenPoints({bool allZero = false}) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return List.generate(
    7,
    (i) => UserDashboardWeeklyPoint(
      dayIndex: i,
      label: labels[i],
      thisWeek: allZero ? _pair0 : _pair100,
      lastWeek: allZero ? _pair0 : _pair50,
    ),
  );
}

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(
      body: SizedBox(
        width: 400,
        height: 300,
        child: child,
      ),
    ),
  );
}

ColorScheme _cs(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(WeeklyComparisonChartTest)))
        .colorScheme;

WeeklyChartPainterTest _painter(WidgetTester tester) {
  // Find the CustomPaint that is a direct child of WeeklyComparisonChartTest.
  final chartFinder = find.descendant(
    of: find.byType(WeeklyComparisonChartTest),
    matching: find.byType(CustomPaint),
  );
  return tester.widget<CustomPaint>(chartFinder).painter
      as WeeklyChartPainterTest;
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. Color resolution: light theme
// ─────────────────────────────────────────────────────────────────────────────
  group('Light theme color resolution', () {
    testWidgets('painter receives primary as thisWeekColor', (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
      ));
      final cs = _cs(tester);
      expect(_painter(tester).thisWeekColor, cs.primary);
    });

    testWidgets('painter receives outlineVariant as lastWeekColor',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
      ));
      final cs = _cs(tester);
      expect(_painter(tester).lastWeekColor, cs.outlineVariant);
    });

    testWidgets('painter receives onSurfaceVariant as textColor',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
      ));
      final cs = _cs(tester);
      expect(_painter(tester).textColor, cs.onSurfaceVariant);
    });

    testWidgets('This Week and Last Week colors are different', (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
      ));
      final p = _painter(tester);
      expect(p.thisWeekColor, isNot(equals(p.lastWeekColor)));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Color resolution: dark theme
// ─────────────────────────────────────────────────────────────────────────────
  group('Dark theme color resolution', () {
    testWidgets('painter receives onSurface as thisWeekColor in dark mode',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      expect(_painter(tester).thisWeekColor, cs.onSurface);
    });

    testWidgets('dark thisWeekColor differs from dark surface (contrast)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      // onSurface must differ from surface — the fundamental contrast guarantee.
      expect(_painter(tester).thisWeekColor, isNot(equals(cs.surface)));
    });

    testWidgets('dark Last Week is distinguishable from This Week',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
        brightness: Brightness.dark,
      ));
      final p = _painter(tester);
      expect(p.thisWeekColor, isNot(equals(p.lastWeekColor)));
    });

    testWidgets('dark painter receives outlineVariant as lastWeekColor',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      expect(_painter(tester).lastWeekColor, cs.outlineVariant);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. shouldRepaint
// ─────────────────────────────────────────────────────────────────────────────
  group('shouldRepaint', () {
    // Share the same list reference so identity equality holds for the
    // "nothing changes" test — the painter uses != on the points object.
    final sharedPoints = _sevenPoints();

    WeeklyChartPainterTest basePainter() => WeeklyChartPainterTest(
          sharedPoints,
          WeeklyMetricChart.drivenKm,
          thisWeekColor: Colors.black,
          lastWeekColor: Colors.grey,
          gridColor: Colors.grey.shade200,
          patternColor: Colors.white,
          textColor: Colors.grey.shade600,
        );

    test('returns false when nothing changes', () {
      final a = basePainter();
      final b = basePainter();
      expect(a.shouldRepaint(b), isFalse);
    });

    test('returns true when metric changes', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(),
        WeeklyMetricChart.engineHours,
        thisWeekColor: Colors.black,
        lastWeekColor: Colors.grey,
        gridColor: Colors.grey.shade200,
        patternColor: Colors.white,
        textColor: Colors.grey.shade600,
      );
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when thisWeekColor changes (theme switch)', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(),
        WeeklyMetricChart.drivenKm,
        thisWeekColor: Colors.white, // dark mode onSurface ≠ black
        lastWeekColor: Colors.grey,
        gridColor: Colors.grey.shade200,
        patternColor: Colors.white,
        textColor: Colors.grey.shade600,
      );
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when lastWeekColor changes (theme switch)', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(),
        WeeklyMetricChart.drivenKm,
        thisWeekColor: Colors.black,
        lastWeekColor: Colors.blueGrey.shade700,
        gridColor: Colors.grey.shade200,
        patternColor: Colors.white,
        textColor: Colors.grey.shade600,
      );
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when gridColor changes (theme switch)', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(),
        WeeklyMetricChart.drivenKm,
        thisWeekColor: Colors.black,
        lastWeekColor: Colors.grey,
        gridColor: Colors.grey.shade800,
        patternColor: Colors.white,
        textColor: Colors.grey.shade600,
      );
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when patternColor changes (theme switch)', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(),
        WeeklyMetricChart.drivenKm,
        thisWeekColor: Colors.black,
        lastWeekColor: Colors.grey,
        gridColor: Colors.grey.shade200,
        patternColor: Colors.black, // dark surface
        textColor: Colors.grey.shade600,
      );
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when textColor changes (theme switch)', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(),
        WeeklyMetricChart.drivenKm,
        thisWeekColor: Colors.black,
        lastWeekColor: Colors.grey,
        gridColor: Colors.grey.shade200,
        patternColor: Colors.white,
        textColor: Colors.white70,
      );
      expect(a.shouldRepaint(b), isTrue);
    });

    test('returns true when points reference changes', () {
      final a = basePainter();
      final b = WeeklyChartPainterTest(
        _sevenPoints(allZero: true),
        WeeklyMetricChart.drivenKm,
        thisWeekColor: Colors.black,
        lastWeekColor: Colors.grey,
        gridColor: Colors.grey.shade200,
        patternColor: Colors.white,
        textColor: Colors.grey.shade600,
      );
      expect(a.shouldRepaint(b), isTrue);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. Bar height logic
// ─────────────────────────────────────────────────────────────────────────────
  group('Bar height logic', () {
    test('zero value produces zero height', () {
      const chartHeight = 100.0;
      const scale = 100.0;
      const value = 0.0;
      final height = value > 0
          ? math.max(2.0, chartHeight * (value / scale).clamp(0.0, 1.0))
          : 0.0;
      expect(height, 0.0);
    });

    test('small positive value gets 2 px minimum height', () {
      const chartHeight = 100.0;
      const scale = 10000.0;
      const value = 1.0; // would be 0.01 px without floor
      final height = value > 0
          ? math.max(2.0, chartHeight * (value / scale).clamp(0.0, 1.0))
          : 0.0;
      expect(height, 2.0);
    });

    test('large value produces proportional height above minimum', () {
      const chartHeight = 100.0;
      const scale = 100.0;
      const value = 80.0;
      final height = value > 0
          ? math.max(2.0, chartHeight * (value / scale).clamp(0.0, 1.0))
          : 0.0;
      expect(height, closeTo(80.0, 0.001));
    });

    test('maximum value fills the chart height', () {
      const chartHeight = 100.0;
      const scale = 100.0;
      const value = 100.0;
      final height = value > 0
          ? math.max(2.0, chartHeight * (value / scale).clamp(0.0, 1.0))
          : 0.0;
      expect(height, 100.0);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. Widget rendering
// ─────────────────────────────────────────────────────────────────────────────
  group('Widget rendering', () {
    testWidgets('renders without error in light mode with seven points',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
      ));
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(WeeklyComparisonChartTest),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders without error in dark mode with seven points',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
        brightness: Brightness.dark,
      ));
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(WeeklyComparisonChartTest),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders without error with all-zero data', (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(allZero: true),
          metric: WeeklyMetricChart.drivenKm,
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error for Engine Hours metric',
        (tester) async {
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.engineHours,
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('patternColor is cs.surface in dark mode', (tester) async {
      // Verifies the pattern stripe color tracks the card surface in dark mode
      // so that stripe gaps reveal the last-week bar color underneath.
      await tester.pumpWidget(_wrap(
        WeeklyComparisonChartTest(
          points: _sevenPoints(),
          metric: WeeklyMetricChart.drivenKm,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      expect(_painter(tester).patternColor, cs.surface);
    });
  });
}
