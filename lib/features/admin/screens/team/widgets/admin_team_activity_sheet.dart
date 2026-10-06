import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../controllers/admin_team_details_controller.dart';

class AdminTeamActivitySheet extends ConsumerWidget {
  const AdminTeamActivitySheet({required this.memberId, super.key});
  final String memberId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adminTeamActivityControllerProvider(memberId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final page = state.valueOrNull;
    final formatter = ref.watch(appDateFormatterProvider);
    final error = state.error is ApiException
        ? (state.error as ApiException).message
        : context.mobileText('Activity could not be loaded.');
    if (state.isLoading && page == null) return const OpenVtsLoader();
    if (state.hasError && page == null) {
      return OpenVtsErrorView(message: error, onRetry: controller.load);
    }
    return Column(
      children: [
        if (state.isLoading) const LinearProgressIndicator(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.load,
            child: ListView.builder(
              controller: PrimaryScrollController.maybeOf(context),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: (page?.items.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (index == (page?.items.length ?? 0)) {
                  if (state.hasError) {
                    return Column(
                      children: [
                        Text(error),
                        TextButton(
                          onPressed: () => controller.load(more: true),
                          child: Text(context.mobileText('Retry')),
                        ),
                      ],
                    );
                  }
                  if (page?.items.isEmpty ?? true) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.mobileText('No team activity found.'),
                      ),
                    );
                  }
                  if (page?.hasMore == true) {
                    return TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () => controller.load(more: true),
                      child: Text(context.mobileText('Load more')),
                    );
                  }
                  return const SizedBox(height: 16);
                }
                final row = page!.items[index];
                final date = DateTime.tryParse('${row['createdAt']}');
                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    leading: const Icon(Icons.history_rounded),
                    title: Text(
                      '${row['action'] ?? ''}'.replaceAll('.', ' · '),
                    ),
                    subtitle: Text(
                      [
                        '${row['entity'] ?? ''}',
                        formatter.formatDateTimeWithSeconds(date),
                        if (row['ip'] != null) '${row['ip']}',
                        if (row['browser'] != null || row['platform'] != null)
                          [
                            row['browser'],
                            row['platform'],
                          ].whereType<String>().join(' · '),
                      ].where((line) => line.isNotEmpty).join('\n'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
