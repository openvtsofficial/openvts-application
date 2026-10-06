import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/helpers/toast_helper.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/widgets/open_vts_button.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../controllers/user_operations_providers.dart';
import '../../models/user_operation_attachment.dart';
import 'operations_localizations.dart';
import 'operations_ui.dart';

class UserOperationProofScreen extends ConsumerStatefulWidget {
  const UserOperationProofScreen({super.key, required this.proof});
  final UserOperationProof proof;
  @override
  ConsumerState<UserOperationProofScreen> createState() =>
      _UserOperationProofScreenState();
}

class _UserOperationProofScreenState
    extends ConsumerState<UserOperationProofScreen> {
  bool _sharing = false;
  @override
  Widget build(BuildContext context) {
    final content = ref.watch(userOperationProofProvider(widget.proof));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.proof.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: context.operationText('Save or share proof'),
            icon: const Icon(Icons.ios_share),
            onPressed:
                _sharing ||
                    content.isLoading ||
                    content.hasError ||
                    !content.hasValue
                ? null
                : () => _share(content.requireValue),
          ),
        ],
      ),
      body: SafeArea(
        child: content.when(
          skipLoadingOnRefresh: false,
          skipLoadingOnReload: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error is FormatException
                        ? error.message
                        : operationError(context, error),
                  ),
                  OpenVtsButton(
                    label: context.operationText('Retry'),
                    onPressed: () => ref.invalidate(
                      userOperationProofProvider(widget.proof),
                    ),
                    variant: OpenVtsButtonVariant.secondary,
                  ),
                ],
              ),
            ),
          ),
          data: (bytes) => widget.proof.isImage
              ? Center(
                  child: InteractiveViewer(
                    minScale: .5,
                    maxScale: 5,
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          context.operationText(
                            'This image could not be previewed. Use Save or share to open it in another app.',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : PdfPreview(
                  build: (_) async => bytes,
                  allowPrinting: false,
                  allowSharing: false,
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  useActions: false,
                  dynamicLayout: false,
                  pdfFileName: widget.proof.safeName,
                  onError: (_, __) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.operationText(
                          'This PDF could not be previewed. Use Save or share to open it in another app.',
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _share(Uint8List bytes) async {
    final current = ref.read(userOperationProofProvider(widget.proof));
    final user = ref.read(authControllerProvider).user;
    if (current.isLoading ||
        current.hasError ||
        !identical(current.valueOrNull, bytes) ||
        user == null ||
        user.role != UserRole.user ||
        !user.access.canFeature(user.role, 'routeOptimization')) {
      ToastHelper.showError(
        context.operationText(
          'Account access changed. Reopen this trip proof.',
        ),
        context: context,
      );
      return;
    }
    setState(() => _sharing = true);
    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            mimeType: widget.proof.mimeType,
            name: widget.proof.safeName,
          ),
        ],
        fileNameOverrides: [widget.proof.safeName],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (_) {
      if (mounted) {
        ToastHelper.showError(
          context.operationText(
            'Unable to share this proof. Please try again.',
          ),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }
}
