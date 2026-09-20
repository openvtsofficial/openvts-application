import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_colors.dart';
import 'package:open_vts/features/superadmin/models/superadmin_support_model.dart';
import 'package:open_vts/shared/widgets/support/open_vts_support_chips.dart';

// Mirrors the brightness-aware _statusColor logic shared by:
//   superadmin_support_conversation_screen.dart
//   superadmin_support_ticket_card.dart
Color _statusChipColor(
    BuildContext context, SuperadminSupportTicketStatus status) {
  final cs = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return switch (status) {
    SuperadminSupportTicketStatus.open =>
      isDark ? const Color(0xFF5DB588) : OpenVtsColors.success,
    SuperadminSupportTicketStatus.inProgress =>
      isDark ? const Color(0xFFD4A852) : OpenVtsColors.warning,
    SuperadminSupportTicketStatus.closed => cs.onSurfaceVariant,
  };
}

class _StatusChipTest extends StatelessWidget {
  const _StatusChipTest({required this.status});
  final SuperadminSupportTicketStatus status;

  @override
  Widget build(BuildContext context) {
    return OpenVtsSupportSoftChip(
      label: status.label,
      color: _statusChipColor(context, status),
    );
  }
}

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF141118),
        brightness: brightness,
      ),
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Support status chip — light mode', () {
    testWidgets('Open: label text uses OpenVtsColors.success', (tester) async {
      await tester.pumpWidget(_wrap(
        const _StatusChipTest(status: SuperadminSupportTicketStatus.open),
      ));
      final text = tester.widget<Text>(find.text('Open'));
      expect(text.style?.color, OpenVtsColors.success);
    });

    testWidgets('In Progress: label text uses OpenVtsColors.warning',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _StatusChipTest(status: SuperadminSupportTicketStatus.inProgress),
      ));
      final text = tester.widget<Text>(find.text('In Progress'));
      expect(text.style?.color, OpenVtsColors.warning);
    });

    testWidgets('Closed: label text uses colorScheme.onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _StatusChipTest(status: SuperadminSupportTicketStatus.closed),
      ));
      final text = tester.widget<Text>(find.text('Closed'));
      final cs = Theme.of(tester.element(find.text('Closed'))).colorScheme;
      expect(text.style?.color, cs.onSurfaceVariant);
    });
  });

  group('Support status chip — dark mode', () {
    testWidgets('Open: label text uses bright green, not fixed dark success',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _StatusChipTest(status: SuperadminSupportTicketStatus.open),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Open'));
      expect(text.style?.color, const Color(0xFF5DB588));
      expect(text.style?.color, isNot(OpenVtsColors.success));
    });

    testWidgets(
        'In Progress: label text uses bright amber, not fixed dark warning',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _StatusChipTest(status: SuperadminSupportTicketStatus.inProgress),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('In Progress'));
      expect(text.style?.color, const Color(0xFFD4A852));
      expect(text.style?.color, isNot(OpenVtsColors.warning));
    });

    testWidgets('Closed: label text uses colorScheme.onSurfaceVariant',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const _StatusChipTest(status: SuperadminSupportTicketStatus.closed),
        brightness: Brightness.dark,
      ));
      final text = tester.widget<Text>(find.text('Closed'));
      final cs = Theme.of(tester.element(find.text('Closed'))).colorScheme;
      expect(text.style?.color, cs.onSurfaceVariant);
    });
  });
}
