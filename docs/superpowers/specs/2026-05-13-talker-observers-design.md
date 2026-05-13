# Design: Talker Riverpod Logger + Route Observer

**Date:** 2026-05-13  
**Status:** Approved

## Overview

Tambah dua Talker observer ke project:
1. `TalkerRiverpodLogger` — log state changes semua Riverpod provider (non-production only)
2. `TalkerRouteObserver` — log navigasi GoRouter (semua environment)

## Dependencies

Tambah ke `pubspec.yaml` (dependencies):

```yaml
talker_riverpod_logger: ^4.4.1
```

Versi dikunci di `^4.4.1` agar match dengan `talker: ^4.4.1` yang sudah ada.

## Architecture

### TalkerRiverpodLogger — `bootstrap.dart`

- Guard dengan `!kReleaseMode` (dari `package:flutter/foundation.dart`)
- Didaftarkan sebagai `ProviderObserver` di `ProviderScope(observers:)`
- Instance `talker` yang dipakai adalah instance yang sama yang sudah dibuat di bootstrap (konsisten dengan `TalkerDioLogger`)
- Production build (release mode) tidak terpengaruh secara performa

```dart
ProviderScope(
  overrides: [talkerProvider.overrideWithValue(talker)],
  observers: [
    if (!kReleaseMode) TalkerRiverpodLogger(talker: talker),
  ],
  child: await builder(),
)
```

### TalkerRouteObserver — `app_router.dart`

- Aktif di semua environment (berguna untuk debug navigasi di semua build)
- `appRouterProvider` menambah `ref.watch(talkerProvider)` untuk mendapat instance Talker
- Didaftarkan di `GoRouter(observers:)`
- Tidak butuh perubahan pada route definitions atau extensions

```dart
@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final talker = ref.watch(talkerProvider);
  return GoRouter(
    initialLocation: UsersRoute.path,
    observers: [TalkerRouteObserver(talker)],
    routes: [...],
  );
}
```

## Files Changed

| File | Perubahan |
|---|---|
| `pubspec.yaml` | Tambah `talker_riverpod_logger: ^4.4.1` |
| `lib/bootstrap.dart` | Import + tambah observer ke ProviderScope |
| `lib/core/router/app_router.dart` | Watch talkerProvider + tambah GoRouter observer |

## Out of Scope

- Konfigurasi custom filter log per event type (pakai default: semua event)
- Environment flag eksplisit di `main_*.dart` (tidak diperlukan)
- Perubahan pada `talker_provider.dart` (tidak diperlukan)
