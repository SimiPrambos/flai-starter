import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({required int page});
}
