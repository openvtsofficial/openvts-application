import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/providers/shared_preferences_provider.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/admin/controllers/admin_providers.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'actual Auth and ApiClient providers can load every formerly circular user detail tab',
    () async {
      dotenv.testLoad(fileInput: 'USE_MOCK_DATA=false');
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = TokenStorage(const FlutterSecureStorage());
      const user = CurrentUser(
        id: '11',
        name: 'Administrator',
        email: '',
        role: UserRole.admin,
      );
      await storage.saveSessionForRole(
        role: user.role,
        accessToken: 'access',
        refreshToken: 'refresh',
        currentUserJson: jsonEncode(user.toJson()),
      );
      final requests = <RequestOptions>[];
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              Object payload = [];
              if (options.path.endsWith('/users/42')) {
                payload = {'id': 42, 'name': 'Assigned user'};
              }
              if (options.path.endsWith('/payments')) {
                payload = {'items': [], 'total': 0, 'page': 1, 'limit': 100};
              }
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'action': true, 'data': payload},
                ),
              );
            },
          ),
        );
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          tokenStorageProvider.overrideWithValue(storage),
          dioProvider.overrideWithValue(dio),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(() => dio.close(force: true));
      // Keep the real dependency graph, including Auth -> ApiClient. An override
      // of auth or ApiClient would hide the original circular dependency.
      container.read(authControllerProvider);
      final provider = adminUserDetailsControllerProvider('42');
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      final controller = container.read(provider.notifier);
      await controller.loadProfile();
      await controller.loadVehicles();
      expect(container.read(provider).sectionErrorMessage, isNull);
      await controller.loadDrivers();
      expect(container.read(provider).sectionErrorMessage, isNull);
      await controller.loadTickets();
      expect(container.read(provider).sectionErrorMessage, isNull);
      await controller.loadPayments();
      expect(container.read(provider).sectionErrorMessage, isNull);
      expect(
        requests.map((r) => r.path),
        containsAll([
          '/admin/linkvehicles/42',
          '/admin/unlinkvehicles/42',
          '/admin/users/linkeddrivers/42',
          '/admin/users/unlinkeddrivers/42',
          '/admin/tickets',
          '/admin/payments',
        ]),
      );
    },
  );
}
