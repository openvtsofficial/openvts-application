import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/models/admin_drivers_model.dart';
import '../../features/admin/models/admin_users_model.dart';
import '../../features/admin/models/admin_vehicle_model.dart';
import '../../features/admin/screens/admin_home_screen.dart';
import '../../features/admin/screens/admin_shell.dart';
import '../../features/admin/screens/calendar/admin_calendar_screen.dart';
import '../../features/admin/screens/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/screens/drivers/admin_driver_details_screen.dart';
import '../../features/admin/screens/drivers/admin_drivers_screen.dart';
import '../../features/admin/screens/inventory/admin_inventory_screen.dart';
import '../../features/admin/screens/logs/admin_logs_screen.dart';
import '../../features/admin/screens/map/admin_map_screen.dart';
import '../../features/admin/screens/notifications/admin_notifications_screen.dart';
import '../../features/admin/screens/payments/admin_payments_screen.dart';
import '../../features/admin/screens/plans/admin_plans_screen.dart';
import '../../features/admin/screens/settings/admin_settings_screen.dart';
import '../../features/admin/screens/support/admin_create_support_ticket_screen.dart';
import '../../features/admin/screens/support/admin_support_screen.dart';
import '../../features/admin/screens/team/admin_team_screen.dart';
import '../../features/admin/screens/users/admin_create_user_screen.dart';
import '../../features/admin/screens/users/admin_user_details_screen.dart';
import '../../features/admin/screens/users/admin_users_screen.dart';
import '../../features/admin/screens/vehicles/admin_create_vehicle_screen.dart';
import '../../features/admin/screens/vehicles/admin_vehicle_details_screen.dart';
import '../../features/admin/screens/vehicles/admin_vehicles_screen.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/controllers/auth_state.dart';
import '../../features/auth/screens/api_base_url_settings_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/superadmin/models/superadmin_administrator_model.dart';
import '../../features/superadmin/screens/administrators/superadmin_admin_details_screen.dart';
import '../../features/superadmin/screens/administrators/superadmin_administrators_screen.dart';
import '../../features/superadmin/screens/administrators/superadmin_create_admin_screen.dart';
import '../../features/superadmin/screens/calendar/superadmin_calendar_screen.dart';
import '../../features/superadmin/screens/dashboard/superadmin_dashboard_screen.dart';
import '../../features/superadmin/screens/map/superadmin_map_screen.dart';
import '../../features/superadmin/screens/notifications/superadmin_notifications_screen.dart';
import '../../features/superadmin/screens/payments/superadmin_payments_screen.dart';
import '../../features/superadmin/screens/server/superadmin_server_screen.dart';
import '../../features/superadmin/screens/settings/superadmin_settings_screen.dart';
import '../../features/superadmin/screens/superadmin_home_screen.dart';
import '../../features/superadmin/screens/superadmin_shell.dart';
import '../../features/superadmin/screens/support/superadmin_create_support_ticket_screen.dart';
import '../../features/superadmin/screens/support/superadmin_support_screen.dart';
import '../../features/superadmin/screens/vehicles/superadmin_vehicles_screen.dart';
import '../../features/user/models/user_driver_model.dart';
import '../../features/user/models/user_subuser_model.dart';
import '../../features/user/models/user_vehicle_model.dart';
import '../../features/user/screens/accounts/drivers/user_driver_details_screen.dart';
import '../../features/user/screens/accounts/drivers/user_drivers_screen.dart';
import '../../features/user/screens/accounts/subusers/user_subuser_details_screen.dart';
import '../../features/user/screens/accounts/subusers/user_subusers_screen.dart';
import '../../features/user/screens/accounts/user_accounts_screen.dart';
import '../../features/user/screens/dashboard/user_dashboard_screen.dart';
import '../../features/user/screens/landmarks/geofences/user_geofences_screen.dart';
import '../../features/user/screens/landmarks/pois/user_pois_screen.dart';
import '../../features/user/screens/landmarks/routes/user_routes_screen.dart';
import '../../features/user/screens/landmarks/user_landmark_studio_screen.dart';
import '../../features/user/screens/map/user_map_screen.dart';
import '../../features/user/screens/notification_settings/user_notification_settings_screen.dart';
import '../../features/user/screens/notifications/user_notification_center_screen.dart';
import '../../features/user/models/user_report_model.dart';
import '../../features/user/screens/reports/user_reports_catalog_screen.dart';
import '../../features/user/screens/reports/user_report_workspace_screen.dart';
import '../../features/user/screens/settings/user_settings_screen.dart';
import '../../features/user/screens/support/user_create_support_ticket_screen.dart';
import '../../features/user/screens/support/user_support_screen.dart';
import '../../features/user/screens/track_links/user_share_track_links_screen.dart';
import '../../features/user/screens/transactions/user_transactions_screen.dart';
import '../../features/user/screens/user_home_screen.dart';
import '../../features/user/screens/user_shell.dart';
import '../../features/user/screens/vehicles/user_vehicle_details_screen.dart';
import '../../features/user/screens/vehicles/user_vehicles_screen.dart';
import 'route_paths.dart';

final appRootNavigatorKey = GlobalKey<NavigatorState>();

final _appRouterRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final refreshNotifier = ValueNotifier<int>(0);

  ref.listen<AuthState>(authControllerProvider, (_, __) {
    refreshNotifier.value++;
  });

  ref.onDispose(refreshNotifier.dispose);
  return refreshNotifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(_appRouterRefreshProvider);

  return GoRouter(
    navigatorKey: appRootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final path = state.uri.path;
      final isAuthRoute = path == RoutePaths.login ||
          path == RoutePaths.forgotPassword ||
          path == RoutePaths.apiBaseUrlSettings;
      final isSplash = path == RoutePaths.splash;
      final emailedResetToken =
          state.uri.queryParameters['reset-password']?.trim();
      final routeToken = path == RoutePaths.forgotPassword
          ? state.uri.queryParameters['token']?.trim()
          : null;
      final resetToken = emailedResetToken?.isNotEmpty == true
          ? emailedResetToken
          : routeToken;
      final isResetFlow = resetToken?.isNotEmpty == true;

      if (isResetFlow && path != RoutePaths.forgotPassword) {
        return Uri(
          path: RoutePaths.forgotPassword,
          queryParameters: <String, String>{'token': resetToken!},
        ).toString();
      }
      if (isResetFlow) {
        return null;
      }

      if (authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading) {
        return isSplash ? null : RoutePaths.splash;
      }

      if (!authState.isAuthenticated) {
        return isAuthRoute ? null : RoutePaths.login;
      }

      final activeRole = authState.activeRole;
      if (activeRole == null) {
        return RoutePaths.login;
      }

      if (isSplash || isAuthRoute) {
        return activeRole.homePath;
      }

      if (authState.user?.isSubuser == true &&
          (path == RoutePaths.userSubUsers ||
              path.startsWith('${RoutePaths.userSubUsers}/'))) {
        return RoutePaths.userAccounts;
      }

      if (!path.startsWith(activeRole.routePrefix)) {
        return activeRole.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => ForgotPasswordScreen(
          initialToken: state.uri.queryParameters['token'] ??
              state.uri.queryParameters['reset-password'],
        ),
      ),
      GoRoute(
        path: RoutePaths.apiBaseUrlSettings,
        builder: (context, state) => const ApiBaseUrlSettingsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => SuperadminShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.superadminHome,
            builder: (context, state) => const SuperadminHomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminDashboard,
            builder: (context, state) => const SuperadminDashboardScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminMap,
            builder: (context, state) => const SuperadminMapScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminVehicles,
            builder: (context, state) => const SuperadminVehiclesScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminAdministrators,
            builder: (context, state) => const SuperadminAdministratorsScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminCalendar,
            builder: (context, state) => const SuperadminCalendarScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminServer,
            builder: (context, state) => const SuperadminServerScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminSupport,
            builder: (context, state) => const SuperadminSupportScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminSupportCreate,
            builder: (context, state) =>
                const SuperadminCreateSupportTicketScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminPayments,
            builder: (context, state) => const SuperadminPaymentsScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminDevices,
            redirect: (context, state) => RoutePaths.superadminVehicles,
          ),
          GoRoute(
            path: RoutePaths.superadminNotifications,
            builder: (context, state) => const SuperadminNotificationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminProfile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: RoutePaths.superadminReports,
            redirect: (context, state) => RoutePaths.superadminDashboard,
          ),
          GoRoute(
            path: RoutePaths.superadminSettings,
            builder: (context, state) => const SuperadminSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.superadminAdministratorCreate,
        builder: (context, state) => const SuperadminCreateAdminScreen(),
      ),
      GoRoute(
        path: RoutePaths.superadminAdministratorDetails,
        builder: (context, state) {
          final adminId = state.pathParameters['adminId'] ?? '';
          final extra = state.extra;
          return SuperadminAdminDetailsScreen(
            adminId: adminId,
            initialAdmin: extra is SuperadminAdministrator ? extra : null,
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.adminHome,
            builder: (context, state) => const AdminHomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminDashboard,
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminMap,
            builder: (context, state) => const AdminMapScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminUsers,
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminUserDetails,
            builder: (context, state) {
              final userId = state.pathParameters['userId'] ?? '';
              final extra = state.extra;
              return AdminUserDetailsScreen(
                userId: userId,
                initialUser: extra is AdminUserListItem ? extra : null,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.adminVehicles,
            builder: (context, state) => const AdminVehiclesScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminVehicleDetails,
            builder: (context, state) {
              final vehicleId = state.pathParameters['vehicleId'] ?? '';
              final extra = state.extra;
              return AdminVehicleDetailsScreen(
                vehicleId: vehicleId,
                initialVehicle: extra is AdminVehicleListItem ? extra : null,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.adminDrivers,
            builder: (context, state) => const AdminDriversScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminDriverDetails,
            builder: (context, state) {
              final driverId = state.pathParameters['driverId'] ?? '';
              final extra = state.extra;
              return AdminDriverDetailsScreen(
                driverId: driverId,
                initialDriver: extra is AdminDriverListItem ? extra : null,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.adminTeam,
            builder: (context, state) => const AdminTeamScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminInventory,
            builder: (context, state) => const AdminInventoryScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminPayments,
            builder: (context, state) => const AdminPaymentsScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminSupport,
            builder: (context, state) => const AdminSupportScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminSupportCreate,
            builder: (context, state) => AdminCreateSupportTicketScreen(
              mode: state.uri.queryParameters['mode'],
            ),
          ),
          GoRoute(
            path: RoutePaths.adminCalendar,
            builder: (context, state) => const AdminCalendarScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminNotifications,
            builder: (context, state) => const AdminNotificationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminProfile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminLogs,
            builder: (context, state) => const AdminLogsScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminPlans,
            builder: (context, state) => const AdminPlansScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminReports,
            redirect: (context, state) => RoutePaths.adminDashboard,
          ),
          GoRoute(
            path: RoutePaths.adminSettings,
            builder: (context, state) => const AdminSettingsScreen(),
          ),
          GoRoute(
            path: RoutePaths.adminRoles,
            redirect: (context, state) => RoutePaths.adminDashboard,
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.adminUserCreate,
        builder: (context, state) => const AdminCreateUserScreen(),
      ),
      GoRoute(
        path: RoutePaths.adminVehicleCreate,
        builder: (context, state) => const AdminCreateVehicleScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => UserShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.userHome,
            builder: (context, state) => const UserHomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.userDashboard,
            builder: (context, state) => const UserDashboardScreen(),
          ),
          GoRoute(
            path: RoutePaths.userMap,
            builder: (context, state) => const UserMapScreen(),
          ),
          GoRoute(
            path: RoutePaths.userVehicles,
            builder: (context, state) => const UserVehiclesScreen(),
          ),
          GoRoute(
            path: RoutePaths.userVehicleDetails,
            builder: (context, state) {
              final vehicleId = state.pathParameters['vehicleId'] ?? '';
              final extra = state.extra;
              return UserVehicleDetailsScreen(
                vehicleId: vehicleId,
                initialVehicle: extra is UserVehicleListItem ? extra : null,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.userTrackLinks,
            builder: (context, state) => const UserShareTrackLinksScreen(),
          ),
          GoRoute(
            path: RoutePaths.userLandmarksStudio,
            builder: (context, state) => const UserLandmarkStudioScreen(),
          ),
          GoRoute(
            path: RoutePaths.userLandmarkGeofences,
            builder: (context, state) => const UserGeofencesScreen(),
          ),
          GoRoute(
            path: RoutePaths.userLandmarkPois,
            builder: (context, state) => const UserPoisScreen(),
          ),
          GoRoute(
            path: RoutePaths.userLandmarkRoutes,
            builder: (context, state) => const UserRoutesScreen(),
          ),
          GoRoute(
            path: RoutePaths.userGeofenceEditor,
            redirect: (context, state) => RoutePaths.userLandmarkGeofences,
          ),
          GoRoute(
            path: RoutePaths.userPoiEditor,
            redirect: (context, state) => RoutePaths.userLandmarkPois,
          ),
          GoRoute(
            path: RoutePaths.userRouteEditor,
            redirect: (context, state) => RoutePaths.userLandmarkRoutes,
          ),
          GoRoute(
            path: RoutePaths.userSupport,
            builder: (context, state) => const UserSupportScreen(),
          ),
          GoRoute(
            path: RoutePaths.userSupportCreate,
            builder: (context, state) => const UserCreateSupportTicketScreen(),
          ),
          GoRoute(
            path: RoutePaths.userTransactions,
            builder: (context, state) => const UserTransactionsScreen(),
          ),
          GoRoute(
            path: RoutePaths.userAccounts,
            builder: (context, state) => const UserAccountsScreen(),
          ),
          GoRoute(
            path: RoutePaths.userDrivers,
            builder: (context, state) => const UserDriversScreen(),
          ),
          GoRoute(
            path: RoutePaths.userDriverDetails,
            builder: (context, state) {
              final driverId = state.pathParameters['driverId'] ?? '';
              final extra = state.extra;
              return UserDriverDetailsScreen(
                driverId: driverId,
                initialDriver: extra is UserDriver ? extra : null,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.userSubUsers,
            builder: (context, state) => const UserSubUsersScreen(),
          ),
          GoRoute(
            path: RoutePaths.userSubUserDetails,
            builder: (context, state) {
              final subUserId = state.pathParameters['subUserId'] ?? '';
              final extra = state.extra;
              return UserSubUserDetailsScreen(
                subUserId: subUserId,
                initialSubUser: extra is UserSubUser ? extra : null,
              );
            },
          ),
          GoRoute(
            path: RoutePaths.userHistory,
            redirect: (context, state) => RoutePaths.userMap,
          ),
          GoRoute(
            path: RoutePaths.userReports,
            builder: (context, state) => const UserReportsCatalogScreen(),
            routes: [
              GoRoute(
                path: ':reportKey',
                builder: (context, state) {
                  final keyStr = state.pathParameters['reportKey'] ?? '';
                  final reportKey = UserReportKey.values.firstWhere(
                    (k) => k.name == keyStr,
                    orElse: () => UserReportKey.distance,
                  );
                  return UserReportWorkspaceScreen(reportKey: reportKey);
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.userNotifications,
            builder: (context, state) => const UserNotificationSettingsScreen(),
          ),
          GoRoute(
            path: RoutePaths.userNotificationCenter,
            builder: (context, state) => const UserNotificationCenterScreen(),
          ),
          GoRoute(
            path: RoutePaths.userProfile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: RoutePaths.userSettings,
            builder: (context, state) => const UserSettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
});
