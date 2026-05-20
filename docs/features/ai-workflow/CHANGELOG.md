# AI Workflow Governance — Changelog

## 2026-05-20 — Initial governance stack
**Trigger:** Engineer ask: "i want to governance the ai workflow"
**Changed:**
- Added four hooks under `.claude/hooks/`: `require-spec.sh` (PreToolUse), `spec-changelog-reminder.sh` + `regenerate-index.sh` (PostToolUse), `verify-or-block.sh` (Stop)
- Wired hooks in `.claude/settings.json` (preserved existing `UserPromptSubmit` reminder)
- Slimmed `.claude/skills/feature-spec/SKILL.md` from a four-mode workflow skill to a format + tooling contract
- Rewrote `.claude/CLAUDE.md` with a governance-model section pointing at hook enforcement
- Backfilled `docs/features/users/SPEC.md` so the reference feature isn't blocked by the spec-gate
- Created this meta-feature folder documenting the governance system using its own conventions

**Code affected:**
- `.claude/hooks/*.sh` (4 new files)
- `.claude/settings.json` (PreToolUse, PostToolUse, Stop sections added)
- `.claude/skills/feature-spec/SKILL.md` (rewrite)
- `.claude/CLAUDE.md` (rewrite)
- `docs/features/README.md` (refreshed for the new model)
- `docs/features/users/SPEC.md` (new)
- `docs/features/users/CHANGELOG.md` (new)
- `docs/features/ai-workflow/SPEC.md` (this feature)
- `docs/features/ai-workflow/CHANGELOG.md` (this file)

**Status:** applied
