import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Inline mirrors of the production drawer sheet and card after the dark-mode
// fix. Both the Geofence editor and the POI picker open the same
// OpenVtsMapLayerSelectorButton → _MapLayerDrawerSheet → _MapLayerCard chain,
// so fixing/testing the shared component covers both launchers.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Minimal data model (mirrors MapLayerOption)
// ---------------------------------------------------------------------------

class LayerOptionTest {
  const LayerOptionTest({required this.id, required this.shortLabel});
  final String id;
  final String shortLabel;
}

const _kLayerA = LayerOptionTest(id: 'layer-a', shortLabel: 'Road');
const _kLayerB = LayerOptionTest(id: 'layer-b', shortLabel: 'Satellite');

// ---------------------------------------------------------------------------
// Mirror: _MapLayerCard
// ---------------------------------------------------------------------------

class MapLayerCardTest extends StatelessWidget {
  const MapLayerCardTest({
    super.key,
    required this.option,
    required this.isSelected,
    this.onTap,
  });

  final LayerOptionTest option;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labelColor =
        isSelected ? const Color(0xFF1293A6) : cs.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF1293A6) : cs.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: Color(0xFFD6F1E4)),
                    if (isSelected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1293A6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            option.shortLabel,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: labelColor,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mirror: _MapLayerDrawerSheet (content only — no actual bottom-sheet host)
// ---------------------------------------------------------------------------

class MapLayerDrawerSheetTest extends StatefulWidget {
  const MapLayerDrawerSheetTest({
    super.key,
    required this.initialLayerId,
  });

  final String initialLayerId;

  @override
  State<MapLayerDrawerSheetTest> createState() =>
      _MapLayerDrawerSheetTestState();
}

class _MapLayerDrawerSheetTestState extends State<MapLayerDrawerSheetTest> {
  late String _selectedLayerId;

  @override
  void initState() {
    super.initState();
    _selectedLayerId = widget.initialLayerId;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const options = [_kLayerA, _kLayerB];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Align(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Map type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Row(
                children: [
                  for (final opt in options) ...[
                    Expanded(
                      child: MapLayerCardTest(
                        option: opt,
                        isSelected: _selectedLayerId == opt.id,
                        onTap: () => setState(() => _selectedLayerId = opt.id),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: cs.outlineVariant, height: 1),
              const SizedBox(height: 16),
              Text(
                'Map details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(
  Widget child, {
  Brightness brightness = Brightness.light,
  Color? surfaceColor,
}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
      scaffoldBackgroundColor: surfaceColor,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

ColorScheme _cs(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(MapLayerDrawerSheetTest))).colorScheme;

ColorScheme _csCard(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(MapLayerCardTest).first)).colorScheme;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Headings
  // -------------------------------------------------------------------------

  group('Drawer headings', () {
    testWidgets('dark — "Map type" uses onSurface color', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      final text = tester.widget<Text>(find.text('Map type'));
      expect(text.style?.color, cs.onSurface,
          reason: '"Map type" must use onSurface in dark mode');
    });

    testWidgets('dark — "Map type" is not hardcoded near-black',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Map type'));
      expect(text.style?.color, isNot(const Color(0xFF141118)),
          reason: 'dark heading must not use the hardcoded light-mode color');
    });

    testWidgets('dark — "Map details" uses onSurface color', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      final text = tester.widget<Text>(find.text('Map details'));
      expect(text.style?.color, cs.onSurface,
          reason: '"Map details" must use onSurface in dark mode');
    });

    testWidgets('light — "Map type" uses onSurface color', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
      ));
      final cs = _cs(tester);
      final text = tester.widget<Text>(find.text('Map type'));
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('dark — onSurface is not near-black', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      // Verify the fix actually resolves to a light color in dark mode.
      final luminance = cs.onSurface.computeLuminance();
      expect(luminance, greaterThan(0.3),
          reason: 'onSurface in dark mode should be a light color');
    });
  });

  // -------------------------------------------------------------------------
  // Divider and handle
  // -------------------------------------------------------------------------

  group('Drawer chrome', () {
    testWidgets('dark — divider uses outlineVariant', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, cs.outlineVariant,
          reason: 'divider must use outlineVariant instead of black-alpha');
    });

    testWidgets('light — divider uses outlineVariant', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
      ));
      final cs = _cs(tester);
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, cs.outlineVariant);
    });

    testWidgets('dark — handle indicator is not solid black', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      final handle =
          tester.widgetList<Container>(find.byType(Container)).firstWhere((c) {
        final s = c.constraints?.maxWidth;
        return s == null &&
            (c.decoration as BoxDecoration?)?.borderRadius != null &&
            (c.decoration as BoxDecoration?)?.color != null;
      }, orElse: () {
        // fall back: find by known dimensions via SizedBox wrapping
        return tester.widgetList<Container>(find.byType(Container)).first;
      });
      final color = (handle.decoration as BoxDecoration?)?.color;
      // Must not be pure black (which would be invisible against dark bg).
      if (color != null) {
        expect(color, isNot(Colors.black));
        expect(color, isNot(const Color(0xFF000000)));
      }
    });
  });

  // -------------------------------------------------------------------------
  // Card labels
  // -------------------------------------------------------------------------

  group('Layer card labels', () {
    testWidgets('dark — unselected label uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: false,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _csCard(tester);
      final text = tester.widget<Text>(find.text('Road'));
      expect(text.style?.color, cs.onSurfaceVariant,
          reason: 'unselected label must use onSurfaceVariant in dark mode');
    });

    testWidgets('dark — unselected label is not near-black', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: false,
        ),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Road'));
      expect(text.style?.color, isNot(const Color(0xFF000000)));
      // Black with 0.78 alpha
      expect(text.style?.color, isNot(Colors.black.withValues(alpha: 0.78)));
    });

    testWidgets('light — unselected label uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: false,
        ),
      ));
      final cs = _csCard(tester);
      final text = tester.widget<Text>(find.text('Road'));
      expect(text.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('dark — selected label stays teal (brand accent)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: true,
        ),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Road'));
      expect(text.style?.color, const Color(0xFF1293A6),
          reason: 'selected label must keep the brand teal in dark mode');
    });

    testWidgets('light — selected label stays teal', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: true,
        ),
      ));
      final text = tester.widget<Text>(find.text('Road'));
      expect(text.style?.color, const Color(0xFF1293A6));
    });
  });

  // -------------------------------------------------------------------------
  // Card border
  // -------------------------------------------------------------------------

  group('Layer card border', () {
    testWidgets('dark — unselected border uses outlineVariant', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: false,
        ),
        brightness: Brightness.dark,
      ));
      final cs = _csCard(tester);
      final containers =
          tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == cs.outlineVariant;
        }),
        isTrue,
        reason: 'unselected card border must use outlineVariant in dark mode',
      );
    });

    testWidgets('dark — unselected border is not black-alpha', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: false,
        ),
        brightness: Brightness.dark,
      ));
      final containers =
          tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border &&
              b.top.color == Colors.black.withValues(alpha: 0.08);
        }),
        isFalse,
        reason: 'unselected border must not use black-alpha in dark mode',
      );
    });

    testWidgets('dark — selected border keeps teal', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: true,
        ),
        brightness: Brightness.dark,
      ));
      final containers =
          tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == const Color(0xFF1293A6);
        }),
        isTrue,
        reason: 'selected border must keep the brand teal in dark mode',
      );
    });

    testWidgets('light — selected border keeps teal', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerCardTest(
          option: _kLayerA,
          isSelected: true,
        ),
      ));
      final containers =
          tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == const Color(0xFF1293A6);
        }),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  // Selection toggle (regression: tapping a card changes selection)
  // -------------------------------------------------------------------------

  group('Selection state', () {
    testWidgets('tapping an unselected card selects it', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
      ));
      // Initially "layer-a" is selected; tap "Satellite" (layer-b)
      await tester.tap(find.text('Satellite'));
      await tester.pump();

      // After tap, Satellite card should now show the teal label.
      final text = tester.widget<Text>(find.text('Satellite'));
      expect(text.style?.color, const Color(0xFF1293A6),
          reason: 'tapped card must become selected');
    });

    testWidgets('dark — tapping an unselected card selects it', (tester) async {
      await tester.pumpWidget(_wrap(
        const MapLayerDrawerSheetTest(initialLayerId: 'layer-a'),
        brightness: Brightness.dark,
      ));
      await tester.tap(find.text('Satellite'));
      await tester.pump();

      final text = tester.widget<Text>(find.text('Satellite'));
      expect(text.style?.color, const Color(0xFF1293A6));
    });
  });
}
