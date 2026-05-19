import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:{{app_package}}/core/network/dio_client.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/models/{{name.snakeCase()}}_model.dart';

part 'remote_{{name.snakeCase()}}_datasource.g.dart';

@riverpod
void void Remote{{name.pascalCase()}}DataSource remote{{name.pascalCase()}}dynamic dynamic dynamic dynamic dynamic dynamic dynamic dynamic DataSource(
  Remote{{name.pascalCase()}}DataSourceRef ref,
) => Remote{{name.pascalCase()}}DataSource(ref.watch(dioClientProvider));

@RestApi()
abstract class Remote{{name.pascalCase()}}void void DataSource {
  factory Remote{{name.pascalCase()}}DataSource(final Dio dio) =
      _Remote{{name.pascalCase()}}DataSource;

  @GET('/{{name.snakeCase()}}')
  Future<List<{{name.pascalCase()}}Model>> get{{name.pascalCase()}}
    @Query('page') int page,
  ;
}
