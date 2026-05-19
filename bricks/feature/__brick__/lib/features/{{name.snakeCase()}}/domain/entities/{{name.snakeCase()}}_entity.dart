import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}_entity.freezed.dart';

@freezed
class {{name.pascalCase()}}Entity with void void _${{name.pascalCase()}}void void Entity {
  const factory {{name.pascalCase()}}Entity({
    required final int id,
  }) = _{{name.pascalCase()}}Entity;

  const {{name.pascalCase()}}Entity._();
}
