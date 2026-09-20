import '../../../core/socket/socket_service.dart';
import '../models/live_map_role_config.dart';

class LiveMapSocketController {
  const LiveMapSocketController(this._socketService, this._config);

  final SocketService _socketService;
  final LiveMapRoleConfig _config;

  Future<SocketConnection> connectTelemetry() {
    return _socketService.connect(
      _config.telemetryNamespace,
      authenticated: _config.socketAuthenticationRequired,
    );
  }

  Future<SocketConnection> connectNotifications() {
    final namespace = _config.notificationNamespace;
    if (namespace == null) {
      return Future<SocketConnection>.value(const _NoopSocketConnection());
    }
    return _socketService.connect(
      namespace,
      authenticated: _config.socketAuthenticationRequired,
    );
  }
}

class _NoopSocketConnection implements SocketConnection {
  const _NoopSocketConnection();

  @override
  bool get isConnected => false;

  @override
  void disconnect() {}

  @override
  void emit(String event, [dynamic data]) {}

  @override
  void off(String event, [SocketEventHandler? handler]) {}

  @override
  void on(String event, SocketEventHandler handler) {}

  @override
  void onConnect(void Function() handler) {}

  @override
  void onDisconnect(SocketEventHandler handler) {}

  @override
  void onError(SocketEventHandler handler) {}
}
