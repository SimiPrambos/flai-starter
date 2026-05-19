import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

part 'user_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepositoryImpl(ref.watch(remoteUserDataSourceProvider));

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._datasource);
  final RemoteUserDataSource _datasource;

  @override
  Future<Either<Failure, PaginatedResult<UserEntity>>> getUsers({
    required int page,
  }) async {
    try {
      final response = await _datasource.getUsers(page);
      return right(
        PaginatedResult(
          items: response.data.map((m) => m.toEntity()).toList(),
          currentPage: response.page,
          totalPages: response.totalPages,
        ),
      );
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) return left(appException.toFailure());
      return left(Failure.unknown(message: e.message ?? 'Unknown error'));
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById({required int id}) async {
    try {
      final response = await _datasource.getUser(id);
      return right(response.data.toEntity());
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) return left(appException.toFailure());
      return left(Failure.unknown(message: e.message ?? 'Unknown error'));
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
