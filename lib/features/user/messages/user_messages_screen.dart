import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import 'user_message_models.dart';
import 'user_messages_controller.dart';

class UserMessagesScreen extends ConsumerStatefulWidget {
  const UserMessagesScreen({super.key});
  @override
  ConsumerState<UserMessagesScreen> createState() => _UserMessagesScreenState();
}

class _UserMessagesScreenState extends ConsumerState<UserMessagesScreen>
    with WidgetsBindingObserver {
  final _composer = TextEditingController(), _search = TextEditingController();
  final _scroll = ScrollController();
  final _drafts = <int, String>{};
  Timer? _searchDebounce;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => ref
      .read(userMessagesControllerProvider.notifier)
      .setForeground(state == AppLifecycleState.resumed);
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _composer.dispose();
    _search.dispose();
    _scroll.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _open(UserMessageThread? thread) {
    final current = ref.read(userMessagesControllerProvider).selected?.driverId;
    if (current != null) _drafts[current] = _composer.text;
    _composer.text = thread == null ? '' : _drafts[thread.driverId] ?? '';
    FocusScope.of(context).unfocus();
    ref.read(userMessagesControllerProvider.notifier).select(thread);
    if (thread != null) _scrollToBottom();
  }

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
  Future<void> _send() async {
    final scope = ref.read(workspaceDataScopeProvider);
    final id = ref.read(userMessagesControllerProvider).selected?.driverId;
    final text = _composer.text;
    final sent =
        await ref.read(userMessagesControllerProvider.notifier).send(text);
    if (sent && mounted && scope == ref.read(workspaceDataScopeProvider)) {
      if (_drafts[id] == text) _drafts.remove(id);
      if (id == ref.read(userMessagesControllerProvider).selected?.driverId &&
          _composer.text == text) {
        _composer.clear();
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(workspaceDataScopeProvider, (previous, next) {
      if (previous != next) {
        _composer.clear();
        _search.clear();
        _drafts.clear();
        _searchDebounce?.cancel();
      }
    });
    ref.listen(userMessagesControllerProvider, (previous, next) {
      final same = previous?.selected?.driverId == next.selected?.driverId;
      final latestChanged = next.messages.isNotEmpty &&
          (previous?.messages.isEmpty != false ||
              previous!.messages.last.id != next.messages.last.id);
      if (same &&
          latestChanged &&
          (!_scroll.hasClients || _scroll.position.extentAfter < 100)) {
        _scrollToBottom();
      }
    });
    final state = ref.watch(userMessagesControllerProvider);
    final controller = ref.read(userMessagesControllerProvider.notifier);
    final formatter = ref.watch(appDateFormatterProvider);
    return PopScope(
        canPop: state.selected == null,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && state.selected != null) _open(null);
        },
        child: OpenVtsPageScaffold(
          title: state.selected?.title ?? 'Messages',
          leading: state.selected == null
              ? null
              : IconButton(
                  tooltip: 'All conversations',
                  onPressed: () => _open(null),
                  icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                tooltip: 'Refresh messages',
                onPressed: controller.refresh,
                icon: const Icon(Icons.refresh))
          ],
          body: state.selected == null
              ? Column(children: [
                  TextField(
                      controller: _search,
                      maxLength: 100,
                      decoration: const InputDecoration(
                          labelText: 'Find a driver',
                          hintText: 'Name, username or vehicle',
                          prefixIcon: Icon(Icons.search),
                          counterText: ''),
                      onChanged: (value) {
                        _searchDebounce?.cancel();
                        _searchDebounce =
                            Timer(const Duration(milliseconds: 300), () {
                          if (mounted) controller.search(value);
                        });
                      }),
                  const SizedBox(height: 8),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                          '${state.totalUnread} unread ${state.totalUnread == 1 ? 'message' : 'messages'}',
                          style: Theme.of(context).textTheme.labelLarge)),
                  if (state.threadError != null)
                    _MessageError(state.threadError!,
                        onRetry: controller.loadThreads),
                  if (state.threads.length >= 500)
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                            'Showing up to 500 drivers. Search to narrow the list.')),
                  Expanded(
                      child: state.loadingThreads
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: controller.refresh,
                              child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: state.threads.isEmpty
                                      ? 1
                                      : state.threads.length,
                                  itemBuilder: (context, index) {
                                    if (state.threads.isEmpty) {
                                      return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 64, horizontal: 24),
                                          child: Text(
                                              'No drivers found. Drivers linked to your account appear here, including new conversations.',
                                              textAlign: TextAlign.center));
                                    }
                                    final thread = state.threads[index];
                                    return UserMessageThreadTile(
                                        thread: thread,
                                        onTap: () => _open(thread));
                                  }))),
                ])
              : Column(children: [
                  if (!state.selected!.isActive)
                    const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                            'This driver account is inactive. They can read new messages after their account is reactivated.')),
                  if (state.fetchingMessages && !state.loadingMessages)
                    const LinearProgressIndicator(minHeight: 2),
                  if (state.messageError != null)
                    _MessageError(state.messageError!,
                        onRetry: controller.loadMessages),
                  Expanded(
                      child: state.loadingMessages
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: controller.loadMessages,
                              child: ListView(
                                  controller: _scroll,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8),
                                  children: [
                                    if (state.nextBeforeId != null)
                                      TextButton(
                                          onPressed: state.fetchingMessages
                                              ? null
                                              : () async {
                                                  final before =
                                                      _scroll.hasClients
                                                          ? _scroll.position
                                                              .maxScrollExtent
                                                          : 0.0;
                                                  final offset =
                                                      _scroll.hasClients
                                                          ? _scroll.offset
                                                          : 0.0;
                                                  final driver =
                                                      state.selected!.driverId;
                                                  await controller.loadMessages(
                                                      older: true);
                                                  if (!mounted ||
                                                      ref
                                                              .read(
                                                                  userMessagesControllerProvider)
                                                              .selected
                                                              ?.driverId !=
                                                          driver) {
                                                    return;
                                                  }
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    if (mounted &&
                                                        _scroll.hasClients) {
                                                      _scroll.jumpTo((offset +
                                                              _scroll.position
                                                                  .maxScrollExtent -
                                                              before)
                                                          .clamp(
                                                              0.0,
                                                              _scroll.position
                                                                  .maxScrollExtent));
                                                    }
                                                  });
                                                },
                                          child: const Text(
                                              'Load earlier messages')),
                                    if (state.messages.isEmpty)
                                      const Padding(
                                          padding: EdgeInsets.all(32),
                                          child: Text(
                                              'Start a conversation with this driver.',
                                              textAlign: TextAlign.center)),
                                    for (final message in state.messages)
                                      UserMessageBubble(
                                          message: message,
                                          timestamp: formatter.formatDateTime(
                                              message.createdAt)),
                                  ]))),
                  const Divider(height: 1),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: TextField(
                                    controller: _composer,
                                    enabled: !state.sending,
                                    minLines: 1,
                                    maxLines: 4,
                                    maxLength: 4000,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                        labelText: 'Message driver',
                                        counterText: ''))),
                            const SizedBox(width: 8),
                            IconButton.filled(
                                tooltip: 'Send message',
                                onPressed: state.sending ? null : _send,
                                icon: state.sending
                                    ? const SizedBox.square(
                                        dimension: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : const Icon(Icons.send)),
                          ])),
                ]),
        ));
  }
}

class UserMessageThreadTile extends StatelessWidget {
  const UserMessageThreadTile(
      {super.key, required this.thread, required this.onTap});
  final UserMessageThread thread;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          title:
              Text(thread.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
              [
                if (thread.subtitle.isNotEmpty) thread.subtitle,
                if (!thread.isActive) 'Inactive driver',
                thread.lastMessage?.body ?? 'Start a conversation'
              ].join('\n'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          trailing: thread.unreadCount > 0
              ? Badge(
                  label: Text(thread.unreadCount > 99
                      ? '99+'
                      : '${thread.unreadCount}'))
              : const Icon(Icons.chevron_right),
          onTap: onTap));
}

class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble(
      {super.key, required this.message, required this.timestamp});
  final UserChatMessage message;
  final String timestamp;
  @override
  Widget build(BuildContext context) => Align(
      alignment: message.isMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
          widthFactor: .88,
          child: Card(
              color: message.isMine
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            message.senderName.isEmpty
                                ? message.senderType
                                : message.senderName,
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 4),
                        SelectableText(message.body),
                        if (message.assignmentReference?.isNotEmpty == true)
                          Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('Trip ${message.assignmentReference}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium)),
                        const SizedBox(height: 6),
                        Text(
                            '$timestamp${message.isMine ? message.isRead ? ' · Read' : ' · Sent' : ''}',
                            style: Theme.of(context).textTheme.labelSmall),
                      ])))));
}

class _MessageError extends StatelessWidget {
  const _MessageError(this.message, {required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        Text(message,
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
        TextButton(onPressed: onRetry, child: const Text('Refresh')),
      ]));
}
