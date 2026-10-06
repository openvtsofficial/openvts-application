import '../../core/router/route_paths.dart';

/// The authenticated server role is never inferred from a route or username.
enum UserRole {
  superadmin,
  admin,
  team,
  user,
  subuser,
  driver,
  unknown;

  static UserRole fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'superadmin':
      case 'super_admin':
      case 'super admin':
      case 'super-admin':
        return superadmin;
      case 'admin':
        return admin;
      case 'team':
        return team;
      case 'user':
        return user;
      case 'subuser':
      case 'sub_user':
      case 'sub user':
      case 'sub-user':
        return subuser;
      case 'driver':
        return driver;
      default:
        return unknown;
    }
  }

  String get apiValue => name;
  bool get isUserWorkspace => this == user || this == subuser;
  bool get isAdminWorkspace => this == admin || this == team;
  // Team and Subuser share mobile screen trees, but retain their API identity.
  String get routePrefix => switch (this) {
    superadmin => RoutePaths.superadminHome,
    admin || team => RoutePaths.adminHome,
    user || subuser => RoutePaths.userHome,
    driver => RoutePaths.driverHome,
    unknown => '/unsupported-role',
  };
  String get homePath => this == unknown ? RoutePaths.login : routePrefix;
  String get profilePath => '$routePrefix/profile';
  String get settingsPath => '$routePrefix/settings';
  String get securityPath => '$settingsPath?tab=security';
  String get displayLabel => switch (this) {
    superadmin => 'Super Admin',
    admin => 'Admin',
    team => 'Team',
    user => 'User',
    subuser => 'Sub user',
    driver => 'Driver',
    unknown => 'Unsupported role',
  };
}
