# Feature Specs

Each feature has its own folder. The structure and file schemas are defined by the `feature-spec` skill (`.claude/skills/feature-spec/SKILL.md`).

```
docs/features/
├── INDEX.md          ← auto-generated team dashboard (do not edit by hand)
└── {name}/
    ├── SPEC.md       ← source of truth (entity, API, scenarios, UI states, ACs)
    ├── PLAN.md       ← implementation plan (from superpowers:writing-plans)
    ├── CHANGELOG.md  ← what changed, newest first
    └── decisions/    ← ADRs for non-obvious choices (optional)
        └── NNN-*.md
```

## How governance works

Workflow is enforced by hooks in `.claude/settings.json`. The contract:

- **Spec before code** — `require-spec.sh` (PreToolUse) blocks any Edit/Write into `lib/features/{name}/**` if `docs/features/{name}/SPEC.md` is missing
- **Changelog reminders** — `spec-changelog-reminder.sh` (PostToolUse) fires whenever a SPEC.md changes
- **Auto-regenerated index** — `regenerate-index.sh` (PostToolUse) rewrites `INDEX.md` from frontmatter on every SPEC.md save
- **Verified completion** — `verify-or-block.sh` (Stop) re-runs `flutter analyze` + `flutter test` before completion claims succeed

`superpowers:*` skills drive the workflow (brainstorm → plan → TDD → verify → finish). `feature-spec` defines the artifact formats they write into.

## Creating a new feature

1. Run `superpowers:brainstorming` to explore intent and gather user stories
2. Use the `feature-spec` skill to learn the SPEC.md schema
3. Write `docs/features/{name}/SPEC.md` with valid YAML frontmatter
4. Create `docs/features/{name}/CHANGELOG.md` with the first entry
5. Run `superpowers:writing-plans` → `PLAN.md`
6. Scaffold via Mason; the spec-gate hook now allows code edits

INDEX.md regenerates automatically on every SPEC.md save.

## Status lifecycle

Set in SPEC.md frontmatter `status:` field.

```
draft        → SPEC.md exists, code not started
in-progress  → scaffolded, layers being implemented
review       → all acceptance criteria checked, tests pass
shipped      → merged to main; spec locked (material changes need a new ADR)
```
