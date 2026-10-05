import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import 'security_service.dart';

class DriverSettingsService {
  DriverSettingsService(this._api);
  final ApiClient _api;
  Future<Map<String, dynamic>> profile() async =>
      (await _api.get(AuthSecurityEndpoints.driverProfile,
              parser: SecurityService.payload))
          .data;
  Future<Map<String, dynamic>> settings() async =>
      (await _api.get(AuthSecurityEndpoints.driverSettings,
              parser: SecurityService.payload))
          .data;
  Future<void> saveProfile(Map<String, dynamic> values) async {
    await _api.patch(AuthSecurityEndpoints.driverProfile,
        data: values, parser: SecurityService.payload);
  }

  Future<void> saveSettings(Map<String, dynamic> values) async {
    await _api.patch(AuthSecurityEndpoints.driverSettings,
        data: values, parser: SecurityService.payload);
  }

  Future<void> changePassword(Map<String, String> values) async {
    await _api.patch(AuthSecurityEndpoints.driverPassword,
        data: values, parser: SecurityService.payload);
  }
}
