---
name: users
status: shipped
owner: silmi
branch: main
last_changed: 2026-05-20
---

# Feature: Users

## Overview

**Why:** Reference implementation of the full Clean Architecture + Riverpod + GoRouter stack against a public API (`reqres.in`). Treat it as the template for any new feature.

**User Stories:**
- As a developer, I want to see a working list + detail flow so that I can model new features after it
- As a developer, I want a paginated list so that I can copy the `PaginatedListPage` + `PaginatedMixin` pattern
- As a developer, I want a typed-route detail page so that I can copy the `@TypedGoRoute` + `AsyncDetailScaffold` pattern

## Entity

| Field     | Type   | Nullable | Notes                                            |
|-----------|--------|----------|--------------------------------------------------|
| id        | int    | no       | server-assigned                                  |
| email     | String | no       |                                                  |
| firstName | String | no       | maps from JSON `first_name`                      |
| lastName  | String | no       | maps from JSON `last_name`                       |
| avatar    | String | no       | absolute URL to an image                         |

Convenience getter: `fullName` → `"$firstName $lastName"`

## API

| Method | Endpoint        | Params      | Response             | Status    |
|--------|-----------------|-------------|----------------------|-----------|
| GET    | /users          | page: int   | UsersListResponse    | confirmed |
| GET    | /users/{id}     | id: int     | UserSingleResponse   | confirmed |

Base URL: `https://reqres.in/api` (configured via `Env.baseUrl`).

## Scenarios

### Listing users — happy path

**Given** the API returns a non-empty page of users
**When** the user opens `/users`
**Then** `UserCard` rows render with avatar, full name, and email

### Listing users — empty page

**Given** the API returns an empty array
**When** the user opens `/users`
**Then** the empty state message appears

### Listing users — load more

**Given** more pages are available (`hasMore == true`)
**When** the user scrolls to the bottom
**Then** the next page is requested and appended; duplicate requests are guarded by `PaginatedMixin`

### Listing users — error + retry

**Given** the API returns a network or server error
**When** the user opens `/users`
**Then** an error message + retry button render; tapping retry resets to page 1

### Detail — happy path

**Given** the API returns a user for the given id
**When** the user taps a `UserCard`
**Then** `UserDetailRoute(id: user.id)` is pushed and renders the user's avatar (120dp), full name, and email

### Detail — loading

**Given** the detail request is in flight
**When** the page mounts
**Then** `UserDetailSkeleton` renders until the data resolves

### Detail — error

**Given** the API returns an error
**When** the page mounts
**Then** the standard `AsyncDetailScaffold` error UI renders with retry

## UI States

### UsersPage (list)

- **Loading:** `UserCardSkeleton × 6` via `Skeletonizer`
- **Empty:** "No users found"
- **Error:** message + retry (via `PaginatedListPage`)
- **Data:** `UserCard` showing avatar (48dp), full name, email

### UserDetailPage

- **Loading:** `UserDetailSkeleton`
- **Error:** retry (via `AsyncDetailScaffold`)
- **Data:** centered avatar (120dp), full name (headline), email (body)

## Navigation

- **Entry:** `/users` → `UsersRoute`
- **List → Detail:** tap card → `UserDetailRoute(id: user.id).push(context)` → renders at `/users/:id`

## Acceptance Criteria

- [x] Paginated list with skeleton loading, empty, error+retry, and data states
- [x] Detail page with skeleton loading, error+retry, and data states
- [x] Typed routes via `@TypedGoRoute` + generated `$appRoutes`
- [x] Repository returns `Either<Failure, T>` and uses `RepositoryGuard`
- [x] Notifier overrides covered by tests in `test/features/users/`
- [x] All `lib/shared/widgets/` building blocks used: `AppAvatar`, `PaginatedListPage`, `AsyncDetailScaffold`, `ErrorRetryWidget`, `Skeletonizer`

## Open Questions

_(none — feature is shipped and locked. Material changes require a new ADR in `decisions/`.)_
