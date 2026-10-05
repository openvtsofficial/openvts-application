import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/providers/core_providers.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/auth/controllers/auth_controller.dart';
import 'package:open_vts/features/auth/controllers/auth_state.dart';
import 'package:open_vts/features/auth/controllers/driver_settings_controller.dart';
import 'package:open_vts/features/auth/controllers/security_controller.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/features/auth/screens/driver_settings_screen.dart';
import 'package:open_vts/features/auth/screens/security_screen.dart';
import 'package:open_vts/features/auth/screens/team_settings_screen.dart';
import 'package:open_vts/features/auth/services/team_settings_service.dart';
import 'package:open_vts/features/user/controllers/user_providers.dart';
import 'package:open_vts/features/user/controllers/user_settings_controller.dart';
import 'package:open_vts/features/user/models/user_settings_model.dart';
import 'package:open_vts/features/user/models/user_settings_state.dart';
import 'package:open_vts/features/user/screens/settings/user_settings_screen.dart';
import 'package:open_vts/l10n/app_localizations.dart';
import 'package:open_vts/shared/models/user_role.dart';

class _Auth extends StateNotifier<AuthState> implements AuthController {
  _Auth(UserRole role)
    : super(
        AuthState.authenticated(
          CurrentUser(id: '7', name: 'Account', email: '', role: role),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Security extends StateNotifier<SecurityState>
    implements SecurityController {
  _Security()
    : super(
        const SecurityState(
          status: {'enabled': false, 'devices': []},
          tokens: {'tokens': []},
        ),
      );
  int loads = 0;
  @override
  Future<void> load() async {
    loads++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UserSettings extends StateNotifier<UserSettingsState>
    implements UserSettingsController {
  _UserSettings()
    : super(
        const UserSettingsState.initial().copyWith(
          profileErrorMessage: 'Profile temporarily unavailable',
        ),
      );
  @override
  void selectTab(UserSettingsTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnavailableTeam implements TeamSettingsService {
  @override
  Future<Map<String, dynamic>> profile() async =>
      throw StateError('Profile unavailable');
  @override
  Future<Map<String, dynamic>> localization() async =>
      throw StateError('Preferences unavailable');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnavailableDriver extends StateNotifier<DriverSettingsState>
    implements DriverSettingsController {
  _UnavailableDriver()
    : super(const DriverSettingsState(error: 'Account unavailable'));
  @override
  Future<void> load() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ApiClient _emptyReferenceClient() {
  final dio = Dio(BaseOptions(baseUrl: 'https://server.example/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (r, h) => h.resolve(
        Response(
          requestOptions: r,
          statusCode: 200,
          data: {'action': true, 'data': []},
        ),
      ),
    ),
  );
  return ApiClient(dio);
}

void main() {
  for (final role in [UserRole.team, UserRole.driver]) {
    testWidgets(
      '${role.name} failed initial load cannot save placeholder values and retains Security',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith((_) => _Auth(role)),
              securityControllerProvider.overrideWith((_) => _Security()),
              apiClientProvider.overrideWithValue(_emptyReferenceClient()),
              teamSettingsServiceProvider.overrideWithValue(_UnavailableTeam()),
              driverSettingsControllerProvider.overrideWith(
                (_) => _UnavailableDriver(),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: role == UserRole.team
                  ? const TeamSettingsScreen()
                  : const DriverSettingsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final save = find.byType(FilledButton);
        expect(save, findsOneWidget);
        expect(tester.widget<FilledButton>(save).onPressed, isNull);
        await tester.tap(find.text('Localization').first);
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNull,
        );
        await tester.tap(find.text('Security').first);
        await tester.pumpAndSettle();
        expect(find.text('Multi-factor authentication'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final role in UserRole.values.where((r) => r != UserRole.unknown)) {
    testWidgets(
      'Security is embeddable without an extra page for ${role.name}',
      (tester) async {
        final security = _Security();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith((_) => _Auth(role)),
              securityControllerProvider.overrideWith((_) => security),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: SingleChildScrollView(
                  child: SecurityScreen(embedded: true),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsNothing);
        expect(find.text('Multi-factor authentication'), findsOneWidget);
        expect(
          find.text('Delete my account'),
          role.isUserWorkspace ? findsOneWidget : findsNothing,
        );
        expect(security.loads, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('failed User profile leaves Settings Security tab usable', (
    tester,
  ) async {
    final security = _Security();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((_) => _Auth(UserRole.user)),
          securityControllerProvider.overrideWith((_) => security),
          userSettingsControllerProvider.overrideWith((_) => _UserSettings()),
          appDateFormatterProvider.overrideWithValue(
            const AppDateFormatter(datePattern: 'yyyy-MM-dd', use24Hour: true),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: UserSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Security'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Multi-factor authentication'), findsOneWidget);
    expect(find.text('Delete my account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
