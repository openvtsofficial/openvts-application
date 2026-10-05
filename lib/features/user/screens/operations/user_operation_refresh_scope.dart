import 'dart:async';
import 'package:flutter/material.dart';

/// Revalidates only the visible foreground route, never polling behind another
/// page or while the app is backgrounded.
class UserOperationRefreshScope extends StatefulWidget {
  const UserOperationRefreshScope(
      {super.key, required this.onRefresh, required this.child});
  final VoidCallback onRefresh;
  final Widget child;
  @override
  State<UserOperationRefreshScope> createState() =>
      _UserOperationRefreshScopeState();
}

class _UserOperationRefreshScopeState extends State<UserOperationRefreshScope>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_foreground && (ModalRoute.of(context)?.isCurrent ?? true)) {
        widget.onRefresh();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    if (resumed && !_foreground && (ModalRoute.of(context)?.isCurrent ?? true)) {
      widget.onRefresh();
    }
    _foreground = resumed;
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
