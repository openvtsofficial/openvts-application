import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/permission_helper.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/current_user.dart';

/// The API remains authoritative for ownership and assignment scope on records.
final adminActorProvider = Provider<CurrentUser?>(
  (ref) => ref.watch(authControllerProvider).user,
);

bool adminCanPerform(WidgetRef ref, String capability, {Set<String>? scopes}) =>
    PermissionHelper.canPerform(
      ref.watch(adminActorProvider),
      capability,
      scopes: scopes,
    );

class AdminActionGate extends ConsumerWidget {
  const AdminActionGate({
    super.key,
    required this.capability,
    required this.child,
    this.scopes,
  });
  final String capability;
  final Set<String>? scopes;
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      adminCanPerform(ref, capability, scopes: scopes)
      ? child
      : const SizedBox.shrink();
}
