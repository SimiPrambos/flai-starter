import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/common/repository_guard.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:template_vgv_app/features/auth/data/models/auth_model.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';
import 'package:template_vgv_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl with RepositoryGuard implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);
  final AuthRemoteDataSource _datasource;

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) => guardRequest(
    () async =>
        (await _datasource.login(email: email, password: password)).toEntity(),
  );
}
