---
name: ai-workflow
status: in-progress
owner: silmi
branch: feat/ai-improvement
last_changed: 2026-05-20
---

# Feature: AI Workflow Governance

## Overview

**Why:** AI workflow needs to be non-bypassable and auditable across team members. Prose rules in CLAUDE.md and skill files are advisory — a different AI session, a long context, or prompt drift can route around them. Governance must live in machine-enforced contracts (hooks, file existence checks, machine-readable status) so any reviewer can answer "did the workflow get followed?" with `grep`, `cat`, and `git log` instead of trust.

**User Stories:**
- As an engineer, I want AI to be blocked from coding into a feature with no spec so that I can trust SPEC.md exists for everything in `lib/features/`
- As an engineer, I want completion claims to be backed by a real `flutter analyze + flutter test` run so that "done" means green, not "I think so"
- As a team lead, I want a single dashboard (`docs/features/INDEX.md`) showing every feature's status and owner so that coordination across multiple engineers is one `cat` away
- As an auditor, I want every spec change to leave a CHANGELOG entry so that the *why* of a change is recoverable without git archaeology

## "Entity" — Governance Artifacts

Not a Flutter entity. This feature governs files, not data. The artifacts are:

| Artifact | Path | Purpose |
|----------|------|---------|
| SPEC.md | `docs/features/{name}/SPEC.md` | Source of truth per feature (entity, API, scenarios, UI, ACs) |
| PLAN.md | `docs/features/{name}/PLAN.md` | Implementation plan from `superpowers:writing-plans` |
| CHANGELOG.md | `docs/features/{name}/CHANGELOG.md` | What changed and why, newest first |
| INDEX.md | `docs/features/INDEX.md` | Auto-generated team dashboard |
| ADR | `docs/features/{name}/decisions/NNN-*.md` | Non-obvious architectural decisions |
| Hooks | `.claude/hooks/*.sh` | Enforcement scripts |
| Settings | `.claude/settings.json` | Hook wiring |

## "API" — Hook Contract

Not an HTTP API. The "interface" between AI and the harness is hooks declared in `.claude/settings.json`.

| Event | Script | Effect | Status |
|-------|--------|--------|--------|
| `UserPromptSubmit` | `echo` reminder | Reminds AI to follow superpowers workflow | confirmed |
| `PreToolUse(Edit\|Write\|NotebookEdit)` | `require-spec.sh` | **Blocks** edits to `lib/features/{name}/**` if `docs/features/{name}/SPEC.md` is missing | confirmed |
| `PostToolUse(Edit\|Write\|NotebookEdit)` | `spec-changelog-reminder.sh` | Emits reminder to update CHANGELOG when SPEC.md changes | confirmed |
| `PostToolUse(Edit\|Write\|NotebookEdit)` | `regenerate-index.sh` | Rewrites `docs/features/INDEX.md` from all SPEC.md frontmatter | confirmed |
| `Stop` | `verify-or-block.sh` | **Blocks** completion if `flutter analyze` or `flutter test` fails (only when `lib/` or `test/` has uncommitted changes) | confirmed |

Emergency bypass for all blocking hooks: `GOVERNANCE_BYPASS=1` (audited via shell history / process env).

## Scenarios

### Spec-gate — happy path
**Given** `docs/features/orders/SPEC.md` exists
**When** AI calls `Edit` on `lib/features/orders/data/repositories/order_repository_impl.dart`
**Then** `require-spec.sh` exits 0 and the edit proceeds

### Spec-gate — blocked
**Given** `docs/features/orders/SPEC.md` does NOT exist
**When** AI calls `Write` on `lib/features/orders/domain/entities/order_entity.dart`
**Then** `require-spec.sh` exits 2 with a message naming the missing path, and the edit is rejected

### Spec-gate — bypass
**Given** the env var `GOVERNANCE_BYPASS=1` is set
**When** AI calls `Edit` on `lib/features/orders/**` with no SPEC.md
**Then** the hook exits 0 immediately without checking

### Index regeneration — happy path
**Given** three feature folders exist with valid frontmatter
**When** any SPEC.md is edited
**Then** `regenerate-index.sh` rewrites `INDEX.md` with one row per feature, including the regeneration timestamp

### Index regeneration — non-SPEC edit
**Given** a CHANGELOG.md or PLAN.md is edited
**When** the PostToolUse hook fires
**Then** `regenerate-index.sh` matches its path filter and exits 0 without rewriting

### Verify-on-stop — happy path
**Given** no uncommitted changes under `lib/` or `test/`
**When** AI claims completion
**Then** `verify-or-block.sh` exits 0 immediately

### Verify-on-stop — block on analyzer error
**Given** uncommitted changes exist under `lib/` and `flutter analyze` would fail
**When** AI claims completion
**Then** `verify-or-block.sh` exits 2 with the analyzer tail, the Stop is rejected, and AI re-enters with the failure

### Verify-on-stop — block on test failure
**Given** uncommitted changes exist under `lib/` and `flutter test` would fail
**When** AI claims completion
**Then** `verify-or-block.sh` exits 2 with the test tail

### Verify-on-stop — no flutter available
**Given** `flutter` is not on PATH (e.g., fresh CI container)
**When** AI claims completion
**Then** `verify-or-block.sh` exits 0 silently — no false positives

### Changelog reminder
**Given** a SPEC.md is edited
**When** the PostToolUse hook fires
**Then** `spec-changelog-reminder.sh` emits a reminder naming the feature and the required follow-ups (CHANGELOG block, frontmatter bump, last_changed date)

## UI States

No Flutter UI. The "UI" of this feature is the generated `INDEX.md`. Its rendering rules:

- **Initial:** empty table with just the header row
- **One feature:** single row with frontmatter values
- **Missing frontmatter field:** the cell renders `?`
- **Missing `name:` field:** the cell falls back to the folder basename

## Navigation

No app routes. The "navigation" of this feature is the file-system convention:

```
docs/features/
├── INDEX.md
└── {name}/
    ├── SPEC.md
    ├── PLAN.md
    ├── CHANGELOG.md
    └── decisions/
```

## Acceptance Criteria

- [x] `.claude/hooks/require-spec.sh` written and executable
- [x] `.claude/hooks/verify-or-block.sh` written and executable
- [x] `.claude/hooks/regenerate-index.sh` written and executable
- [x] `.claude/hooks/spec-changelog-reminder.sh` written and executable
- [x] `.claude/settings.json` wires all four hooks to the correct events
- [x] `.claude/skills/feature-spec/SKILL.md` slimmed to format + tooling (no workflow modes)
- [x] `.claude/CLAUDE.md` updated with the governance model and hook reference table
- [x] `docs/features/users/SPEC.md` backfilled so the spec-gate doesn't block edits to the reference feature
- [x] `docs/features/INDEX.md` auto-generates on the next SPEC.md write
- [ ] End-to-end smoke test: attempt to edit a fictional `lib/features/nonexistent/foo.dart`, confirm the spec-gate blocks it
- [ ] `GOVERNANCE_BYPASS=1` honored by all blocking hooks

## Open Questions

- [ ] Should the Stop hook be gated by an explicit `claude/.verified` marker file to skip flutter runs when AI has already verified inline? — silmi to decide
- [ ] Do we need a `validate-frontmatter.sh` PostToolUse hook to catch malformed YAML before INDEX regeneration silently produces `?` cells? — silmi to decide
- [ ] Should `decisions/` ADRs also feed into INDEX.md (e.g., a "decisions count" column)? — likely no; keeps INDEX simple
