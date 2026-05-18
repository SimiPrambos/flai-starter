---
name: flai-responsive-ui
description: Use when writing widget sizes, spacing, font sizes, or any numeric dimension in this Flutter project. Covers ScreenUtil suffixes, design baseline, and when NOT to use const.
---

# Responsive UI

## Design Baseline

**375×812** (iPhone 13 mini). All sizes scale with ScreenUtil.

## Suffix Quick Reference

| Use case | Suffix | Example |
|---|---|---|
| Spacing / radius | `.r` | `16.r`, `BorderRadius.circular(12.r)` |
| Font size | `.sp` | `14.sp` |
| Fixed width / image size | `.w` | `48.w` |
| Fixed height | `.h` | `14.h` |

## Rules

- **Never** use raw `double` literals for sizes in widgets — always apply the suffix
- **Never** use `const` on `EdgeInsets`, `Gap`, or `SizedBox` that use `AppSpacing` — getters are runtime values
- `AppSpacing` and `AppTextStyles` already apply `.r`/`.sp` — use them as-is without adding suffixes again

## Common Mistakes

```dart
// BAD
Padding(padding: EdgeInsets.all(16))
Gap(8)
Text('Hello', style: TextStyle(fontSize: 14))

// GOOD
Padding(padding: EdgeInsets.all(16.r))
Gap(AppSpacing.sm)
Text('Hello', style: AppTextStyles.body)
```

## Shared Spacing / Text Helpers

- `AppSpacing.xs`, `AppSpacing.sm`, `AppSpacing.md`, `AppSpacing.lg`, `AppSpacing.xl`
- `AppTextStyles.headline`, `AppTextStyles.body`, `AppTextStyles.caption`
- `AppColors.*` for all reusable colors
