---
name: flai-theme
description: Use when choosing colors, text styles, spacing values, or shared UI components in this Flutter project. Covers AppColors, AppTextStyles, AppSpacing, Gap usage, and shared widget reuse.
---

# Theme and Shared UI

## Design Tokens

| Token | Use for |
|---|---|
| `AppColors.*` | All reusable colors |
| `AppTextStyles.*` | All text styles |
| `AppSpacing.*` | All spacing values |

## Spacing

Use `Gap(AppSpacing.*)` for simple spacing between widgets:

```dart
Gap(AppSpacing.sm)   // replaces SizedBox(height: 8)
Gap(AppSpacing.md)   // replaces SizedBox(height: 16)
Image.asset('assets/images/logo.png')
```

## Shared Widgets

Check before creating feature-local equivalents:

| Widget | When to use |
|---|---|
| `AppButton` | Any button |
| `AppTextField` | Any text input |
| `AsyncValueWidget` | Render `AsyncValue` loading/error/data |

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

## Rules

- Use `AppColors` over hardcoded hex values
- Use `AppTextStyles` over inline `TextStyle()`
- Use `AppSpacing` constants over magic numbers
- Prefer shared widgets before creating new ones
- Do not put `const` on widgets using `AppSpacing` — getters are runtime values
- Use `Assets.*` (flutter_gen) over raw asset path strings

## Common Mistakes

```dart
// BAD
Color(0xFF2196F3)
TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
SizedBox(height: 16)

// GOOD
AppColors.primary
AppTextStyles.headline
Gap(AppSpacing.md)
Assets.images.logo.image()
```
