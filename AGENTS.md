<!-- setup:start -->
# Setup — Required Tools

After cloning, run once:

```bash
dart pub global activate melos
melos bootstrap
```

`melos bootstrap` installs dependencies, links local packages, and activates git hooks automatically.

Then check and install CLI tools:

```bash
# GitNexus
npx gitnexus --version || npm install -g gitnexus && npx gitnexus analyze --index-only

# RTK
rtk --version || npm install -g @rtk/cli
```

**NEVER proceed with coding if any tool is missing.**

<!-- setup:end -->

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

> Index stale? Run `npx gitnexus analyze --index-only` first.

**Always:** when running analyze command must use `--index-only`.

**Always:** Run `gitnexus_impact({target, direction: "upstream"})` before editing any symbol. Run `gitnexus_detect_changes()` before committing. Warn user on HIGH/CRITICAL risk.

**Never:** Edit without impact analysis. Ignore HIGH/CRITICAL warnings. Rename with find-and-replace (use `gitnexus_rename`). Commit without `gitnexus_detect_changes()`.

**Explore:** `gitnexus_query({query})` over grep. `gitnexus_context({name})` for full symbol context.

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/flai-starter/context` | Overview, index freshness |
| `gitnexus://repo/flai-starter/clusters` | Functional areas |
| `gitnexus://repo/flai-starter/processes` | Execution flows |
| `gitnexus://repo/flai-starter/process/{name}` | Step-by-step trace |

| Task | Skill |
|------|-------|
| Architecture / "How does X work?" | `gitnexus-exploring` |
| Blast radius / "What breaks?" | `gitnexus-impact-analysis` |
| Trace bugs | `gitnexus-debugging` |
| Rename / refactor | `gitnexus-refactoring` |
| Tools / schema reference | `gitnexus-guide` |
| Index / status / CLI | `gitnexus-cli` |

<!-- gitnexus:end -->

<!-- dart-mcp:start -->
# Dart & Flutter MCP — Live Project Tooling

**Always:** Use Dart MCP to analyze errors, resolve symbols, search pub.dev, manage `pubspec.yaml`, and run tests. Never guess — fetch live data.

**Never:** Guess API signatures. Recommend packages without pub.dev search. Edit `pubspec.yaml` by hand. Claim a fix works without running analyzer + tests.

| Situation | Action |
|-----------|--------|
| Errors / warnings | Run analyzer |
| Using a class or method | Resolve symbol |
| Need a package | Search pub.dev |
| Adding a dependency | Use dependency tool |
| After changes | Run tests |
| App running | Introspect live state |

<!-- dart-mcp:end -->

<!-- context7 -->
# Context7 — Live Library Docs

Use for any library, framework, SDK, API, or CLI tool question — even well-known ones. Training data may be stale. Prefer over web search for library docs.

**Skip for:** refactoring, business logic debugging, code review, general programming concepts.

1. `resolve-library-id` with library name + question
2. Pick best match by: name, relevance, snippet count, reputation, benchmark score
3. `query-docs` with library ID + full question
4. Answer from fetched docs
<!-- context7 -->

<!-- rtk-instructions v2 -->
# RTK — Token-Optimized Commands

**Always prefix commands with `rtk`** — safe for all commands, even in `&&` chains.

```bash
# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

| Category | Commands | Savings |
|----------|----------|---------|
| Tests | `rtk jest/vitest/pytest/cargo test/playwright test` | 90-99% |
| Build | `rtk tsc/lint/prettier/next build/cargo build` | 70-90% |
| Git | `rtk git status/log/diff/add/commit/push/pull` | 59-80% |
| GitHub | `rtk gh pr view/checks/run list/issue list` | 26-87% |
| Packages | `rtk pnpm/npm/npx/prisma` | 70-90% |
| Files | `rtk ls/read/grep/find` | 60-75% |
| Infra | `rtk docker/kubectl` | 85% |
| Network | `rtk curl/wget` | 65-70% |
| Debug | `rtk err/log/json/deps/env/summary/diff` | 70-90% |
| Meta | `rtk gain/discover/proxy/init` | — |

Overall average: **60-90% token reduction**.
<!-- /rtk-instructions -->
