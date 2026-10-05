import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/shared/widgets/dashboard/open_vts_dashboard_metric_card.dart';

void main() {
  for (final scale in [1.0, 2.0, 3.0]) {
    testWidgets('dashboard metrics fit320px phone at ${scale}x text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) => GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: OpenVtsDashboardMetricCard.gridColumns(
                      context,
                      constraints.maxWidth,
                    ),
                    mainAxisExtent: OpenVtsDashboardMetricCard.gridExtent(
                      context,
                    ),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) => OpenVtsDashboardMetricCard(
                    title: 'Last Month Revenue',
                    value: '₹123,456,789.00',
                    subtitle: '6 pending invoices',
                    icon: Icons.receipt_long_outlined,
                    key: ValueKey('metric-$index'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('metric-5')),
        300,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
