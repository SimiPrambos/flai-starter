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

```dart
Future<Either<Failure, List<User>>> getUsers() async {
  try {
    final models = await _datasource.getUsers();
    return right(models.map((m) => m.toEntity()).toList());
  } on AppException catch (e) {
    return left(e.toFailure());
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
