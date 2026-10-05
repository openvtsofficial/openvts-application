import '../../features/auth/models/current_user.dart';
import '../../shared/models/user_role.dart';

class PermissionHelper {
  const PermissionHelper._();

  /// A workspace prefix check, never an authorization decision.
  static bool canAccessPath(UserRole role, String path) =>
      role != UserRole.unknown &&
      (path == role.routePrefix || path.startsWith('${role.routePrefix}/'));
  static bool canAccessUserPath(CurrentUser? user, String path) =>
      user?.access.canAccessPath(user.role, path) ?? false;
  static bool canPerform(
    CurrentUser? user,
    String capability, {
    Set<String>? scopes,
  }) {
    if (user == null || !user.accessLoaded) return false;
    if (user.role == UserRole.admin || user.role == UserRole.superadmin) {
      return true;
    }
    if (user.role == UserRole.team) {
      final scope = user.access.grants[capability];
      return scope != null && (scopes == null || scopes.contains(scope));
    }
    return false;
  }
}
