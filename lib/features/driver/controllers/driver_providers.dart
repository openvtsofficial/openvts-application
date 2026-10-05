import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/providers/core_providers.dart';
import '../models/driver_workspace_models.dart';
import '../services/driver_workspace_service.dart';

final driverWorkspaceServiceProvider =
    Provider.autoDispose<DriverWorkspaceService>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return DriverWorkspaceService(ref.watch(apiClientProvider));
});
final driverDashboardProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(driverWorkspaceServiceProvider).dashboard());
final driverTripsProvider = FutureProvider.autoDispose
    .family<DriverTripsPage, DriverTripsQuery>(
        (ref, query) => ref.watch(driverWorkspaceServiceProvider).trips(query));
final driverTripProvider = FutureProvider.autoDispose
    .family<DriverTrip, String>(
        (ref, id) => ref.watch(driverWorkspaceServiceProvider).trip(id));
final driverCalendarProvider = FutureProvider.autoDispose
    .family<List<DriverTrip>, DateTime>((ref, month) =>
        ref.watch(driverWorkspaceServiceProvider).calendar(month));
final driverDocumentsProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(driverWorkspaceServiceProvider).documents());
final driverDocumentTypesProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(driverWorkspaceServiceProvider).documentTypes());
final driverNotificationsProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(driverWorkspaceServiceProvider).notifications());
void refreshDriverTrips(WidgetRef ref, [String? tripId]) {
  if (tripId != null) ref.invalidate(driverTripProvider(tripId));
  ref.invalidate(driverTripsProvider);
  ref.invalidate(driverDashboardProvider);
  ref.invalidate(driverCalendarProvider);
  ref.invalidate(driverNotificationsProvider);
}
