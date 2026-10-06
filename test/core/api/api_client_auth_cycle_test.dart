import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/access/mobile_access.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/providers/shared_preferences_provider.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final role in UserRole.values.where((r) => r != UserRole.unknown)) {
    test(
      'synchronous $role API selection does not construct auth recursively',
      () async {
        dotenv.testLoad(fileInput: 'API_BASE_URL=https://server.example/api');
        SharedPreferences.setMockInitialValues({});
        FlutterSecureStorage.setMockInitialValues({});
        final storage = TokenStorage(const FlutterSecureStorage());
        final user = CurrentUser(
          id: '7',
          name: 'Account',
          email: '',
          role: role,
        );
        await storage.saveSessionForRole(
          role: role,
          accessToken: 'access',
          refreshToken: 'refresh',
          currentUserJson: jsonEncode(user.toJson()),
        );
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            tokenStorageProvider.overrideWithValue(storage),
          ],
        );
        addTearDown(container.dispose);
        final client = container.read(apiClientProvider);
        expect(client.activeRole, role);
        expect(
          container.exists(authControllerProvider),
          false,
          reason:
              'Role services must never construct their own auth dependency',
        );
        final verified = user.copyWith(access: const MobileAccess.account());
        storage.publishVerifiedUser(verified);
        expect(client.activeUser?.accessLoaded, true);
      },
    );
  }

  test('canonical roles and human readable aliases resolve safely', () {
    expect(UserRole.fromString('SUPERADMIN'), UserRole.superadmin);
    expect(UserRole.fromString('super admin'), UserRole.superadmin);
    expect(UserRole.fromString('sub user'), UserRole.subuser);
    expect(UserRole.fromString('sub-user'), UserRole.subuser);
    expect(UserRole.fromString('unexpected owner'), UserRole.unknown);
  });
}
