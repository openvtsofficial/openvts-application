import '../../features/auth/models/current_user.dart';
import '../../shared/models/user_role.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../api/api_exception.dart';
import 'mobile_access.dart';

class MobileAccessService {
  MobileAccessService(this._client);
  final ApiClient _client;
  Future<CurrentUser> loadAccess(CurrentUser user) async {
    if (user.role == UserRole.unknown) {
      throw const ApiException(message: 'This account role is not supported.');
    }
    if (user.role == UserRole.team || user.role.isUserWorkspace) {
      final response = await _client.get<MobileAccess>(
        user.role == UserRole.team
            ? ApiEndpoints.teamBootstrap
            : ApiEndpoints.userPermissions,
        parser: (value) {
          if (value is! Map) {
            throw const FormatException('Permissions response is unavailable');
          }
          final json = Map<String, dynamic>.from(value);
          return user.role == UserRole.team
              ? MobileAccess.team(json)
              : MobileAccess.user(json);
        },
      );
      return user.copyWith(access: response.data);
    }
    return user.copyWith(access: const MobileAccess.account());
  }
}
