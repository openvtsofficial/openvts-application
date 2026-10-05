import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import 'user_message_models.dart';

class UserMessagesService {
  UserMessagesService(this._api);
  final ApiClient _api;

  Future<UserMessageThreads> threads({String search = ''}) async {
    final term = search.trim();
    if (term.length > 100) {
      throw ArgumentError('Search must be at most 100 characters');
    }
    return (await _api.get(UserMessagesEndpoints.threads,
            // The server provides bounded search, without a thread cursor.
            queryParameters: {
              'limit': 500,
              if (term.isNotEmpty) 'search': term
            },
            parser: UserMessageThreads.fromJson))
        .data;
  }

  Future<UserMessagePage> messages(int driverId, {String? beforeId}) async {
    if (beforeId != null && !RegExp(r'^[1-9][0-9]*$').hasMatch(beforeId)) {
      throw ArgumentError('Invalid message cursor');
    }
    return (await _api.get(UserMessagesEndpoints.conversation(driverId),
            queryParameters: {
              'limit': 50,
              if (beforeId != null) 'beforeId': beforeId
            },
            parser: UserMessagePage.fromJson))
        .data;
  }

  Future<UserChatMessage> send(
      int driverId, String text, String clientMessageId) async {
    final body = text.trim();
    if (body.isEmpty || body.runes.length > 4000) {
      throw ArgumentError('Message must contain 1–4000 characters');
    }
    if (!RegExp(r'^[0-9a-fA-F]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}$')
        .hasMatch(clientMessageId)) {
      throw ArgumentError('Invalid client message ID');
    }
    return (await _api.post(UserMessagesEndpoints.conversation(driverId),
            data: {'body': body, 'clientMessageId': clientMessageId},
            parser: (json) =>
                UserChatMessage.fromJson(messageMap(json)['message'])))
        .data;
  }

  Future<int> markRead(int driverId) async => (await _api.post(
          UserMessagesEndpoints.read(driverId),
          parser: (json) => (messageMap(json)['totalUnread'] as num).toInt()))
      .data;
}
