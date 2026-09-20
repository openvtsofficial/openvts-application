import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/superadmin/models/superadmin_settings_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_settings_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Map<String, dynamic> _notConfiguredEnvelope() => <String, dynamic>{
      'action': false,
      'message': 'SMTP Settings not found',
    };

Map<String, dynamic> _successEnvelope(dynamic data, [String msg = 'ok']) =>
    <String, dynamic>{'action': true, 'message': msg, 'data': data};

Map<String, dynamic> _minimalSmtpJson({int id = 1}) => <String, dynamic>{
      'id': id,
      'senderName': 'OpenVTS',
      'host': 'smtp.example.com',
      'port': '587',
      'email': 'noreply@example.com',
      'type': 'TLS',
      'username': 'apikey',
      'password': 's3cr3t',
      'isActive': true,
    };

/// Creates a Dio that intercepts GET /superadmin/smtpsettings and
/// optionally PATCH /superadmin/smtpsettings.
Dio _smtpDio({
  required dynamic Function(RequestOptions) onGet,
  dynamic Function(RequestOptions)? onPatch,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://app.openvts.io/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.method == 'PATCH') {
          final result = onPatch?.call(options);
          if (result is DioException) {
            handler.reject(result);
          } else {
            handler.resolve(Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: result ?? _successEnvelope(null, 'Updated'),
            ));
          }
          return;
        }
        // GET
        final result = onGet(options);
        if (result is DioException) {
          handler.reject(result);
        } else {
          handler.resolve(Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: result,
          ));
        }
      },
    ),
  );
  return dio;
}

SuperadminSettingsService _serviceWith(Dio dio) =>
    SuperadminSettingsService(ApiClient(dio));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // A. Unconfigured: action:false + "SMTP Settings not found"
  //    → returns empty default model, does NOT throw
  // -------------------------------------------------------------------------
  group('getSmtpSettings — unconfigured (action:false, "not found")', () {
    test('returns empty SuperadminSmtpSettings without throwing', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (_) => _notConfiguredEnvelope(),
      ));

      final result = await service.getSmtpSettings();

      expect(result.id, isNull);
      expect(result.host, isNull);
      expect(result.email, isNull);
      expect(result.isActive, isFalse);
      expect(result.type, SuperadminSmtpType.none);
    });

    test('message casing variant is handled', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (_) => <String, dynamic>{
          'action': false,
          'message': 'smtp settings not found',
        },
      ));

      final result = await service.getSmtpSettings();
      expect(result.id, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // B. Configured envelope → returns fully-parsed settings
  // -------------------------------------------------------------------------
  group('getSmtpSettings — configured envelope', () {
    test('parses id, host, port, email, type, username, isActive', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (_) => _successEnvelope(_minimalSmtpJson()),
      ));

      final result = await service.getSmtpSettings();

      expect(result.id, 1);
      expect(result.host, 'smtp.example.com');
      expect(result.port, '587');
      expect(result.email, 'noreply@example.com');
      expect(result.type, SuperadminSmtpType.tls);
      expect(result.username, 'apikey');
      expect(result.isActive, isTrue);
    });

    test('senderName field is parsed', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (_) => _successEnvelope(_minimalSmtpJson()),
      ));

      final result = await service.getSmtpSettings();
      expect(result.senderName, 'OpenVTS');
    });
  });

  // -------------------------------------------------------------------------
  // C. Unrelated action:false → NOT suppressed, exception propagates
  // -------------------------------------------------------------------------
  group('getSmtpSettings — unrelated action:false error', () {
    test('re-throws when message is not the "not found" sentinel', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (_) => <String, dynamic>{
          'action': false,
          'message': 'Forbidden',
        },
      ));

      await expectLater(
        service.getSmtpSettings(),
        throwsA(isA<ApiException>()),
      );
    });

    test('re-throws when action is false but message is empty', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (_) => <String, dynamic>{
          'action': false,
          'message': '',
        },
      ));

      await expectLater(
        service.getSmtpSettings(),
        throwsA(isA<ApiException>()),
      );
    });

    test('network error (DioException) still propagates', () async {
      final service = _serviceWith(_smtpDio(
        onGet: (opts) => DioException(
          requestOptions: opts,
          type: DioExceptionType.connectionError,
        ),
      ));

      await expectLater(
        service.getSmtpSettings(),
        throwsA(isA<DioException>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // D. Save then reload: PATCH succeeds, subsequent GET returns persisted data
  // -------------------------------------------------------------------------
  group('updateSmtpSettings + getSmtpSettings — save/reload sequence', () {
    test('GET after PATCH returns the persisted settings', () async {
      var patchCalled = false;

      final service = _serviceWith(_smtpDio(
        onGet: (_) => _successEnvelope(_minimalSmtpJson(id: 5)),
        onPatch: (_) {
          patchCalled = true;
          return _successEnvelope(null, 'Updated');
        },
      ));

      await service.updateSmtpSettings(const SuperadminSmtpSettings(
        senderName: 'OpenVTS',
        host: 'smtp.example.com',
        port: '587',
        email: 'noreply@example.com',
        type: SuperadminSmtpType.tls,
        username: 'apikey',
        password: 's3cr3t',
        isActive: true,
      ));
      expect(patchCalled, isTrue);

      final reloaded = await service.getSmtpSettings();
      expect(reloaded.id, 5);
      expect(reloaded.host, 'smtp.example.com');
      expect(reloaded.isActive, isTrue);
    });
  });
}
