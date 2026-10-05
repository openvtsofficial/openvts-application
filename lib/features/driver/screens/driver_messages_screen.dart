import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/access/workspace_scope_provider.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_messages_controller.dart';
import '../models/driver_workspace_models.dart';
import 'driver_widgets.dart';

class DriverMessagesScreen extends ConsumerStatefulWidget {
  const DriverMessagesScreen({super.key});
  @override
  ConsumerState<DriverMessagesScreen> createState() =>
      _DriverMessagesScreenState();
}

class _DriverMessagesScreenState extends ConsumerState<DriverMessagesScreen> {
  final _composer = TextEditingController();
  final _scroll = ScrollController();
  @override
  void dispose() {
    _composer.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && _scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  });
  Future<void> _send() async {
    final controller = ref.read(driverMessagesControllerProvider.notifier);
    final scope = ref.read(workspaceDataScopeProvider);
    if (await controller.send(_composer.text) &&
        mounted &&
        scope == ref.read(workspaceDataScopeProvider)) {
      _composer.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(workspaceDataScopeProvider, (previous, next) {
      if (previous != next) {
        _composer.clear();
      }
    });
    ref.listen(driverMessagesControllerProvider, (previous, next) {
      if (next.items.length > (previous?.items.length ?? 0) &&
          (_scroll.hasClients ? _scroll.position.extentAfter < 100 : true)) {
        _scrollToBottom();
      }
    });
    final state = ref.watch(driverMessagesControllerProvider),
        formatter = ref.watch(appDateFormatterProvider);
    final controller = ref.read(driverMessagesControllerProvider.notifier);
    return DriverRefreshScope(
      interval: const Duration(seconds: 15),
      onRefresh: () => controller.refresh(),
      child: OpenVtsPageScaffold(
        title: context.mobileText('Messages'),
        actions: [
          IconButton(
            tooltip: context.mobileText('Refresh messages'),
            onPressed: state.fetching ? null : () => controller.refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
        body: Column(
          children: [
            if (state.fetching && !state.loading)
              const LinearProgressIndicator(minHeight: 2),
            if (state.error != null)
              MaterialBanner(
                content: Text(state.error!),
                actions: [
                  TextButton(
                    onPressed: state.fetching
                        ? null
                        : () => controller.refresh(),
                    child: Text(context.mobileText('Retry')),
                  ),
                ],
              ),
            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: ListView(
                        controller: _scroll,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        children: [
                          if (state.nextBeforeId != null)
                            TextButton(
                              onPressed: state.fetching
                                  ? null
                                  : () => controller.loadOlder(),
                              child: Text(
                                context.mobileText('Load earlier messages'),
                              ),
                            ),
                          if (state.items.isEmpty)
                            DriverEmpty(
                              context.mobileText(
                                'Message your fleet manager here.',
                              ),
                              icon: Icons.chat_bubble_outline,
                            ),
                          for (final message in state.items)
                            Align(
                              alignment: message['senderType'] == 'DRIVER'
                                  ? AlignmentDirectional.centerEnd
                                  : AlignmentDirectional.centerStart,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * .82,
                                ),
                                child: Card(
                                  color: message['senderType'] == 'DRIVER'
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          driverText(message['senderName']),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        SelectableText(
                                          driverText(message['body']),
                                        ),
                                        if (driverMap(
                                          message['assignment'],
                                        ).isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            child: Text(
                                              driverText(
                                                driverMap(
                                                  message['assignment'],
                                                )['referenceCode'],
                                              ),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall,
                                            ),
                                          ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${formatter.formatDateTime(DateTime.tryParse(driverText(message['createdAt'])))}${message['senderType'] == 'DRIVER'
                                              ? message['isRead'] == true
                                                    ? ' · Read'
                                                    : ' · Sent'
                                              : ''}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _composer,
                      enabled: !state.sending,
                      maxLength: 4000,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: context.mobileText('Message dispatch'),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: context.mobileText('Send message'),
                    onPressed: state.sending ? null : _send,
                    icon: state.sending
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
