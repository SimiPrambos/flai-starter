# Talker Observers Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tambah `TalkerRiverpodLogger` (non-production only) dan `TalkerRouteObserver` (semua env) ke project Flutter.

**Architecture:** `TalkerRiverpodLogger` didaftarkan sebagai `ProviderObserver` di `ProviderScope` dalam `bootstrap.dart`, di-guard dengan `!kReleaseMode`. `TalkerRouteObserver` didaftarkan di `GoRouter(observers:)` dalam `appRouterProvider` dengan menambah `ref.watch(talkerProvider)`. Keduanya memakai instance `Talker` yang sama yang sudah ada.

**Tech Stack:** Flutter, Riverpod (`flutter_riverpod`), GoRouter, `talker_flutter ^4.4.1`, `talker_riverpod_logger ^4.4.1` (baru)

---

## File Map

| File | Aksi |
|---|---|
| `pubspec.yaml` | Modify — tambah dependency `talker_riverpod_logger` |
| `lib/bootstrap.dart` | Modify — import + observers di ProviderScope |
| `lib/core/router/app_router.dart` | Modify — watch talkerProvider + observers di GoRouter |
| `test/core/router/app_router_test.dart` | Create — smoke test provider |

---

## Task 1: Tambah dependency `talker_riverpod_logger`

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Tambah package ke `pubspec.yaml`**

  Tambah baris berikut di blok `dependencies`, setelah `talker_flutter`:

  ```yaml
  talker_flutter: ^4.4.1
  talker_riverpod_logger: ^4.4.1
  ```

  Sehingga blok dependencies relevan menjadi:
  ```yaml
  talker: ^4.4.1
  talker_dio_logger: ^4.4.1
  talker_flutter: ^4.4.1
  talker_riverpod_logger: ^4.4.1
  ```

- [ ] **Step 2: Install dependency**

  ```bash
  flutter pub get
  ```

  Expected output: `Got dependencies!` tanpa conflict.

- [ ] **Step 3: Commit**

  ```bash
  git add pubspec.yaml pubspec.lock
  git commit -m "chore: add talker_riverpod_logger dependency"
  ```

---

## Task 2: Tambah `TalkerRiverpodLogger` ke `bootstrap.dart`

**Files:**
- Modify: `lib/bootstrap.dart`

- [ ] **Step 1: Ganti seluruh isi `bootstrap.dart`**

  ```dart
  import 'dart:async';

  import 'package:flutter/foundation.dart';
  import 'package:flutter/widgets.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:talker_flutter/talker_flutter.dart';
  import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
  import 'package:template_vgv_app/core/logging/talker_provider.dart';

  Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
    WidgetsFlutterBinding.ensureInitialized();

    final talker = TalkerFlutter.init();

    FlutterError.onError = (details) {
      talker.handle(details.exception, details.stack);
    };

    runApp(
      ProviderScope(
        overrides: [
          talkerProvider.overrideWithValue(talker),
        ],
        observers: [
          if (!kReleaseMode) TalkerRiverpodLogger(talker: talker),
        ],
        child: await builder(),
      ),
    );
  }
  ```

- [ ] **Step 2: Verifikasi compile**

  ```bash
  flutter analyze lib/bootstrap.dart
  ```

  Expected: `No issues found!`

- [ ] **Step 3: Commit**

  ```bash
  git add lib/bootstrap.dart
  git commit -m "feat: add TalkerRiverpodLogger observer (non-production only)"
  ```

---

## Task 3: Tambah `TalkerRouteObserver` ke `app_router.dart`

**Files:**
- Modify: `lib/core/router/app_router.dart`
- Create: `test/core/router/app_router_test.dart`

- [ ] **Step 1: Tulis failing test terlebih dahulu**

  Buat file `test/core/router/app_router_test.dart`:

  ```dart
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:go_router/go_router.dart';
  import 'package:talker_flutter/talker_flutter.dart';
  import 'package:template_vgv_app/core/logging/talker_provider.dart';
  import 'package:template_vgv_app/core/router/app_router.dart';

  void main() {
    test('appRouterProvider creates a GoRouter', () {
      final talker = TalkerFlutter.init();
      final container = ProviderContainer(
        overrides: [
          talkerProvider.overrideWithValue(talker),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);

      expect(router, isA<GoRouter>());
    });
  }
  ```

- [ ] **Step 2: Jalankan test — harus PASS (router sudah ada, belum ada observer)**

  ```bash
  flutter test test/core/router/app_router_test.dart
  ```

  Expected: PASS (test ini adalah smoke test — observer tidak bisa di-inspect dari luar GoRouter)

- [ ] **Step 3: Ganti seluruh isi `app_router.dart`**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:riverpod_annotation/riverpod_annotation.dart';
  import 'package:talker_flutter/talker_flutter.dart';
  import 'package:template_vgv_app/core/logging/talker_provider.dart';
  import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
  import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';

  part 'app_router.g.dart';

  // ---------------------------------------------------------------------------
  // Route definitions
  // ---------------------------------------------------------------------------

  class UsersRoute extends GoRouteData {
    const UsersRoute();

    static const path = '/users';

    @override
    Widget build(BuildContext context, GoRouterState state) =>
        const UsersPage();
  }

  class UserDetailRoute extends GoRouteData {
    const UserDetailRoute({required this.id});

    static const path = ':id';

    final int id;

    @override
    Widget build(BuildContext context, GoRouterState state) =>
        UserDetailPage(id: id);
  }

  // ---------------------------------------------------------------------------
  // Navigation extensions  (type-safe — never use context.go('/string') directly)
  // ---------------------------------------------------------------------------

  extension UsersRouteX on UsersRoute {
    void go(BuildContext context) => context.go(UsersRoute.path);
    void push(BuildContext context) => context.push(UsersRoute.path);
  }

  extension UserDetailRouteX on UserDetailRoute {
    String get _location => '${UsersRoute.path}/$id';
    void go(BuildContext context) => context.go(_location);
    void push(BuildContext context) => context.push(_location);
  }

  // ---------------------------------------------------------------------------
  // Router provider
  // ---------------------------------------------------------------------------

  @Riverpod(keepAlive: true)
  GoRouter appRouter(AppRouterRef ref) {
    final talker = ref.watch(talkerProvider);
    return GoRouter(
      initialLocation: UsersRoute.path,
      observers: [TalkerRouteObserver(talker)],
      routes: [
        GoRoute(
          path: UsersRoute.path,
          builder: (context, state) => const UsersRoute().build(context, state),
          routes: [
            GoRoute(
              path: UserDetailRoute.path,
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return UserDetailRoute(id: id).build(context, state);
              },
            ),
          ],
        ),
      ],
    );
  }
  ```

- [ ] **Step 4: Jalankan test — harus tetap PASS**

  ```bash
  flutter test test/core/router/app_router_test.dart
  ```

  Expected: PASS

- [ ] **Step 5: Jalankan full test suite**

  ```bash
  flutter test
  ```

  Expected: semua test PASS, tidak ada regresi.

- [ ] **Step 6: Commit**

  ```bash
  git add lib/core/router/app_router.dart test/core/router/app_router_test.dart
  git commit -m "feat: add TalkerRouteObserver to GoRouter"
  ```

---

## Task 4: Verifikasi manual

- [ ] **Step 1: Jalankan app di development mode**

  ```bash
  flutter run -t lib/main_development.dart
  ```

- [ ] **Step 2: Verifikasi TalkerRiverpodLogger aktif**

  Di console terminal, cari log dengan prefix `[riverpod]` saat provider di-read pertama kali (contoh: `[riverpod] Provider talkerProvider was initialized`).

- [ ] **Step 3: Verifikasi TalkerRouteObserver aktif**

  Navigasi dari halaman Users ke halaman User Detail. Di console, cari log dengan prefix `[route]` atau `[navigation]` (contoh: `[route] Route /users/1 was pushed`).

- [ ] **Step 4: Verifikasi analyze bersih**

  ```bash
  flutter analyze
  ```

  Expected: `No issues found!`
