import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../shared/helpers/mobile_text.dart';
import '../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../shared/widgets/open_vts_page_scaffold.dart';
import '../../controllers/admin_parity_controller.dart';
import '../../models/admin_payments_model.dart';
import '../../services/admin_transactions_service.dart';
import '../payments/widgets/admin_payment_transaction_card.dart';
import '../payments/widgets/admin_payment_transaction_details_sheet.dart';

/// Administrator-to-software-owner ledger; customer payments remain separate.
class AdminTransactionsScreen extends ConsumerStatefulWidget {
  const AdminTransactionsScreen({super.key});
  @override
  ConsumerState<AdminTransactionsScreen> createState() =>
      _AdminTransactionsScreenState();
}

class _AdminTransactionsScreenState
    extends ConsumerState<AdminTransactionsScreen> {
  final _items = <AdminPaymentTransaction>[];
  String _query = '';
  String? _status;
  DateTimeRange? _range;
  int _page = 0, _total = 0, _request = 0;
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _load({bool more = false}) async {
    if (more && _loading) return;
    final request = ++_request, page = more ? _page + 1 : 1;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(adminParityControllerProvider)
          .transactions(
            page: page,
            search: _query,
            status: _status,
            range: _range == null
                ? null
                : DateTimeRangeBounds(
                    _range!.start,
                    DateTime(
                      _range!.end.year,
                      _range!.end.month,
                      _range!.end.day + 1,
                    ).subtract(const Duration(milliseconds: 1)),
                  ),
          );
      if (!mounted || request != _request) return;
      setState(() {
        if (!more) _items.clear();
        final ids = _items.map((r) => r.id).toSet();
        _items.addAll(result.items.where((r) => ids.add(r.id)));
        _page = result.page;
        _total = result.total;
        _loading = false;
      });
    } catch (error) {
      if (mounted && request == _request) {
        setState(() {
          _loading = false;
          _error = error is ApiException
              ? error.message
              : 'Transactions could not be loaded. Please retry.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => OpenVtsPageScaffold(
    title: context.mobileText('Transactions'),
    headerMode: OpenVtsPageHeaderMode.closeable,
    actions: [
      IconButton(
        tooltip: context.mobileText('Refresh transactions'),
        onPressed: _loading ? null : () => _load(),
        icon: const Icon(Icons.refresh),
      ),
    ],
    body: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.mobileText('Your transactions with the software owner.'),
          ),
        ),
        const SizedBox(height: 12),
        AdminTransactionsSearchField(
          currentQuery: _query,
          onSearch: (query) async {
            _query = query;
            await _load();
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final status in [null, 'SUCCESS', 'PENDING', 'FAILED'])
              ChoiceChip(
                label: Text(
                  status == null
                      ? context.mobileText('All')
                      : '${status[0]}${status.substring(1).toLowerCase()}',
                ),
                selected: _status == status,
                onSelected: (_) {
                  setState(() => _status = status);
                  unawaited(_load());
                },
              ),
            ActionChip(
              avatar: const Icon(Icons.date_range, size: 18),
              label: Text(
                _range == null
                    ? context.mobileText('Date range')
                    : context.mobileText('Change dates'),
              ),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                  initialDateRange: _range,
                );
                if (!mounted || picked == null) return;
                setState(() => _range = picked);
                unawaited(_load());
              },
            ),
            if (_range != null)
              ActionChip(
                label: Text(context.mobileText('Clear dates')),
                onPressed: () {
                  setState(() => _range = null);
                  unawaited(_load());
                },
              ),
          ],
        ),
        if (_loading) const LinearProgressIndicator(),
        if (_error != null && _items.isNotEmpty)
          MaterialBanner(
            content: Text(_error!),
            actions: [
              TextButton(
                onPressed: () => _load(),
                child: Text(context.mobileText('Retry')),
              ),
            ],
          ),
        Expanded(
          child: _error != null && _items.isEmpty
              ? OpenVtsErrorView(message: _error!, onRetry: () => _load())
              : RefreshIndicator(
                  onRefresh: () => _load(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _items.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == _items.length) {
                        if (_items.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              _loading
                                  ? context.mobileText('Loading transactions…')
                                  : context.mobileText(
                                      'No transactions match these filters.',
                                    ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                context.mobileText(
                                  "{value1} of {value2} transactions",
                                  {
                                    'value1': (_items.length).toString(),
                                    'value2': (_total).toString(),
                                  },
                                ),
                              ),
                              if (_page * 50 < _total)
                                TextButton(
                                  onPressed: _loading
                                      ? null
                                      : () => _load(more: true),
                                  child: Text(context.mobileText('Load more')),
                                ),
                            ],
                          ),
                        );
                      }
                      final item = _items[index];
                      return AdminPaymentTransactionCard(
                        item: item,
                        onTap: () => OpenVtsBottomSheet.show<void>(
                          context: context,
                          title: context.mobileText('Transaction details'),
                          initialChildSize: .8,
                          minChildSize: .45,
                          maxChildSize: .96,
                          child: AdminPaymentTransactionDetailsSheet(
                            item: item,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    ),
  );
}

class AdminTransactionsSearchField extends StatefulWidget {
  const AdminTransactionsSearchField({
    required this.currentQuery,
    required this.onSearch,
    super.key,
  });
  final String currentQuery;
  final Future<void> Function(String) onSearch;
  @override
  State<AdminTransactionsSearchField> createState() =>
      _AdminTransactionsSearchFieldState();
}

class _AdminTransactionsSearchFieldState
    extends State<AdminTransactionsSearchField> {
  late final TextEditingController _controller;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentQuery);
  }

  @override
  void didUpdateWidget(AdminTransactionsSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentQuery != oldWidget.currentQuery &&
        widget.currentQuery != _controller.text.trim()) {
      _timer?.cancel();
      _controller.text = widget.currentQuery;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    decoration: InputDecoration(
      hintText: context.mobileText('Search transactions...'),
      prefixIcon: const Icon(Icons.search, size: 20),
    ),
    onChanged: (value) {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 350), () {
        final query = value.trim();
        if (query != widget.currentQuery) unawaited(widget.onSearch(query));
      });
    },
  );
}
