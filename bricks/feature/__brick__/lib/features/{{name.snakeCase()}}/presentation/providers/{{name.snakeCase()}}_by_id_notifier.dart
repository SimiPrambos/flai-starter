import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/{{name.snakeCase()}}_providers.dart';

part '{{name.snakeCase()}}_by_id_notifier.g.dart';

@riverpod
class {{name.pascalCase()}}ByIdNotifier extends _${{name.pascalCase()}}ByIdNotifier {
  @override
  Future<{{name.pascalCase()}}Entity> build(int id) async {
    final result = await ref
        .read({{name.camelCase()}}RepositoryProvider)
        .get{{name.pascalCase()}}ById(id: id);
    return result.fold(
      // ignore: only_throw_errors // Failure is not an Exception but is intentionally thrown
      (failure) => throw failure,
      (entity) => entity,
    );
  }
}
