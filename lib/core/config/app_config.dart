import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static const appName = 'OpenVTS';
  static const defaultApiBaseUrl = 'https://app.openvts.io/api';

  /// Public OSRM-compatible routing endpoint, isolated from backend credentials.
  static const osrmBaseUrl = String.fromEnvironment(
    'OSRM_BASE_URL',
    defaultValue: 'https://router.project-osrm.org',
  );

  static String get apiBaseUrl {
    final envValue = dotenv.env['API_BASE_URL'];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim();
    }

    return const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: defaultApiBaseUrl,
    );
  }

  static bool get useMockData {
    final envValue = dotenv.env['USE_MOCK_DATA'];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim().toLowerCase() == 'true';
    }

    return const bool.fromEnvironment('USE_MOCK_DATA', defaultValue: false);
  }

  static String apiOriginBaseUrl() {
    final uri = Uri.parse(apiBaseUrl);
    return '${uri.scheme}://${uri.authority}';
  }

  // Reduced defaults to speed up UI failure feedback on mobile.
  static const connectTimeoutSeconds = 8;
  static const receiveTimeoutSeconds = 12;
}
