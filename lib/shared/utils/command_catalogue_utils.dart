import '../../features/superadmin/models/superadmin_vehicle_model.dart';

/// Normalises and deduplicates a raw list of custom commands fetched from any
/// role endpoint (superadmin / admin / user).
///
/// Normalisation order:
///   A. Remove inactive commands.
///   B. Prefer commands belonging to [selectedDeviceTypeId] when provided; any
///      command whose [SuperadminCustomCommand.deviceTypeId] is non-null and
///      does NOT match [selectedDeviceTypeId] is dropped.
///   C. Remove exact duplicate stable backend IDs.
///   D. Remove commands whose normalised payload matches one already retained
///      (payload-only key; commandTypeId and deviceTypeId are NOT part of the
///      final dedup key so the same bytes sent to the device are always shown
///      once regardless of metadata differences).
///
/// Two commands with the same [commandTypeName] but different payloads are
/// kept as separate entries; they are distinguishable via [displaySelectedLabel]
/// on the model.
///
/// The result is sorted by commandTypeName then command text.
///
/// Returns a list where every element has a [stableKey] that is globally unique
/// within the list, safe to use as a [DropdownMenuItem.value].
List<SuperadminCustomCommand> deduplicateLiveMapCommandCatalogue(
  List<SuperadminCustomCommand> raw, {
  int? selectedDeviceTypeId,
}) {
  // ---- A. Remove inactive commands ----------------------------------------
  final active = raw.where((cmd) => cmd.isActive).toList(growable: false);

  // ---- B. Device-type filtering -------------------------------------------
  //
  // When [selectedDeviceTypeId] is known, drop records whose deviceTypeId is
  // also known but different.  Records with no deviceTypeId are kept — they
  // may be universal commands the backend sends without a type tag.
  final deviceFiltered = selectedDeviceTypeId != null
      ? active.where((cmd) {
          final dt = cmd.deviceTypeId;
          return dt == null || dt == selectedDeviceTypeId;
        }).toList(growable: false)
      : active;

  // ---- C+D. ID dedup then payload dedup -----------------------------------
  final seenIds = <String>{};
  final seenPayloadKeys = <String>{};
  final result = <SuperadminCustomCommand>[];

  for (final cmd in deviceFiltered) {
    final id = cmd.id.trim();

    // C — exact stable ID collision
    if (id.isNotEmpty && seenIds.contains(id)) continue;

    // D — same normalised payload (regardless of commandTypeId/deviceTypeId)
    final payloadKey = _normalisePayload(cmd.command);
    if (seenPayloadKeys.contains(payloadKey)) continue;

    if (id.isNotEmpty) seenIds.add(id);
    seenPayloadKeys.add(payloadKey);
    result.add(cmd);
  }

  result.sort((a, b) {
    final typeA = (a.commandTypeName ?? '').toLowerCase();
    final typeB = (b.commandTypeName ?? '').toLowerCase();
    final typeCmp = typeA.compareTo(typeB);
    if (typeCmp != 0) return typeCmp;
    return a.command.toLowerCase().compareTo(b.command.toLowerCase());
  });

  // Assign stable unique selection keys and return.
  return _assignStableKeys(result);
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/// Normalise a command payload for equality comparison:
/// - trim leading/trailing whitespace
/// - normalise CRLF and CR line endings to LF
/// - lower-case for case-insensitive comparison
String _normalisePayload(String payload) {
  return payload
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .trim()
      .toLowerCase();
}

/// Re-wrap each command with a [stableKey] that is unique within [items].
///
/// Priority for the stable key:
///   1. The backend ID when it is non-empty and unique within the list.
///   2. `<backendId>@<index>` when the ID collides with a prior entry.
///   3. `payload@<index>` when the backend ID is empty.
///
/// The original [SuperadminCustomCommand.id] (backend ID) is preserved on the
/// returned object and used for display/submission lookups.
List<SuperadminCustomCommand> _assignStableKeys(
    List<SuperadminCustomCommand> items) {
  final usedKeys = <String>{};
  final out = <SuperadminCustomCommand>[];

  for (var i = 0; i < items.length; i++) {
    final cmd = items[i];
    final backendId = cmd.id.trim();
    String key;
    if (backendId.isNotEmpty && !usedKeys.contains(backendId)) {
      key = backendId;
    } else if (backendId.isNotEmpty) {
      key = '$backendId@$i';
    } else {
      key = '${_normalisePayload(cmd.command)}@$i';
    }
    usedKeys.add(key);
    // Preserve original command exactly — only the key changes.
    out.add(cmd.withStableKey(key));
  }

  return out;
}
