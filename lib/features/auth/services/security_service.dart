import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/auth_api_error.dart';
import '../../../core/providers/core_providers.dart';

final securityServiceProvider = Provider<SecurityService>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return SecurityService(ref.watch(apiClientProvider));
});

class SecurityService {
  SecurityService(this._api);
  final ApiClient _api;
  Future<Map<String, dynamic>> status() async =>
      (await _api.get(AuthSecurityEndpoints.mfa, parser: payload)).data;
  Future<Map<String, dynamic>> tokens() async =>
      (await _api.get(AuthSecurityEndpoints.apiTokens, parser: payload)).data;
  Future<Map<String, dynamic>> enroll(Map<String, dynamic> proof) =>
      _post(AuthSecurityEndpoints.enroll, proof);
  Future<Map<String, dynamic>> confirm(String token, String code) => _post(
    AuthSecurityEndpoints.confirm,
    {'enrollmentToken': token, 'code': code.trim()},
  );
  Future<Map<String, dynamic>> change(
    String action,
    Map<String, dynamic> proof,
  ) {
    const routes = {
      'disable': AuthSecurityEndpoints.disable,
      'remove': AuthSecurityEndpoints.removeDevice,
      'recovery': AuthSecurityEndpoints.recoveryCodes,
    };
    final path = routes[action];
    if (path == null) throw ArgumentError.value(action);
    return _post(path, proof);
  }

  Future<Map<String, dynamic>> createToken(Map<String, dynamic> values) =>
      _post(AuthSecurityEndpoints.apiTokens, values);
  Future<void> revokeToken(String id) async {
    await _post(AuthSecurityEndpoints.revokeToken(id), {});
  }

  Future<void> deleteAccount(Map<String, dynamic> proof) async {
    final response = await _api.delete(
      AuthSecurityEndpoints.account,
      data: proof,
      parser: payload,
    );
    if (response.data['deleted'] != true) {
      throw const ApiException(
        message: 'The server did not confirm account deletion.',
      );
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async => (await _api.post(path, data: data, parser: payload)).data;
  static Map<String, dynamic> payload(dynamic json) {
    if (json is Map) return Map<String, dynamic>.from(json);
    throw const FormatException('Invalid security response.');
  }

  static String errorMessage(Object error) => AuthApiError.message(error);
}
