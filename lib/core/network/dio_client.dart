import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:template_vgv_app/core/env/env.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/network/connectivity_service.dart';
import 'package:template_vgv_app/core/network/interceptors/api_key_interceptor.dart';
import 'package:template_vgv_app/core/network/interceptors/connectivity_interceptor.dart';
import 'package:template_vgv_app/core/network/interceptors/error_interceptor.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(DioClientRef ref) {
  final talker = ref.watch(talkerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.addAll([
    ApiKeyInterceptor(),
    ConnectivityInterceptor(connectivity),
    ErrorInterceptor(),
    TalkerDioLogger(talker: talker),
  ]);

  return dio;
}
