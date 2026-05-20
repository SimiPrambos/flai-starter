# Feature Spec

## Governance Rule

**ALWAYS invoke this skill before any work inside `lib/features/{name}/`.**

The `SPEC.md` is the source of truth for a feature. Do not invent entity fields,
endpoints, or UI patterns not in the spec without updating the spec first.
All implementation skills (`architecture`, `network`, `riverpod`, etc.) apply
**after** the spec is confirmed.

---

## Three Modes

Detect the mode automatically based on context:

| Situation | Mode |
|---|---|
| Engineer mentions a new feature, no SPEC.md exists | **Create** |
| Starting work on an existing feature | **Follow** |
| Engineer mentions PRD changed / new requirements | **Update** |

---

## Mode 1 — Create

Use when: no `docs/features/{name}/SPEC.md` exists yet.

### Steps

1. Ask for the PRD — accept pasted text, file path, or uploaded file
2. Ask for Figma — accept:
   - Figma link (if Figma MCP is configured)
   - Screenshot(s)
   - Written description of each screen
3. Extract from PRD + Figma:
   - Entity fields (name, type, nullability, notes)
   - API endpoints (method, path, query params, response type)
   - UI states per screen (loading, empty, error, data — what each renders)
   - Navigation (entry point, transitions, params passed)
   - Acceptance criteria (testable conditions from PRD)
   - Open questions (anything unclear or pending backend confirmation)
4. Write `docs/features/{name}/SPEC.md` using the format below
5. Create empty `docs/features/{name}/CHANGELOG.md`
6. Set status: `draft`
7. Announce: "Spec created. Proceeding to scaffold."
8. Ask: **"Is the API contract confirmed for all endpoints?"**

   **If YES (all endpoints confirmed):**
   - Invoke `mason` skill → full stack: `make-domain` + `make-data` + `make-presentation`
   - Fill in generated files from spec:
     - Entity fields → `{name}_entity.dart` + `{name}_model.dart`
     - API endpoint → `remote_{name}_datasource.dart` Retrofit annotations
     - Card widget content → `{name}_card.dart` (list type only)
   - Mark all API endpoints as `confirmed` in SPEC.md

   **If NO (any endpoint is pending or unknown):**
   - Run `make-domain` → entity + repository interface only
   - Run `make-presentation` → page + notifier + route (skip `make-data`)
   - Create `lib/features/{name}/data/repositories/mock_{name}_repository.dart`:
     ```dart
     class Mock{Name}Repository implements {Name}Repository {
       @override
       Future<Either<Failure, PaginatedResult<{Name}Entity>>> get{Name}s({
         required int page,
       }) async =>
           right(PaginatedResult(
             items: _dummy{Name}s,
             currentPage: page,
             totalPages: 1,
           ));

       static const _dummy{Name}s = [
         {Name}Entity(id: 1 /* fill entity fields from spec */),
         {Name}Entity(id: 2 /* fill entity fields from spec */),
       ];
     }
     ```
   - Wire mock in `{name}_providers.dart`:
     ```dart
     @Riverpod(keepAlive: true)
     {Name}Repository {name}Repository({Name}RepositoryRef ref) =>
         Mock{Name}Repository(); // TODO: swap when API ready
     ```
   - Mark affected API endpoints as `mock-only` in SPEC.md
   - Fill entity fields in `{name}_entity.dart` from spec

9. Update spec status to `in-progress`

---

## Mode 2 — Follow

Use when: `docs/features/{name}/SPEC.md` exists and work is starting.

### Steps

1. Read `docs/features/{name}/SPEC.md`
2. Print a short summary:
   ```
   Feature: {name} [status]
   Entity: {N} fields — {field1}, {field2}, ...
   API: {endpoints}
   Open questions: {count}
   ```
3. Confirm which part of the spec the current task relates to
4. Proceed with implementation — existing skills apply normally
5. After changes: if entity fields, endpoints, or UI states changed, run **Update** mode

---

## Mode 3 — Update

Use when: PRD changed, requirements changed, or code diverged from spec.

### Steps

1. Read current `docs/features/{name}/SPEC.md`
2. Accept new requirements (pasted PRD section, verbal description, or observed code change)
3. Diff — show exactly what is changing before writing:
   ```
   + currency: String     (new field)
   ~ status: pending → queued  (renamed)
   - notes              (removed)
   ```
4. Ask: "Update spec with these changes?" — proceed on confirmation
5. Update `SPEC.md` in place
6. Run `gitnexus_impact` on affected symbols to surface code files that need updating
7. Append entry to `docs/features/{name}/CHANGELOG.md`
8. Surface affected files to engineer: "These files need updating: ..."
9. If the change is a significant architectural decision, add an ADR to `docs/features/{name}/decisions/`

---

## Mode 4 — API Integration

Use when: a feature was built with mock data and the real API contract is now confirmed.

### Steps

1. Update endpoint status in SPEC.md from `pending`/`mock-only` to `confirmed`
2. Run `make-data` to scaffold real datasource + model + repository impl:
   ```sh
   melos make-data -- --name <feature_name> --app-package <app_package>
   ```
3. Fill in entity fields, model fields, and datasource Retrofit annotations from spec
4. Implement `toEntity()` mapper extension on the model
5. Swap provider in `{name}_providers.dart`:
   ```dart
   @Riverpod(keepAlive: true)
   {Name}Repository {name}Repository({Name}RepositoryRef ref) =>
       {Name}RepositoryImpl(ref.read(remote{Name}DataSourceProvider));
   ```
6. Delete `mock_{name}_repository.dart` (or keep as a test helper — rename to `fake_{name}_repository.dart` in `test/`)
7. Invoke `superpowers:test-driven-development` for the data layer — seed tests from API scenarios in SPEC.md
8. Append entry to `docs/features/{name}/CHANGELOG.md`:
   ```markdown
   ## {YYYY-MM-DD} — API integrated
   **Trigger:** Backend API confirmed and deployed
   **Changed:** Swapped Mock{Name}Repository → {Name}RepositoryImpl. All endpoints now confirmed.
   **Code affected:** {name}_providers.dart, remote_{name}_datasource.dart, {name}_repository_impl.dart
   **Status:** applied
   ```

---

## SPEC.md Format

```markdown
# Feature: {Name}
**Status:** draft | in-progress | shipped

## Overview
**Why:** {one sentence — business reason}

**User Stories:**
- As a {role}, I want to {action} so that {benefit}
- As a {role}, I want to {action} so that {benefit}

## Entity
| Field  | Type   | Nullable | Notes |
|--------|--------|----------|-------|
| id     | int    | no       |       |

## API
| Method | Endpoint           | Params      | Response              | Status    |
|--------|--------------------|-------------|-----------------------|-----------|
| GET    | /{name}?page=      | page: int   | {Name}ListResponse    | confirmed |
| GET    | /{name}/{id}       | id: int     | {Name}SingleResponse  | pending   |

Status values: `confirmed` (contract agreed) | `pending` (not yet agreed) | `mock-only` (no backend, mock in use)

## Scenarios

### {Screen or action name}

**Given** {precondition / input state}
**When** {user action or system event}
**Then** {expected output / visible result}

**Given** {edge case or error input state}
**When** {action}
**Then** {expected handling}

*(Add one block per meaningful behavior — happy path + empty state + error paths + edge cases.
Each block maps directly to one test case when superpowers:test-driven-development runs.)*

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

---

## CHANGELOG.md Format

Append one block per change, newest first:

```markdown
## {YYYY-MM-DD} — {short description}
**Trigger:** {PRD vX.Y / engineer request / code observation}
**Changed:** {what fields/endpoints/UI states changed}
**Code affected:** {file1.dart, file2.dart}
**Status:** applied | pending
```

---

## ADR Format (`decisions/`)

Use only for non-obvious choices — when a future engineer would reasonably ask "why not X instead?"

Filename: `{NNN}-{kebab-description}.md`

```markdown
# {NNN}. {Title}

**Date:** {YYYY-MM-DD}
**Status:** accepted

## Decision
{One sentence: what was decided.}

## Why
{The reason — constraint, business rule, technical limitation.}

## Rejected alternatives
- {Option A} — {why rejected}
```

---

## Integration with Existing Skills

| Phase | Skill |
|---|---|
| Start of every conversation | `superpowers:using-superpowers` |
| New feature or existing feature | `feature-spec` (this skill) |
| After spec approved | `superpowers:writing-plans` → output to `docs/features/{name}/PLAN.md` |
| Before any UI work | Scan `lib/shared/widgets/` → decide placement (see CLAUDE.md Workflow rules) |
| Before implementing each layer | `superpowers:test-driven-development` — seed from Scenarios in SPEC.md |
| Filling in entity + model | `architecture` skill — layer rules apply |
| Filling in datasource | `network` skill — Retrofit annotations, interceptors |
| Filling in notifier | `riverpod` skill — codegen, keepAlive rules |
| Building card / page UI | `theme`, `responsive-ui`, `shared-widgets` skills |
| Before marking complete | `superpowers:verification-before-completion` |
| Closing out the branch | `superpowers:finishing-a-development-branch` |
| API contract arrives after mock build | Mode 4 — API Integration (this skill) |

---

## Status Lifecycle

```
PRD received              → draft
bricks scaffolded         → in-progress
All ACs met + tests pass  → shipped  (spec locked; changes require new ADR)
```

---

## Common Mistakes

- Starting to code before the spec exists — always run Create mode first
- Inventing entity fields not in the spec — update the spec first, then code
- Forgetting to append CHANGELOG on PRD change — GitNexus impact analysis is useless without it
- Setting status to `shipped` before acceptance criteria are checked off
- Writing an ADR for obvious choices — ADRs are for decisions that need justification
