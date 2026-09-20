import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_card.dart';
import '../../../../../shared/widgets/open_vts_empty_state.dart';
import '../../../../../shared/widgets/open_vts_error_view.dart';
import '../../../../../shared/widgets/open_vts_loader.dart';
import '../../../controllers/admin_driver_details_controller.dart';
import '../../../models/admin_driver_details_model.dart';
import '../../../models/admin_driver_details_state.dart';
import 'admin_driver_document_sheet.dart';

class AdminDriverDocumentsTab extends ConsumerWidget {
  const AdminDriverDocumentsTab({
    required this.provider,
    required this.state,
    super.key,
  });

  final AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
      AdminDriverDetailsState> provider;
  final AdminDriverDetailsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(provider.notifier);

    if (state.isLoadingDocuments && state.documents.isEmpty) {
      return const OpenVtsCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: OpenVtsSpacing.md),
          child: OpenVtsLoader(),
        ),
      );
    }

    if (state.sectionErrorMessage != null && state.documents.isEmpty) {
      return OpenVtsErrorView(
        message: state.sectionErrorMessage!,
        onRetry: controller.loadDocuments,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: state.isUploadingDocument
              ? null
              : () => showDriverDocumentSheet(
                    context: context,
                    provider: provider,
                    driverId: state.driverId,
                    documentTypes: state.documentTypes,
                  ),
          icon: const Icon(Icons.upload_file_rounded, size: 16),
          label: const Text('Upload Document'),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        if (state.documents.isEmpty)
          const OpenVtsEmptyState(
            title: 'No driver documents',
            message: 'Upload a document to get started.',
          )
        else
          ...state.documents.map(
            (doc) => Padding(
              padding: const EdgeInsets.only(bottom: OpenVtsSpacing.xs),
              child: _DocCard(
                doc: doc,
                onView: () => _openFile(context, doc),
                onEdit: () => showDriverDocumentSheet(
                  context: context,
                  provider: provider,
                  driverId: state.driverId,
                  existing: doc,
                  documentTypes: state.documentTypes,
                ),
                onDelete: () async {
                  final yes = await showDialog<bool>(
                    context: context,
                    builder: (dCtx) => AlertDialog(
                      title: const Text('Delete document'),
                      content: Text('Delete ${doc.title}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dCtx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(dCtx).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: OpenVtsColors.error,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (yes != true) return;
                  final ok = await controller.deleteDocument(doc.id);
                  if (!context.mounted) return;
                  if (ok) {
                    ToastHelper.showSuccess(
                      'Document deleted.',
                      context: context,
                    );
                  } else {
                    ToastHelper.showError(
                      ref.read(provider).sectionErrorMessage ??
                          'Unable to delete document.',
                      context: context,
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openFile(BuildContext context, AdminDriverDocument doc) async {
    final path = doc.fileUrl.trim().isNotEmpty
        ? doc.fileUrl.trim()
        : doc.filePath.trim();
    if (path.isEmpty) {
      ToastHelper.showError('No file available.', context: context);
      return;
    }

    final url = path.startsWith('http://') || path.startsWith('https://')
        ? path
        : '${AppConfig.apiBaseUrl.replaceAll(RegExp(r'/+$'), '')}${path.startsWith('/') ? path : '/$path'}';
    try {
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok && context.mounted) {
        ToastHelper.showError('Unable to open file.', context: context);
      }
    } catch (_) {
      if (context.mounted) {
        ToastHelper.showError('Unable to open file.', context: context);
      }
    }
  }
}

class _DocCard extends StatelessWidget {
  const _DocCard({
    required this.doc,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final AdminDriverDocument doc;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final f = const DateTimeFormatter();
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    // Show type name only when it differs from the title and is meaningful.
    final showType = doc.docTypeName != '-' && doc.docTypeName != doc.title;
    // Show filename only when it is meaningful and not a placeholder.
    final showFileName = doc.fileName != '-' && doc.fileName.isNotEmpty;
    return OpenVtsCard(
      padding: const EdgeInsets.all(OpenVtsSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title: allow wrapping so long licence names are readable.
                    Text(
                      doc.title,
                      style: OpenVtsTypography.label.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (showType) ...[
                      const SizedBox(height: 2),
                      Text(
                        doc.docTypeName,
                        style: OpenVtsTypography.meta.copyWith(
                          color: onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (showFileName) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            size: 11,
                            color: onSurfaceVariant,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              doc.fileName,
                              style: OpenVtsTypography.meta.copyWith(
                                color: onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<_DocAction>(
                tooltip: 'Document actions',
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onSelected: (value) {
                  switch (value) {
                    case _DocAction.view:
                      onView();
                      break;
                    case _DocAction.edit:
                      onEdit();
                      break;
                    case _DocAction.delete:
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: _DocAction.view,
                    child: _MenuRow(
                        icon: Icons.download_rounded, label: 'View/Download'),
                  ),
                  const PopupMenuItem(
                    value: _DocAction.edit,
                    child: _MenuRow(icon: Icons.edit_outlined, label: 'Edit'),
                  ),
                  const PopupMenuDivider(height: 8),
                  const PopupMenuItem(
                    value: _DocAction.delete,
                    child: _MenuRow(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      isDestructive: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: OpenVtsSpacing.sm),
          Wrap(
            spacing: OpenVtsSpacing.xs,
            runSpacing: OpenVtsSpacing.xs,
            children: [
              _MetaPill(
                icon: Icons.info_outline_rounded,
                label: doc.status,
                color: _statusColor(doc.status),
              ),
              if (doc.createdAt != null)
                _MetaPill(
                  icon: Icons.calendar_today_rounded,
                  label: f.formatDate(doc.createdAt!),
                  color: onSurfaceVariant,
                ),
              if (doc.expiryAt != null)
                _MetaPill(
                  icon: Icons.event_busy_rounded,
                  label: 'Exp: ${f.formatDate(doc.expiryAt!)}',
                  color: OpenVtsColors.warning,
                ),
              _MetaPill(
                icon: doc.isVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                label: doc.isVisible ? 'Visible' : 'Hidden',
                color: onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('approve') || lower.contains('valid')) {
      return OpenVtsColors.success;
    }
    if (lower.contains('reject') || lower.contains('fail')) {
      return OpenVtsColors.error;
    }
    if (lower.contains('pend') || lower.contains('review')) {
      return OpenVtsColors.warning;
    }
    return OpenVtsColors.textSecondary;
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? OpenVtsColors.error
        : Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: OpenVtsSpacing.xs),
        Text(
          label,
          style: OpenVtsTypography.label.copyWith(color: color),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(OpenVtsRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: OpenVtsTypography.meta.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _DocAction { view, edit, delete }
