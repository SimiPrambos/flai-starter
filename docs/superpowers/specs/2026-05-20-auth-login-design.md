# Auth / Login Feature Design

**Date:** 2026-05-20
**Status:** approved

## Overview

Login screen for **LearnXpert LnD** (Learning & Development platform by Ajari). Full Clean Architecture scaffold with a mock remote datasource (no real backend yet). After successful login, navigate to a static Dashboard placeholder.

## Architecture

### Feature `auth`

| Layer | File | Responsibility |
|---|---|---|
| Domain entity | `auth_entity.dart` | `AuthEntity(token: String)` |
| Domain repo | `auth_repository.dart` | Abstract interface: `login(email, password) → Either<Failure, AuthEntity>` |
| Data model | `auth_model.dart` | JSON model matching future API response |
| Data datasource | `remote_auth_datasource.dart` | Mock: 500ms delay, returns fake token |
| Data repo impl | `auth_repository_impl.dart` | `RepositoryGuard` mixin, maps to `AuthEntity` |
| Providers | `auth_providers.dart` | Riverpod datasource + repo providers |
| Notifier | `login_notifier.dart` | `AsyncNotifier<void>`, calls repo, navigates on success |
| Page | `login_page.dart` | `ConsumerWidget`, full-screen gradient UI from design |

### Feature `dashboard`

| Layer | File | Responsibility |
|---|---|---|
| Page | `dashboard_page.dart` | Static placeholder, `ConsumerWidget` |

No domain or data layer for dashboard — placeholder only.

## Visual Specification (from Login.html)

| Element | Value |
|---|---|
| Background | `LinearGradient(#04040E → #1056D9, top → bottom)` |
| Screen | Full screen (no phone frame wrapper in Flutter) |
| Decorative | Arch SVG shapes at bottom, opacity 0.75, soft-light blend |
| Logo | "LearnXpert" SVG wordmark (gradient X with leaf, inline SVG → `CustomPaint`) |
| Subtitle | "POWERED BY AJARI" — 10sp, spaced, `rgba(247,247,247,0.35)` |
| Email field | White rounded input, border `#D5D7DA`, placeholder `#9AA2B1` |
| Password field | White rounded input + eye icon toggle (show/hide) |
| Login button | `#1056D9`, full width, Poppins SemiBold 14sp, radius 6 |
| Footer | "©2026 LearnXpert LnD" — bottom center, `#868D9D` |

All sizes use ScreenUtil suffixes (`.r`, `.sp`, `.w`, `.h`).

## Auth Flow

```
LoginPage (idle)
  → user enters email + password
  → tap Login
  → LoginNotifier.login(email, password)
  → MockAuthRemoteDataSource.login() — 500ms delay → AuthModel(token: 'mock-token')
  → AuthRepositoryImpl.login() → Either.right(AuthEntity(token: 'mock-token'))
  → LoginNotifier: state = AsyncData(null)
  → navigate to DashboardRoute (replaces login — no back navigation)
  → (on error) → state = AsyncError → show error snackbar/message in UI
```

## Melos Scaffold Commands

```sh
melos make-domain       -- --name auth --app-package template_vgv_app
melos make-data         -- --name auth --app-package template_vgv_app
melos make-presentation -- --feature auth --name login --type single --app-package template_vgv_app
melos make-presentation -- --feature dashboard --name dashboard --type static --app-package template_vgv_app
```

## Open Questions

- [ ] Real API endpoint + response shape (pending BE)
- [ ] Token persistence strategy (secure storage vs shared prefs) — needed before shipping
- [ ] Dashboard content — out of scope for this spec
