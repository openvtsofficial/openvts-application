import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../../shared/models/user_role.dart';
import 'security_service.dart';

final teamSettingsServiceProvider = Provider<TeamSettingsService>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return TeamSettingsService(ref.watch(apiClientProvider));
});

/// Personal Team settings never pass through tenant Admin settings endpoints.
class TeamSettingsService {
  TeamSettingsService(this._api);
  final ApiClient _api;
  void _requireTeam() {
    if (_api.activeRole != UserRole.team) {
      throw const ApiException(
        message: 'Team account required.',
        statusCode: 403,
      );
    }
  }

  Future<Map<String, dynamic>> profile() async {
    _requireTeam();
    return (await _api.get(
      '/team/profile',
      parser: SecurityService.payload,
    )).data;
  }

  Future<Map<String, dynamic>> localization() async {
    _requireTeam();
    return (await _api.get(
      '/team/localization',
      parser: SecurityService.payload,
    )).data;
  }

  Future<void> saveProfile(Map<String, dynamic> values) async {
    _requireTeam();
    await _api.patch('/team/profile', data: values, parser: (_) {});
  }

  Future<void> saveLocalization(Map<String, dynamic> values) async {
    _requireTeam();
    await _api.patch('/team/localization', data: values, parser: (_) {});
  }

  Future<void> changePassword(Map<String, String> values) async {
    _requireTeam();
    await _api.patch('/team/updatepassword', data: values, parser: (_) {});
  }
}
