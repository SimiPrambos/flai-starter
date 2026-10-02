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

One Firebase config per flavor (development, staging, production):

| Layer | File | Committed? |
|---|---|---|
| Dart | `lib/core/firebase/firebase_options_<flavor>.dart` | Yes — placeholder that throws until regenerated |
| Android | `android/app/src/<flavor>/google-services.json` | No (gitignored) |
| iOS | `ios/config/<flavor>/GoogleService-Info.plist` | No (gitignored) |

- Each `main_<flavor>.dart` passes `firebaseOptions: () => DefaultFirebaseOptions.currentPlatform` from its own options file to `bootstrap`. `initializeFirebase` resolves the closure inside its `try`, so a placeholder logs a Talker warning and the app runs without Firebase.
- Regenerate per flavor with `flutterfire configure --out=lib/core/firebase/firebase_options_<flavor>.dart --android-out=android/app/src/<flavor>/google-services.json --ios-out=ios/config/<flavor>/GoogleService-Info.plist` (full command in README "Firebase").
- Android applies the google-services and Crashlytics Gradle plugins only when a `google-services.json` exists; flavors without one warn instead of failing.
- iOS: the "Copy Firebase Config" Run Script picks the plist via `FLUTTER_APP_FLAVOR` (falling back to the Xcode configuration name) and warns + skips when it is missing. The FlutterFire Crashlytics phase uploads dSYMs only when the `flutterfire` CLI and a repo-root `firebase.json` exist.

## Common Mistakes

- Creating a second Talker instance → always use `talkerProvider`
- Adding `TalkerRiverpodObserver` without `!kReleaseMode` guard → noisy logs in production
- Navigating without a route `name` → Analytics reports raw paths, not screen names
- Reading `DefaultFirebaseOptions.currentPlatform` eagerly in `main` → the placeholder throws before `bootstrap`; always pass a closure
- Importing a flavor's options file anywhere except its own `main_<flavor>.dart`
