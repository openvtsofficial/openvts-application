OPENVTS · ENGINEERING

# Backend API Reference

Complete HTTP and Realtime Integration Manual

**590 HTTP routes · 21 controllers · 148 source schemas**

Internal Development Team Edition

Application API version: 2.6.0

Source snapshot: openVTS-main.zip

Archive SHA-256: ec4ca49499a364e18e3b1cd68971d8197f3f26b4848c525758d1881fd872e782

Generated: 27 July 2026

Source of truth: backend controllers, guards, DTOs, services, gateways, configuration, and response interceptor in the supplied archive.

## Document Control

| **Control** | **Value** |
| --- | --- |
| Document | OpenVTS Backend API Reference v1.0 |
| Audience | Internal frontend, mobile, backend, QA, DevOps, and integration teams |
| Scope | All HTTP routes and realtime namespaces in the supplied backend source |
| Application API version | 2.6.0 (GET /version) |
| Package version | 0.0.1 |
| Archive SHA-256 | ec4ca49499a364e18e3b1cd68971d8197f3f26b4848c525758d1881fd872e782 |
| Backend source SHA-256 | 0d6447b6f108fccc50c3d1a17f0336707130e8ebbae6a76f03d694aae1099942 |
| Inventory generated | 2026-07-27T00:17:13.418Z |
| Controllers | 21 |
| HTTP routes | 590 |
| Duplicate method/path routes | 0 |
| DTO/response schemas | 148 |
| Legacy Postman comparison | 151 of 324 saved requests exactly match current routes; source wins on every conflict. |

### Completeness and Interpretation

Every controller decorator in the supplied backend is represented exactly once in the endpoint reference and exactly once in the coverage ledger. The reference also includes request DTO constraints, inline/untyped fields observed in code, guards, roles, response modes, inferred result object variants, explicit exceptions, and controller-to-service source mappings.

The backend has no generated Swagger/OpenAPI contract. Some handlers and services use Promise\<any\>, database records, or dynamically assembled objects. For those routes this manual reports the concrete fields visible in source, the declared return type, and the implementation line; it does not invent fields that the source does not guarantee.

## Contents

[How to Use This Reference](#how-to-use-this-reference)

[Global HTTP Contract](#global-http-contract)

[Authentication and Authorization](#authentication-and-authorization)

[Pagination, Time, Uploads, and Streaming](#pagination-time-uploads-and-streaming)

[HTTP Endpoint Reference](#http-endpoint-reference)

[Auth APIs (15)](#auth-apis)

[Demo APIs (63)](#demo-apis)

[Superadmin APIs (162)](#superadmin-apis)

[Admin APIs (167)](#admin-apis)

[User APIs (126)](#user-apis)

[Public and Shared APIs (19)](#public-and-shared-apis)

[Public Tracking APIs (7)](#public-tracking-apis)

[Geocoding APIs (3)](#geocoding-apis)

[Feedback APIs (2)](#feedback-apis)

[Agent Orchestration APIs (3)](#agent-orchestration-apis)

[Webhooks APIs (2)](#webhooks-apis)

[Internal Ingestion APIs (2)](#internal-ingestion-apis)

[Health and Operations APIs (19)](#health-and-operations-apis)

[Realtime Socket.IO Contract](#realtime-socket.io-contract)

[DTO and Response Schema Catalog](#dto-and-response-schema-catalog)

[Complete Route Coverage Ledger](#complete-route-coverage-ledger)

## How to Use This Reference

Start with the role section that matches the client being built. Use each API ID when discussing defects or contract changes. Request lines identify path, query, header, and body inputs; DTO names link conceptually to the complete schema catalog. Response lines describe the handler result before or instead of the global wrapper, depending on response mode.

| **Notation** | **Meaning** |
| --- | --- |
| field | Required field. |
| field? | Optional field. |
| :id | Path parameter supplied in the URL. |
| Bearer JWT | Authorization: Bearer \<access-token\>. |
| HeaderId | Internal identity derived from JWT; never a client header. |
| Global envelope | ResponseInterceptor wraps the handler result in status/data/timestamp. |
| Raw response | Controller writes or streams directly; no global success envelope. |
| Observed fields | The code accesses these fields but does not enforce a class-validator DTO. |

## Global HTTP Contract

| **Property** | **Source-backed contract** |
| --- | --- |
| Default origin | http://\<backend-host\>:3001 |
| Global path prefix | None. Use route paths exactly as documented. |
| Route versioning | No /v1 prefix. GET /version reports application API version 2.6.0. |
| CORS | Origin reflected/allowed; credentials enabled; GET, PUT, POST, DELETE, OPTIONS, PATCH, HEAD. |
| JSON validation | Whitelist, reject non-whitelisted fields, transform values, implicit type conversion. |
| Default request content | application/json when a body DTO is present. |
| Default success status | 200 unless an endpoint declares another code. |
| Idempotency | No global idempotency-key middleware was detected. |

### Success Envelope

For normal JSON handlers the global response interceptor preserves the HTTP status and wraps the handler result as follows:

``` json
{
  "status": "success",
  "data": <handler result>,
  "timestamp": "2026-07-27T00:00:00.000Z"
}
```

Many services return an additional business object such as { action, message, data }. A business-level action:false may therefore still arrive inside an HTTP 2xx global success envelope. Clients must evaluate both HTTP status and the handler result when action is present.

### Errors

``` json
{
  "statusCode": 400,
  "message": ["field must be ..."],
  "error": "Bad Request"
}
```

| **HTTP** | **When to expect it** |
| --- | --- |
| 400 | DTO validation, malformed inputs, invalid ranges, unsupported values, or explicit BadRequestException. |
| 401 | Missing/invalid/expired/revoked token, inactive account, refresh-token failure, or role-guard mismatch. |
| 403 | Explicit ForbiddenException or an authorization rule implemented by a service. |
| 404 | Entity or configuration not found. |
| 409 | Uniqueness/conflict checks such as duplicate inventory, SIM, plan, or assignment records. |
| 413 | Multipart limits exceeded; global file limit is 5 MiB and at most five files. |
| 500 | Unhandled backend/infrastructure failure. |

## Authentication and Authorization

| **Role / mode** | **Scope** |
| --- | --- |
| Public | No bearer token is required. Apply normal abuse controls at the edge. |
| SUPERADMIN | Platform-wide administration, infrastructure, integration, and tenant control. |
| ADMIN | Tenant administrator; data is scoped to the authenticated administrator. |
| USER | Fleet customer account; data is scoped to the authenticated user. |
| SUBUSER | Delegated user identity used by shared geocoding/realtime authorization paths. |
| TEAM | Team-scoped identity supported by shared geocoding/realtime authorization paths. |
| DRIVER | Driver identity supported by shared geocoding/realtime authorization paths. |
| Listener secret | Internal ingestion caller authenticated by the exact x-listener-secret header. |

Access tokens use the JWT secret and default to 24 hours unless JWT_EXPIRES_IN overrides the configuration. Refresh tokens expire after seven days. Both contain sub, userId, role, authVersion, and tokenUse. Protected HTTP calls require tokenUse=access; POST /auth/refresh-token requires tokenUse=refresh.

The JWT strategy rechecks that the account exists, remains active, and has the same authVersion. Password/session security changes can therefore revoke outstanding tokens. Role enforcement is performed after JWT validation. The current RolesGuard reports role mismatch as unauthorized.

``` text
Authorization: Bearer <access-token>
```

Demo HTTP routes are public and read-only GET routes backed by the demo dataset. Internal ingestion routes are not public: they require the exact x-listener-secret value configured by LISTNER_KEY.

## Pagination, Time, Uploads, and Streaming

| **Pattern** | **Contract** |
| --- | --- |
| page + limit | Numbered paging. Use response metadata/total fields exposed by that endpoint; do not infer total from page length. |
| cursor / nextCursor | Opaque forward cursor. Send the returned value unchanged; reports use an opaque base64url cursor. |
| cursorId | Numeric keyset cursor used by activity/command-style feeds. |
| beforeId | Reverse keyset cursor used by selected log/event feeds. |
| from / to | Usually ISO-8601 timestamps. Apply the endpoint DTO and maximum range; report rules are listed separately. |
| timeZone | Use a valid IANA timezone where required by reports; server timestamps are ISO-8601. |

Global multipart limits are 5 MiB per file, 5 files, and 20 text fields. Endpoint-level rules may be stricter. Support attachments accept attachments or attachments\[\]; profile/branding/document routes use named file parts described by their request fields.

Document upload code permits PDF, JPEG/JPG, PNG, WebP, DOC, and DOCX and blocks unsafe extensions including SVG, HTML, JavaScript, and executable files. Branding routes accept the specific logo/favicon aliases documented by the implementation.

### Direct and Streaming Responses

The following routes write directly to Fastify or stream content. Consumers must not expect the global status/data/timestamp envelope.

| **Method** | **Path** | **Response** | **Access** |
| --- | --- | --- | --- |
| GET | /admin/driverbulkjobs/:id/failed.csv | CSV download (raw response) | Bearer JWT (ADMIN) |
| GET | /admin/driverbulkjobs/:id/stream | SSE (text/event-stream; raw response) | Bearer JWT (ADMIN) |
| GET | /admin/inventorybulkjobs/:id/failed.csv | CSV download (raw response) | Bearer JWT (ADMIN) |
| GET | /admin/inventorybulkjobs/:id/stream | SSE (text/event-stream; raw response) | Bearer JWT (ADMIN) |
| GET | /admin/userbulkjobs/:id/failed.csv | CSV download (raw response) | Bearer JWT (ADMIN) |
| GET | /admin/userbulkjobs/:id/stream | SSE (text/event-stream; raw response) | Bearer JWT (ADMIN) |
| GET | /admin/vehiclebulkjobs/:id/failed.csv | CSV download (raw response) | Bearer JWT (ADMIN) |
| GET | /admin/vehiclebulkjobs/:id/stream | SSE (text/event-stream; raw response) | Bearer JWT (ADMIN) |
| GET | /admin/vehicles/by-imei/:imei/events/export | CSV download (raw response) | Bearer JWT (ADMIN) |
| GET | /admin/vehicles/by-imei/:imei/logs/export | CSV download (raw response) | Bearer JWT (ADMIN) |
| GET | /unsubscribe | HTML document (raw response) | Public |
| GET | /superadmin/server/jobs/:id/stream | SSE (text/event-stream; raw response) | Bearer JWT (SUPERADMIN) |
| GET | /superadmin/ssl/jobs/:jobId/stream | SSE (text/event-stream; raw response) | Public |
| GET | /user/landmarkbulkjobs/:id/failed.csv | CSV download (raw response) | Bearer JWT (ADMIN, USER) |
| GET | /user/landmarkbulkjobs/:id/stream | SSE (text/event-stream; raw response) | Bearer JWT (ADMIN, USER) |
| GET | /webhooks/whatsapp | Raw Fastify response | Public |
| POST | /webhooks/whatsapp | Raw Fastify response | Public |

## HTTP Endpoint Reference

The following role-organized reference contains all 590 unique controller routes. IDs are documentation identifiers; they are not part of the URL.

## Auth APIs

15 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Google Sign-In (2)

#### AUTH-001 **GET /auth/google/client-id**

Public endpoint: returns the Google OAuth Client ID from the active GOOGLE_OAUTH SSO integration so the frontend can initialise Google Identity Services.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: false, message: "Google SSO is not configured."} | {action: false, message: "Google SSO is currently disabled."} | {action: false, message: "Google SSO Client ID is not configured."} | {action: true, message: "Google Client ID retrieved.", data: {clientId: \<clientId\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:71 (AuthController.getGoogleClientId) → src/auth/services/auth.service.ts:432 (AuthService.getGoogleClientId)

#### AUTH-002 **POST /auth/google/login**

Exchange a Google authorization code (from the GIS popup flow) for a JWT. Login only — if no user exists with the Google email, an error is returned.

Access Public · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · GoogleLoginDto · required · schema GoogleLoginDto \[src/auth/dto/google-login.dto.ts\] · fields code: string

**Response:** Global success envelope; typed result AuthResponseDto; observed result variants {action: false, message: \<\`No account found for \${googleEmail}. Please contact your administrator to create an account first.\`\>}

**Errors:** HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/auth/controllers/auth.controller.ts:81 (AuthController.googleLogin) → src/auth/services/auth.service.ts:465 (AuthService.googleLogin)

### Password Recovery (2)

#### AUTH-003 **POST /auth/forgot-password**

Request a password-reset email.

Access Public · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · ForgotPasswordDto · required · schema ForgotPasswordDto \[src/auth/dto/forgot-password.dto.ts\] · fields identifier: string

**Response:** Global success envelope; observed result variants {action: true, message: \<genericMessage\>} | {action: false, message: "Password reset email could not be sent. Please try again later.", data: {code: "EMAIL_DELIVERY_FAILED"}} | {action: false, message: "SMTP is not configured. Please configure SMTP before sending password reset emails.", data: {code: "SMTP_NOT_CONFIGURED"}} | {action: false, message: "Password reset email could not be sent. Please try again later.", data: {code: \<outcomeCode ?? 'EMAIL_DELIVERY_FAILED'\>}}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/auth/controllers/auth.controller.ts:52 (AuthController.forgotPassword) → src/auth/services/auth.service.ts:1210 (AuthService.forgotPassword)

#### AUTH-004 **POST /auth/reset-password**

Reset a user's password using a valid reset token.

Access Public · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · ResetPasswordDto · required · schema ResetPasswordDto \[src/auth/dto/reset-password.dto.ts\] · fields token: string; newPassword: string

**Response:** Global success envelope; observed result variants {action: true, message: "Password has been reset successfully. You can now sign in with your new password."}

**Errors:** HttpException; Error; UnauthorizedException — Invalid user identity. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/auth/controllers/auth.controller.ts:58 (AuthController.resetPassword) → src/auth/services/auth.service.ts:1328 (AuthService.resetPassword)

### Platform Bootstrap (2)

#### AUTH-005 **GET /auth/checksadmin**

Get Checks Admin

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Super Admin exists"} | {action: false, message: "Super Admin does not exist"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:22 (AuthController.getChecksAdmin) → src/auth/services/auth.service.ts:78 (AuthService.getChecksAdmin)

#### AUTH-006 **POST /auth/createsuperadmin**

Create Super Admin

Access Public · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body superadminDto · CreateSuperAdminDto · required · schema CreateSuperAdminDto \[src/auth/dto/superadmin.dto.ts\] · fields name: string; email: string; mobilePrefix: string; mobileNumber: string; username: string; password: string; companyName: string; website?: string; address: string; country: string; state: string; city: string; pincode?: string

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:28 (AuthController.createSuperAdmin) → src/auth/services/auth.service.ts:91 (AuthService.createSuperAdmin)

### Push and Client Configuration (6)

#### AUTH-007 **GET /auth/fcm-mobile-config**

Returns the Firebase app config for future Android/iOS clients. Only non-secret Firebase options from publicConfig are exposed.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query platform · 'android' | 'ios' · required

**Response:** Global success envelope; observed result variants {action: false, message: "platform must be android or ios"} | {action: false, message: "No active FCM integration configured."} | {action: false, message: \<result.message ?? \`FCM \${normalizedPlatform} app config not set\`\>} | {action: true, message: "FCM mobile config retrieved.", data: {platform: \<normalizedPlatform\>, firebaseOptions: \<result.firebaseOptions\>, configVersion: \<configVersion\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:93 (AuthController.getFcmMobileConfig) → src/auth/services/auth.service.ts:844 (AuthService.getFcmMobileConfig)

#### AUTH-008 **GET /auth/fcm-web-config**

Returns the FCM web push public config (webConfig + webVapidKey) from the active FCM integration. This is safe to expose publicly since Firebase web config is not a secret.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: false, message: "No active FCM integration configured."} | {action: false, message: "FCM web push config not set."} | {action: true, message: "FCM web config retrieved.", data: {webConfig: \<webConfig\>, webVapidKey: \<webVapidKey\>, configVersion: \<configVersion\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:88 (AuthController.getFcmWebConfig) → src/auth/services/auth.service.ts:811 (AuthService.getFcmWebConfig)

#### AUTH-009 **POST /auth/push-test**

Send a test push to the authenticated user's latest active token(s).

Access Bearer JWT (any authenticated role) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · TestPushDto · required · schema TestPushDto \[src/auth/dto/push-token.dto.ts\] · fields title?: string; body?: string; platform?: PushTokenPlatformFilter

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Push notifications are not configured. Please contact your administrator."} | {action: false, message: "Failed to initialise notification service."} | {action: false, message: "No active FCM secret found."} | {action: false, message: "FCM integration is missing projectId."} | {action: false, message: \<\`No active \${targetLabel} push token registered. Enable notifications and re-login.\`\>} | {action: false, message: conditional, data: {sent: \<sent\>, failed: \<failed\>, deactivated: \<deactivated\>, platform: \<platform\>}} | {action: true, message: \<\`Test notification sent to \${sent} \${targetLabel} device(s).\${failed \> 0 ? \` \${failed} failed (\${deactivated} deactivated).\` : ''}\`\>, data: {sent: \<sent\>, failed: \<failed\>, deactivated: \<deactivated\>, platform: \<platform\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:127 (AuthController.testPush) → src/auth/services/auth.service.ts:999 (AuthService.testPushToMe)

#### AUTH-010 **DELETE /auth/push-token**

Remove / deactivate push token(s) for the authenticated user. Accepts either a specific \`token\` or a \`deviceId\` to deactivate all tokens for that device.

Access Bearer JWT (any authenticated role) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · RemovePushTokenDto · required · schema RemovePushTokenDto \[src/auth/dto/push-token.dto.ts\] · fields token?: string; deviceId?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Push token removed"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:108 (AuthController.removePushToken) → src/auth/services/auth.service.ts:914 (AuthService.removePushToken)

#### AUTH-011 **POST /auth/push-token**

Register or refresh a push token for the authenticated user. Upserts by unique \`token\` value.

Access Bearer JWT (any authenticated role) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · RegisterPushTokenDto · required · schema RegisterPushTokenDto \[src/auth/dto/push-token.dto.ts\] · fields token: string; platform?: string = 'web'; deviceId?: string; userAgent?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Push token registered"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:98 (AuthController.registerPushToken) → src/auth/services/auth.service.ts:880 (AuthService.registerPushToken)

#### AUTH-012 **GET /auth/push-tokens/me**

List the authenticated user's active push tokens by platform group.

Access Bearer JWT (any authenticated role) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · PushTokensQueryDto · required · schema PushTokensQueryDto \[src/auth/dto/push-token.dto.ts\] · fields platform?: PushTokenPlatformFilter

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: \<\`Found \${safeTokens.length} active web token(s).\`\>, data: \<safeTokens\>} | {action: true, message: \<\`Found \${safeTokens.length} active push token(s).\`\>, data: {tokens: \<safeTokens\>, counts: \<counts\>, platform: \<normalizedPlatform\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/auth/controllers/auth.controller.ts:118 (AuthController.getMyPushTokens) → src/auth/services/auth.service.ts:949 (AuthService.getMyPushTokens)

### Session and Login (3)

#### AUTH-013 **POST /auth/email-test**

Send a test email to the authenticated user’s verified address.

Access Bearer JWT (any authenticated role) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · TestEmailDto · required · schema TestEmailDto \[src/auth/dto/email-test.dto.ts\] · fields subject?: string; body?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found."} | {action: false, message: "Your email address is not verified. Please verify it first."} | {action: true, message: "Test email sent successfully.", data: {messageId: \<result.messageId\>, resolvedVia: \<result.smtpResolvedVia\>}} | {action: false, message: conditional, data: {code: \<code ?? 'SMTP_SEND_FAILED'\>}}

**Errors:** Error — EMAIL_SEND_MISSING_SUBJECT; Error — EMAIL_SEND_MISSING_BODY. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/auth/controllers/auth.controller.ts:137 (AuthController.testEmail) → src/auth/services/auth.service.ts:1128 (AuthService.testEmailToMe)

#### AUTH-014 **POST /auth/login**

Login

Access Public · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body loginDto · LoginDto · required · schema LoginDto \[src/auth/dto/login.dto.ts\] · fields identifier: string; password: string

**Response:** Global success envelope; typed result AuthResponseDto; observed result variants {action: false, message: "Invalid username or password"}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/auth/controllers/auth.controller.ts:38 (AuthController.login) → src/auth/services/auth.service.ts:212 (AuthService.login)

#### AUTH-015 **POST /auth/refresh-token**

Refresh Token

Access Public · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · RefreshTokenDto · required · schema RefreshTokenDto \[src/auth/dto/refresh-token.dto.ts\] · fields refresh_token: string

**Response:** Global success envelope; typed result AuthResponseDto; observed result variants {...: spread, message: "Token refreshed successfully"}

**Errors:** UnauthorizedException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/auth/controllers/auth.controller.ts:44 (AuthController.refreshToken) → src/auth/services/auth.service.ts:336 (AuthService.refreshToken)

## Demo APIs

63 source-backed HTTP routes. These routes expose a public, read-only demo experience and do not create a production JWT. Each handler result uses {action, message, data} and is then placed inside the normal global success envelope.

### Company and Branding (1)

#### DEMO-001 **GET /demo/companydetails**

Get Company Details

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:34 (DemoController.getCompanyDetails) → src/demo/demo.service.ts:41 (DemoService.getCompanyDetails)

### Dashboard (9)

#### DEMO-002 **GET /demo/dashboard/day-night-comparison**

Get Day Night Comparison

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {filter: {mode: conditional, vehicleId: conditional}, range: {from: \<new Date(addLocalDaysUtcMs(todayStart, -6, timeContext.offsetMinutes)).toISOString\>, to: \<new Date(todayStart).toISOString\>}, dayWindow: {startHour: 6, endHour: 18, label: "Day (6am-6pm)"}, points: \<points\>, totals: \<totals\>, percentages: {dayDrivenKm: \<pct\>, nightDrivenKm: \<pct\>, dayEngineHours: \<pct\>, nightEngineHours: \<pct\>}, timezone: {id: \<timeContext.id\>, offsetMinutes: \<timeContext.offsetMinutes\>, offset: \<timeContext.offset\>, source: \<timeContext.source\>}, updatedAt: \<new Date().toISOString\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:234 (DemoController.getDayNightComparison) → src/demo/demo.service.ts:393 (DemoService.getDayNightComparison)

#### DEMO-003 **GET /demo/dashboard/fleet-status**

Get Fleet Status

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {totalVehicles: \<total\>, withDevice: \<withDevice\>, noDevice: \<noDevice\>, running: \<running\>, idle: \<idle\>, stopped: \<stopped\>, inactive: \<inactive\>, noData: \<noData\>, distanceTodayKm: \<distanceTodayKm\>, engineHoursToday: \<engineHoursToday\>, alerts: \<alerts\>, utilizationPct: \<utilizationPct\>, buckets: {total: \<total\>, connected: \<withDevice\>, running: \<running\>, idle: \<idle\>, stopped: \<stopped\>, inactive: \<inactive\>, noData: \<noData\>}, percentages: {running: conditional, idle: conditional, stopped: conditional, inactive: conditional, noData: conditional, connected: conditional, noDevice: 0}, updatedAt: \<new Date().toISOString\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:203 (DemoController.getFleetStatus) → src/demo/demo.service.ts:119 (DemoService.getFleetStatus)

#### DEMO-004 **GET /demo/dashboard/recent-alerts**

Get Recent Alerts

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields limit, vehicleId · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {filter: {mode: conditional, vehicleId: conditional}, limit: \<limit\>, nextCursor: conditional, items: \<items\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:218 (DemoController.getRecentAlerts) → src/demo/demo.service.ts:297 (DemoService.getRecentAlerts)

#### DEMO-005 **GET /demo/dashboard/recent-alerts/:id**

Get Recent Alert Detail

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {id: \<alert.id\>, vehicleId: \<alert.vehicleId\>, vehicleName: \<alert.vehicleName\>, plateNumber: null, imei: \<alert.imei\>, source: \<alert.type\>, severity: \<alert.severity\>, title: \<alert.title\>, message: \<alert.message || null\>, meta: conditional, isRead: false, createdAt: \<alert.timestamp\>, deliveries: \[{id: \<\`\${alert.id}-sms\`\>, channel: "SMS", status: "delivered", sentAt: \<alert.timestamp\>, deliveredAt: \<new Date(Date.parse(alert.timestamp) + 1000).toISOString\>}\]}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:223 (DemoController.getRecentAlertDetail) → src/demo/demo.service.ts:328 (DemoService.getRecentAlertDetail)

#### DEMO-006 **GET /demo/dashboard/top-performing-assets**

Get Top Performing Assets

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields limit · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {range: {from: \<new Date(dayStart).toISOString\>, to: \<new Date(now).toISOString\>}, limit: \<limit\>, items: \<items\>, timezone: {id: \<timeContext.id\>, offsetMinutes: \<timeContext.offsetMinutes\>, offset: \<timeContext.offset\>, source: \<timeContext.source\>}, updatedAt: \<new Date().toISOString\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:229 (DemoController.getTopPerformingAssets) → src/demo/demo.service.ts:358 (DemoService.getTopPerformingAssets)

#### DEMO-007 **GET /demo/dashboard/usage-last-7-days**

Get Usage Last7 Days

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {range: {from: \<new Date(addLocalDaysUtcMs(todayStart, -6, timeContext.offsetMinutes)).toISOString\>, to: \<new Date(now).toISOString\>}, filter: {mode: conditional, vehicleId: conditional}, days: \<days\>, points: \<days\>, totals: {drivenKm: \<this.round1\>, engineHours: \<this.round1\>}, timezone: {id: \<timeContext.id\>, offsetMinutes: \<timeContext.offsetMinutes\>, offset: \<timeContext.offset\>, source: \<timeContext.source\>}, updatedAt: \<new Date().toISOString\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:208 (DemoController.getUsageLast7Days) → src/demo/demo.service.ts:169 (DemoService.getUsageLast7Days)

#### DEMO-008 **GET /demo/dashboard/weekly-comparison**

Get Weekly Comparison

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {filter: {mode: conditional, vehicleId: conditional}, week: {thisWeek: {from: \<new Date(thisWeekStart).toISOString\>, to: \<new Date(todayStart).toISOString\>}, lastWeek: {from: \<new Date(lastWeekStart).toISOString\>, to: \<new Date(lastWeekEnd).toISOString\>}, weekStart: \<new Date(thisWeekStart).toISOString\>}, points: \<points\>, totals: \<totals\>, timezone: {id: \<timeContext.id\>, offsetMinutes: \<timeContext.offsetMinutes\>, offset: \<timeContext.offset\>, source: \<timeContext.source\>}, updatedAt: \<new Date().toISOString\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:213 (DemoController.getWeeklyComparison) → src/demo/demo.service.ts:226 (DemoService.getWeeklyComparison)

#### DEMO-009 **GET /demo/dashboards**

Get Dashboards

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:192 (DemoController.getDashboards) → src/demo/demo.service.ts:546 (DemoService.getDashboards)

#### DEMO-010 **GET /demo/dashboards/:id**

Get Dashboard

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:197 (DemoController.getDashboard) → src/demo/demo.service.ts:550 (DemoService.getDashboard)

### Device Commands (3)

#### DEMO-011 **GET /demo/commands/:cmdId**

Get Command Log

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required

**Response:** Global success envelope; observed result variants conditional | null | {...: spread, logs: \[{timestamp: \<command.createdAt\>, message: "Command queued in demo history"}, {timestamp: \<command.createdAt\>, message: "Command marked read-only in demo mode"}\]}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:341 (DemoController.getCommandLog) → src/demo/demo.service.ts:790 (DemoService.getCommandLog)

#### DEMO-012 **GET /demo/commands/status/:cmdId**

Get Command Status

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required

**Response:** Global success envelope; observed result variants conditional | null | {cmdId: \<cmdId\>, status: \<command.status ?? 'completed'\>, command: \<command.command ?? null\>, vehicleId: \<command.vehicleId ?? null\>, updatedAt: \<command.createdAt ?? new Date().toISOString()\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:335 (DemoController.getCommandStatus) → src/demo/demo.service.ts:761 (DemoService.getCommandStatus)

#### DEMO-013 **GET /demo/customcommands**

Get Custom Commands

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {commands: \<this.data.getCustomCommands\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:325 (DemoController.getCustomCommands) → src/demo/demo.service.ts:753 (DemoService.getCustomCommands)

### Drivers (4)

#### DEMO-014 **GET /demo/drivers**

Get Drivers

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {drivers: \<this.data.getDrivers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:250 (DemoController.getDrivers) → src/demo/demo.service.ts:679 (DemoService.getDrivers)

#### DEMO-015 **GET /demo/drivers/:id**

Get Driver

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:267 (DemoController.getDriver) → src/demo/demo.service.ts:683 (DemoService.getDriver)

#### DEMO-016 **GET /demo/drivers/:id/documents**

Get Driver Documents

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {driverId: \<id\>, documents: \[{id: \<\`\${id}-license\`\>, name: "Driver License", status: "verified", expiresAt: \<driver.licenseExpiry ?? null\>}, {id: \<\`\${id}-insurance\`\>, name: "Insurance Certificate", status: "verified", expiresAt: "2027-01-31"}\]}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:261 (DemoController.getDriverDocuments) → src/demo/demo.service.ts:705 (DemoService.getDriverDocuments)

#### DEMO-017 **GET /demo/drivers/:id/logs**

Get Driver Logs

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required ; query query · Record\<string, unknown\> · required · observed fields limit · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants conditional | null | {driverId: \<id\>, logs: \<Array.from\>, meta: {limit: \<limit\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:255 (DemoController.getDriverLogs) → src/demo/demo.service.ts:687 (DemoService.getDriverLogs)

### Fleet Catalog (1)

#### DEMO-018 **GET /demo/vehicletypes**

Get Vehicle Types

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle types fetched successfully", data: \<data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:393 (DemoController.getVehicleTypes) → src/demo/demo.service.ts:1220 (DemoService.getVehicleTypesForApi)

### Geofences and Landmarks (4)

#### DEMO-019 **GET /demo/geofences**

Get Geofences

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields q · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {geofences: \<geofences\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:159 (DemoController.getGeofences) → src/demo/demo.service.ts:479 (DemoService.getGeofences)

#### DEMO-020 **GET /demo/geofences/:id**

Get Geofence

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {geofence: \<geofence\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:164 (DemoController.getGeofence) → src/demo/demo.service.ts:495 (DemoService.getGeofence)

#### DEMO-021 **GET /demo/pois**

Get Pois

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields q · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {pois: \<pois\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:170 (DemoController.getPois) → src/demo/demo.service.ts:501 (DemoService.getPois)

#### DEMO-022 **GET /demo/pois/:id**

Get Poi

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {poi: \<poi\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:175 (DemoController.getPoi) → src/demo/demo.service.ts:518 (DemoService.getPoi)

### Live Map and Telemetry (2)

#### DEMO-023 **GET /demo/map-events**

Get Map Events

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields limit · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {items: \<items\>, nextCursor: null, meta: {limit: \<limit\>, total: \<alerts.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:154 (DemoController.getMapEvents) → src/demo/demo.service.ts:95 (DemoService.getMapEvents)

#### DEMO-024 **GET /demo/map-telemetry**

Get Map Telemetry

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:149 (DemoController.getMapTelemetry) → src/demo/demo.service.ts:91 (DemoService.getMapTelemetry)

### Notifications (3)

#### DEMO-025 **GET /demo/notifications**

Get Notifications

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields limit, page · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {notifications: \<notifications\>, unreadCount: \<allNotifications.filter((notification) =\> notification\['read'\] === false).length\>, meta: {page: \<page\>, limit: \<limit\>, total: \<allNotifications.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:315 (DemoController.getNotifications) → src/demo/demo.service.ts:618 (DemoService.getNotifications)

#### DEMO-026 **GET /demo/notifications/preferences**

Get Notification Preferences

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:305 (DemoController.getNotificationPreferences) → src/demo/demo.service.ts:659 (DemoService.getNotificationPreferences)

#### DEMO-027 **GET /demo/notifications/vehicle**

Get Vehicle Notifications

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields limit, page, vehicleId · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {notifications: \<allNotifications.slice\>, unreadCount: \<allNotifications.filter((notification) =\> notification\['read'\] === false).length\>, meta: {page: \<page\>, limit: \<limit\>, total: \<allNotifications.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:310 (DemoController.getVehicleNotifications) → src/demo/demo.service.ts:636 (DemoService.getVehicleNotifications)

### Pricing and Billing (1)

#### DEMO-028 **GET /demo/transactions**

Get Transactions

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:300 (DemoController.getTransactions) → src/demo/demo.service.ts:749 (DemoService.getTransactions)

### Profile and Security (1)

#### DEMO-029 **GET /demo/profile**

Get Profile

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:29 (DemoController.getProfile) → src/demo/demo.service.ts:37 (DemoService.getProfile)

### Reports (4)

#### DEMO-030 **GET /demo/reports/alerts**

Get Alerts Report

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {rows: \<this.resolveAlerts\>, summary: {critical: \<this.resolveAlerts(query).filter((alert) =\> alert.severity === 'critical').length\>, warning: \<this.resolveAlerts(query).filter((alert) =\> alert.severity === 'warning').length\>, info: \<this.resolveAlerts(query).filter((alert) =\> alert.severity === 'info').length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:362 (DemoController.getAlertsReport) → src/demo/demo.service.ts:607 (DemoService.getAlertsReport)

#### DEMO-031 **GET /demo/reports/daily**

Get Daily Report

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields from, to · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {rows: \<this.history.buildDailyRows\>, meta: {...: spread, timezone: {id: \<timeContext.id\>, offsetMinutes: \<timeContext.offsetMinutes\>, offset: \<timeContext.offset\>, source: \<timeContext.source\>}}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:352 (DemoController.getDailyReport) → src/demo/demo.service.ts:562 (DemoService.getDailyReport)

#### DEMO-032 **GET /demo/reports/stoppages**

Get Stoppage Report

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {rows: \<rows.slice\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:357 (DemoController.getStoppageReport) → src/demo/demo.service.ts:582 (DemoService.getStoppageReport)

#### DEMO-033 **GET /demo/reports/summary**

Get Report Summary

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {...: spread, fleetStatus: \<this.getFleetStatus\>, generatedAt: \<new Date().toISOString\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:347 (DemoController.getReportSummary) → src/demo/demo.service.ts:554 (DemoService.getReportSummary)

### Routes and Optimization (3)

#### DEMO-034 **GET /demo/route-optimization**

Get Route Optimization

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:320 (DemoController.getRouteOptimization) → src/demo/demo.service.ts:745 (DemoService.getRouteOptimization)

#### DEMO-035 **GET /demo/routes**

Get Routes

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · Record\<string, unknown\> · required · observed fields q · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {routes: \<routes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:181 (DemoController.getRoutes) → src/demo/demo.service.ts:524 (DemoService.getRoutes)

#### DEMO-036 **GET /demo/routes/:id**

Get Route

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {route: \<route\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:186 (DemoController.getRoute) → src/demo/demo.service.ts:540 (DemoService.getRoute)

### Session and Configuration (3)

#### DEMO-037 **GET /demo/accounts**

Get Accounts

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:290 (DemoController.getAccounts) → src/demo/demo.service.ts:675 (DemoService.getAccounts)

#### DEMO-038 **GET /demo/health**

Get Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {ok: true, source: "json", mode: "public-demo", manifest: \<this.data.getManifest\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:19 (DemoController.getHealth) → src/demo/demo.service.ts:28 (DemoService.getHealth)

#### DEMO-039 **GET /demo/session**

Get Session

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:24 (DemoController.getSession) → src/demo/demo.service.ts:24 (DemoService.getSession)

### Settings and Localization (3)

#### DEMO-040 **GET /demo/localization**

Get Localization

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:39 (DemoController.getLocalization) → src/demo/demo.service.ts:45 (DemoService.getLocalization)

#### DEMO-041 **GET /demo/systemvariables**

Get System Variables

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {variables: \<this.data.getSystemVariables\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:330 (DemoController.getSystemVariables) → src/demo/demo.service.ts:757 (DemoService.getSystemVariables)

#### DEMO-042 **GET /demo/timezones**

Get Timezones

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Timezones fetched successfully", data: \<data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:403 (DemoController.getTimezones) → src/demo/demo.service.ts:1224 (DemoService.getTimezonesForApi)

### Sharing (2)

#### DEMO-043 **GET /demo/share-track-links**

Get Share Track Links

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {links: \<this.data.getShareTrackLinks\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:239 (DemoController.getShareTrackLinks) → src/demo/demo.service.ts:663 (DemoService.getShareTrackLinks)

#### DEMO-044 **GET /demo/share-track-links/:id**

Get Share Track Link

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:244 (DemoController.getShareTrackLink) → src/demo/demo.service.ts:667 (DemoService.getShareTrackLink)

### Subusers (3)

#### DEMO-045 **GET /demo/subusers**

Get Subusers

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {subusers: \<this.data.getSubusers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:273 (DemoController.getSubusers) → src/demo/demo.service.ts:728 (DemoService.getSubusers)

#### DEMO-046 **GET /demo/subusers/:id**

Get Subuser

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:284 (DemoController.getSubuser) → src/demo/demo.service.ts:732 (DemoService.getSubuser)

#### DEMO-047 **GET /demo/subusers/:id/vehicles**

Get Subuser Vehicles

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {subuserId: \<id\>, vehicles: \<vehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:278 (DemoController.getSubuserVehicles) → src/demo/demo.service.ts:736 (DemoService.getSubuserVehicles)

### Support Tickets (1)

#### DEMO-048 **GET /demo/support-tickets**

Get Support Tickets

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {tickets: \<this.data.getSupportTickets\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:295 (DemoController.getSupportTickets) → src/demo/demo.service.ts:671 (DemoService.getSupportTickets)

### Vehicles (15)

#### DEMO-049 **GET /demo/vehicles**

Get Vehicles

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles fetched successfully", data: {vehicles: \<vehicles\>}} | \<vehicles.map\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:44 (DemoController.getVehicles) → src/demo/demo.service.ts:1063 (DemoService.getVehiclesForApi)

#### DEMO-050 **GET /demo/vehicles/:id**

Get Vehicle

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {id: \<vehicle.id\>, name: \<vehicle.name\>, vin: \<vehicle.vin\>, plateNumber: \<vehicle.plateNumber\>, isActive: \<vehicle.isActive\>, createdAt: \<vehicle.createdAt\>, imei: \<vehicle.imei\>, simNumber: \<vehicle.simNumber\>, vehicleType: \<vehicle.vehicleType\>, vehicleMeta: \<vehicle.vehicleMeta\>, gmtOffset: \<vehicle.gmtOffset\>, device: {id: \<vehicle.deviceInfo?.id\>, imei: \<vehicle.deviceInfo?.imei\>, speedVariation: \<vehicle.deviceInfo?.speedVariation\>, distanceVariation: \<vehicle.deviceInfo?.distanceVariation\>, odometer: \<vehicle.deviceInfo?.odometer\>, engineHours: \<vehicle.deviceInfo?.engineHours\>, ignitionSource: \<vehicle.deviceInfo?.ignitionSource\>, liveOdometer: \<vehicle.deviceInfo?.liveOdometer\>, liveEngineHours: \<vehicle.deviceInfo?.liveEngineHours\>}, plan: \<vehicle.plan\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:113 (DemoController.getVehicle) → src/demo/demo.service.ts:1087 (DemoService.getVehicleForApi)

#### DEMO-051 **GET /demo/vehicles/:id/documents**

Get Vehicle Documents

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle documents fetched successfully", data: \<documents\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:367 (DemoController.getVehicleDocuments) → src/demo/demo.service.ts:1118 (DemoService.getVehicleDocumentsForApi)

#### DEMO-052 **GET /demo/vehicles/:id/sensors**

Get Vehicle Sensors By Id

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required ; query query · Record\<string, unknown\> · required · observed fields includeLive, limit, page · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<sensorData\>} | {items: \[\], page: 1, limit: 50, total: 0, telemetryMeta: {}} | {items: \<paginatedSensors\>, page: \<page\>, limit: \<limit\>, total: \<sensors.length\>, telemetryMeta: {imei: \<vehicle.imei\>, serverTime: \<new Date().toISOString\>, deviceTime: \<new Date().toISOString\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:129 (DemoController.getVehicleSensorsById) → src/demo/demo.service.ts:1122 (DemoService.getVehicleSensorsForApi)

#### DEMO-053 **GET /demo/vehicles/:id/sensors/:sensorId/history**

Get Sensor History

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required ; param sensorId · string · required ; query query · Record\<string, unknown\> · required · observed fields maxPoints · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: string, data: \<demo payload\>} | {supported: false, sensor: null, range: {from: "", to: ""}, sampling: {bucketSec: 0, returnedPoints: 0, errorCount: 0}, points: \[\], stats: {min: null, max: null, avg: null, first: null, last: null}} | {supported: true, sensor: \<sensor\>, range: {from: \<new Date(now - 24 \* 60 \* 60 \* 1000).toISOString\>, to: \<new Date(now).toISOString\>}, sampling: {bucketSec: 3600, returnedPoints: \<points.length\>, errorCount: 0}, points: \<points\>, stats: {min: \<min\>, max: \<max\>, avg: \<avg\>, first: \<first\>, last: \<last\>}, timezone: {id: \<timeContext.id\>, offsetMinutes: \<timeContext.offsetMinutes\>, offset: \<timeContext.offset\>, source: \<timeContext.source\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:139 (DemoController.getSensorHistory) → src/demo/demo.service.ts:984 (DemoService.getSensorHistory)

#### DEMO-054 **GET /demo/vehicles/:id/sensors/telemetry**

Get Vehicle Sensors Telemetry

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {telemetry: \<telemetry\>, imei: \<vehicle.imei\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:377 (DemoController.getVehicleSensorsTelemetry) → src/demo/demo.service.ts:1172 (DemoService.getVehicleSensorsTelemetryForApi)

#### DEMO-055 **GET /demo/vehicles/:id/telemetry**

Get Vehicle Telemetry

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Response:** Global success envelope; observed result variants conditional | null | {vehicleId: \<vehicle.id\>, imei: \<vehicle.imei\>, status: \<snapshot.status\>, telemetry: \<snapshot.telemetry\>, lastUpdatedAt: \<snapshot.lastUpdatedAt\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:107 (DemoController.getVehicleTelemetry) → src/demo/demo.service.ts:77 (DemoService.getVehicleTelemetry)

#### DEMO-056 **GET /demo/vehicles/:vehicleId/commands**

Get Vehicle Commands

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · string · required ; query query · Record\<string, unknown\> · required · observed fields limit · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants conditional | null | {vehicleId: \<vehicleId\>, commands: \<commands\>, meta: {limit: \<limit\>, total: \<commands.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:98 (DemoController.getVehicleCommands) → src/demo/demo.service.ts:774 (DemoService.getVehicleCommands)

#### DEMO-057 **GET /demo/vehicles/by-imei/:imei/details**

Get Vehicle Details

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Response:** Global success envelope; observed result variants conditional | null | {vehicle: {...: spread, routeName: \<routeName\>}, telemetry: \<snapshot.telemetry\>, status: \<snapshot.status\>, driver: \<vehicle.driver\>, device: \<vehicle.device\>, stats: {distanceTodayKm: \<snapshot.telemetry?.distanceToday ?? 0\>, engineHoursToday: \<snapshot.telemetry?.engineHoursToday ?? 0\>, odometerKm: \<snapshot.telemetry?.odometer ?? vehicle.baseOdometerKm\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:56 (DemoController.getVehicleDetails) → src/demo/demo-history.service.ts:26 (DemoHistoryService.getVehicleDetails)

#### DEMO-058 **GET /demo/vehicles/by-imei/:imei/events**

Get Vehicle Events

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · Record\<string, unknown\> · required · observed fields beforeId, limit · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants conditional | null | {events: \<\[...alertEvents, ...generated\].slice\>, meta: {limit: \<limit\>, hasMore: false, beforeId: \<query.beforeId ?? null\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:68 (DemoController.getVehicleEvents) → src/demo/demo-history.service.ts:121 (DemoHistoryService.getEvents)

#### DEMO-059 **GET /demo/vehicles/by-imei/:imei/history**

Get Vehicle History

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · Record\<string, unknown\> · required

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:92 (DemoController.getVehicleHistory) → src/demo/demo-history.service.ts:453 (DemoHistoryService.getHistory)

#### DEMO-060 **GET /demo/vehicles/by-imei/:imei/logs**

Get Vehicle Logs

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · Record\<string, unknown\> · required · observed fields beforeId, limit · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants conditional | null | {items: \<items\>, nextCursor: null, meta: {limit: \<limit\>, hasMore: false, beforeId: \<(query.beforeId as string | null) ?? null\>, source: "telemetry-json"}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:62 (DemoController.getVehicleLogs) → src/demo/demo-history.service.ts:50 (DemoHistoryService.getLogs)

#### DEMO-061 **GET /demo/vehicles/by-imei/:imei/replay**

Get Vehicle Replay

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · Record\<string, unknown\> · required · observed fields maxPoints, stopMin · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:86 (DemoController.getVehicleReplay) → src/demo/demo-history.service.ts:445 (DemoHistoryService.getReplay)

#### DEMO-062 **GET /demo/vehicles/by-imei/:imei/sensors**

Get Vehicle Sensors

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Response:** Global success envelope; observed result variants conditional | null | {vehicle: {id: \<vehicle.id\>, imei: \<vehicle.imei\>}, items: \<items\>, totalCount: \<items.length\>, truncated: false, telemetryMeta: {hasTelemetry: \<Boolean\>, serverTime: \<telemetry?.serverTime ?? null\>, deviceTime: \<telemetry?.deviceTime ?? null\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:74 (DemoController.getVehicleSensors) → src/demo/demo-history.service.ts:164 (DemoHistoryService.getSensors)

#### DEMO-063 **GET /demo/vehicles/by-imei/:imei/trail**

Get Vehicle Trail

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · Record\<string, unknown\> · required · observed fields hours, maxPoints, stopMin · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants conditional

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/demo/demo.controller.ts:80 (DemoController.getVehicleTrail) → src/demo/demo-history.service.ts:436 (DemoHistoryService.getTrail)

## Superadmin APIs

162 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### AI and OpenRouter (1)

#### SA-001 **GET /superadmin/openrouter/models**

Return the full OpenRouter model catalogue using the public API. No API key or integration record is required.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OpenRouter models loaded", data: \<models\>} | {action: false, message: \<\`Failed to load OpenRouter models: \${safeMessage}\`\>, data: \[\]}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:977 (SuperadminController.listOpenRouterModels) → src/superadmin/superadmin.service.ts:6707 (SuperadminService.listOpenRouterModels)

### Administrator Management (10)

#### SA-002 **POST /superadmin/activateadmin/:id**

Activate Admin

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · ActivateAdminDto · required · schema ActivateAdminDto \[src/superadmin/dto/activateadmin.ts\] · fields isActive: boolean

**Response:** Global success envelope; observed result variants {action: true, message: \<\`Admin has been \${isActive ? 'activated' : 'deactivated'} successfully\`\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:154 (SuperadminController.activateAdmin) → src/superadmin/superadmin.service.ts:489 (SuperadminService.activateAdmin)

#### SA-003 **GET /superadmin/admin/:id**

Get Admin By Id

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {message: "Invalid admin ID"} | {action: true, message: "Admin not found"} | {action: true, message: "Admin fetched successfully", data: \<user\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:142 (SuperadminController.getAdminById) → src/superadmin/superadmin.service.ts:427 (SuperadminService.getAdminById)

#### SA-004 **GET /superadmin/admin/:id/activitylogs**

Get Admin Activity Logs

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; query dto · AdminActivityLogsDto · required · schema AdminActivityLogsDto \[src/superadmin/dto/admin-activity-logs.dto.ts\] · fields limit?: number = 20; cursorId?: number; from?: string; to?: string; q?: string; actionPrefix?: string; rk?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Admin not found"} | {action: true, message: "OK", data: {admin: \<admin\>, items: \<items\>, nextCursorId: \<nextCursorId\>, hasMore: \<hasMore\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:665 (SuperadminController.getAdminActivityLogs) → src/superadmin/superadmin.service.ts:3927 (SuperadminService.getAdminActivityLogs)

#### SA-005 **GET /superadmin/adminlist**

Get Admin List

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Admin List Fetched Successfully", data: \<data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:137 (SuperadminController.getAdminList) → src/superadmin/superadmin.service.ts:353 (SuperadminService.getAdminList)

#### SA-006 **GET /superadmin/adminlogin/:id**

Admin Login

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:163 (SuperadminController.adminLogin) → src/superadmin/superadmin.service.ts:501 (SuperadminService.adminLogin)

#### SA-007 **POST /superadmin/adminpasswordupdate**

Update Admin Password

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body adminpasswordupdate · AdminPasswordUpdateDto · required · schema AdminPasswordUpdateDto \[src/superadmin/dto/adminpasswordupdate.dto.ts\] · fields adminid: string; newpassword: string; confirmpassword: string

**Response:** Global success envelope; observed result variants {action: true, message: "Admin password updated successfully"}

**Errors:** UnauthorizedException — Invalid user identity. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:149 (SuperadminController.updateAdminPassword) → src/superadmin/superadmin.service.ts:477 (SuperadminService.updateAdminPassword)

#### SA-008 **GET /superadmin/adminvehicles/:adminId**

Get Admin Vehicles List

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param adminId · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Admin vehicles fetched successfully", data: \<vehicles\>} | {action: false, message: \<error?.message || 'Failed to fetch admin vehicles'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:675 (SuperadminController.getAdminVehiclesList) → src/superadmin/superadmin.service.ts:4084 (SuperadminService.getAdminVehiclesList)

#### SA-009 **POST /superadmin/createadmin**

Create Admin

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body Admindto · CreateAdminDto · required · schema CreateAdminDto \[src/superadmin/dto/admin.dto.ts\] · fields name: string; email?: string; mobilePrefix?: string; mobileNumber?: string; username: string; password: string; companyName: string; address: string; country: string; state: string; city: string; pincode?: string; credits?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Admin with the given username or email already exists"} | \<CurrentAdmin\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:132 (SuperadminController.createAdmin) → src/superadmin/superadmin.service.ts:238 (SuperadminService.createAdmin)

#### SA-010 **DELETE /superadmin/deleteadmin/:id**

Delete Admin

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {message: "Admin not found"} | {message: "Admin deleted successfully"}

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:184 (SuperadminController.deleteAdmin) → src/superadmin/superadmin.service.ts:660 (SuperadminService.deleteAdmin)

#### SA-011 **POST /superadmin/updateadmin/:id**

Update Admin

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body Adminupdatedto · UpdateAdminDto · required · schema UpdateAdminDto \[src/superadmin/dto/updateadmin.dto.ts\] · fields name: string; email?: string; mobilePrefix: string; mobileNumber: string; addressLine: string; countryCode: string; stateCode: string; cityName: string; pincode?: string

**Response:** Global success envelope; observed result variants \<Updatedadmin\>

**Errors:** NotFoundException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:168 (SuperadminController.updateAdmin) → src/superadmin/superadmin.service.ts:512 (SuperadminService.updateAdmin)

### Calendar (3)

#### SA-012 **GET /superadmin/calendar/day**

Get detailed calendar events for a specific day Returns lists of users created, vehicles created, and vehicles expiring

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · CalendarDayDto · required · schema CalendarDayDto \[src/superadmin/dto/calendar.dto.ts\] · fields date: string; types?: string; rk?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Day details fetched successfully", data: \<result\>} | {action: false, message: \<error?.message || 'Failed to fetch day details'\>, data: {date: \<date\>, usersCreated: \[\], vehiclesCreated: \[\], vehiclesExpiry: \[\]}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:719 (SuperadminController.getCalendarDayDetails) → src/superadmin/superadmin.service.ts:4291 (SuperadminService.getCalendarDayDetails)

#### SA-013 **GET /superadmin/calendar/events**

Get calendar events aggregated by date for a given range Returns counts grouped by date and event type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · CalendarRangeDto · required · schema CalendarRangeDto \[src/superadmin/dto/calendar.dto.ts\] · fields from: string; to: string; types?: string; rk?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Calendar events fetched successfully", data: {events: \<events\>}} | {action: false, message: \<error?.message || 'Failed to fetch calendar events'\>, data: {events: \[\]}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:714 (SuperadminController.getCalendarEvents) → src/superadmin/superadmin.service.ts:4213 (SuperadminService.getCalendarEvents)

#### SA-014 **GET /superadmin/calendar/user/:uid**

Get detailed user info for calendar modal display.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param uid · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"} | {action: true, message: "User details fetched successfully", data: {uid: \<user.uid\>, name: \<user.name\>, email: \<user.email\>, phone: \<phone\>, username: \<user.username\>, loginType: \<user.loginType\>, isActive: \<user.isActive\>, createdAt: \<user.createdAt\>, addedByUser: \<user.parent\>}} | {action: false, message: \<error?.message || 'Failed to fetch user details'\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:724 (SuperadminController.getCalendarUserDetails) → src/superadmin/superadmin.service.ts:4391 (SuperadminService.getCalendarUserDetails)

### Commandtypes (4)

#### SA-015 **GET /superadmin/commandtypes**

Get Command Types

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Command Types Fetched Successfully", data: \<commandTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:294 (SuperadminController.getCommandTypes) → src/superadmin/superadmin.service.ts:1766 (SuperadminService.getCommandTypes)

#### SA-016 **POST /superadmin/commandtypes**

Create Command Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body commandTypeDto · any · required · observed fields description, name · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Command Type with the same name or description already exists"} | {action: true, message: "Command Type created successfully", data: \<newCommandType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:298 (SuperadminController.createCommandType) → src/superadmin/superadmin.service.ts:1773 (SuperadminService.createCommandType)

#### SA-017 **DELETE /superadmin/commandtypes/:id**

Delete Command Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Command Type deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:306 (SuperadminController.deleteCommandType) → src/superadmin/superadmin.service.ts:1808 (SuperadminService.deleteCommandType)

#### SA-018 **PATCH /superadmin/commandtypes/:id**

Update Command Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body commandTypeDto · any · required · observed fields description, name · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Command Type not found"} | {action: true, message: "Command Type updated successfully", data: \<updatedCommandType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:302 (SuperadminController.updateCommandType) → src/superadmin/superadmin.service.ts:1792 (SuperadminService.updateCommandType)

### Company and Branding (5)

#### SA-019 **PATCH /superadmin/companydetails**

Update Company Details

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body companyConfig · CompanyDto · required · schema CompanyDto \[src/superadmin/dto/company.dto.ts\] · fields name?: string; websiteUrl?: string; customDomain?: string; socialLinks?: Record\<string, string\>; primaryColor?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {message: "Nothing to update"} | {message: "Company config updated successfully", data: \<updated\>} | {message: "No data provided to create company config"} | {message: "Company config created successfully", data: \<created\>}

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:615 (SuperadminController.updateCompanyDetails) → src/superadmin/superadmin.service.ts:1035 (SuperadminService.updateCompanyConfig)

#### SA-020 **POST /superadmin/upload/:id**

Upload

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Upload:** One file plus type=PROFILE|DARKLOGO|LIGHTLOGO|FAVICON. The superadmin variant targets the administrator identified by :id.

**Response:** Global success envelope; observed result variants {action: false, message: \<error.message || 'Upload failed'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:246 (SuperadminController.upload) → src/superadmin/superadmin.service.ts:1119 (SuperadminService.handleUpload)

#### SA-021 **GET /superadmin/whitelabel**

Get White Label Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:533 (SuperadminController.getWhiteLabelSettings) → src/superadmin/superadmin.service.ts:2535 (SuperadminService.getWhiteLabelSettings)

#### SA-022 **PATCH /superadmin/whitelabel**

Update White Label Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** JSON or multipart. Multipart accepts up to three named logoLight/logoDark/favicon files plus customDomain, logoLightUrl, logoDarkUrl, faviconUrl, and primaryColor fields.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:543 (SuperadminController.updateWhiteLabelSettings) → src/superadmin/superadmin.service.ts:2547 (SuperadminService.updateWhiteLabelSettings)

#### SA-023 **GET /superadmin/whitelabel/inspect**

Inspect White Label Branding

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query host · string · optional

**Response:** Global success envelope; observed result variants {action: true, message: "Branding diagnostics fetched successfully", data: \<this.brandingUpdate.inspectBrandingByHost\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:538 (SuperadminController.inspectWhiteLabelBranding) → src/superadmin/superadmin.service.ts:2539 (SuperadminService.inspectWhiteLabelBranding)

### Credits (2)

#### SA-024 **POST /superadmin/assigncredits/:id**

Assign Credits

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body creditsUpdateDto · CreditsUpdateDto · required · schema CreditsUpdateDto \[src/superadmin/dto/creditassign.dto.ts\] · fields credits: string; activity: string

**Response:** Global success envelope; observed result variants {message: "Invalid activity. Must be ASSIGN or DEDUCT."} | {message: "Admin not found"} | {message: "Insufficient credits to deduct"} | {message: "Credits updated successfully", data: \<Updatedadmin\>}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:174 (SuperadminController.assignCredits) → src/superadmin/superadmin.service.ts:562 (SuperadminService.assignCredits)

#### SA-025 **GET /superadmin/creditlogs/:id**

Get Credit Logs

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Admin not found"} | {action: true, message: "Credit logs fetched successfully", data: \<logs\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:179 (SuperadminController.getCreditLogs) → src/superadmin/superadmin.service.ts:646 (SuperadminService.getCreditLogs)

### Dashboard (6)

#### SA-026 **GET /superadmin/dashboard/activitylogs**

Get Dashboard Activity Logs

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · DashboardActivityLogsDto · required · schema DashboardActivityLogsDto \[src/superadmin/dto/dashboard-activity-logs.dto.ts\] · fields limit?: number = 20; cursorId?: number; actorId?: number; from?: string; to?: string; rk?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Activity logs fetched successfully", data: {items: \<items\>, nextCursorId: \<nextCursorId\>, hasMore: \<hasMore\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:650 (SuperadminController.getDashboardActivityLogs) → src/superadmin/superadmin.service.ts:3867 (SuperadminService.getDashboardActivityLogs)

#### SA-027 **GET /superadmin/dashboard/adoptiongraph**

Get Adoption Graph

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Adoption graph data fetched successfully", data: \<monthlyData\>} | {action: false, message: \<error?.message || 'Failed to fetch adoption graph data'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:659 (SuperadminController.getAdoptionGraph) → src/superadmin/superadmin.service.ts:4002 (SuperadminService.getAdoptionGraphData)

#### SA-028 **GET /superadmin/dashboard/overview**

Get Dashboard Overview

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Dashboard overview fetched successfully", data: {totalCounts: \<totalCounts?.data ?? null\>, recentVehicles: \<recentVehicles?.data ?? \[\]\>, recentUsers: \<recentUsers?.data ?? \[\]\>, adoptionGraph: \<adoptionGraph?.data ?? \[\]\>, latestTransactions: conditional}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:627 (SuperadminController.getDashboardOverview) → src/superadmin/superadmin.service.ts:3713 (SuperadminService.getDashboardOverview)

#### SA-029 **GET /superadmin/dashboard/recentusers**

Get Recent Users

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Recent users fetched successfully", data: \<recentUsers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:639 (SuperadminController.getRecentUsers) → src/superadmin/superadmin.service.ts:3756 (SuperadminService.getRecentUsers)

#### SA-030 **GET /superadmin/dashboard/recentvehicles**

Get Recent Vehicles

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Recent vehicles fetched successfully", data: \<recentVehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:633 (SuperadminController.getRecentVehicles) → src/superadmin/superadmin.service.ts:3736 (SuperadminService.getRecentVehicles)

#### SA-031 **GET /superadmin/dashboard/totalcounts**

Get Total Counts

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Total counts fetched successfully", data: {totalAdmins: \<totalAdmins\>, totalVehicles: \<totalVehicles\>, activeVehicles: \<activeVehicles\>, totalUsers: \<totalUsers\>, licensedCredits: \<licensedCredits\>, usedCredits: \<usedCredits\>, vehicleLiveStatus: \<vehicleLiveStatus\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:644 (SuperadminController.getTotalCounts) → src/superadmin/superadmin.service.ts:3792 (SuperadminService.getTotalCounts)

### Device Commands (6)

#### SA-032 **GET /superadmin/commands/:cmdId**

Get Command Log By Cmd Id

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required · observed fields length · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cmdId", data: null} | {action: false, message: "Command log not found", data: null} | {action: true, message: "Command log retrieved", data: \<serializeDeviceCommandLog\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:1043 (SuperadminController.getCommandLogByCmdId) → src/superadmin/superadmin.service.ts:6986 (SuperadminService.getCommandLogByCmdId)

#### SA-033 **GET /superadmin/commands/status/:cmdId**

Get Command Status

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required · observed fields length · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cmdId", data: null} | {action: false, message: "Command status not found or expired", data: null} | {action: true, message: "Command status retrieved", data: {cmdId: \<cmdId\>, ...: spread}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:1025 (SuperadminController.getCommandStatus) → src/superadmin/superadmin.service.ts:6945 (SuperadminService.getCommandStatus)

#### SA-034 **GET /superadmin/customcommands**

Get Custom Commands

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · CustomCommandsQueryDto · required · schema CustomCommandsQueryDto \[src/superadmin/dto/custom-commands-query.dto.ts\] · fields deviceTypeId?: string; commandTypeId?: string; activeOnly?: string; rk?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Custom Commands Fetched Successfully", data: \<customCommands\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:328 (SuperadminController.getCustomCommands) → src/superadmin/superadmin.service.ts:1864 (SuperadminService.getCustomCommands)

#### SA-035 **POST /superadmin/customcommands**

Create Custom Command

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body customCommandDto · CustomCommandDto · required · schema CustomCommandDto \[src/superadmin/dto/customcommand.dto.ts\] · fields deviceTypeId: number; commandTypeId: number; command: string; isActive?: boolean

**Response:** Global success envelope; observed result variants {action: false, message: "Custom Command already exists for this device type and command type"} | {action: true, message: "Custom Command created successfully", data: \<newCustomCommand\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:332 (SuperadminController.createCustomCommand) → src/superadmin/superadmin.service.ts:1895 (SuperadminService.createCustomCommand)

#### SA-036 **DELETE /superadmin/customcommands/:id**

Delete Custom Command

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Custom Command deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:340 (SuperadminController.deleteCustomCommand) → src/superadmin/superadmin.service.ts:1939 (SuperadminService.deleteCustomCommand)

#### SA-037 **PATCH /superadmin/customcommands/:id**

Update Custom Command

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body customCommandDto · CustomCommandDto · required · schema CustomCommandDto \[src/superadmin/dto/customcommand.dto.ts\] · fields deviceTypeId: number; commandTypeId: number; command: string; isActive?: boolean

**Response:** Global success envelope; observed result variants {action: false, message: "Custom Command not found"} | {action: false, message: "Custom Command already exists for this device type and command type"} | {action: true, message: "Custom Command updated successfully", data: \<updatedCustomCommand\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:336 (SuperadminController.updateCustomCommand) → src/superadmin/superadmin.service.ts:1912 (SuperadminService.updateCustomCommand)

### Devices (1)

#### SA-038 **POST /superadmin/devices/:imei/send-command**

Send Device Command

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param imei · string · required ; body dto · SendDeviceCommandDto · required · schema SendDeviceCommandDto \[src/superadmin/dto/send-device-command.dto.ts\] · fields command: string; note?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: true, message: conditional, data: \<result\>}

**Errors:** NotFoundException; HttpException; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED; command was not dispatched\`; Error — \`Failed to dispatch command \${cmdId} via Redis: \${errorMessage}\`; Error; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED_OFFLINE\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:1016 (SuperadminController.sendDeviceCommand) → src/superadmin/superadmin.service.ts:6896 (SuperadminService.sendDeviceCommandByImei)

### Documents (8)

#### SA-039 **GET /superadmin/documents/:adminId**

Get Documents

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param adminId · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Documents Fetched Successfully", data: \<documents\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:458 (SuperadminController.getDocuments) → src/superadmin/superadmin.service.ts:2181 (SuperadminService.getDocuments)

#### SA-040 **GET /superadmin/documenttypes**

Get Document Types

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Document Types Fetched Successfully", data: \<documentTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:362 (SuperadminController.getDocumentTypes) → src/superadmin/superadmin.service.ts:2000 (SuperadminService.getDocumentTypes)

#### SA-041 **POST /superadmin/documenttypes**

Create Document Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body documentTypeDto · DocumentTypeDto · required · schema DocumentTypeDto \[src/superadmin/dto/documenttype.dto.ts\] · fields name: string; docFor: DocForDto

**Response:** Global success envelope; observed result variants {action: false, message: "Document Type with the same name and docFor already exists"} | {action: true, message: "Document Type created successfully", data: \<newDocumentType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:366 (SuperadminController.createDocumentType) → src/superadmin/superadmin.service.ts:2007 (SuperadminService.createDocumentType)

#### SA-042 **DELETE /superadmin/documenttypes/:id**

Delete Document Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Document Type deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:374 (SuperadminController.deleteDocumentType) → src/superadmin/superadmin.service.ts:2048 (SuperadminService.deleteDocumentType)

#### SA-043 **PATCH /superadmin/documenttypes/:id**

Update Document Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body documentTypeDto · DocumentTypeDto · required · schema DocumentTypeDto \[src/superadmin/dto/documenttype.dto.ts\] · fields name: string; docFor: DocForDto

**Response:** Global success envelope; observed result variants {action: false, message: "Document Type not found"} | {action: false, message: "Document Type with the same name and docFor already exists"} | {action: true, message: "Document Type updated successfully", data: \<updatedDocumentType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:370 (SuperadminController.updateDocumentType) → src/superadmin/superadmin.service.ts:2023 (SuperadminService.updateDocumentType)

#### SA-044 **POST /superadmin/uploaddoc**

Upload Document

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Request must be multipart/form-data' } as any\>

**Errors:** Error — err ?? new Error('Unknown error'). Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:421 (SuperadminController.uploadDocument) → src/superadmin/superadmin.service.ts:1278 (SuperadminService.uploadDocumentMultipart)

#### SA-045 **DELETE /superadmin/uploaddoc/:id**

Delete Document

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: false, message: "Document not found"} | {action: true, message: "Document deleted successfully", data: \<updated\>}

**Errors:** Error — err ?? new Error('Unknown error'). Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:449 (SuperadminController.deleteDocument) → src/superadmin/superadmin.service.ts:2342 (SuperadminService.deleteDocument)

#### SA-046 **PATCH /superadmin/uploaddoc/:id**

Upload Document Update

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateDocDto · required · schema UpdateDocDto \[src/superadmin/dto/updatedoc.dto.ts\] · fields title?: string; docTypeId?: number; fileName?: string; description?: string; tags?: string; associateType?: AssociateTypeDto; associateId?: number; expiryAt?: string; isVisible?: boolean; isVisibleDriver?: boolean

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Request must be multipart/form-data' } as any\> | \<updatedResult\> | {action: true, message: "Document updated successfully", data: \<updatedWithFile\>} | {action: false, message: "Document not found"} | {action: false, message: \<\`User not found: \${associateId}\`\>} | {action: false, message: \<\`Driver not found: \${associateId}\`\>} | {action: false, message: \<\`Vehicle not found: \${associateId}\`\>} | \<{ action: false, message: \`DocumentType not found: \${effectiveDocTypeId}\` } as any\> | \<{ action: false, message: \`DocumentType \${effectiveDocTypeId} is not for \${effectiveAssociateType}\` } as any\> | {action: true, message: "Document updated successfully", data: \<updated\>}

**Errors:** Error — err ?? new Error('Unknown error'); Error — Document association is missing; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:432 (SuperadminController.uploadDocumentUpdate) → src/superadmin/superadmin.service.ts:2280 (SuperadminService.updateDocumentMultipart) → src/superadmin/superadmin.service.ts:2193 (SuperadminService.updateDocument)

### Email and SMTP (3)

#### SA-047 **GET /superadmin/smtpsettings**

Get Smtp Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "SMTP Settings not found"} | {action: true, message: "SMTP Settings fetched successfully", data: \<smtpsettings\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:551 (SuperadminController.getSmtpSettings) → src/superadmin/superadmin.service.ts:2554 (SuperadminService.getSmtpSettings)

#### SA-048 **PATCH /superadmin/smtpsettings**

Update Smtp Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body smtpSettingsDto · SmtpSettingDto · required · schema SmtpSettingDto \[src/superadmin/dto/smtp.dto.ts\] · fields senderName?: string; host?: string; port?: string | number; email?: string; type?: SmtpSecurity; username?: string; password?: string; replyTo?: string; isActive?: string | boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {message: "Nothing to update"} | {message: "SMTP settings updated successfully", data: \<updated\>} | {message: \<\`Missing required SMTP fields: \${missing.join(', ')}\`\>} | {message: "SMTP settings created successfully", data: \<created\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:556 (SuperadminController.updateSmtpSettings) → src/superadmin/superadmin.service.ts:970 (SuperadminService.updateSmtpConfig)

#### SA-049 **POST /superadmin/testsmtp**

Test Smtp Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body email · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:564 (SuperadminController.testSmtpSettings) → src/superadmin/superadmin.service.ts:2565 (SuperadminService.testSmtpSettings)

### Fleet Catalog (8)

#### SA-050 **GET /superadmin/devicetypes**

Get Device Types

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Device Types Fetched Successfully", data: \<deviceTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:311 (SuperadminController.getDeviceTypes) → src/superadmin/superadmin.service.ts:1815 (SuperadminService.getDeviceTypes)

#### SA-051 **POST /superadmin/devicetypes**

Create Device Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body deviceTypeDto · DeviceTypeDto · required · schema DeviceTypeDto \[src/superadmin/dto/devicetype.dto.ts\] · fields name: string; port: number; manufacturer?: string | null; protocol?: string | null; firmwareVersion?: string | null

**Response:** Global success envelope; observed result variants {action: false, message: "Device Type with the same name or port already exists"} | {action: true, message: "Device Type created successfully", data: \<newDeviceType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:315 (SuperadminController.createDeviceType) → src/superadmin/superadmin.service.ts:1823 (SuperadminService.createDeviceType)

#### SA-052 **DELETE /superadmin/devicetypes/:id**

Delete Device Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Device Type deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:323 (SuperadminController.deleteDeviceType) → src/superadmin/superadmin.service.ts:1857 (SuperadminService.deleteDeviceType)

#### SA-053 **PATCH /superadmin/devicetypes/:id**

Update Device Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body deviceTypeDto · DeviceTypeDto · required · schema DeviceTypeDto \[src/superadmin/dto/devicetype.dto.ts\] · fields name: string; port: number; manufacturer?: string | null; protocol?: string | null; firmwareVersion?: string | null

**Response:** Global success envelope; observed result variants {action: false, message: "Device Type not found"} | {action: true, message: "Device Type updated successfully", data: \<updatedDeviceType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:319 (SuperadminController.updateDeviceType) → src/superadmin/superadmin.service.ts:1842 (SuperadminService.updateDeviceType)

#### SA-054 **GET /superadmin/vehicletypes**

Get Vehicle Types

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle Types Fetched Successfully", data: \<vehicleTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:261 (SuperadminController.getVehicleTypes) → src/superadmin/superadmin.service.ts:1530 (SuperadminService.getVehicleTypes)

#### SA-055 **POST /superadmin/vehicletypes**

Create Vehicle Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body vehicleTypeDto · VehicleTypeDto · required · schema VehicleTypeDto \[src/superadmin/dto/vehicletype.dto.ts\] · fields name: string; slug: string

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle Type with the same name or slug already exists"} | {action: true, message: "Vehicle Type created successfully", data: \<newVehicleType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:266 (SuperadminController.createVehicleType) → src/superadmin/superadmin.service.ts:1747 (SuperadminService.createVehicleType)

#### SA-056 **DELETE /superadmin/vehicletypes/:id**

Delete Vehicle Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle Type deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:276 (SuperadminController.deleteVehicleType) → src/superadmin/superadmin.service.ts:1740 (SuperadminService.deleteVehicleType)

#### SA-057 **PATCH /superadmin/vehicletypes/:id**

Update Vehicle Type

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body vehicleTypeDto · VehicleTypeDto · required · schema VehicleTypeDto \[src/superadmin/dto/vehicletype.dto.ts\] · fields name: string; slug: string

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle Type not found"} | {action: true, message: "Vehicle Type updated successfully", data: \<updatedVehicleType\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:271 (SuperadminController.updateVehicleType) → src/superadmin/superadmin.service.ts:1723 (SuperadminService.updateVehicleType)

### Geofences and Landmarks (2)

#### SA-058 **GET /superadmin/geofences**

Get All Geofences

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Geofences fetched", geofences: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:790 (SuperadminController.getAllGeofences) → src/superadmin/superadmin.service.ts:4625 (SuperadminService.getAllGeofences)

#### SA-059 **GET /superadmin/pois**

Get All Pois

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "POIs fetched", pois: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:795 (SuperadminController.getAllPois) → src/superadmin/superadmin.service.ts:4676 (SuperadminService.getAllPois)

### Licensing and Feature Keys (4)

#### SA-060 **POST /superadmin/ftkey/deactivate**

Deactivate Ftkey

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "License removed. Free vehicle limit is now active.", data: \<snapshot\>} | {action: false, message: \<error?.message || 'Failed to remove license'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:705 (SuperadminController.deactivateFtkey) → src/superadmin/superadmin.service.ts:4188 (SuperadminService.deactivateFtkey)

#### SA-061 **POST /superadmin/ftkey/recheck**

Force re-check the stored license key against the validation API.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: conditional, data: \<snapshot\>} | {action: false, message: \<error?.message || 'Failed to re-check license'\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:700 (SuperadminController.recheckFtkey) → src/superadmin/superadmin.service.ts:4171 (SuperadminService.recheckFtkey)

#### SA-062 **GET /superadmin/ftkey/status**

Check if a valid ftkey (license key) exists in software_config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: conditional, data: \<snapshot\>} | {action: false, message: \<error?.message || 'Failed to check license status'\>, data: {licensed: false}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:690 (SuperadminController.getFtkeyStatus) → src/superadmin/superadmin.service.ts:4135 (SuperadminService.getFtkeyStatus)

#### SA-063 **POST /superadmin/ftkey/validate**

Validate ftkey against external API and save if valid. Delegates to LicenseService (single source of truth).

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · ValidateFtkeyDto · required · schema ValidateFtkeyDto \[src/superadmin/dto/ftkey.dto.ts\] · fields ftkey: string

**Response:** Global success envelope; observed result variants {action: false, message: \<error?.message || 'Failed to validate license key'\>, data: {valid: false}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:695 (SuperadminController.validateFtkey) → src/superadmin/superadmin.service.ts:4156 (SuperadminService.validateAndSaveFtkey)

### Live Map and Telemetry (2)

#### SA-064 **GET /superadmin/map-events**

GET /superadmin/map-events

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · MapEventsQueryDto · required · schema MapEventsQueryDto \[src/superadmin/dto/map-events.dto.ts\] · fields limit?: string; beforeId?: string; from?: string; to?: string; source?: string; severity?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Map events loaded", data: \<result\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:988 (SuperadminController.getMapEvents) → src/superadmin/superadmin.service.ts:6856 (SuperadminService.getMapEvents)

#### SA-065 **GET /superadmin/map-telemetry**

Get Map Telemetry

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query cursor · string · optional ; query limit · string · optional

**Response:** Global success envelope; observed result variants {action: true, message: "Map telemetry fetched", data: {items: \<items\>, cursor: \<nextCursor\>, nextCursor: \<nextCursor\>, hasMore: \<hasMore\>, count: \<items.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:761 (SuperadminController.getMapTelemetry) → src/superadmin/superadmin.service.ts:4497 (SuperadminService.getMapTelemetry)

### Message Templates (11)

#### SA-066 **GET /superadmin/appnotifytemplates**

Get App Notify Templates

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "App Notify Templates Fetched Successfully", data: \<appNotifyTemplates\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:408 (SuperadminController.getAppNotifyTemplates) → src/superadmin/superadmin.service.ts:2146 (SuperadminService.getAppNotifyTemplates)

#### SA-067 **GET /superadmin/appnotifytemplates/:id**

Get App Notify Template By Id

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: false, message: "App Notify Template not found"} | {action: true, message: "App Notify Template Fetched Successfully", data: \<appNotifyTemplate\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:412 (SuperadminController.getAppNotifyTemplateById) → src/superadmin/superadmin.service.ts:2157 (SuperadminService.getAppNotifyTemplateById)

#### SA-068 **PATCH /superadmin/appnotifytemplates/:id**

Update App Notify Template

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body appNotifyTemplateDto · AppNotifyTemplateDto · required · schema AppNotifyTemplateDto \[src/superadmin/dto/appnotifytempletes.dto.ts\] · fields notifySubject?: string; message?: string

**Response:** Global success envelope; observed result variants {action: false, message: "App Notify Template not found"} | {action: true, message: "App Notify Template updated successfully", data: \<updatedAppNotifyTemplate\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:416 (SuperadminController.updateAppNotifyTemplate) → src/superadmin/superadmin.service.ts:2166 (SuperadminService.updateAppNotifyTemplate)

#### SA-069 **GET /superadmin/emailtemplates**

Get Email Templates

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Email Templates Fetched Successfully", data: \<emailTemplates\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:396 (SuperadminController.getEmailTemplates) → src/superadmin/superadmin.service.ts:2110 (SuperadminService.getEmailTemplates)

#### SA-070 **GET /superadmin/emailtemplates/:id**

Get Email Template By Id

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: false, message: "Email Template not found"} | {action: true, message: "Email Template Fetched Successfully", data: \<emailTemplate\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:400 (SuperadminController.getEmailTemplateById) → src/superadmin/superadmin.service.ts:2121 (SuperadminService.getEmailTemplateById)

#### SA-071 **PATCH /superadmin/emailtemplates/:id**

Update Email Template

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body emailTemplateDto · EmailTemplateDto · required · schema EmailTemplateDto \[src/superadmin/dto/emailtemplate.dto.ts\] · fields emailSubject?: string; message?: string

**Response:** Global success envelope; observed result variants {action: false, message: "Email Template not found"} | {action: true, message: "Email Template updated successfully", data: \<updatedEmailTemplate\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:404 (SuperadminController.updateEmailTemplate) → src/superadmin/superadmin.service.ts:2131 (SuperadminService.updateEmailTemplate)

#### SA-072 **GET /superadmin/whatsapptemplates**

List all local WhatsApp templates (with optional filters).

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · ListWhatsAppTemplatesQueryDto · required · schema ListWhatsAppTemplatesQueryDto \[src/superadmin/dto/whatsapp-templates.dto.ts\] · fields type?: string; languageCode?: string; isActive?: boolean; rk?: string

**Response:** Global success envelope; observed result variants {action: true, message: \<\`Found \${templates.length} template(s)\`\>, data: \<templates\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/whatsapp-templates/whatsapp-templates.controller.ts:33 (WhatsAppTemplatesController.list) → src/superadmin/whatsapp-templates/whatsapp-templates.service.ts:55 (WhatsAppTemplatesService.listTemplates)

#### SA-073 **GET /superadmin/whatsapptemplates/:id**

Fetch a single local WhatsApp template by ID.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "Template fetched", data: \<template\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/whatsapp-templates/whatsapp-templates.controller.ts:61 (WhatsAppTemplatesController.getOne) → src/superadmin/whatsapp-templates/whatsapp-templates.service.ts:73 (WhatsAppTemplatesService.getTemplate)

#### SA-074 **PATCH /superadmin/whatsapptemplates/:id**

Update a local template (title, body, category, language, isActive).

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateWhatsAppTemplateDto · required · schema UpdateWhatsAppTemplateDto \[src/superadmin/dto/whatsapp-templates.dto.ts\] · fields title?: string; body?: string; category?: string; languageCode?: string; isActive?: boolean

**Response:** Global success envelope; observed result variants {action: true, message: "Template updated", data: \<updated\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/whatsapp-templates/whatsapp-templates.controller.ts:67 (WhatsAppTemplatesController.update) → src/superadmin/whatsapp-templates/whatsapp-templates.service.ts:86 (WhatsAppTemplatesService.updateTemplate)

#### SA-075 **GET /superadmin/whatsapptemplates/meta**

Fetch all templates from Meta Graph API (read-only view).

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: \<\`Fetched \${templates.length} template(s) from Meta\`\>, data: \<templates.map\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/whatsapp-templates/whatsapp-templates.controller.ts:41 (WhatsAppTemplatesController.fetchMeta) → src/superadmin/whatsapp-templates/whatsapp-templates.service.ts:123 (WhatsAppTemplatesService.fetchMetaTemplates)

#### SA-076 **POST /superadmin/whatsapptemplates/sync**

Sync local templates to Meta. Optionally pass templateIds to sync a subset, or dryRun to preview.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · SyncWhatsAppTemplatesDto · required · schema SyncWhatsAppTemplatesDto \[src/superadmin/dto/whatsapp-templates.dto.ts\] · fields templateIds?: number\[\]; dryRun?: boolean

**Response:** Global success envelope; observed result variants {action: true, message: "No active templates to sync", data: {summary: {createdCount: 0, updatedCount: 0, skippedCount: 0, failedCount: 0}, results: \[\]}} | {action: true, message: "WhatsApp templates sync completed", data: {summary: {createdCount: \<createdCount\>, updatedCount: \<updatedCount\>, skippedCount: \<skippedCount\>, failedCount: \<failedCount\>}, results: \<results\>}}

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/whatsapp-templates/whatsapp-templates.controller.ts:52 (WhatsAppTemplatesController.sync) → src/superadmin/whatsapp-templates/whatsapp-templates.service.ts:145 (WhatsAppTemplatesService.syncTemplates)

### Notification Campaigns (9)

#### SA-077 **GET /superadmin/notify/campaigns**

List Campaigns

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · NotifyCampaignQueryDto · required · schema NotifyCampaignQueryDto \[src/notify/dto/notify-campaign-query.dto.ts\] · fields status?: NotifyCampaignStatus; channel?: NotificationChannel; search?: string; limit?: number = 20; cursor?: number; page?: number; from?: string; to?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {items: \<pageRows.map\>, nextCursor: conditional, summary: \<summary\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/notify.controller.ts:58 (NotifyController.listCampaigns) → src/notify/notify.service.ts:186 (NotifyService.listCampaigns)

#### SA-078 **POST /superadmin/notify/campaigns**

Create Campaign

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateNotifyCampaignDto · required · schema CreateNotifyCampaignDto \[src/notify/dto/create-notify-campaign.dto.ts\] · fields audienceType: NotifyAudienceType; selectedUserIds?: number\[\]; filters?: NotifyAudienceFiltersDto; channels: NotificationChannel\[\]; subject: string; message: string; category: UserNotificationCategory; severity?: NotificationSeverity; ctaLabel?: string | null; ctaUrl?: string | null; scheduledAt?: string | null ; headers idempotency-key · string | undefined · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/notify/notify.controller.ts:42 (NotifyController.createCampaign) → src/notify/notify.service.ts:61 (NotifyService.createCampaign)

#### SA-079 **DELETE /superadmin/notify/campaigns/:id**

Delete Campaign

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {deleted: true, id: \<campaign.id\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/notify/notify.controller.ts:74 (NotifyController.deleteCampaign) → src/notify/notify.service.ts:304 (NotifyService.deleteCampaign)

#### SA-080 **GET /superadmin/notify/campaigns/:id**

Get Campaign

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {id: \<campaign.id\>, subject: \<campaign.subject\>, message: \<campaign.message\>, category: \<campaign.category\>, severity: \<campaign.severity\>, status: \<this.deriveStatus\>, audienceType: \<campaign.audienceType\>, filters: \<campaign.filters ?? null\>, selectedUserIds: conditional, selectedUserIdsCount: conditional, channels: \<this.parseChannels\>, channelSummary: \<this.buildChannelSummary\>, totalRecipients: \<recipientCount\>, totalDeliveries: \<deliveryCount\>, sentCount: \<stats?.sentCount ?? campaign.sentCount\>, failedCount: \<stats?.failedCount ?? campaign.failedCount\>, pendingCount: \<stats?.pendingCount ?? Math.max(0, deliveryCount - campaign.sentCount - campaign.failedCount)\>, readCount: \<readCount\>, skippedCount: \<skippedCount\>, createdBy: {id: \<campaign.sender.uid\>, name: \<campaign.sender.name\>, email: \<this.maskEmail\>}, scheduledAt: \<campaign.scheduledAt\>, queuedAt: \<campaign.queuedAt\>, startedAt: \<campaign.startedAt\>, completedAt: \<campaign.completedAt\>, createdAt: \<campaign.createdAt\>, updatedAt: \<campaign.updatedAt\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/notify/notify.controller.ts:66 (NotifyController.getCampaign) → src/notify/notify.service.ts:230 (NotifyService.getCampaign)

#### SA-081 **GET /superadmin/notify/campaigns/:id/deliveries**

List Campaign Deliveries

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; query query · NotifyDeliveriesQueryDto · required · schema NotifyDeliveriesQueryDto \[src/notify/dto/notify-deliveries-query.dto.ts\] · fields channel?: NotificationChannel; status?: NotificationDeliveryStatus; failureOnly?: boolean; recipientSearch?: string; limit?: number = 25; cursor?: number; page?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {items: \<pageRows.map\>, nextCursor: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/notify.controller.ts:96 (NotifyController.listCampaignDeliveries) → src/notify/notify.service.ts:344 (NotifyService.listCampaignDeliveries)

#### SA-082 **GET /superadmin/notify/campaigns/:id/recipients**

List Campaign Recipients

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; query query · NotifyCampaignRecipientsQueryDto · required · schema NotifyCampaignRecipientsQueryDto \[src/notify/dto/notify-campaign-recipients-query.dto.ts\] · fields search?: string; status?: NotifyCampaignRecipientStatusFilter; read?: NotifyRecipientReadFilter; channel?: NotificationChannel; limit?: number = 25; cursor?: number; page?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {items: \<pageRows.map\>, nextCursor: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/notify.controller.ts:83 (NotifyController.listCampaignRecipients) → src/notify/notify.service.ts:432 (NotifyService.listCampaignRecipients)

#### SA-083 **GET /superadmin/notify/capabilities**

Get Capabilities

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/notify.controller.ts:20 (NotifyController.getCapabilities) → src/notify/notify.service.ts:49 (NotifyService.getCapabilities)

#### SA-084 **GET /superadmin/notify/recipients**

List Recipients

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · NotifyRecipientsQueryDto · required · schema NotifyRecipientsQueryDto \[src/notify/dto/notify-recipients-query.dto.ts\] · fields type: NotifyListAudienceType; search?: string; adminId?: number; status?: NotifyRecipientStatusFilter; limit?: number = 25; cursor?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/notify.controller.ts:25 (NotifyController.listRecipients) → src/notify/notify.service.ts:53 (NotifyService.listRecipients)

#### SA-085 **POST /superadmin/notify/recipients/estimate**

Estimate Recipients

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · EstimateNotifyRecipientsDto · required · schema EstimateNotifyRecipientsDto \[src/notify/dto/create-notify-campaign.dto.ts\] · fields audienceType: NotifyAudienceType; selectedUserIds?: number\[\]; filters?: NotifyAudienceFiltersDto; channels: NotificationChannel\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/notify.controller.ts:33 (NotifyController.estimateRecipients) → src/notify/notify.service.ts:57 (NotifyService.estimateRecipients)

### Notifications (4)

#### SA-086 **GET /superadmin/notifications**

Get Notifications

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · NotificationsQueryDto · required · schema NotificationsQueryDto \[src/superadmin/dto/notifications.dto.ts\] · fields limit?: string; beforeId?: string; unreadOnly?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Notifications fetched successfully", data: {items: \<items\>, nextCursor: \<nextCursor\>, unreadCount: \<unreadCount\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:1067 (SuperadminController.getNotifications) → src/superadmin/superadmin.service.ts:7005 (SuperadminService.getNotifications)

#### SA-087 **PATCH /superadmin/notifications/:id/read**

Mark Notification Read

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Notification marked as read", data: {id: \<notificationId\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:1082 (SuperadminController.markNotificationRead) → src/superadmin/superadmin.service.ts:7048 (SuperadminService.markNotificationRead)

#### SA-088 **PATCH /superadmin/notifications/read-all**

Mark All Notifications Read

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "All notifications marked as read", data: {updatedCount: \<result.count\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:1075 (SuperadminController.markAllNotificationsRead) → src/superadmin/superadmin.service.ts:7071 (SuperadminService.markAllNotificationsRead)

#### SA-089 **POST /superadmin/notifications/test-fcm-me**

Send a test FCM push notification to the current user's stored push token(s). Finds the default active FCM integration and all active tokens for the selected platform, then sends to each.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · TestFcmToMeDto · required · schema TestFcmToMeDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields title?: string; body?: string; platform?: PushTokenPlatformFilter = 'web'

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "No active FCM integration found. Configure one first."} | {action: false, message: "FCM integration has no active secret configured."} | {action: false, message: \<\`No active \${targetLabel} push token registered. Please enable notifications and re-login.\`\>} | {action: false, message: "Failed to decrypt FCM integration secret."} | {action: false, message: "projectId is missing in the integration."} | {action: false, message: conditional, data: {sent: \<sent\>, failed: \<failed\>, deactivated: \<deactivated\>, platform: \<platform\>}} | {action: true, message: \<\`Test notification sent to \${sent} \${targetLabel} device(s).\${failed \> 0 ? \` \${failed} failed (\${deactivated} deactivated).\` : ''}\`\>, data: {sent: \<sent\>, failed: \<failed\>, deactivated: \<deactivated\>, platform: \<platform\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:908 (SuperadminController.testFcmToMe) → src/superadmin/superadmin.service.ts:5772 (SuperadminService.testFcmToMe)

### Platform Configuration (11)

#### SA-090 **GET /superadmin/companyconfig/:id**

Get Company Config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {message: "Company config Not Exists for this Admin"} | \<company\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:236 (SuperadminController.getCompanyConfig) → src/superadmin/superadmin.service.ts:1026 (SuperadminService.getCompanyConfig)

#### SA-091 **PATCH /superadmin/companyconfig/:id**

Update Company Config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body companyConfig · CompanyDto · required · schema CompanyDto \[src/superadmin/dto/company.dto.ts\] · fields name?: string; websiteUrl?: string; customDomain?: string; socialLinks?: Record\<string, string\>; primaryColor?: string

**Response:** Global success envelope; observed result variants {message: "Nothing to update"} | {message: "Company config updated successfully", data: \<updated\>} | {message: "No data provided to create company config"} | {message: "Company config created successfully", data: \<created\>}

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:241 (SuperadminController.updateCompanyConfig) → src/superadmin/superadmin.service.ts:1035 (SuperadminService.updateCompanyConfig)

#### SA-092 **GET /superadmin/domainlist**

Get Domain List

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Domain list fetched successfully", data: \<domains\>} | {action: false, message: \<error?.message || 'Failed to fetch domain list'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:681 (SuperadminController.getDomainList) → src/superadmin/superadmin.service.ts:4111 (SuperadminService.getDomainList)

#### SA-093 **PATCH /superadmin/policy**

Update Policy

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body PolicyDto · PolicyDto · required · schema PolicyDto \[src/superadmin/dto/policy.dto.ts\] · fields PolicyType: PolicyTypeDto; PolicyText: string

**Response:** Global success envelope; observed result variants {action: true, message: "Policy updated successfully", data: \<updatedPolicy\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:609 (SuperadminController.updatePolicy) → src/superadmin/superadmin.service.ts:2766 (SuperadminService.updatePolicy)

#### SA-094 **POST /superadmin/policy**

Create Policy

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body PolicyType · string · required

**Response:** Global success envelope; observed result variants {action: false, message: \<\`Invalid policy type. Must be one of: \${allowed.join(', ')}\`\>} | {action: false, message: "Policy not found"} | {action: true, message: "Policy fetched successfully", data: \<policy\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:604 (SuperadminController.createPolicy) → src/superadmin/superadmin.service.ts:2738 (SuperadminService.getPolicy)

#### SA-095 **GET /superadmin/settings/:id**

Get Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: false, message: "Settings not found"} | {action: true, message: "Settings fetched successfully", data: \<settings\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:463 (SuperadminController.getSettings) → src/superadmin/superadmin.service.ts:2356 (SuperadminService.getadminSettings)

#### SA-096 **PATCH /superadmin/settings/:id**

Update Settings

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body settingsDto · UpdateSettingsStateDto · required · schema UpdateSettingsStateDto \[src/superadmin/dto/usersetting.dto.ts\] · fields language?: string; layoutDirection?: LayoutDirectionDto; dateFormat?: string; use24Hour?: boolean; theme?: ThemeModeDto; timezoneOffset?: string; units?: UnitsDto; defaultLat?: number; defaultLon?: number; mapZoom?: number

**Response:** Global success envelope; observed result variants {action: false, message: "No settings fields provided"} | {action: true, message: conditional, data: \<saved\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:468 (SuperadminController.updateSettings) → src/superadmin/superadmin.service.ts:2364 (SuperadminService.updateadminSettings)

#### SA-097 **GET /superadmin/settings/data-retention/preview**

Counts rows older than the configured retention window across all pruneable operational tables. Never deletes anything.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: \<!data.skipped\>, message: conditional, data: \<data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:594 (SuperadminController.previewDataRetention) → src/superadmin/superadmin.service.ts:156 (SuperadminService.previewDataRetention)

#### SA-098 **POST /superadmin/settings/data-retention/run**

Manually triggers the same cleanup pipeline used by the daily scheduler. Honors the distributed Redis lock so manual and scheduled runs cannot overlap.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body body · { dryRun?: boolean } · optional · fields dryRun?: boolean

**Response:** Global success envelope; observed result variants {action: \<!data.skipped\>, message: conditional, data: \<data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:599 (SuperadminController.runDataRetention) → src/superadmin/superadmin.service.ts:172 (SuperadminService.runDataRetention)

#### SA-099 **GET /superadmin/softwareconfig**

Get Config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "No configuration found.", data: null} | {action: true, message: "Configuration loaded successfully.", data: \<mergedData\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:582 (SuperadminController.getConfig) → src/superadmin/superadmin.service.ts:2580 (SuperadminService.GetConfig)

#### SA-100 **PATCH /superadmin/softwareconfig**

Update Config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body softwareConfigDto · SoftwareConfigDto · required · schema SoftwareConfigDto \[src/superadmin/dto/softwareconfig.dto.ts\] · fields geocodingPrecision?: GeocodingPrecisionDto; backupDays?: number; allowDemoLogin?: boolean; allowSignup?: boolean; signupCredits?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Configuration updated successfully", data: {company: \<updatedCompany\>, softwareConfig: \<updateSoftwareConfig\>}}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:587 (SuperadminController.updateConfig) → src/superadmin/superadmin.service.ts:2643 (SuperadminService.updateConfig)

### Pricing and Billing (3)

#### SA-101 **GET /superadmin/transactions**

List Transactions

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query adminId · string · optional ; query status · string · optional ; query from · string · optional ; query to · string · optional ; query q · string · optional ; query page · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>} | {page: \<page\>, limit: \<limit\>, total: \<total\>, items: \<mapped\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:189 (SuperadminController.listTransactions) → src/superadmin/superadmin.service.ts:752 (SuperadminService.listTransactions)

#### SA-102 **GET /superadmin/transactions/analytics**

Transactions Analytics

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query adminId · string · optional ; query from · string · optional ; query to · string · optional ; query month · string · optional ; query year · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>} | {range: {start: \<rangeStart.toISOString\>, end: \<rangeEnd.toISOString\>}, totalTransactions: \<rows.length\>, totalsByCurrency: \<totals\>, statusBreakdown: \<statusBreakdown\>, modeBreakdown: \<modes\>, dailySeriesByCurrency: \<dailySeriesByCurrency\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:204 (SuperadminController.transactionsAnalytics) → src/superadmin/superadmin.service.ts:841 (SuperadminService.transactionsAnalytics)

#### SA-103 **POST /superadmin/transactions/manual**

Record Manual Transaction

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · RecordManualTransactionDto · required · schema RecordManualTransactionDto \[src/superadmin/dto/record-manual-transaction.dto.ts\] · fields adminId: number; amount: string; reference?: string; paymentMode?: PaymentMode

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Payment recorded", data: \<data\>} | {...: spread, amount: \<created.amount?.toString?.() ?? String(created.amount)\>}

**Errors:** HttpException; NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:217 (SuperadminController.recordManualTransaction) → src/superadmin/superadmin.service.ts:688 (SuperadminService.recordManualTransaction)

### Profile and Security (9)

#### SA-104 **GET /superadmin/profile**

Get Profile

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Profile fetched successfully", data: \<superadmin\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:473 (SuperadminController.getProfile) → src/superadmin/superadmin.service.ts:2427 (SuperadminService.getProfile)

#### SA-105 **PATCH /superadmin/profile**

Update Profile

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body profileDto · ProfileDto · required · schema ProfileDto \[src/superadmin/dto/profile.dto.ts\] · fields name: string; email?: string; mobilePrefix: string; mobileNumber: string; addressLine: string; countryCode: string; stateCode: string; cityName: string; pincode?: string

**Response:** Global success envelope; observed result variants {action: false, message: "Superadmin not found"} | {action: false, message: "Address not found"} | {action: true, message: "Profile updated successfully", data: \<updatedSuperadmin\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:478 (SuperadminController.updateProfile) → src/superadmin/superadmin.service.ts:2479 (SuperadminService.updateProfile)

#### SA-106 **GET /superadmin/profile/email-subscription**

Resolve brand owner + SMTP owner for a recipient user.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, data: {isSubscribed: \<subscribed\>, brandOwnerId: \<brandOwnerId\>, scope: \<scope\>}} | \<result\> | \<cached === SUBSCRIBED\> | \<subscribed\>

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:511 (SuperadminController.getEmailSubscription) → src/email/services/email-context.resolver.ts:97 (EmailContextResolver.resolveContextForRecipient) → src/email/services/email-subscription.service.ts:57 (EmailSubscriptionService.ensureSubscription) → src/email/services/email-subscription.service.ts:89 (EmailSubscriptionService.isSubscribed)

#### SA-107 **POST /superadmin/profile/email-subscription/subscribe**

Resolve brand owner + SMTP owner for a recipient user.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Subscribed", data: {isSubscribed: true}} | \<result\>

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:522 (SuperadminController.subscribeEmail) → src/email/services/email-context.resolver.ts:97 (EmailContextResolver.resolveContextForRecipient) → src/email/services/email-subscription.service.ts:202 (EmailSubscriptionService.subscribe)

#### SA-108 **POST /superadmin/profile/verify/email/confirm**

Verify an email OTP.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · VerifyOtpDto · required · schema VerifyOtpDto \[src/verification/dto/verify-otp.dto.ts\] · fields otp: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Email verified successfully"}

**Errors:** HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:492 (SuperadminController.verifyEmailOtp) → src/verification/verification.service.ts:171 (VerificationService.verifyEmailOtp)

#### SA-109 **POST /superadmin/profile/verify/email/request**

Generate and send an email OTP to the user's registered email.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "SMTP is not configured. Please configure SMTP before sending email OTP.", data: {code: "SMTP_NOT_CONFIGURED"}} | {action: false, message: "Email verification code could not be sent. Please try again later.", data: {code: "EMAIL_DELIVERY_FAILED"}} | {action: true, message: \<\`Verification code sent to \${this.maskEmail(user.email)}\`\>, data: {expiresInSeconds: \<this.otpTtl\>}}

**Errors:** NotFoundException; HttpException; Error; Error — \`Cannot send email: recipient \${recipientUserId} has no email address\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:487 (SuperadminController.requestEmailOtp) → src/verification/verification.service.ts:74 (VerificationService.requestEmailOtp)

#### SA-110 **POST /superadmin/profile/verify/whatsapp/confirm**

Verify the WhatsApp OTP submitted by the superadmin.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · VerifyOtpDto · required · schema VerifyOtpDto \[src/verification/dto/verify-otp.dto.ts\] · fields otp: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Mobile number verified successfully."}

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:502 (SuperadminController.verifyWhatsAppOtp) → src/communications/verification/verification.service.ts:215 (CommsVerificationService.verifyWhatsAppOtpForSuperadmin)

#### SA-111 **POST /superadmin/profile/verify/whatsapp/request**

Generate, hash, store, and send a WhatsApp OTP to the superadmin's registered mobile number.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<'Template required — the user must message the business first, ' + 'or an approved template must be used.'\>, data: {requiresTemplate: true}} | {action: false, message: \<result.errorMessage ?? 'Failed to send WhatsApp OTP.'\>, data: {requiresTemplate: false, details: \<result.details\>}} | {action: true, message: \<\`Verification code sent to \${this.maskPhone(phone)}\`\>, data: {expiresInSeconds: \<OTP_TTL_SECONDS\>}}

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:497 (SuperadminController.requestWhatsAppOtp) → src/communications/verification/verification.service.ts:102 (CommsVerificationService.requestWhatsAppOtpForSuperadmin)

#### SA-112 **PATCH /superadmin/updatepassword**

Update Password

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body passwordDto · UpdatePasswordDto · required · schema UpdatePasswordDto \[src/superadmin/dto/updatepassword.dto.ts\] · fields currentPassword: string; newPassword: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Current password and new password are required"} | {action: false, message: "New password must be different from current password"} | {action: false, message: "Superadmin not found"} | {action: false, message: "Password is not set for this user"} | {action: false, message: "Current password is incorrect"} | {action: true, message: "Password updated successfully"}

**Errors:** UnauthorizedException — Invalid user identity; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:620 (SuperadminController.updatePassword) → src/superadmin/superadmin.service.ts:2776 (SuperadminService.updatePassword)

### Routes and Optimization (1)

#### SA-113 **GET /superadmin/routes**

Get All Routes

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query includeGeodata · string · optional

**Response:** Global success envelope; observed result variants {action: true, message: "Routes fetched", routes: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:800 (SuperadminController.getAllRoutes) → src/superadmin/superadmin.service.ts:4711 (SuperadminService.getAllRoutes)

### SSL Operations (4)

#### SA-114 **POST /superadmin/ssl/install**

Start an SSL install/renew job. Returns the job ID immediately. Execution happens in the background; progress is streamed via SSE.

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · SslInstallDto · required · schema SslInstallDto \[src/ssl/dto/ssl.dto.ts\] · fields domain: string; action: SslAction; email?: string; backendProxyPass?: string

**Response:** Global success envelope; observed result variants {action: true, message: \<\`SSL \${dto.action} job started\`\>, data: {jobId: \<job.id\>, domain: \<job.domain\>, action: \<job.action\>}} | \<job\>

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/ssl/ssl.controller.ts:37 (SslController.install) → src/ssl/ssl.service.ts:258 (SslService.startJob)

#### SA-115 **GET /superadmin/ssl/jobs/:jobId**

Get Job

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param jobId · string · required

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found", data: null} | {action: true, message: "Job state retrieved", data: \<job\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/ssl/ssl.controller.ts:52 (SslController.getJob) → src/ssl/ssl.service.ts:246 (SslService.getJob)

#### SA-116 **GET /superadmin/ssl/jobs/:jobId/stream**

Stream Job

Access Public · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param jobId · string · required ; query token · string · required

**Stream:** Server-Sent Events with event names job_state, log, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/ssl/ssl.controller.ts:75 (SslStreamController.streamJob) → src/ssl/ssl.service.ts:246 (SslService.getJob) → src/ssl/ssl.service.ts:250 (SslService.getJobEmitter)

#### SA-117 **GET /superadmin/ssl/status**

Get Status

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "SSL status retrieved", data: \<data\>} | \<results.map\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/ssl/ssl.controller.ts:31 (SslController.getStatus) → src/ssl/ssl.service.ts:218 (SslService.getFullStatus)

### Search (1)

#### SA-118 **GET /superadmin/topbar-search**

Search Topbar

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · TopbarSearchQueryDto · required · schema TopbarSearchQueryDto \[src/topbar-search/dto/topbar-search.dto.ts\] · fields q: string; limit?: number = 20

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:73 (SuperadminController.searchTopbar) → src/topbar-search/topbar-search.service.ts:36 (TopbarSearchService.searchForSuperadmin)

### Server Operations (4)

#### SA-119 **POST /superadmin/server/actions**

Create Server Action Job

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · ServerActionDto · required · schema ServerActionDto \[src/superadmin/server/dto/server-action.dto.ts\] · fields componentId: ServerActionComponentId; action: ServerActionType

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Server action job created", data: \<created\>} | {id: \<id\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/server/server.controller.ts:31 (ServerController.createServerActionJob) → src/superadmin/server/server-actions.service.ts:48 (ServerActionsService.createJob)

#### SA-120 **GET /superadmin/server/jobs/:id**

Get Server Action Job

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found"} | {action: false, message: \<latestLog?.message || 'Job failed'\>, data: \<job\>} | {action: true, message: "Job fetched", data: \<job\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/server/server.controller.ts:44 (ServerController.getServerActionJob) → src/superadmin/server/server-actions.service.ts:83 (ServerActionsService.getJob)

#### SA-121 **GET /superadmin/server/jobs/:id/stream**

Stream Server Action Job

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Stream:** Server-Sent Events with event names job_state, log, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void | null | \<job.emitter\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/server/server.controller.ts:67 (ServerController.streamServerActionJob) → src/superadmin/server/server-actions.service.ts:89 (ServerActionsService.getEmitter) → src/superadmin/server/server-actions.service.ts:83 (ServerActionsService.getJob)

#### SA-122 **GET /superadmin/server/overview**

Get Overview

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Server overview", data: \<data\>} | {system: \<system\>, components: \<components\>, install: \<detectInstallRoot\>, recommendedActions: \<recommendedActions\>, localAgent: \<localAgent\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/server/server.controller.ts:21 (ServerController.getOverview) → src/superadmin/server/server-monitor.service.ts:94 (ServerMonitorService.getOverview)

### Settings and Localization (8)

#### SA-123 **GET /superadmin/localization**

Get Localization Data

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Localization Settings not found"} | {action: true, message: "Localization Settings fetched successfully", data: \<localsettings\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:569 (SuperadminController.getLocalizationData) → src/superadmin/superadmin.service.ts:2569 (SuperadminService.getLocalizationData)

#### SA-124 **PATCH /superadmin/localization**

Update Localization Data

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body localizationDto · UpdateSettingsStateDto · required · schema UpdateSettingsStateDto \[src/superadmin/dto/usersetting.dto.ts\] · fields language?: string; layoutDirection?: LayoutDirectionDto; dateFormat?: string; use24Hour?: boolean; theme?: ThemeModeDto; timezoneOffset?: string; units?: UnitsDto; defaultLat?: number; defaultLon?: number; mapZoom?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "No settings fields provided"} | {action: true, message: conditional, data: \<saved\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:574 (SuperadminController.updateLocalizationData) → src/superadmin/superadmin.service.ts:2364 (SuperadminService.updateadminSettings)

#### SA-125 **GET /superadmin/smtpconfig/:id**

Get Smtp Config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {message: "SMTP settings Not Exists for this Admin"} | \<smtp\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:226 (SuperadminController.getSmtpConfig) → src/superadmin/superadmin.service.ts:961 (SuperadminService.getSmtpConfig)

#### SA-126 **PATCH /superadmin/smtpconfig/:id**

Update Smtp Config

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body smtpConfig · SmtpSettingDto · required · schema SmtpSettingDto \[src/superadmin/dto/smtp.dto.ts\] · fields senderName?: string; host?: string; port?: string | number; email?: string; type?: SmtpSecurity; username?: string; password?: string; replyTo?: string; isActive?: string | boolean

**Response:** Global success envelope; observed result variants {message: "Nothing to update"} | {message: "SMTP settings updated successfully", data: \<updated\>} | {message: \<\`Missing required SMTP fields: \${missing.join(', ')}\`\>} | {message: "SMTP settings created successfully", data: \<created\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:231 (SuperadminController.updateSmtpConfig) → src/superadmin/superadmin.service.ts:970 (SuperadminService.updateSmtpConfig)

#### SA-127 **GET /superadmin/systemvariables**

Get System Variables

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "System Variables Fetched Successfully", data: \<systemVariables\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:345 (SuperadminController.getSystemVariables) → src/superadmin/superadmin.service.ts:1946 (SuperadminService.getSystemVariables)

#### SA-128 **POST /superadmin/systemvariables**

Create System Variable

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body systemVariableDto · SystemVariableDto · required · schema SystemVariableDto \[src/superadmin/dto/systemvariable.dto.ts\] · fields name: string; initialValue: string

**Response:** Global success envelope; observed result variants {action: false, message: "System Variable with the same name already exists"} | {action: true, message: "System Variable created successfully", data: \<newSystemVariable\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:349 (SuperadminController.createSystemVariable) → src/superadmin/superadmin.service.ts:1952 (SuperadminService.createSystemVariable)

#### SA-129 **DELETE /superadmin/systemvariables/:id**

Delete System Variable

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "System Variable deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:357 (SuperadminController.deleteSystemVariable) → src/superadmin/superadmin.service.ts:1993 (SuperadminService.deleteSystemVariable)

#### SA-130 **PATCH /superadmin/systemvariables/:id**

Update System Variable

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body systemVariableDto · SystemVariableDto · required · schema SystemVariableDto \[src/superadmin/dto/systemvariable.dto.ts\] · fields name: string; initialValue: string

**Response:** Global success envelope; observed result variants {action: false, message: "System Variable not found"} | {action: false, message: "System Variable with the same name already exists"} | {action: true, message: "System Variable updated successfully", data: \<updatedSystemVariable\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:353 (SuperadminController.updateSystemVariable) → src/superadmin/superadmin.service.ts:1968 (SuperadminService.updateSystemVariable)

### Simproviders (4)

#### SA-131 **GET /superadmin/simproviders**

Get Sim Providers

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "SIM Providers Fetched Successfully", data: \<simProviders\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:379 (SuperadminController.getSimProviders) → src/superadmin/superadmin.service.ts:2055 (SuperadminService.getSimProviders)

#### SA-132 **POST /superadmin/simproviders**

Create Sim Provider

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body simProviderDto · SimProviderDto · required · schema SimProviderDto \[src/superadmin/dto/simprociders.dto.ts\] · fields name: string; countryCode: string; apnName?: string | null; apnUser?: string | null; apnPassword?: string | null

**Response:** Global success envelope; observed result variants {action: false, message: "SIM Provider with the same name already exists"} | {action: true, message: "SIM Provider created successfully", data: \<newSimProvider\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:383 (SuperadminController.createSimProvider) → src/superadmin/superadmin.service.ts:2062 (SuperadminService.createSimProvider)

#### SA-133 **DELETE /superadmin/simproviders/:id**

Delete Sim Provider

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Response:** Global success envelope; observed result variants {action: true, message: "SIM Provider deleted successfully", data: \<record\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:391 (SuperadminController.deleteSimProvider) → src/superadmin/superadmin.service.ts:2103 (SuperadminService.deleteSimProvider)

#### SA-134 **PATCH /superadmin/simproviders/:id**

Update Sim Provider

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body simProviderDto · SimProviderDto · required · schema SimProviderDto \[src/superadmin/dto/simprociders.dto.ts\] · fields name: string; countryCode: string; apnName?: string | null; apnUser?: string | null; apnPassword?: string | null

**Response:** Global success envelope; observed result variants {action: false, message: "SIM Provider not found"} | {action: false, message: "SIM Provider with the same name already exists"} | {action: true, message: "SIM Provider updated successfully", data: \<updatedSimProvider\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:387 (SuperadminController.updateSimProvider) → src/superadmin/superadmin.service.ts:2079 (SuperadminService.updateSimProvider)

### Support (5)

#### SA-135 **GET /superadmin/support/tickets**

List Support Tickets

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query status · string · optional ; query search · string · optional ; query priority · string · optional ; query category · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Tickets fetched successfully", data: \<sorted\>} | {action: false, message: \<error?.message || 'Failed to fetch tickets'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:85 (SuperadminController.listSupportTickets) → src/superadmin/superadmin.service.ts:2859 (SuperadminService.listSupportTickets)

#### SA-136 **POST /superadmin/support/tickets**

Create Support Ticket On Behalf Of Admin

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** body body · any · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "adminId is required", data: null} | {action: false, message: "Admin not found", data: null} | {action: false, message: "title is required and must be max 120 characters", data: null} | {action: false, message: "Title must contain at least one letter or number", data: null} | {action: false, message: "message is required and must be max 5000 characters", data: null} | {action: false, message: "Message must contain at least one letter or number", data: null} | {action: true, message: "Ticket created successfully", data: {id: \<ticket.id\>, ticketNo: \<ticketNo\>}} | {action: false, message: \<error?.message || 'Failed to create ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:96 (SuperadminController.createSupportTicketOnBehalfOfAdmin) → src/superadmin/superadmin.service.ts:2983 (SuperadminService.createSupportTicketOnBehalfOfAdmin)

#### SA-137 **GET /superadmin/support/tickets/:id**

Get Support Ticket By Id

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Ticket fetched successfully", data: \<data\>} | {action: false, message: \<error?.message || 'Failed to fetch ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:105 (SuperadminController.getSupportTicketById) → src/superadmin/superadmin.service.ts:3097 (SuperadminService.getSupportTicketById)

#### SA-138 **POST /superadmin/support/tickets/:id/messages**

Reply Support Ticket

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body body · ReplySupportTicketDto · required · schema ReplySupportTicketDto \[src/superadmin/dto/reply-support-ticket.dto.ts\] · fields message?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "message is required and must be max 5000 characters", data: null} | {action: true, message: "Message sent successfully", data: {messageId: \<ticketMessage.id\>}} | {action: false, message: \<error?.message || 'Failed to send message'\>, data: null}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:113 (SuperadminController.replySupportTicket) → src/superadmin/superadmin.service.ts:3172 (SuperadminService.replySupportTicket)

#### SA-139 **PATCH /superadmin/support/tickets/:id/status**

Update Support Ticket Status

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateSupportTicketStatusDto · required · schema UpdateSupportTicketStatusDto \[src/superadmin/dto/update-support-ticket-status.dto.ts\] · fields status: TicketStatusEnum

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid status", data: null} | {action: true, message: "Ticket status updated successfully", data: \<updated\>} | {action: false, message: \<error?.message || 'Failed to update ticket status'\>, data: null}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:123 (SuperadminController.updateSupportTicketStatus) → src/superadmin/superadmin.service.ts:3274 (SuperadminService.updateSupportTicketStatus)

### Telemetry (1)

#### SA-140 **GET /superadmin/telemetry**

Lightweight telemetry snapshot straight from Redis live hash. Used by the frontend map to hydrate markers before Socket.IO connects. Optional ?imeis=IMEI1,IMEI2 to filter specific devices.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query imeis · string · optional · observed fields split · no DTO-enforced field contract ; query cursor · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Telemetry snapshot", data: \<Object.values\>} | {action: true, message: "Telemetry snapshot", data: \[\]} | {action: true, message: "Telemetry snapshot (paginated)", data: \<result.data\>, nextCursor: \<result.nextCursor\>, hasMore: \<result.hasMore\>, count: \<result.count\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:775 (SuperadminController.getTelemetrySnapshot) → src/superadmin/superadmin.service.ts:4461 (SuperadminService.getTelemetrySnapshot)

### Third-Party Integrations (11)

#### SA-141 **GET /superadmin/integrations**

List integrations with computed secret metadata (never exposes encryptedJson).

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · ListThirdPartyIntegrationsQueryDto · required · schema ListThirdPartyIntegrationsQueryDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields scope?: IntegrationScope; adminId?: number; category?: IntegrationCategory; provider?: IntegrationProvider

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Integrations listed", data: \<data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:862 (SuperadminController.listIntegrations) → src/superadmin/superadmin.service.ts:5242 (SuperadminService.listThirdPartyIntegrations)

#### SA-142 **POST /superadmin/integrations**

Create or update an integration (plus optionally rotate the secret).

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · UpsertThirdPartyIntegrationDto · required · schema UpsertThirdPartyIntegrationDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields scope: IntegrationScope; adminId?: number; category: IntegrationCategory; provider: IntegrationProvider; name: string; status?: IntegrationStatus; isDefault?: boolean; priority?: number; publicConfig?: any; secretJson?: any

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Integration upserted", data: {id: \<result.id\>, name: \<result.name\>, scope: \<result.scope\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:870 (SuperadminController.upsertIntegration) → src/superadmin/superadmin.service.ts:5323 (SuperadminService.upsertThirdPartyIntegration)

#### SA-143 **DELETE /superadmin/integrations/:id**

Delete an integration (cascades to secrets via Prisma onDelete). Restricted to GEOCODING category to avoid breaking platform services.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Integration deleted", data: {id: \<id\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:965 (SuperadminController.deleteIntegration) → src/superadmin/superadmin.service.ts:6648 (SuperadminService.deleteThirdPartyIntegration)

#### SA-144 **PATCH /superadmin/integrations/:id**

Update non-secret fields of an existing integration.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateThirdPartyIntegrationDto · required · schema UpdateThirdPartyIntegrationDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields status?: IntegrationStatus; isDefault?: boolean; priority?: number; publicConfig?: any; lastError?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Integration updated", data: {id: \<result.id\>, name: \<result.name\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:879 (SuperadminController.updateIntegration) → src/superadmin/superadmin.service.ts:5456 (SuperadminService.updateThirdPartyIntegration)

#### SA-145 **GET /superadmin/integrations/:id/openrouter/models**

Fetch available models from OpenRouter for a given integration. Returns a lightweight list suitable for a frontend dropdown.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "No active secret configured", data: {models: \[\]}} | {action: false, message: \<result.message\>, data: {models: \[\], diagnostics: \<result.diagnostics\>}} | {action: true, message: \<\`\${models.length} model(s) available\`\>, data: {models: \<models\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:927 (SuperadminController.getOpenRouterModels) → src/superadmin/superadmin.service.ts:6397 (SuperadminService.getOpenRouterModels)

#### SA-146 **POST /superadmin/integrations/:id/rotate-secret**

Rotate (replace) the secret for an existing integration.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · RotateThirdPartyIntegrationSecretDto · required · schema RotateThirdPartyIntegrationSecretDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields secretJson: any

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Secret rotated", data: {integrationId: \<id\>, version: \<secret.version\>, createdAt: \<secret.createdAt\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:888 (SuperadminController.rotateIntegrationSecret) → src/superadmin/superadmin.service.ts:5512 (SuperadminService.rotateThirdPartyIntegrationSecret)

#### SA-147 **POST /superadmin/integrations/:id/test-fcm**

Test an FCM integration by sending a push notification to a single device token via the Firebase Admin SDK.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · TestFcmIntegrationDto · required · schema TestFcmIntegrationDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields token: string; title?: string; body?: string; data?: any; targetPlatform?: FcmTargetPlatformInput; platform?: FcmTargetPlatformInput

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Test notification sent.", data: {messageId: \<result.messageId\>, diagnostics: \<diagnostics\>}} | {action: false, message: \<classified.userMessage\>, data: {error: \<classified.reason\>, errorCategory: \<classified.category\>, diagnostics: \<diagnostics\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:898 (SuperadminController.testFcmIntegration) → src/superadmin/superadmin.service.ts:5595 (SuperadminService.testFcmIntegration)

#### SA-148 **POST /superadmin/integrations/:id/test-openrouter**

Test an OpenRouter integration by sending a minimal chat completion. Supports enterprise fallback: tries models sequentially until one succeeds.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · TestOpenRouterIntegrationDto · required · schema TestOpenRouterIntegrationDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields model?: string; prompt?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OpenRouter validated", data: {usedModel: \<candidateModel\>, reply: \<reply\>, diagnostics: \<result.diagnostics\>, status: \<result.status\>}} | {action: false, message: "OpenRouter validation failed", data: {attempts: \<attempts\>, diagnostics: \<lastDiagnostics\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:935 (SuperadminController.testOpenRouterIntegration) → src/superadmin/superadmin.service.ts:6486 (SuperadminService.testOpenRouterIntegration)

#### SA-149 **POST /superadmin/integrations/:id/test-whatsapp**

Test a WhatsApp integration by sending a hello_world template message via the Meta WhatsApp Cloud API.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · TestWhatsAppIntegrationDto · required · schema TestWhatsAppIntegrationDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields phoneNumber: string; mode?: 'template' | 'custom' = 'template'; templateName?: string; languageCode?: string; message?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<result.errorMessage ?? 'WhatsApp send failed'\>, data: {httpStatus: \<(result.details as any)?.httpStatus ?? null\>, error: \<(result.details as any)?.error ?? null\>, diagnostics: \<(result.details as any)?.diagnostics ?? null\>}} | {action: true, message: "Test message sent successfully via WhatsApp.", data: {messageId: \<result.messageId\>, recipientPhone: \<recipientPhone\>, diagnostics: \<(result.details as any)?.diagnostics ?? null\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:917 (SuperadminController.testWhatsAppIntegration) → src/superadmin/superadmin.service.ts:5913 (SuperadminService.testWhatsAppIntegration)

#### SA-150 **POST /superadmin/integrations/:id/validate-geocoding**

Validate a GEOCODING integration by performing a real reverse-geocode call and persisting the validation status.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · ValidateGeocodingIntegrationDto · required · schema ValidateGeocodingIntegrationDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields lat: number; lng: number; language?: string; zoom?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Geocoding validated.", data: {provider: \<integration.provider\>, normalized: \<result.normalized\>, diagnostics: \<result.diagnostics\>}} | {action: false, message: \<result.message\>, data: {provider: \<integration.provider\>, httpStatus: \<result.status ?? null\>, diagnostics: \<result.diagnostics\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:955 (SuperadminController.validateGeocodingIntegration) → src/superadmin/superadmin.service.ts:5990 (SuperadminService.validateGeocodingIntegration)

#### SA-151 **POST /superadmin/integrations/:id/validate-google-sso**

Validate Google OAuth credentials by probing the Google token endpoint with a deliberately invalid authorization code.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · ValidateGoogleSsoDto · required · schema ValidateGoogleSsoDto \[src/superadmin/dto/third-party-integrations.dto.ts\] · fields redirectUri?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Client ID is not configured.", data: {checks: \<checks\>, redirectUriUsed: ""}} | {action: false, message: "No active secret found. Configure a Client Secret first.", data: {checks: \<checks\>, redirectUriUsed: ""}} | {action: false, message: "Failed to decrypt integration secret.", data: {checks: \<checks\>, redirectUriUsed: ""}} | {action: false, message: "Decrypted secret does not contain a clientSecret.", data: {checks: \<checks\>, redirectUriUsed: ""}} | {action: false, message: "No redirect URI available. Ensure the frontend sends the base URL.", data: {checks: \<checks\>, redirectUriUsed: ""}} | {action: false, message: "Rate limited by Google. Please try again later.", data: {checks: \<checks\>, redirectUriUsed: \<redirectUri\>, httpStatus: \<httpStatus\>}} | {action: false, message: "Invalid client credentials. Check your Client ID and Client Secret.", data: {checks: \<checks\>, redirectUriUsed: \<redirectUri\>, httpStatus: \<httpStatus\>}} | {action: false, message: "Unauthorized client. Verify OAuth consent screen and client configuration.", data: {checks: \<checks\>, redirectUriUsed: \<redirectUri\>, httpStatus: \<httpStatus\>}} | {action: false, message: \<\`Redirect URI mismatch. "\${redirectUri}" is not an authorized redirect URI in your Google Cloud project.\`\>, data: {checks: \<checks\>, redirectUriUsed: \<redirectUri\>, httpStatus: \<httpStatus\>}} | {action: true, message: \<msg\>, data: {checks: \<checks\>, redirectUriUsed: \<redirectUri\>, httpStatus: \<httpStatus\>}} | {action: false, message: \<\`Unexpected Google response: \${error || \`HTTP \${httpStatus}\`}\`\>, data: {checks: \<checks\>, redirectUriUsed: \<redirectUri\>, httpStatus: \<httpStatus\>}} | {action: false, message: \<safeMsg\>, data: {checks: \<checks\>, redirectUriUsed: \<dto.redirectUri?.trim() || ''\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:945 (SuperadminController.validateGoogleSsoIntegration) → src/superadmin/superadmin.service.ts:6126 (SuperadminService.validateGoogleSsoIntegration)

### Vehicles (11)

#### SA-152 **GET /superadmin/vehicles**

Get All Vehicles

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles fetched successfully", vehicles: \<data\>} | {action: false, message: \<error.message || 'Failed to fetch vehicles'\>, vehicles: \[\]}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:284 (SuperadminController.getAllVehicles) → src/superadmin/superadmin.service.ts:1540 (SuperadminService.getAllVehicles)

#### SA-153 **GET /superadmin/vehicles/:id**

Get Vehicle By Id

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found"} | {action: true, message: "Vehicle fetched successfully", data: \<vehicle\>} | {action: false, message: \<error.message || 'Failed to fetch vehicle'\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:289 (SuperadminController.getVehicleById) → src/superadmin/superadmin.service.ts:1637 (SuperadminService.getVehicleById)

#### SA-154 **GET /superadmin/vehicles/by-imei/:imei/commands**

Get Command History By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query limit · string · optional ; query cursorId · string · optional

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: true, message: "Command history retrieved", data: \<buildDeviceCommandLogListResponse\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:1034 (SuperadminController.getCommandHistoryByImei) → src/superadmin/superadmin.service.ts:6963 (SuperadminService.getCommandHistoryByImei)

#### SA-155 **GET /superadmin/vehicles/by-imei/:imei/details**

Get Vehicle Details By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: false, message: "Vehicle not found", data: null} | {action: true, message: "Vehicle details loaded", data: {vehicle: \<vehicle\>, telemetry: \<live ?? null\>, deviceStatus: \<deviceStatus\>, lastConnectionAt: \<lastConnectionAt\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:733 (SuperadminController.getVehicleDetailsByImei) → src/superadmin/superadmin.service.ts:4787 (SuperadminService.getVehicleDetailsByImei)

#### SA-156 **GET /superadmin/vehicles/by-imei/:imei/events**

GET /superadmin/vehicles/by-imei/:imei/events

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · MapEventsQueryDto · required · schema MapEventsQueryDto \[src/superadmin/dto/map-events.dto.ts\] · fields limit?: string; beforeId?: string; from?: string; to?: string; source?: string; severity?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle events loaded", data: \<result\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:995 (SuperadminController.getVehicleEventsByImei) → src/superadmin/superadmin.service.ts:6874 (SuperadminService.getVehicleEventsByImei)

#### SA-157 **GET /superadmin/vehicles/by-imei/:imei/history**

Get Vehicle History By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · required ; query to · string · required ; query stopMin · string · optional ; query overspeedKph · string · optional ; query maxPoints · string · optional

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: false, message: \<history.message\>, data: null} | {action: true, message: "History loaded", data: \<history.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:840 (SuperadminController.getVehicleHistoryByImei) → src/superadmin/superadmin.service.ts:5111 (SuperadminService.getVehicleHistoryByImei)

#### SA-158 **GET /superadmin/vehicles/by-imei/:imei/logs**

Get Vehicle Logs By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · optional ; query to · string · optional ; query limit · string · optional ; query beforeId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: {items: \[\], nextCursor: null}} | {action: false, message: "Invalid cursor", data: {items: \[\], nextCursor: null}} | {action: false, message: \<dateRange.message\>, data: {items: \[\], nextCursor: null}} | {action: true, message: "Telemetry logs loaded", data: {items: \<items\>, nextCursor: \<nextCursor\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:745 (SuperadminController.getVehicleLogsByImei) → src/superadmin/superadmin.service.ts:5007 (SuperadminService.getVehicleLogsByImei)

#### SA-159 **GET /superadmin/vehicles/by-imei/:imei/replay**

Get Vehicle Replay By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · required ; query to · string · required ; query maxPoints · string · optional

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: false, message: \<replay.message\>, data: null} | {action: true, message: "Replay data loaded", data: \<replay.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:826 (SuperadminController.getVehicleReplayByImei) → src/superadmin/superadmin.service.ts:5084 (SuperadminService.getVehicleReplayByImei)

#### SA-160 **POST /superadmin/vehicles/by-imei/:imei/send-command**

Send Device Command By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param imei · string · required ; body dto · SendDeviceCommandDto · required · schema SendDeviceCommandDto \[src/superadmin/dto/send-device-command.dto.ts\] · fields command: string; note?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: true, message: conditional, data: \<result\>}

**Errors:** NotFoundException; HttpException; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED; command was not dispatched\`; Error — \`Failed to dispatch command \${cmdId} via Redis: \${errorMessage}\`; Error; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED_OFFLINE\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:1007 (SuperadminController.sendDeviceCommandByImei) → src/superadmin/superadmin.service.ts:6896 (SuperadminService.sendDeviceCommandByImei)

#### SA-161 **GET /superadmin/vehicles/by-imei/:imei/sensors**

Fetch all sensors for a vehicle (by IMEI), compute each value using the VM sandbox, and return display-ready results. \`customJs\` is NEVER sent to the client.

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query includeTelemetryMeta · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: false, message: "Vehicle not found", data: null} | {action: true, message: "OK", data: \<data\>}

**Errors:** BadRequestException — code must be at least 5 characters; BadRequestException — Code too large; BadRequestException — payload must be a JSON object; BadRequestException — payload is not serialisable; BadRequestException — Payload too large; BadRequestException — Execution timed out; BadRequestException — safe. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/superadmin/superadmin.controller.ts:1052 (SuperadminController.getVehicleSensorsByImei) → src/superadmin/superadmin.service.ts:4880 (SuperadminService.getVehicleSensorsByImei)

#### SA-162 **GET /superadmin/vehicles/by-imei/:imei/trail**

Get Vehicle Trail By Imei

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query hours · string · optional ; query from · string · optional ; query to · string · optional ; query maxPoints · string · optional

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid IMEI", data: null} | {action: false, message: \<trail.message\>, data: null} | {action: true, message: "Vehicle trail loaded", data: \<trail.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/superadmin/superadmin.controller.ts:811 (SuperadminController.getVehicleTrailByImei) → src/superadmin/superadmin.service.ts:5057 (SuperadminService.getVehicleTrailByImei)

## Admin APIs

167 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Assignments (8)

#### ADM-001 **GET /admin/linkusers/:vehicleId**

Get Linked Users

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found or access denied"} | {action: true, message: "Linked users fetched successfully", data: \<users\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:800 (AdminController.getLinkedUsers) → src/admin/admin.service.ts:5443 (AdminService.getLinkedUsers)

#### ADM-002 **POST /admin/linkusers/:vehicleId**

Link Users

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; body userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: false, message: "Vehicle not found or access denied"} | {action: false, message: "Vehicle already linked to user"} | {action: true, message: "Vehicle linked to user successfully", data: \<link\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:804 (AdminController.linkUsers) → src/admin/admin.service.ts:5384 (AdminService.linkVehicleToUser)

#### ADM-003 **GET /admin/linkvehicles/:userId**

Get Linked Vehicles

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: true, message: "Linked vehicles fetched successfully", data: \<vehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:778 (AdminController.getLinkedVehicles) → src/admin/admin.service.ts:5298 (AdminService.getLinkedVehicles)

#### ADM-004 **POST /admin/linkvehicles/:userId**

Link Vehicles

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe ; body vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: false, message: "Vehicle not found or access denied"} | {action: false, message: "Vehicle already linked to user"} | {action: true, message: "Vehicle linked to user successfully", data: \<link\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:783 (AdminController.linkVehicles) → src/admin/admin.service.ts:5384 (AdminService.linkVehicleToUser)

#### ADM-005 **GET /admin/unlinkusers/:vehicleId**

Get Unlinked Users

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found or access denied"} | {action: true, message: "Unlinked users fetched successfully", data: \<users\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:809 (AdminController.getUnlinkedUsers) → src/admin/admin.service.ts:5473 (AdminService.getUnlinkedUsers)

#### ADM-006 **POST /admin/unlinkusers/:vehicleId**

Unlink Users

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; body userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: false, message: "Vehicle not found or access denied"} | {action: false, message: "Vehicle is not linked to user"} | {action: true, message: "Vehicle unlinked from user successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:813 (AdminController.unlinkUsers) → src/admin/admin.service.ts:5413 (AdminService.unlinkVehicleFromUser)

#### ADM-007 **GET /admin/unlinkvehicles/:userId**

Get Unlinked Vehicles

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: true, message: "Unlinked vehicles fetched successfully", data: \<vehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:789 (AdminController.getUnlinkedVehicles) → src/admin/admin.service.ts:5347 (AdminService.getUnlinkedVehicles)

#### ADM-008 **POST /admin/unlinkvehicles/:userId**

Unlink Vehicles

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe ; body vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: false, message: "Vehicle not found or access denied"} | {action: false, message: "Vehicle is not linked to user"} | {action: true, message: "Vehicle unlinked from user successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:794 (AdminController.unlinkVehicles) → src/admin/admin.service.ts:5413 (AdminService.unlinkVehicleFromUser)

### Calendar (3)

#### ADM-009 **GET /admin/calendar/day**

Get detailed calendar events for a specific day (admin-scoped) Returns lists of users created, vehicles created, and vehicles expiring.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · AdminCalendarDayDto · required · schema AdminCalendarDayDto \[src/admin/dto/calendar.dto.ts\] · fields date: string; types?: string; rk?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Day details fetched successfully", data: \<result\>} | {action: false, message: \<error?.message || 'Failed to fetch day details'\>, data: {date: \<date\>, usersCreated: \[\], vehiclesCreated: \[\], vehiclesExpiry: \[\]}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:971 (AdminController.getCalendarDayDetails) → src/admin/admin.service.ts:7126 (AdminService.getCalendarDayDetails)

#### ADM-010 **GET /admin/calendar/events**

Get calendar events aggregated by date for a given range (admin-scoped) Returns counts grouped by date and event type.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · AdminCalendarRangeDto · required · schema AdminCalendarRangeDto \[src/admin/dto/calendar.dto.ts\] · fields from: string; to: string; types?: string; rk?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Calendar events fetched successfully", data: {events: \<events\>}} | {action: false, message: \<error?.message || 'Failed to fetch calendar events'\>, data: {events: \[\]}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:963 (AdminController.getCalendarEvents) → src/admin/admin.service.ts:7041 (AdminService.getCalendarEvents)

#### ADM-011 **GET /admin/calendar/user/:uid**

Get detailed user info for calendar modal display (admin-scoped).

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param uid · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"} | {action: true, message: "User details fetched successfully", data: {uid: \<user.uid\>, name: \<user.name\>, email: \<user.email\>, phone: \<phone\>, username: \<user.username\>, loginType: \<user.loginType\>, isActive: \<user.isActive\>, createdAt: \<user.createdAt\>, addedByUser: \<user.parent\>}} | {action: false, message: \<error?.message || 'Failed to fetch user details'\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:979 (AdminController.getCalendarUserDetails) → src/admin/admin.service.ts:7229 (AdminService.getCalendarUserDetails)

### Company and Branding (8)

#### ADM-012 **PATCH /admin/companydetails**

Update Own Company Details

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body companyConfig · CompanyDto · required · schema CompanyDto \[src/admin/dto/company.dto.ts\] · fields name?: string; websiteUrl?: string; customDomain?: string; socialLinks?: Record\<string, string\>; primaryColor?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {message: "Nothing to update"} | {message: "Company config updated successfully", data: \<updated\>} | {message: "No data provided to create company config"} | {message: "Company config created successfully", data: \<created\>}

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:690 (AdminController.updateOwnCompanyDetails) → src/admin/admin.service.ts:1485 (AdminService.updateCompanyConfig)

#### ADM-013 **GET /admin/companydetails/:id**

Get Company Details

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<company\>

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:239 (AdminController.getCompanyDetails) → src/admin/admin.service.ts:1468 (AdminService.getCompanyDetails)

#### ADM-014 **PATCH /admin/companydetails/:id**

Update Company Details

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body companyConfig · CompanyDto · required · schema CompanyDto \[src/admin/dto/company.dto.ts\] · fields name?: string; websiteUrl?: string; customDomain?: string; socialLinks?: Record\<string, string\>; primaryColor?: string

**Response:** Global success envelope; observed result variants {message: "Nothing to update"} | {message: "Company config updated successfully", data: \<updated\>} | {message: "No data provided to create company config"} | {message: "Company config created successfully", data: \<created\>}

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:244 (AdminController.updateCompanyDetails) → src/admin/admin.service.ts:1485 (AdminService.updateCompanyConfig)

#### ADM-015 **PATCH /admin/companyinfo/:id**

Update Company Info

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body updateCompanydto · UpdateCompanyDto · required · schema UpdateCompanyDto \[src/admin/dto/updatecompany.dto.ts\] · fields name?: string; websiteUrl?: string; customDomain?: string; socialLinks?: Record\<string, string\>; primaryColor?: string; secondaryColor?: string; navbarColor?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<updatedCompany\>

**Errors:** Error; NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:587 (AdminController.updateCompanyInfo) → src/admin/admin.service.ts:4395 (AdminService.updateCompanyInfo)

#### ADM-016 **POST /admin/upload**

Upload File

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One file plus type=PROFILE|DARKLOGO|LIGHTLOGO|FAVICON. The superadmin variant targets the administrator identified by :id.

**Response:** Global success envelope; observed result variants \<result\> | {action: false, message: \<error.message || 'Upload failed'\>, data: null} | {message: "Upload failed", error: \<error.message\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:709 (AdminController.uploadFile) → src/admin/admin.service.ts:4621 (AdminService.uploadFile)

#### ADM-017 **GET /admin/whitelabel**

Get White Label Settings

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:941 (AdminController.getWhiteLabelSettings) → src/admin/admin.service.ts:5807 (AdminService.getWhiteLabelSettings)

#### ADM-018 **PATCH /admin/whitelabel**

Update White Label Settings

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** JSON or multipart. Multipart accepts up to three named logoLight/logoDark/favicon files plus customDomain, logoLightUrl, logoDarkUrl, faviconUrl, and primaryColor fields.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:951 (AdminController.updateWhiteLabelSettings) → src/admin/admin.service.ts:5830 (AdminService.updateWhiteLabelSettings)

#### ADM-019 **GET /admin/whitelabel/inspect**

Inspect White Label Branding

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query host · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Branding diagnostics fetched successfully", data: \<this.brandingUpdate.inspectBrandingByHost\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:946 (AdminController.inspectWhiteLabelBranding) → src/admin/admin.service.ts:5811 (AdminService.inspectWhiteLabelBranding)

### Dashboard (1)

#### ADM-020 **GET /admin/dashboard/summary**

Enterprise admin dashboard aggregation. Single endpoint returning all dashboard widgets in one round-trip.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · AdminDashboardSummaryDto · required · schema AdminDashboardSummaryDto \[src/admin/dto/admin-dashboard-summary.dto.ts\] · fields months?: number; listLimit?: number; currency?: string; rk?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Admin dashboard summary fetched successfully", data: {generatedAt: \<now.toISOString\>, selectedCurrency: \<selectedCurrency\>, defaultCurrency: \<defaultCurrency\>, availableCurrencies: \<availableCurrencies\>, currency: \<selectedCurrency\>, totals: {totalVehicles: \<totalVehicles\>, totalUsers: \<totalUsers\>}, revenue: {lastMonthRevenue: \<lastMonthRevenue\>, thisMonthRevenue: \<thisMonthRevenue\>, pendingAmount: \<pendingAmount\>, pendingCount: \<pendingCount\>, expectedRenewalRevenue: \<expectedRenewalRevenue\>, projectedThisMonth: \<projectedThisMonth\>}, expiry: {thisWeek: \<expiryThisWeek\>, thisMonth: \<expiryThisMonth\>, preview: \<filteredExpiryPreview.map\>}, installs: {thisMonth: \<deviceInstallsThisMonth\>}, vehicleLiveStatus: \<vehicleLiveStatus\>, graph: \<graph\>, graphMeta: \<graphMeta\>, topClients: \<topClients\>, recent: {users: \<recentUsers\>, vehicles: \<enrichedVehicles\>, payments: \<mappedPayments\>}}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:83 (AdminController.getDashboardSummary) → src/admin/admin.service.ts:453 (AdminService.getDashboardSummary)

### Device Commands (3)

#### ADM-021 **GET /admin/commands/:cmdId**

Get Command Log By Cmd Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required · observed fields length · no DTO-enforced field contract

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cmdId", data: null} | {action: false, message: "Command log not found", data: null} | {action: false, message: "You are not authorized to view this command", data: null} | {action: true, message: "Command log retrieved", data: \<serializeDeviceCommandLog\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1328 (AdminController.getCommandLogByCmdId) → src/admin/admin.service.ts:8743 (AdminService.getCommandLogByCmdId)

#### ADM-022 **GET /admin/commands/status/:cmdId**

Get Command Status

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required · observed fields length · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cmdId", data: null} | {action: false, message: "Command status not found or expired", data: null} | {action: true, message: "Command status retrieved", data: {cmdId: \<cmdId\>, ...: spread}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1309 (AdminController.getCommandStatus) → src/admin/admin.service.ts:8702 (AdminService.getCommandStatus)

#### ADM-023 **GET /admin/customcommands**

Get Custom Commands

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · CustomCommandsQueryDto · required · schema CustomCommandsQueryDto \[src/superadmin/dto/custom-commands-query.dto.ts\] · fields deviceTypeId?: string; commandTypeId?: string; activeOnly?: string; rk?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Custom Commands Fetched Successfully", data: \<customCommands\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1286 (AdminController.getCustomCommands) → src/admin/admin.service.ts:8625 (AdminService.getAdminCustomCommands)

### Devices (6)

#### ADM-024 **GET /admin/devices**

Get Devices

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Devices fetched successfully", data: \<devices\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:249 (AdminController.getDevices) → src/admin/admin.service.ts:1571 (AdminService.getDevices)

#### ADM-025 **POST /admin/devices**

Create Device

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body createDeviceDto · CreateDeviceDto · required · schema CreateDeviceDto \[src/admin/dto/createdevice.dto.ts\] · fields imei: string; deviceTypeId: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Device with this IMEI already exists"} | {action: true, message: conditional, data: \<newDevice\>, meta: {listenerRedisSynced: \<redisSynced\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:254 (AdminController.createDevice) → src/admin/admin.service.ts:1695 (AdminService.createDevice)

#### ADM-026 **DELETE /admin/devices/:id**

Delete Device

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Device not found"} | {action: false, message: "Device is linked to a vehicle and cannot be deleted"} | {action: true, message: \<\`Device \${device.imei} deleted successfully\`\>, meta: {listenerRedisSynced: \<redisSynced\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:263 (AdminController.deleteDevice) → src/admin/admin.service.ts:1667 (AdminService.deleteDevice)

#### ADM-027 **PATCH /admin/devices/:id**

Update Device

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body updateDeviceDto · UpdateDeviceDto · required · schema UpdateDeviceDto \[src/admin/dto/updatedevice.dto.ts\] · fields simId?: number | null; deviceTypeId?: number | null; isActive?: boolean; status?: DeviceInventoryStatusDto

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Device not found"} | {action: false, message: "SIM card is already assigned to another device"} | {action: true, message: "Device updated successfully", data: \<updatedDevice\>, meta: {listenerRedisSynced: \<redisSynced\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:258 (AdminController.updateDevice) → src/admin/admin.service.ts:1604 (AdminService.updateDevice)

#### ADM-028 **GET /admin/quickdevice**

Get Quick Devices

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Devices fetched successfully", data: \<devices\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:301 (AdminController.getQuickDevices) → src/admin/admin.service.ts:1939 (AdminService.getQuickDevices)

#### ADM-029 **POST /admin/quickdevice**

Create Quick Device

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body quickDeviceDto · QuickDeviceDto · required · schema QuickDeviceDto \[src/admin/dto/quickdevice.dto.ts\] · fields imei: string; deviceTypeId: number; simNumber: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid SIM number provided"} | {action: false, message: "Device with this IMEI already exists"} | {action: false, message: "Device is already in use"} | \<reused\> | {...: spread, meta: {listenerRedisSynced: \<redisSynced\>}} | \<result\> | {action: true, message: "Quick device created successfully", data: \<result\>, meta: {listenerRedisSynced: \<redisSynced\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:308 (AdminController.createQuickDevice) → src/admin/admin.service.ts:1805 (AdminService.createQuickDevice)

### Documents (6)

#### ADM-030 **GET /admin/documents/:userId**

Get Documents

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found or access denied"} | {action: true, message: "Documents fetched successfully", data: \<files\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:742 (AdminController.getDocuments) → src/admin/admin.service.ts:5146 (AdminService.getDocuments)

#### ADM-031 **GET /admin/documents/driver/:driverId**

Get Driver Documents

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param driverId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found or access denied"} | {action: true, message: "Driver documents fetched successfully", data: \<files\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:755 (AdminController.getDriverDocuments) → src/admin/admin.service.ts:5197 (AdminService.getDriverDocuments)

#### ADM-032 **GET /admin/documents/vehicle/:vehicleId**

Get Vehicle Documents

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found or access denied"} | {action: true, message: "Vehicle documents fetched successfully", data: \<files\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:747 (AdminController.getVehicleDocuments) → src/admin/admin.service.ts:5172 (AdminService.getVehicleDocuments)

#### ADM-033 **POST /admin/uploaddoc**

Upload Document

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Request must be multipart/form-data' } as any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:723 (AdminController.uploadDocument) → src/admin/admin.service.ts:4962 (AdminService.uploadDocumentMultipart)

#### ADM-034 **DELETE /admin/uploaddoc/:id**

Delete Document

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Document not found"} | {action: false, message: "Access denied to delete this document"} | {action: true, message: "Document deleted successfully", data: \<updated\>}

**Errors:** Error — err ?? new Error('Unknown error'). Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:733 (AdminController.deleteDocument) → src/admin/admin.service.ts:5114 (AdminService.deleteDocument)

#### ADM-035 **PATCH /admin/uploaddoc/:id**

Update Document

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Request must be multipart/form-data' } as any\> | \<updatedResult\> | {action: true, message: "Document updated successfully", data: \<updatedWithFile\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:728 (AdminController.updateDocument) → src/admin/admin.service.ts:5056 (AdminService.updateDocumentMultipartWithAuth)

### Drivers (10)

#### ADM-036 **GET /admin/drivers**

Get Drivers

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Drivers fetched successfully", data: \<drivers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:562 (AdminController.getDrivers) → src/admin/admin.service.ts:4035 (AdminService.getDrivers)

#### ADM-037 **POST /admin/drivers**

Create Driver

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body CreateDriverDto · CreateDriverDto · required · schema CreateDriverDto \[src/admin/dto/createdriver.dto.ts\] · fields name: string; mobilePrefix: string; mobile: string; email?: string; primaryUserid: string | number; username: string; password: string; countryCode: string; stateCode?: string; city?: string; address?: string; pincode?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Username is required"} | {action: false, message: "Invalid primary user id"} | {action: false, message: \<\`Driver with this \${field} already exists\`\>} | {action: true, message: "Driver created successfully", data: \<newDriver\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:557 (AdminController.createDriver) → src/admin/admin.service.ts:3951 (AdminService.createDriver)

#### ADM-038 **DELETE /admin/drivers/:id**

Delete Driver

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: true, message: "Driver deleted successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:582 (AdminController.deleteDriver) → src/admin/admin.service.ts:4264 (AdminService.deleteDriver)

#### ADM-039 **GET /admin/drivers/:id**

Get Driver By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: true, message: "Driver fetched successfully", data: \<driver\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:567 (AdminController.getDriverById) → src/admin/admin.service.ts:4054 (AdminService.getDriverById)

#### ADM-040 **PATCH /admin/drivers/:id**

Update Driver

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body UpdateDriverDto · UpdateDriverDto · required · schema UpdateDriverDto \[src/admin/dto/updatedriver.dto.ts\] · fields name?: string; mobilePrefix?: string; mobile?: string; email?: string; username?: string; password?: string; countryCode?: string; StateCode?: string; city?: string; address?: string; pincode?: string; isactive?: string; attributes?: Record\<string, any\> | string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "Username already exists"} | {action: false, message: "Email already exists"} | {action: false, message: "Mobile number already exists"} | \<updatedDriver\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:577 (AdminController.updateDriver) → src/admin/admin.service.ts:4151 (AdminService.updateDriver)

#### ADM-041 **GET /admin/drivers/:id/users**

Get Driver Users

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: true, message: "Users fetched successfully", data: \<usersList\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:572 (AdminController.getDriverUsers) → src/admin/admin.service.ts:4079 (AdminService.getDriverUsers)

#### ADM-042 **GET /admin/drivers/linkedusers/:driverId**

Get Linked Users For Driver

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param driverId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: true, message: "Users fetched successfully", data: \<usersList\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:819 (AdminController.getLinkedUsersForDriver) → src/admin/admin.service.ts:4282 (AdminService.getLinkedUsersForDriver)

#### ADM-043 **POST /admin/drivers/linkedusers/:driverId**

Link Users To Driver

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param driverId · number · required · pipes ParseIntPipe ; body userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "User not found"} | {action: false, message: "Driver-User link already exists"} | {action: true, message: "Driver linked to user successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:827 (AdminController.linkUsersToDriver) → src/admin/admin.service.ts:4342 (AdminService.linkDriverToUser)

#### ADM-044 **GET /admin/drivers/unlinkedusers/:driverId**

Get Unlinked Users For Driver

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param driverId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: true, message: "Users fetched successfully", data: \<unlinkedUsers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:823 (AdminController.getUnlinkedUsersForDriver) → src/admin/admin.service.ts:4310 (AdminService.getUnlinkedUsersForDriver)

#### ADM-045 **POST /admin/drivers/unlinkedusers/:driverId**

Unlink Users From Driver

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param driverId · number · required · pipes ParseIntPipe ; body userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "User not found"} | {action: false, message: "Driver is not linked to this user"} | {action: true, message: "Driver unlinked from user successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:832 (AdminController.unlinkUsersFromDriver) → src/admin/admin.service.ts:4370 (AdminService.unlinkDriverFromUser)

### Drivers and Bulk Jobs (4)

#### ADM-046 **POST /admin/driverbulkjobs**

Create Driver Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateDriverBulkJobDto · required · schema CreateDriverBulkJobDto \[src/admin/dto/driverbulkjobs.dto.ts\] · fields primaryUserId: string; rows: DriverBulkJobRowDto\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Bulk job created", data: \<created\>} | {id: \<id\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:838 (AdminController.createDriverBulkJob) → src/admin/driver-bulk-jobs.service.ts:144 (DriverBulkJobsService.createJob)

#### ADM-047 **GET /admin/driverbulkjobs/:id**

Get Driver Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found"} | {action: true, message: "Job fetched", data: \<job\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:844 (AdminController.getDriverBulkJob) → src/admin/driver-bulk-jobs.service.ts:196 (DriverBulkJobsService.getJob)

#### ADM-048 **GET /admin/driverbulkjobs/:id/failed.csv**

Download Driver Failed Csv

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants void | null | {filename: \<\`driver-bulk-failed-\${jobId}.csv\`\>, csv: \<csv\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:851 (AdminController.downloadDriverFailedCsv) → src/admin/driver-bulk-jobs.service.ts:208 (DriverBulkJobsService.getFailedCsv)

#### ADM-049 **GET /admin/driverbulkjobs/:id/stream**

Stream Driver Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Stream:** Server-Sent Events with event names job_state, log, row, progress, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void | null | \<job.emitter\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:869 (AdminController.streamDriverBulkJob) → src/admin/driver-bulk-jobs.service.ts:202 (DriverBulkJobsService.getEmitter) → src/admin/driver-bulk-jobs.service.ts:196 (DriverBulkJobsService.getJob)

### Email and SMTP (1)

#### ADM-050 **POST /admin/testsmtp**

Test Smtp Settings

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body email · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:608 (AdminController.testSmtpSettings) → src/admin/admin.service.ts:4553 (AdminService.testSmtpSettings)

### Live Map and Telemetry (2)

#### ADM-051 **GET /admin/map-events**

Get Map Events

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · MapEventsQueryDto · required · schema MapEventsQueryDto \[src/superadmin/dto/map-events.dto.ts\] · fields limit?: string; beforeId?: string; from?: string; to?: string; source?: string; severity?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Map events loaded", data: \<result\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1132 (AdminController.getMapEvents) → src/admin/admin.service.ts:8041 (AdminService.getMapEvents)

#### ADM-052 **GET /admin/map-telemetry**

Get Map Telemetry

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query cursor · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Map telemetry fetched", data: {items: \<items\>, cursor: \<nextCursor\>, nextCursor: \<nextCursor\>, hasMore: \<hasMore\>, count: \<items.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1122 (AdminController.getMapTelemetry) → src/admin/admin.service.ts:7807 (AdminService.getMapTelemetry)

### Logs and Audit (6)

#### ADM-053 **GET /admin/logs/activity**

GET /admin/logs/activity Activity logs across all users under this admin (including admin itself).

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · AdminActivityLogsDto · required · schema AdminActivityLogsDto \[src/admin/dto/admin-activity-logs.dto.ts\] · fields limit?: number; cursorId?: number; from?: string; to?: string; q?: string; userId?: number; actionPrefix?: string; entity?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \<items\>, nextCursorId: \<nextCursorId\>, hasMore: \<hasMore\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1078 (AdminController.getActivityLogs) → src/admin/admin.service.ts:7411 (AdminService.getActivityLogs)

#### ADM-054 **GET /admin/logs/events**

GET /admin/logs/events VehicleNotificationLog scoped to admin's vehicles with optional dedupe.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · AdminEventLogsDto · required · schema AdminEventLogsDto \[src/admin/dto/admin-event-logs.dto.ts\] · fields limit?: number; cursorId?: number; from?: string; to?: string; vehicleId?: number; userId?: number; source?: string; severity?: string; isRead?: boolean; q?: string; dedupe?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \<items\>, nextCursorId: \<nextCursorId\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1086 (AdminController.getEventLogs) → src/admin/admin.service.ts:7491 (AdminService.getEventLogs)

#### ADM-055 **GET /admin/logs/events/:id**

GET /admin/logs/events/:id Single VehicleNotificationLog with delivery details.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<row\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1094 (AdminController.getEventLogById) → src/admin/admin.service.ts:7596 (AdminService.getEventLogById)

#### ADM-056 **GET /admin/logs/options**

GET /admin/logs/options Returns minimal dropdown data for the logs explorer UI.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {users: \<users\>, vehicles: \<vehicles\>, sources: \<sources\>, packetTypes: \<packetTypes\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1073 (AdminController.getLogsOptions) → src/admin/admin.service.ts:7380 (AdminService.getLogsOptions)

#### ADM-057 **GET /admin/logs/telemetry**

GET /admin/logs/telemetry Telemetry logs scoped to admin's vehicles (by IMEI).

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · AdminTelemetryLogsDto · required · schema AdminTelemetryLogsDto \[src/admin/dto/admin-telemetry-logs.dto.ts\] · fields limit?: number; beforeId?: string; from?: string; to?: string; vehicleId?: number; imei?: string; packetType?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \[\], nextCursor: null}} | {action: false, message: "Invalid cursor", data: {items: \[\], nextCursor: null}} | {action: false, message: \<dateRange.message\>, data: {items: \[\], nextCursor: null}} | {action: true, message: "OK", data: {items: \<items\>, nextCursor: \<nextCursor\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1102 (AdminController.getTelemetryLogs) → src/admin/admin.service.ts:7630 (AdminService.getTelemetryLogs)

#### ADM-058 **GET /admin/logs/telemetry/:id**

GET /admin/logs/telemetry/:id Single telemetry log row (BigInt id passed as string).

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants void | {action: true, message: "OK", data: \<this.serializeTelemetryRow\>}

**Errors:** HttpException; NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1110 (AdminController.getTelemetryLogById) → src/admin/admin.service.ts:7695 (AdminService.getTelemetryLogById)

### Notification Campaigns (9)

#### ADM-059 **GET /admin/notify/campaigns**

List Campaigns

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · NotifyCampaignQueryDto · required · schema NotifyCampaignQueryDto \[src/notify/dto/notify-campaign-query.dto.ts\] · fields status?: NotifyCampaignStatus; channel?: NotificationChannel; search?: string; limit?: number = 20; cursor?: number; page?: number; from?: string; to?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {items: \<pageRows.map\>, nextCursor: conditional, summary: \<summary\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/admin-notify.controller.ts:54 (AdminNotifyController.listCampaigns) → src/notify/notify.service.ts:186 (NotifyService.listCampaigns)

#### ADM-060 **POST /admin/notify/campaigns**

Create Campaign

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateNotifyCampaignDto · required · schema CreateNotifyCampaignDto \[src/notify/dto/create-notify-campaign.dto.ts\] · fields audienceType: NotifyAudienceType; selectedUserIds?: number\[\]; filters?: NotifyAudienceFiltersDto; channels: NotificationChannel\[\]; subject: string; message: string; category: UserNotificationCategory; severity?: NotificationSeverity; ctaLabel?: string | null; ctaUrl?: string | null; scheduledAt?: string | null ; headers idempotency-key · string | undefined · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** Error; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/notify/admin-notify.controller.ts:43 (AdminNotifyController.createCampaign) → src/notify/notify.service.ts:61 (NotifyService.createCampaign)

#### ADM-061 **DELETE /admin/notify/campaigns/:id**

Delete Campaign

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {deleted: true, id: \<campaign.id\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/notify/admin-notify.controller.ts:70 (AdminNotifyController.deleteCampaign) → src/notify/notify.service.ts:304 (NotifyService.deleteCampaign)

#### ADM-062 **GET /admin/notify/campaigns/:id**

Get Campaign

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {id: \<campaign.id\>, subject: \<campaign.subject\>, message: \<campaign.message\>, category: \<campaign.category\>, severity: \<campaign.severity\>, status: \<this.deriveStatus\>, audienceType: \<campaign.audienceType\>, filters: \<campaign.filters ?? null\>, selectedUserIds: conditional, selectedUserIdsCount: conditional, channels: \<this.parseChannels\>, channelSummary: \<this.buildChannelSummary\>, totalRecipients: \<recipientCount\>, totalDeliveries: \<deliveryCount\>, sentCount: \<stats?.sentCount ?? campaign.sentCount\>, failedCount: \<stats?.failedCount ?? campaign.failedCount\>, pendingCount: \<stats?.pendingCount ?? Math.max(0, deliveryCount - campaign.sentCount - campaign.failedCount)\>, readCount: \<readCount\>, skippedCount: \<skippedCount\>, createdBy: {id: \<campaign.sender.uid\>, name: \<campaign.sender.name\>, email: \<this.maskEmail\>}, scheduledAt: \<campaign.scheduledAt\>, queuedAt: \<campaign.queuedAt\>, startedAt: \<campaign.startedAt\>, completedAt: \<campaign.completedAt\>, createdAt: \<campaign.createdAt\>, updatedAt: \<campaign.updatedAt\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/notify/admin-notify.controller.ts:62 (AdminNotifyController.getCampaign) → src/notify/notify.service.ts:230 (NotifyService.getCampaign)

#### ADM-063 **GET /admin/notify/campaigns/:id/deliveries**

List Campaign Deliveries

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; query query · NotifyDeliveriesQueryDto · required · schema NotifyDeliveriesQueryDto \[src/notify/dto/notify-deliveries-query.dto.ts\] · fields channel?: NotificationChannel; status?: NotificationDeliveryStatus; failureOnly?: boolean; recipientSearch?: string; limit?: number = 25; cursor?: number; page?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {items: \<pageRows.map\>, nextCursor: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/admin-notify.controller.ts:88 (AdminNotifyController.listCampaignDeliveries) → src/notify/notify.service.ts:344 (NotifyService.listCampaignDeliveries)

#### ADM-064 **GET /admin/notify/campaigns/:id/recipients**

List Campaign Recipients

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; query query · NotifyCampaignRecipientsQueryDto · required · schema NotifyCampaignRecipientsQueryDto \[src/notify/dto/notify-campaign-recipients-query.dto.ts\] · fields search?: string; status?: NotifyCampaignRecipientStatusFilter; read?: NotifyRecipientReadFilter; channel?: NotificationChannel; limit?: number = 25; cursor?: number; page?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {items: \<pageRows.map\>, nextCursor: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/admin-notify.controller.ts:79 (AdminNotifyController.listCampaignRecipients) → src/notify/notify.service.ts:432 (NotifyService.listCampaignRecipients)

#### ADM-065 **GET /admin/notify/capabilities**

Get Capabilities

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/admin-notify.controller.ts:21 (AdminNotifyController.getCapabilities) → src/notify/notify.service.ts:49 (NotifyService.getCapabilities)

#### ADM-066 **GET /admin/notify/recipients**

List Recipients

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · AdminNotifyRecipientsQueryDto · required · schema AdminNotifyRecipientsQueryDto \[src/notify/dto/notify-recipients-query.dto.ts\] · fields type: NotifyListAudienceType; search?: string; adminId?: number; status?: NotifyRecipientStatusFilter; limit?: number = 25; cursor?: number; type?: NotifyListAudienceType = 'USERS'

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/admin-notify.controller.ts:26 (AdminNotifyController.listRecipients) → src/notify/notify.service.ts:53 (NotifyService.listRecipients)

#### ADM-067 **POST /admin/notify/recipients/estimate**

Estimate Recipients

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · EstimateNotifyRecipientsDto · required · schema EstimateNotifyRecipientsDto \[src/notify/dto/create-notify-campaign.dto.ts\] · fields audienceType: NotifyAudienceType; selectedUserIds?: number\[\]; filters?: NotifyAudienceFiltersDto; channels: NotificationChannel\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type untyped

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/notify/admin-notify.controller.ts:34 (AdminNotifyController.estimateRecipients) → src/notify/notify.service.ts:57 (NotifyService.estimateRecipients)

### Notifications (3)

#### ADM-068 **GET /admin/notifications**

Get Notifications

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query limit · string · optional ; query beforeId · string · optional ; query unreadOnly · string · optional ; query category · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \<items\>, nextCursor: \<nextCursor\>, unreadCount: \<unreadCount\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1256 (AdminController.getNotifications) → src/admin/admin.service.ts:8546 (AdminService.getNotifications)

#### ADM-069 **PATCH /admin/notifications/:id/read**

Mark Notification Read

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {id: \<notificationId\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1274 (AdminController.markNotificationRead) → src/admin/admin.service.ts:8590 (AdminService.markNotificationRead)

#### ADM-070 **PATCH /admin/notifications/read-all**

Mark All Notifications Read

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {updatedCount: \<result.count\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1267 (AdminController.markAllNotificationsRead) → src/admin/admin.service.ts:8608 (AdminService.markAllNotificationsRead)

### Platform Configuration (2)

#### ADM-071 **GET /admin/config**

Get Admin Config

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Configuration fetched successfully", data: {allowSignup: \<company?.allowSignup ?? true\>, signupCredits: \<company?.signupCredits ?? 0\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:699 (AdminController.getAdminConfig) → src/admin/admin.service.ts:1106 (AdminService.getAdminConfig)

#### ADM-072 **PATCH /admin/config**

Patch Admin Config

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body configDto · AdminConfigDto · required · schema AdminConfigDto \[src/admin/dto/adminconfig.dto.ts\] · fields allowSignup?: boolean; signupCredits?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Nothing to update"} | {action: true, message: "Configuration updated successfully", data: {allowSignup: \<updated.allowSignup\>, signupCredits: \<updated.signupCredits\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:704 (AdminController.patchAdminConfig) → src/admin/admin.service.ts:1123 (AdminService.updateAdminConfig)

### Pricing and Billing (8)

#### ADM-073 **GET /admin/payments**

List payments where USER paid ADMIN (user→admin). This is for the "Payments" page in admin panel. Scoped to fromUser.loginType = USER (or SUBUSER).

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query userId · string · optional ; query status · string · optional ; query from · string · optional ; query to · string · optional ; query q · string · optional ; query page · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>} | {page: \<page\>, limit: \<limit\>, total: \<total\>, items: \<mapped\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1022 (AdminController.listAdminPayments) → src/admin/admin.service.ts:3377 (AdminService.listAdminPayments)

#### ADM-074 **POST /admin/payments/renew**

Renew multiple vehicles for a user. Creates ONE single transaction record for the entire payment and extends vehicle secondaryExpiry. Atomic via Prisma \$transaction.

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · AdminRenewVehiclesDto · required · schema AdminRenewVehiclesDto \[src/admin/dto/admin-transactions.dto.ts\] · fields userId: number; vehicleIds: number\[\]; paymentMode?: PaymentMode; reference?: string; amountOverride?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles renewed successfully", data: \<data\>} | {transaction: \<result.transaction\>, updatedVehicles: \<result.updatedVehicles\>, validationWarnings: conditional}

**Errors:** HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1037 (AdminController.renewVehiclesPayment) → src/admin/admin.service.ts:3606 (AdminService.renewVehicles)

#### ADM-075 **GET /admin/pricingplans**

Get Pricing Plans

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Pricing plans fetched successfully", data: \<plans\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:763 (AdminController.getPricingPlans) → src/admin/admin.service.ts:5223 (AdminService.getPricingPlans)

#### ADM-076 **POST /admin/pricingplans**

Create Pricing Plan

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body createPricingPlanDto · CreatePricingPlanDto · required · schema CreatePricingPlanDto \[src/admin/dto/createpricingplan.dto.ts\] · fields name: string; durationDays: number; price: number; currency: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Pricing plan created successfully", data: \<created\>}

**Errors:** ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:768 (AdminController.createPricingPlan) → src/admin/admin.service.ts:5232 (AdminService.createPricingPlan)

#### ADM-077 **PATCH /admin/pricingplans/:id**

Update Pricing Plan

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body updatePricingPlanDto · CreatePricingPlanDto · required · schema CreatePricingPlanDto \[src/admin/dto/createpricingplan.dto.ts\] · fields name: string; durationDays: number; price: number; currency: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Pricing plan not found"} | {action: false, message: "Another pricing plan with the same name already exists"} | {action: true, message: "Pricing plan updated successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:773 (AdminController.updatePricingPlan) → src/admin/admin.service.ts:5263 (AdminService.updatePricingPlan)

#### ADM-078 **GET /admin/transactions**

List transactions where ADMIN paid SUPERADMIN (admin→superadmin). This is for the "Transactions" page in admin panel.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query status · string · optional ; query from · string · optional ; query to · string · optional ; query q · string · optional ; query page · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>} | {page: \<page\>, limit: \<limit\>, total: 0, items: \[\]} | {page: \<page\>, limit: \<limit\>, total: \<total\>, items: \<mapped\>}

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:991 (AdminController.listAdminTransactions) → src/admin/admin.service.ts:3267 (AdminService.listTransactions)

#### ADM-079 **GET /admin/transactions/analytics**

Analytics for admin transactions (where USER paid ADMIN). Returns summary + daily chart series for SUCCESS transactions.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query userId · string · optional ; query from · string · optional ; query to · string · optional ; query month · string · optional ; query year · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>} | {range: {start: \<rangeStart.toISOString\>, end: \<rangeEnd.toISOString\>}, totalTransactions: \<rows.length\>, totalsByCurrency: \<totals\>, statusBreakdown: \<statusBreakdown\>, modeBreakdown: \<modes\>, dailySeriesByCurrency: \<dailySeriesByCurrency\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1005 (AdminController.transactionsAnalytics) → src/admin/admin.service.ts:3479 (AdminService.transactionsAnalytics)

#### ADM-080 **POST /admin/transactions/renew**

Renew multiple vehicles for a user. Creates ONE single transaction record for the entire payment and extends vehicle secondaryExpiry. Atomic via Prisma \$transaction.

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · AdminRenewVehiclesDto · required · schema AdminRenewVehiclesDto \[src/admin/dto/admin-transactions.dto.ts\] · fields userId: number; vehicleIds: number\[\]; paymentMode?: PaymentMode; reference?: string; amountOverride?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles renewed successfully", data: \<data\>} | {transaction: \<result.transaction\>, updatedVehicles: \<result.updatedVehicles\>, validationWarnings: conditional}

**Errors:** HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1047 (AdminController.renewVehicles) → src/admin/admin.service.ts:3606 (AdminService.renewVehicles)

### Profile and Security (10)

#### ADM-081 **GET /admin/profile**

Get Profile

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Admin not found", data: null} | {action: true, message: "Profile fetched successfully", data: \<admin\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:630 (AdminController.getProfile) → src/admin/admin.service.ts:5621 (AdminService.getProfile)

#### ADM-082 **PATCH /admin/profile**

Update Profile

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body profileDto · ProfileDto · required · schema ProfileDto \[src/superadmin/dto/profile.dto.ts\] · fields name: string; email?: string; mobilePrefix: string; mobileNumber: string; addressLine: string; countryCode: string; stateCode: string; cityName: string; pincode?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Admin not found"} | {action: true, message: "Profile updated successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:635 (AdminController.updateProfile) → src/admin/admin.service.ts:5673 (AdminService.updateProfile)

#### ADM-083 **GET /admin/profile/email-subscription**

Resolve brand owner + SMTP owner for a recipient user.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, data: {isSubscribed: \<subscribed\>, brandOwnerId: \<brandOwnerId\>, scope: \<scope\>}} | \<result\> | \<cached === SUBSCRIBED\> | \<subscribed\>

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:668 (AdminController.getEmailSubscription) → src/email/services/email-context.resolver.ts:97 (EmailContextResolver.resolveContextForRecipient) → src/email/services/email-subscription.service.ts:57 (EmailSubscriptionService.ensureSubscription) → src/email/services/email-subscription.service.ts:89 (EmailSubscriptionService.isSubscribed)

#### ADM-084 **POST /admin/profile/email-subscription/subscribe**

Resolve brand owner + SMTP owner for a recipient user.

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Subscribed", data: {isSubscribed: true}} | \<result\>

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:679 (AdminController.subscribeEmail) → src/email/services/email-context.resolver.ts:97 (EmailContextResolver.resolveContextForRecipient) → src/email/services/email-subscription.service.ts:202 (EmailSubscriptionService.subscribe)

#### ADM-085 **POST /admin/profile/verify/email/confirm**

Verify an email OTP.

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · VerifyOtpDto · required · schema VerifyOtpDto \[src/verification/dto/verify-otp.dto.ts\] · fields otp: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Email verified successfully"}

**Errors:** HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:649 (AdminController.verifyEmailOtp) → src/verification/verification.service.ts:171 (VerificationService.verifyEmailOtp)

#### ADM-086 **POST /admin/profile/verify/email/request**

Generate and send an email OTP to the user's registered email.

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "SMTP is not configured. Please configure SMTP before sending email OTP.", data: {code: "SMTP_NOT_CONFIGURED"}} | {action: false, message: "Email verification code could not be sent. Please try again later.", data: {code: "EMAIL_DELIVERY_FAILED"}} | {action: true, message: \<\`Verification code sent to \${this.maskEmail(user.email)}\`\>, data: {expiresInSeconds: \<this.otpTtl\>}}

**Errors:** NotFoundException; HttpException; Error; Error — \`Cannot send email: recipient \${recipientUserId} has no email address\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:644 (AdminController.requestEmailOtp) → src/verification/verification.service.ts:74 (VerificationService.requestEmailOtp)

#### ADM-087 **POST /admin/profile/verify/whatsapp/confirm**

Verify a WhatsApp OTP.

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · VerifyOtpDto · required · schema VerifyOtpDto \[src/verification/dto/verify-otp.dto.ts\] · fields otp: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Mobile number verified successfully"}

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:659 (AdminController.verifyWhatsAppOtp) → src/verification/verification.service.ts:364 (VerificationService.verifyWhatsAppOtp)

#### ADM-088 **POST /admin/profile/verify/whatsapp/request**

Generate and send a WhatsApp OTP to the user's registered mobile.

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "WhatsApp Meta API is not configured. Please configure WhatsApp integration before sending OTP.", data: {code: \<code\>}} | {action: false, message: "Failed to send WhatsApp verification code. Please try again later.", data: {code: \<(code as string) ?? 'WHATSAPP_SEND_FAILED'\>}} | {action: false, message: "Failed to send WhatsApp verification code. Please try again later.", data: {diagnostics: \<sendResult.diagnostics\>}} | {action: true, message: \<\`Verification code sent to \${this.maskPhone(phone)}\`\>, data: {expiresInSeconds: \<this.otpTtl\>}}

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:654 (AdminController.requestWhatsAppOtp) → src/verification/verification.service.ts:233 (VerificationService.requestWhatsAppOtp)

#### ADM-089 **PATCH /admin/updatepassword**

Patch Password Admin

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body body · { currentPassword: string, newPassword: string } · required · fields currentPassword: string; newPassword: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Admin user not found"} | {action: true, message: "Password updated successfully"}

**Errors:** UnauthorizedException; UnauthorizedException — Invalid user identity; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:620 (AdminController.patchPasswordAdmin) → src/admin/admin.service.ts:4558 (AdminService.updateAdminPassword)

#### ADM-090 **POST /admin/updatepassword**

Update Password Admin

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body body · { currentPassword: string, newPassword: string } · required · fields currentPassword: string; newPassword: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Admin user not found"} | {action: true, message: "Password updated successfully"}

**Errors:** UnauthorizedException; UnauthorizedException — Invalid user identity; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:613 (AdminController.updatePasswordAdmin) → src/admin/admin.service.ts:4558 (AdminService.updateAdminPassword)

### SIM and Inventory (11)

#### ADM-091 **POST /admin/deviceandsim**

Create Device And Sim

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · DeviceAndSimDto · required · schema DeviceAndSimDto \[src/admin/dto/deviceandsim.dto.ts\] · fields imei: string; deviceTypeId: number; simNumber: string; imsi?: string; providerId?: string; iccid?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<result\> | {...: spread, meta: {listenerRedisSynced: \<redisSynced\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:283 (AdminController.createDeviceAndSim) → src/admin/admin.service.ts:1728 (AdminService.createDeviceAndSim)

#### ADM-092 **POST /admin/inventorybulkjobs**

Create Inventory Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateInventoryBulkJobDto · required · schema CreateInventoryBulkJobDto \[src/admin/dto/inventorybulkjobs.dto.ts\] · fields target: InventoryBulkTarget; deviceTypeId?: string; providerId?: string; rows: InventoryBulkJobRowDto\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Bulk job created", data: \<created\>} | {id: \<id\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:369 (AdminController.createInventoryBulkJob) → src/admin/inventory-bulk-jobs.service.ts:113 (InventoryBulkJobsService.createJob)

#### ADM-093 **GET /admin/inventorybulkjobs/:id**

Get Inventory Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found"} | {action: true, message: "Job fetched", data: \<job\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:375 (AdminController.getInventoryBulkJob) → src/admin/inventory-bulk-jobs.service.ts:169 (InventoryBulkJobsService.getJob)

#### ADM-094 **GET /admin/inventorybulkjobs/:id/failed.csv**

Download Inventory Failed Csv

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants void | null | {filename: \<\`inventory-bulk-failed-\${jobId}.csv\`\>, csv: \<csv\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:382 (AdminController.downloadInventoryFailedCsv) → src/admin/inventory-bulk-jobs.service.ts:181 (InventoryBulkJobsService.getFailedCsv)

#### ADM-095 **GET /admin/inventorybulkjobs/:id/stream**

Stream Inventory Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Stream:** Server-Sent Events with event names job_state, log, row, progress, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void | null | \<job.emitter\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:400 (AdminController.streamInventoryBulkJob) → src/admin/inventory-bulk-jobs.service.ts:175 (InventoryBulkJobsService.getEmitter) → src/admin/inventory-bulk-jobs.service.ts:169 (InventoryBulkJobsService.getJob)

#### ADM-096 **GET /admin/quicksimcards**

Get Quick Sim Cards

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "SIM cards fetched successfully", data: \<simcards\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:314 (AdminController.getQuickSimCards) → src/admin/admin.service.ts:1954 (AdminService.getQuickSimCards)

#### ADM-097 **GET /admin/simcards**

Get Sim Cards

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "SIM cards fetched successfully", data: \<simcards\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:268 (AdminController.getSimCards) → src/admin/admin.service.ts:1967 (AdminService.getSimCards)

#### ADM-098 **POST /admin/simcards**

Create Sim Card

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body CreateSimCardDto · SimCardDto · required · schema SimCardDto \[src/admin/dto/sim.dto.ts\] · fields simNumber?: string; imsi?: string; providerId?: string; iccid?: string; isActive?: boolean; status?: 'IN_STOCK' | 'IN_USE' | 'IN_SCRAP'

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "SIM card created successfully", data: \<newSim\>}

**Errors:** HttpException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:273 (AdminController.createSimCard) → src/admin/admin.service.ts:1983 (AdminService.createSimCard)

#### ADM-099 **DELETE /admin/simcards/:id**

Delete Sim Card

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "SIM card not found"} | {action: false, message: "SIM card is linked to a device and cannot be deleted"} | {action: true, message: "SIM card deleted successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:278 (AdminController.deleteSimCard) → src/admin/admin.service.ts:2166 (AdminService.deleteSimCard)

#### ADM-100 **GET /admin/simcards/:id**

Get Sim Card By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<sim\>

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:289 (AdminController.getSimCardById) → src/admin/admin.service.ts:2154 (AdminService.getSimCardById)

#### ADM-101 **PATCH /admin/simcards/:id**

Update Sim Card

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body UpdateSimCardDto · SimCardDto · required · schema SimCardDto \[src/admin/dto/sim.dto.ts\] · fields simNumber?: string; imsi?: string; providerId?: string; iccid?: string; isActive?: boolean; status?: 'IN_STOCK' | 'IN_USE' | 'IN_SCRAP'

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "SIM card not found"} | {action: false, message: "Invalid SIM number provided"} | {action: false, message: "Duplicate SIM number"} | {action: false, message: "Duplicate IMSI"} | {action: false, message: "SIM provider not found"} | {action: false, message: "Duplicate ICCID"} | {action: true, message: "SIM card updated successfully", data: \<updatedSim\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:294 (AdminController.updateSimCard) → src/admin/admin.service.ts:2056 (AdminService.updateSimCard)

### Search (1)

#### ADM-102 **GET /admin/topbar-search**

Search Topbar

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · TopbarSearchQueryDto · required · schema TopbarSearchQueryDto \[src/topbar-search/dto/topbar-search.dto.ts\] · fields q: string; limit?: number = 20

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:91 (AdminController.searchTopbar) → src/topbar-search/topbar-search.service.ts:64 (TopbarSearchService.searchForAdmin)

### Settings and Localization (6)

#### ADM-103 **GET /admin/localization**

Get Localization Data

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Localization Settings not found"} | {action: true, message: "Localization Settings fetched successfully", data: \<localsettings\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:928 (AdminController.getLocalizationData) → src/admin/admin.service.ts:5740 (AdminService.getLocalizationData)

#### ADM-104 **PATCH /admin/localization**

Update Localization Data

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body localizationDto · UpdateSettingsStateDto · required · schema UpdateSettingsStateDto \[src/superadmin/dto/usersetting.dto.ts\] · fields language?: string; layoutDirection?: LayoutDirectionDto; dateFormat?: string; use24Hour?: boolean; theme?: ThemeModeDto; timezoneOffset?: string; units?: UnitsDto; defaultLat?: number; defaultLon?: number; mapZoom?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Localization settings updated successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:933 (AdminController.updateLocalizationData) → src/admin/admin.service.ts:5750 (AdminService.updateLocalizationSettings)

#### ADM-105 **GET /admin/smtpconfig**

Get Smtp Config

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<smtpConfig\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:592 (AdminController.getSmtpConfig) → src/admin/admin.service.ts:4466 (AdminService.getSmtpConfig)

#### ADM-106 **PATCH /admin/smtpconfig**

Patch Smtp Config

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body smtpConfig · UpdateSmtpConfigDto · required · schema UpdateSmtpConfigDto \[src/admin/dto/updatesmtpconfig.dto.ts\] · fields senderName?: string; host?: string; port?: string | number; email?: string; type?: SmtpSecurity; username?: string; password?: string; replyTo?: string; isActive?: string | boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<newSmtpConfig\> | \<updatedSmtpConfig\>

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:603 (AdminController.patchSmtpConfig) → src/admin/admin.service.ts:4473 (AdminService.updateSmtpConfig)

#### ADM-107 **POST /admin/smtpconfig**

Update Smtp Config

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body smtpConfig · UpdateSmtpConfigDto · required · schema UpdateSmtpConfigDto \[src/admin/dto/updatesmtpconfig.dto.ts\] · fields senderName?: string; host?: string; port?: string | number; email?: string; type?: SmtpSecurity; username?: string; password?: string; replyTo?: string; isActive?: string | boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<newSmtpConfig\> | \<updatedSmtpConfig\>

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:597 (AdminController.updateSmtpConfig) → src/admin/admin.service.ts:4473 (AdminService.updateSmtpConfig)

#### ADM-108 **GET /admin/systemvariables**

Get System Variables

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "System Variables Fetched Successfully", data: \<systemVariables\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1291 (AdminController.getSystemVariables) → src/admin/admin.service.ts:8660 (AdminService.getAdminSystemVariables)

### Support (10)

#### ADM-109 **GET /admin/mytickets**

List Admin My Tickets

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query status · string · optional ; query search · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Tickets fetched successfully", data: \<sorted\>} | {action: false, message: \<error?.message || 'Failed to fetch tickets'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:163 (AdminController.listAdminMyTickets) → src/admin/admin.service.ts:6337 (AdminService.listAdminMyTickets)

#### ADM-110 **POST /admin/mytickets**

Create Admin My Ticket

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** body body · any · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "title is required and must be max 120 characters", data: null} | {action: false, message: "message is required and must be max 5000 characters", data: null} | {action: true, message: "Ticket created successfully", data: {id: \<ticket.id\>, ticketNo: \<ticketNo\>}} | {action: false, message: \<error?.message || 'Failed to create ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:172 (AdminController.createAdminMyTicket) → src/admin/admin.service.ts:6524 (AdminService.createAdminMyTicket)

#### ADM-111 **GET /admin/mytickets/:id**

Get Admin My Ticket By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Ticket fetched successfully", data: \<data\>} | {action: false, message: \<error?.message || 'Failed to fetch ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:181 (AdminController.getAdminMyTicketById) → src/admin/admin.service.ts:6441 (AdminService.getAdminMyTicketById)

#### ADM-112 **POST /admin/mytickets/:id/messages**

Reply Admin My Ticket

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body body · any · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "message is required and must be max 5000 characters", data: null} | {action: true, message: "Message sent successfully", data: {messageId: \<ticketMessage.id\>}} | {action: false, message: \<error?.message || 'Failed to send message'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:189 (AdminController.replyAdminMyTicket) → src/admin/admin.service.ts:6639 (AdminService.replyAdminMyTicket)

#### ADM-113 **PATCH /admin/mytickets/:id/status**

Update Admin My Ticket Status

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · AdminUpdateTicketStatusDto · required · schema AdminUpdateTicketStatusDto \[src/admin/dto/admin-update-ticket-status.dto.ts\] · fields status: TicketStatusEnum

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid status", data: null} | {action: true, message: "Ticket status updated successfully", data: \<updated\>} | {action: false, message: \<error?.message || 'Failed to update ticket status'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:199 (AdminController.updateAdminMyTicketStatus) → src/admin/admin.service.ts:6704 (AdminService.updateAdminMyTicketStatus)

#### ADM-114 **GET /admin/tickets**

List Admin Tickets

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query status · string · optional ; query search · string · optional ; query userId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Tickets fetched successfully", data: \<sorted\>} | {action: false, message: \<error?.message || 'Failed to fetch tickets'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:113 (AdminController.listAdminTickets) → src/admin/admin.service.ts:5842 (AdminService.listAdminTickets)

#### ADM-115 **POST /admin/tickets**

Create Admin Ticket

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** body body · any · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "fromUserId is required", data: null} | {action: false, message: "title is required and must be max 120 characters", data: null} | {action: false, message: "message is required and must be max 5000 characters", data: null} | {action: true, message: "Ticket created successfully", data: {id: \<ticket.id\>, ticketNo: \<ticketNo\>}} | {action: false, message: \<error?.message || 'Failed to create ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:131 (AdminController.createAdminTicket) → src/admin/admin.service.ts:6051 (AdminService.createAdminTicket)

#### ADM-116 **GET /admin/tickets/:id**

Get Admin Ticket By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Ticket fetched successfully", data: \<data\>} | {action: false, message: \<error?.message || 'Failed to fetch ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:123 (AdminController.getAdminTicketById) → src/admin/admin.service.ts:5969 (AdminService.getAdminTicketById)

#### ADM-117 **POST /admin/tickets/:id/messages**

Reply Admin Ticket

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body body · any · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "message is required and must be max 5000 characters", data: null} | {action: true, message: "Message sent successfully", data: {messageId: \<ticketMessage.id\>}} | {action: false, message: \<error?.message || 'Failed to send message'\>, data: null}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:140 (AdminController.replyAdminTicket) → src/admin/admin.service.ts:6156 (AdminService.replyAdminTicket)

#### ADM-118 **PATCH /admin/tickets/:id/status**

Update Admin Ticket Status

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · AdminUpdateTicketStatusDto · required · schema AdminUpdateTicketStatusDto \[src/admin/dto/admin-update-ticket-status.dto.ts\] · fields status: TicketStatusEnum

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid status", data: null} | {action: true, message: "Ticket status updated successfully", data: \<updated\>} | {action: false, message: \<error?.message || 'Failed to update ticket status'\>, data: null}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:150 (AdminController.updateAdminTicketStatus) → src/admin/admin.service.ts:6262 (AdminService.updateAdminTicketStatus)

### Teams (5)

#### ADM-119 **GET /admin/teams**

Get Teams

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Teams fetched successfully", data: \<teams\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:903 (AdminController.getTeams) → src/admin/admin.service.ts:5504 (AdminService.getTeams)

#### ADM-120 **POST /admin/teams**

Create Team

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body createTeamDto · CreateTeamMemberDto · required · schema CreateTeamMemberDto \[src/admin/dto/createteam.dto.ts\] · fields name: string; email: string; mobilePrefix: string; mobileNumber: string; username: string; password: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "A team member with the same email or username already exists"} | {action: true, message: "Team member created successfully", data: \<created\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:907 (AdminController.createTeam) → src/admin/admin.service.ts:5522 (AdminService.createTeam)

#### ADM-121 **DELETE /admin/teams/:id**

Delete Team

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Team member not found"} | {action: true, message: "Team member deleted successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:919 (AdminController.deleteTeam) → src/admin/admin.service.ts:5604 (AdminService.deleteTeam)

#### ADM-122 **GET /admin/teams/:id**

Get Team By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Team member not found"} | {action: true, message: "Team member fetched successfully", data: \<teamMember\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:911 (AdminController.getTeamById) → src/admin/admin.service.ts:5554 (AdminService.getTeamById)

#### ADM-123 **PATCH /admin/teams/:id**

Update Team

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body updateTeamDto · UpdateTeamMemberDto · required · schema UpdateTeamMemberDto \[src/admin/dto/updateteam.dto.ts\] · fields name?: string; email?: string; mobilePrefix?: string; mobileNumber?: string; username?: string; password?: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Team member not found"} | {action: true, message: "Team member updated successfully", data: \<updated\>}

**Errors:** UnauthorizedException — Invalid user identity. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:915 (AdminController.updateTeam) → src/admin/admin.service.ts:5575 (AdminService.updateTeam)

### Users and Access (13)

#### ADM-124 **GET /admin/shortusers**

Get Short Users

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query search · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Users fetched successfully", usersshortlist: \<usersshortlist\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:104 (AdminController.getShortUsers) → src/admin/admin.service.ts:1240 (AdminService.getShortUsers)

#### ADM-125 **POST /admin/updateuserpassword/:id**

Update Password

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body body · { newPassword: string } · required · fields newPassword: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** NotFoundException; UnauthorizedException — Invalid user identity. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:233 (AdminController.updatePassword) → src/admin/admin.service.ts:4244 (AdminService.updateuserPassword)

#### ADM-126 **GET /admin/userlogin/:id**

Admin Login

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:223 (AdminController.adminLogin) → src/admin/admin.service.ts:1457 (AdminService.userLogin)

#### ADM-127 **GET /admin/users**

Get Users

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query search · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Users fetched successfully", userslist: \<userslist\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:99 (AdminController.getUsers) → src/admin/admin.service.ts:1182 (AdminService.getUsers)

#### ADM-128 **POST /admin/users**

Create User

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body CreateUserDto · CreateUserDto · required · schema CreateUserDto \[src/admin/dto/createuser.dto.ts\] · fields name: string; email?: string; mobilePrefix: string; mobileNumber: string; username: string; password: string; companyName?: string; address: string; countryCode: string; stateCode?: string; city?: string; pincode?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<\`\${field} already exists\`\>} | \<currentUser\>

**Errors:** ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:208 (AdminController.createUser) → src/admin/admin.service.ts:1268 (AdminService.createUser)

#### ADM-129 **DELETE /admin/users/:id**

Delete User

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"} | {action: true, message: "User deleted successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:228 (AdminController.deleteUser) → src/admin/admin.service.ts:1430 (AdminService.deleteUser)

#### ADM-130 **GET /admin/users/:id**

Get User By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<user\>

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:213 (AdminController.getUserById) → src/admin/admin.service.ts:1445 (AdminService.getUserById)

#### ADM-131 **PATCH /admin/users/:id**

Update User

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body UpdateUserDto · UpdateUserDto · required · schema UpdateUserDto \[src/admin/dto/updateuser.dto.ts\] · fields roleId?: string; name?: string; email?: string; mobilePrefix?: string; mobileNumber?: string; username?: string; password?: string; companyName?: string; address?: string; countryCode?: string; stateCode?: string; city?: string; pincode?: string; isActive?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<currentUser\>

**Errors:** NotFoundException; ConflictException; UnauthorizedException — Invalid user identity. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:218 (AdminController.updateUser) → src/admin/admin.service.ts:1333 (AdminService.updateUser)

#### ADM-132 **GET /admin/users/:id/activitylogs**

Get User Activity Logs

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; query dto · UserActivityLogsDto · required · schema UserActivityLogsDto \[src/admin/dto/user-activity-logs.dto.ts\] · fields limit?: number; cursorId?: number; from?: string; to?: string; q?: string; actionPrefix?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \<items\>, nextCursorId: \<nextCursorId\>, hasMore: \<hasMore\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1060 (AdminController.getUserActivityLogs) → src/admin/admin.service.ts:7295 (AdminService.getUserActivityLogs)

#### ADM-133 **GET /admin/users/linkeddrivers/:userId**

Get Linked Drivers For User

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"} | {action: true, message: "Drivers fetched successfully", data: \<drivers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:884 (AdminController.getLinkedDriversForUser) → src/admin/admin.service.ts:4109 (AdminService.getLinkedDriversForUser)

#### ADM-134 **POST /admin/users/linkeddrivers/:userId**

Link Drivers To User

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe ; body driverId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "User not found"} | {action: false, message: "Driver-User link already exists"} | {action: true, message: "Driver linked to user successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:892 (AdminController.linkDriversToUser) → src/admin/admin.service.ts:4342 (AdminService.linkDriverToUser)

#### ADM-135 **GET /admin/users/unlinkeddrivers/:userId**

Get Unlinked Drivers For User

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"} | {action: true, message: "Unlinked drivers fetched successfully", data: \<unlinkedDrivers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:888 (AdminController.getUnlinkedDriversForUser) → src/admin/admin.service.ts:4129 (AdminService.getUnlinkedDriversForUser)

#### ADM-136 **POST /admin/users/unlinkeddrivers/:userId**

Unlink Drivers From User

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param userId · number · required · pipes ParseIntPipe ; body driverId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "User not found"} | {action: false, message: "Driver is not linked to this user"} | {action: true, message: "Driver unlinked from user successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:897 (AdminController.unlinkDriversFromUser) → src/admin/admin.service.ts:4370 (AdminService.unlinkDriverFromUser)

### Users and Bulk Jobs (4)

#### ADM-137 **POST /admin/userbulkjobs**

Create User Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateUserBulkJobDto · required · schema CreateUserBulkJobDto \[src/admin/dto/userbulkjobs.dto.ts\] · fields rows: UserBulkJobRowDto\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Bulk job created", data: \<created\>} | {id: \<id\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:417 (AdminController.createUserBulkJob) → src/admin/user-bulk-jobs.service.ts:141 (UserBulkJobsService.createJob)

#### ADM-138 **GET /admin/userbulkjobs/:id**

Get User Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found"} | {action: true, message: "Job fetched", data: \<job\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:423 (AdminController.getUserBulkJob) → src/admin/user-bulk-jobs.service.ts:192 (UserBulkJobsService.getJob)

#### ADM-139 **GET /admin/userbulkjobs/:id/failed.csv**

Download User Failed Csv

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants void | null | {filename: \<\`user-bulk-failed-\${jobId}.csv\`\>, csv: \<csv\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:430 (AdminController.downloadUserFailedCsv) → src/admin/user-bulk-jobs.service.ts:204 (UserBulkJobsService.getFailedCsv)

#### ADM-140 **GET /admin/userbulkjobs/:id/stream**

Stream User Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Stream:** Server-Sent Events with event names job_state, log, row, progress, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void | null | \<job.emitter\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:444 (AdminController.streamUserBulkJob) → src/admin/user-bulk-jobs.service.ts:198 (UserBulkJobsService.getEmitter) → src/admin/user-bulk-jobs.service.ts:192 (UserBulkJobsService.getJob)

### Vehicles (23)

#### ADM-141 **GET /admin/vehicles**

Get Vehicles

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles fetched successfully", vehicles: \<vehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:459 (AdminController.getVehicles) → src/admin/admin.service.ts:2187 (AdminService.getVehicles)

#### ADM-142 **POST /admin/vehicles**

Create Vehicle

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body CreateVehicleDto · CreateVehicleDto · required · schema CreateVehicleDto \[src/admin/dto/createvehicle.dto.ts\] · fields name: string; vin?: string; plateNumber?: string; deviceId: number | string; vehicleTypeId: number | string; primaryUserId: number | string; planId: number | string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle name is required"} | {action: false, message: \<err.message || 'Invalid input'\>} | {action: false, message: "Invalid input parameters"} | {action: true, message: "Vehicle created successfully", data: \<newVehicle\>, meta: {licenseEnforced: true, listenerRedisSynced: \<enforcement.redisSynced\>}} | {action: false, message: \<err.message || 'Request failed'\>} | {action: false, message: "Vehicle with this VIN already exists"} | {action: false, message: "Vehicle with this IMEI already exists"} | {action: false, message: "This device is already assigned to another vehicle"} | {action: false, message: "Duplicate record detected"} | {action: false, message: "Invalid reference - one of the selected items does not exist"} | {action: false, message: "One of the selected items does not exist"} | {action: false, message: "Something went wrong while creating vehicle"}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:464 (AdminController.createVehicle) → src/admin/admin.service.ts:2230 (AdminService.createVehicle)

#### ADM-143 **DELETE /admin/vehicles/:id**

Delete Vehicle

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found"} | {action: true, message: "Vehicle deleted successfully", meta: {licenseEnforced: true, listenerRedisSynced: \<enforcement.redisSynced\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:479 (AdminController.deleteVehicle) → src/admin/admin.service.ts:2826 (AdminService.deleteVehicle)

#### ADM-144 **GET /admin/vehicles/:id**

Get Vehicle By Id

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<vehicle\>

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:474 (AdminController.getVehicleById) → src/admin/admin.service.ts:2784 (AdminService.getVehicleById)

#### ADM-145 **PATCH /admin/vehicles/:id**

Update Vehicle

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body UpdateVehicleDto · UpdateVehicleDto · required · schema UpdateVehicleDto \[src/admin/dto/updatevehicle.dto.ts\] · fields name?: string; vin?: string; plateNumber?: string; deviceid?: number; vehicleTypeId?: number; planid?: number; gmtOffset?: string; isActive?: boolean; vehicleMeta?: Record\<string, any\>

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<updatedVehicle\> | {...: spread, meta: {licenseEnforced: true, listenerRedisSynced: \<enforcement.redisSynced\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:469 (AdminController.updateVehicle) → src/admin/admin.service.ts:2659 (AdminService.updateVehicle)

#### ADM-146 **PATCH /admin/vehicles/:id/config**

Update Vehicle Config

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateVehicleConfigDto · required · schema UpdateVehicleConfigDto \[src/admin/dto/update-vehicle-config.dto.ts\] · fields speedVariation?: number; distanceVariation?: number; odometer?: number; engineHours?: number; ignitionSource?: 'ACC' | 'MOTION'

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle config fetched successfully", data: conditional} | {action: true, message: "Vehicle config updated successfully", data: {...: spread, speedVariation: conditional, distanceVariation: conditional, odometer: conditional, engineHours: conditional}, meta: {telemetrySynced: \<telemetrySynced\>, ...: spread}}

**Errors:** NotFoundException; HttpException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:484 (AdminController.updateVehicleConfig) → src/admin/admin.service.ts:2854 (AdminService.updateVehicleConfig)

#### ADM-147 **GET /admin/vehicles/:vehicleId/sensors**

List Vehicle Sensors

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; query search · string · optional ; query page · string · optional ; query limit · string · optional ; query includeLive · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \<items\>, page: \<page\>, limit: \<limit\>, total: \<total\>}} | {action: true, message: "OK", data: {items: \<enriched.items\>, page: \<page\>, limit: \<limit\>, total: \<total\>, telemetryMeta: \<enriched.telemetryMeta\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:497 (AdminController.listVehicleSensors) → src/admin/admin.service.ts:2989 (AdminService.listVehicleSensors)

#### ADM-148 **POST /admin/vehicles/:vehicleId/sensors**

Create Vehicle Sensor

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; body dto · CreateVehicleSensorDto · required · schema CreateVehicleSensorDto \[src/user/dto/sensors/create-vehicle-sensor.dto.ts\] · fields name: string; unit?: string; icon?: string; code: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sensor created", data: \<created\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:512 (AdminController.createVehicleSensor) → src/admin/admin.service.ts:3097 (AdminService.createVehicleSensor)

#### ADM-149 **DELETE /admin/vehicles/:vehicleId/sensors/:sensorId**

Delete Vehicle Sensor

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; param sensorId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sensor deleted"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:531 (AdminController.deleteVehicleSensor) → src/admin/admin.service.ts:3194 (AdminService.deleteVehicleSensor)

#### ADM-150 **PATCH /admin/vehicles/:vehicleId/sensors/:sensorId**

Update Vehicle Sensor

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; param sensorId · number · required · pipes ParseIntPipe ; body dto · UpdateVehicleSensorDto · required · schema UpdateVehicleSensorDto \[src/user/dto/sensors/update-vehicle-sensor.dto.ts\] · fields name?: string; unit?: string; icon?: string; code?: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sensor updated", data: \<updated\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:521 (AdminController.updateVehicleSensor) → src/admin/admin.service.ts:3137 (AdminService.updateVehicleSensor)

#### ADM-151 **POST /admin/vehicles/:vehicleId/sensors/run**

Run Vehicle Sensor

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; body dto · RunVehicleSensorDto · required · schema RunVehicleSensorDto \[src/user/dto/sensors/run-vehicle-sensor.dto.ts\] · fields code: string; payload: Record\<string, unknown\>

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Run OK", data: \<run\>}

**Errors:** BadRequestException — code must be at least 5 characters; BadRequestException — Code too large; BadRequestException — payload must be a JSON object; BadRequestException — payload is not serialisable; BadRequestException — Payload too large; BadRequestException — Execution timed out; BadRequestException — safe. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:540 (AdminController.runVehicleSensor) → src/admin/admin.service.ts:3210 (AdminService.runVehicleSensor)

#### ADM-152 **GET /admin/vehicles/:vehicleId/sensors/telemetry**

Get Vehicle Sensor Telemetry

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "No IMEI assigned", data: {telemetry: null, imei: null}} | {action: true, message: conditional, data: {telemetry: \<telemetry ?? null\>, imei: \<vehicle.imei\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:549 (AdminController.getVehicleSensorTelemetry) → src/admin/admin.service.ts:3216 (AdminService.getVehicleSensorTelemetry)

#### ADM-153 **GET /admin/vehicles/by-imei/:imei/commands**

Get Command History By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query limit · string · optional ; query cursorId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Command history retrieved", data: \<buildDeviceCommandLogListResponse\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1318 (AdminController.getCommandHistoryByImei) → src/admin/admin.service.ts:8720 (AdminService.getCommandHistoryByImei)

#### ADM-154 **GET /admin/vehicles/by-imei/:imei/details**

Get Vehicle Details By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found", data: null} | {action: true, message: "Vehicle details loaded", data: {vehicle: \<vehicle\>, telemetry: \<live ?? null\>, deviceStatus: \<deviceStatus\>, lastConnectionAt: \<lastConnectionAt\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1140 (AdminController.getVehicleDetailsByImei) → src/admin/admin.service.ts:8095 (AdminService.getVehicleDetailsByImei)

#### ADM-155 **GET /admin/vehicles/by-imei/:imei/events**

Get Vehicle Events By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · MapEventsQueryDto · required · schema MapEventsQueryDto \[src/superadmin/dto/map-events.dto.ts\] · fields limit?: string; beforeId?: string; from?: string; to?: string; source?: string; severity?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle events loaded", data: \<result\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1160 (AdminController.getVehicleEventsByImei) → src/admin/admin.service.ts:8051 (AdminService.getVehicleEventsByImei)

#### ADM-156 **GET /admin/vehicles/by-imei/:imei/events/export**

Export Vehicle Events Csv

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param imei · string · required ; query from · string · optional ; query to · string · optional ; query source · string · optional ; query severity · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants {csv: \<'\uFEFF' + csvLines.join('\n')\>, filename: \<filename\>, truncated: \<truncated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1186 (AdminController.exportVehicleEventsCsv) → src/admin/admin.service.ts:8297 (AdminService.exportVehicleEventsCsv)

#### ADM-157 **GET /admin/vehicles/by-imei/:imei/history**

Get Vehicle History By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · required ; query to · string · required ; query stopMin · string · optional ; query overspeedKph · string · optional ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<history.message\>, data: null} | {action: true, message: "History loaded", data: \<history.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1228 (AdminController.getVehicleHistoryByImei) → src/admin/admin.service.ts:8417 (AdminService.getVehicleHistoryByImei)

#### ADM-158 **GET /admin/vehicles/by-imei/:imei/logs**

Get Vehicle Logs By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · optional ; query to · string · optional ; query limit · string · optional ; query beforeId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cursor", data: {items: \[\], nextCursor: null}} | {action: false, message: \<dateRange.message\>, data: {items: \[\], nextCursor: null}} | {action: true, message: "Telemetry logs loaded", data: {items: \<items\>, nextCursor: \<nextCursor\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1148 (AdminController.getVehicleLogsByImei) → src/admin/admin.service.ts:8170 (AdminService.getVehicleLogsByImei)

#### ADM-159 **GET /admin/vehicles/by-imei/:imei/logs/export**

Export Vehicle Logs Csv

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param imei · string · required ; query from · string · optional ; query to · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants {csv: "", filename: "error.csv", truncated: false} | {csv: \<'\uFEFF' + csvLines.join('\n')\>, filename: \<filename\>, truncated: \<truncated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1169 (AdminController.exportVehicleLogsCsv) → src/admin/admin.service.ts:8217 (AdminService.exportVehicleLogsCsv)

#### ADM-160 **GET /admin/vehicles/by-imei/:imei/replay**

Get Vehicle Replay By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · required ; query to · string · required ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<replay.message\>, data: null} | {action: true, message: "Replay data loaded", data: \<replay.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1217 (AdminController.getVehicleReplayByImei) → src/admin/admin.service.ts:8393 (AdminService.getVehicleReplayByImei)

#### ADM-161 **POST /admin/vehicles/by-imei/:imei/send-command**

Send Device Command By Imei

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param imei · string · required ; body dto · SendDeviceCommandDto · required · schema SendDeviceCommandDto \[src/superadmin/dto/send-device-command.dto.ts\] · fields command: string; note?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: conditional, data: \<result\>}

**Errors:** Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED; command was not dispatched\`; Error — \`Failed to dispatch command \${cmdId} via Redis: \${errorMessage}\`; Error; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED_OFFLINE\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1300 (AdminController.sendDeviceCommandByImei) → src/admin/admin.service.ts:8671 (AdminService.sendDeviceCommandByImei)

#### ADM-162 **GET /admin/vehicles/by-imei/:imei/sensors**

Get Vehicle Sensors By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query includeTelemetryMeta · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>}

**Errors:** BadRequestException — code must be at least 5 characters; BadRequestException — Code too large; BadRequestException — payload must be a JSON object; BadRequestException — payload is not serialisable; BadRequestException — Payload too large; BadRequestException — Execution timed out; BadRequestException — safe. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/admin/admin.controller.ts:1243 (AdminController.getVehicleSensorsByImei) → src/admin/admin.service.ts:8439 (AdminService.getVehicleSensorsByImei)

#### ADM-163 **GET /admin/vehicles/by-imei/:imei/trail**

Get Vehicle Trail By Imei

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query hours · string · optional ; query from · string · optional ; query to · string · optional ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<trail.message\>, data: null} | {action: true, message: "Vehicle trail loaded", data: \<trail.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:1205 (AdminController.getVehicleTrailByImei) → src/admin/admin.service.ts:8369 (AdminService.getVehicleTrailByImei)

### Vehicles and Bulk Jobs (4)

#### ADM-164 **POST /admin/vehiclebulkjobs**

Create Vehicle Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateVehicleBulkJobDto · required · schema CreateVehicleBulkJobDto \[src/admin/dto/vehiclebulkjobs.dto.ts\] · fields primaryUserId: string; planId: string; trackerDeviceTypeId: string; rows: VehicleBulkJobRowDto\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Bulk job created", data: \<created\>} | {id: \<id\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:321 (AdminController.createVehicleBulkJob) → src/admin/vehicle-bulk-jobs.service.ts:130 (VehicleBulkJobsService.createJob)

#### ADM-165 **GET /admin/vehiclebulkjobs/:id**

Get Vehicle Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found"} | {action: true, message: "Job fetched", data: \<job\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:327 (AdminController.getVehicleBulkJob) → src/admin/vehicle-bulk-jobs.service.ts:186 (VehicleBulkJobsService.getJob)

#### ADM-166 **GET /admin/vehiclebulkjobs/:id/failed.csv**

Download Failed Csv

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants void | null | {filename: \<\`vehicle-bulk-failed-\${jobId}.csv\`\>, csv: \<csv\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:334 (AdminController.downloadFailedCsv) → src/admin/vehicle-bulk-jobs.service.ts:198 (VehicleBulkJobsService.getFailedCsv)

#### ADM-167 **GET /admin/vehiclebulkjobs/:id/stream**

Stream Vehicle Bulk Job

Access Bearer JWT (ADMIN) · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Stream:** Server-Sent Events with event names job_state, log, row, progress, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void | null | \<job.emitter\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/admin/admin.controller.ts:352 (AdminController.streamVehicleBulkJob) → src/admin/vehicle-bulk-jobs.service.ts:192 (VehicleBulkJobsService.getEmitter) → src/admin/vehicle-bulk-jobs.service.ts:186 (VehicleBulkJobsService.getJob)

## User APIs

126 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Report Generation Contract

POST /user/reports/:reportKey supports nine bounded report engines. The body uses GenerateReportDto with vehicleScope, dateRange, filters, timeZone, from, to, and cursor. vehicleScope.mode is one of single, multiple, group, all; multiple mode accepts at most 20,000 vehicles. The server verifies ownership/availability and fails when requested vehicles are inaccessible.

Event reports return at most 1,000 rows. Aggregate queries are bounded to 2,000 cells (500 for raw aggregate cells). Timeline map requests are limited to 48 hours.

| **reportKey** | **Maximum range** | **filters** | **Row fields** | **Specific errors** |
| --- | --- | --- | --- | --- |
| distance | 31 days / dateOnly | None | vehicleId, vehicleName, vehicleNumber, date, firstMovement, lastMovement, startLat, startLon, endLat, endLon, startAddress, endAddress, distanceKm, engineHoursSeconds, odometerStartKm, odometerEndKm | Common report validation |
| driven | 31 days / dateTime | None | vehicleId, vehicleName, vehicleNumber, distanceKm, date | Common report validation |
| overspeed | 7 days / dateTime | speedLimitKmh | vehicleId, vehicleName, maxSpeedKmh, avgSpeedKmh, configuredLimitKmh, durationSeconds, startedAt, endedAt, lat, lon, address | Speed limit must be between 10 and 300 km/h |
| geofence | 90 days / dateTime | geofenceIds | vehicleId, vehicleName, geofenceId, geofenceName, event, timestamp, durationSeconds, lat, lon, address | Select no more than 500 geofences; One or more geofences are unavailable |
| sensor | 30 days / dateTime | sensorIds | vehicleId, vehicleName, sensorId, sensorLabel, value, state, unit, valueMode, timestamp | Sensor report requires one vehicle; Select one sensor |
| alerts | 90 days / dateTime | acknowledged, alertTypes, severities | id, vehicleId, vehicleName, alertType, severity, message, timestamp, acknowledged, speedKmh, lat, lon, address | Invalid alert type filter; Invalid alert severity filter; Invalid acknowledged filter |
| logs | 7 days / dateTime | categories, directions, levels, search | id, vehicleId, vehicleName, category, level, direction, event, message, protocol, timestamp, payload, metadata | Logs report requires one vehicle; Invalid log category filter; Invalid log level filter; Invalid log direction filter; Log search must contain at least 3 characters |
| timeline | 7 days / dateOnly | states | vehicleId, vehicleName, state, date, startedAt, endedAt, durationSeconds, distanceKm, engineHoursSeconds, maxSpeedKmh, avgSpeedKmh, startLat, startLon, endLat, endLon, startAddress, endAddress | Select running, stopped, or both timeline states |
| details | 31 days / dateOnly | None | vehicleId, vehicleName, date, distanceKm, engineHoursSeconds, dayDistanceKm, nightDistanceKm, dayEngineHoursSeconds, nightEngineHoursSeconds, maxSpeedKmh, avgSpeedKmh, totalTrips, startLat, startLon, startAddress, endLat, endLon, endAddress | Common report validation |

``` json
{
  "action": true,
  "message": "Report generated",
  "data": {
    "rows": [<report-specific rows>],
    "meta": {
      "generatedAt": "<ISO-8601>", "rowCount": 0,
      "hasMore": false, "nextCursor": null,
      "warning": null, "source": "<query source>",
      "query": {"vehicleScope": {}, "dateRange": {}, "filters": {}}
    }
  }
}
```

### Company and Branding (2)

#### USR-001 **PATCH /user/companydetails**

Update Own Company Details

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body companyDto · CompanyDto · required · schema CompanyDto \[src/superadmin/dto/company.dto.ts\] · fields name?: string; websiteUrl?: string; customDomain?: string; socialLinks?: Record\<string, string\>; primaryColor?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Company not found"} | {action: true, message: "Company updated successfully", data: \<updated\>} | {action: false, message: \<err?.message || 'Failed to update company'\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:514 (UserController.updateOwnCompanyDetails) → src/user/user.service.ts:3143 (UserService.updateCompanyDetails)

#### USR-002 **POST /user/upload**

Upload Profile

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One image file plus type=PROFILE. Accepted image families are JPEG/JPG, PNG, and WebP.

**Response:** Global success envelope; observed result variants {action: false, message: "Request must be multipart/form-data", data: null} | {action: false, message: "User not found", data: null} | {action: false, message: "Only one file allowed", data: null} | {action: false, message: "Invalid upload type. Only PROFILE is allowed for users.", data: null} | {action: false, message: "File field is required", data: null} | {action: false, message: "Profile image must be PNG, JPEG, JPG, or WebP format.", data: null} | {action: true, message: "Profile image updated successfully", data: {url: \<urlPath\>, type: "PROFILE"}} | {action: false, message: \<error.message || 'Upload failed'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:789 (UserController.uploadProfile) → src/user/user.service.ts:5437 (UserService.uploadProfileImage)

### Dashboard (13)

#### USR-003 **GET /user/dashboard/day-night-comparison**

Get Day Night Comparison

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query vehicleId · string · optional ; query from · string · optional ; query to · string · optional ; query tzOffset · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<shortDayNames\[d.getUTCDay()\]\> | \<\`\${d.getUTCDate()} \${monthNames\[d.getUTCMonth()\]}\`\> | {action: true, message: "Day/Night comparison", data: {timezoneOffsetMin: \<offsetMin\>, timezoneSource: conditional, filter: {mode: conditional, vehicleId: \<singleVehicleId ?? null\>}, range: {from: \<fromDate.toISOString\>, to: \<toDate.toISOString\>}, dayWindow: {startHour: \<DAY_START\>, endHour: \<DAY_END\>, label: \<\`\${String(DAY_START).padStart(2, '0')}:00–\${String(DAY_END).padStart(2, '0')}:00\`\>}, points: \<points\>, totals: \<totals\>, percentages: \<percentages\>, updatedAt: \<new Date().toISOString\>}}

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:866 (UserController.getDayNightComparison) → src/user/user.service.ts:7097 (UserService.getDayNightComparison)

#### USR-004 **GET /user/dashboard/fleet-status**

Get User Fleet Status

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Fleet status computed", data: {totalVehicles: \<totalVehicles\>, withDevice: \<buckets.total\>, noDevice: \<noDevice\>, buckets: {...: spread}, percentages: {running: \<pct\>, idle: \<pct\>, stopped: \<pct\>, inactive: \<pct\>, noData: \<pct\>, connected: \<pct\>, noDevice: \<pct\>}, updatedAt: \<new Date().toISOString\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:798 (UserController.getUserFleetStatus) → src/user/user.service.ts:5085 (UserService.getUserFleetStatus)

#### USR-005 **GET /user/dashboard/recent-alerts**

GET /user/dashboard/recent-alerts Returns a paginated, deduped feed of vehicle notification logs scoped to the authenticated user.

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query vehicleId · string · optional ; query limit · string · optional ; query beforeId · string · optional ; query from · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Recent alerts", data: {filter: {mode: conditional, ...: spread}, limit: \<limit\>, nextCursor: \<nextCursor\>, items: \<items\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:823 (UserController.getDashboardRecentAlerts) → src/user/user.service.ts:6257 (UserService.getDashboardRecentAlerts)

#### USR-006 **GET /user/dashboard/recent-alerts/:id**

GET /user/dashboard/recent-alerts/:id Returns full detail for a single alert including delivery logs.

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Alert detail", data: {id: \<row!.id\>, vehicleId: \<row!.vehicleId\>, vehicleName: \<(row as any).vehicle?.name ?? ''\>, plateNumber: \<(row as any).vehicle?.plateNumber ?? null\>, imei: \<(row as any).vehicle?.imei ?? null\>, source: \<row!.source\>, severity: \<row!.severity\>, title: \<row!.title\>, message: \<row!.message\>, meta: \<row!.meta ?? null\>, isRead: \<row!.isRead\>, createdAt: conditional, deliveries: \<(row as any).deliveries ?? \[\]\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:840 (UserController.getDashboardRecentAlertDetail) → src/user/user.service.ts:6353 (UserService.getDashboardRecentAlertDetail)

#### USR-007 **PATCH /user/dashboard/recent-alerts/:id/read**

PATCH /user/dashboard/recent-alerts/:id/read Marks a single alert as read (only if it belongs to the user).

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Marked as read", data: {id: \<id\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:848 (UserController.markDashboardRecentAlertRead) → src/user/user.service.ts:6400 (UserService.markDashboardRecentAlertRead)

#### USR-008 **GET /user/dashboard/top-performing-assets**

Top Performing Assets

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query from · string · optional ; query to · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Top performing assets", data: {range: {from: \<fromDate.toISOString\>, to: \<toDate.toISOString\>}, limit: \<limit\>, items: \[\], updatedAt: \<new Date().toISOString\>}} | {action: true, message: "Top performing assets", data: {range: {from: \<fromDate.toISOString\>, to: \<toDate.toISOString\>}, limit: \<limit\>, items: \<items\>, updatedAt: \<new Date().toISOString\>}}

**Errors:** BadRequestException — Invalid date format for from/to; BadRequestException — "from" must be before "to"; BadRequestException — Date range too large (max 90 days). Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:856 (UserController.topPerformingAssets) → src/user/user.service.ts:6606 (UserService.getTopPerformingAssets)

#### USR-009 **GET /user/dashboard/usage-last-7-days**

Compute fleet status buckets for the logged-in user's assigned vehicles.

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query vehicleId · string · optional ; query tzOffset · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Usage last 7 days computed", data: {range: {from: \<fromDayKey\>, to: \<toDayKey\>, timezoneOffsetMin: \<offsetMin\>, timezoneSource: conditional}, filter: {mode: \<filterMode\>, ...: spread}, points: \<points\>, totals: {drivenKm: \<Math.round(totalDrivenKm \* 100) / 100\>, engineHours: \<Math.round(totalEngineHours \* 100) / 100\>}, updatedAt: \<new Date().toISOString\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:803 (UserController.getUsageLast7Days) → src/user/user.service.ts:4936 (UserService.getUsageLast7Days)

#### USR-010 **GET /user/dashboard/weekly-comparison**

Weekly Comparison

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query vehicleId · string · optional ; query tzOffset · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Weekly comparison", data: {timezoneOffsetMin: \<offsetMin\>, timezoneSource: conditional, filter: {mode: \<filterMode\>, ...: spread}, week: {thisWeek: {}, lastWeek: {}, weekStart: "MONDAY"}, points: \<points\>, totals: \<totals\>, updatedAt: \<new Date().toISOString\>}}

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:813 (UserController.weeklyComparison) → src/user/user.service.ts:6417 (UserService.getWeeklyComparison)

#### USR-011 **GET /user/dashboards**

List all dashboards for a user

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Dashboards fetched successfully", data: \<dashboards\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:881 (UserController.listDashboards) → src/user/user.service.ts:5201 (UserService.listUserDashboards)

#### USR-012 **POST /user/dashboards**

Create a new dashboard

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateDashboardDto · required · schema CreateDashboardDto \[src/user/dto/dashboard.dto.ts\] · fields name: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Dashboard created successfully", data: \<dashboard\>}

**Errors:** NotFoundException; HttpException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:894 (UserController.createDashboard) → src/user/user.service.ts:5257 (UserService.createUserDashboard)

#### USR-013 **DELETE /user/dashboards/:id**

Soft delete a dashboard

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Dashboard deleted successfully"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:911 (UserController.deleteDashboard) → src/user/user.service.ts:5409 (UserService.deleteUserDashboard)

#### USR-014 **GET /user/dashboards/:id**

Get a single dashboard by ID

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Dashboard fetched successfully", data: \<dashboard\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:886 (UserController.getDashboard) → src/user/user.service.ts:5226 (UserService.getUserDashboardById)

#### USR-015 **PUT /user/dashboards/:id**

Update an existing dashboard (with optimistic locking)

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateDashboardDto · required · schema UpdateDashboardDto \[src/user/dto/dashboard.dto.ts\] · fields name?: string; config?: any; version: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Dashboard updated elsewhere", data: {conflict: true}} | {action: true, message: "Dashboard updated successfully", data: \<updated\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:902 (UserController.updateDashboard) → src/user/user.service.ts:5335 (UserService.updateUserDashboard)

### Device Commands (4)

#### USR-016 **GET /user/commands/:cmdId**

Get Command Log By Cmd Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required · observed fields length · no DTO-enforced field contract

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cmdId", data: null} | {action: false, message: "Command log not found", data: null} | {action: false, message: "You are not authorized to view this command", data: null} | {action: true, message: "Command log retrieved", data: \<serializeDeviceCommandLog\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1011 (UserController.getCommandLogByCmdId) → src/user/user.service.ts:7060 (UserService.getCommandLogByCmdId)

#### USR-017 **POST /user/commands/send-bulk**

Send Command Bulk

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · SendCommandBulkDto · required · schema SendCommandBulkDto \[src/user/dto/send-command-bulk.dto.ts\] · fields mode: SendCommandBulkMode; vehicleIds?: number\[\]; command?: string; items?: SendCommandBulkItem\[\]; note?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "No target vehicles found", data: {mode: \<dto.mode\>, command: \<globalCommand\>, totalTargets: 0, sentNow: 0, queued: 0, invalid: 0, results: \[\]}} | {action: true, message: "Commands dispatched", data: {mode: \<dto.mode\>, command: \<globalCommand\>, totalTargets: \<tasks.length\>, sentNow: \<sentNow\>, queued: \<queued\>, invalid: \<invalid\>, results: \<results\>}}

**Errors:** HttpException; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED; command was not dispatched\`; Error — \`Failed to dispatch command \${cmdId} via Redis: \${errorMessage}\`; Error; Error — \`DeviceCommandLog \${cmdId} could not transition REQUESTED -\> QUEUED_OFFLINE\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:984 (UserController.sendCommandBulk) → src/user/user.service.ts:6791 (UserService.sendCommandBulk)

#### USR-018 **GET /user/commands/status/:cmdId**

Get Command Status

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param cmdId · string · required · observed fields length · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cmdId", data: null} | {action: false, message: "Command status not found or expired", data: null} | {action: true, message: "Command status retrieved", data: {cmdId: \<cmdId\>, ...: spread}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:992 (UserController.getCommandStatus) → src/user/user.service.ts:6997 (UserService.getCommandStatus)

#### USR-019 **GET /user/customcommands**

Get User Custom Commands

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · CustomCommandsQueryDto · required · schema CustomCommandsQueryDto \[src/superadmin/dto/custom-commands-query.dto.ts\] · fields deviceTypeId?: string; commandTypeId?: string; activeOnly?: string; rk?: string

**Response:** Global success envelope; observed result variants {action: true, message: "Custom Commands Fetched Successfully", data: \<customCommands\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:970 (UserController.getUserCustomCommands) → src/user/user.service.ts:6749 (UserService.getUserCustomCommands)

### Drivers (12)

#### USR-020 **GET /user/drivers**

Get Drivers

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Drivers fetched successfully", data: \<drivers\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:359 (UserController.getDrivers) → src/user/user.service.ts:1927 (UserService.getDrivers)

#### USR-021 **POST /user/drivers**

Create Driver

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateUserDriverDto · required · schema CreateUserDriverDto \[src/user/dto/create-driver.dto.ts\] · fields name: string; mobilePrefix: string; mobile: string; email?: string; username: string; password: string; countryCode: string; stateCode?: string; city?: string; address?: string; pincode?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Username is required"} | {action: false, message: \<\`Driver with this \${field} already exists\`\>} | {action: true, message: "Driver created successfully", data: \<newDriver\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:351 (UserController.createDriver) → src/user/user.service.ts:1944 (UserService.createDriver)

#### USR-022 **DELETE /user/drivers/:id**

Delete Driver

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "You cannot delete this driver."} | {action: true, message: "Driver deleted successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:381 (UserController.deleteDriver) → src/user/user.service.ts:2137 (UserService.deleteDriver)

#### USR-023 **GET /user/drivers/:id**

Get Driver By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: true, message: "Driver fetched successfully", data: \<driver\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:364 (UserController.getDriverById) → src/user/user.service.ts:2014 (UserService.getDriverById)

#### USR-024 **PATCH /user/drivers/:id**

Update Driver

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateUserDriverDto · required · schema UpdateUserDriverDto \[src/user/dto/update-driver.dto.ts\] · fields name?: string; mobilePrefix?: string; mobile?: string; email?: string; username?: string; password?: string; countryCode?: string; StateCode?: string; city?: string; address?: string; pincode?: string; isactive?: string; attributes?: Record\<string, any\> | string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Driver not found"} | {action: false, message: "You cannot edit this driver."} | {action: false, message: "Username already exists"} | {action: false, message: "Email already exists"} | {action: false, message: "Mobile number already exists"} | {action: true, message: "Driver updated successfully", data: \<updatedDriver\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:372 (UserController.updateDriver) → src/user/user.service.ts:2050 (UserService.updateDriver)

#### USR-025 **POST /user/drivers/:id/assign-vehicle**

Assign Driver To Vehicle

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · AssignDriverVehicleDto · required · schema AssignDriverVehicleDto \[src/user/dto/assign-driver-vehicle.dto.ts\] · fields vehicleId: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Assigned successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:389 (UserController.assignDriverToVehicle) → src/user/user.service.ts:2175 (UserService.assignDriverToVehicle)

#### USR-026 **GET /user/drivers/:id/documents**

Get Driver Documents

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Driver documents fetched successfully", data: \<files\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:418 (UserController.getDriverDocuments) → src/user/user.service.ts:2272 (UserService.getDriverDocuments)

#### USR-027 **POST /user/drivers/:id/documents**

Upload Driver Document

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Request must be multipart/form-data' } as any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:426 (UserController.uploadDriverDocument) → src/user/user.service.ts:2290 (UserService.uploadDriverDocumentMultipart)

#### USR-028 **DELETE /user/drivers/:id/documents/:docId**

Delete Driver Document

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; param docId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Document not found"} | {action: false, message: "Access denied to delete this document"} | {action: true, message: "Document deleted successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:445 (UserController.deleteDriverDocument) → src/user/user.service.ts:2390 (UserService.deleteDriverDocument)

#### USR-029 **PATCH /user/drivers/:id/documents/:docId**

Update Driver Document

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; param docId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Document not found' } as any\> | \<{ action: false, message: 'Access denied to update this document' } as any\> | \<{ action: false, message: 'Request must be multipart/form-data' } as any\> | \<updatedResult\> | {action: true, message: "Document updated successfully", data: \<updatedWithFile\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:435 (UserController.updateDriverDocument) → src/user/user.service.ts:2327 (UserService.updateDriverDocumentMultipart)

#### USR-030 **GET /user/drivers/:id/logs**

Get Driver Logs

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Driver logs fetched successfully", data: \<logs\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:406 (UserController.getDriverLogs) → src/user/user.service.ts:2253 (UserService.getDriverLogs)

#### USR-031 **POST /user/drivers/:id/unassign-vehicle**

Unassign Driver From Vehicle

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "No assignment found"} | {action: true, message: "Unassigned successfully"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:398 (UserController.unassignDriverFromVehicle) → src/user/user.service.ts:2229 (UserService.unassignDriverFromVehicle)

### Geofences and Landmarks (14)

#### USR-032 **GET /user/geofences**

List Geofences

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query q · string · optional ; query isActive · string · optional ; query type · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Geofences fetched", geofences: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:593 (UserController.listGeofences) → src/user/user.service.ts:3896 (UserService.getUserGeofences)

#### USR-033 **POST /user/geofences**

Create Geofence

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateGeofenceDto · required · schema CreateGeofenceDto \[src/user/dto/geofence.dto.ts\] · fields name: string; description?: string; type: GeofenceType; color?: string; isActive?: boolean; geodata?: GeofenceGeoData

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Geofence created", geofence: {...: spread, radius: conditional, toleranceMeters: conditional}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:611 (UserController.createGeofence) → src/user/user.service.ts:4038 (UserService.createUserGeofence)

#### USR-034 **DELETE /user/geofences/:id**

Delete Geofence

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Geofence deleted"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:628 (UserController.deleteGeofence) → src/user/user.service.ts:4292 (UserService.deleteUserGeofence)

#### USR-035 **GET /user/geofences/:id**

Get Geofence By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Geofence fetched", geofence: {...: spread, radius: conditional, toleranceMeters: conditional}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:603 (UserController.getGeofenceById) → src/user/user.service.ts:3969 (UserService.getUserGeofenceById)

#### USR-036 **PATCH /user/geofences/:id**

Update Geofence

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateGeofenceDto · required · schema UpdateGeofenceDto \[src/user/dto/geofence.dto.ts\] · fields name?: string; description?: string; type?: GeofenceType; color?: string; isActive?: boolean; geodata?: GeofenceGeoData

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Geofence updated", geofence: {...: spread, radius: conditional, toleranceMeters: conditional}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:619 (UserController.updateGeofence) → src/user/user.service.ts:4159 (UserService.updateUserGeofence)

#### USR-037 **POST /user/landmarkbulkjobs**

Create Landmark Bulk Job

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateLandmarkBulkJobDto · required · schema CreateLandmarkBulkJobDto \[src/user/dto/landmarkbulkjobs.dto.ts\] · fields entityType: LandmarkEntityType; geofenceRows?: GeofenceBulkRowDto\[\]; poiRows?: PoiBulkRowDto\[\]; routeRows?: RouteBulkRowDto\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Landmark bulk job created", data: \<created\>} | {id: \<id\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:733 (UserController.createLandmarkBulkJob) → src/user/landmark-bulk-jobs.service.ts:185 (LandmarkBulkJobsService.createJob)

#### USR-038 **GET /user/landmarkbulkjobs/:id**

Get Landmark Bulk Job

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Job not found"} | {action: true, message: "Job fetched", data: \<job\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:742 (UserController.getLandmarkBulkJob) → src/user/landmark-bulk-jobs.service.ts:254 (LandmarkBulkJobsService.getJob)

#### USR-039 **GET /user/landmarkbulkjobs/:id/failed.csv**

Download Landmark Failed Csv

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response CSV download (raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Download:** Raw CSV body with download-oriented headers. Do not parse it as JSON or expect the global success envelope.

**Response:** CSV download (raw response); observed result variants void | null | {filename: \<\`\${job.entityType}-bulk-failed-\${jobId}.csv\`\>, csv: \<csv\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:752 (UserController.downloadLandmarkFailedCsv) → src/user/landmark-bulk-jobs.service.ts:266 (LandmarkBulkJobsService.getFailedCsv)

#### USR-040 **GET /user/landmarkbulkjobs/:id/stream**

Stream Landmark Bulk Job

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response SSE (text/event-stream; raw response)

**Request:** param id · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Stream:** Server-Sent Events with event names job_state, log, row, progress, and done. The connection begins with job_state and closes after done or terminal/error handling.

**Response:** SSE (text/event-stream; raw response); observed result variants void | null | \<job.emitter\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:770 (UserController.streamLandmarkBulkJob) → src/user/landmark-bulk-jobs.service.ts:260 (LandmarkBulkJobsService.getEmitter) → src/user/landmark-bulk-jobs.service.ts:254 (LandmarkBulkJobsService.getJob)

#### USR-041 **GET /user/pois**

List Pois

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query q · string · optional ; query isActive · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "POIs fetched", pois: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:687 (UserController.listPois) → src/user/user.service.ts:4600 (UserService.getUserPois)

#### USR-042 **POST /user/pois**

Create Poi

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreatePoiDto · required · schema CreatePoiDto \[src/user/dto/poi.dto.ts\] · fields name: string; description?: string; category: string; color?: string; iconSlug?: string; toleranceMeters?: number; isActive?: boolean; coordinates: PoiCoordinatesDto

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "POI created", poi: {...: spread, toleranceMeters: conditional}}

**Errors:** ConflictException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:704 (UserController.createPoi) → src/user/user.service.ts:4699 (UserService.createUserPoi)

#### USR-043 **DELETE /user/pois/:id**

Delete Poi

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "POI deleted"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:721 (UserController.deletePoi) → src/user/user.service.ts:4890 (UserService.deleteUserPoi)

#### USR-044 **GET /user/pois/:id**

Get Poi By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "POI fetched", poi: {...: spread, toleranceMeters: conditional}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:696 (UserController.getPoiById) → src/user/user.service.ts:4655 (UserService.getUserPoiById)

#### USR-045 **PATCH /user/pois/:id**

Update Poi

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdatePoiDto · required · schema UpdatePoiDto \[src/user/dto/poi.dto.ts\] · fields name?: string; description?: string; category?: string; color?: string; iconSlug?: string; toleranceMeters?: number | null; isActive?: boolean; coordinates?: PoiCoordinatesDto

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "POI updated", poi: {...: spread, toleranceMeters: conditional}}

**Errors:** NotFoundException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:712 (UserController.updatePoi) → src/user/user.service.ts:4797 (UserService.updateUserPoi)

### Groups (5)

#### USR-046 **GET /user/vehicle-groups**

List Vehicle Groups

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle groups fetched successfully", groups: \<mapped\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1198 (UserController.listVehicleGroups) → src/user/user.service.ts:8266 (UserService.listVehicleGroups)

#### USR-047 **POST /user/vehicle-groups**

Create Vehicle Group

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateVehicleGroupDto · required · schema CreateVehicleGroupDto \[src/user/dto/vehicle-group.dto.ts\] · fields name: string; color?: string; vehicleIds?: number\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle group created successfully", group: {id: \<group.id\>, name: \<group.name\>, color: \<group.color\>}}

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1203 (UserController.createVehicleGroup) → src/user/user.service.ts:8317 (UserService.createVehicleGroup)

#### USR-048 **DELETE /user/vehicle-groups/:id**

Delete Vehicle Group

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle group deleted successfully"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1217 (UserController.deleteVehicleGroup) → src/user/user.service.ts:8388 (UserService.deleteVehicleGroup)

#### USR-049 **PATCH /user/vehicle-groups/:id**

Update Vehicle Group

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateVehicleGroupDto · required · schema UpdateVehicleGroupDto \[src/user/dto/vehicle-group.dto.ts\] · fields name?: string; color?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle group updated successfully", group: {id: \<updated.id\>, name: \<updated.name\>, color: \<updated.color\>}}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1208 (UserController.updateVehicleGroup) → src/user/user.service.ts:8352 (UserService.updateVehicleGroup)

#### USR-050 **PUT /user/vehicle-groups/:id/vehicles**

Replace Vehicle Group Vehicles

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · ReplaceVehicleGroupVehiclesDto · required · schema ReplaceVehicleGroupVehiclesDto \[src/user/dto/vehicle-group.dto.ts\] · fields vehicleIds: number\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle group vehicles updated successfully", group: {id: \<groupId\>, vehicleIds: \<vehicleIds\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1225 (UserController.replaceVehicleGroupVehicles) → src/user/user.service.ts:8402 (UserService.replaceVehicleGroupVehicles)

### Live Map and Telemetry (2)

#### USR-051 **GET /user/map-events**

Get Map Events

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · MapEventsQueryDto · required · schema MapEventsQueryDto \[src/superadmin/dto/map-events.dto.ts\] · fields limit?: string; beforeId?: string; from?: string; to?: string; source?: string; severity?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Map events loaded", data: \<result\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1031 (UserController.getMapEvents) → src/user/user.service.ts:7685 (UserService.getMapEvents)

#### USR-052 **GET /user/map-telemetry**

Get Map Telemetry

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query cursor · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Map telemetry fetched", data: {items: \<items\>, cursor: \<nextCursor\>, nextCursor: \<nextCursor\>, hasMore: \<hasMore\>, count: \<items.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1021 (UserController.getMapTelemetry) → src/user/user.service.ts:7426 (UserService.getMapTelemetry)

### Notifications (11)

#### USR-053 **GET /user/notification-settings**

Get Notification Settings

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Notification settings fetched successfully", data: \<settings\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:923 (UserController.getNotificationSettings) → src/user/user.service.ts:5534 (UserService.getNotificationSettings)

#### USR-054 **PUT /user/notification-settings**

Update Notification Settings

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · any · required · observed fields settings · no DTO-enforced field contract

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Notification settings updated successfully", data: \<results\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:928 (UserController.updateNotificationSettings) → src/user/user.service.ts:5543 (UserService.updateNotificationSettings)

#### USR-055 **GET /user/notifications**

Get User Notifications

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · NotificationsQueryDto · required · schema NotificationsQueryDto \[src/superadmin/dto/notifications.dto.ts\] · fields limit?: string; beforeId?: string; unreadOnly?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Notifications fetched successfully", data: {items: \<items\>, nextCursor: \<nextCursor\>, unreadCount: \<unreadCount\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1139 (UserController.getUserNotifications) → src/user/user.service.ts:8039 (UserService.getUserNotifications)

#### USR-056 **PATCH /user/notifications/:id/read**

Mark User Notification Read

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Notification marked as read", data: {id: \<notificationId\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1156 (UserController.markUserNotificationRead) → src/user/user.service.ts:8082 (UserService.markUserNotificationRead)

#### USR-057 **GET /user/notifications/preferences**

Get Notification Preferences

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {channels: \<channels\>, vehicles: \<vehicles\>, basic: \<basic\>, overspeed: \<overspeed\>, duration: \<duration\>, geofences: \<geofences\>, geofenceMatrix: \<geofenceMatrix\>, routes: \<routes\>, routeMatrix: \<routeMatrix\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:940 (UserController.getNotificationPreferences) → src/user/user.service.ts:5582 (UserService.getNotificationPreferences)

#### USR-058 **PUT /user/notifications/preferences**

Update Notification Preferences

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · any · required · observed fields basic, channels, duration, geofences, overspeed, routes · no DTO-enforced field contract

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Saved", data: {}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:945 (UserController.updateNotificationPreferences) → src/user/user.service.ts:5735 (UserService.updateNotificationPreferences)

#### USR-059 **PATCH /user/notifications/read-all**

Mark All User Notifications Read

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "All notifications marked as read", data: {updatedCount: \<result.count\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1148 (UserController.markAllUserNotificationsRead) → src/user/user.service.ts:8105 (UserService.markAllUserNotificationsRead)

#### USR-060 **POST /user/notifications/test-fcm-me**

Send a test FCM push notification to the current user's stored push token(s) so the user can verify notifications are working.

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · TestPushDto · required · schema TestPushDto \[src/auth/dto/push-token.dto.ts\] · fields title?: string; body?: string; platform?: PushTokenPlatformFilter

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Notifications are not configured. Please contact your administrator."} | {action: false, message: "Notification service is not fully configured."} | {action: false, message: \<this.getNoActivePushTokenMessage\>} | {action: false, message: "Notification service encryption is not configured."} | {action: false, message: "Failed to initialize notification service."} | {action: false, message: "Notification service project is not configured."} | {action: false, message: \<safeReason\>, data: {platform: \<platform\>, sent: \<sent\>, failed: \<failed\>, deactivated: \<deactivated\>}} | {action: true, message: \<\`Test notification sent to \${sent} \${targetLabel} device(s).\${failed \> 0 ? \` \${failed} failed.\` : ''}\`\>, data: {platform: \<platform\>, sent: \<sent\>, failed: \<failed\>, deactivated: \<deactivated\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:957 (UserController.testFcmToMe) → src/user/user.service.ts:6079 (UserService.testFcmToMe)

#### USR-061 **GET /user/notifications/vehicle**

Get Vehicle Notifications For Topbar

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · NotificationsQueryDto · required · schema NotificationsQueryDto \[src/superadmin/dto/notifications.dto.ts\] · fields limit?: string; beforeId?: string; unreadOnly?: string ; query vehicleId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle notifications fetched successfully", data: {items: \<items\>, nextCursor: \<nextCursor\>, unreadCount: \<unreadCount\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1169 (UserController.getVehicleNotificationsForTopbar) → src/user/user.service.ts:8126 (UserService.getVehicleNotificationsForTopbar)

#### USR-062 **PATCH /user/notifications/vehicle/:id/read**

Mark Vehicle Notification Read For Topbar

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants void | {action: true, message: "Notification marked as read", data: {id: \<notificationId\>}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1187 (UserController.markVehicleNotificationReadForTopbar) → src/user/user.service.ts:8217 (UserService.markVehicleNotificationReadForTopbar)

#### USR-063 **PATCH /user/notifications/vehicle/read-all**

Mark All Vehicle Notifications Read For Topbar

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "All vehicle notifications marked as read", data: {updatedCount: \<result.count\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1179 (UserController.markAllVehicleNotificationsReadForTopbar) → src/user/user.service.ts:8251 (UserService.markAllVehicleNotificationsReadForTopbar)

### Pricing and Billing (1)

#### USR-064 **GET /user/transactions**

List User Transactions

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query status · string · optional ; query from · string · optional ; query to · string · optional ; query q · string · optional ; query page · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>} | {page: \<page\>, limit: \<limit\>, total: \<total\>, items: \<mapped\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:541 (UserController.listUserTransactions) → src/user/user.service.ts:7328 (UserService.listUserTransactions)

### Profile and Security (9)

#### USR-065 **GET /user/profile**

Get Profile

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found", data: null} | {action: true, message: "Profile fetched successfully", data: \<user\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:454 (UserController.getProfile) → src/user/user.service.ts:3024 (UserService.getProfile)

#### USR-066 **PATCH /user/profile**

Update Profile

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body profileDto · ProfileDto · required · schema ProfileDto \[src/superadmin/dto/profile.dto.ts\] · fields name: string; email?: string; mobilePrefix: string; mobileNumber: string; addressLine: string; countryCode: string; stateCode: string; cityName: string; pincode?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "User not found"} | {action: true, message: "Profile updated successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:459 (UserController.updateProfile) → src/user/user.service.ts:3076 (UserService.updateProfile)

#### USR-067 **GET /user/profile/email-subscription**

Resolve brand owner + SMTP owner for a recipient user.

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, data: {isSubscribed: \<subscribed\>, brandOwnerId: \<brandOwnerId\>, scope: \<scope\>}} | \<result\> | \<cached === SUBSCRIBED\> | \<subscribed\>

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:492 (UserController.getEmailSubscription) → src/email/services/email-context.resolver.ts:97 (EmailContextResolver.resolveContextForRecipient) → src/email/services/email-subscription.service.ts:57 (EmailSubscriptionService.ensureSubscription) → src/email/services/email-subscription.service.ts:89 (EmailSubscriptionService.isSubscribed)

#### USR-068 **POST /user/profile/email-subscription/subscribe**

Resolve brand owner + SMTP owner for a recipient user.

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Subscribed", data: {isSubscribed: true}} | \<result\>

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:503 (UserController.subscribeEmail) → src/email/services/email-context.resolver.ts:97 (EmailContextResolver.resolveContextForRecipient) → src/email/services/email-subscription.service.ts:202 (EmailSubscriptionService.subscribe)

#### USR-069 **POST /user/profile/verify/email/confirm**

Verify an email OTP.

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · VerifyOtpDto · required · schema VerifyOtpDto \[src/verification/dto/verify-otp.dto.ts\] · fields otp: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Email verified successfully"}

**Errors:** HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:473 (UserController.verifyEmailOtp) → src/verification/verification.service.ts:171 (VerificationService.verifyEmailOtp)

#### USR-070 **POST /user/profile/verify/email/request**

Generate and send an email OTP to the user's registered email.

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "SMTP is not configured. Please configure SMTP before sending email OTP.", data: {code: "SMTP_NOT_CONFIGURED"}} | {action: false, message: "Email verification code could not be sent. Please try again later.", data: {code: "EMAIL_DELIVERY_FAILED"}} | {action: true, message: \<\`Verification code sent to \${this.maskEmail(user.email)}\`\>, data: {expiresInSeconds: \<this.otpTtl\>}}

**Errors:** NotFoundException; HttpException; Error; Error — \`Cannot send email: recipient \${recipientUserId} has no email address\`. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:468 (UserController.requestEmailOtp) → src/verification/verification.service.ts:74 (VerificationService.requestEmailOtp)

#### USR-071 **POST /user/profile/verify/whatsapp/confirm**

Verify a WhatsApp OTP.

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · VerifyOtpDto · required · schema VerifyOtpDto \[src/verification/dto/verify-otp.dto.ts\] · fields otp: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Mobile number verified successfully"}

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:483 (UserController.verifyWhatsAppOtp) → src/verification/verification.service.ts:364 (VerificationService.verifyWhatsAppOtp)

#### USR-072 **POST /user/profile/verify/whatsapp/request**

Generate and send a WhatsApp OTP to the user's registered mobile.

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "WhatsApp Meta API is not configured. Please configure WhatsApp integration before sending OTP.", data: {code: \<code\>}} | {action: false, message: "Failed to send WhatsApp verification code. Please try again later.", data: {code: \<(code as string) ?? 'WHATSAPP_SEND_FAILED'\>}} | {action: false, message: "Failed to send WhatsApp verification code. Please try again later.", data: {diagnostics: \<sendResult.diagnostics\>}} | {action: true, message: \<\`Verification code sent to \${this.maskPhone(phone)}\`\>, data: {expiresInSeconds: \<this.otpTtl\>}}

**Errors:** NotFoundException; HttpException; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:478 (UserController.requestWhatsAppOtp) → src/verification/verification.service.ts:233 (VerificationService.requestWhatsAppOtp)

#### USR-073 **PATCH /user/updatepassword**

Update Password

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body passwordDto · UpdatePasswordDto · required · schema UpdatePasswordDto \[src/superadmin/dto/updatepassword.dto.ts\] · fields currentPassword: string; newPassword: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Current password and new password are required"} | {action: false, message: "New password must be different from current password"} | {action: false, message: "User not found"} | {action: false, message: "Password is not set for this user"} | {action: false, message: "Current password is incorrect"} | {action: true, message: "Password updated successfully"}

**Errors:** UnauthorizedException — Invalid user identity; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:519 (UserController.updatePassword) → src/user/user.service.ts:3179 (UserService.updatePassword)

### Reports (3)

#### USR-074 **POST /user/reports/:reportKey**

Generate

Access Bearer JWT (USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param reportKey · string · required ; body dto · GenerateReportDto · required · schema GenerateReportDto \[src/user/reports/reports.dto.ts\] · fields vehicleScope: Record\<string, unknown\>; dateRange: Record\<string, unknown\>; filters: Record\<string, unknown\>; timeZone: string; from: string; to: string; cursor?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Report:** reportKey is distance, driven, overspeed, geofence, sensor, alerts, logs, timeline, or details. Use nextCursor unchanged while hasMore is true.

**Response:** Global success envelope; return type Promise\<unknown\>

**Errors:** BadRequestException — Unsupported report type. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/reports/reports.controller.ts:28 (ReportsController.generate) → src/user/reports/reports.service.ts:193 (ReportsService.generate)

#### USR-075 **GET /user/reports/options**

Lightweight selector data for the reports workspace. The generic vehicle and group screens return many nested fields that reports never consume; keeping this projection small materially reduces DB, JSON and browser work for large fleets.

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Report options fetched", vehicles: \<vehicles\>, groups: \<groupRows.map\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/reports/reports.controller.ts:15 (ReportsController.options) → src/user/reports/reports.service.ts:128 (ReportsService.options)

#### USR-076 **POST /user/reports/timeline/map**

Timeline Map

Access Bearer JWT (USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · TimelineMapDto · required · schema TimelineMapDto \[src/user/reports/reports.dto.ts\] · fields vehicleId: string; from: string; to: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Report:** Timeline route-point lookup is bounded to a maximum 48-hour interval.

**Response:** Global success envelope; observed result variants {action: true, message: "Timeline map loaded", data: {points: \<rows.map\>}}

**Errors:** BadRequestException — Invalid map segment range; BadRequestException — Map segment range cannot exceed 48 hours; BadRequestException — Vehicle is not available. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/reports/reports.controller.ts:20 (ReportsController.timelineMap) → src/user/reports/reports.service.ts:243 (ReportsService.timelineMap)

### Routes and Optimization (5)

#### USR-077 **GET /user/routes**

List Routes

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query q · string · optional ; query isActive · string · optional ; query includeGeodata · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Routes fetched", routes: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:640 (UserController.listRoutes) → src/user/user.service.ts:4311 (UserService.getUserRoutes)

#### USR-078 **POST /user/routes**

Create Route

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateRouteDto · required · schema CreateRouteDto \[src/user/dto/route.dto.ts\] · fields name: string; description?: string; color?: string; isActive?: boolean; toleranceMeters?: number; geodata?: RouteGeoData

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Route created", route: {...: spread, toleranceMeters: conditional}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:658 (UserController.createRoute) → src/user/user.service.ts:4431 (UserService.createUserRoute)

#### USR-079 **DELETE /user/routes/:id**

Delete Route

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Route deleted"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:675 (UserController.deleteRoute) → src/user/user.service.ts:4581 (UserService.deleteUserRoute)

#### USR-080 **GET /user/routes/:id**

Get Route By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Route fetched", route: {...: spread, toleranceMeters: conditional}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:650 (UserController.getRouteById) → src/user/user.service.ts:4379 (UserService.getUserRouteById)

#### USR-081 **PATCH /user/routes/:id**

Update Route

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateRouteDto · required · schema UpdateRouteDto \[src/user/dto/route.dto.ts\] · fields name?: string; description?: string; color?: string; isActive?: boolean; toleranceMeters?: number; geodata?: RouteGeoData

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Route updated", route: {...: spread, toleranceMeters: conditional}}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:666 (UserController.updateRoute) → src/user/user.service.ts:4503 (UserService.updateUserRoute)

### Search (1)

#### USR-082 **GET /user/topbar-search**

Search Topbar

Access Bearer JWT (USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query dto · TopbarSearchQueryDto · required · schema TopbarSearchQueryDto \[src/topbar-search/dto/topbar-search.dto.ts\] · fields q: string; limit?: number = 20

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:64 (UserController.searchTopbar) → src/topbar-search/topbar-search.service.ts:100 (TopbarSearchService.searchForUser)

### Settings and Localization (3)

#### USR-083 **GET /user/localization**

Get Localization Data

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Localization Settings not found"} | {action: true, message: "Localization Settings fetched successfully", data: \<localsettings\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:524 (UserController.getLocalizationData) → src/user/user.service.ts:3251 (UserService.getLocalizationData)

#### USR-084 **PATCH /user/localization**

Update Localization Data

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body localizationDto · UpdateSettingsStateDto · required · schema UpdateSettingsStateDto \[src/superadmin/dto/usersetting.dto.ts\] · fields language?: string; layoutDirection?: LayoutDirectionDto; dateFormat?: string; use24Hour?: boolean; theme?: ThemeModeDto; timezoneOffset?: string; units?: UnitsDto; defaultLat?: number; defaultLon?: number; mapZoom?: number

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Localization settings updated successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:529 (UserController.updateLocalizationData) → src/user/user.service.ts:3263 (UserService.updateLocalizationSettings)

#### USR-085 **GET /user/systemvariables**

Get User System Variables

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "System Variables Fetched Successfully", data: \<systemVariables\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:975 (UserController.getUserSystemVariables) → src/user/user.service.ts:6780 (UserService.getUserSystemVariables)

### Sharing (5)

#### USR-086 **GET /user/sharetracklinks**

List Share Track Links

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query query · ListShareTrackLinksDto · required · schema ListShareTrackLinksDto \[src/user/dto/sharetracklinks/list-sharetracklinks.dto.ts\] · fields search?: string; page?: string; limit?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Share links fetched successfully", data: {items: \<mapped\>, page: \<page\>, limit: \<limit\>, total: \<total\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:158 (UserController.listShareTrackLinks) → src/user/user.service.ts:290 (UserService.listShareTrackLinks)

#### USR-087 **POST /user/sharetracklinks**

Create Share Track Link

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateShareTrackLinkDto · required · schema CreateShareTrackLinkDto \[src/user/dto/sharetracklinks/create-sharetracklink.dto.ts\] · fields vehicleIds: number\[\]; expiryAt: string; isGeofence?: boolean; isHistory?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Link created", data: \<this.mapShareLinkPayload\>}

**Errors:** HttpException; NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:150 (UserController.createShareTrackLink) → src/user/user.service.ts:238 (UserService.createShareTrackLink)

#### USR-088 **DELETE /user/sharetracklinks/:id**

Delete Share Track Link

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Link deleted"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:183 (UserController.deleteShareTrackLink) → src/user/user.service.ts:419 (UserService.deleteShareTrackLink)

#### USR-089 **GET /user/sharetracklinks/:id**

Get Share Track Link By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Share link fetched successfully", data: \<this.mapShareLinkPayload\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:166 (UserController.getShareTrackLinkById) → src/user/user.service.ts:322 (UserService.getShareTrackLinkById)

#### USR-090 **PATCH /user/sharetracklinks/:id**

Update Share Track Link

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateShareTrackLinkDto · required · schema UpdateShareTrackLinkDto \[src/user/dto/sharetracklinks/update-sharetracklink.dto.ts\] · fields vehicleIds?: number\[\]; expiryAt?: string; isGeofence?: boolean; isHistory?: boolean; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Link updated", data: \<this.mapShareLinkPayload\>}

**Errors:** NotFoundException; HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:174 (UserController.updateShareTrackLink) → src/user/user.service.ts:341 (UserService.updateShareTrackLink)

### Subusers (8)

#### USR-091 **GET /user/subusers**

List Sub Users

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query search · string · optional ; query page · string · optional ; query limit · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sub users fetched successfully", data: {items: \<items\>, page: \<page\>, limit: \<limit\>, total: \<total\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:77 (UserController.listSubUsers) → src/user/user.service.ts:1620 (UserService.listSubUsers)

#### USR-092 **POST /user/subusers**

Create Sub User

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateSubUserDto · required · schema CreateSubUserDto \[src/user/dto/subusers/create-subuser.dto.ts\] · fields name: string; username?: string; email?: string; mobilePrefix?: string; mobileNumber?: string; password?: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sub user created successfully", data: \<created\>}

**Errors:** HttpException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:87 (UserController.createSubUser) → src/user/user.service.ts:1667 (UserService.createSubUser)

#### USR-093 **DELETE /user/subusers/:id**

Delete Sub User

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sub user deleted successfully", data: {id: \<subUserId\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:106 (UserController.deleteSubUser) → src/user/user.service.ts:1799 (UserService.deleteSubUser)

#### USR-094 **GET /user/subusers/:id**

Get Sub User By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sub user fetched successfully", data: \<subUser\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:92 (UserController.getSubUserById) → src/user/user.service.ts:1733 (UserService.getSubUserById)

#### USR-095 **PATCH /user/subusers/:id**

Update Sub User

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateSubUserDto · required · schema UpdateSubUserDto \[src/user/dto/subusers/update-subuser.dto.ts\] · fields name?: string; username?: string; email?: string; mobilePrefix?: string; mobileNumber?: string; password?: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sub user updated successfully", data: \<updated\>}

**Errors:** ConflictException; UnauthorizedException — Invalid user identity. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:97 (UserController.updateSubUser) → src/user/user.service.ts:1738 (UserService.updateSubUser)

#### USR-096 **GET /user/subusers/:id/vehicles**

Get Sub User Vehicles

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sub user vehicles fetched successfully", data: \[\]} | {action: true, message: "Sub user vehicles fetched successfully", data: \<vehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:114 (UserController.getSubUserVehicles) → src/user/user.service.ts:1810 (UserService.getSubUserVehicles)

#### USR-097 **POST /user/subusers/:id/vehicles/assign**

Assign Sub User Vehicles

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · AssignSubUserVehiclesDto · required · schema AssignSubUserVehiclesDto \[src/user/dto/subusers/assign-subuser-vehicles.dto.ts\] · fields vehicleIds: number\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles assigned successfully", data: {assigned: \<created.count\>}}

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:122 (UserController.assignSubUserVehicles) → src/user/user.service.ts:1851 (UserService.assignSubUserVehicles)

#### USR-098 **POST /user/subusers/:id/vehicles/unassign**

Unassign Sub User Vehicles

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UnassignSubUserVehiclesDto · required · schema UnassignSubUserVehiclesDto \[src/user/dto/subusers/unassign-subuser-vehicles.dto.ts\] · fields vehicleIds: number\[\]

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles unassigned successfully", data: {removed: \<result.count\>}}

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:131 (UserController.unassignSubUserVehicles) → src/user/user.service.ts:1886 (UserService.unassignSubUserVehicles)

### Support (4)

#### USR-099 **GET /user/tickets**

GET /user/tickets List all tickets for current logged-in user

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Tickets fetched successfully", data: \<tickets\>} | {action: false, message: \<error.message || 'Failed to fetch tickets'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:559 (UserController.listTickets) → src/user/user.service.ts:3328 (UserService.listTickets)

#### USR-100 **POST /user/tickets**

POST /user/tickets Create a new ticket with first message and optional attachments

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "Title is required and must be max 120 characters", data: null} | {action: false, message: "Invalid category", data: null} | {action: false, message: "Message is required and must be max 5000 characters", data: null} | {action: false, message: "Invalid priority", data: null} | {action: true, message: "Ticket created successfully", data: {id: \<ticket.id\>, ticketNo: \<ticketNo\>}} | {action: false, message: \<error.message || 'Failed to create ticket'\>, data: null}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:564 (UserController.createTicket) → src/user/user.service.ts:3358 (UserService.createTicket)

#### USR-101 **GET /user/tickets/:id**

GET /user/tickets/:id Get ticket details with full conversation

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Unauthorized to access this ticket", data: null} | {action: true, message: "Ticket fetched successfully", data: \<ticketData\>} | {action: false, message: \<error.message || 'Failed to fetch ticket'\>, data: null}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:572 (UserController.getTicketConversation) → src/user/user.service.ts:3550 (UserService.getTicketConversation)

#### USR-102 **POST /user/tickets/:id**

POST /user/tickets/:id Add a new message (reply) to ticket with optional attachments

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json or multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** Support request/reply attachment parts use attachments or attachments\[\]. Up to five files, 5 MiB each; unsafe SVG/HTML/JavaScript/executable content is blocked.

**Response:** Global success envelope; observed result variants {action: false, message: "Ticket not found", data: null} | {action: false, message: "Unauthorized to reply to this ticket", data: null} | {action: false, message: "Cannot reply to a closed ticket", data: null} | {action: false, message: "Message is required and must be max 5000 characters", data: null} | {action: true, message: "Message sent successfully", data: {messageId: \<ticketMessage.id\>}} | {action: false, message: \<error.message || 'Failed to send message'\>, data: null}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:580 (UserController.addTicketMessage) → src/user/user.service.ts:3610 (UserService.addTicketMessage)

### Vehicles (24)

#### USR-103 **GET /user/vehicles**

Get User Vehicles

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicles fetched successfully", vehicles: \<vehicles\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:140 (UserController.getUserVehicles) → src/user/user.service.ts:187 (UserService.getUserVehicles)

#### USR-104 **GET /user/vehicles/:id**

Get Vehicle By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found"} | {action: true, message: "Vehicle fetched successfully", vehicle: \<normalized\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:196 (UserController.getVehicleById) → src/user/user.service.ts:434 (UserService.getVehicleById)

#### USR-105 **PATCH /user/vehicles/:id**

Update Vehicle By Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateUserVehicleDto · required · schema UpdateUserVehicleDto \[src/user/dto/update-vehicle.dto.ts\] · fields name?: string; plateNumber?: string | null; vin?: string | null; vehicleTypeId?: number; gmtOffset?: string | null; vehicleMeta?: Record\<string, any\>

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found"} | {action: true, message: "Vehicle updated successfully", vehicle: \<normalized\>}

**Errors:** Error; ConflictException; NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:201 (UserController.updateVehicleById) → src/user/user.service.ts:510 (UserService.updateVehicleById)

#### USR-106 **PATCH /user/vehicles/:id/config**

Update Vehicle Config

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; body dto · UpdateVehicleConfigDto · required · schema UpdateVehicleConfigDto \[src/user/dto/update-vehicle-config.dto.ts\] · fields speedVariation?: number; distanceVariation?: number; odometer?: number; engineHours?: number; ignitionSource?: 'ACC' | 'MOTION'

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle config fetched successfully", data: conditional} | {action: true, message: "Vehicle config updated successfully", data: {...: spread, speedVariation: conditional, distanceVariation: conditional, odometer: conditional, engineHours: conditional}, meta: {telemetrySynced: \<telemetrySynced\>}}

**Errors:** NotFoundException; HttpException; ConflictException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:210 (UserController.updateVehicleConfig) → src/user/user.service.ts:695 (UserService.updateVehicleConfig)

#### USR-107 **GET /user/vehicles/:id/documents**

Get Vehicle Documents

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle documents fetched successfully", data: \<files\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:311 (UserController.getVehicleDocuments) → src/user/user.service.ts:1422 (UserService.getVehicleDocuments)

#### USR-108 **POST /user/vehicles/:id/documents**

Upload Vehicle Document

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Request must be multipart/form-data' } as any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:319 (UserController.uploadVehicleDocument) → src/user/user.service.ts:1440 (UserService.uploadVehicleDocumentMultipart)

#### USR-109 **DELETE /user/vehicles/:id/documents/:docId**

Delete Vehicle Document

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; param docId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Document not found"} | {action: false, message: "Access denied to delete this document"} | {action: true, message: "Document deleted successfully", data: \<updated\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:338 (UserController.deleteVehicleDocument) → src/user/user.service.ts:1543 (UserService.deleteVehicleDocument)

#### USR-110 **PATCH /user/vehicles/:id/documents/:docId**

Update Vehicle Document

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request multipart/form-data · Response JSON through global success envelope

**Request:** param id · number · required · pipes ParseIntPipe ; param docId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Upload:** One document file. Metadata supports title, fileName, docTypeId, description, tags, associateType, associateId, fileType, expiryAt, isVisible, and isVisibleDriver; route-scoped vehicle/driver uploads force the association.

**Response:** Global success envelope; observed result variants \<{ action: false, message: 'Document not found' } as any\> | \<{ action: false, message: 'Access denied to update this document' } as any\> | \<{ action: false, message: 'Request must be multipart/form-data' } as any\> | \<updatedResult\> | {action: true, message: "Document updated successfully", data: \<updatedWithFile\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:328 (UserController.updateVehicleDocument) → src/user/user.service.ts:1478 (UserService.updateVehicleDocumentMultipart)

#### USR-111 **GET /user/vehicles/:vehicleId/commands**

Get Command History By Vehicle Id

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; query limit · string · optional ; query cursorId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Command history retrieved", data: \<buildDeviceCommandLogListResponse\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1001 (UserController.getCommandHistoryByVehicleId) → src/user/user.service.ts:7039 (UserService.getCommandHistoryByVehicleId)

#### USR-112 **GET /user/vehicles/:vehicleId/sensors**

List Vehicle Sensors

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; query search · string · optional ; query page · string · optional ; query limit · string · optional ; query includeLive · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: {items: \<items\>, page: \<page\>, limit: \<limit\>, total: \<total\>}} | {action: true, message: "OK", data: {items: \<enriched.items\>, page: \<page\>, limit: \<limit\>, total: \<total\>, telemetryMeta: \<enriched.telemetryMeta\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:223 (UserController.listVehicleSensors) → src/user/user.service.ts:808 (UserService.listVehicleSensors)

#### USR-113 **POST /user/vehicles/:vehicleId/sensors**

Create Vehicle Sensor

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; body dto · CreateVehicleSensorDto · required · schema CreateVehicleSensorDto \[src/user/dto/sensors/create-vehicle-sensor.dto.ts\] · fields name: string; unit?: string; icon?: string; code: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sensor created", data: \<created\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:238 (UserController.createVehicleSensor) → src/user/user.service.ts:917 (UserService.createVehicleSensor)

#### USR-114 **DELETE /user/vehicles/:vehicleId/sensors/:sensorId**

Delete Vehicle Sensor

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; param sensorId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sensor deleted"}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:257 (UserController.deleteVehicleSensor) → src/user/user.service.ts:1014 (UserService.deleteVehicleSensor)

#### USR-115 **PATCH /user/vehicles/:vehicleId/sensors/:sensorId**

Update Vehicle Sensor

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; param sensorId · number · required · pipes ParseIntPipe ; body dto · UpdateVehicleSensorDto · required · schema UpdateVehicleSensorDto \[src/user/dto/sensors/update-vehicle-sensor.dto.ts\] · fields name?: string; unit?: string; icon?: string; code?: string; isActive?: boolean

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Sensor updated", data: \<updated\>}

**Errors:** NotFoundException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:247 (UserController.updateVehicleSensor) → src/user/user.service.ts:957 (UserService.updateVehicleSensor)

#### USR-116 **GET /user/vehicles/:vehicleId/sensors/:sensorId/history**

Get Sensor History

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; param sensorId · number · required · pipes ParseIntPipe ; query from · string · optional ; query to · string · optional ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants \<emptyResult\> | {action: true, message: "No telemetry data available", data: {supported: true, vehicle: {id: \<vehicleId\>, imei: \<imei\>}, sensor: \<sensorMeta\>, range: {from: \<fromDate.toISOString\>, to: \<toDate.toISOString\>}, sampling: {maxPoints: \<maxPoints\>, bucketSec: \<bucketSec\>, estimatedBuckets: \<estimatedBuckets\>, returnedPoints: 0, errorCount: 0}, points: \[\], stats: {min: null, max: null, avg: null, first: null, last: null}}} | {action: true, message: "Sensor history", data: {supported: true, vehicle: {id: \<vehicleId\>, imei: \<imei\>}, sensor: \<sensorMeta\>, range: {from: \<fromDate.toISOString\>, to: \<toDate.toISOString\>}, sampling: {maxPoints: \<maxPoints\>, bucketSec: \<bucketSec\>, estimatedBuckets: \<estimatedBuckets\>, returnedPoints: \<points.length\>, errorCount: \<errorCount\>}, points: \<points\>, stats: \<stats\>}}

**Errors:** NotFoundException; HttpException; BadRequestException — code must be at least 5 characters; BadRequestException — Code too large; BadRequestException — payload must be a JSON object; BadRequestException — payload is not serialisable; BadRequestException — Payload too large; BadRequestException — Execution timed out; BadRequestException — safe. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:283 (UserController.getSensorHistory) → src/user/user.service.ts:1094 (UserService.getVehicleSensorHistory)

#### USR-117 **POST /user/vehicles/:vehicleId/sensors/run**

Run Vehicle Sensor

Access Bearer JWT (ADMIN, USER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe ; body dto · RunVehicleSensorDto · required · schema RunVehicleSensorDto \[src/user/dto/sensors/run-vehicle-sensor.dto.ts\] · fields code: string; payload: Record\<string, unknown\>

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Run OK", data: \<run\>}

**Errors:** BadRequestException — code must be at least 5 characters; BadRequestException — Code too large; BadRequestException — payload must be a JSON object; BadRequestException — payload is not serialisable; BadRequestException — Payload too large; BadRequestException — Execution timed out; BadRequestException — safe. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:266 (UserController.runVehicleSensor) → src/user/user.service.ts:1030 (UserService.runVehicleSensor)

#### USR-118 **GET /user/vehicles/:vehicleId/sensors/telemetry**

Get Vehicle Sensor Telemetry

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "No IMEI assigned", data: {telemetry: null, imei: null}} | {action: true, message: conditional, data: {telemetry: \<telemetry ?? null\>, imei: \<vehicle.imei\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:275 (UserController.getVehicleSensorTelemetry) → src/user/user.service.ts:1036 (UserService.getVehicleSensorTelemetry)

#### USR-119 **GET /user/vehicles/:vehicleId/telemetry**

Get Vehicle Telemetry Snapshot

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param vehicleId · number · required · pipes ParseIntPipe

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "No IMEI", data: null} | {action: true, message: "No telemetry", data: null} | {action: true, message: "Live telemetry snapshot", data: \<telemetry\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:299 (UserController.getVehicleTelemetrySnapshot) → src/user/user.service.ts:1057 (UserService.getVehicleTelemetrySnapshot)

#### USR-120 **GET /user/vehicles/by-imei/:imei/details**

Get Vehicle Details By Imei

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Vehicle not found", data: null} | {action: true, message: "Vehicle details loaded", data: {vehicle: \<vehicle\>, telemetry: \<live ?? null\>, deviceStatus: \<deviceStatus\>, lastConnectionAt: \<lastConnectionAt\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1039 (UserController.getVehicleDetailsByImei) → src/user/user.service.ts:7740 (UserService.getMapVehicleDetailsByImei)

#### USR-121 **GET /user/vehicles/by-imei/:imei/events**

Get Vehicle Events By Imei

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query query · MapEventsQueryDto · required · schema MapEventsQueryDto \[src/superadmin/dto/map-events.dto.ts\] · fields limit?: string; beforeId?: string; from?: string; to?: string; source?: string; severity?: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle events loaded", data: \<result\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1064 (UserController.getVehicleEventsByImei) → src/user/user.service.ts:7695 (UserService.getMapVehicleEventsByImei)

#### USR-122 **GET /user/vehicles/by-imei/:imei/history**

Get Vehicle History By Imei

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · required ; query to · string · required ; query stopMin · string · optional ; query overspeedKph · string · optional ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<history.message\>, data: null} | {action: true, message: "History loaded", data: \<history.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1105 (UserController.getVehicleHistoryByImei) → src/user/user.service.ts:7910 (UserService.getMapVehicleHistoryByImei)

#### USR-123 **GET /user/vehicles/by-imei/:imei/logs**

Get Vehicle Logs By IMEI

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · optional ; query to · string · optional ; query limit · string · optional ; query beforeId · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: "Invalid cursor", data: {items: \[\], nextCursor: null}} | {action: false, message: \<dateRange.message\>, data: {items: \[\], nextCursor: null}} | {action: true, message: "Telemetry logs loaded", data: {items: \<items\>, nextCursor: \<nextCursor\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1047 (UserController.getVehicleLogsByIMEI) → src/user/user.service.ts:7815 (UserService.getMapVehicleLogsByImei)

#### USR-124 **GET /user/vehicles/by-imei/:imei/replay**

Get Vehicle Replay By Imei

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query from · string · required ; query to · string · required ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<replay.message\>, data: null} | {action: true, message: "Replay data loaded", data: \<replay.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1090 (UserController.getVehicleReplayByImei) → src/user/user.service.ts:7886 (UserService.getMapVehicleReplayByImei)

#### USR-125 **GET /user/vehicles/by-imei/:imei/sensors**

Get Vehicle Sensors By Imei

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query includeTelemetryMeta · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "OK", data: \<data\>}

**Errors:** BadRequestException — code must be at least 5 characters; BadRequestException — Code too large; BadRequestException — payload must be a JSON object; BadRequestException — payload is not serialisable; BadRequestException — Payload too large; BadRequestException — Execution timed out; BadRequestException — safe. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/user/user.controller.ts:1124 (UserController.getVehicleSensorsByImei) → src/user/user.service.ts:7932 (UserService.getMapVehicleSensorsByImei)

#### USR-126 **GET /user/vehicles/by-imei/:imei/trail**

Get Vehicle Trail By Imei

Access Bearer JWT (ADMIN, USER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; query hours · string · optional ; query from · string · optional ; query to · string · optional ; query maxPoints · string · optional

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: false, message: \<trail.message\>, data: null} | {action: true, message: "Vehicle trail loaded", data: \<trail.data\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/user/user.controller.ts:1073 (UserController.getVehicleTrailByImei) → src/user/user.service.ts:7862 (UserService.getMapVehicleTrailByImei)

## Public and Shared APIs

19 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Email Subscription (1)

#### PUB-001 **GET /unsubscribe**

Validate an unsubscribe token in constant time.

Access Public · Success HTTP 200 · Request No request body · Response HTML document (raw response)

**Request:** query u · string · required ; query b · string · required ; query s · string · required ; query t · string · required

**Document:** Returns an HTML page directly; intended for browser navigation from the unsubscribe link.

**Response:** HTML document (raw response); observed result variants \<sendHtml\> | false | \<timingSafeEqual\>

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/app.controller.ts:30 (AppController.unsubscribe) → src/email/services/email-subscription.service.ts:243 (EmailSubscriptionService.validateToken) → src/email/services/email-subscription.service.ts:57 (EmailSubscriptionService.ensureSubscription) → src/email/services/email-subscription.service.ts:159 (EmailSubscriptionService.unsubscribe)

### Public Branding (1)

#### PUB-002 **GET /branding**

Get Branding

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query host · string · optional

**Response:** Global success envelope; observed result variants null | \<branding\> | \<inspection.branding\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:221 (AppController.getBranding) → src/branding/branding-resolver.service.ts:143 (BrandingResolverService.resolveBrandingByHost)

### Public Catalog (2)

#### PUB-003 **GET /devicestypes**

Get Device Types

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Device types fetched successfully", data: \<deviceTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:123 (AppController.getDeviceTypes) → src/app.service.ts:22 (AppService.getDeviceTypes)

#### PUB-004 **GET /vehicletypes**

Get Vehicle Types

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Vehicle types fetched successfully", data: \<vehicleTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:128 (AppController.getVehicleTypes) → src/app.service.ts:35 (AppService.getVehicleTypes)

### Shared Public (15)

#### PUB-005 **GET /**

Get Hello

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants "Finally i did CI-CD with github actions."

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:18 (AppController.getHello) → src/app.service.ts:18 (AppService.getHello)

#### PUB-006 **GET /cities/:countryCode/:stateCode**

Get Cities

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param countryCode · string · required · observed fields toUpperCase · no DTO-enforced field contract ; param stateCode · string · required · observed fields toUpperCase · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: "Cities fetched successfully", data: \<this.appService.getCitiesByState\>} | \<cities.map\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:150 (AppController.getCities) → src/app.service.ts:73 (AppService.getCitiesByState)

#### PUB-007 **GET /countries**

Get Countries

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Countries fetched successfully", data: \<this.appService.getCountries\>} | \<countries.map\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:139 (AppController.getCountries) → src/app.service.ts:55 (AppService.getCountries)

#### PUB-008 **GET /currencies**

Get Currencies

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Currencies fetched successfully", data: \<this.appService.getCurrencies\>} | \<currencies\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:158 (AppController.getCurrencies) → src/app.service.ts:82 (AppService.getCurrencies)

#### PUB-009 **GET /dateformats**

Get Date Formats

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Date formats fetched successfully", data: \<DATE_FORMATS\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:211 (AppController.getDateFormats) → src/app.service.ts:121 (AppService.getDateFormats)

#### PUB-010 **GET /documenttypes/:documentType**

Get Document Types

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param documentType · string · required · observed fields toUpperCase · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: "Document types fetched successfully", data: \<documentTypes\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:216 (AppController.getDocumentTypes) → src/app.service.ts:125 (AppService.getDocumentTypes)

#### PUB-011 **GET /languages**

Get Languages

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Languages fetched successfully", data: \<LANGUAGES\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:173 (AppController.getLanguages) → src/app.service.ts:117 (AppService.getLanguages)

#### PUB-012 **GET /mobileprefix**

Get Mobile Code

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Mobile codes fetched successfully", data: \<this.appService.getMobileCode\>} | \<countries.map\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:133 (AppController.getMobileCode) → src/app.service.ts:45 (AppService.getMobileCode)

#### PUB-013 **GET /policies**

Get Policies

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Policies fetched successfully", data: \<policies\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:178 (AppController.getPolicies)

#### PUB-014 **GET /policies/:type**

Get Policy By Type

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param type · string · required · observed fields toUpperCase · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: false, message: "Policy not found", data: null} | {action: true, message: "Policy fetched successfully", data: \<policy\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:192 (AppController.getPolicyByType)

#### PUB-015 **GET /simproviders**

Get Sim Providers

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "SIM Providers fetched successfully", data: \<this.appService.getSimProviders\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:163 (AppController.getSimProviders) → src/app.service.ts:102 (AppService.getSimProviders)

#### PUB-016 **GET /states/:countryCode**

Get States

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param countryCode · string · required · observed fields toUpperCase · no DTO-enforced field contract

**Response:** Global success envelope; observed result variants {action: true, message: "States fetched successfully", data: \<this.appService.getStatesByCountry\>} | \<states.map\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:145 (AppController.getStates) → src/app.service.ts:63 (AppService.getStatesByCountry)

#### PUB-017 **GET /status**

Get Status

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants "Running"

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:116 (AppController.getStatus)

#### PUB-018 **GET /timezones**

Get Timezones

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Timezones fetched successfully", data: \<this.appService.getTimezones\>} | \<zones\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:168 (AppController.getTimezones) → src/app.service.ts:113 (AppService.getTimezones)

#### PUB-019 **GET /version**

Get Version

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Version fetched successfully", version: "2.6.0"}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/app.controller.ts:23 (AppController.getVersion)

## Public Tracking APIs

7 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Public Tracking (7)

#### TRACK-001 **GET /public/track/:code**

Lightweight metadata for the share link – used on first load to drive UI permissions (history tab, geofence overlay), set the page title, and hydrate the vehicle list before live telemetry arrives.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required

**Response:** Global success envelope; observed result variants {action: true, message: "Share link resolved", data: {uniqueCode: \<link.uniqueCode\>, isActive: \<link.isActive\>, expiryAt: \<link.expiryAt\>, createdAt: \<link.createdAt\>, permissions: {isGeofence: \<link.isGeofence\>, isHistory: \<link.isHistory\>}, vehicles: \<allowedVehicles.map\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/public-track/public-track.controller.ts:18 (PublicTrackController.getLinkMeta) → src/public-track/public-track.service.ts:117 (PublicTrackService.getLinkMeta)

#### TRACK-002 **GET /public/track/:code/geofences**

Get Geofences

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/public-track/public-track.controller.ts:71 (PublicTrackController.getGeofences) → src/public-track/public-track.service.ts:213 (PublicTrackService.getGeofences)

#### TRACK-003 **GET /public/track/:code/telemetry**

Map telemetry – delegates to UserService and post-filters to only the vehicles attached to this share link.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required ; query cursor · string · optional ; query limit · string · optional

**Response:** Global success envelope; observed result variants {action: true, message: "Map telemetry fetched", data: {items: \<filtered\>, nextCursor: \<payload?.nextCursor ?? payload?.cursor ?? null\>, hasMore: \<payload?.hasMore ?? false\>, count: \<filtered.length\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/public-track/public-track.controller.ts:23 (PublicTrackController.getMapTelemetry) → src/public-track/public-track.service.ts:149 (PublicTrackService.getMapTelemetry)

#### TRACK-004 **GET /public/track/:code/vehicles/:imei/details**

Get Vehicle Details By Imei

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required ; param imei · string · required

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/public-track/public-track.controller.ts:33 (PublicTrackController.getVehicleDetailsByImei) → src/public-track/public-track.service.ts:179 (PublicTrackService.getVehicleDetailsByImei)

#### TRACK-005 **GET /public/track/:code/vehicles/:imei/history**

Get Vehicle History By Imei

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required ; param imei · string · required ; query from · string · required ; query to · string · required ; query stopMin · string · optional ; query overspeedKph · string · optional ; query maxPoints · string · optional

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** HttpException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/public-track/public-track.controller.ts:52 (PublicTrackController.getVehicleHistoryByImei) → src/public-track/public-track.service.ts:200 (PublicTrackService.getVehicleHistoryByImei)

#### TRACK-006 **GET /public/track/:code/vehicles/:imei/logs**

Telemetry logs limited to the \*\*current calendar day\*\* (UTC).

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required ; param imei · string · required ; query limit · string · optional ; query beforeId · string · optional

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/public-track/public-track.controller.ts:76 (PublicTrackController.getVehicleLogsByImei) → src/public-track/public-track.service.ts:228 (PublicTrackService.getVehicleLogsByImei)

#### TRACK-007 **GET /public/track/:code/vehicles/:imei/replay**

Get Vehicle Replay By Imei

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param code · string · required ; param imei · string · required ; query from · string · required ; query to · string · required ; query maxPoints · string · optional

**Response:** Global success envelope; return type Promise\<any\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/public-track/public-track.controller.ts:41 (PublicTrackController.getVehicleReplayByImei) → src/public-track/public-track.service.ts:185 (PublicTrackService.getVehicleReplayByImei)

## Geocoding APIs

3 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Geocoding (3)

#### GEO-001 **GET /geocoding/precision**

Precision

Access Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER, TEAM, DRIVER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {action: true, message: "Current geocoding precision", data: {precision: \<p\>}} | \<precision\>

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/geocoding/geocoding.controller.ts:111 (GeocodingController.precision) → src/geocoding/geocoding.service.ts:219 (GeocodingService.resolvePrecision)

#### GEO-002 **GET /geocoding/reverse**

Reverse

Access Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER, TEAM, DRIVER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** query lat · string · required ; query lng · string · required

**Response:** Global success envelope; observed result variants {action: true, message: "Address resolved", data: {address: \<result.address\>, cached: \<result.source !== 'api'\>, precision: \<precision\>, rounded: {lat: \<latRounded\>, lon: \<lonRounded\>}, providerUsed: \<result.providerUsed ?? result.source\>}} | {action: false, message: "Geocoding failed internally", data: {address: ""}} | \<precision\> | {lat: \<lat\>, lon: \<lng\>, address: "", source: "api"} | {lat: \<latRounded\>, lon: \<lonRounded\>, address: "", source: "redis", providerUsed: "redis"} | {lat: \<latRounded\>, lon: \<lonRounded\>, address: \<cached\>, source: "redis", providerUsed: "redis"} | {lat: \<latRounded\>, lon: \<lonRounded\>, address: \<dbAddress\>, source: "db", providerUsed: "db"}

**Errors:** BadRequestException — lat and lng must be valid numbers; BadRequestException — lat must be in range \[-90, 90\]; BadRequestException — lng must be in range \[-180, 180\]; Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/geocoding/geocoding.controller.ts:35 (GeocodingController.reverse) → src/geocoding/geocoding.service.ts:219 (GeocodingService.resolvePrecision) → src/geocoding/geocoding.service.ts:398 (GeocodingService.getOrCreateAddress)

#### GEO-003 **POST /geocoding/reverse/bulk**

Resolve many points efficiently.

Access Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER, TEAM, DRIVER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · BulkReverseGeocodeDto · required · schema BulkReverseGeocodeDto \[src/geocoding/dto/reverse-geocode.dto.ts\] · fields points: BulkPointDto\[\]

**Response:** Global success envelope; observed result variants {action: true, message: \<\`Resolved \${items.length} addresses\`\>, data: {items: \<items\>}} | \<results\>

**Errors:** Error — Redis client is not initialized. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/geocoding/geocoding.controller.ts:87 (GeocodingController.reverseBulk) → src/geocoding/geocoding.service.ts:462 (GeocodingService.resolveBulk)

## Feedback APIs

2 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Feedback (2)

#### FDBK-001 **POST /bug-reports**

Create

Access Bearer JWT (any authenticated role) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateBugReportDto · required · schema CreateBugReportDto \[src/bug-report/dto/create-bug-report.dto.ts\] · fields message: string; category?: string; severity?: BugReportSeverity = BugReportSeverity.MEDIUM; pageUrl?: string; route?: string; title?: string; screenshotDataUrl?: string; uploadedScreenshotDataUrl?: string; browser?: Record\<string, any\>; os?: Record\<string, any\>; device?: Record\<string, any\>; screen?: Record\<string, any\>; network?: Record\<string, any\>; app?: Record\<string, any\>; recentErrors?: any\[\]; stepsToReproduce?: string; expectedBehavior?: string; actualBehavior?: string; extra?: Record\<string, any\>

**Response:** Global success envelope; observed result variants {action: false, message: "Unable to submit bug report right now. Please try again."} | {action: true, message: "Bug report submitted successfully", data: {reportId: \<this.extractReportId\>, submittedAt: \<submittedAt\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/bug-report/bug-report.controller.ts:28 (BugReportController.create) → src/bug-report/bug-report.service.ts:59 (BugReportService.submitBugReport)

#### FDBK-002 **POST /feature-requests**

Create

Access Bearer JWT (SUPERADMIN) · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateFeatureRequestDto · required · schema CreateFeatureRequestDto \[src/feature-request/dto/create-feature-request.dto.ts\] · fields requestType: FeatureRequestType; title: string; description: string; priority?: FeatureRequestPriority = FeatureRequestPriority.MEDIUM; module?: string; expectedOutcome?: string; protocolName?: string; deviceModel?: string; samplePacket?: string; protocolDocumentDataUrl?: string; protocolDocumentName?: string; pageUrl?: string; route?: string; browser?: Record\<string, any\>; os?: Record\<string, any\>; device?: Record\<string, any\>; screen?: Record\<string, any\>; app?: Record\<string, any\>; extra?: Record\<string, any\>

**Response:** Global success envelope; observed result variants {action: false, message: "Unable to submit feature request right now. Please try again."} | {action: true, message: "Feature request submitted successfully", data: {requestId: \<this.extractRequestId\>, submittedAt: \<submittedAt\>}}

**Errors:** UnauthorizedException — Only Superadmin can submit feature or protocol requests.. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/feature-request/feature-request.controller.ts:33 (FeatureRequestController.create) → src/feature-request/feature-request.service.ts:52 (FeatureRequestService.submitFeatureRequest)

## Agent Orchestration APIs

3 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Agent Orchestration (3)

#### AGENT-001 **POST /agent/commands**

Submit a natural-language or structured command to the agent orchestrator.

Access Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER) · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body dto · CreateAgentCommandDto · required · schema CreateAgentCommandDto \[src/agent/dto/create-agent-command.dto.ts\] · fields command: string; channel?: 'WEB' | 'API' | 'WHATSAPP' | 'WORKFLOW'; payload?: StructuredCommandPayload; metadata?: Record\<string, any\>

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Command received", data: \<result\>} | {ok: false, executionId: \<execution.executionId\>, agent: "none", intent: \<parsed.intent\>, status: "failed", message: "Could not determine a supported intent from the command", errorCode: "UNKNOWN_INTENT"}

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/agent/controllers/agent.controller.ts:33 (AgentController.createCommand) → src/agent/orchestrator/orchestrator.service.ts:45 (OrchestratorService.handleCommand)

#### AGENT-002 **GET /agent/executions/:executionId**

Retrieve the full execution record including result / error payloads.

Access Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param params · ExecutionIdParamDto · required · schema ExecutionIdParamDto \[src/agent/dto/execution-id-param.dto.ts\] · fields executionId: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Execution loaded", data: \<execution\>} | \<execution!\>

**Errors:** NotFoundException; UnauthorizedException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/agent/controllers/agent.controller.ts:55 (AgentController.getExecution) → src/agent/orchestrator/execution-store.service.ts:119 (ExecutionStoreService.getByExecutionIdOrThrow)

#### AGENT-003 **GET /agent/executions/:executionId/status**

Lightweight status-only endpoint for polling from the UI or WhatsApp callback workers.

Access Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER) · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param params · ExecutionIdParamDto · required · schema ExecutionIdParamDto \[src/agent/dto/execution-id-param.dto.ts\] · fields executionId: string

**Identity:** User ID is derived from the validated JWT; clients must not send a separate HeaderId value.

**Response:** Global success envelope; observed result variants {action: true, message: "Status loaded", data: \<status\>} | \<statusPayload\>

**Errors:** NotFoundException; UnauthorizedException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/agent/controllers/agent.controller.ts:75 (AgentController.getExecutionStatus) → src/agent/orchestrator/execution-store.service.ts:140 (ExecutionStoreService.getStatusOrThrow)

## Webhooks APIs

2 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Webhooks (2)

#### WH-001 **GET /webhooks/whatsapp**

Verify

Access Public · Success HTTP 200 · Request No request body · Response Raw Fastify response

**Request:** query hub.mode · string · required ; query hub.verify_token · string · required ; query hub.challenge · string · required

**Webhook:** Fastify response is written directly. GET is the provider verification path; POST is the inbound event delivery path.

**Response:** Raw Fastify response; observed result variants void

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/webhooks/whatsapp-webhook.controller.ts:94 (WhatsappWebhookController.verify)

#### WH-002 **POST /webhooks/whatsapp**

Check if key exists

Access Public · Success HTTP 200 · Request No request body · Response Raw Fastify response

**Request:** No client-supplied path, query, or body fields.

**Webhook:** Fastify response is written directly. GET is the provider verification path; POST is the inbound event delivery path.

**Response:** Raw Fastify response; observed result variants void | \<result === 1\>

**Errors:** Error. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/webhooks/whatsapp-webhook.controller.ts:124 (WhatsappWebhookController.inbound) → src/redis/redis.service.ts:514 (RedisService.exists) → src/redis/redis.service.ts:463 (RedisService.set) → src/webhooks/whatsapp-webhook.service.ts:28 (WhatsappWebhookService.processInboundMessage)

## Internal Ingestion APIs

2 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Internal Ingestion (2)

#### ING-001 **POST /handledata**

Handle Data

Access x-listener-secret header · Success HTTP 201 · Request application/json · Response JSON through global success envelope

**Request:** body payload · any · required · observed fields \_current, \_previous · no DTO-enforced field contract

**Internal auth:** Send x-listener-secret exactly as configured by LISTNER_KEY. Bearer JWT is not used for this route.

**Response:** Global success envelope; observed result variants {action: false, message: "Rejected: missing IMEI"} | {action: false, message: "Rejected: invalid telemetry payload"} | {action: true, message: "Unknown device quarantined"} | {action: true, message: conditional} | {action: true, message: "Telemetry accepted for processing"}

**Errors:** ServiceUnavailableException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/handledata/handledata.controller.ts:15 (HandledataController.handleData) → src/handledata/handledata.service.ts:1950 (HandledataService.ingest)

#### ING-002 **POST /handledata/batch**

Handle Batch

Access x-listener-secret header · Success HTTP 200 · Request application/json · Response JSON through global success envelope

**Request:** body body · any · required · observed fields items, payloads · no DTO-enforced field contract

**Internal auth:** Send x-listener-secret exactly as configured by LISTNER_KEY. Bearer JWT is not used for this route.

**Response:** Global success envelope; observed result variants {action: \<accepted \> 0\>, accepted: \<accepted\>, rejected: \<rejected\>, results: \<finalResults\>}

**Errors:** HttpException; ServiceUnavailableException. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/handledata/handledata.controller.ts:29 (HandledataController.handleBatch) → src/handledata/handledata.service.ts:1829 (HandledataService.ingestBatch)

## Health and Operations APIs

19 source-backed HTTP routes. Access, input, response, error, and source details are recorded per route.

### Health and Readiness (19)

#### OPS-001 **GET /health**

Get Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, timestamp: \<new Date().toISOString\>, service: "NestJS Backend", build: \<this.buildFingerprint\>, runtime: \<describeBackendRuntimeProfile\>, services: {redis: {status: conditional, durability: \<redisDurability\>}, databases: {primary: conditional, logs: conditional, address: conditional}}} | true | false | \<result === 'PONG'\> | {mode: conditional, appendOnly: \<appendOnly\>, snapshotting: \<snapshotting\>, lastRdbStatus: \<persistenceInfo.rdb_last_bgsave_status ?? null\>, lastAofStatus: \<persistenceInfo.aof_last_write_status ?? null\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:252 (HealthController.getHealth) → src/database/primary-database.service.ts:52 (PrimaryDatabaseService.healthCheck) → src/database/logs-database.service.ts:53 (LogsDatabaseService.healthCheck) → src/database/address-database.service.ts:45 (AddressDatabaseService.healthCheck) → src/redis/redis.service.ts:377 (RedisService.healthCheck) → src/redis/redis.service.ts:387 (RedisService.getDurabilityInfo)

#### OPS-002 **GET /health/address-db**

Get Address Db Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, database: "address", timestamp: \<new Date().toISOString\>} | true | false

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:356 (HealthController.getAddressDbHealth) → src/database/address-database.service.ts:45 (AddressDatabaseService.healthCheck)

#### OPS-003 **GET /health/databases**

Get Databases Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, timestamp: \<new Date().toISOString\>, runtime: \<describeBackendRuntimeProfile\>, redis: {durability: \<redisDurability\>}, databases: {primary: {status: conditional, type: "postgresql"}, logs: {status: conditional, type: "postgresql"}, address: {status: conditional, type: "postgresql"}}} | true | false | {mode: conditional, appendOnly: \<appendOnly\>, snapshotting: \<snapshotting\>, lastRdbStatus: \<persistenceInfo.rdb_last_bgsave_status ?? null\>, lastAofStatus: \<persistenceInfo.aof_last_write_status ?? null\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:303 (HealthController.getDatabasesHealth) → src/database/primary-database.service.ts:52 (PrimaryDatabaseService.healthCheck) → src/database/logs-database.service.ts:53 (LogsDatabaseService.healthCheck) → src/database/address-database.service.ts:45 (AddressDatabaseService.healthCheck) → src/redis/redis.service.ts:387 (RedisService.getDurabilityInfo)

#### OPS-004 **GET /health/ingest-ready**

Lightweight listener admission probe.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, accepting: \<accepting\>, timestamp: \<new Date().toISOString\>, redisWriteBlocked: \<capacity?.redisWriteBlocked ?? true\>, reasons: conditional, pressure: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:101 (HealthController.getIngestReadiness) → src/handledata/ingest-capacity.service.ts:128 (IngestCapacityService.getCapacityState)

#### OPS-005 **GET /health/ingestion**

Get Ingestion Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {backendRunning: true, databaseConnected: \<primaryHealth\>, logsDatabaseConnected: \<logsHealth\>, redisConnected: \<redisHealth\>, handledataReady: \<primaryHealth && redisHealth\>, queueHealthy: \<queueHealthy\>} | true | false | \<result === 'PONG'\> | \<Promise.all\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:282 (HealthController.getIngestionHealth) → src/database/primary-database.service.ts:52 (PrimaryDatabaseService.healthCheck) → src/database/logs-database.service.ts:53 (LogsDatabaseService.healthCheck) → src/redis/redis.service.ts:377 (RedisService.healthCheck) → src/queue/queque.service.ts:526 (QuequeService.getQueueHealth)

#### OPS-006 **GET /health/live**

Get Liveness

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, uptimeSec: \<Math.floor\>, eventLoopLagMs: \<Math.max\>, memory: {rssMb: \<Math.round\>, heapUsedMb: \<Math.round\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:78 (HealthController.getLiveness)

#### OPS-007 **GET /health/logs-db**

Get Logs Db Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, database: "logs", timestamp: \<new Date().toISOString\>} | true | false

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:346 (HealthController.getLogsDbHealth) → src/database/logs-database.service.ts:53 (LogsDatabaseService.healthCheck)

#### OPS-008 **GET /health/primary-db**

Get Primary Db Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, database: "primary", timestamp: \<new Date().toISOString\>} | true | false

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:336 (HealthController.getPrimaryDbHealth) → src/database/primary-database.service.ts:52 (PrimaryDatabaseService.healthCheck)

#### OPS-009 **GET /health/queue-maintenance**

Get Queue Maintenance Summary

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, lastCleanup: {available: false, reason: "queue_maintenance_not_registered_in_this_process_role"}} | {status: "ok", timestamp: \<new Date().toISOString\>, lastCleanup: \<summary\>} | conditional | null

**Errors:** Error — Redis client is not initialized. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/health/health.controller.ts:433 (HealthController.getQueueMaintenanceSummary) → src/queue/queue-maintenance.service.ts:181 (QueueMaintenanceService.getLastCleanupSummary)

#### OPS-010 **GET /health/queues**

Get Queues Health

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, queues: \<queueHealth\>, queueMaintenance: \<lastCleanup\>} | \<Promise.all\> | conditional | null

**Errors:** Error — Redis client is not initialized. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/health/health.controller.ts:576 (HealthController.getQueuesHealth) → src/queue/queque.service.ts:526 (QuequeService.getQueueHealth) → src/queue/queue-maintenance.service.ts:181 (QueueMaintenanceService.getLastCleanupSummary)

#### OPS-011 **POST /health/queues/cleanup**

Trigger Queue Cleanup

Access Public · Success HTTP 201 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "error", timestamp: \<new Date().toISOString\>, cleanup: {available: false, reason: "queue_maintenance_not_registered_in_this_process_role"}} | {status: "ok", timestamp: \<new Date().toISOString\>, cleanup: \<summary\>} | {reason: "manual", startedAt: \<new Date().toISOString\>, finishedAt: \<new Date().toISOString\>, durationMs: 0, skipped: true, skipReason: "redis_write_blocked", queues: \[\]}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:555 (HealthController.triggerQueueCleanup) → src/queue/queue-maintenance.service.ts:92 (QueueMaintenanceService.runManualCleanup)

#### OPS-012 **GET /health/ready**

Get Readiness

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: conditional, timestamp: \<new Date().toISOString\>, uptimeSec: \<Math.floor\>, eventLoopLagMs: \<Math.max\>, accepting: \<accepting\>, redisWriteBlocked: \<redisWriteBlocked\>, redisWriteBlockedReason: \<redisWriteBlockedReason\>, redisWriteProbe: \<redisWriteProbe\>, memory: {rssMb: \<rssMb\>, heapUsedMb: \<heapUsedMb\>, rssWarnMb: \<MEMORY_WARN_RSS_MB\>, rssCriticalMb: \<BACKEND_RUNTIME_PLAN.memory.rssCriticalMb\>, heapWarnMb: \<MEMORY_WARN_HEAP_MB\>}, ingestCapacity: {accepting: \<ingestCapacity?.accepting ?? false\>, reason: \<ingestCapacity?.reason ?? null\>, redisWriteBlocked: \<ingestCapacity?.redisWriteBlocked ?? false\>, memoryPressure: \<ingestCapacity?.memoryPressure ?? false\>, queuePressure: \<ingestCapacity?.queuePressure ?? false\>, telemetryDbSpoolRejecting: \<ingestCapacity?.telemetryDbSpoolRejecting ?? false\>}, services: {primaryDb: conditional, logsDb: conditional, redis: conditional, queue: \<queueServiceStatus\>}, queueWarnings: conditional, reasons: conditional} | true | false | \<result === 'PONG'\> | {connected: \<this.isRedisConnected\>, writeBlocked: \<this.writeBlocked\>, writeBlockedReason: \<this.writeBlockedReason\>, lastWriteBlockedAt: \<this.lastWriteBlockedAt\>, lastWriteBlockedOperation: \<this.lastWriteBlockedOperation\>, lastWriteBlockedKey: \<this.lastWriteBlockedKey\>, suppressedPersistenceErrors: \<this.suppressedPersistenceErrors\>, writeRecoveryProbeActive: \<this.writeRecoveryProbeTimer !== null\>} | \<Promise.all\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:132 (HealthController.getReadiness) → src/database/primary-database.service.ts:52 (PrimaryDatabaseService.healthCheck) → src/database/logs-database.service.ts:53 (LogsDatabaseService.healthCheck) → src/redis/redis.service.ts:377 (RedisService.healthCheck) → src/redis/redis.service.ts:125 (RedisService.getRuntimeHealth) → src/redis/redis.service.ts:192 (RedisService.probeWrite) → src/queue/queque.service.ts:526 (QuequeService.getQueueHealth) → src/handledata/ingest-capacity.service.ts:128 (IngestCapacityService.getCapacityState)

#### OPS-013 **GET /health/redis-memory**

Get Redis Memory Diagnostics

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "ok", ...: spread, queues: \<queueHealth.map\>} | {timestamp: \<new Date().toISOString\>, memory: \<memory\>, persistence: \<persistence\>, keyspace: {dbsize: \<dbsize\>}, knownGroups: \<knownGroups\>} | \<Promise.all\>

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:596 (HealthController.getRedisMemoryDiagnostics) → src/redis/redis.service.ts:1034 (RedisService.getMemoryDiagnostics) → src/queue/queque.service.ts:526 (QuequeService.getQueueHealth)

#### OPS-014 **GET /health/runtime**

Get Runtime

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: \<status\>, timestamp: \<new Date().toISOString\>, uptimeSec: \<uptimeSec\>, memoryThresholdSource: \<memoryThresholdSource\>, selectedSpoolRoot: \<selectedSpoolRoot\>, selectedBackendDbSpoolRoot: \<dataRootInfo.backendDbSpoolRoot\>, dataPathMode: \<dataRootInfo.dataPathMode\>, memory: {rssMb: \<Math.round\>, heapUsedMb: \<Math.round\>, heapTotalMb: \<Math.round\>, externalMb: \<Math.round\>}, redis: {ping: \<redisPing\>, redisHealthyFromPing: \<redisPing\>, redisWriteBlocked: \<redisRuntime?.writeBlocked ?? false\>, runtime: \<redisRuntime\>, durability: \<redisDurability\>}, queues: \<queueHealth\>, queueMaintenance: \<lastCleanup\>, ingestCapacity: \<ingestCapacity\>, backendRuntimePlan: {hardwareProfile: \<BACKEND_RUNTIME_PLAN.hardwareProfile\>, cpuCount: \<BACKEND_RUNTIME_PLAN.cpuCount\>, totalMemoryGb: \<BACKEND_RUNTIME_PLAN.totalMemoryGb\>, assumedListenerWorkerCount: \<BACKEND_RUNTIME_PLAN.assumedListenerWorkerCount\>, backendCpuBudget: \<BACKEND_RUNTIME_PLAN.backendCpuBudget\>, workerConcurrency: \<BACKEND_RUNTIME_PLAN.workerConcurrency\>, httpBatch: \<BACKEND_RUNTIME_PLAN.httpBatch\>, dbBatch: \<BACKEND_RUNTIME_PLAN.dbBatch\>, dbSpool: \<BACKEND_RUNTIME_PLAN.dbSpool\>, queueLimits: \<BACKEND_RUNTIME_PLAN.queueLimits\>, memory: \<BACKEND_RUNTIME_PLAN.memory\>}, telemetryDeviceCache: conditional, deviceMetaCache: conditional, packetStateCache: \<this.stack.getPacketStateCacheStats\>, telemetryLogBatchWriter: \<telemetryLogBatchWriter ?? { available: false, reason: 'telemetry_batch_writer_not_registered_in_api_role', }\>, telemetryDbSpool: \<telemetryDbSpool ?? { available: false, reason: 'telemetry_batch_writer_not_registered_in_api_role', }\>, ingestSafety: {backendUnknownQuarantined: \<telemetrySummary.backendUnknownQuarantined\>, backendUnknownRejected: \<telemetrySummary.backendUnknownRejected\>, backendUnknownAccepted: \<telemetrySummary.backendUnknownAccepted\>, quarantineDeviceEventsPersisted: \<telemetrySummary.quarantineDeviceEventsPersisted\>}, ingestCapacityCounters: \<this.ingestCapacity.getCounters\>, telemetryLockStats: \<this.handledata.getLockStats\>, notificationPipeline: \<this.handledata.getNotificationPipelineStats\>, packetStateStaleProcessingRecovered: \<this.handledata.getPacketStateStaleProcessingRecovered\>, packetStateRepair: \<this.handledata.getPacketStateRepairStats\>} | \<result === 'PONG'\> | false | {connected: \<this.isRedisConnected\>, writeBlocked: \<this.writeBlocked\>, writeBlockedReason: \<this.writeBlockedReason\>, lastWriteBlockedAt: \<this.lastWriteBlockedAt\>, lastWriteBlockedOperation: \<this.lastWriteBlockedOperation\>, lastWriteBlockedKey: \<this.lastWriteBlockedKey\>, suppressedPersistenceErrors: \<this.suppressedPersistenceErrors\>, writeRecoveryProbeActive: \<this.writeRecoveryProbeTimer !== null\>} | {mode: conditional, appendOnly: \<appendOnly\>, snapshotting: \<snapshotting\>, lastRdbStatus: \<persistenceInfo.rdb_last_bgsave_status ?? null\>, lastAofStatus: \<persistenceInfo.aof_last_write_status ?? null\>} | null | \<Promise.all\> | conditional | {telemetryBufferSize: \<this.pending.telemetry.length\>, deviceEventBufferSize: \<this.pending.deviceEvent.length\>, flushedBatches: \<spoolStats.flushedBatches\>, flushedRows: \<spoolStats.flushedRows\>, failedBatches: \<spoolStats.failedBatches\>, lastFlushAt: \<spoolStats.lastFlushAt\>, degraded: \<spoolStats.degraded\>, degradedReason: \<this.degradedReason\>, maxBuffer: \<this.admissionMaxBuffer\>, telemetryLogBatchSize: \<this.admissionBatchSize.telemetry\>, deviceEventBatchSize: \<this.admissionBatchSize.deviceEvent\>, flushMs: \<spoolStats.flushMs\>, batchWriterPreReadRemoved: true, consecutiveFailures: \<spoolStats.consecutiveFailures\>, lastFailureAt: \<spoolStats.lastErrorAt\>, lastSuccessAt: \<spoolStats.lastSuccessAt\>, lastFailureMessage: \<spoolStats.lastErrorMessage\>, durableSpoolEnabled: true, telemetryDbSpool: \<spoolStats\>, coalescedAdmissionBatches: \<this.coalescedAdmissionBatches\>, coalescedAdmissionRows: \<this.coalescedAdmissionRows\>, peakTelemetryBufferSize: \<this.peakBuffer.telemetry\>, peakDeviceEventBufferSize: \<this.peakBuffer.deviceEvent\>} | {startedAt: \<this.startedAt\>, acceptedTelemetryPackets: \<acceptedTelemetry\>, acceptedDeviceEventPackets: \<acceptedDeviceEvents\>, telemetryIngestJobsEnqueued: \<telIngestEnqueued\>, telemetryIngestJobsStarted: \<telIngestStarted\>, telemetryIngestJobsCompleted: \<telIngestCompleted\>, telemetryIngestRetryAttempts: \<telIngestRetryAttempts\>, telemetryIngestTerminalFailures: \<telIngestTerminalFailures\>, telemetryIngestPending: \<telIngestPending\>, telemetryIngestActive: \<telIngestActive\>, telemetryIngestRetrying: \<telIngestRetrying\>, deviceEventIngestJobsEnqueued: \<evtIngestEnqueued\>, deviceEventIngestJobsStarted: \<evtIngestStarted\>, deviceEventIngestJobsCompleted: \<evtIngestCompleted\>, deviceEventIngestRetryAttempts: \<evtIngestRetryAttempts\>, deviceEventIngestTerminalFailures: \<evtIngestTerminalFailures\>, deviceEventIngestPending: \<evtIngestPending\>, deviceEventIngestActive: \<evtIngestActive\>, deviceEventIngestRetrying: \<evtIngestRetrying\>, telemetryPersistJobsEnqueued: \<telPersistEnqueued\>, telemetryPersistJobsStarted: \<telPersistStarted\>, telemetryPersistJobsCompleted: \<telPersistCompleted\>, telemetryPersistRetryAttempts: \<telPersistRetryAttempts\>, telemetryPersistTerminalFailures: \<telPersistTerminalFailures\>, telemetryPersistPending: \<telPersistPending\>, telemetryPersistActive: \<telPersistActive\>, telemetryPersistRetrying: \<telPersistRetrying\>, telemetryPersistedAsDeviceEvent: \<telemetryPersistedAsDeviceEvent\>, telemetryPointsPersisted: \<telPersisted\>, telemetryPointsFailedPersist: \<telFailedPersist\>, deviceEventsPersisted: \<evtPersisted\>, deviceEventsFailedPersist: \<evtFailedPersist\>, backendUnknownQuarantined: \<backendUnknownQuarantined\>, backendUnknownRejected: \<backendUnknownRejected\>, backendUnknownAccepted: \<backendUnknownAccepted\>, quarantineDeviceEventsPersisted: \<quarantineDeviceEventsPersisted\>, lockContentionRetries: \<lockRetries\>, lockContentionExhausted: \<lockExhausted\>, lockContentionFailures: \<this.\_lockContentionFailures\>, averageRetryDelayMs: \<avgDelay\>, persistenceRetried: \<persistRetried\>, trackedImeis: \<this.stats.size\>, rates: {telemetryPointsPerSecond: \<this.rateWindow.snapshot\>, deviceEventsPerSecond: \<this.rateWindow.snapshot\>}, queueLagMs: {telemetryIngest: \<this.latencyWindow.snapshot\>, deviceEventIngest: \<this.latencyWindow.snapshot\>, telemetryPersist: \<this.latencyWindow.snapshot\>}, dbPersistLatencyMs: {telemetry: \<this.latencyWindow.snapshot\>, deviceEvent: \<this.latencyWindow.snapshot\>}} | {...: spread} | {packetStateAcceptRepairQueued: \<this.packetStateAcceptRepairStats.queued\>, packetStateAcceptRepairSucceeded: \<this.packetStateAcceptRepairStats.succeeded\>, packetStateAcceptRepairFailed: \<this.packetStateAcceptRepairStats.failed\>, packetStateAcceptRepairDropped: \<this.packetStateAcceptRepairStats.dropped\>, packetStateAcceptRepairQueueSize: \<this.packetStateAcceptRepairQueue.length\>}

**Errors:** Error — Redis client is not initialized. Common authentication, authorization, validation, upload, and server errors also apply.

**Source:** src/health/health.controller.ts:454 (HealthController.getRuntime) → src/redis/redis.service.ts:240 (RedisService.clearWriteBlockedIfDurableHealthy) → src/redis/redis.service.ts:377 (RedisService.healthCheck) → src/redis/redis.service.ts:125 (RedisService.getRuntimeHealth) → src/redis/redis.service.ts:387 (RedisService.getDurabilityInfo) → src/queue/queque.service.ts:526 (QuequeService.getQueueHealth) → src/queue/queue-maintenance.service.ts:181 (QueueMaintenanceService.getLastCleanupSummary) → src/handledata/ingest-capacity.service.ts:128 (IngestCapacityService.getCapacityState) → src/telemetry/telemetry-log-batch-writer.service.ts:99 (TelemetryLogBatchWriterService.getStats) → src/telemetry/telemetry-log-batch-writer.service.ts:128 (TelemetryLogBatchWriterService.getSpoolStats) → src/common/services/telemetry-stats.service.ts:603 (TelemetryStatsService.getSummary) → src/telemetry/telemetry-device-cache.service.ts:333 (TelemetryDeviceCacheService.getStats) → src/stack/stack.service.ts:481 (StackService.getPacketStateCacheStats) → src/handledata/ingest-capacity.service.ts:108 (IngestCapacityService.getCounters) → src/handledata/handledata.service.ts:170 (HandledataService.getLockStats) → src/handledata/handledata.service.ts:174 (HandledataService.getNotificationPipelineStats) → src/handledata/handledata.service.ts:958 (HandledataService.getPacketStateStaleProcessingRecovered) → src/handledata/handledata.service.ts:178 (HandledataService.getPacketStateRepairStats)

#### OPS-015 **GET /health/telemetry-diagnostics/:imei**

Get Telemetry Diagnostics

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, build: \<this.buildFingerprint\>, data: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:393 (HealthController.getTelemetryDiagnostics) → src/common/services/telemetry-stats.service.ts:599 (TelemetryStatsService.getImeiStats)

#### OPS-016 **GET /health/telemetry-packet/:imei/:sourcePacketId**

Run an analytics/read query with database-enforced time and lock bounds.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required ; param sourcePacketId · string · required

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, build: \<this.buildFingerprint\>, data: {imei: \<imei\>, sourcePacketId: \<sourcePacketId\>, route: \<route\>, telemetryLog: \<telemetryLog\>, deviceEventLog: \<deviceEventLog\>}}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:404 (HealthController.getTelemetryPacket) → src/database/logs-database.service.ts:71 (LogsDatabaseService.withReadTimeout)

#### OPS-017 **GET /health/telemetry-stats**

Get Telemetry Stats

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, build: \<this.buildFingerprint\>, runtime: \<describeBackendRuntimeProfile\>, redis: {durability: \<redisDurability\>}, data: \<this.buildGlobalTelemetrySummary\>} | {startedAt: \<this.startedAt\>, acceptedTelemetryPackets: \<acceptedTelemetry\>, acceptedDeviceEventPackets: \<acceptedDeviceEvents\>, telemetryIngestJobsEnqueued: \<telIngestEnqueued\>, telemetryIngestJobsStarted: \<telIngestStarted\>, telemetryIngestJobsCompleted: \<telIngestCompleted\>, telemetryIngestRetryAttempts: \<telIngestRetryAttempts\>, telemetryIngestTerminalFailures: \<telIngestTerminalFailures\>, telemetryIngestPending: \<telIngestPending\>, telemetryIngestActive: \<telIngestActive\>, telemetryIngestRetrying: \<telIngestRetrying\>, deviceEventIngestJobsEnqueued: \<evtIngestEnqueued\>, deviceEventIngestJobsStarted: \<evtIngestStarted\>, deviceEventIngestJobsCompleted: \<evtIngestCompleted\>, deviceEventIngestRetryAttempts: \<evtIngestRetryAttempts\>, deviceEventIngestTerminalFailures: \<evtIngestTerminalFailures\>, deviceEventIngestPending: \<evtIngestPending\>, deviceEventIngestActive: \<evtIngestActive\>, deviceEventIngestRetrying: \<evtIngestRetrying\>, telemetryPersistJobsEnqueued: \<telPersistEnqueued\>, telemetryPersistJobsStarted: \<telPersistStarted\>, telemetryPersistJobsCompleted: \<telPersistCompleted\>, telemetryPersistRetryAttempts: \<telPersistRetryAttempts\>, telemetryPersistTerminalFailures: \<telPersistTerminalFailures\>, telemetryPersistPending: \<telPersistPending\>, telemetryPersistActive: \<telPersistActive\>, telemetryPersistRetrying: \<telPersistRetrying\>, telemetryPersistedAsDeviceEvent: \<telemetryPersistedAsDeviceEvent\>, telemetryPointsPersisted: \<telPersisted\>, telemetryPointsFailedPersist: \<telFailedPersist\>, deviceEventsPersisted: \<evtPersisted\>, deviceEventsFailedPersist: \<evtFailedPersist\>, backendUnknownQuarantined: \<backendUnknownQuarantined\>, backendUnknownRejected: \<backendUnknownRejected\>, backendUnknownAccepted: \<backendUnknownAccepted\>, quarantineDeviceEventsPersisted: \<quarantineDeviceEventsPersisted\>, lockContentionRetries: \<lockRetries\>, lockContentionExhausted: \<lockExhausted\>, lockContentionFailures: \<this.\_lockContentionFailures\>, averageRetryDelayMs: \<avgDelay\>, persistenceRetried: \<persistRetried\>, trackedImeis: \<this.stats.size\>, rates: {telemetryPointsPerSecond: \<this.rateWindow.snapshot\>, deviceEventsPerSecond: \<this.rateWindow.snapshot\>}, queueLagMs: {telemetryIngest: \<this.latencyWindow.snapshot\>, deviceEventIngest: \<this.latencyWindow.snapshot\>, telemetryPersist: \<this.latencyWindow.snapshot\>}, dbPersistLatencyMs: {telemetry: \<this.latencyWindow.snapshot\>, deviceEvent: \<this.latencyWindow.snapshot\>}} | {mode: conditional, appendOnly: \<appendOnly\>, snapshotting: \<snapshotting\>, lastRdbStatus: \<persistenceInfo.rdb_last_bgsave_status ?? null\>, lastAofStatus: \<persistenceInfo.aof_last_write_status ?? null\>} | null

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:366 (HealthController.getTelemetryStats) → src/common/services/telemetry-stats.service.ts:603 (TelemetryStatsService.getSummary) → src/redis/redis.service.ts:387 (RedisService.getDurabilityInfo)

#### OPS-018 **GET /health/telemetry-stats-memory**

Get memory diagnostics for the stats service. Exposed for health checks and monitoring.

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** No client-supplied path, query, or body fields.

**Response:** Global success envelope; observed result variants {status: "ok", telemetryStats: \<this.telemetryStats.getMemoryDiagnostics\>, timestamp: \<new Date().toISOString\>} | {trackedImeis: \<this.stats.size\>, maxImeis: \<TelemetryStatsService.MAX_IMEI_ENTRIES\>, evictedEntries: \<this.evictedEntries\>, utilizationPercent: \<Math.round\>, ttlHours: \<Math.round\>, lastCleanupAgoMs: \<Date.now() - this.lastCleanupMs\>}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:610 (HealthController.getTelemetryStatsMemory) → src/common/services/telemetry-stats.service.ts:752 (TelemetryStatsService.getMemoryDiagnostics)

#### OPS-019 **GET /health/telemetry-stats/:imei**

Get Imei Telemetry Stats

Access Public · Success HTTP 200 · Request No request body · Response JSON through global success envelope

**Request:** param imei · string · required

**Response:** Global success envelope; observed result variants {status: "ok", timestamp: \<new Date().toISOString\>, build: \<this.buildFingerprint\>, data: conditional}

**Errors:** No endpoint-specific exception literal was statically identified. Common authentication, authorization, validation, upload, and server errors still apply.

**Source:** src/health/health.controller.ts:382 (HealthController.getImeiTelemetryStats) → src/common/services/telemetry-stats.service.ts:599 (TelemetryStatsService.getImeiStats)

## Realtime Socket.IO Contract

Realtime channels are Socket.IO namespaces, not plain WebSocket endpoints. Production namespaces use WebSocket transport only; the demo namespace allows WebSocket and polling.

### Production Telemetry · /telemetry

| **Direction** | **Event / mechanism** | **Payload and behavior** |
| --- | --- | --- |
| Connect | JWT | Use handshake.auth.token (recommended), Authorization: Bearer, or query token. Access tokens only. A public shareCode may be supplied through auth or query and is restricted to its IMEI allowlist. |
| Client → server | telemetry:subscribe | {scope?: string, imeis?: string[], snapshot?: boolean, delivery?: 'immediate'\|'batch'}. scope=superadmin is role-gated. Maximum 5,000 IMEIs per request and 50,000 per socket. |
| Server → client | telemetry:subscribe:ack | {acceptedCount, rejectedCount, capped, scope:'imei', delivery}. |
| Server → client | telemetry:snapshot | Array of telemetry records for smaller snapshots. |
| Server → client | telemetry:snapshot:chunk | {chunkIndex, records, hasMore}; chunks are approximately 500 records. |
| Server → client | telemetry:snapshot:complete | {totalRecords, chunkCount}. |
| Server → client | telemetry:update | Single TelemetryRecord for immediate delivery. |
| Server → client | telemetry:update:batch | TelemetryRecord[]; coalesced at approximately 150 ms and emitted in hardware-profile-dependent chunks. |
| Server → client | devicestatus:update | Device status change for an authorized/subscribed vehicle. |
| Server → client | telemetry:error | {message}. |

| **TelemetryRecord field** | **Type / meaning** |
| --- | --- |
| imei | string; required |
| serverTime | ISO-8601 string; required |
| serverTimeMs | number; optional epoch milliseconds |
| deviceTime | ISO-8601 string; optional |
| latitude / longitude | number; optional |
| speedKph | number; optional |
| course | number or null |
| satellites | number; optional |
| ignition / acc / valid | boolean; optional |
| attributes | object; optional protocol attributes |
| odometer / distance / distanceToday | number; optional |
| totalengineHours / engineHours / engineHoursToday | number; optional |
| protocol / packetType | string; optional |
| altitude | number; optional |

### Production Notifications · /notifications

| **Direction** | **Event / mechanism** | **Payload and behavior** |
| --- | --- | --- |
| Connect | JWT | Use handshake.auth.token, Authorization: Bearer, or query token. No public shareCode mode. |
| Client → server | notif:subscribe | {scope?: string, imeis?: string[]}. superadmin scope is role-gated. IMEI authorization is resolved from the authenticated role and assignments and fails closed. |
| Server → client | notif:subscribed | {ok, scope, imeis, denied:{scope, imeis}}; denied values are counts. |
| Server → client | notif:new | New notification payload for an authorized user/vehicle. |
| Server → client | notif:error | Subscription or authorization error. |
| Server → client | dynamic user events | Redis-driven user-specific event names may be emitted to the authenticated user room. |

### Public Demo Telemetry · /demo-telemetry

| **Direction** | **Event / mechanism** | **Payload and behavior** |
| --- | --- | --- |
| Connect | Public | No token. WebSocket and polling are accepted; credentials are disabled. |
| Client → server | telemetry:subscribe | {scope?: 'demo', imeis?: string[]}. |
| Server → client | telemetry:subscribe:ack | {success, count}. |
| Server → client | telemetry:snapshot | Initial demo telemetry array. |
| Server → client | telemetry:update | Single demo telemetry update, normally around every 10 seconds. |
| Server → client | devicestatus:update | Simulated device status change. |
| Server → client | telemetry:error | {message}. |

## DTO and Response Schema Catalog

148 source-defined request/response classes are cataloged below. A property without ? is required; constraints reflect class-validator and transformation decorators in the supplied source.

### ActivateAdminDto

src/superadmin/dto/activateadmin.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| isActive | boolean | Yes | boolean | — |

### AdminActivityLogsDto (admin)

src/admin/dto/admin-activity-logs.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | number | No | optional; integer; Min(5); Max(50); transform: @Type(() =\> Number) | — |
| cursorId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |
| q | string | No | optional; string | — |
| userId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| actionPrefix | string | No | optional; string | — |
| entity | string | No | optional; string | — |

### AdminActivityLogsDto (superadmin)

src/superadmin/dto/admin-activity-logs.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | number | No | optional; integer; Min(5); Max(50); transform: @Type(() =\> Number) | 20 |
| cursorId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |
| q | string | No | optional; string | — |
| actionPrefix | string | No | optional; string | — |
| rk | string | No | optional; string | — |

### AdminCalendarDayDto

src/admin/dto/calendar.dto.ts:86

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| date | string | Yes | string; matches /^\d{4}-\d{2}-\d{2}$/, { message: 'date must be in YYYY-MM-DD format', } | — |
| types | string | No | optional; string; @Validate(IsValidEventTypes) | — |
| rk | string | No | optional; string; matches /^\d+$/, { message: 'rk must be a numeric string' } | — |

### AdminCalendarRangeDto

src/admin/dto/calendar.dto.ts:56

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| from | string | Yes | string; matches /^\d{4}-\d{2}-\d{2}$/, { message: 'from must be in YYYY-MM-DD format', } | — |
| to | string | Yes | string; matches /^\d{4}-\d{2}-\d{2}$/, { message: 'to must be in YYYY-MM-DD format', }; @Validate(IsValidDateRange) | — |
| types | string | No | optional; string; @Validate(IsValidEventTypes) | — |
| rk | string | No | optional; string; matches /^\d+$/, { message: 'rk must be a numeric string' } | — |

### AdminConfigDto

src/admin/dto/adminconfig.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| allowSignup | boolean | No | optional; boolean | — |
| signupCredits | number | No | optional; integer; Min(0) | — |

### AdminDashboardSummaryDto

src/admin/dto/admin-dashboard-summary.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| months | number | No | optional; integer; Min(3); Max(24); transform: @Type(() =\> Number) | — |
| listLimit | number | No | optional; integer; Min(5); Max(25); transform: @Type(() =\> Number) | — |
| currency | string | No | optional; string; Length(3, 3) | — |
| rk | number | No | optional; integer; transform: @Type(() =\> Number) | — |

### AdminEventLogsDto

src/admin/dto/admin-event-logs.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | number | No | optional; integer; Min(1); Max(200); transform: @Type(() =\> Number) | — |
| cursorId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |
| vehicleId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| userId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| source | string | No | optional; string | — |
| severity | string | No | optional; string; one of ['INFO', 'WARNING', 'CRITICAL'] | — |
| isRead | boolean | No | optional; boolean; transform: @Transform(({ value }) =\> { if (value === 'true' \|\| value === '1') return true; if (value === 'false' \|\| value === '0') return false; return value; }) | — |
| q | string | No | optional; string | — |
| dedupe | boolean | No | optional; boolean; transform: @Transform(({ value }) =\> { if (value === 'true' \|\| value === '1') return true; if (value === 'false' \|\| value === '0') return false; return value; }) | — |

### AdminNotifyRecipientsQueryDto

src/notify/dto/notify-recipients-query.dto.ts:47 · inherits src/notify/dto/notify-recipients-query.dto.ts#NotifyRecipientsQueryDto

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| type | NotifyListAudienceType | Yes | one of [...NOTIFY_LIST_AUDIENCE_TYPES] | — |
| search | string | No | optional; string; transform: @Transform(({ value }) =\> { const text = String(value ?? '').trim(); return text.length \> 0 ? text : undefined; }) | — |
| adminId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| status | NotifyRecipientStatusFilter | No | optional; one of [...NOTIFY_RECIPIENT_STATUS_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toUpperCase() : undefined)) | — |
| limit | number | No | optional; integer; Min(1); Max(100); transform: @Type(() =\> Number) | 25 |
| cursor | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| type | NotifyListAudienceType | No | optional; one of [...NOTIFY_LIST_AUDIENCE_TYPES] | 'USERS' |

### AdminPasswordUpdateDto

src/superadmin/dto/adminpasswordupdate.dto.ts:40

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| adminid | string | Yes | non-empty; string; transform: @Transform(({ value }) =\> (typeof value === 'string' ? value.trim() : value)) | — |
| newpassword | string | Yes | non-empty; string; MinLength(6); transform: @Transform(({ value }) =\> (typeof value === 'string' ? value.trim() : value)) | — |
| confirmpassword | string | Yes | non-empty; string; @Match('newpassword', { message: 'confirmpassword must match newpassword' }); transform: @Transform(({ value }) =\> (typeof value === 'string' ? value.trim() : value)) | — |

### AdminRenewVehiclesDto

src/admin/dto/admin-transactions.dto.ts:20

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| userId | number | Yes | integer; Min(1); transform: @Type(() =\> Number) | — |
| vehicleIds | number[] | Yes | array; ArrayMinSize(1); integer; inline: ; transform: @Type(() =\> Number) | — |
| paymentMode | PaymentMode | No | optional; enum PaymentMode | — |
| reference | string | No | optional; string; MaxLength(200) | — |
| amountOverride | string | No | optional; string; matches /^\d+(\.\d{1,2})?$/, { message: 'amountOverride must be a valid decimal string (e.g., "150.00")' } | — |

### AdminTelemetryLogsDto

src/admin/dto/admin-telemetry-logs.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | number | No | optional; integer; Min(1); Max(500); transform: @Type(() =\> Number) | — |
| beforeId | string | No | optional; string | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |
| vehicleId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| imei | string | No | optional; string | — |
| packetType | string | No | optional; string; one of ['LOCATION', 'HISTORY', 'ALARM', 'HEARTBEAT', 'COMMAND', 'EVENT', 'UNKNOWN'] | — |

### AdminUpdateTicketStatusDto

src/admin/dto/admin-update-ticket-status.dto.ts:9

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| status | TicketStatusEnum | Yes | enum TicketStatusEnum; enum: OPEN, IN_PROGRESS, CLOSED | — |

### AppNotifyTemplateDto

src/superadmin/dto/appnotifytempletes.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| notifySubject | string | No | optional; string; non-empty; Length(2, 120) | — |
| message | string | No | optional; string; non-empty; MaxLength(10000) | — |

### AssignDriverVehicleDto

src/user/dto/assign-driver-vehicle.dto.ts:10

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleId | number | Yes | @ToRequiredInt(); number | — |

### AssignSubUserVehiclesDto

src/user/dto/subusers/assign-subuser-vehicles.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleIds | number[] | Yes | array; @ArrayNotEmpty(); integer; Min(1, { each: true }); inline: | — |

### AuthResponseDto

src/auth/dto/auth-response.dto.ts:1

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| action | boolean | Yes | — | — |
| message | string | Yes | — | — |
| data | { token: string; refresh_token: string; user: { id: string; role: string; username: string; email?: string \| null; name: string; profileUrl?: string \| null; }; settings: { dateFormat: string \| null; languageCode: string \| null; direction: 'LTR' \| 'RTL'; theme: 'LIGHT' \| 'DARK'; timezone: string \| null; timeFormat: '24H' \| '12H' \| null; distanceUnit: 'KM' \| 'MILES'; defaultLat: number \| null; defaultLon: number \| null; mapZoom: number \| null; }; } | No | inline: token: string; refresh_token: string; user: { id: string; role: string; username: string; email?: string \| null; name: string; profileUrl?: string \| null; }; settings: { dateFormat: string \| null; languageCode: string \| null; direction: 'LTR' \| 'RTL'; theme: 'LIGHT' \| 'DARK'; timezone: string \| null; timeFormat: '24H' \| '12H' \| null; distanceUnit: 'KM' \| 'MILES'; defaultLat: number \| null; defaultLon: number \| null; mapZoom: number \| null; } | — |

### BulkPointDto

src/geocoding/dto/reverse-geocode.dto.ts:24

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| lat | number | Yes | number; Min(-90); Max(90) | — |
| lng | number | Yes | number; Min(-180); Max(180) | — |

### BulkReverseGeocodeDto

src/geocoding/dto/reverse-geocode.dto.ts:36

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| points | BulkPointDto[] | Yes | array; ArrayMinSize(1); ArrayMaxSize(100); nested validation; nested: src/geocoding/dto/reverse-geocode.dto.ts#BulkPointDto; inline: ; transform: @Type(() =\> BulkPointDto) | — |

### CalendarDayDto

src/superadmin/dto/calendar.dto.ts:86

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| date | string | Yes | string; matches /^\d{4}-\d{2}-\d{2}$/, { message: 'date must be in YYYY-MM-DD format', } | — |
| types | string | No | optional; string; @Validate(IsValidEventTypes) | — |
| rk | string | No | optional; string; matches /^\d+$/, { message: 'rk must be a numeric string' } | — |

### CalendarRangeDto

src/superadmin/dto/calendar.dto.ts:56

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| from | string | Yes | string; matches /^\d{4}-\d{2}-\d{2}$/, { message: 'from must be in YYYY-MM-DD format', } | — |
| to | string | Yes | string; matches /^\d{4}-\d{2}-\d{2}$/, { message: 'to must be in YYYY-MM-DD format', }; @Validate(IsValidDateRange) | — |
| types | string | No | optional; string; @Validate(IsValidEventTypes) | — |
| rk | string | No | optional; string; matches /^\d+$/, { message: 'rk must be a numeric string' } | — |

### CompanyDto (admin)

src/admin/dto/company.dto.ts:8

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string | — |
| websiteUrl | string | No | optional; URL | — |
| customDomain | string | No | optional; string | — |
| socialLinks | Record\<string, string\> | No | optional; object | — |
| primaryColor | string | No | optional; string | — |

### CompanyDto (superadmin)

src/superadmin/dto/company.dto.ts:8

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string | — |
| websiteUrl | string | No | optional; URL | — |
| customDomain | string | No | optional; string | — |
| socialLinks | Record\<string, string\> | No | optional; object | — |
| primaryColor | string | No | optional; string | — |

### CreateAdminDto

src/superadmin/dto/admin.dto.ts:11

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| email | string | No | optional; valid email; transform: @Transform(({ value }) =\> String(value).trim().toLowerCase()) | — |
| mobilePrefix | string | No | optional; string; transform: @Transform(({ value }) =\> value?.toString().trim()) | — |
| mobileNumber | string | No | optional; string; transform: @Transform(({ value }) =\> value?.toString().trim()) | — |
| username | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| password | string | Yes | string; MinLength(6) | — |
| companyName | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| address | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| country | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| state | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| city | string | Yes | string; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| pincode | string | No | optional; string; transform: @Transform(({ value }) =\> value?.toString().trim()) | — |
| credits | string | No | optional; string | — |

### CreateAgentCommandDto

src/agent/dto/create-agent-command.dto.ts:33

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| command | string | Yes | string; MaxLength(1000) | — |
| channel | 'WEB' \| 'API' \| 'WHATSAPP' \| 'WORKFLOW' | No | optional; enum ['WEB', 'API', 'WHATSAPP', 'WORKFLOW'] | — |
| payload | StructuredCommandPayload | No | optional; nested validation; nested: src/agent/dto/create-agent-command.dto.ts#StructuredCommandPayload; transform: @Type(() =\> StructuredCommandPayload) | — |
| metadata | Record\<string, any\> | No | optional; object | — |

### CreateBugReportDto

src/bug-report/dto/create-bug-report.dto.ts:84

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| message | string | Yes | string; non-empty; MinLength(5); MaxLength(3000); transform: @Transform(trimRequiredString) | — |
| category | string | No | optional; string; MaxLength(80); transform: @Transform(trimOptionalString) | — |
| severity | BugReportSeverity | No | optional; enum BugReportSeverity; enum: LOW, MEDIUM, HIGH, CRITICAL; transform: @Transform(({ value }) =\> { if (value === null \|\| value === undefined \|\| value === '') { return BugReportSeverity.MEDIUM; } return typeof value === 'string' ? value.trim().toUpperCase() : value; }) | BugReportSeverity.MEDIUM |
| pageUrl | string | No | optional; string; MaxLength(2000); transform: @Transform(trimOptionalString) | — |
| route | string | No | optional; string; MaxLength(500); transform: @Transform(trimOptionalString) | — |
| title | string | No | optional; string; MaxLength(300); transform: @Transform(trimOptionalString) | — |
| screenshotDataUrl | string | No | optional; string; @Validate(ScreenshotDataUrlConstraint); @Validate(ScreenshotDataUrlSizeConstraint); transform: @Transform(trimOptionalString) | — |
| uploadedScreenshotDataUrl | string | No | optional; string; @Validate(ScreenshotDataUrlConstraint); @Validate(ScreenshotDataUrlSizeConstraint); transform: @Transform(trimOptionalString) | — |
| browser | Record\<string, any\> | No | optional; object | — |
| os | Record\<string, any\> | No | optional; object | — |
| device | Record\<string, any\> | No | optional; object | — |
| screen | Record\<string, any\> | No | optional; object | — |
| network | Record\<string, any\> | No | optional; object | — |
| app | Record\<string, any\> | No | optional; object | — |
| recentErrors | any[] | No | optional; array; ArrayMaxSize(20); inline: | — |
| stepsToReproduce | string | No | optional; string; MaxLength(2000); transform: @Transform(trimOptionalString) | — |
| expectedBehavior | string | No | optional; string; MaxLength(2000); transform: @Transform(trimOptionalString) | — |
| actualBehavior | string | No | optional; string; MaxLength(2000); transform: @Transform(trimOptionalString) | — |
| extra | Record\<string, any\> | No | optional; object | — |

### CreateDashboardDto

src/user/dto/dashboard.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty | — |

### CreateDeviceDto

src/admin/dto/createdevice.dto.ts:5

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| imei | string | Yes | string; non-empty; Length(5, 20); matches /^\d+$/, { message: "imei must contain digits only" } | — |
| deviceTypeId | number | Yes | integer; Min(1); transform: @Transform(({ value }) =\> { if (value == null \|\| value === "") return value; if (typeof value === "number") return value; const n = parseInt(String(value), 10); return Number.isNaN(n) ? value : n; }) | — |

### CreateDriverBulkJobDto

src/admin/dto/driverbulkjobs.dto.ts:94

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| primaryUserId | string | Yes | defined; string; non-empty; transform: @Transform(({ value }) =\> trim(value)) | — |
| rows | DriverBulkJobRowDto[] | Yes | array; nested validation; nested: src/admin/dto/driverbulkjobs.dto.ts#DriverBulkJobRowDto; inline: ; transform: @Type(() =\> DriverBulkJobRowDto) | — |

### CreateDriverDto

src/admin/dto/createdriver.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; MaxLength(120) | — |
| mobilePrefix | string | Yes | string; MaxLength(10) | — |
| mobile | string | Yes | string; MaxLength(20) | — |
| email | string | No | optional; valid email | — |
| primaryUserid | string \| number | Yes | string | — |
| username | string | Yes | string; MaxLength(50) | — |
| password | string | Yes | string; MaxLength(100) | — |
| countryCode | string | Yes | string; MaxLength(5) | — |
| stateCode | string | No | optional; string; MaxLength(10) | — |
| city | string | No | optional; string; MaxLength(50) | — |
| address | string | No | optional; string; MaxLength(200) | — |
| pincode | string | No | optional; string; MaxLength(20) | — |

### CreateFeatureRequestDto

src/feature-request/dto/create-feature-request.dto.ts:66

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| requestType | FeatureRequestType | Yes | enum FeatureRequestType; enum: FEATURE, PROTOCOL; transform: @Transform(({ value }) =\> typeof value === 'string' ? value.trim().toUpperCase() : value, ) | — |
| title | string | Yes | string; non-empty; MinLength(5); MaxLength(160); transform: @Transform(trimRequiredString) | — |
| description | string | Yes | string; non-empty; MinLength(10); MaxLength(3000); @Validate(ProtocolFieldsRequiredConstraint); transform: @Transform(trimRequiredString) | — |
| priority | FeatureRequestPriority | No | optional; enum FeatureRequestPriority; enum: LOW, MEDIUM, HIGH; transform: @Transform(({ value }) =\> { if (value === null \|\| value === undefined \|\| value === '') { return FeatureRequestPriority.MEDIUM; } return typeof value === 'string' ? value.trim().toUpperCase() : value; }) | FeatureRequestPriority.MEDIUM |
| module | string | No | optional; string; MaxLength(120); transform: @Transform(trimOptionalString) | — |
| expectedOutcome | string | No | optional; string; MaxLength(2000); transform: @Transform(trimOptionalString) | — |
| protocolName | string | No | optional; string; MaxLength(120); transform: @Transform(trimOptionalString) | — |
| deviceModel | string | No | optional; string; MaxLength(160); transform: @Transform(trimOptionalString) | — |
| samplePacket | string | No | optional; string; MaxLength(3000); transform: @Transform(trimOptionalString) | — |
| protocolDocumentDataUrl | string | No | optional; string; transform: @Transform(trimOptionalString) | — |
| protocolDocumentName | string | No | optional; string; MaxLength(200); transform: @Transform(trimOptionalString) | — |
| pageUrl | string | No | optional; string; MaxLength(2000); transform: @Transform(trimOptionalString) | — |
| route | string | No | optional; string; MaxLength(500); transform: @Transform(trimOptionalString) | — |
| browser | Record\<string, any\> | No | optional; object | — |
| os | Record\<string, any\> | No | optional; object | — |
| device | Record\<string, any\> | No | optional; object | — |
| screen | Record\<string, any\> | No | optional; object | — |
| app | Record\<string, any\> | No | optional; object | — |
| extra | Record\<string, any\> | No | optional; object | — |

### CreateGeofenceDto

src/user/dto/geofence.dto.ts:34

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; MinLength(2) | — |
| description | string | No | string; optional | — |
| type | GeofenceType | Yes | enum GeofenceType; enum: POLYGON, LINE, CIRCLE | — |
| color | string | No | string; optional | — |
| isActive | boolean | No | boolean; optional | — |
| geodata | GeofenceGeoData | No | object; optional | — |

### CreateInventoryBulkJobDto

src/admin/dto/inventorybulkjobs.dto.ts:51

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| target | InventoryBulkTarget | Yes | defined; string; non-empty; one of ['devices', 'simcards', 'both']; transform: @Transform(({ value }) =\> trim(value)) | — |
| deviceTypeId | string | No | optional; string; transform: @Transform(({ value }) =\> trim(value)) | — |
| providerId | string | No | optional; string; transform: @Transform(({ value }) =\> trim(value)) | — |
| rows | InventoryBulkJobRowDto[] | Yes | array; nested validation; nested: src/admin/dto/inventorybulkjobs.dto.ts#InventoryBulkJobRowDto; inline: ; transform: @Type(() =\> InventoryBulkJobRowDto) | — |

### CreateLandmarkBulkJobDto

src/user/dto/landmarkbulkjobs.dto.ts:190

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| entityType | LandmarkEntityType | Yes | defined; enum LandmarkEntityType; enum: geofence, poi, route | — |
| geofenceRows | GeofenceBulkRowDto[] | No | optional; array; nested validation; nested: src/user/dto/landmarkbulkjobs.dto.ts#GeofenceBulkRowDto; inline: ; transform: @Type(() =\> GeofenceBulkRowDto) | — |
| poiRows | PoiBulkRowDto[] | No | optional; array; nested validation; nested: src/user/dto/landmarkbulkjobs.dto.ts#PoiBulkRowDto; inline: ; transform: @Type(() =\> PoiBulkRowDto) | — |
| routeRows | RouteBulkRowDto[] | No | optional; array; nested validation; nested: src/user/dto/landmarkbulkjobs.dto.ts#RouteBulkRowDto; inline: ; transform: @Type(() =\> RouteBulkRowDto) | — |

### CreateNotifyCampaignDto

src/notify/dto/create-notify-campaign.dto.ts:66 · inherits src/notify/dto/create-notify-campaign.dto.ts#EstimateNotifyRecipientsDto

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| audienceType | NotifyAudienceType | Yes | enum NotifyAudienceType | — |
| selectedUserIds | number[] | No | optional; array; ArrayMaxSize(MAX_NOTIFY_SELECTED_USER_IDS); unique items; integer; Min(1, { each: true }); inline: ; transform: @Type(() =\> Number) | — |
| filters | NotifyAudienceFiltersDto | No | optional; nested validation; nested: src/notify/dto/create-notify-campaign.dto.ts#NotifyAudienceFiltersDto; transform: @Type(() =\> NotifyAudienceFiltersDto) | — |
| channels | NotificationChannel[] | Yes | array; @ArrayNotEmpty(); one of [...NOTIFY_CHANNELS], { each: true }; inline: | — |
| subject | string | Yes | string; non-empty; MaxLength(180); transform: @Transform(({ value }) =\> String(value ?? '').trim()) | — |
| message | string | Yes | string; non-empty; MaxLength(5000); transform: @Transform(({ value }) =\> String(value ?? '').trim()) | — |
| category | UserNotificationCategory | Yes | enum UserNotificationCategory | — |
| severity | NotificationSeverity | No | optional; enum NotificationSeverity | — |
| ctaLabel | string \| null | No | optional; string; MaxLength(80); transform: @Transform(({ value }) =\> { if (value === null \|\| value === undefined) return null; const text = String(value).trim(); return text.length \> 0 ? text : null; }) | — |
| ctaUrl | string \| null | No | optional; URL; MaxLength(2048); transform: @Transform(({ value }) =\> { if (value === null \|\| value === undefined) return null; const text = String(value).trim(); return text.length \> 0 ? text : null; }) | — |
| scheduledAt | string \| null | No | optional; ISO 8601 date/time; transform: @Transform(({ value }) =\> { if (value === null \|\| value === undefined) return null; const text = String(value).trim(); return text.length \> 0 ? text : null; }) | — |

### CreatePoiDto

src/user/dto/poi.dto.ts:28

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; MinLength(2) | — |
| description | string | No | string; optional | — |
| category | string | Yes | string; non-empty | — |
| color | string | No | string; optional | — |
| iconSlug | string | No | string; optional | — |
| toleranceMeters | number | No | number; optional; Min(0) | — |
| isActive | boolean | No | boolean; optional | — |
| coordinates | PoiCoordinatesDto | Yes | object; nested validation; nested: src/user/dto/poi.dto.ts#PoiCoordinatesDto; transform: @Type(() =\> PoiCoordinatesDto) | — |

### CreatePricingPlanDto

src/admin/dto/createpricingplan.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; Length(2, 80) | — |
| durationDays | number | Yes | integer; Min(1) | — |
| price | number | Yes | number; Min(0) | — |
| currency | string | Yes | string; non-empty; Length(3, 3); matches /^[A-Z]{3}$/, { message: "currency must be a 3-letter ISO code" } | — |

### CreateRouteDto

src/user/dto/route.dto.ts:12

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; MinLength(2) | — |
| description | string | No | string; optional | — |
| color | string | No | string; optional | — |
| isActive | boolean | No | boolean; optional | — |
| toleranceMeters | number | No | number; optional; Min(1) | — |
| geodata | RouteGeoData | No | object; optional | — |

### CreateShareTrackLinkDto

src/user/dto/sharetracklinks/create-sharetracklink.dto.ts:29

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleIds | number[] | Yes | array; ArrayMinSize(1); @toIntArray(); integer; inline: | — |
| expiryAt | string | Yes | ISO 8601 date/time | — |
| isGeofence | boolean | No | optional; boolean | — |
| isHistory | boolean | No | optional; boolean | — |

### CreateSubUserDto

src/user/dto/subusers/create-subuser.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; MinLength(2) | — |
| username | string | No | optional; string; MinLength(3) | — |
| email | string | No | optional; valid email | — |
| mobilePrefix | string | No | optional; string | — |
| mobileNumber | string | No | optional; string; matches /^\d{7,15}$/, { message: 'mobileNumber must be 7-15 digits' } | — |
| password | string | No | optional; string; MinLength(6) | — |
| isActive | boolean | No | optional; boolean | — |

### CreateSuperAdminDto

src/auth/dto/superadmin.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string | — |
| email | string | Yes | valid email | — |
| mobilePrefix | string | Yes | string | — |
| mobileNumber | string | Yes | string | — |
| username | string | Yes | string | — |
| password | string | Yes | string; MinLength(6) | — |
| companyName | string | Yes | string | — |
| website | string | No | optional; string | — |
| address | string | Yes | string | — |
| country | string | Yes | string | — |
| state | string | Yes | string | — |
| city | string | Yes | string | — |
| pincode | string | No | optional; string | — |

### CreateTeamMemberDto

src/admin/dto/createteam.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty | — |
| email | string | Yes | valid email; non-empty | — |
| mobilePrefix | string | Yes | string; non-empty | — |
| mobileNumber | string | Yes | string; non-empty | — |
| username | string | Yes | string; non-empty | — |
| password | string | Yes | string; non-empty | — |

### CreateUserBulkJobDto

src/admin/dto/userbulkjobs.dto.ts:101

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rows | UserBulkJobRowDto[] | Yes | array; nested validation; nested: src/admin/dto/userbulkjobs.dto.ts#UserBulkJobRowDto; inline: ; transform: @Type(() =\> UserBulkJobRowDto) | — |

### CreateUserDriverDto

src/user/dto/create-driver.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; MaxLength(120) | — |
| mobilePrefix | string | Yes | string; MaxLength(10) | — |
| mobile | string | Yes | string; MaxLength(20) | — |
| email | string | No | optional; valid email | — |
| username | string | Yes | string; MaxLength(50) | — |
| password | string | Yes | string; MaxLength(100) | — |
| countryCode | string | Yes | string; MaxLength(5) | — |
| stateCode | string | No | optional; string; MaxLength(10) | — |
| city | string | No | optional; string; MaxLength(50) | — |
| address | string | No | optional; string; MaxLength(200) | — |
| pincode | string | No | optional; string; MaxLength(20) | — |

### CreateUserDto

src/admin/dto/createuser.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string | — |
| email | string | No | optional; string | — |
| mobilePrefix | string | Yes | string | — |
| mobileNumber | string | Yes | string | — |
| username | string | Yes | string | — |
| password | string | Yes | string | — |
| companyName | string | No | optional; string | — |
| address | string | Yes | string | — |
| countryCode | string | Yes | string | — |
| stateCode | string | No | optional; string | — |
| city | string | No | optional; string | — |
| pincode | string | No | optional; string | — |

### CreateVehicleBulkJobDto

src/admin/dto/vehiclebulkjobs.dto.ts:63

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| primaryUserId | string | Yes | defined; string; non-empty; transform: @Transform(({ value }) =\> trim(value)) | — |
| planId | string | Yes | defined; string; non-empty; transform: @Transform(({ value }) =\> trim(value)) | — |
| trackerDeviceTypeId | string | Yes | defined; string; non-empty; transform: @Transform(({ value }) =\> trim(value)) | — |
| rows | VehicleBulkJobRowDto[] | Yes | array; nested validation; nested: src/admin/dto/vehiclebulkjobs.dto.ts#VehicleBulkJobRowDto; inline: ; transform: @Type(() =\> VehicleBulkJobRowDto) | — |

### CreateVehicleDto

src/admin/dto/createvehicle.dto.ts:19

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| vin | string | No | optional; string; MaxLength(64); transform: @Transform(({ value }) =\> trim(value)) | — |
| plateNumber | string | No | optional; string; MaxLength(32); transform: @Transform(({ value }) =\> trim(value)) | — |
| deviceId | number \| string | Yes | defined; conditional: (_, v) =\> typeof v === 'number' \|\| (typeof v === 'string' && /^\d+$/.test(v)); integer; conditional: (_, v) =\> typeof v === 'string' && !/^\d+$/.test(v); string; transform: @Transform(({ value }) =\> toNumberIfNumeric(value)) | — |
| vehicleTypeId | number \| string | Yes | defined; conditional: (_, v) =\> typeof v === 'number' \|\| (typeof v === 'string' && /^\d+$/.test(v)); integer; conditional: (_, v) =\> typeof v === 'string' && !/^\d+$/.test(v); string; transform: @Transform(({ value }) =\> toNumberIfNumeric(value)) | — |
| primaryUserId | number \| string | Yes | defined; conditional: (_, v) =\> typeof v === 'number' \|\| (typeof v === 'string' && /^\d+$/.test(v)); integer; conditional: (_, v) =\> typeof v === 'string' && !/^\d+$/.test(v); string; transform: @Transform(({ value }) =\> toNumberIfNumeric(value)) | — |
| planId | number \| string | Yes | defined; conditional: (_, v) =\> typeof v === 'number' \|\| (typeof v === 'string' && /^\d+$/.test(v)); integer; conditional: (_, v) =\> typeof v === 'string' && !/^\d+$/.test(v); string; transform: @Transform(({ value }) =\> toNumberIfNumeric(value)) | — |

### CreateVehicleGroupDto

src/user/dto/vehicle-group.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; MinLength(2); MaxLength(80) | — |
| color | string | No | string; optional; MaxLength(24) | — |
| vehicleIds | number[] | No | array; ArrayMaxSize(1000); optional; inline: ; transform: @Type(() =\> Number) | — |

### CreateVehicleSensorDto

src/user/dto/sensors/create-vehicle-sensor.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; MinLength(2) | — |
| unit | string | No | optional; string | — |
| icon | string | No | optional; string | — |
| code | string | Yes | string; MinLength(5) | — |
| isActive | boolean | No | optional; boolean | — |

### CreditsUpdateDto

src/superadmin/dto/creditassign.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| credits | string | Yes | non-empty; string | — |
| activity | string | Yes | non-empty; string | — |

### CustomCommandDto

src/superadmin/dto/customcommand.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| deviceTypeId | number | Yes | integer; Min(1) | — |
| commandTypeId | number | Yes | integer; Min(1) | — |
| command | string | Yes | string; non-empty; MaxLength(500) | — |
| isActive | boolean | No | optional; boolean | — |

### CustomCommandsQueryDto

src/superadmin/dto/custom-commands-query.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| deviceTypeId | string | No | optional; string | — |
| commandTypeId | string | No | optional; string | — |
| activeOnly | string | No | optional; string | — |
| rk | string | No | optional; string | — |

### DashboardActivityLogsDto

src/superadmin/dto/dashboard-activity-logs.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | number | No | optional; integer; Min(5); Max(50); transform: @Type(() =\> Number) | 20 |
| cursorId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| actorId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |
| rk | string | No | optional; string | — |

### DeviceAndSimDto

src/admin/dto/deviceandsim.dto.ts:15

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| imei | string | Yes | string; non-empty; Length(5, 20); matches /^\d+$/, { message: "imei must contain digits only" } | — |
| deviceTypeId | number | Yes | @ToInt(); integer; Min(1) | — |
| simNumber | string | Yes | @ToStringish(); string; non-empty | — |
| imsi | string | No | optional; @ToStringish(); string | — |
| providerId | string | No | optional; @ToStringish(); string | — |
| iccid | string | No | optional; @ToStringish(); string | — |

### DeviceTypeDto

src/superadmin/dto/devicetype.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; Length(2, 80) | — |
| port | number | Yes | integer; Min(1); Max(65535) | — |
| manufacturer | string \| null | No | optional; string; Length(1, 120) | — |
| protocol | string \| null | No | optional; string; Length(1, 120) | — |
| firmwareVersion | string \| null | No | optional; string; Length(1, 120) | — |

### DocumentTypeDto

src/superadmin/dto/documenttype.dto.ts:10

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; Length(2, 80) | — |
| docFor | DocForDto | Yes | enum DocForDto, { message: "docFor must be one of: USER, DRIVER, VEHICLE" }; enum: USER, DRIVER, VEHICLE | — |

### DriverBulkJobRowDto

src/admin/dto/driverbulkjobs.dto.ts:16

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| name | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| mobilePrefix | string | Yes | defined; string; non-empty; MaxLength(10); transform: @Transform(({ value }) =\> trim(value)) | — |
| mobile | string | Yes | defined; string; non-empty; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |
| email | string | No | optional; string; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| username | string | Yes | defined; string; non-empty; MaxLength(50); transform: @Transform(({ value }) =\> trim(value)) | — |
| password | string | Yes | defined; string; non-empty; MaxLength(100); transform: @Transform(({ value }) =\> trim(value)) | — |
| countryCode | string | Yes | defined; string; non-empty; MaxLength(5); transform: @Transform(({ value }) =\> trim(value)) | — |
| stateCode | string | No | optional; string; MaxLength(10); transform: @Transform(({ value }) =\> trim(value)) | — |
| city | string | No | optional; string; MaxLength(50); transform: @Transform(({ value }) =\> trim(value)) | — |
| address | string | No | optional; string; MaxLength(200); transform: @Transform(({ value }) =\> trim(value)) | — |
| pincode | string | No | optional; string; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |

### EmailTemplateDto

src/superadmin/dto/emailtemplate.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| emailSubject | string | No | optional; string; non-empty; Length(2, 120) | — |
| message | string | No | optional; string; non-empty; MaxLength(10000) | — |

### EstimateNotifyRecipientsDto

src/notify/dto/create-notify-campaign.dto.ts:42

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| audienceType | NotifyAudienceType | Yes | enum NotifyAudienceType | — |
| selectedUserIds | number[] | No | optional; array; ArrayMaxSize(MAX_NOTIFY_SELECTED_USER_IDS); unique items; integer; Min(1, { each: true }); inline: ; transform: @Type(() =\> Number) | — |
| filters | NotifyAudienceFiltersDto | No | optional; nested validation; nested: src/notify/dto/create-notify-campaign.dto.ts#NotifyAudienceFiltersDto; transform: @Type(() =\> NotifyAudienceFiltersDto) | — |
| channels | NotificationChannel[] | Yes | array; @ArrayNotEmpty(); one of [...NOTIFY_CHANNELS], { each: true }; inline: | — |

### ExecutionIdParamDto

src/agent/dto/execution-id-param.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| executionId | string | Yes | UUID | — |

### ForgotPasswordDto

src/auth/dto/forgot-password.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| identifier | string | Yes | non-empty; string | — |

### GenerateReportDto

src/user/reports/reports.dto.ts:7

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleScope | Record\<string, unknown\> | Yes | object | — |
| dateRange | Record\<string, unknown\> | Yes | object | — |
| filters | Record\<string, unknown\> | Yes | object | — |
| timeZone | string | Yes | string; MaxLength(80) | — |
| from | string | Yes | string; MaxLength(40) | — |
| to | string | Yes | string; MaxLength(40) | — |
| cursor | string | No | optional; string; MaxLength(256) | — |

### GeofenceBulkRowDto

src/user/dto/landmarkbulkjobs.dto.ts:37

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| name | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| description | string | No | optional; string; MaxLength(500); transform: @Transform(({ value }) =\> trim(value)) | — |
| type | GeofenceType | Yes | defined; enum GeofenceType; enum: POLYGON, LINE, CIRCLE | — |
| color | string | No | optional; string; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |
| centerLat | number | No | optional; number | — |
| centerLon | number | No | optional; number | — |
| radius | number | No | optional; number; Min(1) | — |
| polygonCoordinates | string | No | optional; string | — |
| lineCoordinates | string | No | optional; string | — |
| toleranceMeters | number | No | optional; number; Min(1) | — |

### GoogleLoginDto

src/auth/dto/google-login.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| code | string | Yes | non-empty; string | — |

### InventoryBulkJobRowDto

src/admin/dto/inventorybulkjobs.dto.ts:19

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| imei | string | No | optional; string; MaxLength(32); transform: @Transform(({ value }) =\> trim(value)) | — |
| simNumber | string | No | optional; string; MaxLength(64); transform: @Transform(({ value }) =\> trim(value)) | — |
| imsi | string | No | optional; string; MaxLength(32); transform: @Transform(({ value }) =\> trim(value)) | — |
| iccid | string | No | optional; string; MaxLength(64); transform: @Transform(({ value }) =\> trim(value)) | — |

### ListShareTrackLinksDto

src/user/dto/sharetracklinks/list-sharetracklinks.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| search | string | No | optional; string | — |
| page | string | No | optional; string | — |
| limit | string | No | optional; string | — |

### ListThirdPartyIntegrationsQueryDto

src/superadmin/dto/third-party-integrations.dto.ts:33

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| scope | IntegrationScope | No | optional; enum IntegrationScope | — |
| adminId | number | No | optional; integer; Min(1); conditional: (o) =\> o.scope === 'ADMIN'; transform: @Type(() =\> Number) | — |
| category | IntegrationCategory | No | optional; enum IntegrationCategory | — |
| provider | IntegrationProvider | No | optional; enum IntegrationProvider | — |

### ListWhatsAppTemplatesQueryDto

src/superadmin/dto/whatsapp-templates.dto.ts:63

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| type | string | No | optional; string | — |
| languageCode | string | No | optional; string | — |
| isActive | boolean | No | optional; boolean; transform: @Transform(({ value }) =\> { if (value === 'true' \|\| value === '1') return true; if (value === 'false' \|\| value === '0') return false; return value; }) | — |
| rk | string | No | optional | — |

### LoginDto

src/auth/dto/login.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| identifier | string | Yes | non-empty; string | — |
| password | string | Yes | non-empty; string | — |

### MapEventsQueryDto

src/superadmin/dto/map-events.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | string | No | optional; @IsNumberString() | — |
| beforeId | string | No | optional; string | — |
| from | string | No | optional; @IsISO8601() | — |
| to | string | No | optional; @IsISO8601() | — |
| source | string | No | optional; one of ['SYSTEM', 'GEOFENCE', 'ROUTE', 'MOTION', 'OVERSPEED', 'IGNITION', 'REMINDER', 'SENSOR', 'DRIVER', 'COMMAND'] | — |
| severity | string | No | optional; one of ['INFO', 'WARNING', 'CRITICAL'] | — |

### NotificationsQueryDto

src/superadmin/dto/notifications.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | string | No | optional; @IsNumberString() | — |
| beforeId | string | No | optional; @IsNumberString() | — |
| unreadOnly | string | No | optional; @IsBooleanString() | — |

### NotifyAudienceFiltersDto

src/notify/dto/create-notify-campaign.dto.ts:29

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| status | NotifyRecipientStatusFilter | No | optional; one of [...NOTIFY_RECIPIENT_STATUS_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toUpperCase() : undefined)) | — |
| adminId | number \| null | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |

### NotifyCampaignQueryDto

src/notify/dto/notify-campaign-query.dto.ts:6

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| status | NotifyCampaignStatus | No | optional; enum NotifyCampaignStatus | — |
| channel | NotificationChannel | No | optional; one of [...NOTIFY_CHANNELS] | — |
| search | string | No | optional; string; transform: @Transform(({ value }) =\> { const text = String(value ?? '').trim(); return text.length \> 0 ? text : undefined; }) | — |
| limit | number | No | optional; integer; Min(1); Max(100); transform: @Type(() =\> Number) | 20 |
| cursor | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| page | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |

### NotifyCampaignRecipientsQueryDto

src/notify/dto/notify-campaign-recipients-query.dto.ts:12

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| search | string | No | optional; string; transform: @Transform(({ value }) =\> { const text = String(value ?? '').trim(); return text.length \> 0 ? text : undefined; }) | — |
| status | NotifyCampaignRecipientStatusFilter | No | optional; one of [...NOTIFY_CAMPAIGN_RECIPIENT_STATUSES]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toUpperCase() : undefined)) | — |
| read | NotifyRecipientReadFilter | No | optional; one of [...NOTIFY_RECIPIENT_READ_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toUpperCase() : undefined)) | — |
| channel | NotificationChannel | No | optional; one of [...NOTIFY_CHANNELS] | — |
| limit | number | No | optional; integer; Min(1); Max(100); transform: @Type(() =\> Number) | 25 |
| cursor | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| page | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |

### NotifyDeliveriesQueryDto

src/notify/dto/notify-deliveries-query.dto.ts:6

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| channel | NotificationChannel | No | optional; one of [...NOTIFY_CHANNELS] | — |
| status | NotificationDeliveryStatus | No | optional; enum NotificationDeliveryStatus | — |
| failureOnly | boolean | No | optional; boolean; transform: @Transform(({ value }) =\> value === true \|\| String(value ?? '').toLowerCase() === 'true') | — |
| recipientSearch | string | No | optional; string; transform: @Transform(({ value }) =\> { const text = String(value ?? '').trim(); return text.length \> 0 ? text : undefined; }) | — |
| limit | number | No | optional; integer; Min(1); Max(100); transform: @Type(() =\> Number) | 25 |
| cursor | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| page | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |

### NotifyRecipientsQueryDto

src/notify/dto/notify-recipients-query.dto.ts:10

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| type | NotifyListAudienceType | Yes | one of [...NOTIFY_LIST_AUDIENCE_TYPES] | — |
| search | string | No | optional; string; transform: @Transform(({ value }) =\> { const text = String(value ?? '').trim(); return text.length \> 0 ? text : undefined; }) | — |
| adminId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| status | NotifyRecipientStatusFilter | No | optional; one of [...NOTIFY_RECIPIENT_STATUS_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toUpperCase() : undefined)) | — |
| limit | number | No | optional; integer; Min(1); Max(100); transform: @Type(() =\> Number) | 25 |
| cursor | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |

### PoiBulkRowDto

src/user/dto/landmarkbulkjobs.dto.ts:98

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| name | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| description | string | No | optional; string; MaxLength(500); transform: @Transform(({ value }) =\> trim(value)) | — |
| category | string | Yes | defined; string; non-empty; MaxLength(80); transform: @Transform(({ value }) =\> trim(value)) | — |
| color | string | No | optional; string; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |
| iconSlug | string | No | optional; string; MaxLength(50); transform: @Transform(({ value }) =\> trim(value)) | — |
| lat | number | Yes | defined; number | — |
| lon | number | Yes | defined; number | — |
| toleranceMeters | number | No | optional; number; Min(0) | — |

### PoiCoordinatesDto

src/user/dto/poi.dto.ts:17

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| lat | number | Yes | number | — |
| lon | number | Yes | number | — |

### PolicyDto

src/superadmin/dto/policy.dto.ts:11

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| PolicyType | PolicyTypeDto | Yes | enum PolicyTypeDto, { message: "type must be one of: PRIVACY_POLICY, SERVICE_TERMS, COOKIES, REFUND" }; enum: PRIVACY_POLICY, SERVICE_TERMS, COOKIES, REFUND | — |
| PolicyText | string | Yes | string; non-empty; MaxLength(200000) | — |

### ProfileDto

src/superadmin/dto/profile.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | non-empty; string | — |
| email | string | No | optional; valid email | — |
| mobilePrefix | string | Yes | non-empty; string | — |
| mobileNumber | string | Yes | non-empty; string | — |
| addressLine | string | Yes | non-empty; string | — |
| countryCode | string | Yes | non-empty; string | — |
| stateCode | string | Yes | non-empty; string | — |
| cityName | string | Yes | non-empty; string | — |
| pincode | string | No | optional; string | — |

### PushTokensQueryDto

src/auth/dto/push-token.dto.ts:57

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| platform | PushTokenPlatformFilter | No | optional; string; one of [...PUSH_TOKEN_PLATFORM_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toLowerCase() : undefined)) | — |

### QuickDeviceDto

src/admin/dto/quickdevice.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| imei | string | Yes | string; non-empty; Length(4, 20); matches /^\d+$/, { message: "imei must contain digits only" } | — |
| deviceTypeId | number | Yes | integer; Min(1) | — |
| simNumber | string | Yes | string; non-empty; Length(5, 30); matches /^\d+$/, { message: "simNumber must contain digits only" } | — |

### RecordManualTransactionDto

src/superadmin/dto/record-manual-transaction.dto.ts:5

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| adminId | number | Yes | integer; transform: @Type(() =\> Number) | — |
| amount | string | Yes | string; matches /^\d+(\.\d{1,2})?$/; MaxLength(12, { message: 'Amount must not exceed 9999999999.99' }) | — |
| reference | string | No | optional; string; MaxLength(100) | — |
| paymentMode | PaymentMode | No | optional; enum PaymentMode | — |

### RefreshTokenDto

src/auth/dto/refresh-token.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| refresh_token | string | Yes | string; non-empty; transform: @Transform(({ value }) =\> String(value).trim()) | — |

### RegisterPushTokenDto

src/auth/dto/push-token.dto.ts:10

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| token | string | Yes | string; non-empty; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| platform | string | No | optional; string; one of ['web', 'android', 'ios']; transform: @Transform(({ value }) =\> (value ? String(value).trim().toLowerCase() : undefined)) | 'web' |
| deviceId | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| userAgent | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |

### RemovePushTokenDto

src/auth/dto/push-token.dto.ts:69

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| token | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| deviceId | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |

### ReplaceVehicleGroupVehiclesDto

src/user/dto/vehicle-group.dto.ts:36

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleIds | number[] | Yes | array; ArrayMaxSize(1000); inline: ; transform: @Type(() =\> Number) | — |

### ReplySupportTicketDto

src/superadmin/dto/reply-support-ticket.dto.ts:6

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| message | string | No | optional; string; MaxLength(5000); matches MEANINGFUL_TEXT, { message: 'Message must contain at least one letter or number' } | — |

### ResetPasswordDto

src/auth/dto/reset-password.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| token | string | Yes | non-empty; string | — |
| newPassword | string | Yes | non-empty; string; MinLength(6); MaxLength(35) | — |

### RotateThirdPartyIntegrationSecretDto

src/superadmin/dto/third-party-integrations.dto.ts:146

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| secretJson | any | Yes | non-empty | — |

### RouteBulkRowDto

src/user/dto/landmarkbulkjobs.dto.ts:152

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| name | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| description | string | No | optional; string; MaxLength(500); transform: @Transform(({ value }) =\> trim(value)) | — |
| color | string | No | optional; string; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |
| coordinates | string | Yes | defined; string | — |
| toleranceMeters | number | No | optional; number; Min(1) | — |

### RunVehicleSensorDto

src/user/dto/sensors/run-vehicle-sensor.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| code | string | Yes | string; MinLength(5) | — |
| payload | Record\<string, unknown\> | Yes | object | — |

### SendCommandBulkDto

src/user/dto/send-command-bulk.dto.ts:19

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| mode | SendCommandBulkMode | Yes | enum SendCommandBulkMode; enum: ALL, SELECTED | — |
| vehicleIds | number[] | No | conditional: (o) =\> o.mode === SendCommandBulkMode.SELECTED && !o.items?.length; optional; array; ArrayMinSize(1); integer; inline: ; transform: @Type(() =\> Number) | — |
| command | string | No | optional; string; MaxLength(500) | — |
| items | SendCommandBulkItem[] | No | optional; array; ArrayMinSize(1); nested validation; nested: src/user/dto/send-command-bulk.dto.ts#SendCommandBulkItem; inline: ; transform: @Type(() =\> SendCommandBulkItem) | — |
| note | string | No | optional; string; MaxLength(500) | — |

### SendCommandBulkItem

src/user/dto/send-command-bulk.dto.ts:9

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleId | number | Yes | integer; transform: @Type(() =\> Number) | — |
| command | string | Yes | string; MaxLength(500) | — |

### SendDeviceCommandDto

src/superadmin/dto/send-device-command.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| command | string | Yes | string; non-empty; MaxLength(500); transform: @Transform(({ value }) =\> (typeof value === 'string' ? value.trim() : value)) | — |
| note | string | No | optional; string; MaxLength(500) | — |

### ServerActionDto

src/superadmin/server/dto/server-action.dto.ts:79

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| componentId | ServerActionComponentId | Yes | one of SERVER_COMPONENT_IDS | — |
| action | ServerActionType | Yes | one of SERVER_ACTIONS; @Validate(ServerActionRulesConstraint) | — |

### SimCardDto

src/admin/dto/sim.dto.ts:8

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| simNumber | string | No | optional; @ToStringish(); string | — |
| imsi | string | No | optional; @ToStringish(); string | — |
| providerId | string | No | optional; @ToStringish(); string | — |
| iccid | string | No | optional; @ToStringish(); string | — |
| isActive | boolean | No | optional | — |
| status | 'IN_STOCK' \| 'IN_USE' \| 'IN_SCRAP' | No | optional; @ToStringish(); string | — |

### SimProviderDto

src/superadmin/dto/simprociders.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; Length(2, 80) | — |
| countryCode | string | Yes | string; non-empty; matches /^[A-Z]{2}$/, { message: "countryCode must be 2 uppercase letters (e.g. IN, NZ)" } | — |
| apnName | string \| null | No | optional; string; MaxLength(120) | — |
| apnUser | string \| null | No | optional; string; MaxLength(120) | — |
| apnPassword | string \| null | No | optional; string; MaxLength(120) | — |

### SmtpSettingDto

src/superadmin/dto/smtp.dto.ts:19

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| senderName | string | No | optional; string | — |
| host | string | No | optional; string | — |
| port | string \| number | No | optional; optional; matches /^\d+$/, {message: 'port must be a numeric string or number'} | — |
| email | string | No | optional; valid email | — |
| type | SmtpSecurity | No | optional; enum SmtpSecurity; enum: NONE, SSL, TLS | — |
| username | string | No | optional; string | — |
| password | string | No | optional; string | — |
| replyTo | string | No | optional; valid email | — |
| isActive | string \| boolean | No | optional; optional; matches /^(true\|false)$/i, { message: 'isActive must be a boolean string ("true" or "false")' } | — |

### SoftwareConfigDto

src/superadmin/dto/softwareconfig.dto.ts:9

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| geocodingPrecision | GeocodingPrecisionDto | No | optional; enum GeocodingPrecisionDto; enum: TWO_DIGIT, THREE_DIGIT | — |
| backupDays | number | No | optional; integer; Min(0) | — |
| allowDemoLogin | boolean | No | optional; boolean | — |
| allowSignup | boolean | No | optional; boolean | — |
| signupCredits | number | No | optional; integer; Min(0); Max(2_000_000_000, { message: 'signupCredits must not exceed 2,000,000,000' }) | — |

### SslInstallDto

src/ssl/dto/ssl.dto.ts:8

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| domain | string | Yes | string; non-empty | — |
| action | SslAction | Yes | enum SslAction; enum: install, renew | — |
| email | string | No | optional; string | — |
| backendProxyPass | string | No | optional; string | — |

### StructuredCommandPayload

src/agent/dto/create-agent-command.dto.ts:11

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleNumber | string | No | optional; string | — |
| imei | string | No | optional; string | — |
| from | string | No | optional; string | — |
| to | string | No | optional; string | — |
| email | string | No | optional; string | — |

### SyncWhatsAppTemplatesDto

src/superadmin/dto/whatsapp-templates.dto.ts:48

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| templateIds | number[] | No | optional; array; integer; Min(1, { each: true }); inline: ; transform: @Type(() =\> Number) | — |
| dryRun | boolean | No | optional; boolean | — |

### SystemVariableDto

src/superadmin/dto/systemvariable.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; Length(2, 80); matches /^[A-Za-z][A-Za-z0-9_]*$/, { message: "name must start with a letter and contain only letters, numbers, and underscore", } | — |
| initialValue | string | Yes | string; non-empty; MaxLength(500) | — |

### TestEmailDto

src/auth/dto/email-test.dto.ts:7

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| subject | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| body | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |

### TestFcmIntegrationDto

src/superadmin/dto/third-party-integrations.dto.ts:159

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| token | string | Yes | string; non-empty; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| title | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| body | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| data | any | No | optional | — |
| targetPlatform | FcmTargetPlatformInput | No | optional; string; one of [...FCM_TARGET_PLATFORMS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toLowerCase() : undefined)) | — |
| platform | FcmTargetPlatformInput | No | optional; string; one of [...FCM_TARGET_PLATFORMS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toLowerCase() : undefined)) | — |

### TestFcmToMeDto

src/superadmin/dto/third-party-integrations.dto.ts:201

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| title | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| body | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| platform | PushTokenPlatformFilter | No | optional; string; one of [...PUSH_TOKEN_PLATFORM_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toLowerCase() : undefined)) | 'web' |

### TestOpenRouterIntegrationDto

src/superadmin/dto/third-party-integrations.dto.ts:263

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| model | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| prompt | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |

### TestPushDto

src/auth/dto/push-token.dto.ts:36

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| title | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| body | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| platform | PushTokenPlatformFilter | No | optional; string; one of [...PUSH_TOKEN_PLATFORM_FILTERS]; transform: @Transform(({ value }) =\> (value ? String(value).trim().toLowerCase() : undefined)) | — |

### TestWhatsAppIntegrationDto

src/superadmin/dto/third-party-integrations.dto.ts:226

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| phoneNumber | string | Yes | string; non-empty; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| mode | 'template' \| 'custom' | No | optional; string; transform: @Transform(({ value }) =\> String(value ?? 'template').trim().toLowerCase()) | 'template' |
| templateName | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| languageCode | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| message | string | No | conditional: (o) =\> o.mode === 'custom'; string; non-empty; transform: @Transform(({ value }) =\> (value ? String(value).trim() : value)) | — |

### TimelineMapDto

src/user/reports/reports.dto.ts:35

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleId | string | Yes | string | — |
| from | string | Yes | string; MaxLength(40) | — |
| to | string | Yes | string; MaxLength(40) | — |

### TopbarSearchQueryDto

src/topbar-search/dto/topbar-search.dto.ts:13

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| q | string | Yes | string; non-empty; MinLength(2); MaxLength(80); transform: @Transform(({ value }) =\> (typeof value === 'string' ? value.trim() : value)) | — |
| limit | number | No | optional; integer; Min(1); Max(30); transform: @Type(() =\> Number) | 20 |

### UnassignSubUserVehiclesDto

src/user/dto/subusers/unassign-subuser-vehicles.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleIds | number[] | Yes | array; @ArrayNotEmpty(); integer; Min(1, { each: true }); inline: | — |

### UpdateAdminDto

src/superadmin/dto/updateadmin.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | non-empty; string | — |
| email | string | No | optional; valid email | — |
| mobilePrefix | string | Yes | non-empty; string | — |
| mobileNumber | string | Yes | non-empty; string | — |
| addressLine | string | Yes | non-empty; string | — |
| countryCode | string | Yes | non-empty; string | — |
| stateCode | string | Yes | non-empty; string | — |
| cityName | string | Yes | non-empty; string | — |
| pincode | string | No | optional; string | — |

### UpdateCompanyDto

src/admin/dto/updatecompany.dto.ts:8

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string | — |
| websiteUrl | string | No | optional; URL | — |
| customDomain | string | No | optional; string | — |
| socialLinks | Record\<string, string\> | No | optional; object | — |
| primaryColor | string | No | optional; string | — |
| secondaryColor | string | No | optional; string | — |
| navbarColor | string | No | optional; string | — |

### UpdateDashboardDto

src/user/dto/dashboard.dto.ts:9

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string | — |
| config | any | No | optional | — |
| version | number | Yes | integer; Min(1) | — |

### UpdateDeviceDto

src/admin/dto/updatedevice.dto.ts:10

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| simId | number \| null | No | optional; integer; Min(0) | — |
| deviceTypeId | number \| null | No | optional; integer; Min(1) | — |
| isActive | boolean | No | optional; boolean | — |
| status | DeviceInventoryStatusDto | No | optional; enum DeviceInventoryStatusDto, { message: "status must be one of: IN_STOCK, IN_USE, IN_SCRAP", }; enum: IN_STOCK, IN_USE, IN_SCRAP | — |

### UpdateDocDto

src/superadmin/dto/updatedoc.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| title | string | No | optional; string; MaxLength(255) | — |
| docTypeId | number | No | optional; integer; Min(1) | — |
| fileName | string | No | optional; string; MaxLength(255) | — |
| description | string | No | optional; string; MaxLength(1000) | — |
| tags | string | No | optional; string; MaxLength(2000) | — |
| associateType | AssociateTypeDto | No | optional; enum AssociateTypeDto, { message: 'associateType must be one of: USER, VEHICLE, DRIVER' }; enum: USER, VEHICLE, DRIVER | — |
| associateId | number | No | optional; integer; Min(1) | — |
| expiryAt | string | No | optional; string; MaxLength(50) | — |
| isVisible | boolean | No | optional; boolean | — |
| isVisibleDriver | boolean | No | optional; boolean | — |

### UpdateDriverDto

src/admin/dto/updatedriver.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string; MaxLength(120) | — |
| mobilePrefix | string | No | optional; string; MaxLength(10) | — |
| mobile | string | No | optional; string; MaxLength(20) | — |
| email | string | No | optional; valid email; MaxLength(254) | — |
| username | string | No | optional; string; MaxLength(50) | — |
| password | string | No | optional; string; MaxLength(100) | — |
| countryCode | string | No | optional; string; MaxLength(5) | — |
| StateCode | string | No | optional; string; MaxLength(10) | — |
| city | string | No | optional; string; MaxLength(50) | — |
| address | string | No | optional; string; MaxLength(200) | — |
| pincode | string | No | optional; string; MaxLength(12) | — |
| isactive | string | No | optional; string; MaxLength(10) | — |
| attributes | Record\<string, any\> \| string | No | optional | — |

### UpdateGeofenceDto

src/user/dto/geofence.dto.ts:60

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | string; optional; MinLength(2) | — |
| description | string | No | string; optional | — |
| type | GeofenceType | No | enum GeofenceType; optional; enum: POLYGON, LINE, CIRCLE | — |
| color | string | No | string; optional | — |
| isActive | boolean | No | boolean; optional | — |
| geodata | GeofenceGeoData | No | object; optional | — |

### UpdatePasswordDto

src/superadmin/dto/updatepassword.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| currentPassword | string | Yes | string; non-empty | — |
| newPassword | string | Yes | string; non-empty; MinLength(6); MaxLength(72) | — |

### UpdatePoiDto

src/user/dto/poi.dto.ts:68

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | string; optional; MinLength(2) | — |
| description | string | No | string; optional | — |
| category | string | No | string; optional | — |
| color | string | No | string; optional | — |
| iconSlug | string | No | string; optional | — |
| toleranceMeters | number \| null | No | number; optional; Min(0) | — |
| isActive | boolean | No | boolean; optional | — |
| coordinates | PoiCoordinatesDto | No | object; optional; nested validation; nested: src/user/dto/poi.dto.ts#PoiCoordinatesDto; transform: @Type(() =\> PoiCoordinatesDto) | — |

### UpdateRouteDto

src/user/dto/route.dto.ts:40

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | string; optional; MinLength(2) | — |
| description | string | No | string; optional | — |
| color | string | No | string; optional | — |
| isActive | boolean | No | boolean; optional | — |
| toleranceMeters | number | No | number; optional; Min(1) | — |
| geodata | RouteGeoData | No | object; optional | — |

### UpdateSettingsStateDto

src/superadmin/dto/usersetting.dto.ts:64

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| language | string | No | optional; string; non-empty; one of ALLOWED_LANGUAGES as unknown as string[], { message: "Invalid language" } | — |
| layoutDirection | LayoutDirectionDto | No | optional; enum LayoutDirectionDto; enum: LTR, RTL | — |
| dateFormat | string | No | optional; string; non-empty; one of ALLOWED_DATE_FORMATS as unknown as string[], { message: "Invalid dateFormat" } | — |
| use24Hour | boolean | No | optional; boolean | — |
| theme | ThemeModeDto | No | optional; enum ThemeModeDto; enum: LIGHT, DARK, SYSTEM | — |
| timezoneOffset | string | No | optional; string; one of ALLOWED_TIMEZONE_OFFSETS as unknown as string[], { message: "Invalid timezoneOffset" } | — |
| units | UnitsDto | No | optional; enum UnitsDto; enum: KM, MILES | — |
| defaultLat | number | No | optional | — |
| defaultLon | number | No | optional | — |
| mapZoom | number | No | optional | — |

### UpdateShareTrackLinkDto

src/user/dto/sharetracklinks/update-sharetracklink.dto.ts:29

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| vehicleIds | number[] | No | optional; array; ArrayMinSize(1); @toIntArray(); integer; inline: | — |
| expiryAt | string | No | optional; ISO 8601 date/time | — |
| isGeofence | boolean | No | optional; boolean | — |
| isHistory | boolean | No | optional; boolean | — |
| isActive | boolean | No | optional; boolean | — |

### UpdateSmtpConfigDto

src/admin/dto/updatesmtpconfig.dto.ts:19

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| senderName | string | No | optional; string | — |
| host | string | No | optional; string | — |
| port | string \| number | No | optional; optional; matches /^\d+$/, {message: 'port must be a numeric string or number'} | — |
| email | string | No | optional; valid email | — |
| type | SmtpSecurity | No | optional; enum SmtpSecurity; enum: NONE, SSL, TLS | — |
| username | string | No | optional; string | — |
| password | string | No | optional; string | — |
| replyTo | string | No | optional; valid email | — |
| isActive | string \| boolean | No | optional; optional; matches /^(true\|false)$/i, { message: 'isActive must be a boolean string ("true" or "false")' } | — |

### UpdateSubUserDto

src/user/dto/subusers/update-subuser.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string; MinLength(2) | — |
| username | string | No | optional; string; MinLength(3) | — |
| email | string | No | optional; valid email | — |
| mobilePrefix | string | No | optional; string | — |
| mobileNumber | string | No | optional; string; matches /^\d{7,15}$/, { message: 'mobileNumber must be 7-15 digits' } | — |
| password | string | No | optional; string; MinLength(6) | — |
| isActive | boolean | No | optional; boolean | — |

### UpdateSupportTicketStatusDto

src/superadmin/dto/update-support-ticket-status.dto.ts:9

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| status | TicketStatusEnum | Yes | enum TicketStatusEnum; enum: OPEN, IN_PROGRESS, CLOSED | — |

### UpdateTeamMemberDto

src/admin/dto/updateteam.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string | — |
| email | string | No | optional; valid email | — |
| mobilePrefix | string | No | optional; string | — |
| mobileNumber | string | No | optional; string | — |
| username | string | No | optional; string | — |
| password | string | No | optional; string | — |
| isActive | boolean | No | optional; boolean | — |

### UpdateThirdPartyIntegrationDto

src/superadmin/dto/third-party-integrations.dto.ts:115

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| status | IntegrationStatus | No | optional; enum IntegrationStatus | — |
| isDefault | boolean | No | optional; boolean; transform: @Transform(({ value }) =\> typeof value === 'string' ? value.toLowerCase() === 'true' : Boolean(value), ) | — |
| priority | number | No | optional; integer; Min(0); transform: @Type(() =\> Number) | — |
| publicConfig | any | No | optional | — |
| lastError | string | No | optional; string | — |

### UpdateUserDriverDto

src/user/dto/update-driver.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string; MaxLength(120) | — |
| mobilePrefix | string | No | optional; string; MaxLength(10) | — |
| mobile | string | No | optional; string; MaxLength(20) | — |
| email | string | No | optional; valid email; MaxLength(254) | — |
| username | string | No | optional; string; MaxLength(50) | — |
| password | string | No | optional; string; MaxLength(100) | — |
| countryCode | string | No | optional; string; MaxLength(5) | — |
| StateCode | string | No | optional; string; MaxLength(10) | — |
| city | string | No | optional; string; MaxLength(50) | — |
| address | string | No | optional; string; MaxLength(200) | — |
| pincode | string | No | optional; string; MaxLength(12) | — |
| isactive | string | No | optional; string; MaxLength(10) | — |
| attributes | Record\<string, any\> \| string | No | optional | — |

### UpdateUserDto

src/admin/dto/updateuser.dto.ts:8

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| roleId | string | No | optional; @ToStringish(); string | — |
| name | string | No | optional; @ToStringish(); string | — |
| email | string | No | optional; @ToStringish(); string | — |
| mobilePrefix | string | No | optional; @ToStringish(); string | — |
| mobileNumber | string | No | optional; @ToStringish(); string | — |
| username | string | No | optional; @ToStringish(); string | — |
| password | string | No | optional; @ToStringish(); string | — |
| companyName | string | No | optional; @ToStringish(); string | — |
| address | string | No | optional; @ToStringish(); string | — |
| countryCode | string | No | optional; @ToStringish(); string | — |
| stateCode | string | No | optional; @ToStringish(); string | — |
| city | string | No | optional; @ToStringish(); string | — |
| pincode | string | No | optional; @ToStringish(); string | — |
| isActive | string | No | optional; @ToStringish(); string | — |

### UpdateUserVehicleDto

src/user/dto/update-vehicle.dto.ts:33

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; @ToTrimmedString(); string | — |
| plateNumber | string \| null | No | optional; @ToOptionalNullIfEmptyString(); string | — |
| vin | string \| null | No | optional; @ToOptionalNullIfEmptyString(); string | — |
| vehicleTypeId | number | No | optional; @ToOptionalInt(); number | — |
| gmtOffset | string \| null | No | optional; @ToOptionalNullIfEmptyString(); matches /^[+-](0\d\|1[0-4]):[0-5]\d$/ | — |
| vehicleMeta | Record\<string, any\> | No | optional; @ToOptionalJSON(); object | — |

### UpdateVehicleConfigDto (admin)

src/admin/dto/update-vehicle-config.dto.ts:17

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| speedVariation | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| distanceVariation | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| odometer | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| engineHours | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| ignitionSource | 'ACC' \| 'MOTION' | No | optional; @ToOptionalUpper(); one of ['ACC', 'MOTION'] | — |

### UpdateVehicleConfigDto (user)

src/user/dto/update-vehicle-config.dto.ts:17

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| speedVariation | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| distanceVariation | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| odometer | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| engineHours | number | No | optional; @ToOptionalFloat(); number; Min(0) | — |
| ignitionSource | 'ACC' \| 'MOTION' | No | optional; @ToOptionalUpper(); one of ['ACC', 'MOTION'] | — |

### UpdateVehicleDto

src/admin/dto/updatevehicle.dto.ts:37

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string | — |
| vin | string | No | optional; string | — |
| plateNumber | string | No | optional; string | — |
| deviceid | number | No | optional; @ToOptionalInt(); number | — |
| vehicleTypeId | number | No | optional; @ToOptionalInt(); number | — |
| planid | number | No | optional; @ToOptionalInt(); number | — |
| gmtOffset | string | No | optional; @ToTrimmedString(); matches /^[+-](0\d\|1[0-4]):[0-5]\d$/ | — |
| isActive | boolean | No | optional; @ToOptionalBool(); boolean | — |
| vehicleMeta | Record\<string, any\> | No | optional; @ToOptionalJSON(); object | — |

### UpdateVehicleGroupDto

src/user/dto/vehicle-group.dto.ts:23

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | string; optional; MinLength(2); MaxLength(80) | — |
| color | string | No | string; optional; MaxLength(24) | — |

### UpdateVehicleSensorDto

src/user/dto/sensors/update-vehicle-sensor.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | No | optional; string; MinLength(2) | — |
| unit | string | No | optional; string | — |
| icon | string | No | optional; string | — |
| code | string | No | optional; string; MinLength(5) | — |
| isActive | boolean | No | optional; boolean | — |

### UpdateWhatsAppTemplateDto

src/superadmin/dto/whatsapp-templates.dto.ts:16

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| title | string | No | optional; string; non-empty; Length(2, 200) | — |
| body | string | No | optional; string; non-empty; MaxLength(1024) | — |
| category | string | No | optional; string; non-empty; MaxLength(50) | — |
| languageCode | string | No | optional; string; non-empty; MaxLength(10) | — |
| isActive | boolean | No | optional; boolean | — |

### UpsertThirdPartyIntegrationDto

src/superadmin/dto/third-party-integrations.dto.ts:59

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| scope | IntegrationScope | Yes | enum IntegrationScope | — |
| adminId | number | No | optional; integer; Min(1); conditional: (o) =\> o.scope === 'ADMIN'; transform: @Type(() =\> Number) | — |
| category | IntegrationCategory | Yes | enum IntegrationCategory | — |
| provider | IntegrationProvider | Yes | enum IntegrationProvider | — |
| name | string | Yes | string; non-empty; transform: @Transform(({ value }) =\> String(value).trim()) | — |
| status | IntegrationStatus | No | optional; enum IntegrationStatus | — |
| isDefault | boolean | No | optional; boolean; transform: @Transform(({ value }) =\> typeof value === 'string' ? value.toLowerCase() === 'true' : Boolean(value), ) | — |
| priority | number | No | optional; integer; Min(0); transform: @Type(() =\> Number) | — |
| publicConfig | any | No | optional | — |
| secretJson | any | No | optional | — |

### UserActivityLogsDto

src/admin/dto/user-activity-logs.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| limit | number | No | optional; integer; Min(5); Max(50); transform: @Type(() =\> Number) | — |
| cursorId | number | No | optional; integer; Min(1); transform: @Type(() =\> Number) | — |
| from | string | No | optional; ISO 8601 date/time | — |
| to | string | No | optional; ISO 8601 date/time | — |
| q | string | No | optional; string | — |
| actionPrefix | string | No | optional; string | — |

### UserBulkJobRowDto

src/admin/dto/userbulkjobs.dto.ts:16

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| name | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| email | string | No | optional; string; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| mobilePrefix | string | Yes | defined; string; non-empty; MaxLength(10); transform: @Transform(({ value }) =\> trim(value)) | — |
| mobileNumber | string | Yes | defined; string; non-empty; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |
| username | string | Yes | defined; string; non-empty; MaxLength(50); transform: @Transform(({ value }) =\> trim(value)) | — |
| password | string | Yes | defined; string; non-empty; MaxLength(100); transform: @Transform(({ value }) =\> trim(value)) | — |
| companyName | string | No | optional; string; MaxLength(160); transform: @Transform(({ value }) =\> trim(value)) | — |
| address | string | Yes | defined; string; non-empty; MaxLength(200); transform: @Transform(({ value }) =\> trim(value)) | — |
| countryCode | string | Yes | defined; string; non-empty; MaxLength(5); transform: @Transform(({ value }) =\> trim(value)) | — |
| stateCode | string | No | optional; string; MaxLength(10); transform: @Transform(({ value }) =\> trim(value)) | — |
| city | string | No | optional; string; MaxLength(50); transform: @Transform(({ value }) =\> trim(value)) | — |
| pincode | string | No | optional; string; MaxLength(20); transform: @Transform(({ value }) =\> trim(value)) | — |

### ValidateFtkeyDto

src/superadmin/dto/ftkey.dto.ts:3

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| ftkey | string | Yes | string; non-empty | — |

### ValidateGeocodingIntegrationDto

src/superadmin/dto/third-party-integrations.dto.ts:293

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| lat | number | Yes | number; Min(-90); Max(90); transform: @Type(() =\> Number) | — |
| lng | number | Yes | number; Min(-180); Max(180); transform: @Type(() =\> Number) | — |
| language | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |
| zoom | number | No | optional; integer; Min(1); Max(20); transform: @Type(() =\> Number) | — |

### ValidateGoogleSsoDto

src/superadmin/dto/third-party-integrations.dto.ts:281

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| redirectUri | string | No | optional; string; transform: @Transform(({ value }) =\> (value ? String(value).trim() : undefined)) | — |

### VehicleBulkJobRowDto

src/admin/dto/vehiclebulkjobs.dto.ts:16

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| rowNumber | number | Yes | integer; Min(1) | — |
| vehicleName | string | Yes | defined; string; non-empty; MaxLength(120); transform: @Transform(({ value }) =\> trim(value)) | — |
| imei | string | Yes | defined; string; non-empty; MaxLength(32); transform: @Transform(({ value }) =\> trim(value)) | — |
| simNumber | string | Yes | defined; string; non-empty; MaxLength(32); transform: @Transform(({ value }) =\> trim(value)) | — |
| deviceType | string | Yes | defined; string; non-empty; MaxLength(80); transform: @Transform(({ value }) =\> trim(value)) | — |
| plateNumber | string | No | optional; string; MaxLength(32); transform: @Transform(({ value }) =\> trim(value)) | — |
| vin | string | No | optional; string; MaxLength(64); transform: @Transform(({ value }) =\> trim(value)) | — |

### VehicleTypeDto

src/superadmin/dto/vehicletype.dto.ts:4

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| name | string | Yes | string; non-empty; Length(2, 60) | — |
| slug | string | Yes | string; non-empty; Length(2, 60); matches /^[a-z0-9]+(?:-[a-z0-9]+)*$/, { message: "slug must be lowercase and hyphen-separated (e.g. snowplow, mini-truck)", } | — |

### VerifyOtpDto

src/verification/dto/verify-otp.dto.ts:9

| **Field** | **Type** | **Required** | **Validation / transformation** | **Default** |
| --- | --- | --- | --- | --- |
| otp | string | Yes | string; Length(6, 6, { message: 'OTP must be exactly 6 digits' }); matches /^\d{6}$/, { message: 'OTP must contain only digits' }; transform: @Transform(({ value }) =\> (typeof value === 'string' ? value.trim() : value)) | — |

## Complete Route Coverage Ledger

This ledger is the completeness proof for the HTTP collection. Every unique method/path pair appears once; detailed contracts use the corresponding API ID in the role sections.

| **API ID** | **Method** | **Path** | **Section / access** | **Request schema/input** |
| --- | --- | --- | --- | --- |
| AUTH-001 | GET | /auth/google/client-id | Auth Public | None |
| AUTH-002 | POST | /auth/google/login | Auth Public | GoogleLoginDto |
| AUTH-003 | POST | /auth/forgot-password | Auth Public | ForgotPasswordDto |
| AUTH-004 | POST | /auth/reset-password | Auth Public | ResetPasswordDto |
| AUTH-005 | GET | /auth/checksadmin | Auth Public | None |
| AUTH-006 | POST | /auth/createsuperadmin | Auth Public | CreateSuperAdminDto |
| AUTH-007 | GET | /auth/fcm-mobile-config | Auth Public | Query:platform |
| AUTH-008 | GET | /auth/fcm-web-config | Auth Public | None |
| AUTH-009 | POST | /auth/push-test | Auth Bearer JWT (any authenticated role) | TestPushDto |
| AUTH-010 | DELETE | /auth/push-token | Auth Bearer JWT (any authenticated role) | RemovePushTokenDto |
| AUTH-011 | POST | /auth/push-token | Auth Bearer JWT (any authenticated role) | RegisterPushTokenDto |
| AUTH-012 | GET | /auth/push-tokens/me | Auth Bearer JWT (any authenticated role) | PushTokensQueryDto |
| AUTH-013 | POST | /auth/email-test | Auth Bearer JWT (any authenticated role) | TestEmailDto |
| AUTH-014 | POST | /auth/login | Auth Public | LoginDto |
| AUTH-015 | POST | /auth/refresh-token | Auth Public | RefreshTokenDto |
| DEMO-001 | GET | /demo/companydetails | Demo Public | None |
| DEMO-002 | GET | /demo/dashboard/day-night-comparison | Demo Public | Query:query |
| DEMO-003 | GET | /demo/dashboard/fleet-status | Demo Public | None |
| DEMO-004 | GET | /demo/dashboard/recent-alerts | Demo Public | Query:query |
| DEMO-005 | GET | /demo/dashboard/recent-alerts/:id | Demo Public | Param:id |
| DEMO-006 | GET | /demo/dashboard/top-performing-assets | Demo Public | Query:query |
| DEMO-007 | GET | /demo/dashboard/usage-last-7-days | Demo Public | Query:query |
| DEMO-008 | GET | /demo/dashboard/weekly-comparison | Demo Public | Query:query |
| DEMO-009 | GET | /demo/dashboards | Demo Public | None |
| DEMO-010 | GET | /demo/dashboards/:id | Demo Public | Param:id |
| DEMO-011 | GET | /demo/commands/:cmdId | Demo Public | Param:cmdId |
| DEMO-012 | GET | /demo/commands/status/:cmdId | Demo Public | Param:cmdId |
| DEMO-013 | GET | /demo/customcommands | Demo Public | None |
| DEMO-014 | GET | /demo/drivers | Demo Public | None |
| DEMO-015 | GET | /demo/drivers/:id | Demo Public | Param:id |
| DEMO-016 | GET | /demo/drivers/:id/documents | Demo Public | Param:id |
| DEMO-017 | GET | /demo/drivers/:id/logs | Demo Public | Param:id, Query:query |
| DEMO-018 | GET | /demo/vehicletypes | Demo Public | None |
| DEMO-019 | GET | /demo/geofences | Demo Public | Query:query |
| DEMO-020 | GET | /demo/geofences/:id | Demo Public | Param:id |
| DEMO-021 | GET | /demo/pois | Demo Public | Query:query |
| DEMO-022 | GET | /demo/pois/:id | Demo Public | Param:id |
| DEMO-023 | GET | /demo/map-events | Demo Public | Query:query |
| DEMO-024 | GET | /demo/map-telemetry | Demo Public | None |
| DEMO-025 | GET | /demo/notifications | Demo Public | Query:query |
| DEMO-026 | GET | /demo/notifications/preferences | Demo Public | None |
| DEMO-027 | GET | /demo/notifications/vehicle | Demo Public | Query:query |
| DEMO-028 | GET | /demo/transactions | Demo Public | None |
| DEMO-029 | GET | /demo/profile | Demo Public | None |
| DEMO-030 | GET | /demo/reports/alerts | Demo Public | Query:query |
| DEMO-031 | GET | /demo/reports/daily | Demo Public | Query:query |
| DEMO-032 | GET | /demo/reports/stoppages | Demo Public | Query:query |
| DEMO-033 | GET | /demo/reports/summary | Demo Public | None |
| DEMO-034 | GET | /demo/route-optimization | Demo Public | None |
| DEMO-035 | GET | /demo/routes | Demo Public | Query:query |
| DEMO-036 | GET | /demo/routes/:id | Demo Public | Param:id |
| DEMO-037 | GET | /demo/accounts | Demo Public | None |
| DEMO-038 | GET | /demo/health | Demo Public | None |
| DEMO-039 | GET | /demo/session | Demo Public | None |
| DEMO-040 | GET | /demo/localization | Demo Public | None |
| DEMO-041 | GET | /demo/systemvariables | Demo Public | None |
| DEMO-042 | GET | /demo/timezones | Demo Public | None |
| DEMO-043 | GET | /demo/share-track-links | Demo Public | None |
| DEMO-044 | GET | /demo/share-track-links/:id | Demo Public | Param:id |
| DEMO-045 | GET | /demo/subusers | Demo Public | None |
| DEMO-046 | GET | /demo/subusers/:id | Demo Public | Param:id |
| DEMO-047 | GET | /demo/subusers/:id/vehicles | Demo Public | Param:id |
| DEMO-048 | GET | /demo/support-tickets | Demo Public | None |
| DEMO-049 | GET | /demo/vehicles | Demo Public | None |
| DEMO-050 | GET | /demo/vehicles/:id | Demo Public | Param:id |
| DEMO-051 | GET | /demo/vehicles/:id/documents | Demo Public | Param:id |
| DEMO-052 | GET | /demo/vehicles/:id/sensors | Demo Public | Param:id, Query:query |
| DEMO-053 | GET | /demo/vehicles/:id/sensors/:sensorId/history | Demo Public | Param:id, Param:sensorId, Query:query |
| DEMO-054 | GET | /demo/vehicles/:id/sensors/telemetry | Demo Public | Param:id |
| DEMO-055 | GET | /demo/vehicles/:id/telemetry | Demo Public | Param:id |
| DEMO-056 | GET | /demo/vehicles/:vehicleId/commands | Demo Public | Param:vehicleId, Query:query |
| DEMO-057 | GET | /demo/vehicles/by-imei/:imei/details | Demo Public | Param:imei |
| DEMO-058 | GET | /demo/vehicles/by-imei/:imei/events | Demo Public | Param:imei, Query:query |
| DEMO-059 | GET | /demo/vehicles/by-imei/:imei/history | Demo Public | Param:imei, Query:query |
| DEMO-060 | GET | /demo/vehicles/by-imei/:imei/logs | Demo Public | Param:imei, Query:query |
| DEMO-061 | GET | /demo/vehicles/by-imei/:imei/replay | Demo Public | Param:imei, Query:query |
| DEMO-062 | GET | /demo/vehicles/by-imei/:imei/sensors | Demo Public | Param:imei |
| DEMO-063 | GET | /demo/vehicles/by-imei/:imei/trail | Demo Public | Param:imei, Query:query |
| SA-001 | GET | /superadmin/openrouter/models | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-002 | POST | /superadmin/activateadmin/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, ActivateAdminDto |
| SA-003 | GET | /superadmin/admin/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-004 | GET | /superadmin/admin/:id/activitylogs | Superadmin Bearer JWT (SUPERADMIN) | Param:id, AdminActivityLogsDto |
| SA-005 | GET | /superadmin/adminlist | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-006 | GET | /superadmin/adminlogin/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-007 | POST | /superadmin/adminpasswordupdate | Superadmin Bearer JWT (SUPERADMIN) | AdminPasswordUpdateDto |
| SA-008 | GET | /superadmin/adminvehicles/:adminId | Superadmin Bearer JWT (SUPERADMIN) | Param:adminId |
| SA-009 | POST | /superadmin/createadmin | Superadmin Bearer JWT (SUPERADMIN) | CreateAdminDto |
| SA-010 | DELETE | /superadmin/deleteadmin/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-011 | POST | /superadmin/updateadmin/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, UpdateAdminDto |
| SA-012 | GET | /superadmin/calendar/day | Superadmin Bearer JWT (SUPERADMIN) | CalendarDayDto |
| SA-013 | GET | /superadmin/calendar/events | Superadmin Bearer JWT (SUPERADMIN) | CalendarRangeDto |
| SA-014 | GET | /superadmin/calendar/user/:uid | Superadmin Bearer JWT (SUPERADMIN) | Param:uid |
| SA-015 | GET | /superadmin/commandtypes | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-016 | POST | /superadmin/commandtypes | Superadmin Bearer JWT (SUPERADMIN) | Body:commandTypeDto |
| SA-017 | DELETE | /superadmin/commandtypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-018 | PATCH | /superadmin/commandtypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, Body:commandTypeDto |
| SA-019 | PATCH | /superadmin/companydetails | Superadmin Bearer JWT (SUPERADMIN) | CompanyDto |
| SA-020 | POST | /superadmin/upload/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-021 | GET | /superadmin/whitelabel | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-022 | PATCH | /superadmin/whitelabel | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-023 | GET | /superadmin/whitelabel/inspect | Superadmin Bearer JWT (SUPERADMIN) | Query:host |
| SA-024 | POST | /superadmin/assigncredits/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, CreditsUpdateDto |
| SA-025 | GET | /superadmin/creditlogs/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-026 | GET | /superadmin/dashboard/activitylogs | Superadmin Bearer JWT (SUPERADMIN) | DashboardActivityLogsDto |
| SA-027 | GET | /superadmin/dashboard/adoptiongraph | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-028 | GET | /superadmin/dashboard/overview | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-029 | GET | /superadmin/dashboard/recentusers | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-030 | GET | /superadmin/dashboard/recentvehicles | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-031 | GET | /superadmin/dashboard/totalcounts | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-032 | GET | /superadmin/commands/:cmdId | Superadmin Bearer JWT (SUPERADMIN) | Param:cmdId |
| SA-033 | GET | /superadmin/commands/status/:cmdId | Superadmin Bearer JWT (SUPERADMIN) | Param:cmdId |
| SA-034 | GET | /superadmin/customcommands | Superadmin Bearer JWT (SUPERADMIN) | CustomCommandsQueryDto |
| SA-035 | POST | /superadmin/customcommands | Superadmin Bearer JWT (SUPERADMIN) | CustomCommandDto |
| SA-036 | DELETE | /superadmin/customcommands/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-037 | PATCH | /superadmin/customcommands/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, CustomCommandDto |
| SA-038 | POST | /superadmin/devices/:imei/send-command | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, SendDeviceCommandDto |
| SA-039 | GET | /superadmin/documents/:adminId | Superadmin Bearer JWT (SUPERADMIN) | Param:adminId |
| SA-040 | GET | /superadmin/documenttypes | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-041 | POST | /superadmin/documenttypes | Superadmin Bearer JWT (SUPERADMIN) | DocumentTypeDto |
| SA-042 | DELETE | /superadmin/documenttypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-043 | PATCH | /superadmin/documenttypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, DocumentTypeDto |
| SA-044 | POST | /superadmin/uploaddoc | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-045 | DELETE | /superadmin/uploaddoc/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-046 | PATCH | /superadmin/uploaddoc/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, UpdateDocDto |
| SA-047 | GET | /superadmin/smtpsettings | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-048 | PATCH | /superadmin/smtpsettings | Superadmin Bearer JWT (SUPERADMIN) | SmtpSettingDto |
| SA-049 | POST | /superadmin/testsmtp | Superadmin Bearer JWT (SUPERADMIN) | Body:email |
| SA-050 | GET | /superadmin/devicetypes | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-051 | POST | /superadmin/devicetypes | Superadmin Bearer JWT (SUPERADMIN) | DeviceTypeDto |
| SA-052 | DELETE | /superadmin/devicetypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-053 | PATCH | /superadmin/devicetypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, DeviceTypeDto |
| SA-054 | GET | /superadmin/vehicletypes | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-055 | POST | /superadmin/vehicletypes | Superadmin Bearer JWT (SUPERADMIN) | VehicleTypeDto |
| SA-056 | DELETE | /superadmin/vehicletypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-057 | PATCH | /superadmin/vehicletypes/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, VehicleTypeDto |
| SA-058 | GET | /superadmin/geofences | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-059 | GET | /superadmin/pois | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-060 | POST | /superadmin/ftkey/deactivate | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-061 | POST | /superadmin/ftkey/recheck | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-062 | GET | /superadmin/ftkey/status | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-063 | POST | /superadmin/ftkey/validate | Superadmin Bearer JWT (SUPERADMIN) | ValidateFtkeyDto |
| SA-064 | GET | /superadmin/map-events | Superadmin Bearer JWT (SUPERADMIN) | MapEventsQueryDto |
| SA-065 | GET | /superadmin/map-telemetry | Superadmin Bearer JWT (SUPERADMIN) | Query:cursor, Query:limit |
| SA-066 | GET | /superadmin/appnotifytemplates | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-067 | GET | /superadmin/appnotifytemplates/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-068 | PATCH | /superadmin/appnotifytemplates/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, AppNotifyTemplateDto |
| SA-069 | GET | /superadmin/emailtemplates | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-070 | GET | /superadmin/emailtemplates/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-071 | PATCH | /superadmin/emailtemplates/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, EmailTemplateDto |
| SA-072 | GET | /superadmin/whatsapptemplates | Superadmin Bearer JWT (SUPERADMIN) | ListWhatsAppTemplatesQueryDto |
| SA-073 | GET | /superadmin/whatsapptemplates/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-074 | PATCH | /superadmin/whatsapptemplates/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, UpdateWhatsAppTemplateDto |
| SA-075 | GET | /superadmin/whatsapptemplates/meta | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-076 | POST | /superadmin/whatsapptemplates/sync | Superadmin Bearer JWT (SUPERADMIN) | SyncWhatsAppTemplatesDto |
| SA-077 | GET | /superadmin/notify/campaigns | Superadmin Bearer JWT (SUPERADMIN) | NotifyCampaignQueryDto |
| SA-078 | POST | /superadmin/notify/campaigns | Superadmin Bearer JWT (SUPERADMIN) | CreateNotifyCampaignDto, Headers:idempotency-key |
| SA-079 | DELETE | /superadmin/notify/campaigns/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-080 | GET | /superadmin/notify/campaigns/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-081 | GET | /superadmin/notify/campaigns/:id/deliveries | Superadmin Bearer JWT (SUPERADMIN) | Param:id, NotifyDeliveriesQueryDto |
| SA-082 | GET | /superadmin/notify/campaigns/:id/recipients | Superadmin Bearer JWT (SUPERADMIN) | Param:id, NotifyCampaignRecipientsQueryDto |
| SA-083 | GET | /superadmin/notify/capabilities | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-084 | GET | /superadmin/notify/recipients | Superadmin Bearer JWT (SUPERADMIN) | NotifyRecipientsQueryDto |
| SA-085 | POST | /superadmin/notify/recipients/estimate | Superadmin Bearer JWT (SUPERADMIN) | EstimateNotifyRecipientsDto |
| SA-086 | GET | /superadmin/notifications | Superadmin Bearer JWT (SUPERADMIN) | NotificationsQueryDto |
| SA-087 | PATCH | /superadmin/notifications/:id/read | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-088 | PATCH | /superadmin/notifications/read-all | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-089 | POST | /superadmin/notifications/test-fcm-me | Superadmin Bearer JWT (SUPERADMIN) | TestFcmToMeDto |
| SA-090 | GET | /superadmin/companyconfig/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-091 | PATCH | /superadmin/companyconfig/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, CompanyDto |
| SA-092 | GET | /superadmin/domainlist | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-093 | PATCH | /superadmin/policy | Superadmin Bearer JWT (SUPERADMIN) | PolicyDto |
| SA-094 | POST | /superadmin/policy | Superadmin Bearer JWT (SUPERADMIN) | Body:PolicyType |
| SA-095 | GET | /superadmin/settings/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-096 | PATCH | /superadmin/settings/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, UpdateSettingsStateDto |
| SA-097 | GET | /superadmin/settings/data-retention/preview | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-098 | POST | /superadmin/settings/data-retention/run | Superadmin Bearer JWT (SUPERADMIN) | inline object |
| SA-099 | GET | /superadmin/softwareconfig | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-100 | PATCH | /superadmin/softwareconfig | Superadmin Bearer JWT (SUPERADMIN) | SoftwareConfigDto |
| SA-101 | GET | /superadmin/transactions | Superadmin Bearer JWT (SUPERADMIN) | Query:adminId, Query:status, Query:from, Query:to, Query:q, Query:page, Query:limit |
| SA-102 | GET | /superadmin/transactions/analytics | Superadmin Bearer JWT (SUPERADMIN) | Query:adminId, Query:from, Query:to, Query:month, Query:year |
| SA-103 | POST | /superadmin/transactions/manual | Superadmin Bearer JWT (SUPERADMIN) | RecordManualTransactionDto |
| SA-104 | GET | /superadmin/profile | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-105 | PATCH | /superadmin/profile | Superadmin Bearer JWT (SUPERADMIN) | ProfileDto |
| SA-106 | GET | /superadmin/profile/email-subscription | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-107 | POST | /superadmin/profile/email-subscription/subscribe | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-108 | POST | /superadmin/profile/verify/email/confirm | Superadmin Bearer JWT (SUPERADMIN) | VerifyOtpDto |
| SA-109 | POST | /superadmin/profile/verify/email/request | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-110 | POST | /superadmin/profile/verify/whatsapp/confirm | Superadmin Bearer JWT (SUPERADMIN) | VerifyOtpDto |
| SA-111 | POST | /superadmin/profile/verify/whatsapp/request | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-112 | PATCH | /superadmin/updatepassword | Superadmin Bearer JWT (SUPERADMIN) | UpdatePasswordDto |
| SA-113 | GET | /superadmin/routes | Superadmin Bearer JWT (SUPERADMIN) | Query:includeGeodata |
| SA-114 | POST | /superadmin/ssl/install | Superadmin Bearer JWT (SUPERADMIN) | SslInstallDto |
| SA-115 | GET | /superadmin/ssl/jobs/:jobId | Superadmin Bearer JWT (SUPERADMIN) | Param:jobId |
| SA-116 | GET | /superadmin/ssl/jobs/:jobId/stream | Superadmin Public | Param:jobId, Query:token |
| SA-117 | GET | /superadmin/ssl/status | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-118 | GET | /superadmin/topbar-search | Superadmin Bearer JWT (SUPERADMIN) | TopbarSearchQueryDto |
| SA-119 | POST | /superadmin/server/actions | Superadmin Bearer JWT (SUPERADMIN) | ServerActionDto |
| SA-120 | GET | /superadmin/server/jobs/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-121 | GET | /superadmin/server/jobs/:id/stream | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-122 | GET | /superadmin/server/overview | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-123 | GET | /superadmin/localization | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-124 | PATCH | /superadmin/localization | Superadmin Bearer JWT (SUPERADMIN) | UpdateSettingsStateDto |
| SA-125 | GET | /superadmin/smtpconfig/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-126 | PATCH | /superadmin/smtpconfig/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, SmtpSettingDto |
| SA-127 | GET | /superadmin/systemvariables | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-128 | POST | /superadmin/systemvariables | Superadmin Bearer JWT (SUPERADMIN) | SystemVariableDto |
| SA-129 | DELETE | /superadmin/systemvariables/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-130 | PATCH | /superadmin/systemvariables/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, SystemVariableDto |
| SA-131 | GET | /superadmin/simproviders | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-132 | POST | /superadmin/simproviders | Superadmin Bearer JWT (SUPERADMIN) | SimProviderDto |
| SA-133 | DELETE | /superadmin/simproviders/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-134 | PATCH | /superadmin/simproviders/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, SimProviderDto |
| SA-135 | GET | /superadmin/support/tickets | Superadmin Bearer JWT (SUPERADMIN) | Query:status, Query:search, Query:priority, Query:category |
| SA-136 | POST | /superadmin/support/tickets | Superadmin Bearer JWT (SUPERADMIN) | Body:body |
| SA-137 | GET | /superadmin/support/tickets/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-138 | POST | /superadmin/support/tickets/:id/messages | Superadmin Bearer JWT (SUPERADMIN) | Param:id, ReplySupportTicketDto |
| SA-139 | PATCH | /superadmin/support/tickets/:id/status | Superadmin Bearer JWT (SUPERADMIN) | Param:id, UpdateSupportTicketStatusDto |
| SA-140 | GET | /superadmin/telemetry | Superadmin Bearer JWT (SUPERADMIN) | Query:imeis, Query:cursor, Query:limit |
| SA-141 | GET | /superadmin/integrations | Superadmin Bearer JWT (SUPERADMIN) | ListThirdPartyIntegrationsQueryDto |
| SA-142 | POST | /superadmin/integrations | Superadmin Bearer JWT (SUPERADMIN) | UpsertThirdPartyIntegrationDto |
| SA-143 | DELETE | /superadmin/integrations/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-144 | PATCH | /superadmin/integrations/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id, UpdateThirdPartyIntegrationDto |
| SA-145 | GET | /superadmin/integrations/:id/openrouter/models | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-146 | POST | /superadmin/integrations/:id/rotate-secret | Superadmin Bearer JWT (SUPERADMIN) | Param:id, RotateThirdPartyIntegrationSecretDto |
| SA-147 | POST | /superadmin/integrations/:id/test-fcm | Superadmin Bearer JWT (SUPERADMIN) | Param:id, TestFcmIntegrationDto |
| SA-148 | POST | /superadmin/integrations/:id/test-openrouter | Superadmin Bearer JWT (SUPERADMIN) | Param:id, TestOpenRouterIntegrationDto |
| SA-149 | POST | /superadmin/integrations/:id/test-whatsapp | Superadmin Bearer JWT (SUPERADMIN) | Param:id, TestWhatsAppIntegrationDto |
| SA-150 | POST | /superadmin/integrations/:id/validate-geocoding | Superadmin Bearer JWT (SUPERADMIN) | Param:id, ValidateGeocodingIntegrationDto |
| SA-151 | POST | /superadmin/integrations/:id/validate-google-sso | Superadmin Bearer JWT (SUPERADMIN) | Param:id, ValidateGoogleSsoDto |
| SA-152 | GET | /superadmin/vehicles | Superadmin Bearer JWT (SUPERADMIN) | None |
| SA-153 | GET | /superadmin/vehicles/:id | Superadmin Bearer JWT (SUPERADMIN) | Param:id |
| SA-154 | GET | /superadmin/vehicles/by-imei/:imei/commands | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, Query:limit, Query:cursorId |
| SA-155 | GET | /superadmin/vehicles/by-imei/:imei/details | Superadmin Bearer JWT (SUPERADMIN) | Param:imei |
| SA-156 | GET | /superadmin/vehicles/by-imei/:imei/events | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, MapEventsQueryDto |
| SA-157 | GET | /superadmin/vehicles/by-imei/:imei/history | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, Query:from, Query:to, Query:stopMin, Query:overspeedKph, Query:maxPoints |
| SA-158 | GET | /superadmin/vehicles/by-imei/:imei/logs | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, Query:from, Query:to, Query:limit, Query:beforeId |
| SA-159 | GET | /superadmin/vehicles/by-imei/:imei/replay | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, Query:from, Query:to, Query:maxPoints |
| SA-160 | POST | /superadmin/vehicles/by-imei/:imei/send-command | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, SendDeviceCommandDto |
| SA-161 | GET | /superadmin/vehicles/by-imei/:imei/sensors | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, Query:includeTelemetryMeta |
| SA-162 | GET | /superadmin/vehicles/by-imei/:imei/trail | Superadmin Bearer JWT (SUPERADMIN) | Param:imei, Query:hours, Query:from, Query:to, Query:maxPoints |
| ADM-001 | GET | /admin/linkusers/:vehicleId | Admin Bearer JWT (ADMIN) | Param:vehicleId |
| ADM-002 | POST | /admin/linkusers/:vehicleId | Admin Bearer JWT (ADMIN) | Param:vehicleId, Body:userId |
| ADM-003 | GET | /admin/linkvehicles/:userId | Admin Bearer JWT (ADMIN) | Param:userId |
| ADM-004 | POST | /admin/linkvehicles/:userId | Admin Bearer JWT (ADMIN) | Param:userId, Body:vehicleId |
| ADM-005 | GET | /admin/unlinkusers/:vehicleId | Admin Bearer JWT (ADMIN) | Param:vehicleId |
| ADM-006 | POST | /admin/unlinkusers/:vehicleId | Admin Bearer JWT (ADMIN) | Param:vehicleId, Body:userId |
| ADM-007 | GET | /admin/unlinkvehicles/:userId | Admin Bearer JWT (ADMIN) | Param:userId |
| ADM-008 | POST | /admin/unlinkvehicles/:userId | Admin Bearer JWT (ADMIN) | Param:userId, Body:vehicleId |
| ADM-009 | GET | /admin/calendar/day | Admin Bearer JWT (ADMIN) | AdminCalendarDayDto |
| ADM-010 | GET | /admin/calendar/events | Admin Bearer JWT (ADMIN) | AdminCalendarRangeDto |
| ADM-011 | GET | /admin/calendar/user/:uid | Admin Bearer JWT (ADMIN) | Param:uid |
| ADM-012 | PATCH | /admin/companydetails | Admin Bearer JWT (ADMIN) | CompanyDto |
| ADM-013 | GET | /admin/companydetails/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-014 | PATCH | /admin/companydetails/:id | Admin Bearer JWT (ADMIN) | Param:id, CompanyDto |
| ADM-015 | PATCH | /admin/companyinfo/:id | Admin Bearer JWT (ADMIN) | Param:id, UpdateCompanyDto |
| ADM-016 | POST | /admin/upload | Admin Bearer JWT (ADMIN) | None |
| ADM-017 | GET | /admin/whitelabel | Admin Bearer JWT (ADMIN) | None |
| ADM-018 | PATCH | /admin/whitelabel | Admin Bearer JWT (ADMIN) | None |
| ADM-019 | GET | /admin/whitelabel/inspect | Admin Bearer JWT (ADMIN) | Query:host |
| ADM-020 | GET | /admin/dashboard/summary | Admin Bearer JWT (ADMIN) | AdminDashboardSummaryDto |
| ADM-021 | GET | /admin/commands/:cmdId | Admin Bearer JWT (ADMIN) | Param:cmdId |
| ADM-022 | GET | /admin/commands/status/:cmdId | Admin Bearer JWT (ADMIN) | Param:cmdId |
| ADM-023 | GET | /admin/customcommands | Admin Bearer JWT (ADMIN) | CustomCommandsQueryDto |
| ADM-024 | GET | /admin/devices | Admin Bearer JWT (ADMIN) | None |
| ADM-025 | POST | /admin/devices | Admin Bearer JWT (ADMIN) | CreateDeviceDto |
| ADM-026 | DELETE | /admin/devices/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-027 | PATCH | /admin/devices/:id | Admin Bearer JWT (ADMIN) | Param:id, UpdateDeviceDto |
| ADM-028 | GET | /admin/quickdevice | Admin Bearer JWT (ADMIN) | None |
| ADM-029 | POST | /admin/quickdevice | Admin Bearer JWT (ADMIN) | QuickDeviceDto |
| ADM-030 | GET | /admin/documents/:userId | Admin Bearer JWT (ADMIN) | Param:userId |
| ADM-031 | GET | /admin/documents/driver/:driverId | Admin Bearer JWT (ADMIN) | Param:driverId |
| ADM-032 | GET | /admin/documents/vehicle/:vehicleId | Admin Bearer JWT (ADMIN) | Param:vehicleId |
| ADM-033 | POST | /admin/uploaddoc | Admin Bearer JWT (ADMIN) | None |
| ADM-034 | DELETE | /admin/uploaddoc/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-035 | PATCH | /admin/uploaddoc/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-036 | GET | /admin/drivers | Admin Bearer JWT (ADMIN) | None |
| ADM-037 | POST | /admin/drivers | Admin Bearer JWT (ADMIN) | CreateDriverDto |
| ADM-038 | DELETE | /admin/drivers/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-039 | GET | /admin/drivers/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-040 | PATCH | /admin/drivers/:id | Admin Bearer JWT (ADMIN) | Param:id, UpdateDriverDto |
| ADM-041 | GET | /admin/drivers/:id/users | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-042 | GET | /admin/drivers/linkedusers/:driverId | Admin Bearer JWT (ADMIN) | Param:driverId |
| ADM-043 | POST | /admin/drivers/linkedusers/:driverId | Admin Bearer JWT (ADMIN) | Param:driverId, Body:userId |
| ADM-044 | GET | /admin/drivers/unlinkedusers/:driverId | Admin Bearer JWT (ADMIN) | Param:driverId |
| ADM-045 | POST | /admin/drivers/unlinkedusers/:driverId | Admin Bearer JWT (ADMIN) | Param:driverId, Body:userId |
| ADM-046 | POST | /admin/driverbulkjobs | Admin Bearer JWT (ADMIN) | CreateDriverBulkJobDto |
| ADM-047 | GET | /admin/driverbulkjobs/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-048 | GET | /admin/driverbulkjobs/:id/failed.csv | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-049 | GET | /admin/driverbulkjobs/:id/stream | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-050 | POST | /admin/testsmtp | Admin Bearer JWT (ADMIN) | Body:email |
| ADM-051 | GET | /admin/map-events | Admin Bearer JWT (ADMIN) | MapEventsQueryDto |
| ADM-052 | GET | /admin/map-telemetry | Admin Bearer JWT (ADMIN) | Query:cursor, Query:limit |
| ADM-053 | GET | /admin/logs/activity | Admin Bearer JWT (ADMIN) | AdminActivityLogsDto |
| ADM-054 | GET | /admin/logs/events | Admin Bearer JWT (ADMIN) | AdminEventLogsDto |
| ADM-055 | GET | /admin/logs/events/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-056 | GET | /admin/logs/options | Admin Bearer JWT (ADMIN) | None |
| ADM-057 | GET | /admin/logs/telemetry | Admin Bearer JWT (ADMIN) | AdminTelemetryLogsDto |
| ADM-058 | GET | /admin/logs/telemetry/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-059 | GET | /admin/notify/campaigns | Admin Bearer JWT (ADMIN) | NotifyCampaignQueryDto |
| ADM-060 | POST | /admin/notify/campaigns | Admin Bearer JWT (ADMIN) | CreateNotifyCampaignDto, Headers:idempotency-key |
| ADM-061 | DELETE | /admin/notify/campaigns/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-062 | GET | /admin/notify/campaigns/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-063 | GET | /admin/notify/campaigns/:id/deliveries | Admin Bearer JWT (ADMIN) | Param:id, NotifyDeliveriesQueryDto |
| ADM-064 | GET | /admin/notify/campaigns/:id/recipients | Admin Bearer JWT (ADMIN) | Param:id, NotifyCampaignRecipientsQueryDto |
| ADM-065 | GET | /admin/notify/capabilities | Admin Bearer JWT (ADMIN) | None |
| ADM-066 | GET | /admin/notify/recipients | Admin Bearer JWT (ADMIN) | AdminNotifyRecipientsQueryDto |
| ADM-067 | POST | /admin/notify/recipients/estimate | Admin Bearer JWT (ADMIN) | EstimateNotifyRecipientsDto |
| ADM-068 | GET | /admin/notifications | Admin Bearer JWT (ADMIN) | Query:limit, Query:beforeId, Query:unreadOnly, Query:category |
| ADM-069 | PATCH | /admin/notifications/:id/read | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-070 | PATCH | /admin/notifications/read-all | Admin Bearer JWT (ADMIN) | None |
| ADM-071 | GET | /admin/config | Admin Bearer JWT (ADMIN) | None |
| ADM-072 | PATCH | /admin/config | Admin Bearer JWT (ADMIN) | AdminConfigDto |
| ADM-073 | GET | /admin/payments | Admin Bearer JWT (ADMIN) | Query:userId, Query:status, Query:from, Query:to, Query:q, Query:page, Query:limit |
| ADM-074 | POST | /admin/payments/renew | Admin Bearer JWT (ADMIN) | AdminRenewVehiclesDto |
| ADM-075 | GET | /admin/pricingplans | Admin Bearer JWT (ADMIN) | None |
| ADM-076 | POST | /admin/pricingplans | Admin Bearer JWT (ADMIN) | CreatePricingPlanDto |
| ADM-077 | PATCH | /admin/pricingplans/:id | Admin Bearer JWT (ADMIN) | Param:id, CreatePricingPlanDto |
| ADM-078 | GET | /admin/transactions | Admin Bearer JWT (ADMIN) | Query:status, Query:from, Query:to, Query:q, Query:page, Query:limit |
| ADM-079 | GET | /admin/transactions/analytics | Admin Bearer JWT (ADMIN) | Query:userId, Query:from, Query:to, Query:month, Query:year |
| ADM-080 | POST | /admin/transactions/renew | Admin Bearer JWT (ADMIN) | AdminRenewVehiclesDto |
| ADM-081 | GET | /admin/profile | Admin Bearer JWT (ADMIN) | None |
| ADM-082 | PATCH | /admin/profile | Admin Bearer JWT (ADMIN) | ProfileDto |
| ADM-083 | GET | /admin/profile/email-subscription | Admin Bearer JWT (ADMIN) | None |
| ADM-084 | POST | /admin/profile/email-subscription/subscribe | Admin Bearer JWT (ADMIN) | None |
| ADM-085 | POST | /admin/profile/verify/email/confirm | Admin Bearer JWT (ADMIN) | VerifyOtpDto |
| ADM-086 | POST | /admin/profile/verify/email/request | Admin Bearer JWT (ADMIN) | None |
| ADM-087 | POST | /admin/profile/verify/whatsapp/confirm | Admin Bearer JWT (ADMIN) | VerifyOtpDto |
| ADM-088 | POST | /admin/profile/verify/whatsapp/request | Admin Bearer JWT (ADMIN) | None |
| ADM-089 | PATCH | /admin/updatepassword | Admin Bearer JWT (ADMIN) | inline object |
| ADM-090 | POST | /admin/updatepassword | Admin Bearer JWT (ADMIN) | inline object |
| ADM-091 | POST | /admin/deviceandsim | Admin Bearer JWT (ADMIN) | DeviceAndSimDto |
| ADM-092 | POST | /admin/inventorybulkjobs | Admin Bearer JWT (ADMIN) | CreateInventoryBulkJobDto |
| ADM-093 | GET | /admin/inventorybulkjobs/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-094 | GET | /admin/inventorybulkjobs/:id/failed.csv | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-095 | GET | /admin/inventorybulkjobs/:id/stream | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-096 | GET | /admin/quicksimcards | Admin Bearer JWT (ADMIN) | None |
| ADM-097 | GET | /admin/simcards | Admin Bearer JWT (ADMIN) | None |
| ADM-098 | POST | /admin/simcards | Admin Bearer JWT (ADMIN) | SimCardDto |
| ADM-099 | DELETE | /admin/simcards/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-100 | GET | /admin/simcards/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-101 | PATCH | /admin/simcards/:id | Admin Bearer JWT (ADMIN) | Param:id, SimCardDto |
| ADM-102 | GET | /admin/topbar-search | Admin Bearer JWT (ADMIN) | TopbarSearchQueryDto |
| ADM-103 | GET | /admin/localization | Admin Bearer JWT (ADMIN) | None |
| ADM-104 | PATCH | /admin/localization | Admin Bearer JWT (ADMIN) | UpdateSettingsStateDto |
| ADM-105 | GET | /admin/smtpconfig | Admin Bearer JWT (ADMIN) | None |
| ADM-106 | PATCH | /admin/smtpconfig | Admin Bearer JWT (ADMIN) | UpdateSmtpConfigDto |
| ADM-107 | POST | /admin/smtpconfig | Admin Bearer JWT (ADMIN) | UpdateSmtpConfigDto |
| ADM-108 | GET | /admin/systemvariables | Admin Bearer JWT (ADMIN) | None |
| ADM-109 | GET | /admin/mytickets | Admin Bearer JWT (ADMIN) | Query:status, Query:search |
| ADM-110 | POST | /admin/mytickets | Admin Bearer JWT (ADMIN) | Body:body |
| ADM-111 | GET | /admin/mytickets/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-112 | POST | /admin/mytickets/:id/messages | Admin Bearer JWT (ADMIN) | Param:id, Body:body |
| ADM-113 | PATCH | /admin/mytickets/:id/status | Admin Bearer JWT (ADMIN) | Param:id, AdminUpdateTicketStatusDto |
| ADM-114 | GET | /admin/tickets | Admin Bearer JWT (ADMIN) | Query:status, Query:search, Query:userId |
| ADM-115 | POST | /admin/tickets | Admin Bearer JWT (ADMIN) | Body:body |
| ADM-116 | GET | /admin/tickets/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-117 | POST | /admin/tickets/:id/messages | Admin Bearer JWT (ADMIN) | Param:id, Body:body |
| ADM-118 | PATCH | /admin/tickets/:id/status | Admin Bearer JWT (ADMIN) | Param:id, AdminUpdateTicketStatusDto |
| ADM-119 | GET | /admin/teams | Admin Bearer JWT (ADMIN) | None |
| ADM-120 | POST | /admin/teams | Admin Bearer JWT (ADMIN) | CreateTeamMemberDto |
| ADM-121 | DELETE | /admin/teams/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-122 | GET | /admin/teams/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-123 | PATCH | /admin/teams/:id | Admin Bearer JWT (ADMIN) | Param:id, UpdateTeamMemberDto |
| ADM-124 | GET | /admin/shortusers | Admin Bearer JWT (ADMIN) | Query:search |
| ADM-125 | POST | /admin/updateuserpassword/:id | Admin Bearer JWT (ADMIN) | Param:id, inline object |
| ADM-126 | GET | /admin/userlogin/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-127 | GET | /admin/users | Admin Bearer JWT (ADMIN) | Query:search |
| ADM-128 | POST | /admin/users | Admin Bearer JWT (ADMIN) | CreateUserDto |
| ADM-129 | DELETE | /admin/users/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-130 | GET | /admin/users/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-131 | PATCH | /admin/users/:id | Admin Bearer JWT (ADMIN) | Param:id, UpdateUserDto |
| ADM-132 | GET | /admin/users/:id/activitylogs | Admin Bearer JWT (ADMIN) | Param:id, UserActivityLogsDto |
| ADM-133 | GET | /admin/users/linkeddrivers/:userId | Admin Bearer JWT (ADMIN) | Param:userId |
| ADM-134 | POST | /admin/users/linkeddrivers/:userId | Admin Bearer JWT (ADMIN) | Param:userId, Body:driverId |
| ADM-135 | GET | /admin/users/unlinkeddrivers/:userId | Admin Bearer JWT (ADMIN) | Param:userId |
| ADM-136 | POST | /admin/users/unlinkeddrivers/:userId | Admin Bearer JWT (ADMIN) | Param:userId, Body:driverId |
| ADM-137 | POST | /admin/userbulkjobs | Admin Bearer JWT (ADMIN) | CreateUserBulkJobDto |
| ADM-138 | GET | /admin/userbulkjobs/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-139 | GET | /admin/userbulkjobs/:id/failed.csv | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-140 | GET | /admin/userbulkjobs/:id/stream | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-141 | GET | /admin/vehicles | Admin Bearer JWT (ADMIN) | None |
| ADM-142 | POST | /admin/vehicles | Admin Bearer JWT (ADMIN) | CreateVehicleDto |
| ADM-143 | DELETE | /admin/vehicles/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-144 | GET | /admin/vehicles/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-145 | PATCH | /admin/vehicles/:id | Admin Bearer JWT (ADMIN) | Param:id, UpdateVehicleDto |
| ADM-146 | PATCH | /admin/vehicles/:id/config | Admin Bearer JWT (ADMIN) | Param:id, UpdateVehicleConfigDto |
| ADM-147 | GET | /admin/vehicles/:vehicleId/sensors | Admin Bearer JWT (ADMIN) | Param:vehicleId, Query:search, Query:page, Query:limit, Query:includeLive |
| ADM-148 | POST | /admin/vehicles/:vehicleId/sensors | Admin Bearer JWT (ADMIN) | Param:vehicleId, CreateVehicleSensorDto |
| ADM-149 | DELETE | /admin/vehicles/:vehicleId/sensors/:sensorId | Admin Bearer JWT (ADMIN) | Param:vehicleId, Param:sensorId |
| ADM-150 | PATCH | /admin/vehicles/:vehicleId/sensors/:sensorId | Admin Bearer JWT (ADMIN) | Param:vehicleId, Param:sensorId, UpdateVehicleSensorDto |
| ADM-151 | POST | /admin/vehicles/:vehicleId/sensors/run | Admin Bearer JWT (ADMIN) | Param:vehicleId, RunVehicleSensorDto |
| ADM-152 | GET | /admin/vehicles/:vehicleId/sensors/telemetry | Admin Bearer JWT (ADMIN) | Param:vehicleId |
| ADM-153 | GET | /admin/vehicles/by-imei/:imei/commands | Admin Bearer JWT (ADMIN) | Param:imei, Query:limit, Query:cursorId |
| ADM-154 | GET | /admin/vehicles/by-imei/:imei/details | Admin Bearer JWT (ADMIN) | Param:imei |
| ADM-155 | GET | /admin/vehicles/by-imei/:imei/events | Admin Bearer JWT (ADMIN) | Param:imei, MapEventsQueryDto |
| ADM-156 | GET | /admin/vehicles/by-imei/:imei/events/export | Admin Bearer JWT (ADMIN) | Param:imei, Query:from, Query:to, Query:source, Query:severity |
| ADM-157 | GET | /admin/vehicles/by-imei/:imei/history | Admin Bearer JWT (ADMIN) | Param:imei, Query:from, Query:to, Query:stopMin, Query:overspeedKph, Query:maxPoints |
| ADM-158 | GET | /admin/vehicles/by-imei/:imei/logs | Admin Bearer JWT (ADMIN) | Param:imei, Query:from, Query:to, Query:limit, Query:beforeId |
| ADM-159 | GET | /admin/vehicles/by-imei/:imei/logs/export | Admin Bearer JWT (ADMIN) | Param:imei, Query:from, Query:to |
| ADM-160 | GET | /admin/vehicles/by-imei/:imei/replay | Admin Bearer JWT (ADMIN) | Param:imei, Query:from, Query:to, Query:maxPoints |
| ADM-161 | POST | /admin/vehicles/by-imei/:imei/send-command | Admin Bearer JWT (ADMIN) | Param:imei, SendDeviceCommandDto |
| ADM-162 | GET | /admin/vehicles/by-imei/:imei/sensors | Admin Bearer JWT (ADMIN) | Param:imei, Query:includeTelemetryMeta |
| ADM-163 | GET | /admin/vehicles/by-imei/:imei/trail | Admin Bearer JWT (ADMIN) | Param:imei, Query:hours, Query:from, Query:to, Query:maxPoints |
| ADM-164 | POST | /admin/vehiclebulkjobs | Admin Bearer JWT (ADMIN) | CreateVehicleBulkJobDto |
| ADM-165 | GET | /admin/vehiclebulkjobs/:id | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-166 | GET | /admin/vehiclebulkjobs/:id/failed.csv | Admin Bearer JWT (ADMIN) | Param:id |
| ADM-167 | GET | /admin/vehiclebulkjobs/:id/stream | Admin Bearer JWT (ADMIN) | Param:id |
| USR-001 | PATCH | /user/companydetails | User Bearer JWT (ADMIN, USER) | CompanyDto |
| USR-002 | POST | /user/upload | User Bearer JWT (ADMIN, USER) | None |
| USR-003 | GET | /user/dashboard/day-night-comparison | User Bearer JWT (ADMIN, USER) | Query:vehicleId, Query:from, Query:to, Query:tzOffset |
| USR-004 | GET | /user/dashboard/fleet-status | User Bearer JWT (ADMIN, USER) | None |
| USR-005 | GET | /user/dashboard/recent-alerts | User Bearer JWT (ADMIN, USER) | Query:vehicleId, Query:limit, Query:beforeId, Query:from |
| USR-006 | GET | /user/dashboard/recent-alerts/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-007 | PATCH | /user/dashboard/recent-alerts/:id/read | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-008 | GET | /user/dashboard/top-performing-assets | User Bearer JWT (ADMIN, USER) | Query:from, Query:to, Query:limit |
| USR-009 | GET | /user/dashboard/usage-last-7-days | User Bearer JWT (ADMIN, USER) | Query:vehicleId, Query:tzOffset |
| USR-010 | GET | /user/dashboard/weekly-comparison | User Bearer JWT (ADMIN, USER) | Query:vehicleId, Query:tzOffset |
| USR-011 | GET | /user/dashboards | User Bearer JWT (ADMIN, USER) | None |
| USR-012 | POST | /user/dashboards | User Bearer JWT (ADMIN, USER) | CreateDashboardDto |
| USR-013 | DELETE | /user/dashboards/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-014 | GET | /user/dashboards/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-015 | PUT | /user/dashboards/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateDashboardDto |
| USR-016 | GET | /user/commands/:cmdId | User Bearer JWT (ADMIN, USER) | Param:cmdId |
| USR-017 | POST | /user/commands/send-bulk | User Bearer JWT (ADMIN, USER) | SendCommandBulkDto |
| USR-018 | GET | /user/commands/status/:cmdId | User Bearer JWT (ADMIN, USER) | Param:cmdId |
| USR-019 | GET | /user/customcommands | User Bearer JWT (ADMIN, USER) | CustomCommandsQueryDto |
| USR-020 | GET | /user/drivers | User Bearer JWT (ADMIN, USER) | None |
| USR-021 | POST | /user/drivers | User Bearer JWT (ADMIN, USER) | CreateUserDriverDto |
| USR-022 | DELETE | /user/drivers/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-023 | GET | /user/drivers/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-024 | PATCH | /user/drivers/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateUserDriverDto |
| USR-025 | POST | /user/drivers/:id/assign-vehicle | User Bearer JWT (ADMIN, USER) | Param:id, AssignDriverVehicleDto |
| USR-026 | GET | /user/drivers/:id/documents | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-027 | POST | /user/drivers/:id/documents | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-028 | DELETE | /user/drivers/:id/documents/:docId | User Bearer JWT (ADMIN, USER) | Param:id, Param:docId |
| USR-029 | PATCH | /user/drivers/:id/documents/:docId | User Bearer JWT (ADMIN, USER) | Param:id, Param:docId |
| USR-030 | GET | /user/drivers/:id/logs | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-031 | POST | /user/drivers/:id/unassign-vehicle | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-032 | GET | /user/geofences | User Bearer JWT (ADMIN, USER) | Query:q, Query:isActive, Query:type |
| USR-033 | POST | /user/geofences | User Bearer JWT (ADMIN, USER) | CreateGeofenceDto |
| USR-034 | DELETE | /user/geofences/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-035 | GET | /user/geofences/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-036 | PATCH | /user/geofences/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateGeofenceDto |
| USR-037 | POST | /user/landmarkbulkjobs | User Bearer JWT (ADMIN, USER) | CreateLandmarkBulkJobDto |
| USR-038 | GET | /user/landmarkbulkjobs/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-039 | GET | /user/landmarkbulkjobs/:id/failed.csv | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-040 | GET | /user/landmarkbulkjobs/:id/stream | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-041 | GET | /user/pois | User Bearer JWT (ADMIN, USER) | Query:q, Query:isActive |
| USR-042 | POST | /user/pois | User Bearer JWT (ADMIN, USER) | CreatePoiDto |
| USR-043 | DELETE | /user/pois/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-044 | GET | /user/pois/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-045 | PATCH | /user/pois/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdatePoiDto |
| USR-046 | GET | /user/vehicle-groups | User Bearer JWT (ADMIN, USER) | None |
| USR-047 | POST | /user/vehicle-groups | User Bearer JWT (ADMIN, USER) | CreateVehicleGroupDto |
| USR-048 | DELETE | /user/vehicle-groups/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-049 | PATCH | /user/vehicle-groups/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateVehicleGroupDto |
| USR-050 | PUT | /user/vehicle-groups/:id/vehicles | User Bearer JWT (ADMIN, USER) | Param:id, ReplaceVehicleGroupVehiclesDto |
| USR-051 | GET | /user/map-events | User Bearer JWT (ADMIN, USER) | MapEventsQueryDto |
| USR-052 | GET | /user/map-telemetry | User Bearer JWT (ADMIN, USER) | Query:cursor, Query:limit |
| USR-053 | GET | /user/notification-settings | User Bearer JWT (ADMIN, USER) | None |
| USR-054 | PUT | /user/notification-settings | User Bearer JWT (ADMIN, USER) | Body:dto |
| USR-055 | GET | /user/notifications | User Bearer JWT (USER) | NotificationsQueryDto |
| USR-056 | PATCH | /user/notifications/:id/read | User Bearer JWT (USER) | Param:id |
| USR-057 | GET | /user/notifications/preferences | User Bearer JWT (ADMIN, USER) | None |
| USR-058 | PUT | /user/notifications/preferences | User Bearer JWT (ADMIN, USER) | Body:dto |
| USR-059 | PATCH | /user/notifications/read-all | User Bearer JWT (USER) | None |
| USR-060 | POST | /user/notifications/test-fcm-me | User Bearer JWT (ADMIN, USER) | TestPushDto |
| USR-061 | GET | /user/notifications/vehicle | User Bearer JWT (USER) | NotificationsQueryDto, Query:vehicleId |
| USR-062 | PATCH | /user/notifications/vehicle/:id/read | User Bearer JWT (USER) | Param:id |
| USR-063 | PATCH | /user/notifications/vehicle/read-all | User Bearer JWT (USER) | None |
| USR-064 | GET | /user/transactions | User Bearer JWT (ADMIN, USER) | Query:status, Query:from, Query:to, Query:q, Query:page, Query:limit |
| USR-065 | GET | /user/profile | User Bearer JWT (ADMIN, USER) | None |
| USR-066 | PATCH | /user/profile | User Bearer JWT (ADMIN, USER) | ProfileDto |
| USR-067 | GET | /user/profile/email-subscription | User Bearer JWT (ADMIN, USER) | None |
| USR-068 | POST | /user/profile/email-subscription/subscribe | User Bearer JWT (ADMIN, USER) | None |
| USR-069 | POST | /user/profile/verify/email/confirm | User Bearer JWT (ADMIN, USER) | VerifyOtpDto |
| USR-070 | POST | /user/profile/verify/email/request | User Bearer JWT (ADMIN, USER) | None |
| USR-071 | POST | /user/profile/verify/whatsapp/confirm | User Bearer JWT (ADMIN, USER) | VerifyOtpDto |
| USR-072 | POST | /user/profile/verify/whatsapp/request | User Bearer JWT (ADMIN, USER) | None |
| USR-073 | PATCH | /user/updatepassword | User Bearer JWT (ADMIN, USER) | UpdatePasswordDto |
| USR-074 | POST | /user/reports/:reportKey | User Bearer JWT (USER) | Param:reportKey, GenerateReportDto |
| USR-075 | GET | /user/reports/options | User Bearer JWT (USER) | None |
| USR-076 | POST | /user/reports/timeline/map | User Bearer JWT (USER) | TimelineMapDto |
| USR-077 | GET | /user/routes | User Bearer JWT (ADMIN, USER) | Query:q, Query:isActive, Query:includeGeodata |
| USR-078 | POST | /user/routes | User Bearer JWT (ADMIN, USER) | CreateRouteDto |
| USR-079 | DELETE | /user/routes/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-080 | GET | /user/routes/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-081 | PATCH | /user/routes/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateRouteDto |
| USR-082 | GET | /user/topbar-search | User Bearer JWT (USER) | TopbarSearchQueryDto |
| USR-083 | GET | /user/localization | User Bearer JWT (ADMIN, USER) | None |
| USR-084 | PATCH | /user/localization | User Bearer JWT (ADMIN, USER) | UpdateSettingsStateDto |
| USR-085 | GET | /user/systemvariables | User Bearer JWT (ADMIN, USER) | None |
| USR-086 | GET | /user/sharetracklinks | User Bearer JWT (ADMIN, USER) | ListShareTrackLinksDto |
| USR-087 | POST | /user/sharetracklinks | User Bearer JWT (ADMIN, USER) | CreateShareTrackLinkDto |
| USR-088 | DELETE | /user/sharetracklinks/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-089 | GET | /user/sharetracklinks/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-090 | PATCH | /user/sharetracklinks/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateShareTrackLinkDto |
| USR-091 | GET | /user/subusers | User Bearer JWT (ADMIN, USER) | Query:search, Query:page, Query:limit |
| USR-092 | POST | /user/subusers | User Bearer JWT (ADMIN, USER) | CreateSubUserDto |
| USR-093 | DELETE | /user/subusers/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-094 | GET | /user/subusers/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-095 | PATCH | /user/subusers/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateSubUserDto |
| USR-096 | GET | /user/subusers/:id/vehicles | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-097 | POST | /user/subusers/:id/vehicles/assign | User Bearer JWT (ADMIN, USER) | Param:id, AssignSubUserVehiclesDto |
| USR-098 | POST | /user/subusers/:id/vehicles/unassign | User Bearer JWT (ADMIN, USER) | Param:id, UnassignSubUserVehiclesDto |
| USR-099 | GET | /user/tickets | User Bearer JWT (ADMIN, USER) | None |
| USR-100 | POST | /user/tickets | User Bearer JWT (ADMIN, USER) | None |
| USR-101 | GET | /user/tickets/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-102 | POST | /user/tickets/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-103 | GET | /user/vehicles | User Bearer JWT (ADMIN, USER) | None |
| USR-104 | GET | /user/vehicles/:id | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-105 | PATCH | /user/vehicles/:id | User Bearer JWT (ADMIN, USER) | Param:id, UpdateUserVehicleDto |
| USR-106 | PATCH | /user/vehicles/:id/config | User Bearer JWT (ADMIN, USER) | Param:id, UpdateVehicleConfigDto |
| USR-107 | GET | /user/vehicles/:id/documents | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-108 | POST | /user/vehicles/:id/documents | User Bearer JWT (ADMIN, USER) | Param:id |
| USR-109 | DELETE | /user/vehicles/:id/documents/:docId | User Bearer JWT (ADMIN, USER) | Param:id, Param:docId |
| USR-110 | PATCH | /user/vehicles/:id/documents/:docId | User Bearer JWT (ADMIN, USER) | Param:id, Param:docId |
| USR-111 | GET | /user/vehicles/:vehicleId/commands | User Bearer JWT (ADMIN, USER) | Param:vehicleId, Query:limit, Query:cursorId |
| USR-112 | GET | /user/vehicles/:vehicleId/sensors | User Bearer JWT (ADMIN, USER) | Param:vehicleId, Query:search, Query:page, Query:limit, Query:includeLive |
| USR-113 | POST | /user/vehicles/:vehicleId/sensors | User Bearer JWT (ADMIN, USER) | Param:vehicleId, CreateVehicleSensorDto |
| USR-114 | DELETE | /user/vehicles/:vehicleId/sensors/:sensorId | User Bearer JWT (ADMIN, USER) | Param:vehicleId, Param:sensorId |
| USR-115 | PATCH | /user/vehicles/:vehicleId/sensors/:sensorId | User Bearer JWT (ADMIN, USER) | Param:vehicleId, Param:sensorId, UpdateVehicleSensorDto |
| USR-116 | GET | /user/vehicles/:vehicleId/sensors/:sensorId/history | User Bearer JWT (ADMIN, USER) | Param:vehicleId, Param:sensorId, Query:from, Query:to, Query:maxPoints |
| USR-117 | POST | /user/vehicles/:vehicleId/sensors/run | User Bearer JWT (ADMIN, USER) | Param:vehicleId, RunVehicleSensorDto |
| USR-118 | GET | /user/vehicles/:vehicleId/sensors/telemetry | User Bearer JWT (ADMIN, USER) | Param:vehicleId |
| USR-119 | GET | /user/vehicles/:vehicleId/telemetry | User Bearer JWT (ADMIN, USER) | Param:vehicleId |
| USR-120 | GET | /user/vehicles/by-imei/:imei/details | User Bearer JWT (ADMIN, USER) | Param:imei |
| USR-121 | GET | /user/vehicles/by-imei/:imei/events | User Bearer JWT (ADMIN, USER) | Param:imei, MapEventsQueryDto |
| USR-122 | GET | /user/vehicles/by-imei/:imei/history | User Bearer JWT (ADMIN, USER) | Param:imei, Query:from, Query:to, Query:stopMin, Query:overspeedKph, Query:maxPoints |
| USR-123 | GET | /user/vehicles/by-imei/:imei/logs | User Bearer JWT (ADMIN, USER) | Param:imei, Query:from, Query:to, Query:limit, Query:beforeId |
| USR-124 | GET | /user/vehicles/by-imei/:imei/replay | User Bearer JWT (ADMIN, USER) | Param:imei, Query:from, Query:to, Query:maxPoints |
| USR-125 | GET | /user/vehicles/by-imei/:imei/sensors | User Bearer JWT (ADMIN, USER) | Param:imei, Query:includeTelemetryMeta |
| USR-126 | GET | /user/vehicles/by-imei/:imei/trail | User Bearer JWT (ADMIN, USER) | Param:imei, Query:hours, Query:from, Query:to, Query:maxPoints |
| PUB-001 | GET | /unsubscribe | Public and Shared Public | Query:u, Query:b, Query:s, Query:t |
| PUB-002 | GET | /branding | Public and Shared Public | Query:host |
| PUB-003 | GET | /devicestypes | Public and Shared Public | None |
| PUB-004 | GET | /vehicletypes | Public and Shared Public | None |
| PUB-005 | GET | / | Public and Shared Public | None |
| PUB-006 | GET | /cities/:countryCode/:stateCode | Public and Shared Public | Param:countryCode, Param:stateCode |
| PUB-007 | GET | /countries | Public and Shared Public | None |
| PUB-008 | GET | /currencies | Public and Shared Public | None |
| PUB-009 | GET | /dateformats | Public and Shared Public | None |
| PUB-010 | GET | /documenttypes/:documentType | Public and Shared Public | Param:documentType |
| PUB-011 | GET | /languages | Public and Shared Public | None |
| PUB-012 | GET | /mobileprefix | Public and Shared Public | None |
| PUB-013 | GET | /policies | Public and Shared Public | None |
| PUB-014 | GET | /policies/:type | Public and Shared Public | Param:type |
| PUB-015 | GET | /simproviders | Public and Shared Public | None |
| PUB-016 | GET | /states/:countryCode | Public and Shared Public | Param:countryCode |
| PUB-017 | GET | /status | Public and Shared Public | None |
| PUB-018 | GET | /timezones | Public and Shared Public | None |
| PUB-019 | GET | /version | Public and Shared Public | None |
| TRACK-001 | GET | /public/track/:code | Public Tracking Public | Param:code |
| TRACK-002 | GET | /public/track/:code/geofences | Public Tracking Public | Param:code |
| TRACK-003 | GET | /public/track/:code/telemetry | Public Tracking Public | Param:code, Query:cursor, Query:limit |
| TRACK-004 | GET | /public/track/:code/vehicles/:imei/details | Public Tracking Public | Param:code, Param:imei |
| TRACK-005 | GET | /public/track/:code/vehicles/:imei/history | Public Tracking Public | Param:code, Param:imei, Query:from, Query:to, Query:stopMin, Query:overspeedKph, Query:maxPoints |
| TRACK-006 | GET | /public/track/:code/vehicles/:imei/logs | Public Tracking Public | Param:code, Param:imei, Query:limit, Query:beforeId |
| TRACK-007 | GET | /public/track/:code/vehicles/:imei/replay | Public Tracking Public | Param:code, Param:imei, Query:from, Query:to, Query:maxPoints |
| GEO-001 | GET | /geocoding/precision | Geocoding Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER, TEAM, DRIVER) | None |
| GEO-002 | GET | /geocoding/reverse | Geocoding Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER, TEAM, DRIVER) | Query:lat, Query:lng |
| GEO-003 | POST | /geocoding/reverse/bulk | Geocoding Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER, TEAM, DRIVER) | BulkReverseGeocodeDto |
| FDBK-001 | POST | /bug-reports | Feedback Bearer JWT (any authenticated role) | CreateBugReportDto |
| FDBK-002 | POST | /feature-requests | Feedback Bearer JWT (SUPERADMIN) | CreateFeatureRequestDto |
| AGENT-001 | POST | /agent/commands | Agent Orchestration Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER) | CreateAgentCommandDto |
| AGENT-002 | GET | /agent/executions/:executionId | Agent Orchestration Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER) | ExecutionIdParamDto |
| AGENT-003 | GET | /agent/executions/:executionId/status | Agent Orchestration Bearer JWT (SUPERADMIN, ADMIN, USER, SUBUSER) | ExecutionIdParamDto |
| WH-001 | GET | /webhooks/whatsapp | Webhooks Public | Query:hub.mode, Query:hub.verify_token, Query:hub.challenge |
| WH-002 | POST | /webhooks/whatsapp | Webhooks Public | None |
| ING-001 | POST | /handledata | Internal Ingestion x-listener-secret header | Body:payload |
| ING-002 | POST | /handledata/batch | Internal Ingestion x-listener-secret header | Body:body |
| OPS-001 | GET | /health | Health and Operations Public | None |
| OPS-002 | GET | /health/address-db | Health and Operations Public | None |
| OPS-003 | GET | /health/databases | Health and Operations Public | None |
| OPS-004 | GET | /health/ingest-ready | Health and Operations Public | None |
| OPS-005 | GET | /health/ingestion | Health and Operations Public | None |
| OPS-006 | GET | /health/live | Health and Operations Public | None |
| OPS-007 | GET | /health/logs-db | Health and Operations Public | None |
| OPS-008 | GET | /health/primary-db | Health and Operations Public | None |
| OPS-009 | GET | /health/queue-maintenance | Health and Operations Public | None |
| OPS-010 | GET | /health/queues | Health and Operations Public | None |
| OPS-011 | POST | /health/queues/cleanup | Health and Operations Public | None |
| OPS-012 | GET | /health/ready | Health and Operations Public | None |
| OPS-013 | GET | /health/redis-memory | Health and Operations Public | None |
| OPS-014 | GET | /health/runtime | Health and Operations Public | None |
| OPS-015 | GET | /health/telemetry-diagnostics/:imei | Health and Operations Public | Param:imei |
| OPS-016 | GET | /health/telemetry-packet/:imei/:sourcePacketId | Health and Operations Public | Param:imei, Param:sourcePacketId |
| OPS-017 | GET | /health/telemetry-stats | Health and Operations Public | None |
| OPS-018 | GET | /health/telemetry-stats-memory | Health and Operations Public | None |
| OPS-019 | GET | /health/telemetry-stats/:imei | Health and Operations Public | Param:imei |

## End of Reference

Coverage check: 590 HTTP routes, 21 controllers, 148 source schemas, 0 duplicate method/path pairs.

When backend source changes, regenerate this reference from controllers, DTOs, services, gateways, configuration, and the response interceptor. Do not use the legacy Postman collection as the authoritative route list.
