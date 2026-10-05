import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';

part '{{name.snakeCase()}}_single_response.freezed.dart';
part '{{name.snakeCase()}}_single_response.g.dart';

@freezed
abstract class {{name.pascalCase()}}SingleResponse with _${{name.pascalCase()}}SingleResponse {
  const factory {{name.pascalCase()}}SingleResponse({
    required {{name.pascalCase()}}Model data,
  }) = _{{name.pascalCase()}}SingleResponse;

  factory {{name.pascalCase()}}SingleResponse.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}SingleResponseFromJson(json);
}
