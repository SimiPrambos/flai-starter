# Feature Specs

Each feature has its own folder maintained automatically by the `feature-spec` skill.

```
docs/features/
  {name}/
    SPEC.md        ← source of truth (entity, API, UI states, nav, ACs)
    CHANGELOG.md   ← auto-appended on every PRD change or code divergence
    decisions/     ← ADRs for non-obvious architectural choices
```

## How it works

The `feature-spec` skill is invoked automatically before any work in `lib/features/{name}/`.

- **New feature** → skill runs Create mode: reads PRD + Figma, writes SPEC.md, then picks the right mason bricks based on what the feature needs
- **Existing feature** → skill runs Follow mode: reads spec, summarizes constraints, proceeds
- **PRD changed** → skill runs Update mode: diffs, updates SPEC.md, runs GitNexus impact analysis, appends CHANGELOG

Do not edit SPEC.md manually — let the skill maintain it so the changelog stays accurate.
