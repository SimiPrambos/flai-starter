# Users — Changelog

## 2026-10-02 — Users moved into the tab shell
**Trigger:** Session gate + bottom-tab shell (auth and settings features)
**Changed:** `UsersRoute` and `UserDetailRoute` now live in branch 0 of `AppShellRoute`. Paths, route names, pages and behavior are unchanged; `/users` is reachable only when signed in, and the detail page keeps the tab bar.
**Code affected:** lib/core/router/app_router.dart, lib/core/router/app_router.g.dart
**Status:** applied

## 2026-10-02 — freezed 3 class modifiers
**Trigger:** Code drift — freezed upgraded to 3.x
**Changed:** `UserEntity`, `UserModel`, `UsersListResponse` and `UserSingleResponse` are now declared `abstract class`; generated files regenerated. No entity, API, UI or behavior change; SPEC.md unchanged.
**Code affected:** user_entity.dart, user_model.dart, users_list_response.dart, user_single_response.dart (+ generated `.freezed.dart` / `.g.dart`)
**Status:** applied

## 2026-05-20 — Backfilled SPEC.md
**Trigger:** Governance rollout — `require-spec.sh` blocks edits to `lib/features/users/` without a SPEC.md
**Changed:** Wrote the SPEC.md by reverse-engineering from the existing implementation (UserEntity, RemoteUserDataSource, pages, notifiers). No code change.
**Code affected:** none — documentation only
**Status:** applied
