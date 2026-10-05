---
name: flai-navigation
description: Use when adding routes, navigating between screens, or reviewing routing code in this Flutter project. Covers @TypedGoRoute, GoRouteData, and route naming conventions.
---

# Navigation

## Core Rule

Always use `@TypedGoRoute` + `GoRouteData` subclasses. Never navigate with raw path strings.

```dart
// CORRECT
const UsersRoute().go(context);
UserDetailRoute(id: user.id).push(context);

// NEVER do this
context.go('/users');
context.go('/users/${user.id}');
```

## How It Works

`@TypedGoRoute` is an annotation from `go_router_builder` (dev dependency). Running `build_runner` generates:

- `List<RouteBase> get $appRoutes` — the full `GoRoute` tree, passed to `GoRouter(routes: $appRoutes)`
- `mixin _$ClassName` — provides `.go()`, `.push()`, `.pushReplacement()`, `.replace()`, and `.location` on each route class
- Type-safe path parameter parsing (e.g., `int id` on the class → auto-parsed from `:id` in the path)

## Route Definition Pattern

All routes live in `lib/core/router/app_router.dart`.

```dart
part 'app_router.g.dart';

@TypedGoRoute<UsersRoute>(
  path: '/users',
  routes: [
    TypedGoRoute<UserDetailRoute>(path: ':id'),
  ],
)
@immutable
class UsersRoute extends GoRouteData with _$UsersRoute {
  const UsersRoute();

  static const path = '/users';     // keep for tests and initialLocation
  static const routeName = 'users'; // required for Firebase Analytics

  @override
  Widget build(BuildContext context, GoRouterState state) => const UsersPage();
}

@immutable
class UserDetailRoute extends GoRouteData with _$UserDetailRoute {
  const UserDetailRoute({required this.id});

  static const path = ':id';
  static const routeName = 'user_detail';

  final int id; // auto-parsed from :id by the generator

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserDetailPage(id: id);
}
```

## Router Provider

The router uses `$appRoutes` (generated) — no manual `GoRoute` tree:

```dart
@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: UsersRoute.path,
    observers: [...],
    routes: $appRoutes,
  );
}
```

## Current Routes

| Class | Path | routeName | Where |
|---|---|---|---|
| `SplashRoute` | `/` | `splash` | top-level (initial location) |
| `LoginRoute` | `/login` | `login` | top-level |
| `UsersRoute` | `/users` | `users` | `AppShellRoute` branch 0 |
| `UserDetailRoute` | `/users/:id` | `user_detail` | `AppShellRoute` branch 0, nested |
| `SettingsRoute` | `/settings` | `settings` | `AppShellRoute` branch 1 |

Access is gated by the session redirect, and tabs come from `AppShellRoute` + `kAppTabs`. See the `flai-auth-navigation` skill before touching the redirect, the shell or the tab list.

## Adding a New Route

1. Define a `GoRouteData` subclass in `app_router.dart` with `with _$ClassName` mixin
2. Add `static const routeName` — Firebase Analytics reports this as the screen name
3. Keep `static const path` — used for `GoRouter(initialLocation:)` and tests
4. Add `@TypedGoRoute<NewRoute>(path: '...')` annotation (or nest it under an existing route via `routes:`)
5. Run build_runner — `$appRoutes` updates automatically:
   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```
6. Navigate using the generated methods: `const NewRoute().go(context)`

### Nested route example

```dart
@TypedGoRoute<ParentRoute>(
  path: '/parent',
  routes: [
    TypedGoRoute<ChildRoute>(path: ':id'),
  ],
)
@immutable
class ParentRoute extends GoRouteData with _$ParentRoute {
  const ParentRoute();
  static const path = '/parent';
  static const routeName = 'parent';
  @override
  Widget build(BuildContext context, GoRouterState state) => const ParentPage();
}

@immutable
class ChildRoute extends GoRouteData with _$ChildRoute {
  const ChildRoute({required this.id});
  static const path = ':id';
  static const routeName = 'child';
  final int id;
  @override
  Widget build(BuildContext context, GoRouterState state) => ChildPage(id: id);
}
```

## Package Versions

| Package | Constraint | Notes |
|---|---|---|
| `go_router` | `^16.0.0` | 16+ required for go_router_builder 3.x mixin pattern |
| `go_router_builder` | `">=3.0.0 <3.2.0"` | 3.2+ requires `build ^3.x`; the current generator set (freezed 3.1, riverpod_generator 2.x, envied_generator 1.1) is on `build ^2` |

Upgrade `go_router_builder` past 3.1 only together with the rest of the generator set, once all of them support `build ^3`.

## Common Mistakes

- Forgetting `with _$ClassName` on the class — build_runner will error "Missing mixin clause"
- Using `context.go('/string')` — always use `const SomeRoute().go(context)`
- Missing `routeName` — Firebase Analytics will not track the screen by name
- Calling `push(context)` without `<void>` in `VoidCallback` context — use `push<void>(context)` to satisfy the `inference_failure_on_function_invocation` lint
- Adding `static const path` to the annotation instead of the class — keep it on the class for tests and `initialLocation` references
