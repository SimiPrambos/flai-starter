# flai-starter

Flutter enterprise starter — Clean Architecture, Riverpod, GoRouter.

## Governance Model

AI workflow is governed by **hooks in `.claude/settings.json`**, not by prose. The rules below describe the contract; the hooks enforce it.

| Concern | Enforced by | Effect |
|---|---|---|
| No code without a spec | `require-spec.sh` (PreToolUse) | Edit/Write into `lib/features/{name}/**` is **blocked** if `docs/features/{name}/SPEC.md` is missing |
| Spec changes are traceable | `spec-changelog-reminder.sh` (PostToolUse) | Reminder fires when SPEC.md is edited |
| Team can see state at a glance | `regenerate-index.sh` (PostToolUse) | `docs/features/INDEX.md` is auto-rewritten from SPEC.md frontmatter |
| No false completion claims | `verify-or-block.sh` (Stop) | `flutter analyze` + `flutter test` must both pass before claimed-done |
| Workflow reminder | `UserPromptSubmit` | Surfaces superpowers requirement on every prompt |

Emergency bypass (audited): `GOVERNANCE_BYPASS=1`. See `.claude/hooks/` for the scripts.

## Mandatory Workflow

**At the start of every conversation:** invoke `superpowers:using-superpowers` before any other response.

**For any work inside `lib/features/{name}/`** — the `require-spec.sh` hook will block edits without a spec. The expected flow:

1. `superpowers:brainstorming` → gather intent, user stories, BDD scenarios → write `docs/features/{name}/SPEC.md` (use the `feature-spec` skill for the schema)
2. `superpowers:writing-plans` → write `docs/features/{name}/PLAN.md`
3. Scaffold via `mason` skill (`make-domain` / `make-data` / `make-presentation`)
4. `superpowers:test-driven-development` → seed tests from BDD scenarios in SPEC.md
5. Implement layer by layer following the architecture rules
6. `superpowers:verification-before-completion` — `flutter analyze` + `flutter test` (Stop hook re-runs these)
7. `superpowers:finishing-a-development-branch` → bump SPEC.md status to `shipped`, merge/PR

**Before any UI implementation** — scan `lib/shared/widgets/` first:
- Use existing shared widget if it covers the use case
- Extend existing widget if a small parameter addition covers it
- New widget used by 2+ features → `lib/shared/widgets/`
- New widget specific to one feature → `lib/features/{name}/presentation/widgets/`

**Per-feature artifact contract** is defined by the `feature-spec` skill. The folder shape is:

```
docs/features/{name}/
├── SPEC.md           ← source of truth, with YAML frontmatter
├── PLAN.md           ← implementation plan
├── CHANGELOG.md      ← what changed and why, newest first
└── decisions/        ← optional ADRs
docs/features/INDEX.md  ← auto-generated team dashboard
```

## Project Purpose

Reusable Flutter starter for future apps. The built-in example feature is `users`, backed by `reqres.in`. Treat it as the reference implementation for new features, not as one-off demo code.

## Stack

- State + DI: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- Routing: `go_router` with manual typed route classes/extensions
- Network: `dio`, `retrofit`, `connectivity_plus`
- Models: `freezed`, `json_serializable`
- Errors: `fpdart` `Either<Failure, T>`
- Env: `envied`
- Logging: `talker`, `talker_dio_logger`, `talker_flutter`, `talker_riverpod_logger`
- Observability: Firebase Core, Crashlytics, Analytics
- UI utilities: `gap`, `cached_network_image`, `skeletonizer`, `flutter_screenutil`

## Specialist Skills

Load the relevant skill before working in each area:

| Topic | Skill | When to load |
|---|---|---|
| Feature artifact contract (SPEC/CHANGELOG/ADR/Mason) | `feature-spec` | Whenever working under `docs/features/` or `lib/features/` |
| Architecture & layers | `flai-architecture` | Adding features, checking imports |
| Navigation / routing | `flai-navigation` | Adding routes, screen navigation |
| Riverpod providers | `flai-riverpod` | Creating providers or notifiers |
| Error handling | `flai-error-handling` | Writing repos, handling failures |
| Network / API | `flai-network` | Adding endpoints, Dio config |
| Responsive UI | `flai-responsive-ui` | Writing widget dimensions |
| Loading skeletons | `flai-loading-states` | Adding loading placeholders |
| Theme & shared UI | `flai-theme` | Colors, text styles, spacing |
| Testing | `flai-testing` | Writing any test |
| Firebase & Talker | `flai-firebase-talker` | Logging, analytics, Crashlytics |
| Generated files | `flai-generated-files` | Build runner, env, constraints |
| Feature scaffolding | `mason` | `make-domain` / `make-data` / `make-presentation` / `make-feature` |
| Shared widgets (AppAvatar, PaginatedListPage, AsyncDetailScaffold, ErrorRetryWidget) | `shared-widgets` | Using or building any shared widget |
