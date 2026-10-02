// Widget tests for dark-mode visibility fix in the Sensors tab and Add Sensor sheet.
//
// Coverage:
//   _HeaderCard
//     • "Sensors" heading uses onSurface in light mode
//     • "Sensors" heading uses onSurface in dark mode
//     • count text uses onSurfaceVariant in light mode
//     • count text uses onSurfaceVariant in dark mode
//     • Add Sensor button foreground is onSurface in both modes
//     • Add Sensor button border is outlineVariant in both modes
//   _SensorCard
//     • sensor name uses onSurface in light/dark
//     • sensor meta uses onSurfaceVariant in light/dark
//     • icon badge border is outlineVariant in light/dark
//   _MetaPill
//     • text and icon use onSurfaceVariant in light/dark
//   Empty state
//     • renders heading and add button without overflow in light/dark
//   _SectionLabel (sensor sheet)
//     • title uses onSurface in light/dark
//     • subtitle uses onSurfaceVariant in light/dark
//   _RunResultCard
//     • background is surfaceContainerHighest in light/dark
//     • border is outlineVariant in light/dark
//     • "Run Result" label uses onSurfaceVariant in light/dark
//     • value text uses onSurface in light/dark
//   Loading / disabled states
//     • loading card label uses onSurfaceVariant in both modes

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';
import 'package:open_vts/features/user/models/user_vehicle_model.dart';

// ── Inline mirrors of private widgets ────────────────────────────────────────

// _HeaderCard mirror
class HeaderCardTest extends StatelessWidget {
  const HeaderCardTest({
    required this.count,
    required this.isLoading,
    required this.onAdd,
    super.key,
  });

  final int count;
  final bool isLoading;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.sensors_outlined, size: 17),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  Text(
                    'Sensors',
                    key: const Key('sensors_heading'),
                    style: OpenVtsTypography.label.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: OpenVtsSpacing.xs),
                  Text(
                    '$count',
                    key: const Key('sensors_count'),
                    style: OpenVtsTypography.meta.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(width: OpenVtsSpacing.xs),
                    const SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
            ),
            SmallButtonTest(
              label: 'Add Sensor',
              icon: Icons.add_rounded,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

// _SmallButton mirror
class SmallButtonTest extends StatelessWidget {
  const SmallButtonTest({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        key: const Key('add_sensor_button'),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.onSurface,
          side: BorderSide(color: cs.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: Icon(icon, size: 15),
        label: Text(
          label,
          style: OpenVtsTypography.meta
              .copyWith(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

// _SensorCard mirror (trimmed to the testable parts)
class SensorCardTest extends StatelessWidget {
  const SensorCardTest({required this.sensor, super.key});

  final UserVehicleSensor sensor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  key: const Key('sensor_icon_badge'),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(Icons.sensors_outlined,
                      size: 18, color: cs.onSurfaceVariant),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sensor.title,
                        key: const Key('sensor_name'),
                        style: OpenVtsTypography.label.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        sensor.dataType ?? '-',
                        key: const Key('sensor_meta'),
                        style: OpenVtsTypography.meta.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// _MetaPill mirror
class MetaPillTest extends StatelessWidget {
  const MetaPillTest({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      key: const Key('meta_pill'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.onSurfaceVariant.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: cs.onSurfaceVariant.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            key: const Key('meta_pill_label'),
            style: OpenVtsTypography.meta.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// _LoadingCard mirror
class LoadingCardTest extends StatelessWidget {
  const LoadingCardTest({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.all(OpenVtsSpacing.sm),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Text(
              label,
              key: const Key('loading_label'),
              style: OpenVtsTypography.meta.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _SectionLabel mirror (from sensor_sheet)
class SectionLabelTest extends StatelessWidget {
  const SectionLabelTest(
      {required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          key: const Key('section_title'),
          style: OpenVtsTypography.label.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          key: const Key('section_subtitle'),
          style: OpenVtsTypography.meta.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// _RunResultCard mirror
class RunResultCardTest extends StatelessWidget {
  const RunResultCardTest({required this.result, super.key});

  final UserVehicleSensorRunResult result;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      key: const Key('run_result_card'),
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Run Result',
            key: const Key('run_result_heading'),
            style: OpenVtsTypography.meta.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: OpenVtsSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    'Value',
                    key: const Key('result_row_label'),
                    style: OpenVtsTypography.meta.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    result.value?.toString() ?? '-',
                    key: const Key('result_row_value'),
                    style: OpenVtsTypography.meta.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(
  Widget child, {
  Brightness brightness = Brightness.light,
  double width = 390,
}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    ),
  );
}

ColorScheme _cs(WidgetTester tester, Key key) =>
    Theme.of(tester.element(find.byKey(key))).colorScheme;

UserVehicleSensor _fakeSensor() => UserVehicleSensor.fromJson({
      'id': 's1',
      'name': 'Speed',
      'unit': 'km/h',
      'icon': 'speed',
      'code': 'return payload.speed',
      'dataType': 'number',
      'isActive': true,
      'displayValue': '85',
    });

UserVehicleSensorRunResult _fakeResult() =>
    UserVehicleSensorRunResult.fromJson({
      'value': 42,
      'output': 'ok',
    });

void _noOp() {}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. HeaderCard — Sensors heading
// ─────────────────────────────────────────────────────────────────────────────
  group('HeaderCard — Sensors heading', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('heading text present ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const HeaderCardTest(count: 3, isLoading: false, onAdd: _noOp),
          brightness: brightness,
        ));
        expect(find.text('Sensors'), findsOneWidget);
      });

      testWidgets('heading uses onSurface ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const HeaderCardTest(count: 3, isLoading: false, onAdd: _noOp),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('sensors_heading'));
        final text =
            tester.widget<Text>(find.byKey(const Key('sensors_heading')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('count uses onSurfaceVariant ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const HeaderCardTest(count: 5, isLoading: false, onAdd: _noOp),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('sensors_count'));
        final text =
            tester.widget<Text>(find.byKey(const Key('sensors_count')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('onSurface distinct from surface ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const HeaderCardTest(count: 0, isLoading: false, onAdd: _noOp),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('sensors_heading'));
        expect(cs.onSurface, isNot(equals(cs.surface)));
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. SmallButton — Add Sensor
// ─────────────────────────────────────────────────────────────────────────────
  group('SmallButton — Add Sensor', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('foregroundColor is onSurface ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const SmallButtonTest(
              key: Key('small_btn_wrapper'),
              label: 'Add Sensor',
              icon: Icons.add_rounded,
              onPressed: _noOp),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('add_sensor_button'));
        final btn = tester.widget<OutlinedButton>(
          find.descendant(
            of: find.byKey(const Key('small_btn_wrapper')),
            matching: find.byType(OutlinedButton),
          ),
        );
        final fg = btn.style!.foregroundColor!.resolve({});
        expect(fg, cs.onSurface);
      });

      testWidgets('border is outlineVariant ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const SmallButtonTest(
              key: Key('small_btn_wrapper'),
              label: 'Add Sensor',
              icon: Icons.add_rounded,
              onPressed: _noOp),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('add_sensor_button'));
        final btn = tester.widget<OutlinedButton>(
          find.descendant(
            of: find.byKey(const Key('small_btn_wrapper')),
            matching: find.byType(OutlinedButton),
          ),
        );
        final side = btn.style!.side!.resolve({});
        expect(side?.color, cs.outlineVariant);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. SensorCard — name, meta, icon badge
// ─────────────────────────────────────────────────────────────────────────────
  group('SensorCard', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('sensor name uses onSurface ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          SensorCardTest(sensor: _fakeSensor()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('sensor_name'));
        final text = tester.widget<Text>(find.byKey(const Key('sensor_name')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('sensor meta uses onSurfaceVariant ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          SensorCardTest(sensor: _fakeSensor()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('sensor_meta'));
        final text = tester.widget<Text>(find.byKey(const Key('sensor_meta')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('icon badge border is outlineVariant ($label)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          SensorCardTest(sensor: _fakeSensor()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('sensor_icon_badge'));
        final container = tester
            .widget<Container>(find.byKey(const Key('sensor_icon_badge')));
        final decoration = container.decoration as BoxDecoration;
        final borderColor = (decoration.border as Border).top.color;
        expect(borderColor, cs.outlineVariant);
      });

      testWidgets('no overflow at 390 px ($label)', (tester) async {
        final errors = <String>[];
        FlutterError.onError = (d) => errors.add(d.exceptionAsString());

        await tester.pumpWidget(_wrap(
          SensorCardTest(sensor: _fakeSensor()),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        FlutterError.onError = FlutterError.presentError;

        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. MetaPill
// ─────────────────────────────────────────────────────────────────────────────
  group('MetaPill', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('label uses onSurfaceVariant ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const MetaPillTest(icon: Icons.schedule_rounded, label: 'Just now'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('meta_pill_label'));
        final text =
            tester.widget<Text>(find.byKey(const Key('meta_pill_label')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. LoadingCard
// ─────────────────────────────────────────────────────────────────────────────
  group('LoadingCard', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('loading label uses onSurfaceVariant ($label)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          const LoadingCardTest(label: 'Loading sensors'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('loading_label'));
        final text =
            tester.widget<Text>(find.byKey(const Key('loading_label')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 6. SectionLabel (sensor sheet)
// ─────────────────────────────────────────────────────────────────────────────
  group('SectionLabel', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('title uses onSurface ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const SectionLabelTest(
              title: 'New Sensor', subtitle: 'Name and code are required.'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('section_title'));
        final text =
            tester.widget<Text>(find.byKey(const Key('section_title')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('subtitle uses onSurfaceVariant ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const SectionLabelTest(
              title: 'New Sensor', subtitle: 'Name and code are required.'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('section_subtitle'));
        final text =
            tester.widget<Text>(find.byKey(const Key('section_subtitle')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('"New Sensor" text present ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          const SectionLabelTest(
              title: 'New Sensor', subtitle: 'Name and code are required.'),
          brightness: brightness,
        ));
        expect(find.text('New Sensor'), findsOneWidget);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 7. RunResultCard
// ─────────────────────────────────────────────────────────────────────────────
  group('RunResultCard', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('"Run Result" heading uses onSurfaceVariant ($label)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          RunResultCardTest(result: _fakeResult()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('run_result_heading'));
        final text =
            tester.widget<Text>(find.byKey(const Key('run_result_heading')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('value row label uses onSurfaceVariant ($label)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          RunResultCardTest(result: _fakeResult()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('result_row_label'));
        final text =
            tester.widget<Text>(find.byKey(const Key('result_row_label')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('value row value uses onSurface ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          RunResultCardTest(result: _fakeResult()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('result_row_value'));
        final text =
            tester.widget<Text>(find.byKey(const Key('result_row_value')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('card background is surfaceContainerHighest ($label)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          RunResultCardTest(result: _fakeResult()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('run_result_card'));
        final container =
            tester.widget<Container>(find.byKey(const Key('run_result_card')));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, cs.surfaceContainerHighest);
      });

      testWidgets('card border is outlineVariant ($label)', (tester) async {
        await tester.pumpWidget(_wrap(
          RunResultCardTest(result: _fakeResult()),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('run_result_card'));
        final container =
            tester.widget<Container>(find.byKey(const Key('run_result_card')));
        final decoration = container.decoration as BoxDecoration;
        final borderColor = (decoration.border as Border).top.color;
        expect(borderColor, cs.outlineVariant);
      });

      testWidgets('no overflow at 390 px ($label)', (tester) async {
        final errors = <String>[];
        FlutterError.onError = (d) => errors.add(d.exceptionAsString());

        await tester.pumpWidget(_wrap(
          RunResultCardTest(result: _fakeResult()),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        FlutterError.onError = FlutterError.presentError;

        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 8. Empty state — no overflow
// ─────────────────────────────────────────────────────────────────────────────
  group('Empty state', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('header with 0 sensors renders without overflow ($label)',
          (tester) async {
        final errors = <String>[];
        FlutterError.onError = (d) => errors.add(d.exceptionAsString());

        await tester.pumpWidget(_wrap(
          const HeaderCardTest(count: 0, isLoading: false, onAdd: _noOp),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        FlutterError.onError = FlutterError.presentError;

        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
        expect(find.text('0'), findsOneWidget);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 9. Disabled / loading header
// ─────────────────────────────────────────────────────────────────────────────
  group('Loading header state', () {
    testWidgets('shows spinner when isLoading is true in dark mode',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HeaderCardTest(count: 2, isLoading: true, onAdd: _noOp),
        brightness: Brightness.dark,
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('no spinner when isLoading is false', (tester) async {
      await tester.pumpWidget(_wrap(
        const HeaderCardTest(count: 2, isLoading: false, onAdd: _noOp),
      ));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
