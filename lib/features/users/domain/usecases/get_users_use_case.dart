import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

part 'get_users_use_case.g.dart';

@riverpod
GetUsersUseCase getUsersUseCase(GetUsersUseCaseRef ref) =>
    GetUsersUseCase(ref.watch(userRepositoryProvider));

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);
  final UserRepository _repository;

  Future<Either<Failure, List<UserEntity>>> call({required int page}) =>
      _repository.getUsers(page: page);
}
