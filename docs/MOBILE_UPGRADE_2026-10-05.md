# Mobile upgrade — 5 October 2026

This initial API parity record is retained for context. The subsequent [mobile UX and Operations revision](MOBILE_UX_REVISION_2026-10-05.md) restores the original launcher, embeds Security in Settings, completes the language catalogs and rebuilds route creation. See `VERIFICATION.txt` for the current revision results.

## Source and scope

Updated `openvts-application-master(2).zip` against the supplied `openVTS-main(20261002-095331).zip` backend controllers, DTOs, permission definitions and web screens. The web/backend/listener archive is unchanged. The mobile package includes source code, regression tests and this implementation/verification record; it is not a signed Android or iOS release.

## Page and API review

| Area | Mobile implementation |
| --- | --- |
| Login and session | All six roles: Superadmin, Admin, Team, User, Subuser and Driver. MFA challenge and authenticator/recovery-code verification; expired challenge handling; token rotation and guarded refresh. Unknown roles fail closed. |
| Security | Authenticator enrollment by QR/manual key, confirmation, authenticator removal, MFA disable, recovery-code replacement, and API-token creation/revocation. MFA security changes replace the current access/refresh tokens and invalidate previous sessions through the backend. User/Subuser account deletion requires confirmation. |
| Navigation | Team bootstrap grants and navigation are intersected; User/Subuser features and reports use `/user/permissions`. Missing/malformed permissions grant no workspace access. Home/profile/security remain reachable to recover. Access refreshes on app resume and periodically. |
| Session isolation | Data providers invalidate when identity or effective permissions change. Unchanged permission refreshes preserve screen data. Account changes reset navigation. Old-account API responses are rejected. Credentials are restricted to the configured API origin/path. |
| Superadmin home/dashboard | Mobile cards and responsive navigation; current overview and activity APIs retained. |
| Superadmin administrators | Optional contact/location fields aligned with DTOs, explicit email clearing, exact password preservation, Unicode names and existing credits/documents/activity/detail flows. |
| Superadmin vehicles/maps/calendar | Existing tracking and detail flows retained; corrected inactive/disconnected and license-block status precedence. Map refresh no longer resets on unchanged access polls. |
| Superadmin payments/support/settings/server/notifications | Existing APIs reviewed. Unicode support text, exact passwords and null/zero localization values corrected; speculative localization writes removed. Notification inbox remains available. |
| Admin and Team home | Shared mobile workspace with capability-filtered destinations and actions. Team requests use explicit current Team contracts rather than falling back to Admin APIs. |
| Admin/Team customers | Scoped read/edit/status/password/impersonation/assignment/document controls. Admin customer feature/report permission editor added. |
| Admin/Team vehicles | Scoped create/config/history/commands/sensors/documents/assignments. Team numeric-vehicle contextual APIs. Admin annual/service-expiry management and credit renewal controls. |
| Admin/Team drivers/inventory | Current contextual selectors and record APIs; create/edit/delete controls follow capabilities. |
| Admin team members | Permission catalog and grant/scope matrix, plus member activity logs. The unrelated Admin Roles page and route are removed. |
| Admin Payments | Customer payments retained separately, scoped renewal selectors, repeat-request idempotency, current payment constraints, and customer renewal-request review/confirmation. |
| Admin Transactions | New administrator-to-software-owner ledger with search debounce, status/date filters, pagination, refresh, details and error/empty/loading states. Uses `/admin/transactions`. |
| Admin/Team support/calendar/logs/maps | Existing mobile pages adapted to supported Team endpoints and capabilities. Team map commands remain unavailable, matching the web Team map. |
| User/Subuser dashboard/maps/vehicles | Server feature permissions govern entry points and map overlays/actions; customer service expiry is displayed. Existing tracking/details retained. |
| User/Subuser reports | Both catalog and direct report workspace enforce per-report permission. |
| User accounts | Driver/Subuser account pages retained; Subuser permission editor respects parent availability and disabled features/reports. |
| User Operations | Today, trips, calendar, driver availability, planning options, planning timezone, recurring schedules and skip dates; trip details, authenticated image/PDF proof preview and save/share, route/stops/current-position map, and version-checked overrides. |
| User Transactions/services | Existing transaction history plus service availability, renewal request creation/status/cancellation. No in-app payment checkout. |
| User Messages | Dedicated driver conversations with search, unread counts, history, receipts, stable retry IDs and foreground updates using the current dispatcher messaging APIs. |
| User landmarks/track links/support/notifications/settings | Existing screens retained behind current feature permissions. Notification settings and inbox retain their distinct behavior. |
| Driver | Dedicated dashboard, searchable/paginated trips, ordered stop actions, start fallback, remarks/issues/proof upload, route map, completed-trip calendar, private documents, messages, notification inbox, profile/preferences/password and security. |
| Mobile presentation | Shared existing theme, page scaffolds, cards and bottom sheets; compact phone layouts, searchable lists, wrapping action groups, loading/error/empty states. Narrow-width and large-text widget checks cover the role home and driver pages. |

## Deliberate exclusions

No Superadmin Master Data, software-license activation, SSL or Notify campaigns; no Admin Notify campaigns; no User Workflow. The notification inbox is separate from Notify campaigns. Backend license enforcement, including the unlicensed vehicle cap, remains the server's responsibility and has not been changed.

## Run the source

Use Flutter 3.47.6 / Dart 3.13.5, the SDK used for this delivery's validation. The updated lockfile records its SDK-pinned dependency versions. Earlier Flutter versions may need a compatible dependency resolution.

The package contains a non-secret `.env` with the original default server `https://app.openvts.io/api` and `USE_MOCK_DATA=false`. Select your own deployment using Server URL on the sign-in screen. Do not place credentials or server secrets in `.env`; Flutter assets are shipped with the app.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

In unattended CI, set `CI=true` and `FLUTTER_SUPPRESS_ANALYTICS=true`. Android signing, iOS signing and platform build configuration must be supplied in your release environment.

## Verification

Final exact results are recorded in `VERIFICATION.txt` beside this document. Contract tests exercise request paths, methods, payloads and permission behavior with controlled transports; they do not replace testing against a deployed backend.

## Release validation still required

- Exercise real MFA enrollment/recovery, refresh/logout, account deletion, impersonation and permission revocation with one account for each supported role against your deployment.
- Run Android and iOS builds on the intended SDKs and physical devices, including secure storage, file/image pickers, downloads, notification permissions and background behavior. Native build/signing tools and live account credentials were not available in this workspace.
- Native driver FCM registration is deliberately withheld: the supplied backend push-token table references User IDs, while drivers use a separate identity table. Driver in-app notifications work through Driver APIs. Supporting driver push requires a backend identity/schema change and device testing.
- Verify live telemetry/socket connectivity, command acknowledgement, payment renewal idempotency and private document authorization with real server data.
- The subsequent UX revision resolves the earlier missing translation messages and expands all six catalogs. Translation, RTL and placeholder checks are recorded in its verification results; server/user data stays unchanged.
- The repository retains pre-existing architecture guardrail debt, including Dio types in feature services and PDF font downloads. See the final verification record for analyzer and architecture-check results. The JavaScript web compiler is a compile check, not proof of native readiness or WebAssembly compatibility.
