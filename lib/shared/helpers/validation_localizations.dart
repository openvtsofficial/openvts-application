import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'widget_localizations.dart';

/// Localizes only known application-authored validation rules at the UI edge.
/// Validation itself remains pure and English by default. Values submitted to
/// the server, arbitrary field names, and unrecognized messages are untouched.
extension ValidationLocalizations on BuildContext {
  FormFieldValidator<T>? localizedValidator<T>(
    FormFieldValidator<T>? validator,
  ) {
    if (validator == null) return null;
    return (value) => localizeValidationMessage(validator(value), widgetL10n);
  }
}

String? localizeValidationMessage(String? message, AppLocalizations l10n) {
  if (message == null || l10n.localeName.split('_').first == 'en') {
    return message;
  }
  // A punctuation variant is accepted for the login form, without rewriting
  // English tests or changing any underlying validation decision.
  final canonical = message.endsWith('.')
      ? message.substring(0, message.length - 1)
      : message;
  final exact = switch (canonical) {
    'Enter a valid email address' => l10n.validationValidEmail,
    'Enter a valid number' => l10n.validationValidNumber,
    'Credits cannot be negative' => l10n.validationNonnegativeCredits,
    'Please confirm the password' => l10n.validationConfirmPassword,
    'Passwords do not match' => l10n.validationPasswordsMismatch,
    'VIN must be 17 alphanumeric characters (excluding I, O, Q)' =>
      l10n.validationStandardVin,
    'VIN must contain only letters and numbers' =>
      l10n.validationVinAlphanumeric,
    _ => null,
  };
  if (exact != null) return exact;
  final required = RegExp(r'^(.+) is required$').firstMatch(canonical);
  if (required != null) {
    return l10n.validationRequired(_fieldLabel(required.group(1)!, l10n));
  }
  final ascii = RegExp(
    r'^(.+) (?:must contain ASCII characters only|must use English characters)$',
  ).firstMatch(canonical);
  if (ascii != null) {
    return l10n.validationAscii(_fieldLabel(ascii.group(1)!, l10n));
  }
  final minimum = RegExp(r'^Minimum (\d+) characters$').firstMatch(canonical);
  if (minimum != null) {
    return l10n.validationMinimumCharacters(int.parse(minimum.group(1)!));
  }
  final minLength = RegExp(
    r'^(.+) must be at least (\d+) (characters|digits)$',
  ).firstMatch(canonical);
  if (minLength != null) {
    final field = _fieldLabel(minLength.group(1)!, l10n);
    final count = int.parse(minLength.group(2)!);
    return minLength.group(3) == 'digits'
        ? l10n.validationMinDigits(field, count)
        : l10n.validationMinCharacters(field, count);
  }
  final maxLength = RegExp(
    r'^(.+) must be (\d+) (characters|digits) or fewer$',
  ).firstMatch(canonical);
  if (maxLength != null) {
    final field = _fieldLabel(maxLength.group(1)!, l10n);
    final count = int.parse(maxLength.group(2)!);
    return maxLength.group(3) == 'digits'
        ? l10n.validationMaxDigits(field, count)
        : l10n.validationMaxCharacters(field, count);
  }
  final numeric = RegExp(r'^(.+) must be numeric$').firstMatch(canonical);
  if (numeric != null) {
    return l10n.validationNumeric(_fieldLabel(numeric.group(1)!, l10n));
  }
  return message;
}

String _fieldLabel(String field, AppLocalizations l10n) => switch (field) {
  'This field' => l10n.validationThisField,
  'Email' => l10n.legacyUi84add5b295,
  'Name' => l10n.mobileName,
  'Username' => l10n.legacyUi84c29015de,
  'Address' => l10n.mobileAddress,
  'Pincode' => l10n.legacyUif2c5ca7b8c,
  'Full name' => l10n.legacyUieeb692087d,
  'Password' => l10n.legacyUi8be3c943b1,
  'Company name' => l10n.legacyUi1e5f7dc45c,
  'Mobile prefix' => l10n.legacyUi2ab961738f,
  'Mobile number' => l10n.mobileMobileNumber,
  'Vehicle name' => l10n.legacyUida83429197,
  'Plate number' => l10n.legacyUif2ce282e2d,
  'SIM number' => l10n.validationFieldSimNumber,
  'Title' => l10n.legacyUi768e0c1c69,
  'Credits' => l10n.legacyUibfac50d642,
  'Username or email' => l10n.legacyUi2c7ab350b3,
  _ => field,
};
