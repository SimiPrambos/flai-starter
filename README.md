# Template VGV App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Flutter enterprise template — [Very Good CLI][very_good_cli_link] + **Riverpod + Clean Architecture**.

Showcases a **users list** from [reqres.in](https://reqres.in) as an example feature covering all architecture layers: data, domain, and presentation.

---

## Tech Stack

| Category | Package |
|---|---|
| State + DI | `flutter_riverpod`, `riverpod_annotation` (codegen) |
| Navigation | `go_router` |
| Network | `dio`, `retrofit` |
| Model | `freezed_annotation`, `json_annotation` |
| Error handling | `fpdart` (Either) |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Env config | `envied` |
| Logging | `talker`, `talker_dio_logger`, `talker_flutter` |
| Observability | `firebase_core`, `firebase_crashlytics`, `firebase_analytics` |
| Connectivity | `connectivity_plus` |
| UI utilities | `gap`, `cached_network_image`, `skeletonizer` |

---

## Getting Started 🚀

### Environment Setup

Copy `.env.example` to `.env` and fill in the values:

```sh
cp .env.example .env
```

```
BASE_URL=https://reqres.in/api
API_KEY=https://app.reqres.in/playground?path=/api/users&method=GET
```

## Code Generation ⚙️

This project uses [build_runner](https://pub.dev/packages/build_runner) to generate code for Riverpod providers, Retrofit API clients, and Freezed models.

Run this after cloning or whenever you add/modify annotated files:

```sh
dart run build_runner build --delete-conflicting-outputs
```

To watch for changes during development:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

### Generated Files

Generated files (`*.g.dart`, `*.freezed.dart`) are **gitignored** — do not commit them. Every developer runs `build_runner` locally.

### Hiding Generated Files in VS Code

The `.vscode/settings.json` already hides generated files from the Explorer:

```json
{
  "files.exclude": {
    "**/*.g.dart": true,
    "**/*.freezed.dart": true
  }
}
```

If they still appear, fully quit and reopen VS Code (`Cmd+Q`), and make sure you open the `template_vgv__app/` folder directly — not a parent folder.

---

### Flavors

This project contains 3 flavors:

- development
- staging
- production

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Template VGV App works on iOS, Android, Web, and Windows._

---

## API

This project uses [reqres.in](https://reqres.in) as the example API.

| | |
|---|---|
| Base URL | `https://reqres.in/api` |
| Auth | `x-api-key` header |
| Endpoint | `GET /users?page={page}` |

Response shape:

```json
{
  "page": 1,
  "per_page": 6,
  "total": 12,
  "total_pages": 2,
  "data": [
    {
      "id": 7,
      "email": "michael.lawson@reqres.in",
      "first_name": "Michael",
      "last_name": "Lawson",
      "avatar": "https://reqres.in/img/faces/7-image.jpg"
    }
  ]
}
```

The API key is loaded from `.env` via `envied` and injected into every request as an `x-api-key` header by `ApiKeyInterceptor`.

---

## Firebase

Firebase Crashlytics and Analytics are scaffolded for consuming projects.
Without Firebase config files, the app logs that Firebase is disabled and keeps
running normally.

To enable Firebase in a project created from this starter:

```sh
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites the placeholder `lib/firebase_options.dart` and generates
native Firebase files for supported platforms. After configuration, Crashlytics
receives uncaught Flutter/platform errors and Talker breadcrumbs. GoRouter
screen transitions are sent to Firebase Analytics via the router observers.

---

## Architecture 🏗️

Clean Architecture with dependency rule: `presentation → domain ← data`.  
The domain layer must stay pure Dart + `fpdart` — no Flutter or data layer imports allowed.

```
lib/
├── core/
│   ├── error/          # Failure (freezed sealed) + AppException
│   ├── network/        # Dio client, interceptors, connectivity service
│   ├── router/         # GoRouter config
│   ├── storage/        # SecureStorage + SharedPreferences wrappers
│   ├── logging/        # Talker provider
│   ├── firebase/       # Firebase bootstrap, Crashlytics, Analytics providers
│   ├── env/            # Envied — BASE_URL, API_KEY
│   └── theme/          # AppColors, AppTextStyles, AppSpacing, AppAssets
├── shared/
│   └── widgets/        # AppButton, AppTextField, AsyncValueWidget
└── features/
    └── users/
        ├── data/         # Retrofit datasource, freezed models, repository impl
        ├── domain/       # UserEntity, UserRepository interface, GetUsersUseCase
        └── presentation/ # UsersNotifier, UsersPage, UserCard, UserCardSkeleton
```

---

## Before You Push 🚦

Run these checks locally **in order** before pushing — they mirror exactly what CI/CD
runs on GitHub so you catch failures before they hit the pipeline.

### 1. Code Generation

Regenerate files whenever you add or modify annotated classes:

```sh
dart run build_runner build --delete-conflicting-outputs
```

> Skip if you have not touched any `@riverpod`, `@freezed`, `@JsonSerializable`,
> or `@RestApi` annotated code.

### 2. Format (line length 80)

VGV enforces 80-character line width. CI uses `--set-exit-if-changed` and will
fail if any file is not formatted correctly.

Auto-fix first, then verify:

```sh
# Fix
dart format --line-length 80 .

# Verify (mirrors CI — exits non-zero if anything changed)
dart format --line-length 80 --set-exit-if-changed .
```

### 3. Static Analysis

```sh
flutter analyze --fatal-infos
```

Expected output: `No issues found!` — CI treats any info-level diagnostic as a
failure.

### 4. Tests + Coverage

```sh
very_good test --coverage --test-randomize-ordering-seed random
```

Or without the `very_good` CLI:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

VGV requires **100 % coverage**. To inspect locally, install `lcov` first
(one-time):

```sh
brew install lcov
```

Then generate and open the report:

```sh
genhtml coverage/lcov.info -o coverage/ && open coverage/index.html
```

Any uncovered line will fail the CI coverage gate — write the test before
pushing.

### 5. Spell Check (markdown files)

CI runs `cspell` on every `*.md` file. If you add a new technical term, add it
to `.github/cspell.json` under `"words"`:

```json
"words": ["yourNewTerm"]
```

### 6. Semantic PR Title

The `semantic-pull-request` job rejects PR titles that do not follow
[Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | When |
|---|---|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `chore:` | Maintenance — deps, config, tooling |
| `docs:` | Documentation only |
| `refactor:` | Code change, no feature or fix |
| `test:` | Adding or fixing tests |
| `ci:` | CI/CD pipeline changes |

Example: `feat: add user profile page`

> Push titles follow the same convention (commits on `main` are squash-merged
> from PRs).

### Quick One-Liner

Run all checks in sequence — stops on the first failure:

```sh
dart run build_runner build --delete-conflicting-outputs && \
  dart format --line-length 80 --set-exit-if-changed . && \
  flutter analyze --fatal-infos && \
  flutter test --coverage --test-randomize-ordering-seed random
```

---

## Running Tests 🧪

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report:

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

### Testing Strategy

| Layer | Approach |
|---|---|
| UseCase | Pure unit test, mock `UserRepository` with mocktail |
| Repository | Mock `RemoteUserDataSource` |
| Notifier | `ProviderContainer` with `overrides` |
| Widget | `pumpApp()` helper — wraps `ProviderScope + MaterialApp` |

---

## Working with Translations 🌐

This project supports **English** and **Bahasa Indonesia**.

### Adding Strings

Open `lib/l10n/arb/app_en.arb` and add a new key/value pair:

```arb
{
    "@@locale": "en",
    "usersPageTitle": "Users",
    "@usersPageTitle": {
        "description": "Title shown in the AppBar of the Users Page"
    }
}
```

Add the corresponding translation in `app_id.arb`:

```arb
{
    "@@locale": "id",
    "usersPageTitle": "Pengguna"
}
```

### File Structure

```
lib/l10n/arb/
├── app_en.arb
└── app_id.arb
```

### Adding a New Locale

Update the `CFBundleLocalizations` array in `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>id</string>
</array>
```

### Generating Translations

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

---

[coverage_badge]: coverage_badge.svg
[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
