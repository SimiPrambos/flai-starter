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

The brick intentionally leaves four things unfinished — complete them in order:

### 1. Add API fields to the model and entity

`payments_model.dart` and `payments_entity.dart` only have `id`. Add the fields your API returns, regenerate:

```sh
dart run build_runner build --delete-conflicting-outputs
```

### 2. Create `lib/features/payments/payments_providers.dart`

Wire the use case to the repository:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/payments/data/repositories/payments_repository_impl.dart';
import 'package:template_vgv_app/features/payments/domain/usecases/get_payments_use_case.dart';

export 'package:template_vgv_app/features/payments/data/repositories/payments_repository_impl.dart'
    show paymentsRepositoryProvider;

part 'payments_providers.g.dart';

@riverpod
GetPaymentsUseCase getPaymentsUseCase(GetPaymentsUseCaseRef ref) =>
    GetPaymentsUseCase(ref.watch(paymentsRepositoryProvider));
```

Run build_runner again after creating this file.

### 3. Wire `payments_notifier.dart`

Import the providers file and implement `fetchPage`:

```dart
import 'package:template_vgv_app/features/payments/users_providers.dart';

// replace the UnimplementedError stub:
@override
Future<PaginatedResult<PaymentsEntity>> fetchPage(int page) async {
  final result = await ref.read(getPaymentsUseCaseProvider).call(page: page);
  return result.fold(
    // ignore: only_throw_errors
    (failure) => throw failure,
    (paginated) => paginated,
  );
}
```

See `lib/features/users/presentation/providers/users_notifier.dart` for the reference.

### 4. Register the route in `app_router.dart`

Add a `@TypedGoRoute` annotation and a `GoRouteData` subclass with `with _$ClassName`:

```dart
@TypedGoRoute<PaymentsRoute>(path: '/payments')
@immutable
class PaymentsRoute extends GoRouteData with _$PaymentsRoute {
  const PaymentsRoute();
  static const path = '/payments';
  static const routeName = 'payments';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PaymentsPage();
}
```

Run `build_runner` — `$appRoutes` is updated automatically. No manual route tree edit needed.

### 5. Verify

```sh
melos check
```

Expected: build_runner no-op, analyzer clean, all tests pass.

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
