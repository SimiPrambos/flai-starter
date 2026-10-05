---
name: flai-auth-navigation
description: Use when touching sign-in/sign-out, the router redirect, the bottom-tab shell, or adding a tab in this Flutter project. Covers the session gate, resolveRedirect, refreshListenable wiring, AppShellPage + TabConfig, and how to extend the gate to roles.
---

# Auth Navigation — Session Gate & Tab Shell

## Core Rule

Pages **never** navigate after sign-in or sign-out. They change the session; the router's `redirect` moves the user.

```dart
// CORRECT
ref.read(sessionNotifierProvider.notifier).signIn();

// NEVER
await ref.read(sessionNotifierProvider.notifier).signIn();
const UsersRoute().go(context);
```

---

## File Locations

| File | Purpose |
|---|---|
| `lib/core/auth/session_storage.dart` | `SessionStorage` interface, `SecureSessionStorage` (key `session_active`), `InMemorySessionStorage`, `sessionStorageProvider` |
| `lib/core/auth/session_notifier.dart` | `SessionNotifier` (`AsyncNotifier<bool>`, keep-alive): `signIn()`, `signOut()` |
| `lib/core/router/redirect_resolver.dart` | Pure `resolveRedirect(...)` |
| `lib/core/router/app_router.dart` | Splash/Login routes, `AppShellRoute`, redirect, `refreshListenable` |
| `lib/core/shell/tab_config.dart` | `TabConfig` + `kAppTabs` |
| `lib/core/shell/app_shell_page.dart` | Generic bottom-tab scaffold |
| `lib/features/auth/presentation/pages/` | `SplashPage` (loader only), `LoginPage` (mock) |
| `lib/features/settings/presentation/pages/settings_page.dart` | Sign-out |

---

## Session Gate

```text
SecureStorageService ── SecureSessionStorage ── sessionStorageProvider
                                                     │
                                         sessionNotifierProvider (AsyncValue<bool>)
                                                     │ ref.listen
                                          _SessionChangeNotifier ── refreshListenable
                                                     │
                                           GoRouter.redirect → resolveRedirect
```

- `build()` reads storage. While it is loading, `redirect` returns `null`, so `SplashPage` (at `/`, the `initialLocation`) stays visible.
- A storage error resolves to `AsyncError` → `valueOrNull ?? false` → treated as signed out.
- `signIn()` writes, then sets `AsyncData(true)`. `signOut()` clears, then sets `AsyncData(false)`.

## `resolveRedirect`

```dart
String? resolveRedirect({
  required bool isSignedIn,
  required String location,
  required String loginPath,
  required String splashPath,
  required String homePath,
});
```

| Signed in? | Location | Result |
|---|---|---|
| no | `loginPath` | `null` |
| no | anything else (splash, home, deep link) | `loginPath` |
| yes | `loginPath` or `splashPath` | `homePath` |
| yes | anything else | `null` |

Keep it pure: no `ref`, no `BuildContext`. Every rule change starts with a row in `test/core/router/redirect_resolver_test.dart`.

## `refreshListenable` Wiring

```dart
@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final sessionListenable = _SessionChangeNotifier(ref);
  ref.onDispose(sessionListenable.dispose);   // never leak the notifier

  return GoRouter(
    initialLocation: SplashRoute.path,
    refreshListenable: sessionListenable,
    redirect: (context, state) {
      final session = ref.read(sessionNotifierProvider); // read, not watch
      if (session.isLoading) return null;
      return resolveRedirect(
        isSignedIn: session.valueOrNull ?? false,
        location: state.uri.path,
        loginPath: LoginRoute.path,
        splashPath: SplashRoute.path,
        homePath: UsersRoute.path,
      );
    },
    routes: $appRoutes,
  );
}

class _SessionChangeNotifier extends ChangeNotifier {
  _SessionChangeNotifier(Ref ref) {
    ref.listen(sessionNotifierProvider, (_, _) => notifyListeners());
  }
}
```

**Never** `ref.watch(sessionNotifierProvider)` inside `appRouter`. That rebuilds the whole `GoRouter` and resets navigation state. Listen and refresh instead.

---

## Shell + `TabConfig`

```dart
@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<UsersBranch>(
      routes: [
        TypedGoRoute<UsersRoute>(
          path: '/users',
          routes: [TypedGoRoute<UserDetailRoute>(path: ':id')],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
@immutable
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) =>
      AppShellPage(navigationShell: navigationShell, tabs: kAppTabs);
}
```

- Shell and branch data classes have **no** `with _$...` mixin; only `GoRouteData` subclasses do.
- `AppShellPage` is tab-agnostic. Tapping tab `i` calls `goBranch(i, initialLocation: i == currentIndex)`, so re-tapping the active tab resets that branch.
- Colors come from `AppColors.primary` (active), `AppColors.onSurfaceDim` (inactive) and `AppColors.infoSurface` (active pill). Icons are Material `Icons.*` only.
- `TabConfig.label` is `String Function(AppLocalizations)`, so `kAppTabs` stays `const` and still localizes.
- Routes nested in a branch (e.g. `UserDetailRoute`) render **inside** the tab, with the bar visible. Top-level routes (Splash, Login, anything Mason appends) render **without** the bar.

## Adding a Tab (Branch)

1. Write `docs/features/{name}/SPEC.md` + `CHANGELOG.md` (the `require-spec.sh` hook blocks code otherwise).
2. Create the page under `lib/features/{name}/presentation/pages/`.
3. Add `tab{Name}` to `app_en.arb` **and** `app_id.arb`, then run `flutter gen-l10n`.
4. In `app_router.dart`:
   - add `class {Name}Branch extends StatefulShellBranchData { const {Name}Branch(); }`
   - add a `GoRouteData` class with `static const path` and `routeName`
   - add `TypedStatefulShellBranch<{Name}Branch>(routes: [TypedGoRoute<{Name}Route>(path: '/{name}')])` to `AppShellRoute` at the position the tab should appear
5. Add a `TabConfig(icon: Icons.<name>_outlined, label: _{name}Label)` to `kAppTabs` at the **same index** as the branch.
6. Run `dart run build_runner build --delete-conflicting-outputs`.
7. Extend `test/core/router/app_router_test.dart` (tab shows page) and `test/core/shell/app_shell_page_test.dart` if the shell behavior changed.

Moving an existing top-level route into a tab means moving its `@TypedGoRoute` annotation into a branch's `routes:`. The class, path and call sites stay the same.

## Swapping the Mock Login for a Real Backend

See the doc comment on `LoginPage`. In short: `make-domain` + `make-data` for `auth`, a `LoginNotifier` calling `AuthRepository.login`, store the token via `SecureStorageService`, then call `signIn()` on success. The router needs no change.

---

## Testing

- Every test that builds `appRouterProvider` **must** override `sessionStorageProvider`. Otherwise `SecureSessionStorage` hits the platform channel.

```dart
ProviderScope(
  overrides: [
    talkerProvider.overrideWithValue(talker),
    userRepositoryProvider.overrideWithValue(mockRepo),
    sessionStorageProvider.overrideWithValue(
      InMemorySessionStorage(signedIn: true),
    ),
  ],
  child: Consumer(
    builder: (_, ref, _) => _appWithRouter(ref.watch(appRouterProvider)),
  ),
)
```

- Splash-only state: a `SessionStorage` whose `read()` returns `Completer<bool>().future`, then `pump()` (not `pumpAndSettle`, because the spinner never settles).
- Tap tabs by icon (`find.byIcon(Icons.settings_outlined)`). Tab labels often equal page titles.
- Widget tests of a page that calls `signIn()`/`signOut()` first `await container.read(sessionNotifierProvider.future)`, mirroring production where the router has already restored the session.

---

## Extending to Roles

The starter gates on one boolean. When an app needs several audiences with different tab sets (e.g. `admin` and `member`), extend the same pattern without touching `AppShellPage`:

1. **Enum with routing metadata**

   ```dart
   enum AppRole {
     admin(homePath: '/admin/home', pathPrefix: '/admin/'),
     member(homePath: '/member/home', pathPrefix: '/member/');

     const AppRole({required this.homePath, required this.pathPrefix});
     final String homePath;
     final String pathPrefix;
   }
   ```

2. **Storage + notifier:**
   - `SessionStorage` persists `role.name` instead of `"true"`, and `read()` maps it back with `AppRole.values.where((r) => r.name == value).firstOrNull`.
   - `SessionNotifier` becomes `AsyncNotifier<AppRole?>`, with `signIn(AppRole role)` and `signOut()`.
   - `null` means signed out.

3. **One shell per role:**
   - Each role gets its own `@TypedStatefulShellRoute<{Role}ShellRoute>` whose branch paths all start with `role.pathPrefix`.
   - Each role gets its own `const k{Role}Tabs`.
   - Every shell uses the same `AppShellPage(navigationShell: ..., tabs: k{Role}Tabs)`.

4. **Redirect by prefix:**

   ```dart
   String? resolveRedirect({required AppRole? role, required String location,
       required String loginPath, required String splashPath}) {
     if (role == null) return location == loginPath ? null : loginPath;
     if (location == loginPath || location == splashPath) return role.homePath;
     final inOtherShell = AppRole.values.any(
       (r) => r != role && location.startsWith(r.pathPrefix),
     );
     return inOtherShell ? role.homePath : null;
   }
   ```

   Paths outside every prefix (shared full-screen routes) stay reachable for all roles.

5. **Login:** the role comes from the auth response. Use a role picker only as a dev/mock affordance, never in production.

6. **Shared vs role pages:**
   - A page used by several roles lives in its own feature and is mounted in each shell's branch under that role's prefix.
   - Never branch on role inside a page or inside `AppShellPage`; create a role-specific page instead.

Adding a role then touches only: the enum, one new shell + branch classes, one `k{Role}Tabs`, and the redirect tests. Existing shells and widgets are untouched.

---

## Common Mistakes

- Navigating imperatively after `signIn()`/`signOut()` → double navigation and flicker. Let the redirect do it.
- `ref.watch(sessionNotifierProvider)` in `appRouter` → the router is recreated and the stack is lost.
- Forgetting `ref.onDispose(listenable.dispose)` → leaked `ChangeNotifier` in tests.
- `kAppTabs` order differs from branch order → tapping a tab opens the wrong branch.
- Hard-coded tab labels or `LucideIcons` → use l10n + Material `Icons.*`.
- Root-level `observers` (Talker, Firebase Analytics) do not see navigation inside branch navigators, so screens opened inside tabs are not tracked. Add per-branch `observers` if per-tab screen tracking is required.
- `melos make-presentation` appends a top-level `@TypedGoRoute` to `app_router.dart`, which renders outside the shell (no tab bar). To make a generated page a tab or a tab sub-route, move its annotation into a branch `routes:` by hand.
- Missing `sessionStorageProvider` override in router tests → `MissingPluginException` from secure storage.
