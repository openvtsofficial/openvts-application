import 'package:flutter/material.dart';

import '../../../../../shared/helpers/mobile_text.dart';

/// Only local app messages are translated. Server validation text stays intact.
String adminUserAccessErrorLabel(
  BuildContext context,
  String? message,
) => switch (message) {
  'The server returned an unsupported permission catalog. Editing is disabled.' =>
    context.mobileText(
      'The server returned an unsupported permission catalog. Editing is disabled.',
    ),
  'The server returned an unsupported retention policy. Editing is disabled.' =>
    context.mobileText(
      'The server returned an unsupported retention policy. Editing is disabled.',
    ),
  'Your account does not have permission to view this section.' =>
    context.mobileText(
      'Your account does not have permission to view this section.',
    ),
  'Unable to load data retention' => context.mobileText(
    'Unable to load data retention',
  ),
  'Unable to save data retention' => context.mobileText(
    'Unable to save data retention',
  ),
  'Unable to save permissions' => context.mobileText(
    'Unable to save permissions',
  ),
  null || 'Unable to load' => context.mobileText('Unable to load'),
  _ => message,
};
