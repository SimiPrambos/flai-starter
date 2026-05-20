import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/network/dio_client.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_list_response.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_single_response.dart';

part 'remote_{{name.snakeCase()}}_datasource.g.dart';

@riverpod
Remote{{name.pascalCase()}}DataSource remote{{name.pascalCase()}}DataSource(
  Remote{{name.pascalCase()}}DataSourceRef ref,
) => Remote{{name.pascalCase()}}DataSource(ref.watch(dioClientProvider));

@RestApi()
abstract class Remote{{name.pascalCase()}}DataSource {
  factory Remote{{name.pascalCase()}}DataSource(Dio dio, {String? baseUrl}) =
      _Remote{{name.pascalCase()}}DataSource;

  @GET('/{{name.snakeCase()}}')
  Future<{{name.pascalCase()}}ListResponse> get{{name.pascalCase()}}s(
    @Query('page') int page,
  );

  @GET('/{{name.snakeCase()}}/{id}')
  Future<{{name.pascalCase()}}SingleResponse> get{{name.pascalCase()}}(
    @Path('id') int id,
  );
}
