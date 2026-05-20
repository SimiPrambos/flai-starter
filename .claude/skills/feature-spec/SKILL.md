---
name: feature-spec
description: Per-feature artifact contract. Defines folder layout, file schemas (SPEC.md, CHANGELOG.md, ADR), and Mason wiring. Invoked by superpowers:* skills to learn where to write outputs and what format to use. Not a workflow — format + tooling only.
---

# feature-spec

Per-feature artifact contract. Defines what lives in `docs/features/{name}/`, the schemas of those files, and the Mason bricks that scaffold matching code under `lib/features/{name}/`.

**This skill is format + tooling, not workflow.** `superpowers:*` skills drive the process (brainstorm → plan → TDD → verify → finish); this skill defines what their outputs look like and where they live. Enforcement of the contract lives in `.claude/hooks/`, not in this prose.

---

## Folder Contract

Every feature lives in its own folder:

```
docs/features/{name}/
├── SPEC.md           ← source of truth (entity, API, scenarios, UI states, ACs)
├── PLAN.md           ← implementation plan (output of superpowers:writing-plans)
├── CHANGELOG.md      ← what changed and why, newest first
└── decisions/        ← ADRs for non-obvious choices (optional)
    └── NNN-*.md
```

`docs/features/INDEX.md` is auto-generated from every SPEC.md's frontmatter. **Never edit it by hand** — the PostToolUse hook overwrites it on every SPEC.md save.

### Hook enforcement

| Trigger | Hook | Effect |
|---|---|---|
| Edit/Write into `lib/features/{name}/**` with no SPEC.md | `require-spec.sh` (PreToolUse) | **Blocks** the edit |
| Edit/Write on `docs/features/{name}/SPEC.md` | `spec-changelog-reminder.sh` (PostToolUse) | Reminds to update CHANGELOG + frontmatter |
| Edit/Write on `docs/features/{name}/SPEC.md` | `regenerate-index.sh` (PostToolUse) | Rewrites `docs/features/INDEX.md` |
| AI claims completion | `verify-or-block.sh` (Stop) | **Blocks** if `flutter analyze` or `flutter test` fails |

See `.claude/hooks/` for the scripts. Emergency bypass: `GOVERNANCE_BYPASS=1` (audited).

---

## SPEC.md — Schema

```markdown
---
name: {feature_name}
status: draft           # draft | in-progress | review | shipped
owner: {github_handle}
branch: feat/{feature_name}
last_changed: {YYYY-MM-DD}
---

# Feature: {Name}

## Overview
**Why:** {one sentence — business reason}

**User Stories:**
- As a {role}, I want to {action} so that {benefit}
- As a {role}, I want to {action} so that {benefit}

## Entity
| Field | Type | Nullable | Notes |
|-------|------|----------|-------|
| id    | int  | no       |       |

## API
| Method | Endpoint    | Params    | Response             | Status     |
|--------|-------------|-----------|----------------------|------------|
| GET    | /{name}     | page: int | {Name}ListResponse   | confirmed  |
| GET    | /{name}/:id | id: int   | {Name}SingleResponse | pending    |

API status values: `confirmed` (contract agreed) | `pending` (not yet agreed) | `mock-only` (mock in use, no backend yet)

## Scenarios

### {screen or action name}

**Given** {precondition / input state}
**When** {user action or system event}
**Then** {expected output / visible result}

**Given** {edge case}
**When** {action}
**Then** {expected handling}

*(One block per meaningful behavior — happy path + empty state + error paths + edge cases. Each maps directly to one test case when superpowers:test-driven-development runs.)*

## UI States

### {Name}Page (list)
- **Loading:** skeleton card × 6
- **Empty:** "{message}" + {CTA or none}
- **Error:** message + retry
- **Data:** {Name}Card showing {field1}, {field2}

### {Name}DetailPage
- **Loading:** {Name}DetailSkeleton
- **Error:** retry
- **Data:** {layout description}

## Navigation
- **Entry:** /{name}
- **List → Detail:** tap card → push {Name}DetailRoute(id: item.id)

## Acceptance Criteria
- [ ] {testable condition — maps to a scenario above}
- [ ] {testable condition}

## Open Questions
- [ ] {question — who resolves it}
```

### Frontmatter rules

- All five fields are **required** — INDEX.md regeneration parses them.
- `status` lifecycle: `draft → in-progress → review → shipped`. Each transition has a meaning (see below).
- `last_changed`: bump on every meaningful edit. The PostToolUse reminder fires when you forget.

### Status lifecycle

| Status | Means |
|---|---|
| `draft` | SPEC.md exists, code not started |
| `in-progress` | Scaffolded; layers being implemented |
| `review` | All acceptance criteria checked, tests pass, ready for review |
| `shipped` | Merged to main. Spec is now locked — material changes require a new ADR |

---

## CHANGELOG.md — Schema

Append one block per change, **newest first**:

```markdown
## {YYYY-MM-DD} — {short description}
**Trigger:** {PRD vX.Y / engineer request / mock → API integration / code drift}
**Changed:** {what fields / endpoints / UI states / behavior changed}
**Code affected:** {file1.dart, file2.dart}
**Status:** applied | pending
```

The PostToolUse reminder fires whenever SPEC.md changes. **Do not ignore it** — git history is per-commit and spans features; CHANGELOG is per-feature and reads like a journal.

---

## ADR — Schema (`decisions/`)

Use **only** for non-obvious choices where a future engineer would reasonably ask "why not X?" (e.g., "Why offset pagination instead of cursor?"). Skip for obvious or default choices.

Filename: `{NNN}-{kebab-description}.md` (e.g., `001-offset-pagination.md`)

```markdown
# {NNN}. {Title}

**Date:** {YYYY-MM-DD}
**Status:** accepted

## Decision
{One sentence: what was decided.}

## Why
{The reason — constraint, business rule, technical limitation, prior incident.}

## Rejected alternatives
- {Option A} — {why rejected}
- {Option B} — {why rejected}
```

---

## Mason Wiring

Three atomic bricks map 1:1 to Clean Architecture layers. Run them independently as the feature grows.

```sh
# Domain layer only (entity + repository interface)
melos make-domain -- --name {feature} --app-package template_vgv_app

# Data layer (model + datasource + repo impl + providers + repo test)
melos make-data -- --name {feature} --app-package template_vgv_app

# Presentation layer (page + notifier + route + notifier test)
melos make-presentation -- --feature {feature} --name {page} --type list|detail|single|static --app-package template_vgv_app
```

Full CRUD shortcut (chains domain + data + list + detail in one shot):

```sh
melos make-feature -- --name {feature} --app-package template_vgv_app
```

See `.claude/skills/mason/SKILL.md` for the full brick reference, type semantics, and file ownership table.

---

## Recipe — Mock-first, then real API

The one workflow worth documenting explicitly because it spans two sessions and the mock → real transition is hard to detect from git alone.

### When the API contract is not yet confirmed

1. Mark affected endpoints as `mock-only` in SPEC.md's API table
2. Run `make-domain` + `make-presentation` (skip `make-data`)
3. Create `lib/features/{name}/data/repositories/mock_{name}_repository.dart` implementing the domain interface with dummy data drawn from the SPEC.md Entity table
4. Wire mock in `{name}_providers.dart` with a `// TODO: swap when API ready` comment:
   ```dart
   @Riverpod(keepAlive: true)
   {Name}Repository {name}Repository({Name}RepositoryRef ref) =>
       Mock{Name}Repository(); // TODO: swap when API ready
   ```
5. Build UI against the mock

### When the API contract is confirmed

1. Update affected endpoints to `confirmed` in SPEC.md
2. Run `make-data` to scaffold the real datasource + model + repository impl
3. Fill in Retrofit annotations on the datasource + model fields + `toEntity()` mapper from the spec
4. Swap the provider:
   ```dart
   @Riverpod(keepAlive: true)
   {Name}Repository {name}Repository({Name}RepositoryRef ref) =>
       {Name}RepositoryImpl(ref.read(remote{Name}DataSourceProvider));
   ```
5. Delete `mock_{name}_repository.dart` (or rename to `test/fake_{name}_repository.dart` and reuse in tests)
6. Run `superpowers:test-driven-development` on the data layer — seed tests from API scenarios in SPEC.md
7. Append a CHANGELOG entry:
   ```markdown
   ## {YYYY-MM-DD} — API integrated
   **Trigger:** Backend API confirmed and deployed
   **Changed:** Swapped Mock{Name}Repository → {Name}RepositoryImpl. All endpoints now confirmed.
   **Code affected:** {name}_providers.dart, remote_{name}_datasource.dart, {name}_repository_impl.dart
   **Status:** applied
   ```

---

## Workflow Integration

`superpowers:*` produces the artifacts; this skill defines their shape. Phase-by-phase:

| Phase | Skill | Artifact produced |
|---|---|---|
| Gather requirements | `superpowers:brainstorming` | `docs/features/{name}/SPEC.md` (using the schema above) |
| Plan implementation | `superpowers:writing-plans` | `docs/features/{name}/PLAN.md` |
| Build each layer | `superpowers:test-driven-development` | Tests seeded from SPEC.md Scenarios |
| Scaffold code | `mason` (via this skill) | Files under `lib/features/{name}/` |
| Verify before done | `superpowers:verification-before-completion` | `verify-or-block.sh` enforces |
| Wrap up branch | `superpowers:finishing-a-development-branch` | Status → `shipped`, merge/PR |

See `.claude/CLAUDE.md` for the mandatory workflow ordering.

---

## Common Mistakes

- Editing `lib/features/{name}/**` without a SPEC.md → **blocked by `require-spec.sh`**. Run `superpowers:brainstorming` first.
- Forgetting to bump `last_changed` after a meaningful edit → INDEX.md still regenerates but shows a stale date.
- Hand-editing INDEX.md → silently overwritten on the next SPEC.md save.
- Setting status to `shipped` before acceptance criteria are checked off → defeats the lifecycle.
- Writing an ADR for an obvious choice → ADRs are for decisions that need justification.
- Inventing entity fields not in SPEC.md → update the spec first, then regenerate via Mason or hand-edit, then code.
