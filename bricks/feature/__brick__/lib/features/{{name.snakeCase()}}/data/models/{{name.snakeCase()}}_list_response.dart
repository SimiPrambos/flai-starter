import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{app_package}}/core/common/paged_response_mapper.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';

part '{{name.snakeCase()}}_list_response.freezed.dart';
part '{{name.snakeCase()}}_list_response.g.dart';

@freezed
class {{name.pascalCase()}}ListResponse
    with _${{name.pascalCase()}}ListResponse, PagedResponseMapper<{{name.pascalCase()}}Model> {
  const factory {{name.pascalCase()}}ListResponse({
    required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<{{name.pascalCase()}}Model> data,
  }) = _{{name.pascalCase()}}ListResponse;

  const {{name.pascalCase()}}ListResponse._();

  factory {{name.pascalCase()}}ListResponse.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}ListResponseFromJson(json);
}
