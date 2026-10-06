# Mobile Account Hierarchy Session Fix — 2026-10-06

## Expected hierarchy

The mobile authentication layer supports this parent-to-child account hierarchy:

- Superadmin -> Admin
- Admin -> Team or User
- Team -> User
- User -> Subuser or Driver

A child login must not destroy the parent session. Logging out of the current child, or invalidating only that child session, must resume the closest surviving parent session.

## Root cause

The app already stored one secure session per role, but two behaviors could collapse an impersonation flow back to Login:

1. When secure storage changed from the active child to a surviving parent session, `AuthController` treated the principal mismatch as a total logout instead of restoring the new active parent.
2. Session fallback was chosen from a static role-priority list. That did not preserve the actual account traversal path when several role sessions were present.

The problem was most visible on Superadmin -> Administrators -> Login as Admin. If the child session was cleared/rejected during profile or refresh validation, the parent Superadmin session could still exist while the UI was nevertheless sent to Login.

## Changes

- Added a persisted secure role traversal stack to `TokenStorage`.
- Logout now restores the most recently traversed surviving parent role before using the legacy priority fallback.
- Added `AuthController.switchToChildSession(...)` with explicit hierarchy validation.
- Superadmin -> Admin and Admin/Team -> User now use the hierarchy-aware switch method.
- A child session rejected during bootstrap is removed without clearing the parent session.
- A child session invalidated later automatically restores the stored parent instead of forcing Login.
- Local preference-write failures no longer discard a valid newly issued auth session.
- Incomplete Superadmin -> Admin login responses are treated as errors rather than false-success UI states.

## Regression coverage added

Tests now cover:

- Superadmin -> Admin -> User -> logout -> Admin -> logout -> Superadmin.
- Full declared hierarchy traversal through Team, Subuser, and Driver session states.
- Child revocation during account switching with parent restoration.
- External child invalidation while authenticated with automatic parent restoration.
- Persistence of the traversal stack across `TokenStorage` reconstruction/app restart.
- Removal of the traversal stack on logout-all.

## API-surface note

In the supplied Flutter source, concrete Login-as network actions currently exist for:

- Superadmin -> Admin
- Admin -> User
- Team -> User (through the Team API policy mapping)

The authentication/session engine now supports the complete six-role hierarchy above. No unverified backend endpoint was invented for Admin -> Team or User -> Subuser/Driver; those UI/service actions should only be wired when their backend Login-as contracts exist in the deployed Open VTS API.
