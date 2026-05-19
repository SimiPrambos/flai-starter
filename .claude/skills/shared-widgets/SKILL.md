---
name: shared-widgets
description: Use when using or building any shared widget in this Flutter project. Covers AppAvatar, PaginatedListPage, AsyncDetailScaffold, ErrorRetryWidget, and AsyncValueWidget.
---

# Shared Widgets

## `AppAvatar`

Replaces every `CachedNetworkImage` block for circular avatar images. Always use this instead of writing raw `CachedNetworkImage`.

```dart
AppAvatar(imageUrl: user.avatar, size: 48)   // list card
AppAvatar(imageUrl: user.avatar, size: 120)  // detail page
```

## `ErrorRetryWidget`

Standard error state for non-paginated screens. Used internally by `PaginatedListPage` — only use standalone for non-paginated error states.

```dart
ErrorRetryWidget(message: failure.readableMessage, onRetry: notifier.refresh)
```

## `PaginatedListPage<T>`

Encodes the full list page scaffold: RefreshIndicator, Skeletonizer, error+retry, ListView with load-more footer. A list page is ~15 lines.

```dart
class XPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(xNotifierProvider.notifier);
    return PaginatedListPage<XEntity>(
      title: 'X',
      value: ref.watch(xNotifierProvider),
      itemBuilder: (item) => XCard(item: item),
      skeletonItem: const XCard(item: _fakeX),
      onRefresh: notifier.refresh,
      onLoadMore: notifier.loadMore,
      hasMore: notifier.hasMore,
    );
  }
}
```

Escape hatches: `actions` (AppBar actions), `skeletonCount` (default 6).

## `AsyncDetailScaffold<T>`

Encodes the detail page scaffold: Scaffold, AppBar, AsyncValueWidget with optional skeleton. A detail page is ~10 lines.

```dart
class XDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncDetailScaffold<XEntity>(
      title: 'X Detail',
      value: ref.watch(xByIdNotifierProvider(id)),
      skeleton: const XDetailSkeleton(),
      builder: (item) => _XDetailContent(item: item),
    );
  }
}
```

Escape hatches: `actions` (AppBar actions), `skeleton` (optional — defaults to CircularProgressIndicator).

## `AsyncValueWidget<T>`

Already in the codebase. Handles loading/error/data states. Default error handler uses `Failure.readableMessage` when the error is a `Failure`. Use for non-paginated async content.

## Common Mistakes

- Writing raw `CachedNetworkImage` — use `AppAvatar`
- Hand-building the list page scaffold — use `PaginatedListPage`
- Hand-building `Scaffold + AppBar + AsyncValueWidget` — use `AsyncDetailScaffold`
- Passing a typed notifier to `PaginatedListPage` — pass callbacks and `hasMore` instead
