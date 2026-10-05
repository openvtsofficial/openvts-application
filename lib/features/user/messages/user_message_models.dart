Map<String, dynamic> messageMap(dynamic value) {
  if (value is! Map) throw const FormatException('Invalid message response');
  return Map<String, dynamic>.from(value);
}

int _integer(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
String _text(dynamic value) => value?.toString() ?? '';
DateTime? _date(dynamic value) => DateTime.tryParse(_text(value));

class UserChatMessage {
  const UserChatMessage(
      {required this.id,
      required this.driverId,
      required this.senderType,
      required this.senderName,
      required this.body,
      required this.isRead,
      this.createdAt,
      this.clientMessageId,
      this.assignmentReference});
  final String id, senderType, senderName, body;
  final int driverId;
  final bool isRead;
  final DateTime? createdAt;
  final String? clientMessageId, assignmentReference;
  bool get isMine => senderType == 'USER';
  factory UserChatMessage.fromJson(dynamic value) {
    final json = messageMap(value);
    final id = _text(json['id']);
    if (!RegExp(r'^[1-9][0-9]*$').hasMatch(id)) {
      throw const FormatException('Invalid message ID');
    }
    final assignment = json['assignment'];
    return UserChatMessage(
        id: id,
        driverId: _integer(json['driverId']),
        senderType: _text(json['senderType']),
        senderName: _text(json['senderName']),
        body: _text(json['body']),
        isRead: json['isRead'] == true,
        createdAt: _date(json['createdAt']),
        clientMessageId: json['clientMessageId'] as String?,
        assignmentReference:
            assignment is Map ? assignment['referenceCode']?.toString() : null);
  }
}

class UserMessageThread {
  const UserMessageThread(
      {required this.driverId,
      required this.title,
      this.subtitle = '',
      this.isActive = true,
      this.unreadCount = 0,
      this.lastMessage,
      this.lastSeenAt});
  final int driverId, unreadCount;
  final String title, subtitle;
  final bool isActive;
  final UserChatMessage? lastMessage;
  final DateTime? lastSeenAt;
  factory UserMessageThread.fromJson(dynamic value) {
    final json = messageMap(value);
    final id = _integer(json['driverId']);
    if (id <= 0) throw const FormatException('Invalid driver ID');
    return UserMessageThread(
        driverId: id,
        title: _text(json['title']),
        subtitle: _text(json['subtitle']),
        isActive: json['isActive'] == true,
        unreadCount: _integer(json['unreadCount']),
        lastSeenAt: _date(json['lastSeenAt']),
        lastMessage: json['lastMessage'] == null
            ? null
            : UserChatMessage.fromJson(json['lastMessage']));
  }
  UserMessageThread read() => UserMessageThread(
      driverId: driverId,
      title: title,
      subtitle: subtitle,
      isActive: isActive,
      lastMessage: lastMessage,
      lastSeenAt: lastSeenAt);
}

class UserMessageThreads {
  const UserMessageThreads(this.items, this.totalUnread);
  final List<UserMessageThread> items;
  final int totalUnread;
  factory UserMessageThreads.fromJson(dynamic value) {
    final json = messageMap(value);
    return UserMessageThreads(
        List.unmodifiable(
            (json['items'] as List).map(UserMessageThread.fromJson)),
        _integer(json['totalUnread']));
  }
}

class UserMessagePage {
  const UserMessagePage(this.items, {this.unreadCount = 0, this.nextBeforeId});
  final List<UserChatMessage> items;
  final int unreadCount;
  final String? nextBeforeId;
  factory UserMessagePage.fromJson(dynamic value) {
    final json = messageMap(value);
    final cursor = json['hasMore'] == true ? _text(json['nextBeforeId']) : null;
    if (cursor != null && !RegExp(r'^[1-9][0-9]*$').hasMatch(cursor)) {
      throw const FormatException('Invalid message cursor');
    }
    return UserMessagePage(
        List.unmodifiable(
            (json['items'] as List).map(UserChatMessage.fromJson)),
        unreadCount: _integer(json['unreadCount']),
        nextBeforeId: cursor);
  }
}
