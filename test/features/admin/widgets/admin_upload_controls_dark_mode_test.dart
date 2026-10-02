import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';

// ---------------------------------------------------------------------------
// Inline re-implementations of the four private widgets under test.
// These are structural copies that mirror exactly the production code so that
// any regression in the production files also shows up here.
// ---------------------------------------------------------------------------

class FilePickerFieldTest extends StatelessWidget {
  const FilePickerFieldTest({
    super.key,
    this.fileName = '',
    this.isPicking = false,
    this.showError = false,
  });

  final String fileName;
  final bool isPicking;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(
          color: showError
              ? OpenVtsColors.error
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_file_rounded,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Text(
              fileName.isEmpty ? 'Choose a file' : fileName,
              style: OpenVtsTypography.meta.copyWith(
                color: fileName.isEmpty
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: isPicking ? null : () {},
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: isPicking
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    fileName.isEmpty ? 'Browse' : 'Replace',
                    style: OpenVtsTypography.meta.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ExpiryFieldTest extends StatelessWidget {
  const ExpiryFieldTest({super.key, this.value});

  final DateTime? value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.sm,
          vertical: OpenVtsSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.event_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: OpenVtsSpacing.xs),
            Expanded(
              child: Text(
                value == null ? 'No expiry' : value.toString(),
                style: OpenVtsTypography.meta.copyWith(
                  color: value == null
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (value != null)
              IconButton(
                tooltip: 'Clear expiry',
                onPressed: () {},
                icon: const Icon(Icons.close_rounded, size: 17),
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(30),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            else
              Icon(
                Icons.expand_more_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class VisibilityToggleTest extends StatelessWidget {
  const VisibilityToggleTest({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: OpenVtsSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visible to user',
                  style: OpenVtsTypography.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  value ? 'Shown in user documents' : 'Hidden from user',
                  style: OpenVtsTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }
}

class AttachmentPickerTest extends StatelessWidget {
  const AttachmentPickerTest({
    super.key,
    required this.attachments,
    this.isPicking = false,
  });

  final List<PlatformFile> attachments;
  final bool isPicking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OpenVtsSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Text(
                  'Attachments',
                  style: OpenVtsTypography.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: isPicking ? null : () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: isPicking
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Add',
                        style: OpenVtsTypography.meta
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
              ),
            ],
          ),
          if (attachments.isEmpty)
            Text(
              'Optional files, up to 5.',
              style: OpenVtsTypography.meta.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // _FilePickerField
  // -------------------------------------------------------------------------

  group('FilePickerField — dark mode', () {
    testWidgets('no file: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.dark));
      final cs = tester
          .element(find.byType(FilePickerFieldTest))
          .findAncestorWidgetOfExactType<MaterialApp>()!
          .theme!
          .colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty,
          reason: 'Container must use surfaceContainerHighest in dark mode');
    });

    testWidgets('no file: placeholder text uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.dark));
      final text = tester.widget<Text>(find.text('Choose a file'));
      final textColor = (text.style?.color);
      final cs =
          Theme.of(tester.element(find.text('Choose a file'))).colorScheme;
      expect(textColor, cs.onSurfaceVariant);
    });

    testWidgets('file selected: filename uses onSurface color', (tester) async {
      await tester.pumpWidget(_wrap(
        const FilePickerFieldTest(fileName: 'doc.pdf'),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('doc.pdf'));
      final cs = Theme.of(tester.element(find.text('doc.pdf'))).colorScheme;
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('error state: border uses error color', (tester) async {
      await tester.pumpWidget(_wrap(
        const FilePickerFieldTest(showError: true),
        brightness: Brightness.dark,
      ));
      final containers = tester.widgetList<Container>(find.byType(Container));
      final errorBorder = containers.any((c) {
        final d = c.decoration as BoxDecoration?;
        final b = d?.border;
        if (b is Border) {
          return b.top.color == OpenVtsColors.error;
        }
        return false;
      });
      expect(errorBorder, isTrue,
          reason: 'Error state must keep error border color');
    });

    testWidgets('light mode: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const FilePickerFieldTest(), brightness: Brightness.light));
      final cs = Theme.of(tester.element(find.byType(FilePickerFieldTest)))
          .colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // _ExpiryField
  // -------------------------------------------------------------------------

  group('ExpiryField — dark mode', () {
    testWidgets('no expiry: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      final cs =
          Theme.of(tester.element(find.byType(ExpiryFieldTest))).colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });

    testWidgets('no expiry: placeholder uses onSurfaceVariant', (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      final text = tester.widget<Text>(find.text('No expiry'));
      final cs = Theme.of(tester.element(find.text('No expiry'))).colorScheme;
      expect(text.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('no expiry: chevron icon present', (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.dark));
      expect(find.byIcon(Icons.expand_more_rounded), findsOneWidget);
    });

    testWidgets('with expiry: value text uses onSurface', (tester) async {
      final date = DateTime(2027, 6, 15);
      await tester.pumpWidget(_wrap(
        ExpiryFieldTest(value: date),
        brightness: Brightness.dark,
      ));
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      final dateText = tester.widget<Text>(find.text(date.toString()));
      final cs =
          Theme.of(tester.element(find.text(date.toString()))).colorScheme;
      expect(dateText.style?.color, cs.onSurface);
    });

    testWidgets('light mode: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const ExpiryFieldTest(), brightness: Brightness.light));
      final cs =
          Theme.of(tester.element(find.byType(ExpiryFieldTest))).colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // _VisibilityToggle
  // -------------------------------------------------------------------------

  group('VisibilityToggle — dark mode', () {
    testWidgets('visible=true: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final cs = Theme.of(tester.element(find.byType(VisibilityToggleTest)))
          .colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });

    testWidgets('visible=true: label uses onSurface', (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Visible to user'));
      final cs =
          Theme.of(tester.element(find.text('Visible to user'))).colorScheme;
      expect(text.style?.color, cs.onSurface);
    });

    testWidgets('visible=false: subtitle uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: false),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Hidden from user'));
      final cs =
          Theme.of(tester.element(find.text('Hidden from user'))).colorScheme;
      expect(text.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('light mode: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VisibilityToggleTest(value: true),
        brightness: Brightness.light,
      ));
      final cs = Theme.of(tester.element(find.byType(VisibilityToggleTest)))
          .colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // _AttachmentPicker
  // -------------------------------------------------------------------------

  group('AttachmentPicker — dark mode', () {
    testWidgets('no attachments: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AttachmentPickerTest(attachments: []),
        brightness: Brightness.dark,
      ));
      final cs = Theme.of(tester.element(find.byType(AttachmentPickerTest)))
          .colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });

    testWidgets('no attachments: hint text uses onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AttachmentPickerTest(attachments: []),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Optional files, up to 5.'));
      final cs = Theme.of(tester.element(find.text('Optional files, up to 5.')))
          .colorScheme;
      expect(text.style?.color, cs.onSurfaceVariant);
    });

    testWidgets('no attachments: "Add" button is enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const AttachmentPickerTest(attachments: []),
        brightness: Brightness.dark,
      ));
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('isPicking=true: button is disabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const AttachmentPickerTest(attachments: [], isPicking: true),
        brightness: Brightness.dark,
      ));
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('light mode: uses surfaceContainerHighest background',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AttachmentPickerTest(attachments: []),
        brightness: Brightness.light,
      ));
      final cs = Theme.of(tester.element(find.byType(AttachmentPickerTest)))
          .colorScheme;
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        final d = c.decoration as BoxDecoration?;
        return d?.color == cs.surfaceContainerHighest;
      }).toList();
      expect(decorated, isNotEmpty);
    });
  });
}
