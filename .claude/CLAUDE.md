# flai-starter

Flutter enterprise starter — Clean Architecture, Riverpod, GoRouter.

## Project Purpose

This repository is a reusable Flutter starter for future apps. Preserve it as a
small but complete example of Clean Architecture, Riverpod codegen, typed
navigation, API integration, logging, observability, localization, responsive
UI, and test patterns.

The built-in example feature is `users`, backed by `reqres.in`. Treat it as a
reference implementation for new features, not as one-off demo code.

## Stack

Use the existing stack unless there is a clear project-level reason to change
it:

- State + DI: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- Routing: `go_router` with manual typed route classes/extensions
- Network: `dio`, `retrofit`, `connectivity_plus`
- Models: `freezed`, `json_serializable`
- Errors: `fpdart` `Either<Failure, T>` in repository/usecase boundaries
- Env: `envied`
- Logging: `talker`, `talker_dio_logger`, `talker_flutter`,
  `talker_riverpod_logger`
- Observability: Firebase Core, Crashlytics, Analytics
- UI utilities: `gap`, `cached_network_image`, `skeletonizer`,
  `flutter_screenutil`

## Architecture

Follow Clean Architecture with this dependency rule:
`presentation -> domain <- data`.

`domain/` is pure Dart. It must not import Flutter, data models, datasources, UI
types, or infrastructure services.

Preferred folder shape:

```text
lib/
├── core/
│   ├── env/
│   ├── error/
│   ├── firebase/
│   ├── logging/
│   ├── network/
│   ├── router/
│   ├── storage/
│   └── theme/
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           ├── providers/
│           └── widgets/
├── shared/widgets/
└── l10n/
```

Import rules:

- `domain/` may depend on Dart packages and `fpdart`, but not Flutter/data/core
  infrastructure unless it is a pure type explicitly designed for domain.
- `data/` may import `domain/` to map models into entities.
- `presentation/` may import `domain/`, shared widgets, theme, and router.
- `presentation/` must not import `data/models/`.
- Provider wiring may expose data implementations through Riverpod providers,
  but UI should depend on notifier/usecase-facing providers.

## Navigation

Always use **TypedGoRouter** (`GoRouteData` subclasses) for all navigation.

```dart
// correct
UsersRoute().go(context);
UserDetailRoute(id: user.id).go(context);

// never do this
context.go('/users');
context.go('/users/${user.id}');
```

Routes are defined in `lib/core/router/app_router.dart`.
Add new routes as `GoRouteData` subclasses with `.go()`/`.push()` extensions.
Give every `GoRoute` a stable `name`; Firebase Analytics uses route observers
and should report meaningful screen names.

Current example routes:

- `UsersRoute`: `/users`
- `UserDetailRoute`: `/users/:id`

Do not navigate with raw path strings from widgets.

## Riverpod

Use Riverpod codegen for app providers and notifiers:

- `@Riverpod(keepAlive: true)` for singleton infrastructure such as Talker,
  Dio, repositories, and storage wrappers.
- `@riverpod` `AsyncNotifier` for feature presentation state that fetches data.
- Use `ref.watch` when UI or provider output must react to changes.
- Use `ref.read` for one-shot commands, usecase calls, refresh, and retry.

Current users dependency chain:

```text
talkerProvider
    ↓
dioClientProvider
    ↓
remoteUserDataSourceProvider
    ↓
userRepositoryProvider
    ↓
getUsersUseCaseProvider
    ↓
usersNotifierProvider
```

When tests override `userRepositoryProvider`, upstream datasource/Dio/network
providers should not need to run.

## Errors

Use `AppException` for infrastructure/data failures and map them to `Failure`
before crossing into domain-facing results.

Repository methods should return `Future<Either<Failure, T>>` when failures are
expected. Presentation notifiers may convert `Failure` into thrown state so
`AsyncValue` can render loading/error/data consistently.

Keep `Failure` variants small and readable:

- `Failure.network(message: ...)`
- `Failure.server(message: ..., statusCode: ...)`
- `Failure.unknown(message: ...)`

Use `readableMessage` for user-facing error text.

## Network

`dioClientProvider` is the shared Dio setup. Keep interceptor order intentional:

1. API key/header interceptor injects `Env.apiKey` as `x-api-key`.
2. Connectivity/error handling maps offline, timeout, server, and unknown
   failures into app exceptions.
3. `TalkerDioLogger` logs request/response/error details.

Retrofit datasources belong in `data/datasources/`. Keep API models in
`data/models/`, then map to domain entities before returning repository data.

## Responsive UI (ScreenUtil)

Design baseline: **375×812** (iPhone 13 mini). All sizes must scale with
ScreenUtil.

| Use case | Suffix | Example |
|---|---|---|
| Spacing / radius | `.r` | `16.r`, `BorderRadius.circular(12.r)` |
| Font size | `.sp` | `14.sp` |
| Fixed width / image size | `.w` | `48.w` |
| Fixed height | `.h` | `14.h` |

`AppSpacing` and `AppTextStyles` already apply `.r`/`.sp` — use them as-is.
Never use raw `double` literals for sizes in widgets — always apply the
appropriate suffix.
Never use `const` on `EdgeInsets`, `Gap`, or `SizedBox` that use `AppSpacing`
(getters are runtime values).

## Loading Skeletons

Use `skeletonizer` for loading placeholders. Prefer `Skeletonizer` /
`Skeletonizer.zone` with `Bone` widgets or skeleton annotations.
Do not add or use the `shimmer` package for new loading states.
Name placeholder widgets with a `Skeleton` suffix, not `Shimmer`.

For list item loading states, prefer a skeleton widget that mirrors the real
card shape. Current example: `UserCardSkeleton`.

## Theme And Shared UI

Use existing theme helpers:

- `AppColors` for all reusable colors.
- `AppTextStyles` for text styles.
- `AppSpacing` for spacing values.
- `Gap(AppSpacing.*)` for simple spacing.

Use shared widgets (`AppButton`, `AppTextField`, `AsyncValueWidget`) when they
fit before creating feature-local equivalents.

## Generated Files

`*.g.dart` and `*.freezed.dart` are committed to git.
`lib/core/env/env.g.dart` is excluded (contains obfuscated secrets).

Run build runner after changing any file using:

- `@riverpod` / `@Riverpod`
- `@freezed`
- `@JsonSerializable`
- `@RestApi`
- `@Envied`

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Env Variables

Defined in `.env` (git-ignored). Access via `Env.baseUrl`, `Env.apiKey`.
After changing `.env`, run `dart run build_runner build --delete-conflicting-outputs`.

## Firebase

Firebase is scaffolded but project-specific config files are intentionally not
committed in this starter. Run `flutterfire configure` in consuming projects to
replace the placeholder `lib/firebase_options.dart` and generate
`android/app/google-services.json` plus Apple `GoogleService-Info.plist` files.

Crashlytics must stay connected to Talker through `CrashlyticsTalkerObserver`
and global error handlers in `bootstrap.dart`. Analytics route tracking belongs
in `app_router.dart` through the GoRouter `observers` list.

## Talker

There is one primary Talker instance created in `bootstrap.dart` and injected
through `talkerProvider.overrideWithValue(talker)`. Do not create unrelated
Talker instances for runtime app code.

Talker integrations:

- `TalkerDioLogger` in Dio.
- `TalkerRiverpodObserver` in `ProviderScope`, guarded by `!kReleaseMode`.
- `TalkerRouteObserver` in GoRouter observers.
- `CrashlyticsTalkerObserver` forwards Talker breadcrumbs/non-fatal errors to
  Crashlytics when Firebase is configured and the platform supports it.

## Users Example Feature

Use `features/users` as the reference implementation for new features:

- Domain entity: immutable Freezed entity with computed convenience getters
  where useful.
- Domain repository: abstract interface returning `Either<Failure, T>`.
- Usecase: small class that delegates to the repository.
- Data model: Freezed/JSON model matching API shape.
- Mapper: model-to-entity extension in the data layer.
- Datasource: Retrofit API interface.
- Repository implementation: catches `AppException`, maps to `Failure`, and
  returns entities only.
- Presentation notifier: Riverpod `AsyncNotifier`.
- Page: `ConsumerWidget` rendering loading/error/data.
- Widget: small feature-local card/skeleton components.

Do not reuse the old `UserCardShimmer` naming or `shimmer` dependency from the
archived migration notes; the current standard is `skeletonizer`.

## Testing

Test each layer at the boundary it owns:

- Usecase tests mock the domain repository.
- Repository tests mock the remote datasource.
- Notifier tests use `ProviderContainer` overrides.
- Widget/page tests use `test/helpers/pump_app.dart`; it wraps
  `ProviderScope`, `ScreenUtilInit`, localization delegates, and `MaterialApp`.

Provider override pattern:

```dart
final container = ProviderContainer(
  overrides: [
    userRepositoryProvider.overrideWithValue(mockRepo),
  ],
);
```

Before finishing implementation work, run:

```sh
flutter analyze
flutter test
```

## Package Constraints

`envied` is pinned to `">=1.1.0 <1.2.0"` to match `envied_generator 1.1.1`.
Do not upgrade `envied` past `1.1.x` without also upgrading `envied_generator`.
`go_router_builder` is not used — typed route extensions are written manually in
`app_router.dart` due to `source_gen` version conflict with `freezed`.

## Archived Planning Docs

Historical `docs/superpowers` plans/specs have been folded into this file. This
`CLAUDE.md` is now the project guidance source of truth.
