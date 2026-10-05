import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/models/current_user.dart';

/// Changes only when principal or effective access changes, not every refresh.
/// Feature services watch it so dependent controller families drop old data.
final workspaceDataScopeProvider = Provider<String>((ref) {
  return ref.watch(
    authControllerProvider.select(
      (state) => workspaceDataScope(
        state.isAuthenticated ? state.user : null,
        isDemo: state.isDemo,
      ),
    ),
  );
});
String workspaceDataScope(CurrentUser? user, {bool isDemo = false}) {
  if (user == null) return 'unauthenticated';
  List<List<Object>> entries(Map<String, Object> values) =>
      (values.keys.toList()..sort())
          .map((key) => <Object>[key, values[key]!])
          .toList();
  final access = user.access;
  return jsonEncode([
    user.role.apiValue,
    user.id,
    isDemo,
    access.loaded,
    entries(access.features),
    entries(access.reports),
    entries(access.grants),
    access.navigation.toList()..sort(),
  ]);
}
