import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/socket/socket_service.dart';

void main() {
  group('SocketService', () {
    test('disposed server cannot open another connection', () async {
      final storage = _HydratingTokenStorage();
      final service = SocketService(storage, apiBaseUrl: 'https://old.example/api');
      service.dispose();
      await expectLater(service.connect('/telemetry'), throwsStateError);
      expect(storage.hydrationCalls, 0);
    });

    test('server disposal during secure-storage hydration prevents socket open', () async {
      final storage = _HydratingTokenStorage();
      final service = SocketService(storage, apiBaseUrl: 'https://old.example/api');
      final connection = service.connect('/telemetry');
      final expectation = expectLater(connection, throwsStateError);
      service.dispose();
      storage.hydration.complete();
      await expectation;
      expect(storage.hydrationCalls, 1);
    });

    test('session change during hydration prevents stale connection open', () async {
      final storage = _HydratingTokenStorage();
      final service = SocketService(storage, apiBaseUrl: 'https://example.test/api');
      addTearDown(service.dispose);
      final connection = service.connect('/telemetry');
      final expectation = expectLater(connection, throwsStateError);
      storage.revision++;
      storage.hydration.complete();
      await expectation;
    });

    test('derives namespace URLs from API base without the REST /api path', () {
      expect(
        SocketService.socketUrlForApiBase(
          'https://app.openvts.io/api',
          '/telemetry',
        ),
        'https://app.openvts.io/telemetry',
      );
      expect(
        SocketService.socketUrlForApiBase(
          'https://app.openvts.io/api/',
          'notifications',
        ),
        'https://app.openvts.io/notifications',
      );
      expect(
        SocketService.socketUrlForApiBase('/api', '/telemetry'),
        '/telemetry',
      );
    });
  });
}

class _HydratingTokenStorage extends TokenStorage {
  _HydratingTokenStorage() : super(const FlutterSecureStorage());

  final hydration = Completer<void>();
  int hydrationCalls = 0;
  int revision = 0;

  @override
  bool get isCacheHydrated => false;

  @override
  int get sessionRevision => revision;

  @override
  String? get cachedActiveAccessToken => null;

  @override
  Future<void> hydrateCache() {
    hydrationCalls++;
    return hydration.future;
  }
}
