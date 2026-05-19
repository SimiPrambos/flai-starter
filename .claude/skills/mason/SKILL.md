# Feature Scaffolding (Mason)

## When to Use

Run the brick whenever you need to create a new Clean Architecture feature from scratch. It generates all layers, wires the correct base classes, and produces test stubs — so you start from a working skeleton rather than copying files from `users`.

## How to Run

```sh
melos make-feature -- --name <feature_name> --app-package template_vgv_app
```

Or directly:

```sh
mason make feature --name <feature_name> --app-package template_vgv_app
```

`<feature_name>` must be `snake_case` (e.g. `payments`, `auth`, `order_items`).

The brick runs `build_runner` automatically after generation.

## What Gets Generated

For `--name payments`:

```
lib/features/payments/
├── data/
│   ├── datasources/remote_payments_datasource.dart
│   ├── models/payments_model.dart
│   └── repositories/payments_repository_impl.dart
├── domain/
│   ├── entities/payments_entity.dart
│   ├── repositories/payments_repository.dart
│   └── usecases/get_payments_use_case.dart
└── presentation/
    ├── pages/payments_page.dart
    ├── providers/payments_notifier.dart
    └── widgets/   (empty, .gitkeep)

test/features/payments/
├── data/repositories/payments_repository_impl_test.dart
├── domain/usecases/get_payments_use_case_test.dart
└── presentation/providers/payments_notifier_test.dart
```

## Required Steps After Generation

The brick generates fully wired, compilable code. The only manual steps are feature-specific:

1. Add API fields to `<name>_model.dart` and `<name>_entity.dart`
2. Implement `toEntity()` in the model mapper extension
3. Run `dart run build_runner build --delete-conflicting-outputs`

Everything else — providers, notifier wiring, route registration, by_id notifier, detail page — is handled automatically by the post-gen hook.

## datasource.getX vs repository.getXs

The brick generates `datasource.getPayments(page)` (no trailing `s`) — this is the API call. The repository interface and implementation use the same name. Tests call `repo.getPayments(page: 1)`. Keep naming consistent when renaming.

## PaginatedMixin

The generated notifier extends `PaginatedMixin<T>` from `lib/core/common/paginated_mixin.dart`. This provides:

- `loadMore()` — appends the next page, guards against double calls
- `refresh()` — resets to page 1
- `hasMore` — true while more pages exist

You only implement `fetchPage(int page)`.

## Common Mistakes

- Running `mason make feature` without `--name` — mason will prompt interactively, which hangs in CI
- Forgetting to create `<feature>_providers.dart` — `fetchPage` stub throws `UnimplementedError`
- Not running build_runner after adding fields to the model — stale `.g.dart` files cause compile errors
- Wiring a route without a stable `name` — Analytics reports raw paths instead of screen names
