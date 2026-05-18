---
name: flai-navigation
description: Use when adding routes, navigating between screens, or reviewing routing code in this Flutter project. Covers TypedGoRouter patterns, GoRouteData subclasses, and route naming conventions.
---

# Navigation

## Core Rule

Always use **TypedGoRouter** (`GoRouteData` subclasses). Never navigate with raw path strings.

```dart
// CORRECT
UsersRoute().go(context);
UserDetailRoute(id: user.id).go(context);

// NEVER do this
context.go('/users');
context.go('/users/${user.id}');
```

## Route Definition

Routes live in `lib/core/router/app_router.dart` as `GoRouteData` subclasses with `.go()`/`.push()` extensions.

Every `GoRoute` must have a stable `name` — Firebase Analytics uses route observers and reports screen names.

## Current Routes

| Class | Path |
|---|---|
| `UsersRoute` | `/users` |
| `UserDetailRoute` | `/users/:id` |

## Adding a New Route

1. Define a `GoRouteData` subclass in `app_router.dart`
2. Add `.go()` / `.push()` extension methods
3. Add a stable `name` string to the `GoRoute`
4. Wire it into the router tree

> `go_router_builder` is NOT used — typed route extensions are written manually due to `source_gen` version conflict with `freezed`.
