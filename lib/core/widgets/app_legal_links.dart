import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';

/// Available before sign-in and in account settings.
class AppLegalLinks extends StatelessWidget {
  const AppLegalLinks({super.key});

  Future<void> _open(BuildContext context, String value) async {
    final uri = Uri.tryParse(value);
    try {
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          !await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
        throw StateError('Link unavailable');
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open this page. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        TextButton(
          onPressed: () => _open(context, AppConfig.privacyPolicyUrl),
          child: const Text('Privacy policy'),
        ),
        TextButton(
          onPressed: () => _open(context, AppConfig.supportUrl),
          child: const Text('Support'),
        ),
      ],
    );
  }
}
