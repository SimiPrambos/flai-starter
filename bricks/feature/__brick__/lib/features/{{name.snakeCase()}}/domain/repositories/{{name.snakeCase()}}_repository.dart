import 'package:fpdart/fpdart.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';

abstract interface class {{name.pascalCase()}}void void Repository {
  Future<Either<Failure, PaginatedResult<{{name.pascalCase()}}Entity>>> get{{name.pascalCase()}}{
    int page,
  }
}
