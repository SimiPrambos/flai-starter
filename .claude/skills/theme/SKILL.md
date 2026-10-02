---
name: flai-theme
description: Use when choosing colors, text styles, spacing values, decorations, icons or the app ThemeData in this Flutter project. Covers AppTheme, AppColors brand and semantic tokens, AppTextStyles, AppSpacing, AppDecorators, Gap usage, flutter_gen assets and the Material-icons-only rule.
---

# Theme and Shared UI

All theme code lives in `lib/core/theme/`.

## `AppTheme`

```dart
MaterialApp.router(theme: AppTheme.light, ...)
```

- `AppTheme.light` is a **getter**, so `.r`/`.sp` read the live ScreenUtil scale. Access it only after `ScreenUtilInit` has built (in its `builder`). `App` and the `pumpApp` test helper already do this.
- It is built on `ColorScheme.fromSeed(seedColor: AppColors.primary)`, with `primary`/`onPrimary` pinned to the brand tokens.
- It defines `filledButtonTheme`, `outlinedButtonTheme`, `iconButtonTheme` and `inputDecorationTheme`. Radii use `.r`.
- Widgets should rely on these themes instead of restyling buttons or fields locally.

## `AppColors`

The brand palette (indigo):

| Token | Hex |
|---|---|
| `primary` | `#6366F1` |
| `secondary` | `#8B5CF6` |
| `error` | `#EF4444` |
| `background` | `#F9FAFB` |
| `surface` | `#FFFFFF` |
| `onPrimary` | `#FFFFFF` |
| `onSurface` | `#111827` |
| `onSurfaceVariant` | `#6B7280` |
| `divider` | `#E5E7EB` |
| `skeletonBase` | `#E5E7EB` |
| `skeletonHighlight` | `#F3F4F6` |

Semantic tokens:

| Group | Token | Hex | Use for |
|---|---|---|---|
| Status | `success` / `successContainer` | `#16A34A` / `#DCFCE7` | Positive state text/icon / background |
| | `warning` / `warningContainer` | `#D97706` / `#FEF3C7` | Caution |
| | `danger` / `dangerContainer` | `#DC2626` / `#FEE2E2` | Destructive actions, input errors |
| Surfaces | `surfaceSubtle` | `#F3F4F6` | Subtle fills (icon boxes, rows) |
| | `surfaceCanvas` | `#F8FAFC` | Page canvas behind cards, unselected chips |
| | `infoSurface` | `#EEF2FF` | Informational banners |
| Borders and text | `borderSubtle` | `#EAECF0` | Hairline borders, outlines |
| | `textTertiary` | `#7D8590` | Hints, inactive labels |
| | `onSurfaceDim` | `#4B5563` | Secondary body text (between `onSurface` and `onSurfaceVariant`) |
| Effects | `shadow` | `#111827` @ 8% | All box shadows |
| | `gradientStart` / `gradientEnd` | `#4F46E5` / `#7C3AED` | Header gradients |
| Avatar | `avatarFallback` | `#E0E7FF` | Placeholder background behind avatar initials or icons |

Add a token here before using a new color. Never write `Color(0x…)` in widgets.

## `AppTextStyles`

| Getter | Size / weight | Use for |
|---|---|---|
| `displayLg` | 32.sp / w700 | Hero names, big numbers |
| `titleMd` | 18.sp / w600 | Card and section titles |
| `bodyMd` | 14.sp / w400 | Body text, inputs |
| `labelSm` | 12.sp / w500, `onSurfaceVariant` | Captions, chips, field labels |

Prefer `AppTextStyles.x.copyWith(...)` over a fresh `TextStyle(...)`.

## `AppSpacing`

`xs` 4, `sm` 8, `md` 16, `lg` 24, `xl` 32, `xxl` 48 (all `.r`), and `sheetMargin` 18 (the bottom-sheet side inset).

Use `Gap(AppSpacing.*)` for spacing between widgets:

```dart
Gap(AppSpacing.sm)   // replaces SizedBox(height: 8)
Gap(AppSpacing.md)   // replaces SizedBox(height: 16)
```

## `AppDecorators`

Reusable `BoxDecoration` getters:

| Getter | Look |
|---|---|
| `persistentFooter` | `surface` fill, `borderSubtle` top hairline, `shadow` blur 12.r offset (0, −2.r) |

```dart
Container(
  decoration: AppDecorators.persistentFooter,
  padding: EdgeInsets.all(AppSpacing.md),
  child: AppButton(label: 'Save', onPressed: onSave),
)
```

## Icons

- **Material `Icons.*` only.** Never add or mix another icon set (Lucide, Cupertino glyphs as a style, Font Awesome, …).
- Prefer the `_outlined` variants for decorative or section icons, and the filled defaults for actions.
- Custom brand glyphs are SVG assets via flutter_gen (below), not an icon font.

## Assets

Use the generated `Assets` class (`lib/gen/assets.gen.dart`, flutter_gen). Never write raw `'assets/...'` strings.

```dart
import 'package:template_vgv_app/gen/assets.gen.dart';

Assets.icons.icHome.svg(width: 24.w, height: 24.w) // assets/icons/ic_home.svg
Assets.images.logo.image(width: 120.w)             // assets/images/logo.png
Assets.images.logo.provider()                      // ImageProvider
Assets.animations.empty                            // String path for other files (e.g. JSON)
```

- Drop files into `assets/icons/`, `assets/images/` or `assets/animations/`. These folders are already declared in `pubspec.yaml`.
- Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `Assets`.
- There is no bundled font; set one in the theme only if a consuming app ships it.

## Shared Widgets

Check `lib/shared/widgets/` before creating feature-local equivalents:

| Widget | When to use |
|---|---|
| `AppButton` | Any button (`filled`, `outlined`, `ghost` variants) |
| `AppAvatar` | Any network avatar image |
| `AppTextField` | Any text input |
| `AsyncValueWidget` | Render `AsyncValue` loading/error/data |
| `PaginatedListPage` | Paginated list screen with load more |
| `AsyncDetailScaffold` | Detail screen backed by an `AsyncValue` |
| `ErrorRetryWidget` | Error message with a retry button |

The `shared-widgets` skill has usage snippets.

## Rules

- Use `AppColors` (or `colorScheme`) over hex values and `Colors.*`.
- Use `AppTextStyles` over inline `TextStyle()`.
- Use `AppSpacing` constants over magic numbers.
- Prefer shared widgets before creating new ones.
- Do not put `const` on widgets that use `AppSpacing`, because its getters are runtime values.
- Use `Assets.*` (flutter_gen) over raw asset path strings.
- Use Material `Icons.*` only.

## Common Mistakes

```dart
// BAD
Color(0xFF2196F3)
Colors.white                       // as a surface/background
TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
SizedBox(height: 16)
Image.asset('assets/images/logo.png')
LucideIcons.user

// GOOD
AppColors.primary
AppColors.surface
AppTextStyles.titleMd
Gap(AppSpacing.md)
Assets.images.logo.image()
Icons.person
```
