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
```

## Shared Widgets

Check before creating feature-local equivalents:

| Widget | When to use |
|---|---|
| `AppButton` | Any button |
| `AppTextField` | Any text input |
| `AsyncValueWidget` | Render `AsyncValue` loading/error/data |

## Rules

- Use `AppColors` over hardcoded hex values
- Use `AppTextStyles` over inline `TextStyle()`
- Use `AppSpacing` constants over magic numbers
- Prefer shared widgets before creating new ones
- Do not put `const` on widgets using `AppSpacing` — getters are runtime values

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
```
