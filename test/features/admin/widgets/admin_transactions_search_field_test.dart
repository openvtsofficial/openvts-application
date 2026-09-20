import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/screens/transactions/admin_transactions_screen.dart';

void main() {
  testWidgets('transaction search is trimmed and debounced once',
      (tester) async {
    final searches = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminTransactionsSearchField(
            currentQuery: '',
            onSearch: (query) async => searches.add(query),
          ),
        ),
      ),
    );

    final search = find.byType(TextField);
    expect(search, findsOneWidget);
    expect(
      tester.widget<TextField>(search).decoration?.hintText,
      'Search transactions...',
    );

    await tester.enterText(search, ' inv');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(search, ' invoice-42 ');
    await tester.pump(const Duration(milliseconds: 349));
    expect(searches, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
    expect(searches, ['invoice-42']);
  });
}
