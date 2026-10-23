import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}_entity.freezed.dart';

@freezed
abstract class {{name.pascalCase()}}Entity with _${{name.pascalCase()}}Entity {
  const factory {{name.pascalCase()}}Entity({
    required int id,
  }) = _{{name.pascalCase()}}Entity;

  const {{name.pascalCase()}}Entity._();
}
