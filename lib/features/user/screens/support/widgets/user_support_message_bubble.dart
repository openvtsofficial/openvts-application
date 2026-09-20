import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_vts/core/theme/open_vts_radius.dart';
import 'package:open_vts/core/theme/open_vts_spacing.dart';
import 'package:open_vts/core/theme/open_vts_typography.dart';
import 'package:open_vts/core/utils/date_time_formatter.dart';
import 'package:open_vts/features/user/models/user_support_model.dart';
import 'package:open_vts/features/user/screens/support/widgets/user_support_attachment_widgets.dart';

class UserSupportMessageBubble extends ConsumerWidget {
  const UserSupportMessageBubble({
    required this.message,
    required this.isCurrentUser,
    required this.baseUrl,
    super.key,
  });

  final UserSupportTicketMessage message;
  final bool isCurrentUser;
  final String baseUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(appDateFormatterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    if (_isSystemMessage) {
      return _SystemMessageBubble(message: message, baseUrl: baseUrl);
    }

    final alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final borderColor = isCurrentUser
        ? colorScheme.primary.withValues(alpha: 0.18)
        : colorScheme.outlineVariant;
    final backgroundColor = isCurrentUser
        ? colorScheme.primary.withValues(alpha: 0.045)
        : colorScheme.surface;
    final senderLabel = _senderLabel;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Container(
          padding: const EdgeInsets.all(OpenVtsSpacing.sm),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(OpenVtsRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      senderLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OpenVtsTypography.meta.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (message.createdAt != null) ...[
                    const SizedBox(width: OpenVtsSpacing.xs),
                    Text(
                      dateFormatter.formatDateTime(message.createdAt!),
                      style: OpenVtsTypography.meta.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              if (message.message.trim().isNotEmpty) ...[
                const SizedBox(height: OpenVtsSpacing.xxs),
                Text(
                  message.message.trim(),
                  style: OpenVtsTypography.body.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.38,
                  ),
                ),
              ],
              if (message.attachments.isNotEmpty) ...[
                const SizedBox(height: OpenVtsSpacing.xs),
                UserSupportMessageAttachmentWrap(
                  attachments: message.attachments,
                  baseUrl: baseUrl,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _isSystemMessage {
    final role = message.sender?.role.trim().toLowerCase() ?? '';
    return role == 'system' || role == 'status' || role.contains('system');
  }

  String get _senderLabel {
    final displayName = message.sender?.displayName.trim() ?? '';
    if (displayName.isNotEmpty && displayName != '-') {
      return displayName;
    }
    if (isCurrentUser) {
      return 'You';
    }

    final role = message.sender?.role.trim() ?? '';
    if (role.isNotEmpty) {
      return role;
    }
    return 'Support';
  }
}

class _SystemMessageBubble extends ConsumerWidget {
  const _SystemMessageBubble({required this.message, required this.baseUrl});

  final UserSupportTicketMessage message;
  final String baseUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(appDateFormatterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final text = message.message.trim();
    final timestamp = message.createdAt;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        padding: const EdgeInsets.symmetric(
          horizontal: OpenVtsSpacing.sm,
          vertical: OpenVtsSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(OpenVtsRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text.isNotEmpty)
              Text(
                text,
                textAlign: TextAlign.center,
                style: OpenVtsTypography.meta.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (timestamp != null) ...[
              const SizedBox(height: OpenVtsSpacing.xxs),
              Text(
                dateFormatter.formatDateTime(timestamp),
                textAlign: TextAlign.center,
                style: OpenVtsTypography.meta.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (message.attachments.isNotEmpty) ...[
              const SizedBox(height: OpenVtsSpacing.xs),
              UserSupportMessageAttachmentWrap(
                attachments: message.attachments,
                baseUrl: baseUrl,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
