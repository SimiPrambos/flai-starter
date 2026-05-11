import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int page,
  }) async {
    try {
      final response = await _datasource.getUsers(page);
      final entities = response.data.map((m) => m.toEntity()).toList();
      return right(entities);
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is NetworkException) {
        return left(Failure.network(message: appException.message));
      }
      if (appException is ServerException) {
        return left(
          Failure.server(
            message: appException.message,
            statusCode: appException.statusCode,
          ),
        );
      }
      return left(Failure.unknown(message: e.message ?? 'Unknown error'));
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
