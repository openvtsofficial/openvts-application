import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/l10n/app_localizations_ar.dart';
import 'package:open_vts/l10n/app_localizations_fr.dart';
import 'package:open_vts/shared/widgets/open_vts_date_time_range_selector.dart';

void main() {
  testWidgets('selected date labels react to language changes', (tester) async {
    late StateSetter setAppState;
    var locale = const Locale('en');
    final date = DateTime(2026, 5, 16);
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          setAppState = setState;
          return MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: OpenVtsDateTimeRangeField(
                label: 'Range',
                value: OpenVtsDateTimeRange(start: date, end: date),
                onChanged: (_) {},
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(DateFormat.yMMMd('en').format(date)), findsOneWidget);
    setAppState(() => locale = const Locale('es'));
    await tester.pumpAndSettle();
    expect(find.text(DateFormat.yMMMd('es').format(date)), findsOneWidget);
    expect(find.text(DateFormat.yMMMd('en').format(date)), findsNothing);
  });

  testWidgets('French week preset starts on the locale first weekday', (
    tester,
  ) async {
    final l10n = AppLocalizationsFr();
    OpenVtsDateTimeRange? selected;
    await tester.pumpWidget(
      _app(
        locale: const Locale('fr'),
        child: OpenVtsDateTimeRangeSelector(
          now: DateTime(2026, 5, 16, 9, 41),
          onApply: (value) => selected = value,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.dateRangeChoose), findsOneWidget);
    expect(
      find.text(DateFormat.yMMMM('fr').format(DateTime(2026, 5))),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text(l10n.dateRangeThisWeek).hitTestable(),
      180,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.right,
      ),
    );
    await tester.tap(find.text(l10n.dateRangeThisWeek).hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.apply));
    expect(selected?.start, DateTime(2026, 5, 11));
    expect(selected?.end, DateTime(2026, 5, 16));
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(320, 568), const Size(568, 320)]) {
    testWidgets(
      'Arabic range remains usable at ${size.width}x${size.height} and large text',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final l10n = AppLocalizationsAr();
        OpenVtsDateTimeRange? selected;
        final start = DateTime(2026, 5, 16, 8, 41);
        final end = DateTime(2026, 5, 16, 9, 41);
        await tester.pumpWidget(
          _app(
            locale: const Locale('ar'),
            textScale: 2,
            child: OpenVtsDateTimeRangeSelector(
              initialValue: OpenVtsDateTimeRange(start: start, end: end),
              dateTimeEnabled: true,
              now: end,
              onApply: (value) => selected = value,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final vertical = find
            .byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection == AxisDirection.down,
            )
            .first;
        await tester.scrollUntilVisible(
          find.text(l10n.dateRangeEndTime),
          160,
          scrollable: vertical,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text(l10n.apply).hitTestable(),
          160,
          scrollable: vertical,
        );
        await tester.tap(find.text(l10n.apply).hitTestable());
        expect(selected?.start, start);
        expect(selected?.end, end);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Widget _app({
  required Widget child,
  required Locale locale,
  double textScale = 1,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: Scaffold(body: child),
  );
}
