/// Identifies which user role a [LiveMapRoleConfig] is bound to.
///
/// The shared live map engine uses this enum to pick role-scoped endpoints,
/// socket subscription strategies, persisted storage keys, and feature flags.
enum LiveMapRole {
  superadmin,
  admin,
  user,
}

/// How the live map should issue commands to vehicles for a given role.
enum LiveMapCommandSendMode {
  /// `POST /<scope>/vehicles/by-imei/{imei}/send-command`.
  byImei,

  /// `POST /<scope>/commands/send-bulk` with `{ vehicleIds: [...] }`.
  bulkByVehicleId,

  /// Commands are not supported for this role.
  disabled,
}

/// How the live map should subscribe to notification events on the socket.
enum LiveMapNotificationSubscribeMode {
  /// Server-side scope-aware subscription (superadmin sees everything).
  superadminScope,

  /// Subscribe explicitly with the list of vehicle IMEIs the user can see.
  imeis,

  /// Demo notifications are REST-backed and intentionally have no socket.
  disabled,
}

/// How the live map should subscribe to live telemetry updates.
enum LiveMapTelemetrySubscribeMode {
  /// Subscribe to the bounded, coalesced superadmin telemetry stream.
  superadminScope,

  /// Subscribe explicitly with the list of vehicle IMEIs.
  imeis,

  /// Subscribe to the isolated public demo telemetry simulator.
  demoScope,
}
