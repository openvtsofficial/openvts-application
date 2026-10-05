import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/errors/error_mapper.dart';
import '../models/driver_workspace_models.dart';
import '../services/driver_workspace_service.dart';
import 'driver_providers.dart';

class DriverMessagesState {
  const DriverMessagesState(
      {this.items = const [],
      this.loading = true,
      this.fetching = false,
      this.sending = false,
      this.error,
      this.nextBeforeId});
  final List<Map<String, dynamic>> items;
  final bool loading, fetching, sending;
  final String? error, nextBeforeId;
  DriverMessagesState copyWith(
          {List<Map<String, dynamic>>? items,
          bool? loading,
          bool? fetching,
          bool? sending,
          String? error,
          String? nextBeforeId,
          bool replaceCursor = false}) =>
      DriverMessagesState(
          items: items ?? this.items,
          loading: loading ?? this.loading,
          fetching: fetching ?? this.fetching,
          sending: sending ?? this.sending,
          error: error,
          nextBeforeId: replaceCursor ? nextBeforeId : this.nextBeforeId);
}

final driverMessagesControllerProvider = StateNotifierProvider.autoDispose<
    DriverMessagesController, DriverMessagesState>((ref) {
  final controller =
      DriverMessagesController(ref.watch(driverWorkspaceServiceProvider));
  controller.refresh();
  return controller;
});

class DriverMessagesController extends StateNotifier<DriverMessagesState> {
  DriverMessagesController(this._service) : super(const DriverMessagesState());
  final DriverWorkspaceService _service;
  Future<void>? _inFlight;
  String? _pendingBody, _pendingMessageId;
  Future<void> refresh() => _request(false);
  Future<void> loadOlder() => _request(true);
  Future<void> _request(bool older) {
    if (_inFlight != null) return _inFlight!;
    if (!mounted || (older && state.nextBeforeId == null)) {
      return Future.value();
    }
    final request = _load(older);
    _inFlight = request;
    return request.whenComplete(() => _inFlight = null);
  }

  Future<void> _load(bool older) async {
    final firstPage = state.items.isEmpty;
    state = state.copyWith(fetching: true, error: null);
    try {
      final data =
          await _service.messages(beforeId: older ? state.nextBeforeId : null);
      if (!mounted) return;
      final merged = {
        for (final message in state.items) driverText(message['id']): message
      };
      for (final message in driverItems(data['items'])) {
        merged[driverText(message['id'])] = message;
      }
      final items = merged.values.toList()
        ..sort((a, b) => (BigInt.tryParse(driverText(a['id'])) ?? BigInt.zero)
            .compareTo(BigInt.tryParse(driverText(b['id'])) ?? BigInt.zero));
      state = state.copyWith(
          items: List.unmodifiable(items),
          loading: false,
          fetching: false,
          replaceCursor: older || firstPage,
          nextBeforeId: data['hasMore'] == true
              ? driverText(data['nextBeforeId'])
              : null);
      // The view invokes refresh only while visible. A failed receipt is retried
      // on the next refresh; it must not hide successfully fetched messages.
      try {
        await _service.readMessages();
      } catch (_) {}
    } catch (error) {
      if (mounted) {
        state = state.copyWith(
            loading: false,
            fetching: false,
            error: ErrorMapper.from(error).message);
      }
    }
  }

  Future<bool> send(String text) async {
    final body = text.trim();
    if (!mounted || state.sending || body.isEmpty || body.length > 4000) {
      return false;
    }
    if (_pendingBody != body) {
      _pendingBody = body;
      _pendingMessageId = const Uuid().v4();
    }
    state = state.copyWith(sending: true);
    try {
      await _service.sendMessage(body, _pendingMessageId!);
      if (!mounted) return false;
      _pendingBody = null;
      _pendingMessageId = null;
      if (_inFlight != null) await _inFlight;
      if (!mounted) return false;
      await refresh();
      if (mounted) state = state.copyWith(sending: false, error: state.error);
      return true;
    } catch (error) {
      if (mounted) {
        state = state.copyWith(
            sending: false, error: ErrorMapper.from(error).message);
      }
      return false;
    }
  }
}
