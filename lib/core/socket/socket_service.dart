import 'package:socket_io_client/socket_io_client.dart' as io;

import '../storage/token_storage.dart';

typedef SocketEventHandler = void Function(dynamic data);

class SocketService {
  SocketService(
    this._tokenStorage, {
    required String apiBaseUrl,
  }) : _apiBaseUrl = apiBaseUrl;

  final TokenStorage _tokenStorage;
  final String _apiBaseUrl;

  Future<SocketConnection> connect(
    String namespace, {
    bool authenticated = true,
  }) async {
    String? token;
    if (authenticated) {
      token = _tokenStorage.cachedActiveAccessToken;
      if (token == null && !_tokenStorage.isCacheHydrated) {
        await _tokenStorage.hydrateCache();
        token = _tokenStorage.cachedActiveAccessToken;
      }
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
      ..['reconnection'] = true;

    final socket = io.io(url, options);
    // socket_io_client invokes a functional auth value for every connection,
    // including reconnects. This keeps a long-lived map socket aligned with
    // access-token refreshes without rebuilding the entire controller.
    socket.auth = (callback) {
      callback(
        authenticated
            ? <String, dynamic>{
                'token': _tokenStorage.cachedActiveAccessToken,
              }
            : const <String, dynamic>{},
      );
    };

    socket.connect();
    return _IoSocketConnection(socket);
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
  _IoSocketConnection(this._socket);

  final io.Socket _socket;

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
    _socket.disconnect();
    _socket.dispose();
  }
}
