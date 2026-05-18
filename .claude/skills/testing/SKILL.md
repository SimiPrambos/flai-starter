---
name: flai-testing
description: Use when writing tests for any layer — usecases, repositories, notifiers, widgets, or pages — in this Flutter project. Covers test boundaries, mock patterns, ProviderContainer overrides, and widget test helpers.
---

# Testing

## Test Boundaries

| Layer | What to mock | Tool |
|---|---|---|
| Usecase | Domain repository | `mockito` / manual mock |
| Repository | Remote datasource | `mockito` / manual mock |
| Notifier | Repository (via provider override) | `ProviderContainer` |
| Widget/Page | Providers (via override) | `pump_app.dart` |

## Provider Override Pattern

```dart
final container = ProviderContainer(
  overrides: [
    userRepositoryProvider.overrideWithValue(mockRepo),
  ],
);
```

Overriding `userRepositoryProvider` means upstream datasource/Dio/network providers do not run.

## Widget Test Helper

Use `test/helpers/pump_app.dart` for all widget and page tests. It wraps:
- `ProviderScope`
- `ScreenUtilInit`
- Localization delegates
- `MaterialApp`

```dart
await tester.pumpApp(
  UsersPage(),
  overrides: [usersNotifierProvider.overrideWith(...)],
);
```

## Before Finishing Implementation

Always run:

```sh
flutter analyze
flutter test
```

Both must pass before marking work complete.

## Common Mistakes

- Testing UI with a real network — always override the repository
- Forgetting `ScreenUtilInit` in widget tests → use `pump_app.dart`
- Mocking at the wrong layer (mocking Dio instead of the datasource) → mock the closest boundary
- Skipping `flutter analyze` → static errors slip through
