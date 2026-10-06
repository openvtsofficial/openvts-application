import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/admin/controllers/admin_user_permissions_controller.dart';
import 'package:open_vts/features/admin/controllers/admin_user_retention_controller.dart';
import 'package:open_vts/features/admin/models/admin_user_permissions.dart';
import 'package:open_vts/features/admin/models/admin_user_retention_policy.dart';
import 'package:open_vts/features/admin/services/admin_user_access_service.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

Map<String, dynamic> _permissions({bool workflow = false}) => {
  'catalogVersion': 1,
  'features': {
    for (final key in AdminUserPermissions.featureKeys)
      key: key != 'workflow' || workflow,
  },
  'reports': {for (final key in AdminUserPermissions.reportKeys) key: true},
};
Map<String, dynamic> _retention({int? configured = 365, int max = 90}) => {
  'globalRetentionDays': 180,
  'parentRetentionDays': max,
  'configuredRetentionDays': configured,
  'effectiveRetentionDays': configured == null || configured > max
      ? max
      : configured,
  'maxAllowedDays': max,
  'source': configured == null ? 'ADMIN' : 'USER',
  'isCapped': configured != null && configured > max,
};
CurrentUser _admin({String id = '11', UserRole role = UserRole.admin}) =>
    CurrentUser(
      id: id,
      name: 'Administrator',
      email: '',
      role: role,
      access: const MobileAccess.account(),
    );

void main() {
  late CurrentUser? principal;
  late Dio dio;
  late List<RequestOptions> requests;
  late Object? response;
  late Completer<void>? pending;
  late AdminUserAccessService service;
  setUp(() {
    principal = _admin();
    requests = [];
    response = _permissions();
    pending = null;
    dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            requests.add(options);
            await pending?.future;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'action': true, 'data': response},
              ),
            );
          },
        ),
      );
    service = AdminUserAccessService(
      ApiClient(dio, activeUser: () => principal),
    );
  });
  tearDown(() => dio.close(force: true));

  test('permission editor loads exact API, preserves Workflow and posts complete deny lists', () async {
    final controller = AdminUserPermissionsController(service, '42');
    addTearDown(controller.dispose);
    await controller.load();
    expect(controller.state.draft!.features['workflow'], false);
    controller.setFeature('vehicles', false);
    controller.setReport('distance', false);
    controller.setFeature('workflow', true);
    expect(controller.state.dirty, true);
    response = {
      ..._permissions(),
      'features': {..._permissions()['features'] as Map, 'vehicles': false},
      'reports': {..._permissions()['reports'] as Map, 'distance': false},
    };
    expect(await controller.save(), true);
    expect(requests.map((r) => '${r.method} ${r.path}'), [
      'GET /admin/users/42/permissions',
      'PUT /admin/users/42/permissions',
    ]);
    expect(requests.last.data, {
      'disabledFeatures': ['vehicles', 'workflow'],
      'disabledReports': ['distance'],
    });
    expect(controller.state.dirty, false);
  });

  test('disabled Reports freezes report-specific grants without losing their prior values', () async {
    final controller = AdminUserPermissionsController(service, '42');
    addTearDown(controller.dispose);
    await controller.load();
    controller.setFeature('reports', false);
    controller.setReport('distance', false);
    expect(controller.state.draft!.reports['distance'], true);
    controller.setFeature('reports', true);
    controller.setReport('distance', false);
    expect(controller.state.draft!.reports['distance'], false);
    controller.reset();
    expect(controller.state.dirty, false);
  });

  test('missing or future catalogs fail closed and cannot submit', () async {
    final controller = AdminUserPermissionsController(service, '42');
    addTearDown(controller.dispose);
    response = {..._permissions(), 'catalogVersion': 2};
    await controller.load();
    expect(controller.state.draft, isNull);
    expect(await controller.save(), false);
    expect(requests, hasLength(1));
    response = {
      ..._permissions(),
      'reports': {'distance': true},
    };
    await controller.load();
    expect(controller.state.draft, isNull);
  });

  for (final role in UserRole.values.where((r) => r != UserRole.admin)) {
    test(
      '${role.name} cannot read or write administrator-owned user access',
      () async {
        principal = _admin(role: role);
        final foreignService = AdminUserAccessService(
          ApiClient(dio, activeUser: () => principal),
        );
        await expectLater(
          foreignService.getPermissions('42'),
          throwsA(isA<ApiException>()),
        );
        await expectLater(
          foreignService.saveRetention('42', 30, maxDays: 90),
          throwsA(isA<ApiException>()),
        );
        expect(requests, isEmpty);
      },
    );
  }

  test(
    'principal change after load cannot submit a prior administrator draft',
    () async {
      final controller = AdminUserPermissionsController(service, '42');
      addTearDown(controller.dispose);
      await controller.load();
      controller.setFeature('maps', false);
      principal = _admin(id: '22');
      expect(await controller.save(), false);
      expect(requests, hasLength(1));
    },
  );

  test(
    'late permission reads are not exposed after principal changes',
    () async {
      final controller = AdminUserPermissionsController(service, '42');
      addTearDown(controller.dispose);
      pending = Completer<void>();
      final task = controller.load();
      await Future<void>.delayed(Duration.zero);
      principal = _admin(id: '22');
      pending!.complete();
      await task;
      expect(controller.state.draft, isNull);
    },
  );

  test('disposed permission controller accepts neither late state nor follow-up save', () async {
    final controller = AdminUserPermissionsController(service, '42');
    pending = Completer<void>();
    final task = controller.load();
    await Future<void>.delayed(Duration.zero);
    controller.dispose();
    pending!.complete();
    await expectLater(task, completes);
    expect(await controller.save(), false);
  });

  test(
    'Data Backup reflects parent cap and patches an inherited null reset',
    () async {
      response = _retention();
      final controller = AdminUserRetentionController(service, '42');
      addTearDown(controller.dispose);
      await controller.load();
      expect(controller.state.policy!.configuredDays, 365);
      expect(controller.state.days, 90);
      expect(controller.state.policy!.availableDays, [30, 90]);
      controller.select(180);
      expect(controller.state.days, 90);
      controller.select(null);
      response = _retention(configured: null);
      expect(await controller.save(), true);
      expect(requests.map((r) => '${r.method} ${r.path}'), [
        'GET /admin/users/42/data-retention',
        'PATCH /admin/users/42/data-retention',
      ]);
      expect(requests.last.data, {'retentionDays': null});
      expect(controller.state.policy!.source, 'ADMIN');
      expect(controller.state.dirty, false);
    },
  );

  test('Data Backup saves a bounded explicit period and refuses over-parent submissions', () async {
    response = _retention(configured: null);
    final controller = AdminUserRetentionController(service, '42');
    addTearDown(controller.dispose);
    await controller.load();
    controller.select(30);
    response = _retention(configured: 30);
    expect(await controller.save(), true);
    expect(requests.last.data, {'retentionDays': 30});
    await expectLater(
      service.saveRetention('42', 180, maxDays: 90),
      throwsA(isA<ApiException>()),
    );
    expect(requests, hasLength(2));
  });

  test('invalid retention policy and pending principal change never expose editable data', () async {
    final controller = AdminUserRetentionController(service, '42');
    addTearDown(controller.dispose);
    response = {..._retention(), 'effectiveRetentionDays': 3660};
    await controller.load();
    expect(controller.state.policy, isNull);
    response = _retention();
    pending = Completer<void>();
    final task = controller.load();
    await Future<void>.delayed(Duration.zero);
    principal = _admin(id: '22');
    pending!.complete();
    await task;
    expect(controller.state.policy, isNull);
  });

  test('custom inherited cap can be displayed without enabling invalid longer presets', () {
    final policy = AdminUserRetentionPolicy.fromJson(
      _retention(configured: 90, max: 45),
    );
    expect(policy.availableDays, [30, 45]);
    expect(policy.selectedDays, 45);
  });
}
