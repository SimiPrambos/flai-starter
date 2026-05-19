import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/common/paginated_mixin.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';

part '{{name.snakeCase()}}_notifier.g.dart';

// Wire the use case provider in a {{name.snakeCase()}}_providers.dart file
// similar to lib/features/users/users_providers.dart, then import it here.
@riverpod
class {{name.pascalCase()}}Notifier extends _${{name.pascalCase()}}Notifier
    with PaginatedMixin<{{name.pascalCase()}}Entity> {
  @override
  Future<List<{{name.pascalCase()}}Entity>> build() => buildPaginated();

  @override
  Future<PaginatedResult<{{name.pascalCase()}}Entity>> fetchPage(int page) async {
    // Replace with your use case provider, e.g.:
    // final result = await ref.read(get{{name.pascalCase()}}UseCaseProvider).call(page: page);
    throw UnimplementedError('Wire the use case and implement fetchPage');
  }
}
