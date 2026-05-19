import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/common/paginated_mixin.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/{{name.snakeCase()}}_providers.dart';

part '{{name.snakeCase()}}_notifier.g.dart';

@riverpod
class {{name.pascalCase()}}Notifier extends _${{name.pascalCase()}}Notifier
    with PaginatedMixin<{{name.pascalCase()}}Entity> {
  @override
  Future<List<{{name.pascalCase()}}Entity>> build() => buildPaginated();

  @override
  Future<PaginatedResult<{{name.pascalCase()}}Entity>> fetchPage(int page) async {
    final result = await ref
        .read({{name.camelCase()}}RepositoryProvider)
        .get{{name.pascalCase()}}s(page: page);
    return result.fold(
      // ignore: only_throw_errors // Failure is not an Exception but is intentionally thrown
      (failure) => throw failure,
      (paginated) => paginated,
    );
  }
}
