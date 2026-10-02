import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/admin/controllers/admin_inventory_controller.dart';
import 'package:open_vts/features/admin/controllers/admin_providers.dart';
import 'package:open_vts/features/admin/models/admin_inventory_model.dart';
import 'package:open_vts/features/admin/screens/inventory/widgets/admin_inventory_add_sheet.dart';
import 'package:open_vts/features/admin/services/admin_inventory_service.dart';

void main() {
  testWidgets('device type is disabled and shows loading before references',
      (tester) async {
    final service = _ReferenceService();
    await _pumpSheet(tester, service);

    expect(
        find.byKey(const Key('inventory-reference-loading')), findsOneWidget);
    expect(find.text('Loading device types...'), findsOneWidget);

    await tester.tap(find.text('Loading device types...'));
    await tester.pump();
    expect(find.text('No results'), findsNothing);
  });

  testWidgets('async options appear and require an explicit stable selection',
      (tester) async {
    final service = _ReferenceService();
    await _pumpSheet(tester, service);

    service.completeSuccess();
    await tester.pumpAndSettle();

    expect(find.text('Select device type'), findsOneWidget);
    await tester.tap(find.text('Select device type'));
    await tester.pumpAndSettle();
    expect(find.text('Tracker A'), findsOneWidget);
    expect(find.text('Tracker B'), findsOneWidget);

    await tester.tap(find.text('Tracker B'));
    await tester.pumpAndSettle();
    expect(find.text('Tracker B'), findsOneWidget);

    await tester.tap(find.text('SIM Only'));
    await tester.tap(find.text('Device Only'));
    await tester.pump();
    expect(find.text('Tracker B'), findsOneWidget);
  });

  testWidgets('reference error exposes retry and loads fresh options',
      (tester) async {
    final service = _ReferenceService();
    await _pumpSheet(tester, service);

    service.completeError();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inventory-reference-error')), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(
        find.byKey(const Key('inventory-reference-loading')), findsOneWidget);

    service.completeSuccess();
    await tester.pumpAndSettle();
    expect(find.text('Select device type'), findsOneWidget);
    expect(find.byKey(const Key('inventory-reference-error')), findsNothing);
  });
}

Future<void> _pumpSheet(
  WidgetTester tester,
  _ReferenceService service,
) async {
  final controller = AdminInventoryController(service: service);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        adminInventoryControllerProvider.overrideWith((ref) => controller),
      ],
      child: const MaterialApp(
        home: Scaffold(body: AdminInventoryAddSheet()),
      ),
    ),
  );
  await tester.pump();
}

class _ReferenceService extends AdminInventoryService {
  _ReferenceService() : super(ApiClient(Dio()));

  Completer<List<AdminDeviceTypeOption>> _deviceTypes = Completer();
  Completer<List<AdminSimProviderOption>> _providers = Completer();

  @override
  Future<List<AdminDeviceTypeOption>> getDeviceTypes() => _deviceTypes.future;

  @override
  Future<List<AdminSimProviderOption>> getSimProviders() => _providers.future;

  void completeSuccess() {
    _deviceTypes.complete(const [
      AdminDeviceTypeOption(id: '1', name: 'Tracker A', slug: 'tracker-a'),
      AdminDeviceTypeOption(id: '2', name: 'Tracker B', slug: 'tracker-b'),
    ]);
    _providers.complete(const <AdminSimProviderOption>[]);
    _resetCompleters();
  }

  void completeError() {
    _deviceTypes.completeError(Exception('reference failure'));
    _providers.complete(const <AdminSimProviderOption>[]);
    _resetCompleters();
  }

  void _resetCompleters() {
    _deviceTypes = Completer<List<AdminDeviceTypeOption>>();
    _providers = Completer<List<AdminSimProviderOption>>();
  }
}
