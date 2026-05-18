---
name: flai-firebase-talker
description: Use when configuring Firebase, Crashlytics, Analytics, Talker, or logging observers in this Flutter project. Covers the single Talker instance rule, observer wiring, and Firebase setup instructions.
---

# Firebase & Talker

## Talker: Single Instance Rule

One Talker instance — created in `bootstrap.dart`, injected via `talkerProvider.overrideWithValue(talker)`.

**Do NOT** create additional Talker instances for runtime app code.

## Talker Integrations

| Integration | Location | Condition |
|---|---|---|
| `TalkerDioLogger` | Dio interceptors | always |
| `TalkerRiverpodObserver` | `ProviderScope` observers | `!kReleaseMode` only |
| `TalkerRouteObserver` | GoRouter `observers` | always |
| `CrashlyticsTalkerObserver` | `bootstrap.dart` | always (no-ops when Firebase unavailable) |

## Crashlytics

Connected to Talker through `CrashlyticsTalkerObserver` and global error handlers in `bootstrap.dart`.

Forwards breadcrumbs and non-fatal errors to Crashlytics when Firebase is configured and the platform supports it.

## Analytics

Route tracking belongs in `app_router.dart` via GoRouter `observers`. Every `GoRoute` must have a stable `name` so Analytics reports meaningful screen names.

## Firebase Config

Project-specific config files are **not committed** in this starter:

- Run `flutterfire configure` in consuming projects
- Generates `lib/firebase_options.dart`, `android/app/google-services.json`, Apple `GoogleService-Info.plist`
- Placeholder `lib/firebase_options.dart` exists for compilation only

## Common Mistakes

- Creating a second Talker instance → always use `talkerProvider`
- Adding `TalkerRiverpodObserver` without `!kReleaseMode` guard → noisy logs in production
- Navigating without a route `name` → Analytics reports raw paths, not screen names
