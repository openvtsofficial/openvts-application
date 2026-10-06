import '../../../core/api/api_exception.dart';

class AdminUserRetentionPolicy {
  const AdminUserRetentionPolicy({
    required this.globalDays,
    required this.parentDays,
    required this.configuredDays,
    required this.effectiveDays,
    required this.maxDays,
    required this.source,
    required this.isCapped,
  });
  static const durations = [30, 90, 180, 365, 730, 1095, 1825, 3650];
  final int globalDays, parentDays, effectiveDays, maxDays;
  final int? configuredDays;
  final String source;
  final bool isCapped;
  int? get selectedDays => configuredDays == null
      ? null
      : [
          configuredDays!,
          effectiveDays,
          maxDays,
        ].reduce((a, b) => a < b ? a : b);
  List<int> get availableDays =>
      (durations.where((days) => days <= maxDays).toSet()
            ..addAll([if (selectedDays != null) selectedDays!]))
          .toList()
        ..sort();

  factory AdminUserRetentionPolicy.fromJson(Map<String, dynamic> json) {
    bool valid(Object? value) => value is int && value >= 30 && value <= 3650;
    if (![
          'globalRetentionDays',
          'parentRetentionDays',
          'effectiveRetentionDays',
          'maxAllowedDays',
        ].every((key) => valid(json[key])) ||
        (json['configuredRetentionDays'] != null &&
            !valid(json['configuredRetentionDays'])) ||
        !['GLOBAL', 'ADMIN', 'USER'].contains(json['source']) ||
        json['isCapped'] is! bool ||
        (json['effectiveRetentionDays'] as int) >
            (json['maxAllowedDays'] as int)) {
      throw const ApiException(
        message: 'The server returned an unsupported retention policy. Editing is disabled.',
      );
    }
    return AdminUserRetentionPolicy(
      globalDays: json['globalRetentionDays'] as int,
      parentDays: json['parentRetentionDays'] as int,
      configuredDays: json['configuredRetentionDays'] as int?,
      effectiveDays: json['effectiveRetentionDays'] as int,
      maxDays: json['maxAllowedDays'] as int,
      source: json['source'] as String,
      isCapped: json['isCapped'] as bool,
    );
  }
}
