---
name: flai-generated-files
description: Use when deciding whether to run build_runner, checking which files are auto-generated, or managing env variables in this Flutter project. Covers when to regenerate, committed vs gitignored files, and package constraints.
---

# Generated Files

## Files Committed to Git

`*.g.dart` and `*.freezed.dart` are committed.

Exception: `lib/core/env/env.g.dart` is **gitignored** (contains obfuscated secrets).

## When to Run Build Runner

Run after changing any file that uses:

| Annotation | Package |
|---|---|
| `@riverpod` / `@Riverpod` | `riverpod_generator` |
| `@freezed` | `freezed` |
| `@JsonSerializable` | `json_serializable` |
| `@RestApi` | `retrofit_generator` |
| `@Envied` | `envied_generator` |

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Env Variables

Defined in `.env` (gitignored). Access via `Env.baseUrl`, `Env.apiKey`.

After changing `.env`:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Package Constraints

| Package | Constraint | Reason |
|---|---|---|
| `envied` | `>=1.1.0 <1.2.0` | Must match `envied_generator 1.1.1` |
| `go_router_builder` | not used | `source_gen` version conflict with `freezed` |

Do not upgrade `envied` past `1.1.x` without also upgrading `envied_generator`.

Typed route extensions for GoRouter are written manually in `app_router.dart`.

## Common Mistakes

- Forgetting to run build_runner after adding `@riverpod` → stale `.g.dart`, compile errors
- Committing `env.g.dart` → exposes obfuscated secrets, blocked by `.gitignore`
- Upgrading `envied` without `envied_generator` → generator version mismatch
