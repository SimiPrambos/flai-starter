# Contributing

## Pre-Push Checklist

Run these checks locally **in order** before pushing — they mirror what CI runs.

### 1. Code Generation

Regenerate files whenever you add or modify annotated classes:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Skip if you have not touched any `@riverpod`, `@freezed`, `@JsonSerializable`, `@RestApi`, or `@Envied` annotated code.

### 2. Format (line length 80)

Auto-fix first, then verify:

```sh
# Fix
dart format --line-length 80 .

# Verify (exits non-zero if anything changed)
dart format --line-length 80 --set-exit-if-changed .
```

### 3. Static Analysis

```sh
flutter analyze --fatal-infos
```

Expected output: `No issues found!` — `--fatal-infos` treats info-level lints as failures, matching CI.

### 4. Tests + Coverage

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

Install `lcov` once to inspect coverage locally:

```sh
brew install lcov
genhtml coverage/lcov.info -o coverage/ && open coverage/index.html
```

100% line coverage is required — every public API you add must have a corresponding test. Write the test before pushing.

### 5. Spell Check

CI runs `cspell` on every `*.md` file. Add new technical terms to
`.github/cspell.json` under `"words"`.

### 6. Quick One-Liner

```sh
dart run build_runner build --delete-conflicting-outputs && \
  dart format --line-length 80 --set-exit-if-changed . && \
  flutter analyze --fatal-infos && \
  flutter test --coverage --test-randomize-ordering-seed random
```

---

## Commit Message Format

Git hooks (activated by `melos bootstrap`) enforce [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description
```

| Type | When |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Maintenance — deps, config, tooling |
| `docs` | Documentation only |
| `refactor` | Code change, no feature or fix |
| `test` | Adding or fixing tests |
| `ci` | CI/CD pipeline changes |
| `perf` | Performance improvement |
| `style` | Formatting, no logic change |
| `build` | Build system changes |
| `revert` | Revert a previous commit |

Scope is optional: `feat(auth): add login with Apple`.
`!` marks a breaking change: `feat(api)!: remove deprecated endpoint`.

---

## Testing Strategy

| Layer | What to mock | Tool |
|---|---|---|
| UseCase | Domain repository | `mocktail` |
| Repository | Remote datasource | `mocktail` |
| Notifier | Repository (via provider override) | `mocktail` + `ProviderContainer` |
| Widget / Page | Providers (via override) | `pump_app.dart` helper |

Override `userRepositoryProvider` in tests — upstream datasource, Dio, and
network providers do not run.

```dart
final container = ProviderContainer(
  overrides: [
    userRepositoryProvider.overrideWithValue(MockUserRepository()),
  ],
);
```

---

## Working with Translations

The app supports **English** and **Bahasa Indonesia**.

### Adding Strings

Add to `lib/l10n/arb/app_en.arb`:

```arb
{
    "@@locale": "en",
    "exampleKey": "Example value",
    "@exampleKey": {
        "description": "Description for translators"
    }
}
```

Add the translation to `lib/l10n/arb/app_id.arb`:

```arb
{
    "@@locale": "id",
    "exampleKey": "Nilai contoh"
}
```

### Generating Translations

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Runs automatically on `flutter run`. Run manually before `flutter test` if you added new strings since the last run.

### Adding a New Locale

Update `CFBundleLocalizations` in `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>id</string>
    <string>your-new-locale</string>
</array>
```
