import '../models/admin_vehicle_model.dart';

/// Deduplicates and sorts a raw list of custom commands.
///
/// Priority:
///   1. Unique by [AdminCustomCommand.id] (stable backend ID wins).
///   2. When the backend repeats semantically identical records under different
///      wrappers, a composite key of deviceTypeId + commandTypeId + normalised
///      command text is used.
///
/// Two commands with the same display title but different command text are
/// kept as separate entries.
///
/// The result is sorted by commandTypeName then command text, matching the
/// ordering the backend applies server-side.
List<AdminCustomCommand> deduplicateAndSortCommands(
    List<AdminCustomCommand> raw) {
  final seenIds = <String>{};
  final seenCompositeKeys = <String>{};
  final result = <AdminCustomCommand>[];

  for (final cmd in raw) {
    final id = cmd.id.trim();

    // Primary dedup: stable backend ID.
    if (id.isNotEmpty && seenIds.contains(id)) continue;

    // Secondary dedup: semantically identical records wrapped differently.
    final compositeKey = _compositeKey(cmd);
    if (seenCompositeKeys.contains(compositeKey)) continue;

    if (id.isNotEmpty) seenIds.add(id);
    seenCompositeKeys.add(compositeKey);
    result.add(cmd);
  }

  result.sort((a, b) {
    final typeA = (a.commandTypeName ?? '').toLowerCase();
    final typeB = (b.commandTypeName ?? '').toLowerCase();
    final typeCmp = typeA.compareTo(typeB);
    if (typeCmp != 0) return typeCmp;
    return a.command.toLowerCase().compareTo(b.command.toLowerCase());
  });

  return result;
}

String _compositeKey(AdminCustomCommand cmd) {
  final deviceType = cmd.deviceTypeId?.toString() ?? '';
  final commandType = cmd.commandTypeId?.toString() ?? '';
  final text = cmd.command.trim().toLowerCase();
  return '$deviceType|$commandType|$text';
}
