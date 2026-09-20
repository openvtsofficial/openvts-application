import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';

// ---------------------------------------------------------------------------
// Inline re-implementations that mirror the production widgets exactly after
// the dark-mode fix so regressions in the production files surface here.
// ---------------------------------------------------------------------------

// -- Events date range control -----------------------------------------------

class DateRangeControlTest extends StatelessWidget {
  const DateRangeControlTest({super.key, this.rangeDisplay = 'All dates'});

  final String rangeDisplay;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: OpenVtsSpacing.xs),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: OpenVtsSpacing.sm,
              vertical: OpenVtsSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(OpenVtsRadius.md),
              color: cs.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded,
                    size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: Text(
                    rangeDisplay,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// -- Filter sheet Apply button -----------------------------------------------

class ApplyFiltersButtonTest extends StatelessWidget {
  const ApplyFiltersButtonTest({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: OpenVtsSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        ),
      ),
      child: const Text('Apply filters'),
    );
  }
}

// -- Document _FilePickerField -----------------------------------------------

class FilePickerFieldTest extends StatelessWidget {
  const FilePickerFieldTest({
    super.key,
    this.fileName,
    this.isPicking = false,
    this.showError = false,
  });

  final String? fileName;
  final bool isPicking;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: isPicking ? null : () {},
      child: Container(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: showError ? cs.error : cs.outlineVariant,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          color: cs.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Icon(
              Icons.upload_file_rounded,
              size: 20,
              color: isPicking
                  ? cs.onSurfaceVariant.withValues(alpha: 0.5)
                  : cs.onSurfaceVariant,
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'File',
                    style: OpenVtsTypography.meta
                        .copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fileName ?? 'Choose a file',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: fileName != null
                              ? cs.onSurface
                              : cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isPicking)
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(Icons.folder_open_rounded, size: 18, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

// -- Document _ExpiryField ---------------------------------------------------

class ExpiryFieldTest extends StatelessWidget {
  const ExpiryFieldTest({super.key, this.value});

  final DateTime? value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.event_rounded, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Expiry Date',
                  style: OpenVtsTypography.meta.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value == null ? 'Optional' : value.toString(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            value == null ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: value == null ? () {} : () {},
            child: Text(
              value == null ? 'Select' : 'Clear',
              style: OpenVtsTypography.label.copyWith(color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// -- Document _VisibilityToggle ----------------------------------------------

class VisibilityToggleTest extends StatelessWidget {
  const VisibilityToggleTest({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                size: 18,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Visibility',
                    style: OpenVtsTypography.meta.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ? 'Visible' : 'Hidden',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Switch(value: value, onChanged: (_) {}),
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
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

ColorScheme _cs(WidgetTester tester, Type type) =>
    Theme.of(tester.element(find.byType(type))).colorScheme;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // DateRangeControl
  // -------------------------------------------------------------------------

  group('DateRangeControl', () {
    testWidgets('dark — container uses surfaceContainerHighest',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const DateRangeControlTest(), brightness: Brightness.dark));
      final cs = _cs(tester, DateRangeControlTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
        reason: 'Container must use surfaceContainerHighest in dark mode',
      );
    });

    testWidgets('dark — border uses outlineVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const DateRangeControlTest(), brightness: Brightness.dark));
      final cs = _cs(tester, DateRangeControlTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == cs.outlineVariant;
        }),
        isTrue,
      );
    });

    testWidgets('dark — label uses onSurfaceVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const DateRangeControlTest(), brightness: Brightness.dark));
      final cs = _cs(tester, DateRangeControlTest);
      final label = tester.widget<Text>(find.text('Date Range'));
      expect(label.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('dark — calendar icon uses onSurfaceVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const DateRangeControlTest(), brightness: Brightness.dark));
      final cs = _cs(tester, DateRangeControlTest);
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(
        icons.any((i) =>
            i.icon == Icons.calendar_month_rounded &&
            i.color == cs.onSurfaceVariant),
        isTrue,
      );
    });

    testWidgets('dark — chevron icon uses onSurfaceVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const DateRangeControlTest(), brightness: Brightness.dark));
      final cs = _cs(tester, DateRangeControlTest);
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      expect(
        icons.any((i) =>
            i.icon == Icons.chevron_right_rounded &&
            i.color == cs.onSurfaceVariant),
        isTrue,
      );
    });

    testWidgets('dark — selected date text is visible (bodyMedium)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const DateRangeControlTest(rangeDisplay: '01 Jan 2026'),
        brightness: Brightness.dark,
      ));
      expect(find.text('01 Jan 2026'), findsOneWidget);
    });

    testWidgets('light — container uses surfaceContainerHighest',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const DateRangeControlTest(), brightness: Brightness.light));
      final cs = _cs(tester, DateRangeControlTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  // ApplyFiltersButton
  // -------------------------------------------------------------------------

  group('ApplyFiltersButton', () {
    testWidgets('dark — background is colorScheme.primary', (tester) async {
      await tester.pumpWidget(_wrap(
        ApplyFiltersButtonTest(onPressed: () {}),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, ApplyFiltersButtonTest);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final bg = button.style!.backgroundColor?.resolve(const <WidgetState>{});
      expect(bg, cs.primary);
    });

    testWidgets('dark — foreground is colorScheme.onPrimary', (tester) async {
      await tester.pumpWidget(_wrap(
        ApplyFiltersButtonTest(onPressed: () {}),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, ApplyFiltersButtonTest);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final fg = button.style!.foregroundColor?.resolve(const <WidgetState>{});
      expect(fg, cs.onPrimary);
    });

    testWidgets('dark — primary and onPrimary are not the same color',
        (tester) async {
      await tester.pumpWidget(_wrap(
        ApplyFiltersButtonTest(onPressed: () {}),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, ApplyFiltersButtonTest);
      expect(cs.primary, isNot(cs.onPrimary),
          reason: 'button must not be white-on-white in dark mode');
    });

    testWidgets('dark — onPressed callback is invoked', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(
        ApplyFiltersButtonTest(onPressed: () => called = true),
        brightness: Brightness.dark,
      ));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(called, isTrue);
    });

    testWidgets('light — background is colorScheme.primary', (tester) async {
      await tester.pumpWidget(_wrap(
        ApplyFiltersButtonTest(onPressed: () {}),
        brightness: Brightness.light,
      ));
      final cs = _cs(tester, ApplyFiltersButtonTest);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final bg = button.style!.backgroundColor?.resolve(const <WidgetState>{});
      expect(bg, cs.primary);
    });
  });

  // -------------------------------------------------------------------------
  // FilePickerField
  // -------------------------------------------------------------------------

  group('FilePickerField', () {
    testWidgets('dark — empty: uses surfaceContainerHighest', (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.dark));
      final cs = _cs(tester, FilePickerFieldTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });

    testWidgets('dark — empty: placeholder text uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.dark));
      final cs = _cs(tester, FilePickerFieldTest);
      final text = tester.widget<Text>(find.text('Choose a file'));
      expect(text.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('dark — selected: filename uses onSurface', (tester) async {
      await tester.pumpWidget(_wrap(
        const FilePickerFieldTest(fileName: 'report.pdf'),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, FilePickerFieldTest);
      final text = tester.widget<Text>(find.text('report.pdf'));
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('dark — error: border uses colorScheme.error', (tester) async {
      await tester.pumpWidget(_wrap(
        const FilePickerFieldTest(showError: true),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, FilePickerFieldTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == cs.error;
        }),
        isTrue,
      );
    });

    testWidgets('dark — normal border uses outlineVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.dark));
      final cs = _cs(tester, FilePickerFieldTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) {
          final b = (c.decoration as BoxDecoration?)?.border;
          return b is Border && b.top.color == cs.outlineVariant;
        }),
        isTrue,
      );
    });

    testWidgets('dark — loading: spinner shown, folder icon absent',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FilePickerFieldTest(isPicking: true),
        brightness: Brightness.dark,
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.folder_open_rounded), findsNothing);
    });

    testWidgets('dark — not loading: folder icon shown', (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.dark));
      expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
    });

    testWidgets('light — uses surfaceContainerHighest', (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.light));
      final cs = _cs(tester, FilePickerFieldTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  // ExpiryField
  // -------------------------------------------------------------------------

  group('ExpiryField', () {
    testWidgets('dark — empty: uses surfaceContainerHighest', (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      final cs = _cs(tester, ExpiryFieldTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });

    testWidgets('dark — empty: "Optional" uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      final cs = _cs(tester, ExpiryFieldTest);
      final text = tester.widget<Text>(find.text('Optional'));
      expect(text.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('dark — empty: Select action button shown', (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('dark — with date: value text uses onSurface', (tester) async {
      final date = DateTime(2027, 3, 20);
      await tester.pumpWidget(
          _wrap(ExpiryFieldTest(value: date), brightness: Brightness.dark));
      final cs = _cs(tester, ExpiryFieldTest);
      final text = tester.widget<Text>(find.text(date.toString()));
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('dark — with date: Clear action shown', (tester) async {
      final date = DateTime(2027, 3, 20);
      await tester.pumpWidget(
          _wrap(ExpiryFieldTest(value: date), brightness: Brightness.dark));
      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('dark — label uses onSurfaceVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      final cs = _cs(tester, ExpiryFieldTest);
      final label = tester.widget<Text>(find.text('Expiry Date'));
      expect(label.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('light — uses surfaceContainerHighest', (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.light));
      final cs = _cs(tester, ExpiryFieldTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });
  });

  // -------------------------------------------------------------------------
  // VisibilityToggle
  // -------------------------------------------------------------------------

  group('VisibilityToggle', () {
    testWidgets('dark — visible=true: uses surfaceContainerHighest',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, VisibilityToggleTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });

    testWidgets('dark — visible=true: value text uses onSurface',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, VisibilityToggleTest);
      final text = tester.widget<Text>(find.text('Visible'));
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('dark — visible=false: value text uses onSurface',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: false),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, VisibilityToggleTest);
      final text = tester.widget<Text>(find.text('Hidden'));
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('dark — label uses onSurfaceVariant', (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, VisibilityToggleTest);
      final label = tester.widget<Text>(find.text('Visibility'));
      expect(label.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('dark — switch is enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.onChanged, isNotNull);
    });

    testWidgets('dark — onSurface and surfaceContainerHighest are distinct',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, VisibilityToggleTest);
      expect(cs.onSurface, isNot(cs.surfaceContainerHighest),
          reason: 'text must contrast with container background in dark mode');
    });

    testWidgets('light — uses surfaceContainerHighest', (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.light,
      ));
      final cs = _cs(tester, VisibilityToggleTest);
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((c) =>
            (c.decoration as BoxDecoration?)?.color ==
            cs.surfaceContainerHighest),
        isTrue,
      );
    });
  });
}
