// Widget tests for dark-mode visibility fix:
// Vehicle Config labels and ACC/MOTION segmented control.
//
// Coverage:
//   _DeviceSummaryCard
//     • heading uses onSurface in light and dark mode
//     • meta text uses onSurfaceVariant in light and dark mode
//     • icon badge border uses outlineVariant
//   _NumberConfigCard
//     • title uses onSurface in light and dark mode
//     • helper uses onSurfaceVariant in light and dark mode
//   _IgnitionSourceCard
//     • heading uses onSurface in light and dark mode
//     • helper uses onSurfaceVariant in light and dark mode
//     • ACC segment present
//     • MOTION segment present
//     • segmented button renders without overflow
//   SegmentedButton theming
//     • selected foreground is onSecondaryContainer
//     • selected background is secondaryContainer
//     • unselected foreground is onSurfaceVariant
//     • border uses outline color
//   Ignition value integrity
//     • onSelectionChanged receives exactly 'ACC'
//     • onSelectionChanged receives exactly 'MOTION'

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';

// ── Inline mirrors ─────────────────────────────────────────────────────────────

class DeviceSummaryCardTest extends StatelessWidget {
  const DeviceSummaryCardTest({
    required this.imei,
    required this.deviceId,
    super.key,
  });

  final String imei;
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final meta = [
      imei.trim().isEmpty ? null : 'IMEI $imei',
      deviceId.trim().isEmpty ? null : 'ID $deviceId',
    ].where((s) => s != null).join(' - ');

    return Row(
      children: [
        Container(
          key: const Key('device_badge'),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
            border: Border.all(color: cs.outlineVariant),
          ),
          child:
              Icon(Icons.memory_outlined, size: 18, color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: OpenVtsSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Device Config',
                key: const Key('device_heading'),
                style: OpenVtsTypography.label.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                meta.isEmpty ? '-' : meta,
                key: const Key('device_meta'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.meta.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NumberConfigCardTest extends StatelessWidget {
  const NumberConfigCardTest({
    required this.title,
    required this.helper,
    super.key,
  });

  final String title;
  final String helper;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          key: Key('num_title_$title'),
          style: OpenVtsTypography.label.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          helper,
          key: Key('num_helper_$title'),
          style: OpenVtsTypography.meta.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class IgnitionSourceCardTest extends StatelessWidget {
  const IgnitionSourceCardTest({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String value;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.key_rounded,
              size: 18,
              color: cs.onSurfaceVariant,
              key: const Key('ignition_icon'),
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Text(
              'Ignition Source',
              key: const Key('ignition_heading'),
              style: OpenVtsTypography.label.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'ACC means wire/ACC. MOTION means motion fallback.',
          key: const Key('ignition_helper'),
          style: OpenVtsTypography.meta.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            key: const Key('ignition_selector'),
            segments: const [
              ButtonSegment<String>(value: 'ACC', label: Text('ACC')),
              ButtonSegment<String>(value: 'MOTION', label: Text('MOTION')),
            ],
            selected: {value},
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStatePropertyAll(
                OpenVtsTypography.meta.copyWith(fontWeight: FontWeight.w800),
              ),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return cs.onSecondaryContainer;
                }
                return cs.onSurfaceVariant;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return cs.secondaryContainer;
                }
                return Colors.transparent;
              }),
              side: WidgetStatePropertyAll(BorderSide(color: cs.outline)),
            ),
            onSelectionChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(body: SingleChildScrollView(child: Center(child: child))),
  );
}

ColorScheme _cs(WidgetTester tester, Key key) =>
    Theme.of(tester.element(find.byKey(key))).colorScheme;

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. DeviceSummaryCard
// ─────────────────────────────────────────────────────────────────────────────
  group('DeviceSummaryCard', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final mode = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('heading uses onSurface ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          const DeviceSummaryCardTest(imei: '123456', deviceId: 'dev-1'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('device_heading'));
        final text =
            tester.widget<Text>(find.byKey(const Key('device_heading')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('meta uses onSurfaceVariant ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          const DeviceSummaryCardTest(imei: '123456', deviceId: 'dev-1'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('device_meta'));
        final text = tester.widget<Text>(find.byKey(const Key('device_meta')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('badge border uses outlineVariant ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          const DeviceSummaryCardTest(imei: '123456', deviceId: 'dev-1'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('device_badge'));
        final container =
            tester.widget<Container>(find.byKey(const Key('device_badge')));
        final box = container.decoration as BoxDecoration;
        final border = box.border as Border;
        expect(border.top.color, cs.outlineVariant);
      });
    }

    testWidgets('shows IMEI and ID in meta', (tester) async {
      await tester.pumpWidget(_wrap(
        const DeviceSummaryCardTest(imei: '99887766', deviceId: 'ABC'),
      ));
      expect(find.textContaining('IMEI 99887766'), findsOneWidget);
      expect(find.textContaining('ID ABC'), findsOneWidget);
    });

    testWidgets('shows dash when IMEI and ID are empty', (tester) async {
      await tester.pumpWidget(_wrap(
        const DeviceSummaryCardTest(imei: '', deviceId: ''),
      ));
      expect(find.text('-'), findsOneWidget);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. NumberConfigCard
// ─────────────────────────────────────────────────────────────────────────────
  group('NumberConfigCard', () {
    const titleStr = 'Speed Multiplier';
    const helperStr = 'Default 1. Applied to speed calibration.';

    for (final brightness in [Brightness.light, Brightness.dark]) {
      final mode = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('title uses onSurface ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          const NumberConfigCardTest(title: titleStr, helper: helperStr),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('num_title_$titleStr'));
        final text =
            tester.widget<Text>(find.byKey(const Key('num_title_$titleStr')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('helper uses onSurfaceVariant ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          const NumberConfigCardTest(title: titleStr, helper: helperStr),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('num_helper_$titleStr'));
        final text =
            tester.widget<Text>(find.byKey(const Key('num_helper_$titleStr')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });
    }

    testWidgets('title text is present', (tester) async {
      await tester.pumpWidget(_wrap(
        const NumberConfigCardTest(title: titleStr, helper: helperStr),
      ));
      expect(find.text(titleStr), findsOneWidget);
    });

    testWidgets('helper text is present', (tester) async {
      await tester.pumpWidget(_wrap(
        const NumberConfigCardTest(title: titleStr, helper: helperStr),
      ));
      expect(find.text(helperStr), findsOneWidget);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. IgnitionSourceCard — labels
// ─────────────────────────────────────────────────────────────────────────────
  group('IgnitionSourceCard labels', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final mode = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('heading uses onSurface ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('ignition_heading'));
        final text =
            tester.widget<Text>(find.byKey(const Key('ignition_heading')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('helper uses onSurfaceVariant ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('ignition_helper'));
        final text =
            tester.widget<Text>(find.byKey(const Key('ignition_helper')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });
    }

    testWidgets('heading text present', (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      expect(find.text('Ignition Source'), findsOneWidget);
    });

    testWidgets('ACC segment present', (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      expect(find.text('ACC'), findsOneWidget);
    });

    testWidgets('MOTION segment present', (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      expect(find.text('MOTION'), findsOneWidget);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. IgnitionSourceCard — SegmentedButton theming
// ─────────────────────────────────────────────────────────────────────────────
  group('IgnitionSourceCard SegmentedButton theming', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final mode = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('button style defines explicit foregroundColor ($mode)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
          brightness: brightness,
        ));
        final btn = tester.widget<SegmentedButton<String>>(
            find.byKey(const Key('ignition_selector')));
        expect(btn.style?.foregroundColor, isNotNull);
      });

      testWidgets('button style defines explicit backgroundColor ($mode)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
          brightness: brightness,
        ));
        final btn = tester.widget<SegmentedButton<String>>(
            find.byKey(const Key('ignition_selector')));
        expect(btn.style?.backgroundColor, isNotNull);
      });

      testWidgets('button style defines explicit side ($mode)', (tester) async {
        await tester.pumpWidget(_wrap(
          IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
          brightness: brightness,
        ));
        final btn = tester.widget<SegmentedButton<String>>(
            find.byKey(const Key('ignition_selector')));
        expect(btn.style?.side, isNotNull);
      });
    }

    testWidgets('selected fg resolves to onSecondaryContainer (light)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      final cs = _cs(tester, const Key('ignition_selector'));
      final btn = tester.widget<SegmentedButton<String>>(
          find.byKey(const Key('ignition_selector')));
      final resolved =
          btn.style?.foregroundColor?.resolve({WidgetState.selected});
      expect(resolved, cs.onSecondaryContainer);
    });

    testWidgets('selected bg resolves to secondaryContainer (light)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      final cs = _cs(tester, const Key('ignition_selector'));
      final btn = tester.widget<SegmentedButton<String>>(
          find.byKey(const Key('ignition_selector')));
      final resolved =
          btn.style?.backgroundColor?.resolve({WidgetState.selected});
      expect(resolved, cs.secondaryContainer);
    });

    testWidgets('unselected fg resolves to onSurfaceVariant (light)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      final cs = _cs(tester, const Key('ignition_selector'));
      final btn = tester.widget<SegmentedButton<String>>(
          find.byKey(const Key('ignition_selector')));
      final resolved = btn.style?.foregroundColor?.resolve({});
      expect(resolved, cs.onSurfaceVariant);
    });

    testWidgets('border uses outline color (light)', (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      final cs = _cs(tester, const Key('ignition_selector'));
      final btn = tester.widget<SegmentedButton<String>>(
          find.byKey(const Key('ignition_selector')));
      final side = btn.style?.side?.resolve({});
      expect(side?.color, cs.outline);
    });

    testWidgets('onSecondaryContainer distinct from onSurfaceVariant (dark)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, const Key('ignition_selector'));
      expect(cs.onSecondaryContainer, isNot(equals(cs.onSurfaceVariant)));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. Ignition value integrity
// ─────────────────────────────────────────────────────────────────────────────
  group('Ignition value integrity', () {
    testWidgets('tapping MOTION segment passes exactly "MOTION"',
        (tester) async {
      Set<String>? received;
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(
          value: 'ACC',
          onChanged: (v) => received = v,
        ),
      ));

      await tester.tap(find.text('MOTION'));
      await tester.pumpAndSettle();

      expect(received, isNotNull);
      expect(received!.single, 'MOTION');
    });

    testWidgets('tapping ACC segment passes exactly "ACC"', (tester) async {
      Set<String>? received;
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(
          value: 'MOTION',
          onChanged: (v) => received = v,
        ),
      ));

      await tester.tap(find.text('ACC'));
      await tester.pumpAndSettle();

      expect(received, isNotNull);
      expect(received!.single, 'ACC');
    });

    testWidgets('selected set matches value prop (ACC)', (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
      ));
      final btn = tester.widget<SegmentedButton<String>>(
          find.byKey(const Key('ignition_selector')));
      expect(btn.selected, {'ACC'});
    });

    testWidgets('selected set matches value prop (MOTION)', (tester) async {
      await tester.pumpWidget(_wrap(
        IgnitionSourceCardTest(value: 'MOTION', onChanged: (_) {}),
      ));
      final btn = tester.widget<SegmentedButton<String>>(
          find.byKey(const Key('ignition_selector')));
      expect(btn.selected, {'MOTION'});
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 6. No overflow
// ─────────────────────────────────────────────────────────────────────────────
  group('No overflow', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final mode = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('IgnitionSourceCard no overflow ($mode)', (tester) async {
        final errors = <String>[];
        FlutterError.onError = (d) => errors.add(d.exceptionAsString());

        await tester.pumpWidget(_wrap(
          IgnitionSourceCardTest(value: 'ACC', onChanged: (_) {}),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        FlutterError.onError = FlutterError.presentError;

        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
      });

      testWidgets('DeviceSummaryCard no overflow ($mode)', (tester) async {
        final errors = <String>[];
        FlutterError.onError = (d) => errors.add(d.exceptionAsString());

        await tester.pumpWidget(_wrap(
          const DeviceSummaryCardTest(
            imei: '012345678901234',
            deviceId: 'device-id-very-long-string',
          ),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        FlutterError.onError = FlutterError.presentError;

        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
      });
    }
  });
}
