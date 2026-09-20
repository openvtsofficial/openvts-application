import 'package:socket_io_client/socket_io_client.dart' as io;

import '../storage/token_storage.dart';
import '../config/app_config.dart';

typedef SocketEventHandler = void Function(dynamic data);

class SocketService {
  SocketService(
    this._tokenStorage, {
    required String apiBaseUrl,
  }) : _apiBaseUrl = apiBaseUrl;

  final TokenStorage _tokenStorage;
  final String _apiBaseUrl;
  final Set<_IoSocketConnection> _connections = <_IoSocketConnection>{};
  bool _disposed = false;

  /// Closes every namespace opened for this configured server.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    for (final connection in _connections.toList(growable: false)) {
      connection.disconnect();
    }
    _connections.clear();
  }

  Future<SocketConnection> connect(
    String namespace, {
    bool authenticated = true,
  }) async {
    if (_disposed) throw StateError('The socket service is closed.');
    final sessionRevision = _tokenStorage.sessionRevision;
    final validationError = AppConfig.validateApiBaseUrl(_apiBaseUrl);
    if (validationError != null) {
      throw ArgumentError(validationError);
    }
    String? token;
    if (authenticated) {
      token = _tokenStorage.cachedActiveAccessToken;
      if (token == null && !_tokenStorage.isCacheHydrated) {
        await _tokenStorage.hydrateCache();
        token = _tokenStorage.cachedActiveAccessToken;
      }
    }
    if (_disposed || sessionRevision != _tokenStorage.sessionRevision) {
      throw StateError('The socket session changed.');
    }
    final originatingSession = _tokenStorage.cachedActiveSession;
    if (authenticated && (originatingSession == null || token == null)) {
      throw StateError('Sign in before opening a live connection.');
    }
    final url = socketUrlForApiBase(_apiBaseUrl, namespace);

    final options = io.OptionBuilder()
        .setPath('/socket.io')
        // The Nest gateways intentionally expose WebSocket transport only.
        // Advertising polling first causes avoidable failed handshakes.
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setAuth(
          authenticated
              ? <String, dynamic>{'token': token}
              : const <String, dynamic>{},
        )
        .enableReconnection()
        .setReconnectionDelay(500)
        .setReconnectionDelayMax(2000)
        .setReconnectionAttempts(double.infinity)
        .build()
      ..['reconnection'] = true
      // A namespace must not reuse a manager retained by an old server/session.
      ..['forceNew'] = true;

    final socket = io.io(url, options);
    late final _IoSocketConnection connection;
    connection = _IoSocketConnection(socket, onClosed: () {
      _connections.remove(connection);
    });
    _connections.add(connection);
    // Token rotation is allowed only within the same explicit login/session.
    // An old server's reconnect must never borrow another account's token.
    socket.auth = (callback) {
      final current = _tokenStorage.cachedActiveSession;
      final sameSession = !authenticated ||
          (sessionRevision == _tokenStorage.sessionRevision &&
              originatingSession != null &&
              current != null &&
              _tokenStorage.cachedActiveAccessToken != null &&
              current.user.id == originatingSession.user.id &&
              current.user.effectiveBackendRole ==
                  originatingSession.user.effectiveBackendRole);
      if (_disposed || connection.isClosed || !sameSession) {
        connection.disconnect();
        return;
      }
      callback(
        authenticated
            ? <String, dynamic>{
                'token': _tokenStorage.cachedActiveAccessToken,
              }
            : const <String, dynamic>{},
      );
    };

    socket.connect();
    return connection;
  }

  static String socketUrlForApiBase(String apiBaseUrl, String namespace) {
    final normalizedNamespace =
        namespace.startsWith('/') ? namespace : '/$namespace';
    final normalizedApiBase = apiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    if (normalizedApiBase.isEmpty) {
      return normalizedNamespace;
    }

    final uri = Uri.tryParse(normalizedApiBase);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      return '${uri.scheme}://${uri.authority}$normalizedNamespace';
    }

    final socketBase = normalizedApiBase == '/api'
        ? ''
        : normalizedApiBase.endsWith('/api')
            ? normalizedApiBase.substring(0, normalizedApiBase.length - 4)
            : normalizedApiBase;
    return '$socketBase$normalizedNamespace';
  }
}

abstract class SocketConnection {
  bool get isConnected;

  void emit(String event, [dynamic data]);

  void on(String event, SocketEventHandler handler);

  void off(String event, [SocketEventHandler? handler]);

  void onConnect(void Function() handler);

  void onDisconnect(SocketEventHandler handler);

  void onError(SocketEventHandler handler);

  void disconnect();
}

class _IoSocketConnection implements SocketConnection {
  _IoSocketConnection(this._socket, {required void Function() onClosed})
      : _onClosed = onClosed;

  final io.Socket _socket;
  final void Function() _onClosed;
  bool isClosed = false;

  @override
  bool get isConnected => _socket.connected;

  @override
  void emit(String event, [dynamic data]) {
    if (data == null) {
      _socket.emit(event);
      return;
    }

    _socket.emit(event, data);
  }

  @override
  void on(String event, SocketEventHandler handler) {
    _socket.on(event, handler);
  }

  @override
  void off(String event, [SocketEventHandler? handler]) {
    if (handler == null) {
      _socket.off(event);
      return;
    }

    _socket.off(event, handler);
  }

  @override
  void onConnect(void Function() handler) {
    _socket.onConnect((_) => handler());
  }

  @override
  void onDisconnect(SocketEventHandler handler) {
    _socket.onDisconnect(handler);
  }

  @override
  void onError(SocketEventHandler handler) {
    _socket.onError(handler);
    _socket.onConnectError(handler);
  }

  @override
  void disconnect() {
    if (isClosed) return;
    isClosed = true;
    _socket.disconnect();
    _socket.dispose();
    _onClosed();
  }
}
