import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/common/paginated_response.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/common/repository_guard.dart';
import 'package:template_vgv_app/core/common/single_response.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

part 'user_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepositoryImpl(ref.watch(remoteUserDataSourceProvider));

class UserRepositoryImpl with RepositoryGuard implements UserRepository {
  const UserRepositoryImpl(this._datasource);
  final RemoteUserDataSource _datasource;

  @override
  Future<Either<Failure, PaginatedResult<UserEntity>>> getUsers({
    required int page,
  }) => guardRequest(
    () async => PaginatedResponse.fromJson(
      (await _datasource.getUsers(page)) as Map<String, dynamic>,
      UserModel.fromJson,
    ).toPaginatedResult((m) => m.toEntity()),
  );

  @override
  Future<Either<Failure, UserEntity>> getUserById({required int id}) =>
      guardRequest(
        () async => SingleResponse.fromJson(
          (await _datasource.getUser(id)) as Map<String, dynamic>,
          UserModel.fromJson,
        ).data.toEntity(),
      );
}
