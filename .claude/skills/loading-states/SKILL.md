---
name: flai-loading-states
description: Use when implementing loading placeholders, skeleton screens, or list loading states in this Flutter project. Covers skeletonizer usage, Bone widgets, naming conventions, and what to avoid.
---

# Loading States

## Package: `skeletonizer`

Use `Skeletonizer` / `Skeletonizer.zone` with `Bone` widgets or skeleton annotations.

**Do NOT** add or use the `shimmer` package.

## Naming

Skeleton widgets use a `Skeleton` suffix — never `Shimmer`:

```dart
// CORRECT
UserCardSkeleton

// NEVER
UserCardShimmer
```

## List Item Skeletons

For list loading states, create a skeleton widget that mirrors the real card shape.

Reference implementation: `UserCardSkeleton` (mirrors `UserCard` layout).

## Usage Pattern

```dart
Skeletonizer(
  enabled: isLoading,
  child: ListView.builder(
    itemCount: isLoading ? 6 : users.length,
    itemBuilder: (_, i) => isLoading
        ? const UserCardSkeleton()
        : UserCard(user: users[i]),
  ),
)
```

Or wrap a zone:

```dart
Skeletonizer.zone(
  child: Column(
    children: [
      Bone.text(width: 120),
      Bone.square(size: 48),
    ],
  ),
)
```

## Common Mistakes

- Using `shimmer` package → use `skeletonizer` only
- Naming widgets with `Shimmer` suffix → rename to `Skeleton`
- Showing empty space during loading instead of skeleton → always provide a skeleton
