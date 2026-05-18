import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';

part 'user_by_id_notifier.g.dart';

@riverpod
class UserByIdNotifier extends _$UserByIdNotifier {
  @override
  Future<UserEntity> build(int id) async {
    final result = await ref.read(getUserByIdUseCaseProvider).call(id: id);
    return result.fold(
      // Failure is a sealed class used as the error type in AsyncNotifier;
      // Riverpod catches it and exposes it via AsyncError regardless of type.
      // ignore: only_throw_errors
      (failure) => throw failure,
      (user) => user,
    );
  }
}
