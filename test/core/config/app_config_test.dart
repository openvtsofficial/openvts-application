import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/config/app_config.dart';

void main() {
  setUp(() => dotenv.testLoad(fileInput: ''));

  test('missing configuration uses production data, never mock data', () {
    expect(AppConfig.useMockData, isFalse);
    expect(AppConfig.apiBaseUrl, 'https://app.openvts.io/api');
  });

  test('server URLs cannot carry credentials or token query parameters', () {
    for (final url in [
      'https://user:password@example.com/api',
      'https://example.com/api?token=secret',
      'https://example.com/api#token',
      '/api',
      'file:///tmp/api',
      'https://',
    ]) {
      expect(AppConfig.validateApiBaseUrl(url), isNotNull, reason: url);
    }
    expect(AppConfig.validateApiBaseUrl('https://fleet.example.com/api'), isNull);
    expect(AppConfig.validateApiBaseUrl('https://fleet.example.com:8443/v1/api'),
        isNull);
  });
}
