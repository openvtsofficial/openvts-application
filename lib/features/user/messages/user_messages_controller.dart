import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/socket/socket_service.dart';
import '../../../shared/models/user_role.dart';
import '../../auth/controllers/auth_controller.dart';
import 'user_message_models.dart';
import 'user_messages_service.dart';

final userMessagesServiceProvider = Provider<UserMessagesService>((ref) {
  ref.watch(workspaceDataScopeProvider);
  return UserMessagesService(ref.watch(apiClientProvider));
});
final userMessagesControllerProvider = StateNotifierProvider.autoDispose<
    UserMessagesController, UserMessagesState>((ref) {
  final user = ref.read(authControllerProvider).user;
  final controller = UserMessagesController(
      ref.watch(userMessagesServiceProvider),
      socketService: ref.watch(socketServiceProvider),
      ownerId: user?.id);
  if (user?.role == UserRole.user && user!.accessLoaded) controller.start();
  return controller;
});

class UserMessagesState {
  const UserMessagesState(
      {this.threads = const [],
      this.messages = const [],
      this.selected,
      this.totalUnread = 0,
      this.search = '',
      this.loadingThreads = true,
      this.loadingMessages = false,
      this.fetchingMessages = false,
      this.sending = false,
      this.threadError,
      this.messageError,
      this.nextBeforeId});
  final List<UserMessageThread> threads;
  final List<UserChatMessage> messages;
  final UserMessageThread? selected;
  final int totalUnread;
  final String search;
  final bool loadingThreads, loadingMessages, fetchingMessages, sending;
  final String? threadError, messageError, nextBeforeId;
  UserMessagesState copyWith(
          {List<UserMessageThread>? threads,
          List<UserChatMessage>? messages,
          UserMessageThread? selected,
          bool clearSelected = false,
          int? totalUnread,
          String? search,
          bool? loadingThreads,
          bool? loadingMessages,
          bool? fetchingMessages,
          bool? sending,
          String? threadError,
          String? messageError,
          String? nextBeforeId,
          bool replaceCursor = false}) =>
      UserMessagesState(
          threads: threads ?? this.threads,
          messages: messages ?? this.messages,
          selected: clearSelected ? null : selected ?? this.selected,
          totalUnread: totalUnread ?? this.totalUnread,
          search: search ?? this.search,
          loadingThreads: loadingThreads ?? this.loadingThreads,
          loadingMessages: loadingMessages ?? this.loadingMessages,
          fetchingMessages: fetchingMessages ?? this.fetchingMessages,
          sending: sending ?? this.sending,
          threadError: threadError,
          messageError: messageError,
          nextBeforeId: replaceCursor ? nextBeforeId : this.nextBeforeId);
}

class UserMessagesController extends StateNotifier<UserMessagesState> {
  UserMessagesController(this._service,
      {SocketService? socketService, String? ownerId})
      : _socketService = socketService,
        _ownerId = ownerId,
        super(const UserMessagesState());
  final UserMessagesService _service;
  final SocketService? _socketService;
  final String? _ownerId;
  SocketConnection? _socket;
  Timer? _poll, _eventRefresh;
  bool _foreground = true;
  int _threadGeneration = 0, _conversationGeneration = 0;
  Future<void>? _threadFlight, _conversationFlight;
  // Keep UUIDs after uncertain network failures so retry cannot duplicate delivery.
  final _pendingIds = <(int, String), String>{};

  void start() {
    refresh();
    _connect();
    _schedulePoll();
  }

  void setForeground(bool foreground) {
    _foreground = foreground;
    _poll?.cancel();
    _eventRefresh?.cancel();
    if (foreground) {
      refresh();
      _schedulePoll();
    }
  }

  void _schedulePoll() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 15), (_) => refresh());
  }

  Future<void> _connect() async {
    if (_socketService == null) return;
    try {
      final socket = await _socketService.connect('/driver-messages');
      if (!mounted) {
        socket.disconnect();
        return;
      }
      _socket = socket;
      socket.on('driver-message:new', _onEvent);
      socket.on('driver-message:read', _onEvent);
      socket.onConnect(() {
        if (mounted && _foreground) refresh();
      });
    } catch (_) {
      /* Foreground HTTP polling remains available offline/reconnecting. */
    }
  }

  void _onEvent(dynamic event) {
    if (!mounted ||
        !_foreground ||
        event is! Map ||
        '${event['ownerUserId']}' != _ownerId) {
      return;
    }
    _eventRefresh?.cancel();
    // Re-fetch the viewer-specific representation; socket receipts can represent
    // the other participant's view of a message.
    _eventRefresh = Timer(const Duration(milliseconds: 150), () => refresh());
  }

  Future<void> refresh() async {
    if (!mounted || !_foreground) return;
    await loadThreads();
    if (mounted && _foreground && state.selected != null) await loadMessages();
  }

  Future<void> search(String value) {
    final term = value.trim();
    if (!mounted || term == state.search) return Future.value();
    _threadGeneration++;
    _threadFlight = null;
    state = state.copyWith(search: term, loadingThreads: true);
    return loadThreads();
  }

  Future<void> loadThreads() {
    if (!mounted || !_foreground) return Future.value();
    if (_threadFlight != null) return _threadFlight!;
    final generation = ++_threadGeneration;
    final future = _loadThreads(generation);
    _threadFlight = future;
    return future.whenComplete(() {
      if (generation == _threadGeneration) _threadFlight = null;
    });
  }

  Future<void> _loadThreads(int generation) async {
    try {
      final result = await _service.threads(search: state.search);
      if (!mounted || generation != _threadGeneration) return;
      UserMessageThread? selected;
      for (final thread in result.items) {
        if (thread.driverId == state.selected?.driverId) selected = thread;
      }
      state = state.copyWith(
          threads: result.items,
          selected: selected,
          totalUnread: result.totalUnread,
          loadingThreads: false,
          messageError: state.messageError);
    } catch (error) {
      if (mounted && generation == _threadGeneration) {
        state = state.copyWith(
            loadingThreads: false,
            threadError: ErrorMapper.from(error).message,
            messageError: state.messageError);
      }
    }
  }

  Future<void> select(UserMessageThread? thread) {
    if (!mounted) return Future.value();
    _conversationGeneration++;
    _conversationFlight = null;
    state = state.copyWith(
        selected: thread,
        clearSelected: thread == null,
        messages: const [],
        loadingMessages: thread != null,
        fetchingMessages: false,
        nextBeforeId: null,
        replaceCursor: true,
        threadError: state.threadError);
    return thread == null ? Future.value() : loadMessages();
  }

  Future<void> loadMessages({bool older = false}) {
    if (!mounted ||
        !_foreground ||
        state.selected == null ||
        (older && state.nextBeforeId == null)) {
      return Future.value();
    }
    if (_conversationFlight != null) return _conversationFlight!;
    final generation = _conversationGeneration;
    final future = _loadMessages(state.selected!.driverId, generation, older);
    _conversationFlight = future;
    return future.whenComplete(() {
      if (generation == _conversationGeneration) _conversationFlight = null;
    });
  }

  bool _isCurrent(int driverId, int generation) =>
      mounted &&
      generation == _conversationGeneration &&
      state.selected?.driverId == driverId;
  Future<void> _loadMessages(int driverId, int generation, bool older) async {
    final first = state.messages.isEmpty;
    state =
        state.copyWith(fetchingMessages: true, threadError: state.threadError);
    try {
      final page = await _service.messages(driverId,
          beforeId: older ? state.nextBeforeId : null);
      if (!_isCurrent(driverId, generation)) return;
      state = state.copyWith(
          messages: _merge(state.messages, page.items),
          loadingMessages: false,
          fetchingMessages: false,
          nextBeforeId: page.nextBeforeId,
          replaceCursor: first || older,
          threadError: state.threadError);
      if (_foreground && page.unreadCount > 0) {
        try {
          final unread = await _service.markRead(driverId);
          if (!_isCurrent(driverId, generation) || !_foreground) return;
          state = state.copyWith(
              totalUnread: unread,
              selected: state.selected!.read(),
              threads: [
                for (final t in state.threads)
                  t.driverId == driverId ? t.read() : t
              ],
              threadError: state.threadError,
              messageError: state.messageError);
        } catch (_) {
          /* Read receipts retry when the visible thread refreshes. */
        }
      }
    } catch (error) {
      if (_isCurrent(driverId, generation)) {
        state = state.copyWith(
            loadingMessages: false,
            fetchingMessages: false,
            messageError: ErrorMapper.from(error).message,
            threadError: state.threadError);
      }
    }
  }

  Future<bool> send(String text) async {
    if (!mounted) return false;
    final body = text.trim(), driverId = state.selected?.driverId;
    if (!_foreground ||
        state.sending ||
        driverId == null ||
        body.isEmpty ||
        body.runes.length > 4000) {
      return false;
    }
    final generation = _conversationGeneration;
    final key = (driverId, body);
    final clientId = _pendingIds.putIfAbsent(key, () => const Uuid().v4());
    state = state.copyWith(sending: true, threadError: state.threadError);
    try {
      final message = await _service.send(driverId, body, clientId);
      if (!mounted) return false;
      _pendingIds.remove(key);
      if (_isCurrent(driverId, generation)) {
        state = state.copyWith(
            messages: _merge(state.messages, [message]),
            sending: false,
            threadError: state.threadError);
      } else {
        state = state.copyWith(
            sending: false,
            threadError: state.threadError,
            messageError: state.messageError);
      }
      loadThreads();
      return true;
    } catch (error) {
      if (mounted) {
        state = state.copyWith(
            sending: false,
            threadError: state.threadError,
            messageError: _isCurrent(driverId, generation)
                ? ErrorMapper.from(error).message
                : state.messageError);
      }
      return false;
    }
  }

  static List<UserChatMessage> _merge(
      List<UserChatMessage> current, List<UserChatMessage> incoming) {
    final values = {for (final message in current) message.id: message};
    for (final message in incoming) {
      values[message.id] = message;
    }
    return List.unmodifiable(values.values.toList()
      ..sort((a, b) => BigInt.parse(a.id).compareTo(BigInt.parse(b.id))));
  }

  @override
  void dispose() {
    _poll?.cancel();
    _eventRefresh?.cancel();
    _socket?.disconnect();
    _pendingIds.clear();
    super.dispose();
  }
}
