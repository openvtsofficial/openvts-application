import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_plans_model.dart';
import 'package:open_vts/features/admin/screens/plans/widgets/admin_plan_form_sheet.dart';

void main() {
  testWidgets('Edit Plan preserves saved currency and updates draft code', (
    tester,
  ) async {
    const existingPlan = AdminPlan(
      id: 'plan-1',
      name: 'Starter',
      durationDays: 30,
      price: 99,
      currency: 'INR',
      createdAt: null,
      updatedAt: null,
    );
    String? draftCurrency = existingPlan.currency;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AdminPlanCurrencyDropdown(
              value: draftCurrency,
              currencies: const [
                AdminCurrencyOption(code: 'INR', name: 'Indian Rupee'),
                AdminCurrencyOption(code: 'USD', name: 'US Dollar'),
                AdminCurrencyOption(code: 'EUR', name: 'Euro'),
              ],
              onChanged: (value) => setState(() => draftCurrency = value),
            ),
          ),
        ),
      ),
    );

    expect(find.text('INR - Indian Rupee'), findsOneWidget);

    final trigger = find.descendant(
      of: find.byType(AdminPlanCurrencyDropdown),
      matching: find.byType(InkWell),
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final results = find.byType(ListView);
    expect(
      find.descendant(
        of: results,
        matching: find.text('INR - Indian Rupee'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: results,
        matching: find.text('USD - US Dollar'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: results,
        matching: find.text('EUR - Euro'),
      ),
      findsOneWidget,
    );

    final search = find.byType(TextField).last;
    await tester.enterText(search, 'usd');
    await tester.pump();
    final usd = find.descendant(
      of: results,
      matching: find.text('USD - US Dollar'),
    );
    expect(usd, findsOneWidget);

    await tester.enterText(search, 'dollar');
    await tester.pump();
    expect(usd, findsOneWidget);

    await tester.tap(usd);
    await tester.pumpAndSettle();

    expect(draftCurrency, 'USD');
    expect(existingPlan.currency, 'INR',
        reason: 'selection changes draft only');

    final update = AdminPlanMutationRequest(
      name: existingPlan.name,
      durationDays: existingPlan.durationDays!,
      price: existingPlan.price!,
      currency: draftCurrency!,
    );
    expect(update.toJson()['currency'], 'USD');
  });
}
