import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../controllers/admin_parity_controller.dart';

class AdminTeamActivitySheet extends ConsumerStatefulWidget {
  const AdminTeamActivitySheet({required this.memberId, super.key});
  final String memberId;
  @override
  ConsumerState<AdminTeamActivitySheet> createState() =>
      _AdminTeamActivitySheetState();
}

class _AdminTeamActivitySheetState
    extends ConsumerState<AdminTeamActivitySheet> {
  final _items = <Map<String, dynamic>>[];
  bool _loading = true, _hasMore = false;
  int? _cursor;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool more = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(adminParityControllerProvider)
          .teamActivity(widget.memberId, cursor: more ? _cursor : null);
      if (!mounted) return;
      setState(() {
        if (!more) _items.clear();
        _items.addAll(
          (data['items'] as List? ?? []).whereType<Map>().map(
            (v) => Map<String, dynamic>.from(v),
          ),
        );
        _cursor = int.tryParse('${data['nextCursorId']}');
        _hasMore = data['hasMore'] == true;
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = error is ApiException
              ? error.message
              : 'Activity could not be loaded.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (_loading) const LinearProgressIndicator(),
      Expanded(
        child: _error != null
            ? OpenVtsErrorView(message: _error!, onRetry: () => _load())
            : RefreshIndicator(
                onRefresh: () => _load(),
                child: ListView.builder(
                  controller: PrimaryScrollController.maybeOf(context),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _items.length) {
                      return _items.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                context.mobileText('No team activity found.'),
                              ),
                            )
                          : _hasMore
                          ? TextButton(
                              onPressed: _loading
                                  ? null
                                  : () => _load(more: true),
                              child: Text(context.mobileText('Load more')),
                            )
                          : const SizedBox(height: 16);
                    }
                    final row = _items[index];
                    final date = DateTime.tryParse('${row['createdAt']}');
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(
                        '${row['action'] ?? ''}'.replaceAll('.', ' · '),
                      ),
                      subtitle: Text(
                        '${row['entity'] ?? ''}\n${date == null ? '' : const DateTimeFormatter().formatDateTime(date.toLocal())}',
                      ),
                    );
                  },
                ),
              ),
      ),
    ],
  );
}
