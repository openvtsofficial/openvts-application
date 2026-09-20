import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_endpoints.dart';
import 'package:open_vts/core/api/api_exception.dart';

void main() {
  group('ApiEndpoints', () {
    test('uses the backend refresh-token endpoint', () {
      expect(ApiEndpoints.auth.refreshToken, '/auth/refresh-token');
    });
  });

  group('ApiClient', () {
    test('parses raw profile maps outside the API envelope', () async {
      final client = ApiClient(_buildDio({'id': '42', 'name': 'Photo User'}));

      final response = await client.get<Map<String, dynamic>>(
        '/profile',
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response.success, isTrue);
      expect(response.data['id'], '42');
      expect(response.data['name'], 'Photo User');
    });

    test('parses non-map upload responses', () async {
      final client = ApiClient(_buildDio('uploaded'));

      final response = await client.post<bool>(
        '/upload',
        parser: (_) => true,
      );

      expect(response.success, isTrue);
      expect(response.data, isTrue);
      expect(response.message, 'uploaded');
    });

    test('keeps parsing enveloped responses', () async {
      final client = ApiClient(
        _buildDio({
          'status': 'success',
          'data': {'name': 'Envelope User'},
        }),
      );

      final response = await client.get<Map<String, dynamic>>(
        '/profile',
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response.success, isTrue);
      expect(response.data['name'], 'Envelope User');
    });

    test('parses implicit data envelopes without status', () async {
      final client = ApiClient(
        _buildDio({
          'data': {
            'calendar': {
              '2026-05-04': {
                'users': {'count': 5},
              },
            },
          },
        }),
      );

      final response = await client.get<Map<String, dynamic>>(
        '/calendar',
        parser: (json) => json as Map<String, dynamic>,
      );

      expect(response.success, isTrue);
      expect(response.data['calendar'], isA<Map<String, dynamic>>());
    });

    test('throws when an enveloped response has action false', () async {
      final client = ApiClient(
        _buildDio({
          'status': 'success',
          'data': {
            'action': false,
            'message': 'Type field is required',
            'data': null,
          },
        }),
      );

      await expectLater(
        client.post<bool>(
          '/upload',
          parser: (_) => true,
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Type field is required',
          ),
        ),
      );
    });

    test('preserves nested OTP configuration failure evidence', () async {
      final client = ApiClient(
        _buildDio({
          'status': 'success',
          'data': {
            'action': false,
            'message': 'SMTP Settings not found',
            'data': {'code': 'SMTP_NOT_CONFIGURED'},
          },
        }),
      );

      await expectLater(
        client.post<void>('/admin/profile/verify/email/request',
            parser: (_) {}),
        throwsA(
          isA<ApiException>()
              .having(
                (error) => error.message,
                'message',
                'SMTP Settings not found',
              )
              .having(
                (error) => error.details,
                'details',
                isA<Map<String, dynamic>>(),
              ),
        ),
      );
    });

    test('returns status and success only when OTP action is true', () async {
      final client = ApiClient(
        _buildDio({
          'status': 'success',
          'data': {
            'action': true,
            'message': 'OTP sent successfully',
            'data': null,
          },
        }),
      );

      final response = await client.post<void>(
        '/admin/profile/verify/whatsapp/request',
        parser: (_) {},
      );

      expect(response.success, isTrue);
      expect(response.statusCode, 200);
      expect(response.message, 'OTP sent successfully');
    });

    test('safe resolved URL excludes query parameters and credentials', () {
      final dio =
          Dio(BaseOptions(baseUrl: 'https://user:secret@example.com/api/'));
      final client = ApiClient(dio);

      expect(
        client.safeResolvedUrl('/admin/profile/verify/email/request?email=x'),
        'https://example.com/api/admin/profile/verify/email/request',
      );
    });

    test('preserves the configured API base path for leading-slash endpoints',
        () async {
      late Uri requestedUri;
      final dio = Dio(BaseOptions(baseUrl: 'https://app.openvts.io/api'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestedUri = options.uri;
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: <String, dynamic>{
                  'status': 'success',
                  'data': <String, dynamic>{
                    'action': true,
                    'message': 'Updated',
                    'data': null,
                  },
                },
              ),
            );
          },
        ),
      );

      await ApiClient(dio).patch<void>('/admin/profile', parser: (_) {});

      expect(
          requestedUri.toString(), 'https://app.openvts.io/api/admin/profile');
    });

    test('does not duplicate an API base path already present in endpoint', () {
      final client = ApiClient(
        Dio(BaseOptions(baseUrl: 'https://app.openvts.io/api')),
      );

      expect(
        client.safeResolvedUrl('/api/admin/profile'),
        'https://app.openvts.io/api/admin/profile',
      );
    });
  });
}

Dio _buildDio(dynamic body) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: body,
          ),
        );
      },
    ),
  );
  return dio;
}
