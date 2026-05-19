import 'package:fpdart/fpdart.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';

class Get{{name.pascalCase()}}void void UseCase {
  const Get{{name.pascalCase()}}UseCase(this._repository);
  final {{name.pascalCase()}}Repository repository;

  Future<Either<Failure, PaginatedResult<{{name.pascalCase()}}Entity>>> call({
    required int page,
  }) => repository.get{{name.pascalCase()}}(page: page);
}
