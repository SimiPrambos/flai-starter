# flai-starter

Flutter enterprise starter — Clean Architecture, Riverpod, GoRouter.

## Feature Spec Governance

**Before any work inside `lib/features/{name}/`:**

1. Invoke the `feature-spec` skill
2. Read `docs/features/{name}/SPEC.md` — this is the source of truth
3. After changes, update `SPEC.md` if entity fields, endpoints, or UI states changed
4. Append a `CHANGELOG.md` entry describing what changed and why

Do not invent fields, endpoints, or UI patterns not in the spec without updating the spec first. All other skills apply after the spec is confirmed.

## Workflow — Mandatory

MUST: At the start of every conversation, invoke `superpowers:using-superpowers`
before any other response, including clarifying questions.

MUST: For any work inside `lib/features/`, invoke `feature-spec` first.
- New feature (no SPEC.md exists) → Create mode → write `docs/features/{name}/SPEC.md`
- Existing feature (SPEC.md exists) → Follow mode → read `docs/features/{name}/SPEC.md`

MUST: When brainstorming a Flutter feature → write spec to `docs/features/{name}/SPEC.md`
using feature-spec format (not `docs/superpowers/specs/`).
MUST: When writing-plans for a Flutter feature → write plan to `docs/features/{name}/PLAN.md`.

MUST: Before any UI implementation → scan `lib/shared/widgets/` to discover existing
widgets. Decide placement before writing a single widget:
- Use existing shared widget if it covers the use case
- Extend existing widget if a small parameter addition covers it
- New widget used by 2+ features → `lib/shared/widgets/`
- New widget specific to one feature → `lib/features/{name}/presentation/widgets/`

MUST: Before implementing any layer → invoke `superpowers:test-driven-development`.
Seed test cases from BDD scenarios in SPEC.md, not generic stubs.

MUST: Before marking work complete → invoke `superpowers:verification-before-completion`.
`flutter analyze` + `flutter test` must both pass.

## Project Purpose

Reusable Flutter starter for future apps. The built-in example feature is `users`, backed by `reqres.in`. Treat it as a reference implementation for new features, not as one-off demo code.

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
| Feature spec (PRD → SPEC.md) | @skills/feature-spec/SKILL.md | Before any new or existing feature work |
| Architecture & layers | @skills/architecture/SKILL.md | Adding features, checking imports |
| Navigation / routing | @skills/navigation/SKILL.md | Adding routes, screen navigation |
| Riverpod providers | @skills/riverpod/SKILL.md | Creating providers or notifiers |
| Error handling | @skills/error-handling/SKILL.md | Writing repos, handling failures |
| Network / API | @skills/network/SKILL.md | Adding endpoints, Dio config |
| Responsive UI | @skills/responsive-ui/SKILL.md | Writing widget dimensions |
| Loading skeletons | @skills/loading-states/SKILL.md | Adding loading placeholders |
| Theme & shared UI | @skills/theme/SKILL.md | Colors, text styles, spacing |
| Testing | @skills/testing/SKILL.md | Writing any test |
| Firebase & Talker | @skills/firebase-talker/SKILL.md | Logging, analytics, Crashlytics |
| Generated files | @skills/generated-files/SKILL.md | Build runner, env, constraints |
| Feature scaffolding | @skills/mason/SKILL.md | Scaffolding any layer with make-domain / make-data / make-presentation / make-feature |
| Shared widgets (AppAvatar, PaginatedListPage, AsyncDetailScaffold, ErrorRetryWidget) | @skills/shared-widgets/SKILL.md | Using or building any shared widget |
