import 'package:dio/dio.dart';

import '../demo/demo_api_policy.dart';
import '../performance/open_vts_perf.dart';
import 'api_exception.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient(
    this._dio, {
    DemoApiPolicy? demoPolicy,
  }) : _demoPolicy = demoPolicy;

  final Dio _dio;
  final DemoApiPolicy? _demoPolicy;

  bool get isDemoMode => _demoPolicy?.isEnabled == true;

  /// Resolves an endpoint for diagnostics without query parameters, fragments,
  /// credentials, headers, or request data.
  String safeResolvedUrl(String endpoint) {
    final base = Uri.tryParse(_dio.options.baseUrl);
    final target = Uri.tryParse(_endpointForRequest(endpoint));
    final resolved =
        base != null && target != null ? base.resolveUri(target) : target;
    if (resolved == null) return _safeEndpointForPerf(endpoint);
    if (!resolved.hasAuthority) return resolved.path;
    final port = resolved.hasPort ? ':${resolved.port}' : '';
    return '${resolved.scheme}://${resolved.host}$port${resolved.path}';
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) {
    return OpenVtsPerf.traceAsync(_apiPerfLabel('GET', endpoint), () async {
      final resolution = _demoPolicy?.resolveGet(endpoint, queryParameters) ??
          DemoGetResolution.remote(
            endpoint: endpoint,
            queryParameters: queryParameters,
          );
      if (resolution.hasLocalPayload) {
        return _parseLocalResponse(
          resolution.adapt(resolution.localPayload),
          parser,
        );
      }

      final response = await _dio.get<dynamic>(
        _endpointForRequest(resolution.endpoint),
        queryParameters: resolution.queryParameters,
        options: options,
      );
      return _parseResponse(
        response,
        (json) => parser(resolution.adapt(json)),
      );
    });
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) {
    return OpenVtsPerf.traceAsync(_apiPerfLabel('POST', endpoint), () async {
      _demoPolicy?.ensureMutationAllowed('POST', endpoint);
      final response = await _dio.post<dynamic>(
        _endpointForRequest(endpoint),
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseResponse(response, parser);
    });
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    required T Function(dynamic json) parser,
  }) {
    return OpenVtsPerf.traceAsync(_apiPerfLabel('PUT', endpoint), () async {
      _demoPolicy?.ensureMutationAllowed('PUT', endpoint);
      final response = await _dio.put<dynamic>(
        _endpointForRequest(endpoint),
        data: data,
        options: options,
      );
      return _parseResponse(response, parser);
    });
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) parser,
  }) {
    return OpenVtsPerf.traceAsync(_apiPerfLabel('PATCH', endpoint), () async {
      _demoPolicy?.ensureMutationAllowed('PATCH', endpoint);
      final response = await _dio.patch<dynamic>(
        _endpointForRequest(endpoint),
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseResponse(response, parser);
    });
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    required T Function(dynamic json) parser,
  }) {
    return OpenVtsPerf.traceAsync(_apiPerfLabel('DELETE', endpoint), () async {
      _demoPolicy?.ensureMutationAllowed('DELETE', endpoint);
      final response = await _dio.delete<dynamic>(
        _endpointForRequest(endpoint),
        data: data,
        options: options,
      );
      return _parseResponse(response, parser);
    });
  }

  String _apiPerfLabel(String method, String endpoint) {
    return 'api.$method ${_safeEndpointForPerf(endpoint)}';
  }

  String _endpointForRequest(String endpoint) {
    final target = Uri.tryParse(endpoint.trim());
    if (target?.hasScheme == true) return endpoint;

    final baseUrl = _dio.options.baseUrl.trim();
    final base = Uri.tryParse(baseUrl);
    if (base == null || base.path.isEmpty || base.path == '/') return endpoint;

    final normalizedBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final normalizedEndpoint = endpoint.trim().replaceFirst(RegExp(r'^/+'), '');
    final normalizedBasePath = base.path.replaceAll(RegExp(r'^/+|/+$'), '');
    if (normalizedBasePath.isNotEmpty &&
        (normalizedEndpoint == normalizedBasePath ||
            normalizedEndpoint.startsWith('$normalizedBasePath/'))) {
      return '${base.scheme}://${base.authority}/$normalizedEndpoint';
    }
    return '$normalizedBase/$normalizedEndpoint';
  }

  String _safeEndpointForPerf(String endpoint) {
    final normalized = endpoint.trim();
    if (normalized.isEmpty) {
      return '/';
    }

    final parsed = Uri.tryParse(normalized);
    final path = parsed?.path.trim();
    if (path != null && path.isNotEmpty) {
      return path.startsWith('/') ? path : '/$path';
    }

    final withoutQuery = normalized.split('?').first.split('#').first.trim();
    if (withoutQuery.isEmpty) {
      return '/';
    }

    return withoutQuery.startsWith('/') ? withoutQuery : '/$withoutQuery';
  }

  ApiResponse<T> _parseResponse<T>(
    Response<dynamic> response,
    T Function(dynamic json) parser,
  ) {
    final data = response.data;
    if (data is Map<String, dynamic> && _looksLikeEnvelope(data)) {
      try {
        final apiResponse = ApiResponse<T>.fromJson(data, parser);
        if (apiResponse.success) {
          return ApiResponse<T>(
            success: apiResponse.success,
            data: apiResponse.data,
            message: apiResponse.message,
            timestamp: apiResponse.timestamp,
            statusCode: response.statusCode,
          );
        }
      } catch (_) {
        // Fall through to the implicit envelope path below.
      }

      if (_canUseImplicitEnvelope(data, response.statusCode)) {
        try {
          return ApiResponse<T>(
            success: true,
            data: parser(_extractEnvelopePayload(data)),
            message: _extractMessage(data),
            statusCode: response.statusCode,
          );
        } catch (_) {
          throw ApiException(
            message: 'Invalid API response format',
            statusCode: response.statusCode,
            details: data,
          );
        }
      }

      final apiResponse = ApiResponse<T>.fromJson(data, parser);
      throw ApiException(
        message: apiResponse.message ?? 'Request failed',
        statusCode: response.statusCode,
        details: data,
      );
    }

    try {
      return ApiResponse<T>(
        success: _isSuccessStatusCode(response.statusCode),
        data: parser(data),
        message: _extractMessage(data),
        statusCode: response.statusCode,
      );
    } catch (_) {
      throw ApiException(
        message: 'Invalid API response format',
        statusCode: response.statusCode,
        details: data,
      );
    }
  }

  ApiResponse<T> _parseLocalResponse<T>(
    dynamic payload,
    T Function(dynamic json) parser,
  ) {
    try {
      return ApiResponse<T>(
        success: true,
        data: parser(payload),
        message: 'Demo data loaded',
      );
    } catch (_) {
      throw ApiException(
        message: 'Invalid demo response format',
        statusCode: 500,
        details: payload,
      );
    }
  }

  bool _looksLikeEnvelope(Map<String, dynamic> data) {
    if (data.containsKey('data') ||
        data.containsKey('success') ||
        data['action'] is bool ||
        data.containsKey('timestamp')) {
      return true;
    }

    final status = data['status']?.toString().trim().toLowerCase();
    return status == 'success' ||
        status == 'ok' ||
        status == 'error' ||
        status == 'failed' ||
        status == 'fail';
  }

  bool _canUseImplicitEnvelope(Map<String, dynamic> data, int? statusCode) {
    if (!data.containsKey('data') || !_isSuccessStatusCode(statusCode)) {
      return false;
    }

    final status = data['status']?.toString().trim().toLowerCase();
    if (status == 'error' || status == 'failed' || status == 'fail') {
      return false;
    }

    if (data['success'] == false) {
      return false;
    }

    if (data['action'] == false) {
      return false;
    }

    final envelope = _asMap(data['data']);
    if (envelope['action'] == false) {
      return false;
    }

    return true;
  }

  dynamic _extractEnvelopePayload(Map<String, dynamic> data) {
    final envelope = data['data'];
    final envelopeMap = _asMap(envelope);

    if (envelopeMap.containsKey('data')) {
      return envelopeMap['data'];
    }

    return envelope;
  }

  bool _isSuccessStatusCode(int? statusCode) {
    if (statusCode == null) {
      return true;
    }

    return statusCode >= 200 && statusCode < 300;
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final envelope = _asMap(data['data']);
      final nestedMessage = envelope['message']?.toString().trim();
      if (nestedMessage != null && nestedMessage.isNotEmpty) {
        return nestedMessage;
      }

      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    if (data is String) {
      final message = data.trim();
      if (message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), item),
      );
    }

    return const <String, dynamic>{};
  }
}
