import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/network/dio_client.dart';

part 'remote_user_datasource.g.dart';

@riverpod
RemoteUserDataSource remoteUserDataSource(RemoteUserDataSourceRef ref) =>
    RemoteUserDataSource(ref.watch(dioClientProvider));

@RestApi()
abstract class RemoteUserDataSource {
  factory RemoteUserDataSource(Dio dio, {String baseUrl}) =
      _RemoteUserDataSource;

  @GET('/users')
  Future<Map<String, dynamic>> getUsers(@Query('page') int page);

  @GET('/users/{id}')
  Future<Map<String, dynamic>> getUser(@Path('id') int id);
}
