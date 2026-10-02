import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/demo/demo_session.dart';

void main() {
  test('parses and serializes the backend demo session contract', () {
    final session = DemoSession.fromJson(const <String, dynamic>{
      'user': <String, dynamic>{
        'id': 'demo-user',
        'role': 'DEMO',
        'name': 'Demo Fleet Manager',
        'email': 'demo@openvts.io',
        'companyName': 'Open VTS Demo Logistics',
      },
      'settings': <String, dynamic>{
        'languageCode': 'en',
        'theme': 'SYSTEM',
        'timezone': 'America/New_York',
      },
      'permissions': <String, dynamic>{
        'readOnly': true,
        'sendCommands': false,
        'createVehicles': false,
        'editVehicles': false,
        'deleteVehicles': false,
      },
    });

    expect(session.user.id, 'demo-user');
    expect(session.permissions.readOnly, isTrue);
    expect(session.permissions.sendCommands, isFalse);
    expect(
      DemoSession.fromJson(session.toJson()).user.name,
      'Demo Fleet Manager',
    );
  });

  test('rejects a session without a stable demo identity', () {
    expect(
      () => DemoSession.fromJson(const <String, dynamic>{
        'user': <String, dynamic>{},
      }),
      throwsFormatException,
    );
  });
}
