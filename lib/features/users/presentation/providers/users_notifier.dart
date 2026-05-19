import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/common/paginated_mixin.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';

part 'users_notifier.g.dart';

@riverpod
class UsersNotifier extends _$UsersNotifier with PaginatedMixin<UserEntity> {
  @override
  Future<List<UserEntity>> build() => buildPaginated();

  @override
  Future<PaginatedResult<UserEntity>> fetchPage(int page) async {
    final result = await ref.read(getUsersUseCaseProvider).call(page: page);
    return result.fold(
      // Failure is a sealed class used as the error type in AsyncNotifier;
      // Riverpod catches it and exposes it via AsyncError regardless of type.
      // ignore: only_throw_errors
      (failure) => throw failure,
      (paginated) => paginated,
    );
  }
}
