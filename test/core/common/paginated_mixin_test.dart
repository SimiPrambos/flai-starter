import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/common/paginated_mixin.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';

class _FakeNotifier extends AutoDisposeAsyncNotifier<List<int>>
    with PaginatedMixin<int> {
  List<PaginatedResult<int>> pages = [];
  int fetchCallCount = 0;

  @override
  Future<PaginatedResult<int>> fetchPage(int page) async {
    fetchCallCount++;
    return pages[page - 1];
  }

  @override
  Future<List<int>> build() => buildPaginated();
}

final _provider = AutoDisposeAsyncNotifierProvider<_FakeNotifier, List<int>>(
  _FakeNotifier.new,
);

ProviderContainer makeContainer(List<PaginatedResult<int>> pages) {
  final notifier = _FakeNotifier()..pages = pages;
  final container = ProviderContainer(
    overrides: [_provider.overrideWith(() => notifier)],
  );
  addTearDown(container.dispose);
  return container;
}

PaginatedResult<int> page(
  List<int> items, {
  int current = 1,
  int total = 1,
}) => PaginatedResult(items: items, currentPage: current, totalPages: total);

void main() {
  group('PaginatedMixin', () {
    test('build() returns first page items', () async {
      final container = makeContainer([
        page([1, 2, 3]),
      ]);
      final result = await container.read(_provider.future);
      expect(result, [1, 2, 3]);
    });

    test('hasMore is false when on last page', () async {
      final container = makeContainer([
        page([1]),
      ]);
      await container.read(_provider.future);
      expect(container.read(_provider.notifier).hasMore, false);
    });

    test('hasMore is true when more pages exist', () async {
      final container = makeContainer([
        page([1], total: 2),
      ]);
      await container.read(_provider.future);
      expect(container.read(_provider.notifier).hasMore, true);
    });

    test('loadMore() appends next page', () async {
      final container = makeContainer([
        page([1, 2], total: 2),
        page([3, 4], current: 2, total: 2),
      ]);
      await container.read(_provider.future);
      await container.read(_provider.notifier).loadMore();
      final result = await container.read(_provider.future);
      expect(result, [1, 2, 3, 4]);
    });

    test('loadMore() sets hasMore false on last page', () async {
      final container = makeContainer([
        page([1], total: 2),
        page([2], current: 2, total: 2),
      ]);
      await container.read(_provider.future);
      await container.read(_provider.notifier).loadMore();
      expect(container.read(_provider.notifier).hasMore, false);
    });

    test('loadMore() is no-op when hasMore is false', () async {
      final container = makeContainer([
        page([1]),
      ]);
      await container.read(_provider.future);
      final callsBefore = container.read(_provider.notifier).fetchCallCount;
      await container.read(_provider.notifier).loadMore();
      expect(container.read(_provider.notifier).fetchCallCount, callsBefore);
    });

    test('refresh() resets to page 1', () async {
      final container = makeContainer([
        page([1], total: 2),
        page([2], current: 2, total: 2),
      ]);
      await container.read(_provider.future);
      await container.read(_provider.notifier).loadMore();
      await container.read(_provider.notifier).refresh();
      final result = await container.read(_provider.future);
      expect(result, [1]);
    });

    test('refresh() resets hasMore', () async {
      final container = makeContainer([
        page([1], total: 2),
        page([2], current: 2, total: 2),
      ]);
      await container.read(_provider.future);
      await container.read(_provider.notifier).loadMore();
      expect(container.read(_provider.notifier).hasMore, false);
      await container.read(_provider.notifier).refresh();
      expect(container.read(_provider.notifier).hasMore, true);
    });
  });
}
