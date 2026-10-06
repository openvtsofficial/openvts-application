import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_theme.dart';
import 'package:open_vts/features/user/controllers/user_operations_providers.dart';
import 'package:open_vts/features/user/screens/operations/user_operation_plan_screen.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'planner controls remain usable at 320 px with Arabic/2x text (${dark ? 'dark' : 'light'})',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              userOperationPlanningProvider.overrideWith(
                (ref) async => {
                  'timezone': 'Asia/Kolkata',
                  'vehicles': [
                    {
                      'id': 4,
                      'name': 'مركبة التوصيل',
                      'plateNumber': 'DL 01',
                      'eligible': true,
                      'driver': {'id': 6, 'name': 'سائق'},
                    },
                  ],
                  'routes': [
                    {'id': 52, 'name': 'مسار المستودع', 'stopCount': 2},
                  ],
                },
              ),
            ],
            child: MaterialApp(
              theme: dark ? OpenVtsTheme.dark : OpenVtsTheme.light,
              locale: const Locale('ar'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: const UserOperationPlanScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final list = find
            .descendant(
              of: find.byType(ListView).first,
              matching: find.byType(Scrollable),
            )
            .first;
        final create = find.byKey(const ValueKey('operation-create-route'));
        await tester.scrollUntilVisible(create, 150, scrollable: list);
        await tester.pumpAndSettle();
        final createButton = tester.widget<OpenVtsButton>(create);
        expect(createButton.variant, OpenVtsButtonVariant.secondary);
        expect(tester.getSize(create).height, greaterThanOrEqualTo(48));
        final schedule = find.byKey(const ValueKey('DATE_ONLY'));
        await tester.scrollUntilVisible(schedule, 200, scrollable: list);
        await tester.pumpAndSettle();
        final dropdown = tester.widget<OpenVtsSearchableDropdown<String>>(
          schedule,
        );
        final timeSlot = dropdown.options.firstWhere(
          (item) => item.value == 'TIME_SLOT',
        );
        await tester.tap(schedule);
        await tester.pumpAndSettle();
        await tester.tap(find.text(timeSlot.label).last);
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('TIME_SLOT')), findsOneWidget);
        expect(tester.takeException(), isNull);
        final save = find.byKey(const ValueKey('operation-save-plan'));
        await tester.scrollUntilVisible(save, 200, scrollable: list);
        await tester.pumpAndSettle();
        expect(
          tester.widget<OpenVtsButton>(save).variant,
          OpenVtsButtonVariant.primary,
        );
        expect(tester.getSize(save).height, greaterThanOrEqualTo(48));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
