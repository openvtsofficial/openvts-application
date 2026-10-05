import 'package:dio/dio.dart';

import '../config/app_config.dart';

/// External routing transport. Deliberately separate from ApiClient and its
/// authentication, refresh, role, cache and logging interceptors.
class RoadRoutingClient {
  RoadRoutingClient({Dio? client, String? baseUrl})
    : _ownsClient = client == null,
      _client =
          client ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 15),
              headers: {'User-Agent': 'OpenVTS-Mobile/1.0 (route-builder)'},
            ),
          ),
      _baseUrl = _validateBase(baseUrl ?? AppConfig.osrmBaseUrl);

  final Dio _client;
  final bool _ownsClient;
  final String _baseUrl;
  static const maxWaypoints = 60;
  static const snapRadiusMeters = 50;
  static const _drivingPath = '/route/v1/driving/';

  static String _validateBase(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw ArgumentError(
        'OSRM_BASE_URL must be an HTTPS origin or base path.',
      );
    }
    return value.replaceFirst(RegExp(r'/+$'), '');
  }

  Future<dynamic> drivingRoute(
    List<({double latitude, double longitude})> stops, {
    RoadRoutingRequest? request,
  }) async {
    if (stops.length < 2 ||
        stops.length > maxWaypoints ||
        stops.any(
          (p) =>
              !p.latitude.isFinite ||
              !p.longitude.isFinite ||
              p.latitude.abs() > 90 ||
              p.longitude.abs() > 180,
        )) {
      throw ArgumentError('Invalid routing coordinates');
    }
    final coordinates = stops
        .map((p) => '${p.longitude},${p.latitude}')
        .join(';');
    try {
      final response = await _client.get<dynamic>(
        '$_baseUrl$_drivingPath$coordinates',
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'steps': false,
          'radiuses': List.filled(stops.length, snapRadiusMeters).join(';'),
        },
        cancelToken: request?._token,
      );
      return response.data;
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        throw const RoadRoutingCancelledException();
      }
      throw const RoadRoutingTransportException();
    }
  }

  void dispose() {
    if (_ownsClient) _client.close(force: true);
  }
}

class RoadRoutingRequest {
  final _token = CancelToken();
  bool get isCancelled => _token.isCancelled;
  void cancel() => _token.cancel();
  void throwIfCancelled() {
    if (isCancelled) throw const RoadRoutingCancelledException();
  }
}

class RoadRoutingCancelledException implements Exception {
  const RoadRoutingCancelledException();
}

class RoadRoutingTransportException implements Exception {
  const RoadRoutingTransportException();
}
