---
name: auth
status: draft
owner: silmi
branch: feat/backport-ef-session-shell
last_changed: 2026-10-02
---

# Feature: Auth

## Overview

**Why:** Every app built from the starter needs a signed-out → signed-in → signed-out flow guarded by the router, ready to swap a mock sign-in for a real backend.

**User Stories:**
- As a user, I want the app to remember that I signed in so that relaunching skips the login screen
- As a user, I want to be sent to the login screen whenever I am signed out so that protected screens are never shown
- As a developer, I want sign-in to be one notifier call so that wiring a real auth repository only touches the login page

## Entity

No feature entity. Session state is a single flag owned by `lib/core/auth/session_notifier.dart`.

| Field    | Type | Nullable | Notes                                                        |
|----------|------|----------|--------------------------------------------------------------|
| signedIn | bool | no       | Persisted under secure-storage key `session_active` (`"true"`) |

## API

| Method | Endpoint | Params | Response | Status    |
|--------|----------|--------|----------|-----------|
| —      | _none_   | —      | —        | mock-only |

Sign-in is mocked: the login button only flips the session flag. A real backend adds a domain + data layer (see Open Questions).

## Scenarios

### Cold start — no stored session

**Given** secure storage has no `session_active` value
**When** the app launches
**Then** `SplashPage` shows a centered loader, then the router redirects to `/login` and `LoginPage` renders

### Cold start — stored session

**Given** secure storage has `session_active = "true"`
**When** the app launches
**Then** the router redirects from `/` to `/users` without showing `LoginPage`

### Session still loading

**Given** the session read has not completed
**When** the router evaluates a redirect
**Then** no redirect happens and `SplashPage` stays visible

### Storage failure

**Given** reading secure storage throws
**When** the app launches
**Then** the user is treated as signed out and lands on `LoginPage`

### Sign in

**Given** the user is on `/login`
**When** they tap the sign-in button
**Then** `session_active` is persisted and the router redirects to `/users` inside the tab shell

### Signed-in user opens login or splash

**Given** the user is signed in
**When** the location becomes `/login` or `/`
**Then** the router redirects to `/users`

### Signed-out deep link

**Given** the user is signed out
**When** the location becomes `/users/7` (or any non-login path)
**Then** the router redirects to `/login`

## UI States

### SplashPage

- **Loading:** centered `CircularProgressIndicator` on `AppColors.background`
- **Empty / Error / Data:** n/a. The page never navigates; the router redirect leaves it.

### LoginPage

- **Loading:** n/a (mock sign-in completes immediately)
- **Error:** n/a (mock)
- **Data:** AppBar "Sign in", `AppTextField` (email, `TextInputType.emailAddress`), full-width `AppButton` "Sign in"

## Navigation

- **Entry:** `/` → `SplashRoute` (`splash`), the initial location
- **Login:** `/login` → `LoginRoute` (`login`)
- **After sign-in:** redirect → `UsersRoute` (`/users`, shell branch 0)
- **Guard:** `resolveRedirect` in `lib/core/router/redirect_resolver.dart`

## Acceptance Criteria

- [ ] Cold start without a session lands on `LoginPage` (router test)
- [ ] Cold start with a session lands on `UsersPage` (router test)
- [ ] `SplashPage` is shown while the session is loading (router test)
- [ ] A storage failure is treated as signed out (router + notifier tests)
- [ ] Tapping sign-in persists the session and lands on `UsersPage` (login page test + router test)
- [ ] `resolveRedirect` truth table covers signed in/out × login/splash/home/deep link/other tab
- [ ] All strings come from l10n (`loginTitle`, `loginEmailLabel`, `loginSubmit`), EN + ID

## Open Questions

- [ ] Real auth backend contract (endpoint, token format, refresh): resolved by the first consuming app's backend team. When confirmed, scaffold `make-domain` + `make-data` for `auth`, add a `LoginNotifier`, and call `signIn()` on success.
