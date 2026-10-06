# Mobile tracking and permission fixes — 6 October 2026

The uploaded `openvts-application-master(3).zip` is the exact source baseline for this revision. Its SHA-256 is `db6b1ec1456add35a015a1efed4fdd92812ba7c8e4d31db07a35acc03fcd18e6`. Existing mobile customizations are retained. Contracts were traced in the provided web reference and the October 2 web/backend source used for the earlier mobile upgrade. This delivery changes the mobile source only.

## Requested behavior

| Area | Revised behavior |
| --- | --- |
| Admin → Users → single User | Vehicles, Drivers, Tickets and Payments use an API/auth graph without a circular dependency. Permissions and Data Backup are visible detail tabs. |
| User permissions | Loads the current permission object, edits feature/report restrictions and saves exact deny lists. The web-only Workflow setting is preserved. Invalid loads cannot enable replacement writes. |
| Data Backup | Matches the web telemetry-retention page: inherited policy, effective retention, parent limit, explicit supported duration or inherited reset, GET/PATCH of the user retention policy. This is the backend's retention policy UI. |
| Admin → Teams → row | Opens Profile, Permissions and Activity Logs. Existing shortcuts open these same tabs. Direct permissions, dependent scopes and elevation confirmation follow the current catalog. |
| User → Accounts → Subusers → row | Permissions are a detail tab using current inherited feature/report restrictions and scoped GET/PUT APIs. |
| Permission safety | Current principal/access scope controls reads and writes; malformed catalogs, duplicate saves, revoked rights and stale responses cannot overwrite another account's permissions. |
| Six role sessions | Superadmin, Admin, Team, User, Subuser and Driver use the existing common login/MFA flow and current profile verification. Existing Login-as Admin/User validates the returned role, identity and tokens and retains preferences. |
| Whole-fleet maps | Cursor collection loads the full authorized fleet, rather than only the default first 100 vehicles. Same shared implementation covers Superadmin, Admin/Team and User/Subuser endpoints. |
| Live continuity | Scoped subscriptions, token-rotation reconnects, reconnect/resume catch-up, periodic membership reconciliation, stale-packet rejection and bounded batch publishing prevent missed updates and full-fleet copying for every packet. |
| Status and plotting | Web-compatible three-state presentation, speed threshold, receive-time freshness, inactive threshold and pending-stop debounce. Stationary packets can change icon/status without changing coordinates. Existing type-specific green/red/white icons and motion timings are retained. |
| Tracking data | Device/GPS time, server receive time and last connection stay separate. Today distance uses the requested device-local day baseline, with safe zero values, rollover and odometer reset handling. |
| Tracking timestamps | Uses device-local display as the current web does, without adding a saved timezone offset a second time. Log timeline uses canonical/device time before server time; logs include seconds in 12-hour and 24-hour displays. |
| Reports | Shared mobile history calendar, presets, custom range, time controls, clear/cancel/apply and report limits. Date-only and UTC datetime request semantics remain distinct. Full-day bounds match the web, including the last day's final milliseconds. |
| Operations controls | Common buttons, tabs, searchable selectors and cards with responsive translated layouts. Route creation, planning payloads and account scheduling timezone behavior are retained. |
| Account-switch detail data | Old route extras do not seed unverified Admin/Subuser profiles after account or permission scope changes. |

## Root causes corrected

The shared map read stopped after one response even though map telemetry defaults to 100 rows and exposes cursors. Realtime did not recover missing snapshots on reconnect or resume. Stale textual running flags could override zero speed, while display time applied the device timezone and then an extra account offset. A synchronous API role lookup traversed AuthController even though AuthController depended on ApiClient, creating the reported Riverpod cycle. Startup transport failures were treated as unauthenticated sessions. Report inputs used separate basic dialogs and minute-only bounds.

The uploaded project also contained incomplete older code/test contracts. The declared `.env` asset was absent; it was restored from the supplied `.env.example` with its original nonsecret default and `USE_MOCK_DATA=false`. Missing legal-link/configuration definitions and browser-day tracking contracts were repaired. An unused obsolete deletion widget was removed; current Settings Security account deletion remains intact. SDK minimums now match the included lockfile, and the already-used timezone package is a direct dependency.

Full-suite verification identified additional payload mismatches: SMTP's named email body, blank optional User creation fields, nested line-geofence tolerance, Driver active-state spelling/type, POI icon selection and entity-specific bulk-import envelopes. Those payloads now follow the current backend. POI updates no longer retry with fabricated zero coordinates. Notification pagination respects the backend's 30-row cap and role-specific filters; activity pagination respects its bounds and retains actor/date filters. Silent native push registration checks current OS permission before generating a token or accepting cached registration, deregisters after confirmed revocation and handles lifecycle errors without an unexpected permission prompt.

The existing native iOS companion-app policy is enforced at both manual subscription-renewal service entry points and their launch buttons. Payment history remains accessible; Android renewal retains a stable idempotency key for retries. No checkout is introduced.

The Cupertino icon-font dependency required by adaptive Flutter controls is included, resolving the release compiler's missing-font warning. This does not change the original launcher icons.

## Session lifetime

A temporary outage or ordinary permission denial keeps the account logged in while permission-dependent access waits for verification. Refresh is single-flight, tied to the login generation, and commits only if the original account/server session is still current. Old refreshes cannot undo logout or a newer login. Genuine token rejection, session revocation, password/MFA changes, account deactivation and role changes still require authentication.

The supplied backend defaults to a 24-hour access token and a seven-day refresh token, renewed after successful refresh. A mobile app left inactive or offline beyond the backend refresh lifetime still needs login. Mobile source cannot safely bypass that server policy. Configure any different lifetime on your backend and validate it in staging.

## Development and verification

Flutter 3.47.6 / Dart 3.13.5 is the validation toolchain. Keep the provided lockfile. Run `flutter pub get`, `flutter analyze`, `flutter test` and your native build commands. For unattended commands, set `CI=true` and `FLUTTER_SUPPRESS_ANALYTICS=true`. The sign-in Server URL setting selects your deployment.

New application-authored UI text is translated in English, Arabic, Spanish, French, Hindi and Portuguese. User-entered content and server messages stay data. Localization maintenance:

```sh
flutter gen-l10n
dart run tool/generate_mobile_text.dart
dart format lib/shared/helpers/mobile_text.dart
dart tool/mobile_localization_contract.dart
flutter test test/l10n
```

Exact final command outcomes and package checks are recorded in `docs/VERIFICATION.txt` and the accompanying verification report. Prior dated upgrade notes remain historical records.

Tests use controlled transports and widgets. They cover 220-vehicle pagination across scopes, large subscriptions, reconnect/resume and sparse/stale packets, zero speed and stationary updates, timezone display, the real Auth/API dependency graph, permission and retention payloads, session races, account switching and narrow Arabic date/planning controls. They are not evidence that the application has been run against your live database or physical devices.

Android/iOS SDKs, signing identities, native devices and live role credentials were unavailable. Validate the revised application against your deployment before release, including actual 220-vehicle membership, live stop/start transitions, all six roles, permission revocation, token rotation, MFA, reports and native integrations. No signed APK/AAB/IPA is included. The JavaScript release build is a compiler check.

The repository-wide architecture guard retains existing migration debt; the final report compares the actual uploaded baseline with the revised source. No broad allowlist was introduced.

## Applying the patch

The full ZIP is ready to extract as source. The patch is an alternative: apply it from the root of a clean extraction of the uploaded `(3)` ZIP with the SHA-256 above. Do not apply it to the older `(2)` ZIP or to this revised ZIP.

```sh
git apply --check /absolute/path/OpenVTS_Mobile_Tracking_Permissions_2026-10-06.patch
git apply /absolute/path/OpenVTS_Mobile_Tracking_Permissions_2026-10-06.patch
```
