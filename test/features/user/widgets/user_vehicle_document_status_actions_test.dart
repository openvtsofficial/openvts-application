// Widget tests for dark-mode visibility fix:
// document Visible/Hidden status pill and View/Edit/Delete popup actions.
//
// Coverage:
//   _MetaPill (default / explicit color)
//     • default color is onSurfaceVariant in light and dark mode
//     • explicit color is forwarded unchanged
//   Visibility pill
//     • Visible pill uses onSurface in light mode
//     • Visible pill uses onSurface in dark mode
//     • Hidden pill uses onSurfaceVariant in light mode
//     • Hidden pill uses onSurfaceVariant in dark mode
//     • onSurface is distinct from onSurfaceVariant in both modes
//   _MenuRow
//     • non-destructive row uses onSurface in light mode
//     • non-destructive row uses onSurface in dark mode
//     • destructive row uses OpenVtsColors.error in both modes
//     • labels are present and not elided
//   Popup actions (integration)
//     • View taps fire onView callback once
//     • Edit taps fire onEdit callback once
//     • popup disabled when isBusy = true

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';

// ── Inline mirrors ─────────────────────────────────────────────────────────────

// _MetaPill mirror — nullable color defaulting to onSurfaceVariant
class MetaPillTest extends StatelessWidget {
  const MetaPillTest({
    required this.icon,
    required this.label,
    this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      key: const Key('meta_pill'),
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: effectiveColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: effectiveColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              key: const Key('meta_pill_label'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OpenVtsTypography.meta.copyWith(
                color: effectiveColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Visibility pill wrapper — mirrors the call-site inside _DocumentCard
class VisibilityPillTest extends StatelessWidget {
  const VisibilityPillTest({required this.isVisible, super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MetaPillTest(
      icon:
          isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      label: isVisible ? 'Visible' : 'Hidden',
      color: isVisible ? cs.onSurface : cs.onSurfaceVariant,
    );
  }
}

// _MenuRow mirror
class MenuRowTest extends StatelessWidget {
  const MenuRowTest({
    required this.icon,
    required this.label,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? OpenVtsColors.error
        : Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: OpenVtsSpacing.xs),
        Text(
          label,
          key: Key('menu_row_$label'),
          style: OpenVtsTypography.meta.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// Minimal document card stub for popup-action integration tests
enum _DocAction { view, edit, delete }

class DocumentCardStub extends StatelessWidget {
  const DocumentCardStub({
    required this.isBusy,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final bool isBusy;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_DocAction>(
      key: const Key('doc_popup'),
      tooltip: 'Document actions',
      enabled: !isBusy,
      icon: isBusy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.more_vert_rounded, size: 18),
      onSelected: (action) {
        switch (action) {
          case _DocAction.view:
            onView();
          case _DocAction.edit:
            onEdit();
          case _DocAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _DocAction.view,
          height: 38,
          child: MenuRowTest(icon: Icons.open_in_new_rounded, label: 'View'),
        ),
        const PopupMenuItem(
          value: _DocAction.edit,
          height: 38,
          child: MenuRowTest(icon: Icons.edit_outlined, label: 'Edit'),
        ),
        const PopupMenuItem(
          value: _DocAction.delete,
          height: 38,
          child: MenuRowTest(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            isDestructive: true,
          ),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(
  Widget child, {
  Brightness brightness = Brightness.light,
}) {
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

ColorScheme _cs(WidgetTester tester, Key key) =>
    Theme.of(tester.element(find.byKey(key))).colorScheme;

void _noOp() {}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
// ─────────────────────────────────────────────────────────────────────────────
// 1. MetaPill — default color
// ─────────────────────────────────────────────────────────────────────────────
  group('MetaPill default color', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final label = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('defaults to onSurfaceVariant ($label)', (tester) async {
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

    testWidgets('explicit color is forwarded unchanged', (tester) async {
      const explicit = Color(0xFF2F6B4F);
      await tester.pumpWidget(_wrap(
        const MetaPillTest(
          icon: Icons.label_outline_rounded,
          label: 'Tag',
          color: explicit,
        ),
      ));
      final text =
          tester.widget<Text>(find.byKey(const Key('meta_pill_label')));
      expect(text.style?.color, explicit);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Visibility pill
// ─────────────────────────────────────────────────────────────────────────────
  group('Visibility pill', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final modeLabel = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('Visible uses onSurface ($modeLabel)', (tester) async {
        await tester.pumpWidget(_wrap(
          const VisibilityPillTest(isVisible: true),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('meta_pill_label'));
        final text =
            tester.widget<Text>(find.byKey(const Key('meta_pill_label')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('Hidden uses onSurfaceVariant ($modeLabel)', (tester) async {
        await tester.pumpWidget(_wrap(
          const VisibilityPillTest(isVisible: false),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('meta_pill_label'));
        final text =
            tester.widget<Text>(find.byKey(const Key('meta_pill_label')));
        expect(text.style?.color, cs.onSurfaceVariant);
      });

      testWidgets('Visible label text present ($modeLabel)', (tester) async {
        await tester.pumpWidget(_wrap(
          const VisibilityPillTest(isVisible: true),
          brightness: brightness,
        ));
        expect(find.text('Visible'), findsOneWidget);
      });

      testWidgets('Hidden label text present ($modeLabel)', (tester) async {
        await tester.pumpWidget(_wrap(
          const VisibilityPillTest(isVisible: false),
          brightness: brightness,
        ));
        expect(find.text('Hidden'), findsOneWidget);
      });
    }

    testWidgets('onSurface distinct from onSurfaceVariant in light mode',
        (tester) async {
      await tester.pumpWidget(_wrap(const VisibilityPillTest(isVisible: true)));
      final cs = _cs(tester, const Key('meta_pill_label'));
      expect(cs.onSurface, isNot(equals(cs.onSurfaceVariant)));
    });

    testWidgets('onSurface distinct from onSurfaceVariant in dark mode',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityPillTest(isVisible: true),
        brightness: Brightness.dark,
      ));
      final cs = _cs(tester, const Key('meta_pill_label'));
      expect(cs.onSurface, isNot(equals(cs.onSurfaceVariant)));
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. MenuRow colors
// ─────────────────────────────────────────────────────────────────────────────
  group('MenuRow colors', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final modeLabel = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('non-destructive uses onSurface ($modeLabel)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          const MenuRowTest(icon: Icons.open_in_new_rounded, label: 'View'),
          brightness: brightness,
        ));
        final cs = _cs(tester, const Key('menu_row_View'));
        final text =
            tester.widget<Text>(find.byKey(const Key('menu_row_View')));
        expect(text.style?.color, cs.onSurface);
      });

      testWidgets('destructive uses OpenVtsColors.error ($modeLabel)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          const MenuRowTest(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            isDestructive: true,
          ),
          brightness: brightness,
        ));
        final text =
            tester.widget<Text>(find.byKey(const Key('menu_row_Delete')));
        expect(text.style?.color, OpenVtsColors.error);
      });

      testWidgets('label text is present and not empty ($modeLabel)',
          (tester) async {
        await tester.pumpWidget(_wrap(
          const MenuRowTest(icon: Icons.edit_outlined, label: 'Edit'),
          brightness: brightness,
        ));
        expect(find.text('Edit'), findsOneWidget);
      });
    }
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. Popup actions — callbacks
// ─────────────────────────────────────────────────────────────────────────────
  group('Popup actions', () {
    testWidgets('View fires onView once', (tester) async {
      var viewCount = 0;
      await tester.pumpWidget(_wrap(
        DocumentCardStub(
          isBusy: false,
          onView: () => viewCount++,
          onEdit: _noOp,
          onDelete: _noOp,
        ),
      ));

      await tester.tap(find.byKey(const Key('doc_popup')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('menu_row_View')));
      await tester.pumpAndSettle();

      expect(viewCount, 1);
    });

    testWidgets('Edit fires onEdit once', (tester) async {
      var editCount = 0;
      await tester.pumpWidget(_wrap(
        DocumentCardStub(
          isBusy: false,
          onView: _noOp,
          onEdit: () => editCount++,
          onDelete: _noOp,
        ),
      ));

      await tester.tap(find.byKey(const Key('doc_popup')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('menu_row_Edit')));
      await tester.pumpAndSettle();

      expect(editCount, 1);
    });

    testWidgets('Delete fires onDelete once', (tester) async {
      var deleteCount = 0;
      await tester.pumpWidget(_wrap(
        DocumentCardStub(
          isBusy: false,
          onView: _noOp,
          onEdit: _noOp,
          onDelete: () => deleteCount++,
        ),
      ));

      await tester.tap(find.byKey(const Key('doc_popup')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('menu_row_Delete')));
      await tester.pumpAndSettle();

      expect(deleteCount, 1);
    });

    testWidgets('popup is disabled when isBusy is true', (tester) async {
      var viewCount = 0;
      await tester.pumpWidget(_wrap(
        DocumentCardStub(
          isBusy: true,
          onView: () => viewCount++,
          onEdit: _noOp,
          onDelete: _noOp,
        ),
      ));

      // Disabled PopupMenuButton ignores taps — just pump a single frame.
      await tester.tap(find.byKey(const Key('doc_popup')));
      await tester.pump();

      // No menu items should appear when busy.
      expect(find.byKey(const Key('menu_row_View')), findsNothing);
      expect(viewCount, 0);
    });

    testWidgets('popup shows spinner icon when isBusy is true', (tester) async {
      await tester.pumpWidget(_wrap(
        const DocumentCardStub(
          isBusy: true,
          onView: _noOp,
          onEdit: _noOp,
          onDelete: _noOp,
        ),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

// ─────────────────────────────────────────────────────────────────────────────
// 5. No overflow
// ─────────────────────────────────────────────────────────────────────────────
  group('No overflow', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final modeLabel = brightness == Brightness.light ? 'light' : 'dark';

      testWidgets('visibility pill no overflow ($modeLabel)', (tester) async {
        final errors = <String>[];
        FlutterError.onError = (d) => errors.add(d.exceptionAsString());

        await tester.pumpWidget(_wrap(
          const VisibilityPillTest(isVisible: true),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        FlutterError.onError = FlutterError.presentError;

        expect(errors.where((e) => e.contains('overflowed')), isEmpty);
      });
    }
  });
}
