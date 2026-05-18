---
name: flai-error-handling
description: Use when handling errors, writing repository methods, or converting exceptions to failures in this Flutter project. Covers AppException, Failure variants, Either pattern, and readable error messages.
---

# Error Handling

## Flow

```
Infrastructure/network throws → AppException
AppException → mapped to Failure (at repository boundary)
Repository returns → Future<Either<Failure, T>>
Presentation notifier → converts Failure to thrown state for AsyncValue
```

## Failure Variants

Keep these small and readable:

```dart
Failure.network(message: ...)
Failure.server(message: ..., statusCode: ...)
Failure.unknown(message: ...)
```

## Repository Pattern

Repositories catch `DioException` (the network layer wrapper) and map the
inner `AppException` via `toFailure()`. The `toFailure()` method is defined
on `AppException` and handles all subtypes via a switch expression.

```dart
Future<Either<Failure, UserEntity>> getUserById({required int id}) async {
  try {
    final response = await _datasource.getUser(id);
    return right(response.data.toEntity());
  } on DioException catch (e) {
    final appException = e.error;
    if (appException is AppException) return left(appException.toFailure());
    return left(Failure.unknown(message: e.message ?? 'Unknown error'));
  } on Object catch (e) {
    return left(Failure.unknown(message: e.toString()));
  }
}
```

## User-Facing Text

Use `failure.readableMessage` for text shown to users — never expose raw exception messages.

## Presentation Notifier

Notifiers may convert `Failure` into a thrown state so `AsyncValue` renders loading/error/data consistently:

```dart
state = AsyncError(failure.readableMessage, StackTrace.current);
```

## Common Mistakes

- Catching `Exception` broadly instead of `AppException` → loses structured failure mapping
- Returning entity data directly without `Either` → caller cannot distinguish success from failure
- Showing raw exception `.toString()` to users → use `readableMessage`
