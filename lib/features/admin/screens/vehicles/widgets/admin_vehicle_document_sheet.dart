import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/open_vts_radius.dart';
import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../core/utils/date_time_formatter.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/helpers/toast_helper.dart';
import '../../../../../shared/widgets/open_vts_button.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';
import '../../../models/admin_vehicle_model.dart';

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

class AdminVehicleDocumentSheet extends StatefulWidget {
  const AdminVehicleDocumentSheet({
    super.key,
    required this.vehicleId,
    required this.docTypes,
    required this.isSubmitting,
    required this.onSubmit,
    this.initial,
  });

  final String vehicleId;
  final List<AdminVehicleDocumentType> docTypes;
  final bool isSubmitting;
  final AdminVehicleDocument? initial;
  final Future<void> Function(AdminVehicleDocumentRequest request) onSubmit;

  @override
  State<AdminVehicleDocumentSheet> createState() =>
      _AdminVehicleDocumentSheetState();
}

class _AdminVehicleDocumentSheetState extends State<AdminVehicleDocumentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _tagsController;
  late final TextEditingController _descriptionController;

  String? _docTypeId;
  bool _isVisible = true;
  DateTime? _expiryAt;
  PlatformFile? _file;
  var _isPicking = false;
  var _fileError = false;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.initial;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _tagsController = TextEditingController(text: existing?.tags ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
    _docTypeId = existing?.docTypeId;
    _isVisible = existing?.isVisible ?? true;
    _expiryAt = existing?.expiryAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    types: widget.docTypes,
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
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  _FilePickerField(
                    file: _file,
                    existingFileName: widget.initial?.fileName,
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
                  OpenVtsTextField(
                    label: 'Tags',
                    controller: _tagsController,
                    hintText: 'license, insurance',
                    prefixIcon: Icons.label_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  OpenVtsTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    hintText: 'Optional notes',
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: OpenVtsSpacing.sm),
                  _VisibilityToggle(
                    value: _isVisible,
                    onChanged: (value) => setState(() => _isVisible = value),
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
                    onPressed: widget.isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: OpenVtsSpacing.sm),
                Expanded(
                  child: OpenVtsButton(
                    label: _isEdit ? 'Save' : 'Upload',
                    height: 40,
                    isLoading: widget.isSubmitting,
                    trailingIcon: _isEdit
                        ? Icons.check_rounded
                        : Icons.upload_file_rounded,
                    onPressed: widget.isSubmitting ? null : _submit,
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
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedDocumentExtensions,
        withData: true,
      );
      if (!mounted || result == null || result.files.isEmpty) {
        setState(() => _isPicking = false);
        return;
      }

      final file = result.files.first;
      final extension = _extensionFromName(file.name).toLowerCase();
      if (_blockedDocumentExtensions.contains(extension)) {
        if (mounted) {
          ToastHelper.showError('This file type is not allowed.',
              context: context);
        }
        setState(() => _isPicking = false);
        return;
      }
      if (!_allowedDocumentExtensions.contains(extension)) {
        if (mounted) {
          ToastHelper.showError('Unsupported file type.', context: context);
        }
        setState(() => _isPicking = false);
        return;
      }
      if (file.size > _maxDocumentBytes) {
        if (mounted) {
          ToastHelper.showError('File must be 10MB or smaller.',
              context: context);
        }
        setState(() => _isPicking = false);
        return;
      }

      setState(() {
        _file = file;
        _fileError = false;
        _isPicking = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _expiryAt ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 30),
    );
    if (selected == null) return;
    setState(() => _expiryAt = selected);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isEdit && _file == null) {
      setState(() => _fileError = true);
      ToastHelper.showError('File is required.', context: context);
      return;
    }

    await widget.onSubmit(
      AdminVehicleDocumentRequest(
        title: _titleController.text.trim(),
        docTypeId: _docTypeId!.trim(),
        vehicleId: widget.vehicleId,
        isVisible: _isVisible,
        tags: _tagsController.text.trim(),
        description: _descriptionController.text.trim(),
        expiryAt: _expiryAt,
        file: _file,
      ),
    );
  }

  String _extensionFromName(String name) {
    final parts = name.split('.');
    return parts.length > 1 ? parts.last : '';
  }
}

class _DocumentTypeField extends StatelessWidget {
  const _DocumentTypeField({
    required this.value,
    required this.types,
    required this.onChanged,
  });

  final String? value;
  final List<AdminVehicleDocumentType> types;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Document Type',
        prefixIcon: const Icon(Icons.category_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.sm),
      ),
      hint: const Text('Select document type'),
      items: types
          .map((type) => DropdownMenuItem<String>(
                value: type.id,
                child: Text(type.name),
              ))
          .toList(growable: false),
      onChanged: onChanged,
      validator: (v) =>
          (v ?? '').trim().isEmpty ? 'Document type is required.' : null,
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
    final fileName = file?.name ?? existingFileName;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: isPicking ? null : onPick,
      child: Container(
        padding: const EdgeInsets.all(OpenVtsSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: showError ? cs.error : cs.outlineVariant,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          color: cs.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Icon(
              Icons.upload_file_rounded,
              size: 20,
              color: isPicking
                  ? cs.onSurfaceVariant.withValues(alpha: 0.5)
                  : cs.onSurfaceVariant,
            ),
            const SizedBox(width: OpenVtsSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'File',
                    style: OpenVtsTypography.meta.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fileName ?? 'Choose a file',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: fileName != null
                              ? cs.onSurface
                              : cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isPicking)
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                Icons.folder_open_rounded,
                size: 18,
                color: cs.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _ExpiryField extends ConsumerWidget {
  const _ExpiryField({
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(appDateFormatterProvider);
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.event_rounded, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: OpenVtsSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Expiry Date',
                  style: OpenVtsTypography.meta.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value == null ? 'Optional' : formatter.formatDateTime(value!),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            value == null ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: value == null ? onPick : onClear,
            child: Text(
              value == null ? 'Select' : 'Clear',
              style: OpenVtsTypography.label.copyWith(
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: OpenVtsSpacing.sm,
        vertical: OpenVtsSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                size: 18,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: OpenVtsSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Visibility',
                    style: OpenVtsTypography.meta.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ? 'Visible' : 'Hidden',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
