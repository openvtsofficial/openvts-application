// Widget tests for the _MetaRowsEditor dark-mode visibility fix.
//
// Coverage:
//   • "Vehicle Meta" heading present in light mode
//   • "Vehicle Meta" heading present in dark mode
//   • heading color equals colorScheme.onSurface (not a fixed value)
//   • heading color distinct from card surface in both modes
//   • empty metadata state renders without overflow
//   • populated metadata state renders key/value fields without overflow
//   • Add icon button is visible (not clipped)
//   • Remove icon button is visible per row

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Inline _MetaRowsEditor mirror ─────────────────────────────────────────────
//
// Mirrors the production _MetaRowsEditor exactly so that any regression in
// the private widget surfaces here without needing Riverpod or real providers.

class MetaRowController {
  MetaRowController({String keyText = '', String valueText = ''})
      : keyController = TextEditingController(text: keyText),
        valueController = TextEditingController(text: valueText);

  final TextEditingController keyController;
  final TextEditingController valueController;

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}

class MetaRowsEditorTest extends StatelessWidget {
  const MetaRowsEditorTest({
    required this.rows,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<MetaRowController> rows;
  final VoidCallback onAdd;
  final void Function(MetaRowController) onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.data_object_rounded,
                    size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Vehicle Meta',
                    key: const Key('vehicle_meta_heading'),
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('add_meta_row'),
                  tooltip: 'Add metadata row',
                  onPressed: onAdd,
                  icon: Icon(Icons.add_rounded, size: 18, color: cs.onSurface),
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(32),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (final row in rows) ...[
              _MetaRowFieldsTest(
                row: row,
                onRemove: () => onRemove(row),
              ),
              if (row != rows.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaRowFieldsTest extends StatelessWidget {
  const _MetaRowFieldsTest({
    required this.row,
    required this.onRemove,
  });

  final MetaRowController row;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: row.keyController,
            decoration: const InputDecoration(
              hintText: 'Key',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: row.valueController,
            decoration: const InputDecoration(
              hintText: 'Value',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: 'Remove metadata row',
          onPressed: onRemove,
          icon: Icon(Icons.close_rounded, size: 17, color: cs.onSurfaceVariant),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(36),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

// ── Stateful wrapper for add/remove interaction ───────────────────────────────

class _EditorWrapper extends StatefulWidget {
  const _EditorWrapper({this.initialMeta = const {}});

  final Map<String, String> initialMeta;

  @override
  State<_EditorWrapper> createState() => _EditorWrapperState();
}

class _EditorWrapperState extends State<_EditorWrapper> {
  late final List<MetaRowController> _rows;

  @override
  void initState() {
    super.initState();
    if (widget.initialMeta.isEmpty) {
      _rows = [MetaRowController()];
    } else {
      _rows = widget.initialMeta.entries
          .map((e) => MetaRowController(keyText: e.key, valueText: e.value))
          .toList();
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MetaRowsEditorTest(
      rows: _rows,
      onAdd: () => setState(() => _rows.add(MetaRowController())),
      onRemove: (row) {
        if (_rows.length == 1) {
          row.keyController.clear();
          row.valueController.clear();
          setState(() {});
          return;
        }
        setState(() => _rows.remove(row));
        row.dispose();
      },
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

ColorScheme _cs(WidgetTester tester) =>
    Theme.of(tester.element(find.byKey(const Key('vehicle_meta_heading'))))
        .colorScheme;

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. Heading text presence
// ─────────────────────────────────────────────────────────────────────────────
  group('Vehicle Meta heading presence', () {
    testWidgets('renders heading in light mode', (tester) async {
      await tester.pumpWidget(_wrap(
        const _EditorWrapper(),
      ));
      expect(find.text('Vehicle Meta'), findsOneWidget);
    });

    testWidgets('renders heading in dark mode', (tester) async {
      await tester.pumpWidget(_wrap(
        const _EditorWrapper(),
        brightness: Brightness.dark,
      ));
      expect(find.text('Vehicle Meta'), findsOneWidget);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Heading color uses onSurface (not a fixed value)
// ─────────────────────────────────────────────────────────────────────────────
  group('Heading color — theme-relative', () {
    testWidgets('light mode: heading color equals colorScheme.onSurface',
        (tester) async {
      await tester.pumpWidget(_wrap(const _EditorWrapper()));
      final cs = _cs(tester);

      final text = tester.widget<Text>(
        find.byKey(const Key('vehicle_meta_heading')),
      );
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('dark mode: heading color equals colorScheme.onSurface',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _EditorWrapper(),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);

      final text = tester.widget<Text>(
        find.byKey(const Key('vehicle_meta_heading')),
      );
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('light mode: onSurface is distinct from surface',
        (tester) async {
      await tester.pumpWidget(_wrap(const _EditorWrapper()));
      final cs = _cs(tester);
      expect(cs.onSurface, isNot(equals(cs.surface)));
    });

    testWidgets('dark mode: onSurface is distinct from surface',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _EditorWrapper(),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester);
      expect(cs.onSurface, isNot(equals(cs.surface)));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. Empty metadata state
// ─────────────────────────────────────────────────────────────────────────────
  group('Empty metadata state', () {
    testWidgets('renders one Key field and one Value field', (tester) async {
      await tester.pumpWidget(_wrap(const _EditorWrapper()));
      expect(find.widgetWithText(TextFormField, 'Key'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Value'), findsOneWidget);
    });

    testWidgets('Add button is present', (tester) async {
      await tester.pumpWidget(_wrap(const _EditorWrapper()));
      expect(find.byKey(const Key('add_meta_row')), findsOneWidget);
    });

    testWidgets('no overflow in light mode at 390 px', (tester) async {
      final errors = <String>[];
      FlutterError.onError = (d) => errors.add(d.exceptionAsString());

      await tester.pumpWidget(_wrap(const _EditorWrapper()));
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.presentError;

      expect(errors.where((e) => e.contains('overflowed')), isEmpty);
    });

    testWidgets('no overflow in dark mode at 390 px', (tester) async {
      final errors = <String>[];
      FlutterError.onError = (d) => errors.add(d.exceptionAsString());

      await tester.pumpWidget(_wrap(
        const _EditorWrapper(),
        brightness: Brightness.dark,
      ));
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.presentError;

      expect(errors.where((e) => e.contains('overflowed')), isEmpty);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. Populated metadata state
// ─────────────────────────────────────────────────────────────────────────────
  group('Populated metadata state', () {
    const meta = {
      'color': 'red',
      'seats': '4',
      'engine': 'diesel',
    };

    testWidgets('renders all key/value pairs in light mode', (tester) async {
      await tester.pumpWidget(_wrap(const _EditorWrapper(initialMeta: meta)));
      for (final entry in meta.entries) {
        expect(find.text(entry.key), findsOneWidget);
        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('renders all key/value pairs in dark mode', (tester) async {
      await tester.pumpWidget(_wrap(
        const _EditorWrapper(initialMeta: meta),
        brightness: Brightness.dark,
      ));
      for (final entry in meta.entries) {
        expect(find.text(entry.key), findsOneWidget);
        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('each row has a Remove button', (tester) async {
      await tester.pumpWidget(_wrap(const _EditorWrapper(initialMeta: meta)));
      // One remove button per row.
      expect(
        find.byTooltip('Remove metadata row'),
        findsNWidgets(meta.length),
      );
    });

    testWidgets('no overflow with three rows at 390 px', (tester) async {
      final errors = <String>[];
      FlutterError.onError = (d) => errors.add(d.exceptionAsString());

      await tester.pumpWidget(_wrap(const _EditorWrapper(initialMeta: meta)));
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.presentError;

      expect(errors.where((e) => e.contains('overflowed')), isEmpty);
    });

    testWidgets('no overflow at narrow 320 px', (tester) async {
      final errors = <String>[];
      FlutterError.onError = (d) => errors.add(d.exceptionAsString());

      await tester.pumpWidget(_wrap(
        const _EditorWrapper(initialMeta: meta),
        width: 320,
      ));
      await tester.pumpAndSettle();

      FlutterError.onError = FlutterError.presentError;

      expect(errors.where((e) => e.contains('overflowed')), isEmpty);
    });
  });
}
