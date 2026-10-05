import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/storage/local_cache.dart';
import 'package:open_vts/core/storage/storage_keys.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/auth/screens/api_base_url_settings_screen.dart';
import 'package:open_vts/shared/models/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'changing server clears all issuer credentials before URL update',
    (tester) async {
      dotenv.testLoad(fileInput: 'API_BASE_URL=https://default.example/api');
      SharedPreferences.setMockInitialValues({
        StorageKeys.apiBaseUrlOverride: 'https://old.example/api',
      });
      FlutterSecureStorage.setMockInitialValues({});
      final storage = TokenStorage(const FlutterSecureStorage());
      await storage.saveSessionForRole(
        role: UserRole.user,
        accessToken: 'old-server-token',
        refreshToken: 'old-server-refresh',
        currentUserJson: jsonEncode(
          const CurrentUser(
            id: '7',
            name: 'User',
            email: '',
            role: UserRole.user,
          ).toJson(),
        ),
      );
      final server = ApiBaseUrlController(
        LocalCache(await SharedPreferences.getInstance()),
      );
      final auth = _SwitchAuth(storage, server);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiBaseUrlProvider.overrideWith((ref) => server),
            authControllerProvider.overrideWith((ref) => auth),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const ApiBaseUrlSettingsScreen(),
                    ),
                  ),
                  child: const Text('Open settings'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField),
        'https://new.example/api',
      );
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(auth.oldServerAtClear, 'https://old.example/api');
      expect(auth.loadingDuringClear, false);
      expect(server.state, 'https://new.example/api');
      expect(await storage.getActiveSession(), isNull);
      expect(tester.takeException(), isNull);
    },
  );
}

class _SwitchAuth extends StateNotifier<AuthState> implements AuthController {
  _SwitchAuth(this.storage, this.server)
    : super(const AuthState.unauthenticated());
  final TokenStorage storage;
  final ApiBaseUrlController server;
  String? oldServerAtClear;
  bool? loadingDuringClear;
  @override
  Future<void> logoutAllRoles({
    bool deregisterPush = true,
    bool showLoading = true,
  }) async {
    oldServerAtClear = server.state;
    loadingDuringClear = showLoading;
    await storage.clearAllSessions();
    state = const AuthState.unauthenticated();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
