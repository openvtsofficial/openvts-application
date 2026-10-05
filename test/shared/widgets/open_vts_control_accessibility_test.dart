import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/theme/open_vts_theme.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/widgets/open_vts_button.dart';
import 'package:open_vts/shared/widgets/open_vts_detail_tab_strip.dart';
import 'package:open_vts/shared/widgets/open_vts_searchable_dropdown.dart';
import 'package:open_vts/shared/widgets/open_vts_segmented_pill_control.dart';
import 'package:open_vts/shared/widgets/open_vts_text_field.dart';
import 'package:open_vts/shared/widgets/searchable_dropdown_field.dart';

Widget app(
  Widget child, {
  double scale = 1,
  Locale locale = const Locale('en'),
  bool dark = false,
}) => MaterialApp(
  theme: dark ? OpenVtsTheme.dark : OpenVtsTheme.light,
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets(
    'button grows for long labels and retains busy label without double submission',
    (tester) async {
      phone(tester);
      var calls = 0;
      await tester.pumpWidget(
        app(
          OpenVtsButton(
            label: 'Save route and assign vehicle',
            isLoading: true,
            trailingIcon: Icons.check,
            onPressed: () => calls++,
          ),
          scale: 3,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(ElevatedButton)).height,
        greaterThan(48),
      );
      expect(find.text('Save route and assign vehicle'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(calls, 0);
    },
  );

  testWidgets('button works in intrinsic dialog action layout', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Continue?'),
                actions: [OpenVtsButton(label: 'Continue', onPressed: () {})],
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets(
    'required picker validates, searches metadata, and saves selection',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      String? value;
      await tester.pumpWidget(
        app(
          StatefulBuilder(
            builder: (context, setState) => Form(
              key: formKey,
              child: OpenVtsSearchableDropdown<String>(
                label: 'Vehicle',
                required: true,
                value: value,
                options: const [
                  OpenVtsDropdownOption(
                    value: '1',
                    label: 'Delivery van',
                    searchText: 'AB12',
                  ),
                ],
                onChanged: (next) => setState(() => value = next),
              ),
            ),
          ),
        ),
      );
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Vehicle is required.'), findsOneWidget);
      await tester.tap(find.text('Select Vehicle'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'AB12');
      await tester.pump();
      await tester.tap(find.text('Delivery van'));
      await tester.pumpAndSettle();
      expect(value, '1');
      expect(formKey.currentState!.validate(), isTrue);
    },
  );

  testWidgets('picker ignores results after owning form is removed', (
    tester,
  ) async {
    var showField = true;
    var calls = 0;
    late StateSetter update;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return showField
                ? OpenVtsSearchableDropdown<String>(
                    label: 'Vehicle',
                    options: const [
                      OpenVtsDropdownOption(value: '1', label: 'Van'),
                    ],
                    onChanged: (_) => calls++,
                  )
                : const Text('Signed out');
          },
        ),
      ),
    );
    await tester.tap(find.text('Select Vehicle'));
    await tester.pumpAndSettle();
    update(() => showField = false);
    await tester.pump();
    await tester.tap(find.text('Van'));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('picker stays scrollable at 3x Arabic text with keyboard', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(
      app(
        OpenVtsSearchableDropdown<String>(
          label: 'المركبات المتاحة لتخطيط الرحلات',
          value: '1',
          options: const [
            OpenVtsDropdownOption(value: '1', label: 'شاحنة التوصيل الأولى'),
          ],
          onChanged: (_) {},
        ),
        scale: 3,
        locale: const Locale('ar'),
        dark: true,
      ),
    );
    await tester.tap(find.text('شاحنة التوصيل الأولى'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      Directionality.of(tester.element(find.byType(TextField))),
      TextDirection.rtl,
    );
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'outlined facade uses same searchable mobile sheet and explicit clear',
    (tester) async {
      String? selected = 'van';
      await tester.pumpWidget(
        app(
          SearchableDropdownField<String>(
            label: 'Vehicle',
            initialValue: selected,
            items: const [SearchableDropdownItem(value: 'van', label: 'Van')],
            onChanged: (value) => selected = value,
          ),
        ),
      );
      await tester.tap(find.text('Van'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      expect(selected, isNull);
    },
  );

  testWidgets(
    'detail tabs and scrolling segments remain touch sized with no unbounded flex',
    (tester) async {
      phone(tester);
      await tester.pumpWidget(
        app(
          Column(
            children: [
              OpenVtsDetailTabStrip<int>(
                tabs: const [
                  OpenVtsDetailTabOption(value: 0, label: 'Security'),
                ],
                selected: 0,
                onChanged: (_) {},
              ),
              OpenVtsSegmentedPillControl<int>(
                segments: const [
                  OpenVtsSegmentedPillSegment(
                    value: 0,
                    label: 'Vehicle activity',
                  ),
                  OpenVtsSegmentedPillSegment(value: 1, label: 'Route status'),
                ],
                selectedValue: 0,
                equalWidth: true,
                allowHorizontalScroll: true,
                onChanged: (_) {},
              ),
            ],
          ),
          scale: 3,
        ),
      );
      expect(tester.takeException(), isNull);
      final chip = find.ancestor(
        of: find.text('Security'),
        matching: find.byType(InkWell),
      );
      expect(tester.getSize(chip).height, greaterThanOrEqualTo(48));
    },
  );

  testWidgets(
    'visible password still disables spell correction and suggestions',
    (tester) async {
      await tester.pumpWidget(
        app(
          const OpenVtsTextField(
            label: 'Password',
            obscureText: false,
            autofillHints: [AutofillHints.password],
          ),
        ),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autocorrect, isFalse);
      expect(field.enableSuggestions, isFalse);
    },
  );
}
