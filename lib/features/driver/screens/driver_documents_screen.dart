import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_actions_controller.dart';
import '../controllers/driver_providers.dart';
import '../models/driver_workspace_models.dart';
import 'driver_upload_sheet.dart';
import 'driver_widgets.dart';

class DriverDocumentsScreen extends ConsumerStatefulWidget {
  const DriverDocumentsScreen({super.key});
  @override
  ConsumerState<DriverDocumentsScreen> createState() =>
      _DriverDocumentsScreenState();
}

class _DriverDocumentsScreenState extends ConsumerState<DriverDocumentsScreen> {
  String? _deleting;
  Future<void> _delete(Map<String, dynamic> document) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.mobileText('Delete document?')),
        content: Text(
          context.mobileText("Delete {value1}?", {
            'value1': (driverText(document['title'])).toString(),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.mobileText('Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.mobileText('Delete')),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _deleting = driverText(document['id']));
    try {
      await ref
          .read(driverActionsControllerProvider)
          .deleteDocument(_deleting!);
      if (!mounted) return;
      ref.invalidate(driverDocumentsProvider);
      driverToast(context, 'Document deleted.');
    } catch (error) {
      if (mounted) driverToast(context, ErrorMapper.from(error).message);
    } finally {
      if (mounted) setState(() => _deleting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(driverDocumentsProvider),
        service = ref.watch(driverActionsControllerProvider),
        formatter = ref.watch(appDateFormatterProvider);
    return OpenVtsPageScaffold(
      title: context.mobileText('Documents'),
      actions: [
        IconButton(
          tooltip: context.mobileText('Upload document'),
          onPressed: () async {
            final uploaded = await showDriverUploadSheet(context);
            if (uploaded == true && mounted) {
              ref.invalidate(driverDocumentsProvider);
            }
          },
          icon: const Icon(Icons.upload_file),
        ),
      ],
      body: DriverAsyncBody(
        value: documents,
        onRetry: () => ref.invalidate(driverDocumentsProvider),
        builder: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(driverDocumentsProvider);
            await ref.read(driverDocumentsProvider.future);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  context.mobileText(
                    'Your documents and documents shared by your fleet manager.',
                  ),
                ),
              ),
              if (items.isEmpty)
                DriverEmpty(
                  context.mobileText(
                    'No documents yet. Upload your first document using the upload button.',
                  ),
                  icon: Icons.folder_outlined,
                ),
              for (final document in items)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverText(document['title']),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${driverText(driverMap(document['documentType'])['name'])} · ${document['scope'] == 'mine' ? 'Uploaded by you' : 'Shared with you'}',
                        ),
                        if (driverText(document['description']).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(driverText(document['description'])),
                          ),
                        if (document['expiryAt'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              context.mobileText("Expires {value1}", {
                                'value1': (formatter.formatDate(
                                  DateTime.tryParse(
                                    driverText(document['expiryAt']),
                                  ),
                                )).toString(),
                              }),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => shareDriverFile(
                                context,
                                () => service.documentContent(
                                  driverText(document['id']),
                                ),
                                driverText(
                                  document['fileName'],
                                  'document.pdf',
                                ),
                                driverText(
                                  document['fileType'],
                                  'application/octet-stream',
                                ),
                              ),
                              icon: const Icon(Icons.ios_share),
                              label: Text(context.mobileText('Open / save')),
                            ),
                            if (document['canDelete'] == true)
                              TextButton.icon(
                                onPressed: _deleting != null
                                    ? null
                                    : () => _delete(document),
                                icon: const Icon(Icons.delete_outline),
                                label: Text(
                                  _deleting == driverText(document['id'])
                                      ? context.mobileText('Deleting…')
                                      : context.mobileText('Delete'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
