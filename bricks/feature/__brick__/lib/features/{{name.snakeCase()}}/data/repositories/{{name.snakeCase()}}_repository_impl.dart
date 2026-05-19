import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/core/common/repository_guard.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/datasources/remote_{{name.snakeCase()}}_datasource.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';

part '{{name.snakeCase()}}_repository_impl.g.dart';

@Riverpod(keepAlive: true)
{{name.pascalCase()}}Repository {{name.camelCase()}}Repository(
  {{name.pascalCase()}}RepositoryRef ref,
) => {{name.pascalCase()}}RepositoryImpl(ref.watch(remote{{name.pascalCase()}}DataSourceProvider));

class {{name.pascalCase()}}RepositoryImpl
    with RepositoryGuard
    implements {{name.pascalCase()}}Repository {
  const {{name.pascalCase()}}RepositoryImpl(this._datasource);
  final Remote{{name.pascalCase()}}DataSource _datasource;

  @override
  Future<Either<Failure, PaginatedResult<{{name.pascalCase()}}Entity>>> get{{name.pascalCase()}}s({
    required int page,
  }) =>
      guardRequest(
        () async => (await _datasource.get{{name.pascalCase()}}s(page))
            .toPaginatedResult((m) => m.toEntity()),
      );

  @override
  Future<Either<Failure, {{name.pascalCase()}}Entity>> get{{name.pascalCase()}}ById({
    required int id,
  }) =>
      guardRequest(
        () async => (await _datasource.get{{name.pascalCase()}}(id)).data.toEntity(),
      );
}
