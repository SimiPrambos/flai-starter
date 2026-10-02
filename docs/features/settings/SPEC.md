---
name: settings
status: draft
owner: silmi
branch: feat/backport-tooling-dx
last_changed: 2026-10-02
---

# Feature: Settings

## Overview

**Why:** Gives the tab shell a second branch and gives users a place to sign out.

**User Stories:**
- As a signed-in user, I want a Settings tab so that account actions live outside the content tabs
- As a signed-in user, I want to sign out so that the next launch asks me to sign in again

## Entity

None. Uses the core session flag only.

## API

| Method | Endpoint | Params | Response | Status    |
|--------|----------|--------|----------|-----------|
| —      | _none_   | —      | —        | mock-only |

## Scenarios

### Open the Settings tab

**Given** the user is signed in and on the Users tab
**When** they tap the Settings tab
**Then** `SettingsPage` renders inside the shell with the Settings tab highlighted

### Tab state is preserved

**Given** the user opened a user detail in the Users tab
**When** they switch to Settings and back to Users
**Then** the user detail is still shown

### Re-tap resets the tab

**Given** the user is on a user detail in the Users tab
**When** they tap the active Users tab again
**Then** the Users branch pops back to `UsersPage`

### Sign out

**Given** the user is on `SettingsPage`
**When** they tap "Sign out"
**Then** the stored session is cleared and the router redirects to `/login`

## UI States

### SettingsPage

- **Loading / Empty / Error:** n/a (static page)
- **Data:** AppBar "Settings", outlined `AppButton` "Sign out" with `Icons.logout`

## Navigation

- **Entry:** `/settings` → `SettingsRoute` (`settings`), shell branch 1, tab icon `Icons.settings_outlined`
- **Sign out:** redirect → `/login`

## Acceptance Criteria

- [ ] Settings tab shows `SettingsPage` (router test)
- [ ] Switching tabs keeps the Users branch stack (router + shell tests)
- [ ] Re-tapping the active tab resets its branch (router + shell tests)
- [ ] Sign-out clears the session (settings page test) and lands on `LoginPage` (router test)
- [ ] Strings from l10n (`settingsTitle`, `settingsSignOut`, `tabSettings`), EN + ID

## Open Questions

_(none)_
