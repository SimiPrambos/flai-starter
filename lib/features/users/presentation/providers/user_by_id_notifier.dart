import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';

part 'user_by_id_notifier.g.dart';

@riverpod
class UserByIdNotifier extends _$UserByIdNotifier {
  @override
  Future<UserEntity> build(int id) async {
    final result = await ref.read(userRepositoryProvider).getUserById(id: id);
    return result.fold(
      // ignore: only_throw_errors // Failure is a sealed class; Riverpod wraps it in AsyncError.
      (failure) => throw failure,
      (user) => user,
    );
  }
}
