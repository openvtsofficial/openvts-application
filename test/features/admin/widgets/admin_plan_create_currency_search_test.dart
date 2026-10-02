import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_plans_model.dart';
import 'package:open_vts/features/admin/screens/plans/widgets/admin_plan_form_sheet.dart';

void main() {
  testWidgets('Create Plan searches currency code and label and selects code', (
    tester,
  ) async {
    String? selectedCurrency;
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => Form(
              key: formKey,
              child: AdminPlanCurrencyDropdown(
                value: selectedCurrency,
                currencies: const [
                  AdminCurrencyOption(code: 'INR', name: 'Indian Rupee'),
                  AdminCurrencyOption(code: 'USD', name: 'US Dollar'),
                ],
                onChanged: (value) => setState(() => selectedCurrency = value),
              ),
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Currency is required'), findsOneWidget);

    final trigger = find.descendant(
      of: find.byType(AdminPlanCurrencyDropdown),
      matching: find.byType(InkWell),
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final search = find.byType(TextField).last;
    final results = find.byType(ListView);
    final usd = find.descendant(
      of: results,
      matching: find.text('USD - US Dollar'),
    );

    await tester.enterText(search, 'usd');
    await tester.pump();
    expect(usd, findsOneWidget);
    expect(
      find.descendant(
        of: results,
        matching: find.text('INR - Indian Rupee'),
      ),
      findsNothing,
    );

    await tester.enterText(search, 'dollar');
    await tester.pump();
    expect(usd, findsOneWidget);

    await tester.tap(usd);
    await tester.pumpAndSettle();
    expect(selectedCurrency, 'USD');
    expect(formKey.currentState!.validate(), isTrue);

    final request = AdminPlanMutationRequest(
      name: 'Starter',
      durationDays: 30,
      price: 99,
      currency: selectedCurrency!,
    );
    expect(request.toJson()['currency'], 'USD');
  });
}
