---
name: flai-riverpod
description: Use when creating providers, notifiers, or wiring dependencies in this Flutter project. Covers Riverpod codegen conventions, keepAlive rules, ref.watch vs ref.read, and the users dependency chain as reference.
---

# Riverpod

## Codegen Rules

| Use case | Annotation |
|---|---|
| Singleton infrastructure (Talker, Dio, repos, storage) | `@Riverpod(keepAlive: true)` |
| Feature state that fetches data | `@riverpod` `AsyncNotifier` |

- `ref.watch` — when UI or provider output must react to changes
- `ref.read` — for one-shot commands, usecase calls, refresh, and retry

## Dependency Chain (users as reference)

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

When tests override `userRepositoryProvider`, upstream datasource/Dio/network providers must not need to run.

## After Changing Providers

Run build runner to regenerate `.g.dart` files:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Common Mistakes

- Using `ref.watch` inside a one-shot callback → use `ref.read`
- Forgetting `keepAlive: true` on infrastructure singletons → they get disposed and re-created
- Creating a raw `Provider` instead of using codegen → prefer `@riverpod` always
