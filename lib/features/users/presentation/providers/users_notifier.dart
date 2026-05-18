import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';

part 'users_notifier.g.dart';

@riverpod
class UsersNotifier extends _$UsersNotifier {
  int _currentPage = 1;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  Future<List<UserEntity>> build() async {
    final page = await _fetchPage(page: 1);
    _currentPage = page.currentPage;
    _hasMore = page.hasMore;
    return page.items;
  }

  Future<PaginatedResult<UserEntity>> _fetchPage({required int page}) async {
    final result = await ref.read(getUsersUseCaseProvider).call(page: page);
    return result.fold(
      // Failure is a sealed class used as the error type in AsyncNotifier;
      // Riverpod catches it and exposes it via AsyncError regardless of type.
      // ignore: only_throw_errors
      (failure) => throw failure,
      (paginated) => paginated,
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final current = state.requireValue;
    final nextPage = _currentPage + 1;

    state = const AsyncLoading<List<UserEntity>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final page = await _fetchPage(page: nextPage);
      _currentPage = page.currentPage;
      _hasMore = page.hasMore;
      return [...current, ...page.items];
    });
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    ref.invalidateSelf();
    await future;
  }
}
