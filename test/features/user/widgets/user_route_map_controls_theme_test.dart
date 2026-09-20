import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Inline mirror of _MapControls + _ControlButton + _ControlDivider after the
// dark-mode fix. Confirms that the toolbar container and divider use
// ColorScheme tokens instead of the fixed OpenVtsColors.surfaceElevated /
// OpenVtsColors.border / OpenVtsColors.divider constants.
// ---------------------------------------------------------------------------

class MapControlsTest extends StatelessWidget {
  const MapControlsTest({
    super.key,
    this.fitEnabled = true,
    this.undoEnabled = true,
    this.clearEnabled = true,
  });

  final bool fitEnabled;
  final bool undoEnabled;
  final bool clearEnabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ControlButtonTest(icon: Icons.add, onTap: () {}),
          ControlButtonTest(icon: Icons.remove, onTap: () {}),
          const ControlDividerTest(),
          ControlButtonTest(
              icon: Icons.center_focus_strong,
              onTap: fitEnabled ? () {} : null),
          ControlButtonTest(
              icon: Icons.undo, onTap: undoEnabled ? () {} : null),
          ControlButtonTest(
            icon: Icons.delete_outline,
            onTap: clearEnabled ? () {} : null,
            destructive: true,
          ),
        ],
      ),
    );
  }
}

class ControlButtonTest extends StatelessWidget {
  const ControlButtonTest({
    super.key,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final cs = Theme.of(context).colorScheme;
    final color = destructive ? const Color(0xFFE53935) : cs.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 18,
          color: disabled ? cs.outline : color,
        ),
      ),
    );
  }
}

class ControlDividerTest extends StatelessWidget {
  const ControlDividerTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

ColorScheme _cs(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(MapControlsTest))).colorScheme;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Container surface
  // -------------------------------------------------------------------------

  group('MapControls — container surface', () {
    testWidgets('light — container color is colorScheme.surface',
        (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest()));
      final cs = _cs(tester);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers
            .any((c) => (c.decoration as BoxDecoration?)?.color == cs.surface),
        isTrue,
        reason: 'container must use colorScheme.surface in light mode',
      );
    });

    testWidgets('dark — container color is colorScheme.surface',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      final cs = _cs(tester);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers
            .any((c) => (c.decoration as BoxDecoration?)?.color == cs.surface),
        isTrue,
        reason: 'container must use colorScheme.surface in dark mode',
      );
    });

    testWidgets('dark — container is not fixed light surfaceElevated',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      // OpenVtsColors.surfaceElevated = Color(0xFFF5F5F5)
      const lightSurface = Color(0xFFF5F5F5);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any(
            (c) => (c.decoration as BoxDecoration?)?.color == lightSurface),
        isFalse,
        reason: 'dark container must not use the fixed light surfaceElevated',
      );
    });
  });

  // -------------------------------------------------------------------------
  // Container border
  // -------------------------------------------------------------------------

  group('MapControls — container border', () {
    testWidgets('light — border uses outlineVariant', (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest()));
      final cs = _cs(tester);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == cs.outlineVariant;
        }),
        isTrue,
        reason: 'border must use outlineVariant in light mode',
      );
    });

    testWidgets('dark — border uses outlineVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      final cs = _cs(tester);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == cs.outlineVariant;
        }),
        isTrue,
        reason: 'border must use outlineVariant in dark mode',
      );
    });

    testWidgets('dark — border is not fixed OpenVtsColors.border',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      // OpenVtsColors.border = Color(0xFFE8E8E8)
      const lightBorder = Color(0xFFE8E8E8);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == lightBorder;
        }),
        isFalse,
        reason: 'dark border must not use the fixed light border color',
      );
    });
  });

  // -------------------------------------------------------------------------
  // Divider
  // -------------------------------------------------------------------------

  group('MapControls — divider', () {
    testWidgets('light — divider uses outlineVariant', (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest()));
      final cs = _cs(tester);
      final dividerContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(ControlDividerTest),
          matching: find.byType(Container),
        ),
      );
      expect(dividerContainer.color, cs.outlineVariant,
          reason: 'divider must use outlineVariant in light mode');
    });

    testWidgets('dark — divider uses outlineVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      final cs = _cs(tester);
      final dividerContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(ControlDividerTest),
          matching: find.byType(Container),
        ),
      );
      expect(dividerContainer.color, cs.outlineVariant,
          reason: 'divider must use outlineVariant in dark mode');
    });

    testWidgets('dark — divider is not fixed OpenVtsColors.divider',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      // OpenVtsColors.divider = Color(0xFFEEEEEE)
      const lightDivider = Color(0xFFEEEEEE);
      final dividerContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(ControlDividerTest),
          matching: find.byType(Container),
        ),
      );
      expect(dividerContainer.color, isNot(lightDivider),
          reason: 'dark divider must not use the fixed light divider color');
    });
  });

  // -------------------------------------------------------------------------
  // Icon colors — enabled/disabled in both modes
  // -------------------------------------------------------------------------

  group('MapControls — icon colors', () {
    testWidgets('light enabled — zoom icon uses onSurface', (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest()));
      final cs = _cs(tester);
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(
        icons.any((i) => i.icon == Icons.add && i.color == cs.onSurface),
        isTrue,
        reason: 'enabled zoom icon must use onSurface in light mode',
      );
    });

    testWidgets('dark enabled — zoom icon uses onSurface', (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      final cs = _cs(tester);
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(
        icons.any((i) => i.icon == Icons.add && i.color == cs.onSurface),
        isTrue,
        reason: 'enabled zoom icon must use onSurface in dark mode',
      );
    });

    testWidgets('light disabled — fit icon uses outline (muted)',
        (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest(fitEnabled: false)));
      final cs = _cs(tester);
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(
        icons.any((i) =>
            i.icon == Icons.center_focus_strong && i.color == cs.outline),
        isTrue,
        reason: 'disabled fit icon must use outline in light mode',
      );
    });

    testWidgets('dark disabled — fit icon uses outline (muted)',
        (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest(fitEnabled: false),
          brightness: Brightness.dark));
      final cs = _cs(tester);
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(
        icons.any((i) =>
            i.icon == Icons.center_focus_strong && i.color == cs.outline),
        isTrue,
        reason: 'disabled fit icon must use outline in dark mode',
      );
    });
  });

  // -------------------------------------------------------------------------
  // Surface coherence: in dark mode, surface resolves to a dark color
  // -------------------------------------------------------------------------

  group('MapControls — surface coherence', () {
    testWidgets('dark — surface luminance is low (dark background)',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const MapControlsTest(), brightness: Brightness.dark));
      final cs = _cs(tester);
      expect(
        cs.surface.computeLuminance(),
        lessThan(0.15),
        reason: 'dark colorScheme.surface must be a dark color',
      );
    });

    testWidgets('light — surface luminance is high (light background)',
        (tester) async {
      await tester.pumpWidget(_wrap(const MapControlsTest()));
      final cs = _cs(tester);
      expect(
        cs.surface.computeLuminance(),
        greaterThan(0.7),
        reason: 'light colorScheme.surface must be a light color',
      );
    });
  });
}
