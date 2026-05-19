---
name: flai-architecture
description: Use when creating new features, adding files, deciding where code belongs, checking import boundaries, or reviewing folder structure in this Flutter project. Covers Clean Architecture layers, dependency rules, and canonical folder shape.
---

# Architecture

## Core Rule

`presentation -> domain <- data`

`domain/` is pure Dart — no Flutter, no data models, no datasources, no UI types, no infrastructure services.

## Folder Shape

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

## Import Rules

| Layer | May import | Must NOT import |
|---|---|---|
| `domain/` | Dart packages, `fpdart` | Flutter, data, core infrastructure |
| `data/` | `domain/` (for mapping) | presentation |
| `presentation/` | `domain/`, shared widgets, theme, router | `data/models/` |

Provider wiring may expose data implementations through Riverpod providers, but UI must depend on notifier/usecase-facing providers only.

## Feature Layer Responsibilities

- **entity**: immutable Freezed entity with computed convenience getters
- **repository (domain)**: abstract interface returning `Either<Failure, T>`
- **usecase**: small class delegating to the repository
- **model (data)**: Freezed/JSON model matching API shape
- **mapper**: model-to-entity extension in the data layer
- **datasource**: Retrofit API interface
- **repository (data)**: catches `AppException`, maps to `Failure`, returns entities only
- **notifier**: Riverpod `AsyncNotifier` for presentation state
- **page**: `ConsumerWidget` rendering loading/error/data

## Core Shared Utilities

### `RepositoryGuard` mixin
Apply to every repository implementation. Wraps the DioException error pipeline. Never write a manual try/catch in a repository — use `guardRequest`.

```dart
class XRepositoryImpl with RepositoryGuard implements XRepository {
  Future<Either<Failure, XEntity>> getX({required int id}) =>
      guardRequest(() async =>
          SingleResponse.fromJson(
            (await _datasource.getX(id)) as Map<String, dynamic>,
            XModel.fromJson,
          ).data.toEntity());
}
```

### `PagedResponseMapper` mixin (via `PaginatedResponse`)
Use `PaginatedResponse<T>.fromJson(json, fromJsonT)` and `SingleResponse<T>.fromJson(json, fromJsonT)` from `lib/core/common/` to parse API responses. The datasource returns `Future<dynamic>`, and the repository casts and parses.

```dart
// datasource (Retrofit)
@GET('/items')
Future<dynamic> getItems(@Query('page') int page);

// repository
PaginatedResponse.fromJson(
  (await _datasource.getItems(page)) as Map<String, dynamic>,
  ItemModel.fromJson,
).toPaginatedResult((m) => m.toEntity())
```

### Usecase rule
Eliminate usecases for simple CRUD (get list, get by ID). Notifiers call `ref.read(xRepositoryProvider).getXs()` directly. Only add a usecase class when the operation contains real business logic (input validation, combining multiple data sources, transformation).

## Reference Implementation

`features/users` is the canonical example — read it before creating new features.
