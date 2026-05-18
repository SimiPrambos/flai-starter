import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

class GetUserByIdUseCase {
  const GetUserByIdUseCase(this._repository);
  final UserRepository _repository;

  Future<Either<Failure, UserEntity>> call({required int id}) =>
      _repository.getUserById(id: id);
}
