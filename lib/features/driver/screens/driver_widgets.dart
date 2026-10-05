import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/helpers/toast_helper.dart';
import '../../../shared/helpers/validation_localizations.dart';
import '../models/driver_workspace_models.dart';

class DriverAsyncBody<T> extends StatelessWidget {
  const DriverAsyncBody({
    super.key,
    required this.value,
    required this.onRetry,
    required this.builder,
  });
  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(T) builder;
  @override
  Widget build(BuildContext context) => value.when(
    data: builder,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, _) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 12),
            Text(ErrorMapper.from(error).message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.mobileText('Try again')),
            ),
          ],
        ),
      ),
    ),
  );
}

class DriverEmpty extends StatelessWidget {
  const DriverEmpty(
    this.message, {
    super.key,
    this.icon = Icons.route_outlined,
  });
  final String message;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
    child: Column(
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ),
  );
}

class DriverStatus extends StatelessWidget {
  const DriverStatus(this.status, {super.key});
  final String status;
  @override
  Widget build(BuildContext context) => Chip(
    visualDensity: VisualDensity.compact,
    label: Text(context.mobileText(driverStatusLabel(status))),
    avatar: Icon(
      status == 'COMPLETED'
          ? Icons.check_circle_outline
          : Icons.circle_outlined,
      size: 16,
    ),
  );
}

class DriverTripCard extends ConsumerWidget {
  const DriverTripCard({super.key, required this.trip, required this.onTap});
  final DriverTrip trip;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(appDateFormatterProvider);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    trip.referenceCode,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  DriverStatus(trip.status),
                ],
              ),
              Text(trip.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (trip.stops.isNotEmpty)
                Text('${trip.stops.first.name} → ${trip.stops.last.name}'),
              if (trip.vehicleLabel.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(trip.vehicleLabel),
                ),
              const SizedBox(height: 6),
              Text(
                formatter.formatDateTime(trip.scheduledStart),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: trip.progress, minHeight: 4),
              const SizedBox(height: 6),
              Text(
                context.mobileText("{value1} / {value2} stops completed", {
                  'value1':
                      (trip.stops.where((s) => s.status == 'COMPLETED').length)
                          .toString(),
                  'value2': (trip.stops.length).toString(),
                }),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void driverToast(BuildContext context, Object message) {
  if (context.mounted) {
    ToastHelper.show(context, '$message');
  }
}

Future<String?> driverNoteDialog(
  BuildContext context, {
  required String title,
  String explanation = '',
  int minimum = 0,
  int maximum = 600,
}) => showDialog<String>(
  context: context,
  builder: (_) => _DriverNoteDialog(
    title: title,
    explanation: explanation,
    minimum: minimum,
    maximum: maximum,
  ),
);

class _DriverNoteDialog extends StatefulWidget {
  const _DriverNoteDialog({
    required this.title,
    required this.explanation,
    required this.minimum,
    required this.maximum,
  });
  final String title, explanation;
  final int minimum, maximum;
  @override
  State<_DriverNoteDialog> createState() => _DriverNoteDialogState();
}

class _DriverNoteDialogState extends State<_DriverNoteDialog> {
  final _controller = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.explanation.isNotEmpty) ...[
              Text(widget.explanation),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _controller,
              minLines: 2,
              maxLines: 5,
              maxLength: widget.maximum,
              decoration: InputDecoration(
                labelText: widget.minimum > 0
                    ? context.mobileText('Note')
                    : context.mobileText('Note (optional)'),
              ),
              validator: context.localizedValidator((v) => (v?.trim().length ?? 0) < widget.minimum ? 'Enter at least ${widget.minimum} characters.' : null),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.mobileText('Cancel')),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, _controller.text.trim());
          }
        },
        child: Text(context.mobileText('Confirm')),
      ),
    ],
  );
}

Future<void> shareDriverFile(
  BuildContext context,
  Future<Uint8List> Function() download,
  String fileName,
  String mimeType,
) async {
  try {
    final bytes = await download();
    if (!context.mounted) return;
    final safeName = fileName.replaceAll(RegExp(r'[\\/\x00-\x1f]'), '_');
    final box = context.findRenderObject() as RenderBox?;
    await Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: mimeType, name: safeName)],
      fileNameOverrides: [safeName],
      sharePositionOrigin: box == null
          ? null
          : box.localToGlobal(Offset.zero) & box.size,
    );
  } catch (error) {
    if (context.mounted) driverToast(context, ErrorMapper.from(error).message);
  }
}

/// Refresh only a visible, foreground screen. Vehicle telemetry is server data;
/// these views do not request or transmit handset location.
class DriverRefreshScope extends StatefulWidget {
  const DriverRefreshScope({
    super.key,
    required this.child,
    required this.onRefresh,
    this.interval = const Duration(seconds: 30),
  });
  final Widget child;
  final VoidCallback onRefresh;
  final Duration interval;
  @override
  State<DriverRefreshScope> createState() => _DriverRefreshScopeState();
}

class _DriverRefreshScopeState extends State<DriverRefreshScope>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(widget.interval, (_) {
      if (_foreground && (ModalRoute.of(context)?.isCurrent ?? true)) {
        widget.onRefresh();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground && (ModalRoute.of(context)?.isCurrent ?? true)) {
      widget.onRefresh();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
