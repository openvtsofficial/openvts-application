enum SuperadminActivityCategory {
  all('', null),
  security('ADMIN.AUTH', 'ADMIN.AUTH'),
  settings('@SETTINGS', 'ADMIN.'),
  billing('@BILLING', 'ADMIN.'),
  vehicles('ADMIN.VEHICLE', 'ADMIN.VEHICLE'),
  drivers('ADMIN.DRIVER', 'ADMIN.DRIVER');

  const SuperadminActivityCategory(this.value, this.backendPrefix);

  final String value;
  final String? backendPrefix;

  bool get requiresClientAggregation =>
      this == SuperadminActivityCategory.settings ||
      this == SuperadminActivityCategory.billing;

  static SuperadminActivityCategory fromValue(String value) =>
      values.firstWhere(
        (category) => category.value == value,
        orElse: () => SuperadminActivityCategory.all,
      );

  bool matches(String action) {
    final normalized = action.trim().toUpperCase();
    if (this == SuperadminActivityCategory.all) return true;
    if (!requiresClientAggregation) {
      return normalized.startsWith(backendPrefix!);
    }

    final parts = normalized.split('.');
    if (parts.length < 2 || parts.first != 'ADMIN') return false;
    final resource = parts[1];
    if (this == SuperadminActivityCategory.billing &&
        normalized.startsWith('ADMIN.VEHICLES.RENEW')) {
      return true;
    }
    return switch (this) {
      SuperadminActivityCategory.settings => _settingsResources.any(
          (candidate) =>
              resource == candidate || resource.startsWith('${candidate}_'),
        ),
      SuperadminActivityCategory.billing => _billingResources.any(
          (candidate) =>
              resource == candidate || resource.startsWith('${candidate}_'),
        ),
      _ => false,
    };
  }
}

const _settingsResources = <String>{
  'PROFILE',
  'PASSWORD',
  'COMPANY',
  'OWN_COMPANY_DETAILS',
  'SMTP',
  'ADMIN_CONFIG',
  'LOCALIZATION',
  'WHITE_LABEL',
  'EMAIL_OTP',
  'WHATS_APP_OTP',
  'WHATSAPP_OTP',
};

const _billingResources = <String>{
  'PAYMENT',
  'TRANSACTION',
  'PRICING_PLAN',
  'VEHICLES_PAYMENT',
};

String? serializeActivityDateTime(DateTime? value) =>
    value?.toUtc().toIso8601String();
