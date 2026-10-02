import 'package:intl/intl.dart';

import '../api/api_exception.dart';

typedef DemoPayloadAdapter = dynamic Function(dynamic payload);

class DemoGetResolution {
  const DemoGetResolution.remote({
    required this.endpoint,
    this.queryParameters,
    this.adapter,
  })  : hasLocalPayload = false,
        localPayload = null;

  const DemoGetResolution.local(
    this.localPayload, {
    this.adapter,
  })  : endpoint = '',
        queryParameters = null,
        hasLocalPayload = true;

  final String endpoint;
  final Map<String, dynamic>? queryParameters;
  final bool hasLocalPayload;
  final dynamic localPayload;
  final DemoPayloadAdapter? adapter;

  dynamic adapt(dynamic payload) => adapter?.call(payload) ?? payload;
}

/// Enforces the backend's public-demo trust boundary in one place.
///
/// Demo mode may read only public `/demo/*` data. All writes are rejected
/// before Dio is invoked, so no production controller, database mutation, or
/// device command can be reached even if a feature forgets to disable a button.
class DemoApiPolicy {
  const DemoApiPolicy({required bool Function() isDemoMode})
      : _isDemoMode = isDemoMode;

  static const restrictedMessage = 'This action is restricted in demo mode.';

  final bool Function() _isDemoMode;

  bool get isEnabled => _isDemoMode();

  DemoGetResolution resolveGet(
    String endpoint,
    Map<String, dynamic>? queryParameters,
  ) {
    if (!isEnabled) {
      return DemoGetResolution.remote(
        endpoint: endpoint,
        queryParameters: queryParameters,
      );
    }

    final path = _pathOf(endpoint);
    final originalQuery = Map<String, dynamic>.from(
      queryParameters ?? const <String, dynamic>{},
    );

    final localPayload = _localPayload(path);
    if (localPayload != null) {
      return DemoGetResolution.local(localPayload);
    }

    if (path.startsWith('/demo/')) {
      return DemoGetResolution.remote(
        endpoint: endpoint,
        queryParameters: _withDemoTimeContext(originalQuery),
      );
    }

    if (path == '/vehicletypes') {
      return DemoGetResolution.remote(
        endpoint: '/demo/vehicletypes',
        queryParameters: _withDemoTimeContext(originalQuery),
      );
    }
    if (path == '/timezones') {
      return DemoGetResolution.remote(
        endpoint: '/demo/timezones',
        queryParameters: _withDemoTimeContext(originalQuery),
      );
    }

    if (!path.startsWith('/user/')) {
      throw const ApiException(
        message: restrictedMessage,
        statusCode: 403,
        details: <String, dynamic>{'mode': 'demo', 'readOnly': true},
      );
    }

    if (path == '/user/profile/email-subscription') {
      return const DemoGetResolution.local(<String, dynamic>{
        'isSubscribed': true,
        'scope': 'demo',
      });
    }

    if (path == '/user/localization' || path == '/user/settings') {
      final timeFormat = _demoTimeFormat();
      return _remote(
        '/demo/localization',
        originalQuery,
        adapter: (payload) {
          final source = _asMap(payload);
          return <String, dynamic>{
            ...source,
            'languageCode': source['languageCode'] ?? 'en',
            'layoutDirection': 'LTR',
            'dateFormat': source['dateFormat'] ?? 'MM/DD/YYYY',
            'timeFormat': timeFormat,
            'use24Hour': timeFormat == '24H',
            'theme': 'SYSTEM',
            'timezoneOffset': '-05:00',
            'distanceUnit': 'KM',
            'units': 'KM',
          };
        },
      );
    }

    if (path == '/user/map/vehicles') {
      return _remote('/demo/vehicles', originalQuery);
    }

    if (path == '/user/transactions') {
      return _remote(
        '/demo/transactions',
        originalQuery,
        adapter: (payload) => _adaptTransactions(payload, originalQuery),
      );
    }

    if (path == '/user/sharetracklinks') {
      return _remote(
        '/demo/share-track-links',
        originalQuery,
        adapter: (payload) => _adaptPagedCollection(
          payload,
          sourceKey: 'links',
          outputKey: 'links',
          query: originalQuery,
          searchKeys: const <String>[
            'id',
            'uniqueCode',
            'vehicleName',
            'name',
          ],
        ),
      );
    }

    final shareLinkMatch =
        RegExp(r'^/user/sharetracklinks/([^/]+)$').firstMatch(path);
    if (shareLinkMatch != null) {
      return _remote(
        '/demo/share-track-links/${shareLinkMatch.group(1)}',
        originalQuery,
      );
    }

    if (path == '/user/subusers') {
      return _remote(
        '/demo/subusers',
        originalQuery,
        adapter: (payload) => _adaptPagedCollection(
          payload,
          sourceKey: 'subusers',
          outputKey: 'subusers',
          query: originalQuery,
          searchKeys: const <String>[
            'id',
            'name',
            'username',
            'email',
            'mobile',
            'status',
          ],
        ),
      );
    }

    if (path == '/user/tickets') {
      return _remote(
        '/demo/support-tickets',
        originalQuery,
        adapter: (payload) => _adaptSupportTickets(
          payload,
          query: originalQuery,
        ),
      );
    }

    final ticketMatch = RegExp(r'^/user/tickets/([^/]+)$').firstMatch(path);
    if (ticketMatch != null) {
      final ticketId = Uri.decodeComponent(ticketMatch.group(1)!);
      return _remote(
        '/demo/support-tickets',
        originalQuery,
        adapter: (payload) => _adaptSupportTicketDetail(payload, ticketId),
      );
    }

    if (path == '/user/notifications') {
      return DemoGetResolution.remote(
        endpoint: '/demo/notifications',
        queryParameters: _withDemoTimeContext(
          const <String, dynamic>{'page': 1, 'limit': 100},
        ),
        adapter: (payload) => _adaptNotifications(payload, originalQuery),
      );
    }

    if (path == '/user/notifications/preferences') {
      return _remote('/demo/notifications/preferences', originalQuery);
    }

    if (path.startsWith('/user/reports/') ||
        path == '/user/history' ||
        path.startsWith('/user/landmarkbulkjobs')) {
      throw const ApiException(
        message:
            'This feature is not available in demo mode. Sign in to access it.',
        statusCode: 403,
        details: <String, dynamic>{'mode': 'demo', 'readOnly': true},
      );
    }

    return _remote(path.replaceFirst('/user/', '/demo/'), originalQuery);
  }

  void ensureMutationAllowed(String method, String endpoint) {
    if (!isEnabled) {
      return;
    }

    throw ApiException(
      message: restrictedMessage,
      statusCode: 403,
      details: <String, dynamic>{
        'mode': 'demo',
        'readOnly': true,
        'method': method.toUpperCase(),
        'endpoint': _pathOf(endpoint),
      },
    );
  }

  DemoGetResolution _remote(
    String endpoint,
    Map<String, dynamic> query, {
    DemoPayloadAdapter? adapter,
  }) {
    return DemoGetResolution.remote(
      endpoint: endpoint,
      queryParameters: _withDemoTimeContext(query),
      adapter: adapter,
    );
  }

  dynamic _localPayload(String path) {
    switch (path) {
      case '/languages':
        return const <String, dynamic>{
          'languages': <Map<String, String>>[
            <String, String>{'code': 'en', 'label': 'English'},
            <String, String>{'code': 'hi', 'label': 'Hindi'},
            <String, String>{'code': 'ar', 'label': 'Arabic'},
            <String, String>{'code': 'es', 'label': 'Spanish'},
            <String, String>{'code': 'fr', 'label': 'French'},
            <String, String>{'code': 'pt', 'label': 'Portuguese'},
          ],
        };
      case '/dateformats':
        return const <String, dynamic>{
          'dateFormats': <String>[
            'MM/DD/YYYY',
            'DD/MM/YYYY',
            'YYYY-MM-DD',
          ],
        };
      case '/countries':
        return const <String, dynamic>{
          'countries': <Map<String, String>>[
            <String, String>{
              'countryCode': 'US',
              'name': 'United States',
            },
          ],
        };
      case '/mobileprefix':
        return const <String, dynamic>{
          'prefixes': <Map<String, String>>[
            <String, String>{
              'countryCode': 'US',
              'name': 'United States',
              'mobilePrefix': '+1',
            },
          ],
        };
      case '/states/US':
      case '/states/United%20States':
      case '/states/United States':
        return const <String, dynamic>{
          'states': <Map<String, String>>[
            <String, String>{'stateCode': 'NY', 'name': 'New York'},
          ],
        };
      case '/cities/US/NY':
      case '/cities/United%20States/New%20York':
      case '/cities/United States/New York':
        return const <String, dynamic>{
          'cities': <Map<String, String>>[
            <String, String>{
              'name': 'New York City',
              'stateCode': 'NY',
              'countryCode': 'US',
            },
          ],
        };
      case '/documenttypes/VEHICLE':
        return const <String, dynamic>{
          'documentTypes': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 1,
              'name': 'Registration',
              'docFor': 'VEHICLE',
            },
            <String, dynamic>{
              'id': 2,
              'name': 'Insurance',
              'docFor': 'VEHICLE',
            },
          ],
        };
      case '/documenttypes/DRIVER':
        return const <String, dynamic>{
          'documentTypes': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 1,
              'name': 'Driver License',
              'docFor': 'DRIVER',
            },
            <String, dynamic>{
              'id': 2,
              'name': 'Insurance Certificate',
              'docFor': 'DRIVER',
            },
          ],
        };
      default:
        return null;
    }
  }

  Map<String, dynamic> _withDemoTimeContext(Map<String, dynamic> query) {
    final offset = DateTime.now().timeZoneOffset;
    final minutes = offset.inMinutes.clamp(-720, 840).toInt();
    final sign = minutes < 0 ? '-' : '+';
    final absolute = minutes.abs();
    final hoursText = (absolute ~/ 60).toString().padLeft(2, '0');
    final minutesText = (absolute % 60).toString().padLeft(2, '0');

    return <String, dynamic>{
      ...query,
      'demoTz': DateTime.now().timeZoneName,
      'demoTzOffsetMin': minutes,
      'demoTzOffset': '$sign$hoursText:$minutesText',
      'demoTimeFormat': _demoTimeFormat(),
    };
  }

  String _demoTimeFormat() {
    try {
      final pattern = DateFormat.jm().pattern ?? '';
      return pattern.contains('H') ? '24H' : '12H';
    } catch (_) {
      return '24H';
    }
  }

  dynamic _adaptNotifications(
    dynamic payload,
    Map<String, dynamic> query,
  ) {
    final source = _asMap(payload);
    final rawItems = _asList(source['notifications']);
    final normalized = <Map<String, dynamic>>[];
    for (var index = 0; index < rawItems.length; index++) {
      final item = _asMap(rawItems[index]);
      final rawId = item['id']?.toString() ?? 'notif-${index + 1}';
      final suffix =
          int.tryParse(RegExp(r'(\d+)$').firstMatch(rawId)?.group(1) ?? '');
      final numericId = 1000000 - (suffix ?? index + 1);
      normalized.add(<String, dynamic>{
        ...item,
        'id': numericId,
        'notificationId': numericId,
        'dedupeKey': 'demo:$rawId',
        'createdAt': item['timestamp'],
        'isRead': item['read'] == true,
        'metadata': <String, dynamic>{
          ...item,
          'demoNotificationId': rawId,
        },
      });
    }

    final unreadOnly = _asBool(query['unreadOnly']);
    final category = query['category']?.toString().trim().toLowerCase() ?? '';
    var filtered = normalized.where((item) {
      if (unreadOnly && item['isRead'] == true) {
        return false;
      }
      if (category.isNotEmpty) {
        final itemCategory =
            (item['type'] ?? item['category'])?.toString().toLowerCase() ?? '';
        if (itemCategory != category) {
          return false;
        }
      }
      return true;
    }).toList(growable: false);

    final beforeId = _asInt(query['beforeId']);
    if (beforeId != null) {
      filtered = filtered
          .where((item) => (_asInt(item['id']) ?? 0) < beforeId)
          .toList(growable: false);
    }
    filtered.sort(
      (left, right) =>
          (_asInt(right['id']) ?? 0).compareTo(_asInt(left['id']) ?? 0),
    );

    final requestedLimit = (_asInt(query['limit']) ?? 20).clamp(1, 100).toInt();
    final hasMore = filtered.length > requestedLimit;
    final pageItems = filtered.take(requestedLimit).toList(growable: false);
    final unreadCount =
        normalized.where((item) => item['isRead'] != true).length;

    return <String, dynamic>{
      'items': pageItems,
      'hasMore': hasMore,
      'nextBeforeId':
          hasMore && pageItems.isNotEmpty ? pageItems.last['id'] : null,
      'unreadCount': unreadCount,
    };
  }

  dynamic _adaptTransactions(
    dynamic payload,
    Map<String, dynamic> query,
  ) {
    final source = _asMap(payload);
    final plan = _asMap(source['plan']);
    var invoiceIndex = 0;
    final invoices = _asList(source['invoices']).map((raw) {
      final currentIndex = invoiceIndex++;
      final invoice = _asMap(raw);
      final status = invoice['status']?.toString().trim().toLowerCase();
      final method = invoice['method']?.toString() ?? '';
      return <String, dynamic>{
        'id': invoice['id'],
        'amount': invoice['amount'],
        'currency': plan['currency'] ?? 'USD',
        'paymentType': 'SUBSCRIPTION',
        'paymentMode': method.toLowerCase().contains('visa') ? 'CARD' : 'OTHER',
        'status': status == 'paid'
            ? 'SUCCESS'
            : status == 'failed'
                ? 'FAILED'
                : 'PENDING',
        'reference': invoice['id'],
        'provider': method,
        'providerRef': invoice['id'],
        'createdAt': _demoInvoiceDate(currentIndex),
        'meta': <String, dynamic>{
          'demoOriginalDate': invoice['date'],
        },
        'plan': <String, dynamic>{
          'id': 'demo-plan',
          'name': plan['name'],
          'price': plan['monthlyRate'],
          'currency': plan['currency'],
        },
      };
    }).toList(growable: false);

    final statusFilter = query['status']?.toString().trim().toUpperCase() ?? '';
    final search =
        (query['q'] ?? query['search'])?.toString().trim().toLowerCase() ?? '';
    final from = query['from']?.toString().trim() ?? '';
    final to = query['to']?.toString().trim() ?? '';
    final filtered = invoices.where((item) {
      if (statusFilter.isNotEmpty &&
          item['status']?.toString().toUpperCase() != statusFilter) {
        return false;
      }
      if (search.isNotEmpty &&
          !item.values.join(' ').toLowerCase().contains(search)) {
        return false;
      }
      final date = item['createdAt']?.toString() ?? '';
      if (from.isNotEmpty && date.compareTo(from) < 0) {
        return false;
      }
      if (to.isNotEmpty && date.compareTo(to) > 0) {
        return false;
      }
      return true;
    }).toList(growable: false);

    return _paginate(
      filtered,
      page: _asInt(query['page']) ?? 1,
      limit: _asInt(query['limit']) ?? 100,
      outputKey: 'items',
    );
  }

  String _demoInvoiceDate(int monthsAgo) {
    final now = DateTime.now();
    final shifted = DateTime(now.year, now.month - monthsAgo, 1);
    return DateTime.utc(shifted.year, shifted.month, shifted.day)
        .toIso8601String();
  }

  dynamic _adaptSupportTickets(
    dynamic payload, {
    required Map<String, dynamic> query,
  }) {
    final source = _asMap(payload);
    var tickets = _asList(source['tickets'])
        .map(_normalizeSupportTicket)
        .toList(growable: false);

    final status = query['status']?.toString().trim().toUpperCase() ?? '';
    final search =
        (query['search'] ?? query['q'])?.toString().trim().toLowerCase() ?? '';
    tickets = tickets.where((ticket) {
      if (status.isNotEmpty &&
          ticket['status']?.toString().toUpperCase() != status) {
        return false;
      }
      return search.isEmpty ||
          ticket.values.join(' ').toLowerCase().contains(search);
    }).toList(growable: false);

    return <String, dynamic>{'tickets': tickets};
  }

  dynamic _adaptSupportTicketDetail(dynamic payload, String ticketId) {
    final source = _asMap(payload);
    for (final raw in _asList(source['tickets'])) {
      final ticket = _normalizeSupportTicket(raw);
      if (ticket['id']?.toString() == ticketId) {
        return ticket;
      }
    }
    throw const ApiException(
      message: 'Demo support ticket was not found.',
      statusCode: 404,
    );
  }

  Map<String, dynamic> _normalizeSupportTicket(dynamic raw) {
    final source = _asMap(raw);
    final id = source['id']?.toString() ?? '';
    final assignedTo = source['assignedTo']?.toString().trim();
    final rawStatus = source['status']?.toString().toLowerCase();
    final status = rawStatus == 'resolved' || rawStatus == 'closed'
        ? 'CLOSED'
        : rawStatus == 'in_progress' || rawStatus == 'in-progress'
            ? 'IN_PROGRESS'
            : 'OPEN';
    final messages = _asList(source['messages']).map((rawMessage) {
      final message = _asMap(rawMessage);
      final senderName = message['sender']?.toString().trim() ?? 'Support Team';
      final fromDemoUser = senderName == 'Demo Fleet Manager';
      return <String, dynamic>{
        ...message,
        'message': message['body'],
        'createdAt': message['sentAt'],
        'senderId': fromDemoUser ? 'demo-user' : 'demo-support',
        'sender': <String, dynamic>{
          'id': fromDemoUser ? 'demo-user' : 'demo-support',
          'name': senderName,
          'role': fromDemoUser ? 'USER' : 'SUPPORT',
        },
      };
    }).toList(growable: false);

    return <String, dynamic>{
      ...source,
      'id': id,
      'ticketNo': id,
      'title': source['subject'],
      'status': status,
      'category': 'OTHER',
      'priority': source['priority']?.toString().toUpperCase(),
      'messageCount': messages.length,
      'lastMessageAt':
          messages.isEmpty ? source['updatedAt'] : messages.last['createdAt'],
      'fromUser': const <String, dynamic>{
        'id': 'demo-user',
        'name': 'Demo Fleet Manager',
        'email': 'demo@openvts.io',
        'role': 'USER',
      },
      'toUser': assignedTo == null || assignedTo.isEmpty
          ? null
          : <String, dynamic>{
              'id': 'demo-support',
              'name': assignedTo,
              'role': 'SUPPORT',
            },
      'messages': messages,
    };
  }

  dynamic _adaptPagedCollection(
    dynamic payload, {
    required String sourceKey,
    required String outputKey,
    required Map<String, dynamic> query,
    required List<String> searchKeys,
  }) {
    final source = _asMap(payload);
    final search =
        (query['search'] ?? query['q'])?.toString().trim().toLowerCase() ?? '';
    final filtered = _asList(source[sourceKey]).where((raw) {
      if (search.isEmpty) {
        return true;
      }
      final item = _asMap(raw);
      return searchKeys.any(
        (key) => item[key]?.toString().toLowerCase().contains(search) == true,
      );
    }).toList(growable: false);

    return _paginate(
      filtered,
      page: _asInt(query['page']) ?? 1,
      limit: _asInt(query['limit']) ?? 100,
      outputKey: outputKey,
    );
  }

  Map<String, dynamic> _paginate(
    List<dynamic> items, {
    required int page,
    required int limit,
    required String outputKey,
  }) {
    final safePage = page < 1 ? 1 : page;
    final safeLimit = limit.clamp(1, 100).toInt();
    final start = (safePage - 1) * safeLimit;
    final pageItems = start >= items.length
        ? const <dynamic>[]
        : items.sublist(
            start,
            (start + safeLimit).clamp(0, items.length).toInt(),
          );
    return <String, dynamic>{
      outputKey: pageItems,
      'page': safePage,
      'limit': safeLimit,
      'total': items.length,
      'hasMore': safePage * safeLimit < items.length,
    };
  }

  String _pathOf(String endpoint) {
    final parsed = Uri.tryParse(endpoint);
    final path = parsed?.path.trim();
    if (path != null && path.isNotEmpty) {
      return path.startsWith('/') ? path : '/$path';
    }
    final normalized = endpoint.split('?').first.trim();
    return normalized.startsWith('/') ? normalized : '/$normalized';
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

  List<dynamic> _asList(dynamic value) {
    return value is List ? value : const <dynamic>[];
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    switch (value?.toString().trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
        return true;
      default:
        return false;
    }
  }
}
