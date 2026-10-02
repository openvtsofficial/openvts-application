import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_colors.dart';
import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_bottom_sheet.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../controllers/admin_driver_details_controller.dart';
import '../../../models/admin_driver_details_model.dart';
import '../../../models/admin_driver_details_state.dart';

const int _maxDocumentBytes = 10 * 1024 * 1024;
const List<String> _blockedDocumentExtensions = <String>[
  'exe',
  'js',
  'html',
  'htm',
];
const List<String> _allowedDocumentExtensions = <String>[
  'pdf',
  'png',
  'jpg',
  'jpeg',
  'webp',
  'gif',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'csv',
  'txt',
  'ppt',
  'pptx',
  'zip',
];

Future<void> showDriverDocumentSheet({
  required BuildContext context,
  required AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
          AdminDriverDetailsState>
      provider,
  required String driverId,
  required List<AdminDriverDocumentType> documentTypes,
  AdminDriverDocument? existing,
}) {
  return OpenVtsBottomSheet.show<void>(
    context: context,
    title: existing == null ? 'Upload Document' : 'Edit Document',
    initialChildSize: 0.86,
    minChildSize: 0.48,
    maxChildSize: 0.96,
    child: _DriverDocumentSheet(
      provider: provider,
      driverId: driverId,
      documentTypes: documentTypes,
      existing: existing,
    ),
  );
}

class _DriverDocumentSheet extends ConsumerStatefulWidget {
  const _DriverDocumentSheet({
    required this.provider,
    required this.driverId,
    required this.documentTypes,
    required this.existing,
  });

  final AutoDisposeStateNotifierProvider<AdminDriverDetailsController,
      AdminDriverDetailsState> provider;
  final String driverId;
  final List<AdminDriverDocumentType> documentTypes;
  final AdminDriverDocument? existing;

  @override
  ConsumerState<_DriverDocumentSheet> createState() =>
      _DriverDocumentSheetState();
}

class _DriverDocumentSheetState extends ConsumerState<_DriverDocumentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String? _docTypeId;
  DateTime? _expiryAt;
  bool _isVisible = true;
  PlatformFile? _file;
  var _isPicking = false;
  var _fileError = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _titleController.text = existing.title;
      _notesController.text = existing.description;
      _docTypeId = existing.docTypeId.isEmpty ? null : existing.docTypeId;
      _expiryAt = existing.expiryAt;
      _isVisible = existing.isVisible;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    final driverTypes = widget.documentTypes
        .where((type) => type.docFor.isEmpty || type.docFor == 'DRIVER')
        .toList(growable: false);
    final isSubmitting = state.isUploadingDocument;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: PrimaryScrollController.maybeOf(context),
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DocumentTypeField(
                    value: _docTypeId,
                    types: driverTypes,
                    onChanged: (value) => setState(() => _docTypeId = value),
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Title',
                    controller: _titleController,
                    hintText: 'Document title',
                    prefixIcon: Icons.title_rounded,
                    textInputAction: TextInputAction.next,
                    validator: Validators.documentTitle,
                    maxLength: Validators.maxNameLength,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  _FilePickerField(
                    file: _file,
                    existingFileName: widget.existing?.fileName,
                    isPicking: _isPicking,
                    showError: _fileError,
                    onPick: _pickFile,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  _ExpiryField(
                    value: _expiryAt,
                    onPick: _pickExpiry,
                    onClear: () => setState(() => _expiryAt = null),
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  _VisibilityToggle(
                    value: _isVisible,
                    onChanged: (value) => setState(() => _isVisible = value),
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Notes (Optional)',
                    controller: _notesController,
                    hintText: 'Additional notes',
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(OpenVtsSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: OpenVtsButton(
                    label: 'Cancel',
                    height: 40,
                    variant: OpenVtsButtonVariant.secondary,
                    onPressed:
                        isSubmitting ? null : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: OpenVtsButton(
                    label: _isEdit ? 'Save' : 'Upload',
                    height: 40,
                    isLoading: isSubmitting,
                    trailingIcon: _isEdit
                        ? Icons.check_rounded
                        : Icons.upload_file_rounded,
                    onPressed: isSubmitting ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    if (_isPicking) {
      return;
    }
    setState(() => _isPicking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedDocumentExtensions,
        withData: true,
      );
      if (!mounted || result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      final extension = _extensionFromName(file.name).toLowerCase();
      if (_blockedDocumentExtensions.contains(extension)) {
        ToastHelper.showError('This file type is not allowed.',
            context: context);
        return;
      }
      if (!_allowedDocumentExtensions.contains(extension)) {
        ToastHelper.showError('Unsupported file type.', context: context);
        return;
      }
      if (file.size > _maxDocumentBytes) {
        ToastHelper.showError('File must be 10MB or smaller.',
            context: context);
        return;
      }

      setState(() {
        _file = file;
        _fileError = false;
      });
    } catch (_) {
      if (mounted) {
        ToastHelper.showError('Could not pick file.', context: context);
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryAt ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 20),
    );
    if (picked != null) {
      setState(() => _expiryAt = picked);
    }
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    final needsFile = !_isEdit && _file == null;
    if (needsFile) {
      setState(() => _fileError = true);
    }
    if (!formOk || needsFile) {
      return;
    }

    final request = AdminDriverDocumentUpsertRequest(
      driverId: widget.driverId,
      title: _titleController.text.trim(),
      docTypeId: _docTypeId ?? '',
      isVisible: _isVisible,
      tags: '',
      description: _notesController.text.trim(),
      expiryAt: _expiryAt,
      file: _file,
    );

    final notifier = ref.read(widget.provider.notifier);
    final ok = _isEdit
        ? await notifier.updateDocument(
            docId: widget.existing!.id,
            request: request,
          )
        : await notifier.uploadDocument(request);
    if (!mounted) {
      return;
    }

    if (ok) {
      ToastHelper.showSuccess(
        _isEdit ? 'Document updated.' : 'Document uploaded.',
        context: context,
      );
      Navigator.of(context).pop();
    } else {
      ToastHelper.showError(
        ref.read(widget.provider).sectionErrorMessage ??
            (_isEdit
                ? 'Unable to update document.'
                : 'Unable to upload document.'),
        context: context,
      );
    }
  }
}

class _DocumentTypeField extends StatelessWidget {
  const _DocumentTypeField({
    required this.value,
    required this.types,
    required this.onChanged,
  });

  final String? value;
  final List<AdminDriverDocumentType> types;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && types.any((type) => type.id == value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Document Type', style: OpenVtsTypography.label),
        const SizedBox(height: OpenVtsSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: hasValue ? value : null,
          isExpanded: true,
          hint: const Text('Select type'),
          decoration:
              const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
          items: types
              .map(
                (type) => DropdownMenuItem<String>(
                  value: type.id,
                  child: Text(
                    type.name.isEmpty ? type.id : type.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(growable: false),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Document Type is required.';
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FilePickerField extends StatelessWidget {
  const _FilePickerField({
    required this.file,
    required this.existingFileName,
    required this.isPicking,
    required this.showError,
    required this.onPick,
  });

  final PlatformFile? file;
  final String? existingFileName;
  final bool isPicking;
  final bool showError;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final currentName = file?.name ?? existingFileName ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('File', style: OpenVtsTypography.label),
        const SizedBox(height: OpenVtsSpacing.xs),
        Container(
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          decoration: BoxDecoration(
            color: OpenVtsColors.surface,
            borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
            border: Border.all(
              color: showError ? OpenVtsColors.error : OpenVtsColors.border,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.attach_file_rounded,
                size: 18,
                color: OpenVtsColors.textSecondary,
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              Expanded(
                child: Text(
                  currentName.isEmpty ? 'Choose file' : currentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OpenVtsTypography.label.copyWith(
                    color: currentName.isEmpty
                        ? OpenVtsColors.textTertiary
                        : OpenVtsColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: OpenVtsSpacing.xs),
              if (isPicking)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                GestureDetector(
                  onTap: onPick,
                  child: const Icon(
                    Icons.folder_open_rounded,
                    size: 18,
                    color: OpenVtsColors.brandInk,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpiryField extends StatelessWidget {
  const _ExpiryField({
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiry Date (Optional)',
          style: OpenVtsTypography.label,
        ),
        const SizedBox(height: OpenVtsSpacing.xs),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: OpenVtsSpacing.sm,
                  vertical: OpenVtsSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: OpenVtsColors.surface,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  border: Border.all(color: OpenVtsColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: OpenVtsColors.textSecondary,
                    ),
                    const SizedBox(width: OpenVtsSpacing.xs),
                    Expanded(
                      child: Text(
                        value == null ? 'No expiry' : _formatDate(value!),
                        style: OpenVtsTypography.label.copyWith(
                          color: value == null
                              ? OpenVtsColors.textTertiary
                              : OpenVtsColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: OpenVtsSpacing.xs),
            GestureDetector(
              onTap: onPick,
              child: Container(
                padding: const EdgeInsets.all(OpenVtsSpacing.sm),
                decoration: BoxDecoration(
                  color: OpenVtsColors.surface,
                  borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                  border: Border.all(color: OpenVtsColors.border),
                ),
                child: const Icon(
                  Icons.event_outlined,
                  size: 18,
                  color: OpenVtsColors.brandInk,
                ),
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: OpenVtsSpacing.xs),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.all(OpenVtsSpacing.sm),
                  decoration: BoxDecoration(
                    color: OpenVtsColors.surface,
                    borderRadius: BorderRadius.circular(OpenVtsRadius.sm),
                    border: Border.all(color: OpenVtsColors.border),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: OpenVtsColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _VisibilityToggle extends StatelessWidget {
  const _VisibilityToggle({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visible To Admin',
          style: OpenVtsTypography.label,
        ),
        const SizedBox(height: OpenVtsSpacing.xs),
        SwitchListTile.adaptive(
          value: value,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            value ? 'Visible to admin' : 'Hidden from admin',
            style: OpenVtsTypography.label.copyWith(
              color: OpenVtsColors.textPrimary,
            ),
          ),
          subtitle: Text(
            value ? 'Admin users can see this document' : 'Only owner can see',
            style: OpenVtsTypography.meta.copyWith(
              color: OpenVtsColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

String _extensionFromName(String filename) {
  final lastDot = filename.lastIndexOf('.');
  if (lastDot < 0) return '';
  return filename.substring(lastDot + 1);
}
