import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/validation_localizations.dart';
import '../controllers/driver_actions_controller.dart';
import '../controllers/driver_providers.dart';
import '../models/driver_workspace_models.dart';

Future<bool?> showDriverUploadSheet(BuildContext context, {DriverTrip? trip}) =>
    showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => _DriverUploadSheet(trip: trip),
    );

class _DriverUploadSheet extends ConsumerStatefulWidget {
  const _DriverUploadSheet({this.trip});
  final DriverTrip? trip;
  @override
  ConsumerState<_DriverUploadSheet> createState() => _DriverUploadSheetState();
}

class _DriverUploadSheetState extends ConsumerState<_DriverUploadSheet> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController(), _note = TextEditingController();
  PlatformFile? _file;
  String? _documentType, _error;
  String _proofType = 'POD', _stopId = '';
  DateTime? _expiry;
  bool _busy = false;
  bool get _proof => widget.trip != null;
  @override
  void initState() {
    super.initState();
    _stopId = widget.trip?.currentStop?.id ?? '';
  }

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'webp',
          if (!_proof) ...['doc', 'docx'],
        ],
        withData: kIsWeb,
        allowMultiple: false,
      );
      if (result == null || !mounted) return;
      final file = result.files.single;
      if (file.size <= 0 || file.size > 5 * 1024 * 1024) {
        setState(() => _error = 'Select a non-empty file up to 5 MB.');
        return;
      }
      setState(() {
        _file = file;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = ErrorMapper.from(error).message);
    }
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    if (_file == null) {
      setState(() => _error = 'Select a file to upload.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final service = ref.read(driverActionsControllerProvider);
      if (_proof) {
        await service.uploadProof(
          tripId: widget.trip!.id,
          file: _file!,
          proofType: _proofType,
          stopId: _stopId,
          title: _title.text,
          note: _note.text,
        );
      } else {
        await service.uploadDocument(
          file: _file!,
          title: _title.text,
          documentTypeId: _documentType!,
          description: _note.text,
          expiry: _expiry,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) setState(() => _error = ErrorMapper.from(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = _proof ? null : ref.watch(driverDocumentTypesProvider);
    return PopScope(
      canPop: !_busy,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: .85,
          maxChildSize: .95,
          minChildSize: .5,
          expand: false,
          builder: (context, scroll) => SingleChildScrollView(
            controller: scroll,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _proof
                              ? context.mobileText('Upload trip proof')
                              : context.mobileText('Upload document'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: context.mobileText('Close'),
                        onPressed: _busy ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_proof) ...[
                    DropdownButtonFormField<String>(
                      initialValue: _proofType,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: context.mobileText('Proof type'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'POD',
                          child: Text(context.mobileText('Proof of delivery')),
                        ),
                        DropdownMenuItem(
                          value: 'PHOTO',
                          child: Text(context.mobileText('Site photo')),
                        ),
                        DropdownMenuItem(
                          value: 'SIGNATURE',
                          child: Text(context.mobileText('Signature')),
                        ),
                        DropdownMenuItem(
                          value: 'DOCUMENT',
                          child: Text(context.mobileText('Other document')),
                        ),
                      ],
                      onChanged: _busy
                          ? null
                          : (v) => setState(() => _proofType = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _stopId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: context.mobileText('Related stop'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text(context.mobileText('Whole trip')),
                        ),
                        for (final stop in widget.trip!.stops)
                          DropdownMenuItem(
                            value: stop.id,
                            child: Text(
                              '${stop.sequence}. ${stop.name}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: _busy
                          ? null
                          : (v) => setState(() => _stopId = v!),
                    ),
                  ] else if (types != null)
                    types.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (error, _) => Column(
                        children: [
                          Text(ErrorMapper.from(error).message),
                          TextButton(
                            onPressed: () =>
                                ref.invalidate(driverDocumentTypesProvider),
                            child: Text(
                              context.mobileText('Reload document types'),
                            ),
                          ),
                        ],
                      ),
                      data: (items) => items.isEmpty
                          ? Text(
                              context.mobileText(
                                'No driver document types are configured. Ask your administrator to add one.',
                              ),
                            )
                          : DropdownButtonFormField<String>(
                              initialValue: _documentType,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: context.mobileText('Document type'),
                              ),
                              items: items
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: driverText(item['id']),
                                      child: Text(driverText(item['name'])),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _busy
                                  ? null
                                  : (v) => setState(() => _documentType = v),
                              validator: context.localizedValidator((v) => v == null ? 'Select a document type.' : null),
                            ),
                    ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _title,
                    enabled: !_busy,
                    maxLength: 160,
                    decoration: InputDecoration(
                      labelText: _proof
                          ? context.mobileText('Title (optional)')
                          : context.mobileText('Document title'),
                    ),
                    validator: context.localizedValidator((v) => !_proof && (v?.trim().length ?? 0) < 2 ? 'Enter at least 2 characters.' : null),
                  ),
                  TextFormField(
                    controller: _note,
                    enabled: !_busy,
                    minLines: 2,
                    maxLines: 4,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      labelText: _proof
                          ? context.mobileText('Note (optional)')
                          : context.mobileText('Description (optional)'),
                    ),
                  ),
                  if (!_proof) ...[
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _expiry ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null && mounted) {
                                setState(() => _expiry = date);
                              }
                            },
                      icon: const Icon(Icons.event),
                      label: Text(
                        _expiry == null
                            ? context.mobileText('Expiry date (optional)')
                            : 'Expires ${_expiry!.year}-${_expiry!.month.toString().padLeft(2, '0')}-${_expiry!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                    if (_expiry != null)
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => setState(() => _expiry = null),
                        child: Text(context.mobileText('Clear expiry date')),
                      ),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _pick,
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      _file?.name ?? 'Select file',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _proof
                        ? context.mobileText(
                            'PDF, JPG, PNG or WebP · Up to 5 MB',
                          )
                        : context.mobileText(
                            'PDF, JPG, PNG, WebP, DOC or DOCX · Up to 5 MB',
                          ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _busy || (!_proof && _documentType == null)
                        ? null
                        : _submit,
                    icon: _busy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload),
                    label: Text(
                      _busy
                          ? context.mobileText('Uploading…')
                          : context.mobileText('Upload'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
