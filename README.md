# flai-starter

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Production-ready Flutter starter with Clean Architecture and AI tooling.

Everything wired up and working — architecture, routing, networking,
error handling, logging, and AI context guides — so your team hits the ground running.

---

## What's Inside

| Area | Technology |
|---|---|
| State + DI | `flutter_riverpod`, `riverpod_annotation` (codegen) |
| Navigation | `go_router` + `go_router_builder` (typed routes, session redirect, stateful bottom-tab shell) |
| Network | `dio`, `retrofit`, `connectivity_plus` |
| Models | `freezed`, `json_serializable` |
| Error handling | `fpdart` `Either<Failure, T>` |
| Env config | `envied` |
| Logging | `talker` + dio / riverpod / flutter adapters |
| Observability | Firebase Core, Crashlytics, Analytics |
| UI utilities | `gap`, `cached_network_image`, `skeletonizer`, `flutter_screenutil` |
| AI context guides | Specialist skills for Claude Code (architecture, routing, Riverpod, testing, and more) |
| Monorepo tooling | Melos |

---

## Getting Started

### Prerequisites

- Flutter ≥ 3.29
- Node.js (for GitNexus)
- `melos` (`dart pub global activate melos`)
- `very_good_cli` (`dart pub global activate very_good_cli`) — used by `melos test`
- `lcov` (`brew install lcov` on macOS, `apt-get install lcov` on Debian/Ubuntu) — used by `melos coverage`

> **PATH:** Dart global executables live in `~/.pub-cache/bin`. Add it to your shell config if not already:
>
> ```sh
> export PATH="$PATH":"$HOME/.pub-cache/bin"
> ```

### 1. Clone and bootstrap

```sh
git clone https://github.com/your-org/flai-starter.git my-app
cd my-app

flutter pub get

dart pub global activate melos
melos bootstrap
```

`melos bootstrap` runs `scripts/bootstrap.sh` as a post-hook, which:

- Activates git hooks: conventional commits, a format check on commit, and analyze + test on push
- Installs GitNexus (first run only) and indexes the codebase
- Installs RTK (via the `rtk-ai/rtk` install script)

On CI (`CI=true`) the hook skips all three.

### 2. Configure environment

```sh
cp .env.example .env
```

Edit `.env` and set:

```
BASE_URL=https://reqres.in/api
API_KEY=<your key from reqres.in>
```

### 3. Generate code

```sh
dart run build_runner build --delete-conflicting-outputs
```

Run this after cloning and after modifying any `@riverpod`, `@freezed`, `@JsonSerializable`, or `@RestApi` annotated file.

### 4. Run

```sh
flutter run --flavor development --target lib/main_development.dart
```

---

## Verification

One command runs the full check loop:

```sh
melos check
```

Runs: `build_runner → flutter analyze → flutter test`. Use it before pushing and after scaffolding a new feature.

| Command | What it does |
|---|---|
| `melos test` | Tests with coverage gate (≥85%) via `scripts/test.sh`. Same command CI runs. |
| `melos coverage` | `melos test` + HTML report in `coverage/` (opens automatically on macOS). |

---

## Scaffolding Features

Use the mason brick commands to scaffold any Clean Architecture layer — domain, data, or presentation — independently and incrementally.

See the `mason` skill (`.claude/skills/mason/SKILL.md`) for the full command reference, type options, typical flows, and common mistakes.

---

## Architecture

Clean Architecture with a strict dependency rule: `presentation → domain ← data`.
The `domain/` layer is pure Dart — no Flutter, no infrastructure imports.

```
lib/
├── app/
│   └── view/         # App widget
├── core/
│   ├── auth/         # SessionStorage + SessionNotifier (signed-in flag)
│   ├── common/       # PaginatedMixin<T>, PaginatedResult<T>
│   ├── env/          # Envied — BASE_URL, API_KEY
│   ├── error/        # Failure (sealed) + AppException
│   ├── network/      # Dio client + interceptors
│   ├── router/       # GoRouter config, session redirect
│   ├── shell/        # Bottom-tab shell (AppShellPage, TabConfig)
│   ├── logging/      # Talker provider
│   ├── firebase/     # Crashlytics + Analytics bootstrap, per-flavor options
│   ├── storage/      # Local persistence
│   └── theme/        # AppTheme, AppColors, AppTextStyles, AppSpacing, AppDecorators
├── features/
│   └── <feature>/
│       ├── data/         # Retrofit datasource, Freezed models, repo impl
│       ├── domain/       # Entity, repository interface, use case
│       └── presentation/ # Notifier, page, widgets
├── gen/              # flutter_gen typed assets (generated, committed)
├── l10n/             # Localisation (English + Bahasa Indonesia)
└── shared/
    └── widgets/      # AppButton, AppTextField, AsyncValueWidget
```

`PaginatedMixin<T>` is a reusable mixin on `AutoDisposeAsyncNotifier<List<T>>` that handles page state, `loadMore()`, and `refresh()`. Extend it in any notifier that fetches paginated data — implement only `fetchPage(int page)`.

The `users` feature is the reference implementation — read it before building new features.

---

## Batteries Included

The starter ships with shared abstractions that eliminate repetitive boilerplate. New features generated by the mason brick use these automatically.

### Data layer

| Abstraction | Use |
|---|---|
| `RepositoryGuard` mixin | Apply to every repository — wraps `DioException → Failure` pipeline |
| `PaginatedResponse<T>` | Parse paginated API responses from `Map<String,dynamic>` |
| `SingleResponse<T>` | Parse single-item API responses from `Map<String,dynamic>` |

### Shared widgets (`lib/shared/widgets/`)

| Widget | Replaces |
|---|---|
| `AppAvatar` | Raw `CachedNetworkImage` with placeholder + error icon |
| `PaginatedListPage<T>` | Full list page scaffold (~100 lines → ~15 lines) |
| `AsyncDetailScaffold<T>` | Detail page scaffold (~35 lines → ~10 lines) |
| `ErrorRetryWidget` | Handcrafted error+retry UI in list pages |
| `AsyncValueWidget<T>` | Manual `AsyncValue.when` pattern |

### Mason

Atomic bricks per Clean Architecture layer, composable and additive. See the `mason` skill for the full reference.

---

## Firebase

Crashlytics and Analytics are pre-wired, with **one Firebase config per flavor**. Without config files the app still builds and runs:

- Dart: the placeholder `firebase_options_<flavor>.dart` throws, `initializeFirebase` catches it, and Talker logs a warning.
- Android: Gradle skips the google-services / Crashlytics plugins and prints a warning.
- iOS: the "Copy Firebase Config" build phase prints `warning: GoogleService-Info.plist not found …; skipping`.

| Flavor | Dart options | Android | iOS |
|---|---|---|---|
| development | `lib/core/firebase/firebase_options_development.dart` | `android/app/src/development/google-services.json` | `ios/config/development/GoogleService-Info.plist` |
| staging | `lib/core/firebase/firebase_options_staging.dart` | `android/app/src/staging/google-services.json` | `ios/config/staging/GoogleService-Info.plist` |
| production | `lib/core/firebase/firebase_options_production.dart` | `android/app/src/production/google-services.json` | `ios/config/production/GoogleService-Info.plist` |

To enable Firebase, first install the FlutterFire CLI:

```sh
dart pub global activate flutterfire_cli
```

Then run `flutterfire configure` once per flavor. Use the flavor's application id and bundle id: the base id plus `.dev` for development, `.stg` for staging, and no suffix for production.

```sh
flutterfire configure \
  --project=<firebase-project-id> \
  --platforms=android,ios \
  --out=lib/core/firebase/firebase_options_development.dart \
  --android-package-name=<your.application.id>.dev \
  --android-out=android/app/src/development/google-services.json \
  --ios-bundle-id=<your.bundle.id>.dev \
  --ios-out=ios/config/development/GoogleService-Info.plist
```

Repeat with `staging` / `.stg` and `production` / no suffix.

Notes:
- `main_<flavor>.dart` already imports its own options file; no Dart change is needed after generation.
- **iOS prompts.** If the CLI asks how to wire the iOS plist, choose the `Debug-<flavor>` build configuration. The project's "Copy Firebase Config" phase already copies `ios/config/<flavor>/GoogleService-Info.plist` into the app. An extra `flutterfire bundle-service-file` phase added by the CLI is redundant and can be removed.
- **Crashlytics dSYM upload.** It runs only when the `flutterfire` CLI is on `PATH` and `firebase.json` (written by `flutterfire configure`) exists at the repo root.
- **Committing configs.** The JSON and plist files are gitignored by default. Consuming apps that want to commit them may delete the `android/app/src/*/google-services.json` and `ios/config/*/GoogleService-Info.plist` lines from `.gitignore`.

After configuration, Crashlytics receives uncaught Flutter and platform errors, and GoRouter screen transitions are forwarded to Analytics automatically.

---

## Release & distribution

The starter ships a session-gated app: a cold start shows a splash loader, then redirects to `/login`. The mock sign-in lands on the Users tab, and Settings → Sign out returns to `/login`. The gate lives in `lib/core/auth/` (`SessionNotifier`) and `lib/core/router/` (`app_router.dart`, `redirect_resolver.dart`); the tab shell is in `lib/core/shell/` (`AppShellPage`, `TabConfig`). Swap in a real backend as described in the `LoginPage` doc comment and the `auth-navigation` skill.

### Codemagic (CI)

`codemagic.yaml` defines two manually triggered workflows for the **development** flavor:

| Workflow | Output | Destination |
|---|---|---|
| `android-dev` | Signed release APK | Firebase App Distribution |
| `ios-dev` | Signed IPA | TestFlight |

Both run the coverage-gated suite (`scripts/test.sh`) before building. Follow the **setup checklist** at the top of `codemagic.yaml`. It covers:
- every `<PLACEHOLDER>` to replace (`<IOS_DEV_BUNDLE_ID>`, `<ASC_INTEGRATION_NAME>`, `<ANDROID_KEYSTORE_REFERENCE>`, `<FIREBASE_ANDROID_APP_ID_DEV>`, `<FIREBASE_TESTER_GROUP>`, `<TESTFLIGHT_BETA_GROUP>`)
- the `dev_env` variable group (`BASE_URL`, `API_KEY`, `FIREBASE_SERVICE_ACCOUNT`)

### Local distribution

The same flow runs from a laptop:

```sh
cp scripts/.distribute.env.example scripts/.distribute.env   # gitignored; fill it in
sh scripts/distribute_android_dev.sh   # needs FIREBASE_APP_ID, FIREBASE_SERVICE_ACCOUNT_PATH, TESTER_GROUPS
sh scripts/distribute_ios_dev.sh       # needs BUNDLE_ID, ASC_KEY_ID, ASC_ISSUER_ID, ASC_P8_PATH
```

The variables can also be exported in the shell (values in `scripts/.distribute.env` win). Each script:
- lists any missing variable and exits 1 before building
- checks its tools (Firebase CLI / codemagic-cli-tools)
- runs `build_runner`
- builds the `development` flavor
- uploads the build

Optional iOS variables: `BETA_GROUP` (TestFlight group) and `CERT_KEY_PATH` (defaults to `~/ios_distribution_private_key`). Both scripts need a `.env` at the repo root.

Android release signing reads `ANDROID_KEYSTORE_PATH`, `ANDROID_KEYSTORE_ALIAS`, `ANDROID_KEYSTORE_PASSWORD` and `ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD`.

---

## AI-Assisted Development

flai-starter ships with pre-configured MCP servers and tooling so AI
assistants work accurately in this codebase from the first message.

### MCP Servers (`.mcp.json`)

| Server | Purpose |
|---|---|
| GitNexus | Code intelligence — impact analysis, refactoring, debugging |
| Context7 | Live library docs — always up-to-date API references |
| Dart | Live Dart tooling — analyzer, pub.dev search, symbol lookup |

### Specialist Skills

Context guides in `.claude/skills/` encode architecture rules, patterns,
and common mistakes for each area (routing, Riverpod, error handling,
testing, etc.).

See [`.claude/CLAUDE.md`](.claude/CLAUDE.md) for the full skills index.

### RTK

Token-optimized CLI wrapper. Prefix any command with `rtk` for 60–90%
token reduction on build, test, and git operations.

All tooling is installed automatically by `melos bootstrap`.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the pre-push checklist, CI/CD
steps, conventional commit format, and testing strategy.

---

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
