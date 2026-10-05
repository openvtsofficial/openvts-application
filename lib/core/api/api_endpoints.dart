class ApiEndpoints {
  const ApiEndpoints._();

  static const auth = _AuthEndpoints();
  static const public = _PublicEndpoints();
  static const superadmin = _SuperadminEndpoints();
  static const admin = _AdminEndpoints();
  static const user = _UserEndpoints();

  static const teamBootstrap = "/team/bootstrap";
  static const userPermissions = "/user/permissions";
}

class _AuthEndpoints {
  const _AuthEndpoints();

  String get login => '/auth/login';
  String get refreshToken => '/auth/refresh-token';
  String get forgotPassword => '/auth/forgot-password';
  String get resetPassword => '/auth/reset-password';
  String get logout => '/auth/logout';
  String get me => '/auth/me';
  String get fcmMobileConfig => '/auth/fcm-mobile-config';
  String get pushToken => '/auth/push-token';
  String get pushTokensMe => '/auth/push-tokens/me';
  String get pushTest => '/auth/push-test';
}

class _PublicEndpoints {
  const _PublicEndpoints();

  String get countries => '/countries';
  String get mobilePrefix => '/mobileprefix';
  String states(String countryCode) => '/states/$countryCode';
  String cities(String countryCode, String stateCode) =>
      '/cities/$countryCode/$stateCode';
  String get languages => '/languages';
  String get dateFormats => '/dateformats';
  String get vehicleTypes => '/vehicletypes';
  String get deviceTypes => '/devicestypes';
  String get simProviders => '/simproviders';
  String get currencies => '/currencies';
  String get timezones => '/timezones';
}

class _SuperadminEndpoints {
  const _SuperadminEndpoints();

  String get dashboard => '/superadmin/dashboard';
  String get dashboardOverview => '/superadmin/dashboard/overview';
  String get dashboardActivityLogs => '/superadmin/dashboard/activitylogs';
  String get serverOverview => '/superadmin/server/overview';
  String get serverActions => '/superadmin/server/actions';
  String serverJob(String id) => '/superadmin/server/jobs/$id';
  String serverJobStream(String id) => '/superadmin/server/jobs/$id/stream';
  String get adminList => '/superadmin/adminlist';
  String get transactions => '/superadmin/transactions';
  String get transactionsAnalytics => '/superadmin/transactions/analytics';
  String get recordManualTransaction => '/superadmin/transactions/manual';
  String get createAdmin => '/superadmin/createadmin';
  String activateAdmin(String id) => '/superadmin/activateadmin/$id';
  String deleteAdmin(String id) => '/superadmin/deleteadmin/$id';
  String adminLogin(String id) => '/superadmin/adminlogin/$id';
  String get mapEvents => '/superadmin/map-events';
  String get mapTelemetry => '/superadmin/map-telemetry';
  String get geofences => '/superadmin/geofences';
  String get pois => '/superadmin/pois';
  String get routes => '/superadmin/routes';
  String get notifications => '/superadmin/notifications';
  String notificationRead(String id) => '/superadmin/notifications/$id/read';
  String get notificationsReadAll => '/superadmin/notifications/read-all';
  String get customCommands => '/superadmin/customcommands';
  String get systemVariables => '/superadmin/systemvariables';
  String sendDeviceCommandByImei(String imei) =>
      '/superadmin/devices/${Uri.encodeComponent(imei)}/send-command';
  String sendVehicleCommandByImei(String imei) =>
      '/superadmin/vehicles/by-imei/${Uri.encodeComponent(imei)}/send-command';
  String commandHistoryByImei(String imei) =>
      '/superadmin/vehicles/by-imei/${Uri.encodeComponent(imei)}/commands';
  String commandStatus(String cmdId) =>
      '/superadmin/commands/status/${Uri.encodeComponent(cmdId)}';
  String commandLog(String cmdId) =>
      '/superadmin/commands/${Uri.encodeComponent(cmdId)}';
  String get vehicles => '/superadmin/vehicles';
  String vehicleDetail(String id) => '/superadmin/vehicles/$id';
  String vehicleDetailsByImei(String imei) =>
      '/superadmin/vehicles/by-imei/$imei/details';
  String vehicleReplayByImei(String imei) =>
      '/superadmin/vehicles/by-imei/$imei/replay';
  String vehicleLogsByImei(String imei) =>
      '/superadmin/vehicles/by-imei/${Uri.encodeComponent(imei)}/logs';
  String vehicleEventsByImei(String imei) =>
      '/superadmin/vehicles/by-imei/${Uri.encodeComponent(imei)}/events';
  String vehicleSensorsByImei(String imei) =>
      '/superadmin/vehicles/by-imei/${Uri.encodeComponent(imei)}/sensors';
  String vehicleCommandsByImei(String imei) => commandHistoryByImei(imei);
  String sendDeviceCommand(String imei) => sendDeviceCommandByImei(imei);
  String commandStatusByCmdId(String cmdId) => commandStatus(cmdId);
  String commandByCmdId(String cmdId) => commandLog(cmdId);
  String vehicleHistoryByImei(String imei) =>
      '/superadmin/vehicles/by-imei/${Uri.encodeComponent(imei)}/history';
  String get administrators => '/superadmin/admins';
  String get devices => '/superadmin/devices';
  String get calendarEvents => '/superadmin/calendar/events';
  String get calendarDay => '/superadmin/calendar/day';
  String calendarUser(String uid) => '/superadmin/calendar/user/$uid';
  String get supportTickets => '/superadmin/support/tickets';
  String supportTicketById(String id) =>
      '/superadmin/support/tickets/${Uri.encodeComponent(id)}';
  String supportTicketMessages(String id) =>
      '/superadmin/support/tickets/${Uri.encodeComponent(id)}/messages';
  String supportTicketStatus(String id) =>
      '/superadmin/support/tickets/${Uri.encodeComponent(id)}/status';
  String get profile => '/superadmin/profile';
  String uploadProfile(String id) => '/superadmin/upload/$id';
  String get companyDetails => '/superadmin/companydetails';
  String get updatePassword => '/superadmin/updatepassword';
  String get profileVerifyEmailRequest =>
      '/superadmin/profile/verify/email/request';
  String get profileVerifyEmailConfirm =>
      '/superadmin/profile/verify/email/confirm';
  String get profileVerifyWhatsAppRequest =>
      '/superadmin/profile/verify/whatsapp/request';
  String get profileVerifyWhatsAppConfirm =>
      '/superadmin/profile/verify/whatsapp/confirm';
  String get profileEmailSubscription =>
      '/superadmin/profile/email-subscription';
  String get profileEmailSubscribe =>
      '/superadmin/profile/email-subscription/subscribe';
  String get whiteLabel => '/superadmin/whitelabel';
  String get smtpSettings => '/superadmin/smtpsettings';
  String get testSmtp => '/superadmin/testsmtp';
  String get localization => '/superadmin/localization';
  String get softwareConfig => '/superadmin/softwareconfig';
  String get dataRetentionPreview =>
      '/superadmin/settings/data-retention/preview';
  String get dataRetentionRun => '/superadmin/settings/data-retention/run';
  String get reports => '/superadmin/reports';
  String get settings => '/superadmin/settings';

  String adminDetail(String id) =>
      '/superadmin/admin/${Uri.encodeComponent(id)}';
  String updateAdmin(String id) =>
      '/superadmin/updateadmin/${Uri.encodeComponent(id)}';
  String assignCredits(String id) =>
      '/superadmin/assigncredits/${Uri.encodeComponent(id)}';
  String creditLogs(String id) =>
      '/superadmin/creditlogs/${Uri.encodeComponent(id)}';
  String get adminPasswordUpdate => '/superadmin/adminpasswordupdate';
  String companyConfig(String id) =>
      '/superadmin/companyconfig/${Uri.encodeComponent(id)}';
  String adminVehicles(String adminId) =>
      '/superadmin/adminvehicles/${Uri.encodeComponent(adminId)}';
  String documentsByAdmin(String adminId) =>
      '/superadmin/documents/${Uri.encodeComponent(adminId)}';
  String get documentTypes => '/superadmin/documenttypes';
  String get uploadDoc => '/superadmin/uploaddoc';
  String uploadDocById(String id) =>
      '/superadmin/uploaddoc/${Uri.encodeComponent(id)}';
  String adminActivityLogs(String adminId) =>
      '/superadmin/admin/${Uri.encodeComponent(adminId)}/activitylogs';
}

class _AdminEndpoints {
  const _AdminEndpoints();

  String get dashboard => '/admin/dashboard';
  String get dashboardSummary => '/admin/dashboard/summary';
  String get mapVehicles => '/admin/map/vehicles';
  String get notifications => '/admin/notifications';
  String notificationRead(String id) => '/admin/notifications/$id/read';
  String get notificationsReadAll => '/admin/notifications/read-all';
  String get calendarEvents => '/admin/calendar/events';
  String get calendarDay => '/admin/calendar/day';
  String calendarUser(String uid) => '/admin/calendar/user/$uid';
  String get vehicles => '/admin/vehicles';
  String vehicleById(String id) => '/admin/vehicles/${Uri.encodeComponent(id)}';
  String vehicleConfigUpdate(String id) =>
      '/admin/vehicles/${Uri.encodeComponent(id)}/config';
  String get quickDevice => '/admin/quickdevice';
  String linkUsersByVehicleId(String vehicleId) =>
      '/admin/linkusers/${Uri.encodeComponent(vehicleId)}';
  String unlinkUsersByVehicleId(String vehicleId) =>
      '/admin/unlinkusers/${Uri.encodeComponent(vehicleId)}';
  String vehicleLogsByImei(String imei) =>
      '/admin/vehicles/by-imei/${Uri.encodeComponent(imei)}/logs';
  String vehicleEventsByImei(String imei) =>
      '/admin/vehicles/by-imei/${Uri.encodeComponent(imei)}/events';
  String get customCommands => '/admin/customcommands';
  String get systemVariables => '/admin/systemvariables';
  String sendCommandByImei(String imei) =>
      '/admin/vehicles/by-imei/${Uri.encodeComponent(imei)}/send-command';
  String commandHistoryByImei(String imei) =>
      '/admin/vehicles/by-imei/${Uri.encodeComponent(imei)}/commands';
  String commandStatus(String cmdId) =>
      '/admin/commands/status/${Uri.encodeComponent(cmdId)}';
  String commandLog(String cmdId) =>
      '/admin/commands/${Uri.encodeComponent(cmdId)}';
  String vehicleSensors(String vehicleId) =>
      '/admin/vehicles/${Uri.encodeComponent(vehicleId)}/sensors';
  String vehicleSensorById({
    required String vehicleId,
    required String sensorId,
  }) =>
      '/admin/vehicles/${Uri.encodeComponent(vehicleId)}/sensors/${Uri.encodeComponent(sensorId)}';
  String vehicleSensorsRun(String id) =>
      '/admin/vehicles/${Uri.encodeComponent(id)}/sensors/run';
  String vehicleSensorsTelemetry(String id) =>
      '/admin/vehicles/${Uri.encodeComponent(id)}/sensors/telemetry';
  String documentsByVehicle(String vehicleId) =>
      '/admin/documents/vehicle/${Uri.encodeComponent(vehicleId)}';
  String get vehicleDocumentTypes => '/documenttypes/VEHICLE';
  String vehicleDetail(String id) => '/admin/vehicles/$id';
  String get users => '/admin/users';
  String userById(String id) => '/admin/users/${Uri.encodeComponent(id)}';
  String userLogin(String id) => '/admin/userlogin/${Uri.encodeComponent(id)}';
  String updateUserPassword(String id) =>
      '/admin/updateuserpassword/${Uri.encodeComponent(id)}';
  String companyDetailsByUserId(String id) =>
      '/admin/companydetails/${Uri.encodeComponent(id)}';
  String linkedVehiclesByUserId(String userId) =>
      '/admin/linkvehicles/${Uri.encodeComponent(userId)}';
  String unlinkedVehiclesByUserId(String userId) =>
      '/admin/unlinkvehicles/${Uri.encodeComponent(userId)}';
  String linkedDriversByUserId(String userId) =>
      '/admin/users/linkeddrivers/${Uri.encodeComponent(userId)}';
  String unlinkedDriversByUserId(String userId) =>
      '/admin/users/unlinkeddrivers/${Uri.encodeComponent(userId)}';
  String documentsByUser(String userId) =>
      '/admin/documents/${Uri.encodeComponent(userId)}';
  String get userDocumentTypes => '/documenttypes/USER';
  String get uploadDoc => '/admin/uploaddoc';
  String uploadDocById(String id) =>
      '/admin/uploaddoc/${Uri.encodeComponent(id)}';
  String get tickets => '/admin/tickets';
  String ticketById(String id) => '/admin/tickets/${Uri.encodeComponent(id)}';
  String ticketMessages(String id) =>
      '/admin/tickets/${Uri.encodeComponent(id)}/messages';
  String ticketStatus(String id) =>
      '/admin/tickets/${Uri.encodeComponent(id)}/status';
  String get myTickets => '/admin/mytickets';
  String myTicketById(String id) =>
      '/admin/mytickets/${Uri.encodeComponent(id)}';
  String myTicketMessages(String id) =>
      '/admin/mytickets/${Uri.encodeComponent(id)}/messages';
  String myTicketStatus(String id) =>
      '/admin/mytickets/${Uri.encodeComponent(id)}/status';
  String get adminPayments => '/admin/payments';
  String get transactionsAnalytics => '/admin/transactions/analytics';
  String get renewVehiclesPayment => '/admin/payments/renew';
  String userActivityLogs(String id) =>
      '/admin/users/${Uri.encodeComponent(id)}/activitylogs';
  String get drivers => '/admin/drivers';
  String driverById(String id) => '/admin/drivers/${Uri.encodeComponent(id)}';
  String documentsByDriver(String driverId) =>
      '/admin/documents/driver/${Uri.encodeComponent(driverId)}';
  String get driverDocumentTypes => '/documenttypes/DRIVER';
  String driverLinkedUsers(String driverId) =>
      '/admin/drivers/linkedusers/${Uri.encodeComponent(driverId)}';
  String driverUnlinkedUsers(String driverId) =>
      '/admin/drivers/unlinkedusers/${Uri.encodeComponent(driverId)}';
  String get teams => '/admin/teams';
  String get pricingPlans => '/admin/pricingplans';
  String pricingPlanById(String id) =>
      '/admin/pricingplans/${Uri.encodeComponent(id)}';
  String get transactions => '/admin/transactions';
  String get devices => '/admin/devices';
  String deviceById(String id) => '/admin/devices/${Uri.encodeComponent(id)}';
  String get simcards => '/admin/simcards';
  String simcardById(String id) => '/admin/simcards/${Uri.encodeComponent(id)}';
  String get deviceAndSim => '/admin/deviceandsim';
  String get quickSimcards => '/admin/quicksimcards';
  String get profile => '/admin/profile';
  String get uploadProfile => '/admin/upload';
  String get companyDetails => '/admin/companydetails';
  String get updatePassword => '/admin/updatepassword';
  String get smtpConfig => '/admin/smtpconfig';
  String get testSmtp => '/admin/testsmtp';
  String get localization => '/admin/localization';
  String get profileVerifyEmailRequest => '/admin/profile/verify/email/request';
  String get profileVerifyEmailConfirm => '/admin/profile/verify/email/confirm';
  String get profileVerifyWhatsAppRequest =>
      '/admin/profile/verify/whatsapp/request';
  String get profileVerifyWhatsAppConfirm =>
      '/admin/profile/verify/whatsapp/confirm';
  String get profileEmailSubscription => '/admin/profile/email-subscription';
  String get profileEmailSubscribe =>
      '/admin/profile/email-subscription/subscribe';
  String get reports => '/admin/reports';
  String get settings => '/admin/settings';
  String get logsOptions => '/admin/logs/options';
  String get logsActivity => '/admin/logs/activity';
  String get logsEvents => '/admin/logs/events';
  String logsEventById(String id) =>
      '/admin/logs/events/${Uri.encodeComponent(id)}';
  String get logsTelemetry => '/admin/logs/telemetry';
  String logsTelemetryById(String id) =>
      '/admin/logs/telemetry/${Uri.encodeComponent(id)}';
}

class _UserEndpoints {
  const _UserEndpoints();

  String get dashboards => '/user/dashboards';
  String dashboardById(String id) =>
      '/user/dashboards/${Uri.encodeComponent(id)}';
  String get dashboardFleetStatus => '/user/dashboard/fleet-status';
  String get dashboardUsageLast7Days => '/user/dashboard/usage-last-7-days';
  String get dashboardWeeklyComparison => '/user/dashboard/weekly-comparison';
  String get dashboardRecentAlerts => '/user/dashboard/recent-alerts';
  String dashboardRecentAlertById(String id) =>
      '/user/dashboard/recent-alerts/${Uri.encodeComponent(id)}';
  String dashboardRecentAlertRead(String id) =>
      '/user/dashboard/recent-alerts/${Uri.encodeComponent(id)}/read';
  String get dashboardTopPerformingAssets =>
      '/user/dashboard/top-performing-assets';
  String get dashboardDayNightComparison =>
      '/user/dashboard/day-night-comparison';
  String get mapVehicles => '/user/map/vehicles';
  String get vehicles => '/user/vehicles';
  String get transactions => '/user/transactions';
  String get tickets => '/user/tickets';
  String ticketById(String id) => '/user/tickets/${Uri.encodeComponent(id)}';
  String get shareTrackLinks => '/user/sharetracklinks';
  String shareTrackLinkById(String id) =>
      '/user/sharetracklinks/${Uri.encodeComponent(id)}';
  String vehicleById(String id) => '/user/vehicles/${Uri.encodeComponent(id)}';
  String vehicleUpdate(String id) =>
      '/user/vehicles/${Uri.encodeComponent(id)}';
  String vehicleConfigUpdate(String id) =>
      '/user/vehicles/${Uri.encodeComponent(id)}/config';
  String vehicleDocuments(String id) =>
      '/user/vehicles/${Uri.encodeComponent(id)}/documents';
  String vehicleDocumentById({
    required String vehicleId,
    required String docId,
  }) =>
      '/user/vehicles/${Uri.encodeComponent(vehicleId)}/documents/${Uri.encodeComponent(docId)}';
  String vehicleSensors(String vehicleId) =>
      '/user/vehicles/${Uri.encodeComponent(vehicleId)}/sensors';
  String vehicleSensorById({
    required String vehicleId,
    required String sensorId,
  }) =>
      '/user/vehicles/${Uri.encodeComponent(vehicleId)}/sensors/${Uri.encodeComponent(sensorId)}';
  String vehicleSensorsRun(String id) =>
      '/user/vehicles/${Uri.encodeComponent(id)}/sensors/run';
  String vehicleSensorsTelemetry(String id) =>
      '/user/vehicles/${Uri.encodeComponent(id)}/sensors/telemetry';
  String vehicleSensorHistory({
    required String vehicleId,
    required String sensorId,
  }) =>
      '/user/vehicles/${Uri.encodeComponent(vehicleId)}/sensors/${Uri.encodeComponent(sensorId)}/history';
  String vehicleTelemetry(String id) =>
      '/user/vehicles/${Uri.encodeComponent(id)}/telemetry';
  String get vehicleDocumentTypes => '/documenttypes/VEHICLE';
  String get driverDocumentTypes => '/documenttypes/DRIVER';
  String get drivers => '/user/drivers';
  String driverById(String id) => '/user/drivers/${Uri.encodeComponent(id)}';
  String driverAssignVehicle(String id) =>
      '/user/drivers/${Uri.encodeComponent(id)}/assign-vehicle';
  String driverUnassignVehicle(String id) =>
      '/user/drivers/${Uri.encodeComponent(id)}/unassign-vehicle';
  String driverLogs(String id) =>
      '/user/drivers/${Uri.encodeComponent(id)}/logs';
  String driverDocuments(String id) =>
      '/user/drivers/${Uri.encodeComponent(id)}/documents';
  String driverDocumentById(
          {required String driverId, required String docId}) =>
      '/user/drivers/${Uri.encodeComponent(driverId)}/documents/${Uri.encodeComponent(docId)}';
  String get subusers => '/user/subusers';
  String subuserById(String id) => '/user/subusers/${Uri.encodeComponent(id)}';
  String subuserVehicles(String id) =>
      '/user/subusers/${Uri.encodeComponent(id)}/vehicles';
  String assignSubuserVehicles(String id) =>
      '/user/subusers/${Uri.encodeComponent(id)}/vehicles/assign';
  String unassignSubuserVehicles(String id) =>
      '/user/subusers/${Uri.encodeComponent(id)}/vehicles/unassign';
  String vehicleDetail(String id) => '/user/vehicles/$id';
  String get history => '/user/history';
  String get reportOptions => '/user/reports/options';
  String reportByKey(String reportKey) =>
      '/user/reports/${Uri.encodeComponent(reportKey)}';
  String get reportTimelineMap => '/user/reports/timeline/map';
  String get notificationPreferences => '/user/notifications/preferences';
  String get testFcmMe => '/user/notifications/test-fcm-me';
  String get notifications => '/user/notifications';
  String notificationRead(String id) => '/user/notifications/$id/read';
  String get notificationsReadAll => '/user/notifications/read-all';
  String get customCommands => '/user/customcommands';
  String get systemVariables => '/user/systemvariables';
  String get sendCommandBulk => '/user/commands/send-bulk';
  String get profile => '/user/profile';
  String get uploadProfile => '/user/upload';
  String get companyDetails => '/user/companydetails';
  String get updatePassword => '/user/updatepassword';
  String get profileVerifyEmailRequest => '/user/profile/verify/email/request';
  String get profileVerifyEmailConfirm => '/user/profile/verify/email/confirm';
  String get profileVerifyWhatsAppRequest =>
      '/user/profile/verify/whatsapp/request';
  String get profileVerifyWhatsAppConfirm =>
      '/user/profile/verify/whatsapp/confirm';
  String get profileEmailSubscription => '/user/profile/email-subscription';
  String get profileEmailSubscribe =>
      '/user/profile/email-subscription/subscribe';
  String get localization => '/user/localization';
  String get settings => '/user/settings';

  String get geofences => '/user/geofences';
  String geofenceById(String id) =>
      '/user/geofences/${Uri.encodeComponent(id)}';

  String get pois => '/user/pois';
  String poiById(String id) => '/user/pois/${Uri.encodeComponent(id)}';

  String get routes => '/user/routes';
  String routeById(String id) => '/user/routes/${Uri.encodeComponent(id)}';

  String get landmarkBulkJobs => '/user/landmarkbulkjobs';
  String landmarkBulkJobById(String id) =>
      '/user/landmarkbulkjobs/${Uri.encodeComponent(id)}';
  String landmarkBulkJobStream(String id) =>
      '/user/landmarkbulkjobs/${Uri.encodeComponent(id)}/stream';
  String landmarkBulkJobFailedCsv(String id) =>
      '/user/landmarkbulkjobs/${Uri.encodeComponent(id)}/failed.csv';
}

/// Shared self-service account endpoints, including the separate Driver identity.
class AuthSecurityEndpoints {
  const AuthSecurityEndpoints._();
  static bool isPublicAuthenticationRequest(String value) {
    final path = Uri.tryParse(value)?.path ?? value.split('?').first;
    return RegExp(r'/demo(?:/|$)').hasMatch(path) ||
        RegExp(r'/auth/(?:login|login-options|refresh-token|forgot-password|reset-password|google/login|mfa/verify-login)$')
            .hasMatch(path);
  }

  static const verifyLogin = '/auth/mfa/verify-login';
  static const mfa = '/auth/mfa';
  static const enroll = '/auth/mfa/enroll';
  static const confirm = '/auth/mfa/confirm';
  static const disable = '/auth/mfa/disable';
  static const removeDevice = '/auth/mfa/devices/remove';
  static const recoveryCodes = '/auth/mfa/recovery-codes';
  static const apiTokens = '/auth/api-tokens';
  static String revokeToken(String id) =>
      '$apiTokens/${Uri.encodeComponent(id)}/revoke';
  static const account = '/auth/account';
  static const teamProfile = '/team/profile';
  static const driverProfile = '/driver/profile';
  static const driverPassword = '/driver/password';
  static const driverSettings = '/driver/settings';
}

/// Latest administrator contracts. IDs are encoded before path interpolation.
class AdminExtendedEndpoints {
  const AdminExtendedEndpoints._();
  static const transactions = '/admin/transactions';
  static const teamPermissionCatalog = '/admin/team-permissions/catalog';
  static String teamPermissions(String id) =>
      '/admin/teams/${Uri.encodeComponent(id)}/permissions';
  static String teamActivity(String id) =>
      '/admin/teams/${Uri.encodeComponent(id)}/activitylogs';
  static String userPermissions(String id) =>
      '/admin/users/${Uri.encodeComponent(id)}/permissions';
  static String vehicleService(String id) =>
      '/admin/vehicle-service/vehicles/${Uri.encodeComponent(id)}';
  static String annualRenew(String id) => '${vehicleService(id)}/annual-renew';
  static const renewalRequests = '/admin/vehicle-service/requests';
  static String confirmRenewal(String id) =>
      '$renewalRequests/${Uri.encodeComponent(id)}/confirm';
  static String cancelRenewal(String id) =>
      '$renewalRequests/${Uri.encodeComponent(id)}/cancel';
}

/// USER APIs introduced after the original mobile release. Kept with endpoint
/// configuration; service code never constructs role prefixes.
class UserExtendedEndpoints {
  const UserExtendedEndpoints._();
  static String operations(String resource) => '/user/operations/$resource';
  static String operationTrip(String id) =>
      operations('trips/${Uri.encodeComponent(id)}');
  static String recurring(String id) =>
      operations('recurring/${Uri.encodeComponent(id)}');
  static String operationProofContent(String tripId, String proofId) =>
      '${operationTrip(tripId)}/proofs/${Uri.encodeComponent(proofId)}/content';
  static const serviceVehicles = '/user/vehicle-service/vehicles';
  static const renewalRequests = '/user/vehicle-service/requests';
  static String cancelRenewal(int id) => '$renewalRequests/$id/cancel';
}

/// Authenticated driver workspace endpoints. Driver ownership is derived from
/// the session, never supplied by a mobile view.
abstract final class DriverEndpoints {
  static const dashboard = '/driver/dashboard';
  static const trips = '/driver/trips';
  static const calendar = '/driver/calendar';
  static const messages = '/driver/messages';
  static const messagesRead = '/driver/messages/read';
  static const notifications = '/driver/notifications';
  static const notificationsReadAll = '/driver/notifications/read-all';
  static const documents = '/driver/documents';
  static const documentTypes = '/driver/document-types';
  static String trip(String id) => '$trips/${_id(id)}';
  static String acknowledge(String id) => '${trip(id)}/acknowledge';
  static String start(String id) => '${trip(id)}/start';
  static String completeStop(String id, String stopId) =>
      '${trip(id)}/stops/${_id(stopId)}/complete';
  static String remarks(String id) => '${trip(id)}/remarks';
  static String exceptions(String id) => '${trip(id)}/exceptions';
  static String proofs(String id) => '${trip(id)}/proofs';
  static String proofContent(String id, String proofId) =>
      '${proofs(id)}/${_id(proofId)}/content';
  static String document(String id) => '$documents/${_id(id)}';
  static String documentContent(String id) => '${document(id)}/content';
  static String readNotification(String id) => '$notifications/${_id(id)}/read';
  static String _id(String value) {
    if (value.trim().isEmpty) throw ArgumentError('Missing identifier');
    return Uri.encodeComponent(value);
  }
}

// Frozen from supplied TeamController. No Admin fallback is allowed.
const teamApiContracts = <String>[
  'GET /team/bootstrap',
  'GET /team/dashboard/summary',
  'GET /team/vehicles',
  'GET /team/vehicles/:id',
  'POST /team/vehicles',
  'PATCH /team/vehicles/:id',
  'DELETE /team/vehicles/:id',
  'GET /team/vehicles/:id/commands',
  'POST /team/vehicles/:id/commands',
  'PATCH /team/vehicles/:id/config',
  'GET /team/vehicle-options/users',
  'GET /team/vehicle-options/devices',
  'POST /team/vehicle-options/devices',
  'POST /team/vehicle-options/devices/validate',
  'GET /team/vehicle-options/plans',
  'GET /team/vehicles/:id/users/linked',
  'GET /team/vehicles/:id/users/available',
  'POST /team/vehicles/:id/users/linked',
  'POST /team/vehicles/:id/users/available',
  'POST /team/vehicles/assign/:userId',
  'GET /team/vehicles/:id/documents',
  'POST /team/vehicles/:id/documents',
  'PATCH /team/vehicles/:id/documents/:documentId',
  'DELETE /team/vehicles/:id/documents/:documentId',
  'GET /team/vehicles/:id/logs',
  'GET /team/vehicles/:id/logs/export',
  'GET /team/vehicles/:id/customcommands',
  'GET /team/vehicles/:id/systemvariables',
  'GET /team/vehicles/:id/commands/history',
  'GET /team/vehicles/:id/commands/status/:cmdId',
  'GET /team/vehicles/:id/commands/:cmdId',
  'POST /team/vehiclebulkjobs',
  'GET /team/vehiclebulkjobs/:id',
  'GET /team/vehiclebulkjobs/:id/failed.csv',
  'GET /team/vehiclebulkjobs/:id/stream',
  'GET /team/users',
  'GET /team/users/:id',
  'POST /team/users',
  'PATCH /team/users/:id',
  'DELETE /team/users/:id',
  'GET /team/users/:id/login',
  'POST /team/users/:id/password',
  'GET /team/users/:id/company',
  'PATCH /team/users/:id/company',
  'GET /team/users/:id/vehicles/linked',
  'GET /team/users/:id/vehicles/available',
  'POST /team/users/:id/vehicles/linked',
  'POST /team/users/:id/vehicles/available',
  'GET /team/users/:id/drivers/linked',
  'GET /team/users/:id/drivers/available',
  'POST /team/users/:id/drivers/linked',
  'POST /team/users/:id/drivers/available',
  'GET /team/users/:id/documents',
  'POST /team/users/:id/documents',
  'PATCH /team/users/:id/documents/:documentId',
  'DELETE /team/users/:id/documents/:documentId',
  'GET /team/users/:id/tickets',
  'POST /team/users/:id/tickets',
  'GET /team/users/:id/payments',
  'POST /team/users/:id/payments/renew',
  'GET /team/users/:id/activitylogs',
  'POST /team/userbulkjobs',
  'GET /team/userbulkjobs/:id',
  'GET /team/userbulkjobs/:id/failed.csv',
  'GET /team/userbulkjobs/:id/stream',
  'GET /team/drivers/eligible-users',
  'GET /team/drivers',
  'GET /team/drivers/:id',
  'POST /team/drivers',
  'PATCH /team/drivers/:id',
  'DELETE /team/drivers/:id',
  'GET /team/drivers/:id/users/linked',
  'GET /team/drivers/:id/users/available',
  'POST /team/drivers/:id/users/linked',
  'POST /team/drivers/:id/users/available',
  'GET /team/drivers/:id/documents',
  'POST /team/drivers/:id/documents',
  'PATCH /team/drivers/:id/documents/:documentId',
  'DELETE /team/drivers/:id/documents/:documentId',
  'POST /team/driverbulkjobs',
  'GET /team/driverbulkjobs/:id',
  'GET /team/driverbulkjobs/:id/failed.csv',
  'GET /team/driverbulkjobs/:id/stream',
  'GET /team/inventory/devices',
  'GET /team/inventory/reference-data',
  'POST /team/inventory/devices',
  'PATCH /team/inventory/devices/:id',
  'DELETE /team/inventory/devices/:id',
  'GET /team/inventory/simcards',
  'GET /team/inventory/sims',
  'POST /team/inventory/simcards',
  'PATCH /team/inventory/simcards/:id',
  'DELETE /team/inventory/simcards/:id',
  'POST /team/inventory/deviceandsim',
  'GET /team/inventory/quicksimcards',
  'POST /team/inventorybulkjobs',
  'GET /team/inventorybulkjobs/:id',
  'GET /team/inventorybulkjobs/:id/failed.csv',
  'GET /team/inventorybulkjobs/:id/stream',
  'GET /team/payments',
  'GET /team/payments/analytics',
  'GET /team/payments/users',
  'GET /team/payments/renew/users',
  'GET /team/payments/renew/users/:id/vehicles',
  'POST /team/payments/renew',
  'GET /team/notify/capabilities',
  'GET /team/notify/recipients',
  'POST /team/notify/recipients/estimate',
  'POST /team/notify/campaigns',
  'GET /team/notify/campaigns',
  'GET /team/notify/campaigns/:id',
  'DELETE /team/notify/campaigns/:id',
  'GET /team/notify/campaigns/:id/recipients',
  'GET /team/notify/campaigns/:id/deliveries',
  'GET /team/notifications',
  'PATCH /team/notifications/read',
  'PATCH /team/notifications/:id/read',
  'GET /team/map-telemetry',
  'GET /team/map-events',
  'GET /team/map/vehicles/by-imei/:imei/details',
  'GET /team/map/vehicles/by-imei/:imei/logs',
  'GET /team/map/vehicles/by-imei/:imei/events',
  'GET /team/map/vehicles/by-imei/:imei/replay',
  'GET /team/map/vehicles/by-imei/:imei/history',
  'GET /team/map/vehicles/by-imei/:imei/sensors',
  'GET /team/vehicles/:id/events',
  'GET /team/vehicles/:id/events/export',
  'GET /team/vehicles/:id/history',
  'GET /team/vehicles/:id/replay',
  'GET /team/vehicles/:id/trail',
  'GET /team/vehicles/:id/sensors',
  'POST /team/vehicles/:id/sensors',
  'POST /team/vehicles/:id/sensors/run',
  'GET /team/vehicles/:id/sensors/telemetry',
  'PATCH /team/vehicles/:id/sensors/:sensorId',
  'DELETE /team/vehicles/:id/sensors/:sensorId',
  'GET /team/calendar/events',
  'GET /team/calendar/day',
  'GET /team/calendar/user/:uid',
  'GET /team/calendar/vehicle/:id',
  'GET /team/logs/options',
  'GET /team/logs/activity',
  'GET /team/logs/events',
  'GET /team/logs/events/:id',
  'GET /team/logs/telemetry',
  'GET /team/logs/telemetry/:id',
  'GET /team/calendar',
  'GET /team/support/tickets',
  'GET /team/support/users',
  'GET /team/support/tickets/:id',
  'POST /team/support/tickets',
  'POST /team/support/tickets/:id/messages',
  'PATCH /team/support/tickets/:id/status',
  'GET /team/support/mytickets',
  'GET /team/support/mytickets/:id',
  'POST /team/support/mytickets',
  'POST /team/support/mytickets/:id/messages',
  'PATCH /team/support/mytickets/:id/status',
  'GET /team/support',
  'POST /team/support',
  'GET /team/support/:id',
  'POST /team/support/:id/replies',
  'GET /team/profile',
  'PATCH /team/profile',
  'PATCH /team/updatepassword',
  'GET /team/localization',
  'PATCH /team/localization',
];

/// Current Team route adaptation configuration.
class TeamApiEndpointRules {
  static const adminPrefix = '/admin';
  const TeamApiEndpointRules._();
  static const exact = <String, String>{
    '/dashboard': '/team/dashboard/summary',
    '/dashboard/summary': '/team/dashboard/summary',
    '/map/vehicles': '/team/map-telemetry',
    '/map-telemetry': '/team/map-telemetry',
    '/map-events': '/team/map-events',
    '/devices': '/team/inventory/devices',
    '/simcards': '/team/inventory/simcards',
    '/deviceandsim': '/team/inventory/deviceandsim',
    '/quicksimcards': '/team/inventory/quicksimcards',
    '/quickdevice': '/team/vehicle-options/devices',
    '/pricingplans': '/team/vehicle-options/plans',
    '/payments': '/team/payments',
    '/transactions/analytics': '/team/payments/analytics',
    '/notifications/read-all': '/team/notifications/read',
    '/tickets': '/team/support/tickets',
    '/mytickets': '/team/support/mytickets',
  };
  static final patterns = <(RegExp, String Function(RegExpMatch))>[
    (
      RegExp(r'^/(devices|simcards)/([^/]+)$'),
      (m) => '/team/inventory/${m[1]}/${m[2]}'
    ),
    (
      RegExp(
          r'^/vehicles/by-imei/([^/]+)/(details|logs|events|history|replay|sensors)$'),
      (m) => '/team/map/vehicles/by-imei/${m[1]}/${m[2]}'
    ),
    (RegExp(r'^/userlogin/([^/]+)$'), (m) => '/team/users/${m[1]}/login'),
    (
      RegExp(r'^/updateuserpassword/([^/]+)$'),
      (m) => '/team/users/${m[1]}/password'
    ),
    (
      RegExp(r'^/companydetails/([^/]+)$'),
      (m) => '/team/users/${m[1]}/company'
    ),
    (
      RegExp(r'^/linkvehicles/([^/]+)$'),
      (m) => '/team/users/${m[1]}/vehicles/linked'
    ),
    (
      RegExp(r'^/unlinkvehicles/([^/]+)$'),
      (m) => '/team/users/${m[1]}/vehicles/available'
    ),
    (
      RegExp(r'^/linkusers/([^/]+)$'),
      (m) => '/team/vehicles/${m[1]}/users/linked'
    ),
    (
      RegExp(r'^/unlinkusers/([^/]+)$'),
      (m) => '/team/vehicles/${m[1]}/users/available'
    ),
    (
      RegExp(r'^/users/linkeddrivers/([^/]+)$'),
      (m) => '/team/users/${m[1]}/drivers/linked'
    ),
    (
      RegExp(r'^/users/unlinkeddrivers/([^/]+)$'),
      (m) => '/team/users/${m[1]}/drivers/available'
    ),
    (
      RegExp(r'^/drivers/linkedusers/([^/]+)$'),
      (m) => '/team/drivers/${m[1]}/users/linked'
    ),
    (
      RegExp(r'^/drivers/unlinkedusers/([^/]+)$'),
      (m) => '/team/drivers/${m[1]}/users/available'
    ),
    (
      RegExp(r'^/documents/vehicle/([^/]+)$'),
      (m) => '/team/vehicles/${m[1]}/documents'
    ),
    (
      RegExp(r'^/documents/driver/([^/]+)$'),
      (m) => '/team/drivers/${m[1]}/documents'
    ),
    (RegExp(r'^/documents/([^/]+)$'), (m) => '/team/users/${m[1]}/documents'),
    (
      RegExp(r'^/(tickets|mytickets)/(.+)$'),
      (m) => '/team/support/${m[1]}/${m[2]}'
    ),
  ];
}

/// Contextual Team endpoints that cannot be inferred from an Admin URL.
class TeamContextEndpoints {
  const TeamContextEndpoints._();
  static const vehicleUsers = '/team/vehicle-options/users';
  static const driverUsers = '/team/drivers/eligible-users';
  static const paymentUsers = '/team/payments/users';
  static const renewalUsers = '/team/payments/renew/users';
  static const supportUsers = '/team/support/users';
  static String renewalVehicles(String userId) =>
      '$renewalUsers/${Uri.encodeComponent(userId)}/vehicles';
  static String vehicleDocuments(String id, {String? documentId}) =>
      '/team/vehicles/${Uri.encodeComponent(id)}/documents${documentId == null ? '' : '/${Uri.encodeComponent(documentId)}'}';
  static String driverDocuments(String id, {String? documentId}) =>
      '/team/drivers/${Uri.encodeComponent(id)}/documents${documentId == null ? '' : '/${Uri.encodeComponent(documentId)}'}';
  static String userDocuments(String id, {String? documentId}) =>
      '/team/users/${Uri.encodeComponent(id)}/documents${documentId == null ? '' : '/${Uri.encodeComponent(documentId)}'}';
  static String userTickets(String id) =>
      '/team/users/${Uri.encodeComponent(id)}/tickets';
  static String userPayments(String id) =>
      '/team/users/${Uri.encodeComponent(id)}/payments';
  static String userRenewal(String id) => '${userPayments(id)}/renew';
  static String customCommands(String id) =>
      '/team/vehicles/${Uri.encodeComponent(id)}/customcommands';
  static String systemVariables(String id) =>
      '/team/vehicles/${Uri.encodeComponent(id)}/systemvariables';
  static String commands(String id) =>
      '/team/vehicles/${Uri.encodeComponent(id)}/commands';
  static String commandHistory(String id) => '${commands(id)}/history';
  static String commandStatus(String id, String commandId) =>
      '${commands(id)}/status/${Uri.encodeComponent(commandId)}';
  static String commandLog(String id, String commandId) =>
      '${commands(id)}/${Uri.encodeComponent(commandId)}';
}

/// USER-only dispatcher endpoints. SUBUSER is excluded by RolesGuard.
abstract final class UserMessagesEndpoints {
  static const threads = '/user/driver-messages/threads';
  static const unread = '/user/driver-messages/unread';
  static String conversation(int driverId) {
    if (driverId <= 0) throw ArgumentError.value(driverId, 'driverId');
    return '/user/driver-messages/$driverId';
  }

  static String read(int driverId) => '${conversation(driverId)}/read';
}
