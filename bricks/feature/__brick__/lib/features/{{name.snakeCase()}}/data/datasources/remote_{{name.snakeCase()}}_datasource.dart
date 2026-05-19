import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/network/dio_client.dart';

part 'remote_{{name.snakeCase()}}_datasource.g.dart';

@riverpod
Remote{{name.pascalCase()}}DataSource remote{{name.pascalCase()}}DataSource(
  Remote{{name.pascalCase()}}DataSourceRef ref,
) => Remote{{name.pascalCase()}}DataSource(ref.watch(dioClientProvider));

@RestApi()
abstract class Remote{{name.pascalCase()}}DataSource {
  factory Remote{{name.pascalCase()}}DataSource(Dio dio) =
      _Remote{{name.pascalCase()}}DataSource;

  @GET('/{{name.snakeCase()}}')
  Future<dynamic> get{{name.pascalCase()}}s(
    @Query('page') int page,
  );

  @GET('/{{name.snakeCase()}}/{id}')
  Future<dynamic> get{{name.pascalCase()}}(
    @Path('id') int id,
  );
}
