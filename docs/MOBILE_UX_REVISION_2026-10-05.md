# Mobile UX and Operations revision — 5 October 2026

This revision updates the previously delivered mobile source. The original mobile launcher was recovered from the pre-upgrade source; API and Operations behavior were checked against `openVTS-main(20261002-095331).zip`. The web, backend, and listener source are unchanged. The earlier API parity implementation remains included.

## Requested changes

| Area | Implemented behavior |
| --- | --- |
| Home / desktop | Original centered logo, rounded square icon tiles, labels, gradient, footer and normal-size grid restored. Large text can expand the layout. Destinations still follow current server permissions. |
| Header | Language, theme, notifications, profile in that logical order. Accessible touch targets; unauthorized notification access stays hidden. |
| Language | English, Arabic, Spanish, French, Hindi and Portuguese. Immediate persistent device language selection, Arabic RTL, existing Settings integration, translated forms, dialogs, filters, validation and action feedback. Server preference hydration preserves the explicit device choice; an explicit Settings save can change it. |
| Language quality | All six catalogs have complete matching message keys (exact count in `VERIFICATION.txt`), with typed placeholders and locale-specific plural handling. User names, user-entered content, identifiers, protocol values and backend messages remain data. Display date formatting follows the selected language without changing wire-format dates. |
| Security | Embedded tab within Settings for Superadmin, Admin, Team, User, Subuser and Driver. No independent launcher tile. Legacy security URLs redirect to the Settings security tab. MFA, recovery, token management and permitted account deletion remain available. |
| Team / Driver Settings | Role-specific personal APIs. Team settings do not fall back to tenant Admin settings endpoints. Failed account loads cannot save empty placeholder values; Security remains accessible. |
| Operations route creation | Shared builder for Operations and Landmarks. Add stops from saved POIs, saved geofences, map taps or latitude/longitude; edit stop details, reorder and remove stops, support road-shaping via points and round trips. |
| Road path | Actual driving geometry, distance and duration from the configured OSRM provider. Stops and source IDs are stored separately from the road vertices in the current route POST/PATCH contract. Failed or malformed routing cannot save an invented straight line. Snap distance, legs, coordinate ranges and geometry continuity are checked. |
| Optimization | Optimizes geographic visiting order, matching the web objective; keeps the start and, for a one-way trip, destination fixed. Exact search up to 12 stops; bounded heuristic above 12. The road provider then computes a drivable path. This is not a claim of global road-time optimality. |
| Route → trip | Creating or editing a route returns to the retained trip draft, refreshes planning options and selects the saved route ID. Vehicle eligibility, unavailable route reasons, schedule variants, account timezone, recurring version checks, skip dates and generation warnings are handled. |
| Operations pages | Today/trips/calendar/drivers, monthly drilldown, search and refresh, trip details, attention-event acknowledgment, proof and map views retain current API contracts. Unsaved changes are protected. |
| Shared controls | Consistent theme for buttons, inputs, dialogs and sheets; 48-pixel button targets; scalable labels; a common searchable dropdown sheet with keyboard-safe scrolling, required validation and disposed/stale-result guards; accessible tabs, password input behavior and ink responses on cards. |
| Additional layout review | Admin/Superadmin calendar uses a shared mobile month view with accessible large-text date list; responsive dashboard KPI cards and vehicle status filters. Settings and notification save bars fit ordinary 320-pixel screens and expand appropriately for translated or large text. |
| Session isolation | Existing permission/session controls retained. Calendar providers now depend on the account/access scope, preventing cached rows from leaking across account changes. |

## Scope retained from the earlier upgrade

All six role logins, MFA, dynamic permissions and navigation, Admin Transactions, Driver workflows, current Team/User APIs and prior security regressions remain included. Admin Roles is removed. The mobile app still excludes Superadmin Master Data, software-license activation, SSL and Notify campaigns; Admin Notify campaigns; and User Workflow. Notification inboxes remain distinct from Notify campaigns. No in-app payment checkout was introduced.

## Run and maintain

Validated SDK: Flutter 3.47.6 / Dart 3.13.5. Keep the included lockfile. Use `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run` in your development environment. For unattended commands, set `CI=true` and `FLUTTER_SUPPRESS_ANALYTICS=true`.

The non-secret `.env` retains the original default server and `USE_MOCK_DATA=false`. Change Server URL at sign-in for your deployment. Authentication is sent only to the configured backend, not to the public road provider.

The routing default matches the web's public OSRM service. For production, configure the intended compatible endpoint with `--dart-define=OSRM_BASE_URL=https://your-routing-host`. Network availability and provider capacity affect route calculation. The builder reports failure and preserves the draft if roads cannot be calculated.

For localization maintenance:

```sh
flutter gen-l10n
dart run tool/generate_mobile_text.dart
dart format lib/shared/helpers/mobile_text.dart
dart tool/mobile_localization_contract.dart
flutter test test/l10n
```

Keep canonical API enums/IDs separate from display labels. Add translations to every ARB, preserve placeholder types, and use typed ICU plurals for counts. The static contract checks registered UI messages and approved dynamic enum/catalog translations. New dynamic sources require explicit review so that user/server data is not translated accidentally.

## Verification and deployment limits

Exact final command outcomes are recorded in `VERIFICATION.txt`. Tests use controlled transports to exercise backend paths, payloads, permission behavior, stale responses and failure states. Widget tests cover narrow phone sizes, large text, dark mode and RTL for the changed shared controls and key flows. A release web compilation is a compiler check.

Android/iOS SDKs, signing identities, physical devices and live role credentials were not available. Native release builds, real MFA/recovery, device file and notification integrations, real telemetry and the live routing/server flow must be validated in the target deployment. Source/test coverage is not certification that every native screen and integration has been exercised on a device.

The repository retains historical architecture guardrail debt, including Dio types in older feature layers and report PDF font downloads. The guard's `Options` check was narrowed to the actual identifier to eliminate unrelated `MapOptions`/`numberWithOptions` false positives; no broad allowlist was added. New route transport lives in the API layer and has no account credentials.

## Visual checks

Rendered widget previews were inspected for the restored launcher and revised calendar:

- [Home, light](ui-revision-previews/home-light.png)
- [Home, dark / narrow phone](ui-revision-previews/home-dark.png)
- [Calendar, light](ui-revision-previews/calendar-light.png)
- [Calendar, dark](ui-revision-previews/calendar-dark.png)

These are test-rendered previews, with a local fallback font used for capture; they are not native-device screenshots or evidence of live data.
