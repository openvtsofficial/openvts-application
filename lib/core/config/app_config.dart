import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static const appName = 'OpenVTS';
  static const defaultApiBaseUrl = 'https://app.openvts.io/api';

  static String get apiBaseUrl {
    const buildValue = String.fromEnvironment('API_BASE_URL');
    if (buildValue.trim().isNotEmpty) return buildValue.trim();
    final envValue = dotenv.env['API_BASE_URL'];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim();
    }

    return defaultApiBaseUrl;
  }

  static bool get useMockData {
    // A distributed build must never substitute sample data for server data.
    if (!kDebugMode) return false;
    final envValue = dotenv.env['USE_MOCK_DATA'];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim().toLowerCase() == 'true';
    }

    return const bool.fromEnvironment(
      'USE_MOCK_DATA',
      defaultValue: false,
    );
  }

  static String? validateApiBaseUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      return 'Enter a server URL without credentials, a query, or a fragment.';
    }
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        !kDebugMode &&
        uri.scheme != 'https') {
      return 'Use an HTTPS server with a valid certificate on iOS.';
    }
    return null;
  }

  // Public links only. These values are bundled in the app, never secrets.
  static const privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://openvts.io/privacy-policy',
  );
  static const supportUrl = String.fromEnvironment(
    'SUPPORT_URL',
    defaultValue: 'https://openvts.io/company/contact-us',
  );

  static String apiOriginBaseUrl() {
    final uri = Uri.parse(apiBaseUrl);
    return '${uri.scheme}://${uri.authority}';
  }

  // Reduced defaults to speed up UI failure feedback on mobile.
  static const connectTimeoutSeconds = 8;
  static const receiveTimeoutSeconds = 12;
}
