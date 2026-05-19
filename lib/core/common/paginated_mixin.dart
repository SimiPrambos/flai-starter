import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';

mixin PaginatedMixin<T> on AutoDisposeAsyncNotifier<List<T>> {
  int _currentPage = 1;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  Future<PaginatedResult<T>> fetchPage(int page);

  Future<List<T>> buildPaginated() async {
    final result = await fetchPage(1);
    _currentPage = result.currentPage;
    _hasMore = result.hasMore;
    return result.items;
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final current = state.requireValue;
    final nextPage = _currentPage + 1;

    state = AsyncLoading<List<T>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final result = await fetchPage(nextPage);
      _currentPage = result.currentPage;
      _hasMore = result.hasMore;
      return [...current, ...result.items];
    });
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    ref.invalidateSelf();
    await future;
  }
}
