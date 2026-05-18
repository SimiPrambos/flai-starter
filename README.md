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
| Navigation | `go_router` (typed routes, manual extensions) |
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
- Node.js (for GitNexus and RTK)
- `melos` (`dart pub global activate melos`)

### 1. Clone and bootstrap

```sh
git clone https://github.com/your-org/flai-starter.git my-app
cd my-app

dart pub global activate melos
melos bootstrap
```

`melos bootstrap` runs `scripts/bootstrap.sh` as a post-hook, which:

- Activates git hooks (conventional commits)
- Installs GitNexus (first run only) and indexes the codebase
- Installs RTK

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
flutter run
```

---

## Architecture

Clean Architecture with a strict dependency rule: `presentation → domain ← data`.
The `domain/` layer is pure Dart — no Flutter, no infrastructure imports.

```
lib/
├── app/
│   └── view/         # App widget
├── core/
│   ├── env/          # Envied — BASE_URL, API_KEY
│   ├── error/        # Failure (sealed) + AppException
│   ├── network/      # Dio client + interceptors
│   ├── router/       # GoRouter config
│   ├── logging/      # Talker provider
│   ├── firebase/     # Crashlytics + Analytics bootstrap
│   ├── storage/      # Local persistence
│   └── theme/        # AppColors, AppTextStyles, AppSpacing
├── features/
│   └── <feature>/
│       ├── data/         # Retrofit datasource, Freezed models, repo impl
│       ├── domain/       # Entity, repository interface, use case
│       └── presentation/ # Notifier, page, widgets
├── l10n/             # Localisation (English + Bahasa Indonesia)
└── shared/
    └── widgets/      # AppButton, AppTextField, AsyncValueWidget
```

The `users` feature is the reference implementation — read it before building new features.

---

## Firebase

Crashlytics and Analytics are pre-wired. Without platform config files the app
runs normally — Firebase is disabled gracefully with a log message.

To enable Firebase in a project built from this starter:

```sh
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites the placeholder `lib/firebase_options.dart` and generates
native config files for all supported platforms. After configuration,
Crashlytics receives uncaught Flutter and platform errors, and GoRouter
screen transitions are forwarded to Analytics automatically.

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
