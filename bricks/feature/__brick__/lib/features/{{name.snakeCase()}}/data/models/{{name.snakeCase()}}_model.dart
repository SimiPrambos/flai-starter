import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';

part '{{name.snakeCase()}}_model.freezed.dart';
part '{{name.snakeCase()}}_model.g.dart';

@freezed
abstract class {{name.pascalCase()}}Model with _${{name.pascalCase()}}Model {
  const factory {{name.pascalCase()}}Model({
    required int id,
  }) = _{{name.pascalCase()}}Model;

  const {{name.pascalCase()}}Model._();

  factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}ModelFromJson(json);
}

extension {{name.pascalCase()}}ModelMapper on {{name.pascalCase()}}Model {
  {{name.pascalCase()}}Entity toEntity() => {{name.pascalCase()}}Entity(id: id);
}
