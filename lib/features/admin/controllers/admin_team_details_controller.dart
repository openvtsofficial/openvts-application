import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../../../shared/models/user_role.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/admin_team_model.dart';
import '../models/admin_team_permissions.dart';
import '../services/admin_team_details_service.dart';

final adminTeamDetailsServiceProvider = Provider(
  (ref) => AdminTeamDetailsService(ref.watch(apiClientProvider)),
);

bool Function() _authorization(Ref ref) {
  final account = ref.watch(
    authControllerProvider.select(
      (s) => (s.user?.id, s.user?.role, s.isRealSession),
    ),
  );
  return () {
    final auth = ref.read(authControllerProvider);
    return auth.isRealSession &&
        auth.user?.id == account.$1 &&
        auth.user?.role == UserRole.admin;
  };
}

final adminTeamProfileControllerProvider = StateNotifierProvider.autoDispose
    .family<AdminTeamProfileController, AsyncValue<AdminTeamListItem>, String>(
      (ref, id) => AdminTeamProfileController(
        ref.watch(adminTeamDetailsServiceProvider),
        id,
        canManage: _authorization(ref),
      )..load(),
    );
final adminTeamPermissionsControllerProvider = StateNotifierProvider.autoDispose
    .family<
      AdminTeamPermissionsController,
      AsyncValue<AdminTeamPermissionSnapshot>,
      String
    >(
      (ref, id) => AdminTeamPermissionsController(
        ref.watch(adminTeamDetailsServiceProvider),
        id,
        canManage: _authorization(ref),
      )..load(),
    );
final adminTeamActivityControllerProvider = StateNotifierProvider.autoDispose
    .family<
      AdminTeamActivityController,
      AsyncValue<AdminTeamActivityPage>,
      String
    >(
      (ref, id) => AdminTeamActivityController(
        ref.watch(adminTeamDetailsServiceProvider),
        id,
        canManage: _authorization(ref),
      )..load(),
    );

abstract class _ScopedTeamController<T> extends StateNotifier<AsyncValue<T>> {
  _ScopedTeamController(this.service, this.id, bool Function()? canManage)
    : canManage = canManage ?? (() => true),
      super(const AsyncLoading());
  final AdminTeamDetailsService service;
  final String id;
  final bool Function() canManage;
  int generation = 0;
  bool busy = false;
  void authorize() {
    if (!mounted || !canManage()) {
      throw const ApiException(
        message: 'Unable to update permissions',
        statusCode: 403,
      );
    }
  }

  bool valid(int request) => mounted && generation == request && canManage();
  @override
  void dispose() {
    generation++;
    super.dispose();
  }
}

class AdminTeamProfileController
    extends _ScopedTeamController<AdminTeamListItem> {
  AdminTeamProfileController(
    AdminTeamDetailsService service,
    String id, {
    bool Function()? canManage,
  }) : super(service, id, canManage);
  Future<void> load() async {
    if (!mounted || busy) return;
    final request = ++generation;
    state = const AsyncLoading();
    try {
      authorize();
      final data = await service.profile(id);
      if (valid(request)) state = AsyncData(data);
    } catch (error, trace) {
      if (mounted && request == generation) state = AsyncError(error, trace);
    }
  }
}

class AdminTeamPermissionsController
    extends _ScopedTeamController<AdminTeamPermissionSnapshot> {
  AdminTeamPermissionsController(
    AdminTeamDetailsService service,
    String id, {
    bool Function()? canManage,
  }) : super(service, id, canManage);
  Future<void> load() async {
    if (!mounted || busy) return;
    final request = ++generation;
    state = const AsyncLoading();
    try {
      authorize();
      final data = await service.permissions(id);
      if (valid(request)) state = AsyncData(data);
    } catch (error, trace) {
      if (mounted && request == generation) state = AsyncError(error, trace);
    }
  }

  Future<bool> save(Map<String, String> selected) async {
    authorize();
    final snapshot = state.valueOrNull;
    if (busy || snapshot == null || state.isLoading) return false;
    final request = ++generation;
    busy = true;
    try {
      await service.savePermissions(
        id,
        legalAdminTeamGrants(snapshot.features, selected),
      );
      if (!valid(request)) return false;
      // Read the persisted server result; the replacement may create a private
      // internal role and revoke active sessions for this member.
      final data = await service.permissions(id);
      if (!valid(request)) return false;
      state = AsyncData(data);
      return true;
    } finally {
      busy = false;
    }
  }
}

class AdminTeamActivityController
    extends _ScopedTeamController<AdminTeamActivityPage> {
  AdminTeamActivityController(
    AdminTeamDetailsService service,
    String id, {
    bool Function()? canManage,
  }) : super(service, id, canManage);
  Future<void> load({bool more = false}) async {
    if (!mounted || busy) return;
    final previous = state.valueOrNull;
    if (more &&
        (previous == null || !previous.hasMore || previous.cursor == null)) {
      return;
    }
    final request = ++generation;
    busy = true;
    state = more && previous != null
        ? const AsyncLoading<AdminTeamActivityPage>().copyWithPrevious(
            AsyncData(previous),
          )
        : const AsyncLoading();
    try {
      authorize();
      final data = await service.activity(
        id,
        cursor: more ? previous?.cursor : null,
      );
      if (!valid(request)) return;
      final items = more && previous != null
          ? [...previous.items, ...data.items]
          : data.items;
      final seen = <String>{};
      final unique = items
          .where((item) => item['id'] == null || seen.add('${item['id']}'))
          .toList(growable: false);
      state = AsyncData(
        AdminTeamActivityPage(
          items: unique,
          hasMore: data.hasMore && (!more || data.cursor != previous?.cursor),
          cursor: data.cursor,
        ),
      );
    } catch (error, trace) {
      if (mounted && request == generation) {
        state = AsyncError<AdminTeamActivityPage>(error, trace)
            .copyWithPrevious(
              previous == null ? const AsyncLoading() : AsyncData(previous),
            );
      }
    } finally {
      busy = false;
    }
  }
}
