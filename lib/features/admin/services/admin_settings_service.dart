import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_options.dart';
import '../models/admin_settings_model.dart';

class AdminSettingsService {
  AdminSettingsService(this._apiClient);

  final ApiClient _apiClient;

  static final Options _readOptions = normalReadOptions();
  static final Options _mutationOptions = normalWriteOptions();
  static final Options _multipartOptions = uploadOptions().copyWith(
    contentType: Headers.multipartFormDataContentType,
  );

  Future<AdminProfileSettings> getProfile() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.admin.profile,
        options: _readOptions,
        parser: (json) => json,
      );
      _logProfileRequest(
        method: 'GET',
        statusCode: response.statusCode,
        message: response.message,
      );
      return AdminProfileSettings.fromJson(response.data);
    } catch (error) {
      _logProfileFailure(method: 'GET', error: error);
      rethrow;
    }
  }

  Future<AdminProfileSettings> updateProfile(
    AdminUpdateProfileRequest request,
  ) async {
    try {
      final response = await _apiClient.patch<void>(
        ApiEndpoints.admin.profile,
        data: request.toJson(),
        options: _mutationOptions,
        parser: (_) {},
      );
      _logProfileRequest(
        method: 'PATCH',
        statusCode: response.statusCode,
        message: response.message,
      );
    } catch (error) {
      _logProfileFailure(method: 'PATCH', error: error);
      throw _profileApiException('Unable to save profile', error);
    }

    try {
      return await getProfile();
    } catch (error) {
      throw _profileApiException('Profile saved, but refresh failed', error);
    }
  }

  void _logProfileRequest({
    required String method,
    required int? statusCode,
    String? message,
  }) {
    debugPrint(
      '[admin-settings-profile] method=$method '
      'url=${_apiClient.safeResolvedUrl(ApiEndpoints.admin.profile)} '
      'status=${statusCode ?? 'unknown'} '
      'message=${_sanitizeProfileDiagnostic(message ?? '')}',
    );
  }

  void _logProfileFailure({required String method, required Object error}) {
    final statusCode = switch (error) {
      ApiException exception => exception.statusCode,
      DioException exception => exception.response?.statusCode,
      _ => null,
    };
    _logProfileRequest(
      method: method,
      statusCode: statusCode,
      message: _safeProfileErrorMessage(error),
    );
  }

  ApiException _profileApiException(String prefix, Object error) {
    final statusCode = switch (error) {
      ApiException exception => exception.statusCode,
      DioException exception => exception.response?.statusCode,
      _ => null,
    };
    return ApiException(
      message: '$prefix: ${_safeProfileErrorMessage(error)}',
      statusCode: statusCode,
    );
  }

  static String _safeProfileErrorMessage(Object error) {
    if (error is ApiException && error.message.trim().isNotEmpty) {
      return error.message.trim();
    }
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final nested = data['data'];
        if (nested is Map) {
          final message = nested['message']?.toString().trim();
          if (message != null && message.isNotEmpty) return message;
        }
        final message = data['message']?.toString().trim();
        if (message != null && message.isNotEmpty) return message;
      }
      if (error.response?.statusCode == 404) return 'Route not found';
    }
    return 'Request failed';
  }

  static String _sanitizeProfileDiagnostic(String value) {
    return value
        .replaceAll(RegExp(r'[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}'), '[redacted]')
        .replaceAll(RegExp(r'\+?\d[\d\s()-]{6,}\d'), '[redacted]')
        .trim();
  }

  Future<void> updateCompany(AdminUpdateCompanyRequest request) async {
    await _apiClient.patch<void>(
      ApiEndpoints.admin.companyDetails,
      data: request.toJson(),
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<void> changePassword(AdminChangePasswordRequest request) async {
    await _apiClient.patch<void>(
      ApiEndpoints.admin.updatePassword,
      data: request.toJson(),
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<AdminProfileSettings> uploadProfilePhoto({
    required List<int> bytes,
    required String fileName,
  }) async {
    final formData = FormData();
    formData.fields.add(const MapEntry('type', 'PROFILE'));
    formData.files.add(
      MapEntry(
        'file',
        MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: _guessContentType(fileName),
        ),
      ),
    );
    await _apiClient.post<void>(
      ApiEndpoints.admin.uploadProfile,
      data: formData,
      options: _multipartOptions,
      parser: (_) {},
    );
    return getProfile();
  }

  Future<void> requestEmailOtp() async {
    await _requestOtp(
      channel: 'email',
      endpoint: ApiEndpoints.admin.profileVerifyEmailRequest,
    );
  }

  Future<void> confirmEmailOtp(String otp) async {
    await _apiClient.post<void>(
      ApiEndpoints.admin.profileVerifyEmailConfirm,
      data: {'otp': otp},
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<void> requestWhatsAppOtp() async {
    await _requestOtp(
      channel: 'whatsapp',
      endpoint: ApiEndpoints.admin.profileVerifyWhatsAppRequest,
    );
  }

  Future<void> _requestOtp({
    required String channel,
    required String endpoint,
  }) async {
    final safeUrl = _apiClient.safeResolvedUrl(endpoint);
    try {
      final response = await _apiClient.post<dynamic>(
        endpoint,
        options: _mutationOptions,
        parser: (json) => json,
      );
      debugPrint(
        '[admin-settings-otp] channel=$channel url=$safeUrl '
        'status=${response.statusCode ?? 'unknown'} '
        'business=${_safeOtpBusinessResponse(action: true, message: response.message)}',
      );
    } on ApiException catch (error) {
      debugPrint(
        '[admin-settings-otp] channel=$channel url=$safeUrl '
        'status=${error.statusCode ?? 'unknown'} '
        'business=${_safeOtpBusinessResponseFromError(error)}',
      );
      rethrow;
    }
  }

  static String _safeOtpBusinessResponseFromError(ApiException error) {
    final details = error.details;
    final root = details is Map ? details : const <dynamic, dynamic>{};
    final nestedValue = root['data'];
    final nested =
        nestedValue is Map ? nestedValue : const <dynamic, dynamic>{};
    final payloadValue = nested['data'];
    final payload =
        payloadValue is Map ? payloadValue : const <dynamic, dynamic>{};
    final action = nested['action'] ?? root['action'];
    final code = payload['code'] ?? nested['code'] ?? root['code'];
    final message = nested['message'] ?? root['message'] ?? error.message;
    return _safeOtpBusinessResponse(
      action: action == true,
      code: code?.toString(),
      message: message?.toString(),
    );
  }

  static String _safeOtpBusinessResponse({
    required bool action,
    String? code,
    String? message,
  }) {
    final safeCode = code?.trim();
    final safeMessage = message?.trim();
    return <String>[
      'action:$action',
      if (safeCode != null && safeCode.isNotEmpty) 'code:$safeCode',
      if (safeMessage != null && safeMessage.isNotEmpty)
        'message:${_sanitizeOtpDiagnostic(safeMessage)}',
    ].join(',');
  }

  static String _sanitizeOtpDiagnostic(String value) {
    return value
        .replaceAll(RegExp(r'[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}'), '[redacted]')
        .replaceAll(RegExp(r'\+?\d[\d\s()-]{6,}\d'), '[redacted]')
        .replaceAll(RegExp(r'\b\d{4,8}\b'), '[redacted]');
  }

  Future<void> confirmWhatsAppOtp(String otp) async {
    await _apiClient.post<void>(
      ApiEndpoints.admin.profileVerifyWhatsAppConfirm,
      data: {'otp': otp},
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<bool> getEmailSubscription() async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.admin.profileEmailSubscription,
      options: _readOptions,
      parser: (json) => json,
    );
    final data = response.data;
    if (data is bool) return data;
    if (data is Map) {
      final map = data.cast<String, dynamic>();
      for (final key in const ['isSubscribed', 'subscribed', 'value']) {
        final value = map[key];
        if (value is bool) return value;
        if (value is num) return value != 0;
        if (value is String) {
          final normalized = value.trim().toLowerCase();
          if (normalized == 'true' || normalized == '1') return true;
          if (normalized == 'false' || normalized == '0') return false;
        }
      }
      final inner = map['data'];
      if (inner is bool) return inner;
    }
    return false;
  }

  Future<void> subscribeEmail() async {
    await _apiClient.post<void>(
      ApiEndpoints.admin.profileEmailSubscribe,
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<AdminLocalizationSettings> getLocalization() async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.admin.localization,
      options: _readOptions,
      parser: (json) => json,
    );
    return AdminLocalizationSettings.fromJson(response.data);
  }

  Future<void> updateLocalization(AdminLocalizationSettings request) async {
    await _apiClient.patch<void>(
      ApiEndpoints.admin.localization,
      data: request.toJson(),
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<List<AdminLanguageOption>> getLanguages() async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.public.languages,
      options: _readOptions,
      parser: (json) => json,
    );
    return AdminLanguageOption.listFromJson(response.data);
  }

  Future<List<AdminDateFormatOption>> getDateFormats() async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.public.dateFormats,
      options: _readOptions,
      parser: (json) => json,
    );
    return AdminDateFormatOption.listFromJson(response.data);
  }

  Future<List<String>> getTimezones() async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.public.timezones,
      options: _readOptions,
      parser: (json) => json,
    );
    return _coerceStringList(response.data);
  }

  Future<AdminSmtpSettings> getSmtpSettings() async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.admin.smtpConfig,
      options: _readOptions,
      parser: (json) => json,
    );
    return AdminSmtpSettings.fromJson(response.data);
  }

  Future<void> updateSmtpSettings(AdminSmtpSettings request) async {
    await _apiClient.patch<void>(
      ApiEndpoints.admin.smtpConfig,
      data: request.toJson(),
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  Future<void> testSmtp(String email) async {
    await _apiClient.post<void>(
      ApiEndpoints.admin.testSmtp,
      data: email.trim(),
      options: _mutationOptions,
      parser: (_) {},
    );
  }

  static List<String> _coerceStringList(dynamic data) {
    List<dynamic>? list;
    if (data is List) {
      list = data;
    } else if (data is Map) {
      for (final key in const ['data', 'items', 'timezones', 'list']) {
        final value = data[key];
        if (value is List) {
          list = value;
          break;
        }
      }
    }
    if (list == null) return const <String>[];
    return list
        .map((entry) {
          if (entry is String) return entry;
          if (entry is Map) {
            final map = entry.cast<String, dynamic>();
            for (final key in const ['value', 'name', 'code', 'label']) {
              final value = map[key];
              if (value is String && value.trim().isNotEmpty) {
                return value;
              }
            }
          }
          return entry?.toString() ?? '';
        })
        .where((value) => value.trim().isNotEmpty)
        .toList(growable: false);
  }

  static MediaType? _guessContentType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }
    if (lower.endsWith('.webp')) return MediaType('image', 'webp');
    return null;
  }
}
