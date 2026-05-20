import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });
}
