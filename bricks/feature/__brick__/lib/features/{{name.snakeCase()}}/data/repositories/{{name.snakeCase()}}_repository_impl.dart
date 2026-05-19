import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/core/error/exceptions.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/datasources/remote_{{name.snakeCase()}}_datasource.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';

part '{{name.snakeCase()}}_repository_impl.g.dart';

@Riverpod(keepAlive: true)
{{name.pascalCase()}}void void Repository {{name.camelCase()}}Repository(
  {{name.pascalCase()}}RepositoryRef ref,
) => {{name.pascalCase()}}RepositoryImpl(ref.watch(remote{{name.pascalCase()}}DataSourceProvider));

class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}void void Repository {
  const {{name.pascalCase()}}RepositoryImpl(this._datasource);
  final Remote{{name.pascalCase()}}DataSource datasource;

  @override
  Future<Either<Failure, PaginatedResult<{{name.pascalCase()}}Entity>>> get{{name.pascalCase()}}({
    required int page,
  }) async {
    try {
      final response = await datasource.get{{name.pascalCase()}}page;
      return right(
        PaginatedResult(
          items: response.map((m) => m.toEntity()).toList(),
          currentPage: page,
          totalPages: 1,
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
}
