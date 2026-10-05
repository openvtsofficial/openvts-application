import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_vts/shared/helpers/toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/mobile_text.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../models/admin_vehicle_model.dart';
import '../../../utils/vehicle_document_url_resolver.dart';
import '../../../widgets/admin_action_gate.dart';
import 'admin_vehicle_document_sheet.dart';

class AdminVehicleDocumentsTab extends ConsumerWidget {
  const AdminVehicleDocumentsTab({
    super.key,
    required this.vehicleId,
    required this.apiBaseUrl,
    required this.documents,
    required this.docTypes,
    required this.isLoading,
    required this.isUploading,
    required this.isUpdating,
    required this.isDeleting,
    required this.onLoad,
    required this.onUpload,
    required this.onUpdate,
    required this.onDelete,
  });

  final String vehicleId;
  final String apiBaseUrl;
  final List<AdminVehicleDocument> documents;
  final List<AdminVehicleDocumentType> docTypes;
  final bool isLoading;
  final bool isUploading;
  final bool isUpdating;
  final bool isDeleting;
  final Future<void> Function() onLoad;
  final Future<void> Function(AdminVehicleDocumentRequest request) onUpload;
  final Future<void> Function({
    required String docId,
    required AdminVehicleDocumentRequest request,
  })
  onUpdate;
  final Future<void> Function(String docId) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(appDateFormatterProvider);
    return Column(
      children: [
        OpenVtsCard(
          child: Align(
            alignment: Alignment.centerRight,
            child: AdminActionGate(
              capability: 'vehicles.update',
              child: OpenVtsButton(
                label: context.mobileText('Upload Document'),
                variant: OpenVtsButtonVariant.secondary,
                onPressed: () => _openDocumentSheet(context),
              ),
            ),
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (isLoading)
          const OpenVtsLoader()
        else if (documents.isEmpty)
          OpenVtsEmptyState(
            title: context.mobileText('No documents'),
            message: context.mobileText('Upload documents for this vehicle.'),
          )
        else
          ...documents.map(
            (doc) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.sm),
              child: OpenVtsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: OpenVtsSpacing.xxs),
                    Text(
                      context.mobileText("Document type: {value1}", {
                        'value1': (_safe(doc.docTypeName)).toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("File: {value1}", {
                        'value1': (_safe(doc.fileName)).toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("Expiry: {value1}", {
                        'value1': (formatter.formatDate(
                          doc.expiryAt,
                        )).toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("Visibility: {value1}", {
                        'value1': (doc.isVisible ? 'Visible' : 'Hidden')
                            .toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("Tags: {value1}", {
                        'value1': (_safe(doc.tags)).toString(),
                      }),
                    ),
                    Text(
                      context.mobileText("Created: {value1}", {
                        'value1': (formatter.formatDate(
                          doc.createdAt,
                        )).toString(),
                      }),
                    ),
                    const SizedBox(height: OpenVtsSpacing.sm),
                    Wrap(
                      spacing: OpenVtsSpacing.xs,
                      runSpacing: OpenVtsSpacing.xs,
                      children: [
                        OutlinedButton(
                          onPressed: () => _openFile(context, doc),
                          child: Text(context.mobileText('Open')),
                        ),
                        AdminActionGate(
                          capability: 'vehicles.update',
                          child: OutlinedButton(
                            onPressed: () =>
                                _openDocumentSheet(context, initial: doc),
                            child: Text(context.mobileText('Edit')),
                          ),
                        ),
                        AdminActionGate(
                          capability: 'vehicles.update',
                          child: OutlinedButton(
                            onPressed: isDeleting
                                ? null
                                : () => _confirmDelete(context, doc),
                            child: Text(context.mobileText('Delete')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openDocumentSheet(
    BuildContext context, {
    AdminVehicleDocument? initial,
  }) {
    return OpenVtsBottomSheet.show<void>(
      context: context,
      title: initial == null
          ? context.mobileText('Upload Document')
          : context.mobileText('Edit Document'),
      initialChildSize: 0.86,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      child: AdminVehicleDocumentSheet(
        vehicleId: vehicleId,
        docTypes: docTypes,
        initial: initial,
        isSubmitting: initial == null ? isUploading : isUpdating,
        onSubmit: (request) async {
          if (initial == null) {
            await onUpload(request);
          } else {
            await onUpdate(docId: initial.id, request: request);
          }
          if (!context.mounted) return;
          await onLoad();
          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AdminVehicleDocument doc,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.mobileText('Delete document')),
        content: Text(
          context.mobileText("Delete {value1}?", {
            'value1': (doc.title).toString(),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.mobileText('Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.mobileText('Delete')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await onDelete(doc.id);
    await onLoad();
  }

  Future<void> _openFile(BuildContext context, AdminVehicleDocument doc) async {
    final uri = VehicleDocumentUrlResolver.resolve(
      url: doc.url,
      filePath: doc.filePath,
      apiBaseUrl: apiBaseUrl,
    );
    if (uri == null) {
      ToastHelper.showError(
        context.mobileText('Document URL is unavailable.'),
        context: context,
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ToastHelper.showError(
        context.mobileText('Could not open document.'),
        context: context,
      );
    }
  }

  String _safe(String value) => value.trim().isEmpty ? '-' : value.trim();
}
