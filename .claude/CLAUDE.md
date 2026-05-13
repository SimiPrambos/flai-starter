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

Routes are defined in `lib/core/router/app_router.dart`.
Add new routes as `GoRouteData` subclasses with `.go()`/`.push()` extensions.

## Responsive UI (ScreenUtil)

Design baseline: **375×812** (iPhone 13 mini). All sizes must scale with ScreenUtil.

| Use case | Suffix | Example |
|---|---|---|
| Spacing / radius | `.r` | `16.r`, `BorderRadius.circular(12.r)` |
| Font size | `.sp` | `14.sp` |
| Fixed width / image size | `.w` | `48.w` |
| Fixed height | `.h` | `14.h` |

`AppSpacing` and `AppTextStyles` already apply `.r`/`.sp` — use them as-is.
Never use raw `double` literals for sizes in widgets — always apply the appropriate suffix.
Never use `const` on `EdgeInsets`, `Gap`, or `SizedBox` that use `AppSpacing` (getters are runtime values).

## Generated Files

`*.g.dart` and `*.freezed.dart` are committed to git.
`lib/core/env/env.g.dart` is excluded (contains obfuscated secrets).

## Env Variables

Defined in `.env` (git-ignored). Access via `Env.baseUrl`, `Env.apiKey`.
After changing `.env`, run `dart run build_runner build --delete-conflicting-outputs`.

## Package Constraints

`envied` is pinned to `">=1.1.0 <1.2.0"` to match `envied_generator 1.1.1`.
Do not upgrade `envied` past `1.1.x` without also upgrading `envied_generator`.
`go_router_builder` is not used — typed route extensions are written manually in `app_router.dart`
due to `source_gen` version conflict with `freezed`.
