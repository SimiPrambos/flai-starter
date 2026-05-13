# flai-starter

Flutter enterprise starter — Clean Architecture, Riverpod, GoRouter.

## Navigation

Always use **TypedGoRouter** (`GoRouteData` subclasses) for all navigation.

```dart
// ✅ correct
UsersRoute().go(context);
UserDetailRoute(id: user.id).go(context);

// ❌ never do this
context.go('/users');
context.go('/users/${user.id}');
```

All routes are defined in `lib/core/router/app_router.dart` via `@TypedGoRoute` annotations.
Run `dart run build_runner build` after adding new routes.

## Generated Files

`*.g.dart` and `*.freezed.dart` are committed to git.
`lib/core/env/env.g.dart` is excluded (contains obfuscated secrets).

## Env Variables

Defined in `.env` (git-ignored). Access via `Env.baseUrl`, `Env.apiKey` from `lib/core/env/env.dart`.
After changing `.env`, run `dart run build_runner build --delete-conflicting-outputs`.

## Package Versions

`envied` is pinned to `">=1.1.0 <1.2.0"` to match `envied_generator 1.1.1`.
Do not upgrade `envied` past `1.1.x` unless `envied_generator` is also upgraded.
