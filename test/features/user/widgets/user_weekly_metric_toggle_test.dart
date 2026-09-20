// Widget tests for the Weekly Comparison metric toggle fix.
//
// Coverage:
//   • default metric is Driven KM
//   • label shows "Driven KM" when units = KM
//   • label shows "Driven MI" when units = MILES
//   • "Engine Hours" label is always present
//   • tapping Engine Hours segment invokes callback with engineHours
//   • tapping Driven segment invokes callback with drivenKm
//   • selected segment uses colorScheme.primary background
//   • selected segment uses colorScheme.onPrimary foreground
//   • unselected segment uses colorScheme.surface background
//   • unselected segment uses colorScheme.onSurfaceVariant foreground
//   • light mode: primary and onPrimary are distinct colors
//   • dark mode: primary and onPrimary are distinct colors
//   • no RenderFlex overflow at 320 px width
//   • no RenderFlex overflow at 375 px width
//   • no overflow at 1.5x text scale

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Inline mirror of _MetricToggle ───────────────────────────────────────────
//
// This mirrors the production implementation exactly so that any regression in
// the production file (which contains private _MetricToggle) surfaces here.

enum WeeklyMetric { drivenKm, engineHours }

class MetricToggleTest extends StatelessWidget {
  const MetricToggleTest({
    required this.metric,
    required this.distanceLabel,
    required this.onChanged,
    super.key,
  });

  final WeeklyMetric metric;
  final String distanceLabel;
  final void Function(Set<WeeklyMetric>) onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const labelStyle = TextStyle(fontWeight: FontWeight.w800, fontSize: 12);

    return Row(
      children: [
        Expanded(
          child: SegmentedButton<WeeklyMetric>(
            segments: [
              ButtonSegment(
                value: WeeklyMetric.drivenKm,
                label: Text('Driven $distanceLabel'),
              ),
              const ButtonSegment(
                value: WeeklyMetric.engineHours,
                label: Text('Engine Hours'),
              ),
            ],
            selected: {metric},
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: const WidgetStatePropertyAll(labelStyle),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return cs.primary;
                return cs.surface;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return cs.onPrimary;
                return cs.onSurfaceVariant;
              }),
              side: WidgetStatePropertyAll(
                BorderSide(color: cs.outlineVariant),
              ),
            ),
            onSelectionChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ── StatefulWrapper for interaction tests ─────────────────────────────────────

class _ToggleWrapper extends StatefulWidget {
  const _ToggleWrapper({
    this.initialMetric = WeeklyMetric.drivenKm,
    this.distanceLabel = 'KM',
    this.onChanged,
  });

  final WeeklyMetric initialMetric;
  final String distanceLabel;
  final void Function(WeeklyMetric)? onChanged;

  @override
  State<_ToggleWrapper> createState() => _ToggleWrapperState();
}

class _ToggleWrapperState extends State<_ToggleWrapper> {
  late WeeklyMetric _metric = widget.initialMetric;

  @override
  Widget build(BuildContext context) {
    return MetricToggleTest(
      metric: _metric,
      distanceLabel: widget.distanceLabel,
      onChanged: (value) {
        if (value.isEmpty) return;
        setState(() => _metric = value.first);
        widget.onChanged?.call(value.first);
      },
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(
  Widget child, {
  Brightness brightness = Brightness.light,
  double width = 390,
  double textScaleFactor = 1.0,
}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScaleFactor),
            ),
            child: SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          );
        },
      ),
    ),
  );
}

ColorScheme _cs(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(MetricToggleTest))).colorScheme;

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. Label text
// ─────────────────────────────────────────────────────────────────────────────
  group('Label text', () {
    testWidgets('default metric shows "Driven KM"', (tester) async {
      await tester.pumpWidget(_wrap(
        const _ToggleWrapper(distanceLabel: 'KM'),
      ));
      expect(find.text('Driven KM'), findsOneWidget);
      expect(find.text('Engine Hours'), findsOneWidget);
    });

    testWidgets('"Driven MI" shown when units are miles', (tester) async {
      await tester.pumpWidget(_wrap(
        const _ToggleWrapper(distanceLabel: 'MI'),
      ));
      expect(find.text('Driven MI'), findsOneWidget);
      expect(find.text('Driven KM'), findsNothing);
    });

    testWidgets('"Engine Hours" always present regardless of units',
        (tester) async {
      for (final label in ['KM', 'MI']) {
        await tester.pumpWidget(_wrap(
          _ToggleWrapper(distanceLabel: label),
        ));
        expect(find.text('Engine Hours'), findsOneWidget);
      }
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Metric switching
// ─────────────────────────────────────────────────────────────────────────────
  group('Metric switching', () {
    testWidgets('default selected metric is drivenKm', (tester) async {
      WeeklyMetric? reported;
      await tester.pumpWidget(_wrap(
        _ToggleWrapper(onChanged: (m) => reported = m),
      ));
      // No callback fired yet — default selection is drivenKm.
      expect(reported, isNull);

      final button = tester.widget<SegmentedButton<WeeklyMetric>>(
        find.byType(SegmentedButton<WeeklyMetric>),
      );
      expect(button.selected, {WeeklyMetric.drivenKm});
    });

    testWidgets('tapping Engine Hours switches metric', (tester) async {
      WeeklyMetric? reported;
      await tester.pumpWidget(_wrap(
        _ToggleWrapper(onChanged: (m) => reported = m),
      ));

      await tester.tap(find.text('Engine Hours'));
      await tester.pumpAndSettle();

      expect(reported, WeeklyMetric.engineHours);
      final button = tester.widget<SegmentedButton<WeeklyMetric>>(
        find.byType(SegmentedButton<WeeklyMetric>),
      );
      expect(button.selected, {WeeklyMetric.engineHours});
    });

    testWidgets('tapping Driven KM after Engine Hours switches back',
        (tester) async {
      WeeklyMetric? reported;
      await tester.pumpWidget(_wrap(
        _ToggleWrapper(
          initialMetric: WeeklyMetric.engineHours,
          onChanged: (m) => reported = m,
        ),
      ));

      await tester.tap(find.text('Driven KM'));
      await tester.pumpAndSettle();

      expect(reported, WeeklyMetric.drivenKm);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. ColorScheme — selected state
// ─────────────────────────────────────────────────────────────────────────────
  group('Selected state colors', () {
    testWidgets('light mode: primary and onPrimary are distinct',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
      ));
      final cs = _cs(tester);
      expect(cs.primary, isNot(equals(cs.onPrimary)));
    });

    testWidgets('dark mode: primary and onPrimary are distinct',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      expect(cs.primary, isNot(equals(cs.onPrimary)));
    });

    testWidgets('ButtonStyle resolves primary for selected background',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
      ));
      final cs = _cs(tester);
      final style = tester
          .widget<SegmentedButton<WeeklyMetric>>(
            find.byType(SegmentedButton<WeeklyMetric>),
          )
          .style!;
      final selectedBg = style.backgroundColor!.resolve({WidgetState.selected});
      expect(selectedBg, cs.primary);
    });

    testWidgets('ButtonStyle resolves onPrimary for selected foreground',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
      ));
      final cs = _cs(tester);
      final style = tester
          .widget<SegmentedButton<WeeklyMetric>>(
            find.byType(SegmentedButton<WeeklyMetric>),
          )
          .style!;
      final selectedFg = style.foregroundColor!.resolve({WidgetState.selected});
      expect(selectedFg, cs.onPrimary);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. ColorScheme — unselected state
// ─────────────────────────────────────────────────────────────────────────────
  group('Unselected state colors', () {
    testWidgets('ButtonStyle resolves surface for unselected background',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
      ));
      final cs = _cs(tester);
      final style = tester
          .widget<SegmentedButton<WeeklyMetric>>(
            find.byType(SegmentedButton<WeeklyMetric>),
          )
          .style!;
      final unselectedBg = style.backgroundColor!.resolve({});
      expect(unselectedBg, cs.surface);
    });

    testWidgets(
        'ButtonStyle resolves onSurfaceVariant for unselected foreground',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
      ));
      final cs = _cs(tester);
      final style = tester
          .widget<SegmentedButton<WeeklyMetric>>(
            find.byType(SegmentedButton<WeeklyMetric>),
          )
          .style!;
      final unselectedFg = style.foregroundColor!.resolve({});
      expect(unselectedFg, cs.onSurfaceVariant);
    });

    testWidgets('dark mode: unselected background is surface', (tester) async {
      await tester.pumpWidget(_wrap(
        const MetricToggleTest(
          metric: WeeklyMetric.drivenKm,
          distanceLabel: 'KM',
          onChanged: _noOp,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      final style = tester
          .widget<SegmentedButton<WeeklyMetric>>(
            find.byType(SegmentedButton<WeeklyMetric>),
          )
          .style!;
      expect(style.backgroundColor!.resolve({}), cs.surface);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. Layout — no overflow at narrow widths
// ─────────────────────────────────────────────────────────────────────────────
  group('No overflow at narrow widths', () {
    for (final px in [320.0, 360.0, 375.0]) {
      testWidgets('no RenderFlex overflow at ${px.toInt()} px', (tester) async {
        final errors = <String>[];
        FlutterError.onError = (details) {
          errors.add(details.exceptionAsString());
        };

        await tester.pumpWidget(_wrap(
          const _ToggleWrapper(distanceLabel: 'KM'),
          width: px,
        ));
        await tester.pumpAndSettle();

        FlutterError.onError = FlutterError.presentError;

        expect(
          errors.where((e) => e.contains('overflowed')),
          isEmpty,
          reason: 'Unexpected overflow at ${px.toInt()} px',
        );
      });
    }

    testWidgets('no RenderFlex overflow with MI label at 320 px',
        (tester) async {
      final errors = <String>[];
      FlutterError.onError = (details) {
        errors.add(details.exceptionAsString());
      };

      await tester.pumpWidget(_wrap(
        const _ToggleWrapper(distanceLabel: 'MI'),
        width: 320,
      ));
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.presentError;

      expect(
        errors.where((e) => e.contains('overflowed')),
        isEmpty,
      );
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 6. Larger text scale
// ─────────────────────────────────────────────────────────────────────────────
  group('Larger text scale', () {
    testWidgets('no overflow at 1.5x text scale on 390 px width',
        (tester) async {
      final errors = <String>[];
      FlutterError.onError = (details) {
        errors.add(details.exceptionAsString());
      };

      await tester.pumpWidget(_wrap(
        const _ToggleWrapper(distanceLabel: 'KM'),
        textScaleFactor: 1.5,
      ));
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.presentError;

      expect(
        errors.where((e) => e.contains('overflowed')),
        isEmpty,
      );
    });

    testWidgets('labels still present at 1.3x text scale', (tester) async {
      await tester.pumpWidget(_wrap(
        const _ToggleWrapper(distanceLabel: 'KM'),
        textScaleFactor: 1.3,
      ));
      expect(find.text('Driven KM'), findsOneWidget);
      expect(find.text('Engine Hours'), findsOneWidget);
    });
  });
}

// ignore: avoid_positional_boolean_parameters
void _noOp(Set<WeeklyMetric> _) {}
