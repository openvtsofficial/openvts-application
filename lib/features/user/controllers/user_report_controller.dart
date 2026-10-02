import '../models/user_landmark_model.dart';
import '../models/user_report_model.dart';
import '../models/user_vehicle_model.dart';
import '../services/user_landmark_service.dart';
import '../services/user_report_service.dart';
import '../services/user_vehicle_service.dart';

/// Coordinates the Reports workspace and keeps API services out of widgets.
class UserReportController {
  const UserReportController({
    required UserReportService reportService,
    required UserVehicleService vehicleService,
    required UserLandmarkService landmarkService,
  })  : _reportService = reportService,
        _vehicleService = vehicleService,
        _landmarkService = landmarkService;

  final UserReportService _reportService;
  final UserVehicleService _vehicleService;
  final UserLandmarkService _landmarkService;

  Future<UserReportOptions> getOptions() => _reportService.getOptions();

  Future<UserVehicleSensorPage> getSensors(String vehicleId) {
    return _vehicleService.getVehicleSensors(
      vehicleId: vehicleId,
      limit: 100,
      includeLive: false,
    );
  }

  Future<List<UserGeofence>> getActiveGeofences() {
    return _landmarkService.fetchGeofences(isActive: true);
  }

  Future<UserReportPage> generate({
    required UserReportKey reportKey,
    required Map<String, dynamic> vehicleScope,
    required Map<String, dynamic> dateRange,
    required Map<String, dynamic> filters,
    required String timeZone,
    required DateTime from,
    required DateTime to,
    String? cursor,
  }) {
    return _reportService.generate(
      reportKey: reportKey,
      vehicleScope: vehicleScope,
      dateRange: dateRange,
      filters: filters,
      timeZone: timeZone,
      from: from,
      to: to,
      cursor: cursor,
    );
  }

  Future<List<UserTimelinePoint>> getTimelineMap({
    required String vehicleId,
    required DateTime from,
    required DateTime to,
  }) {
    return _reportService.getTimelineMap(
      vehicleId: vehicleId,
      from: from,
      to: to,
    );
  }
}
