import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:template_vgv_app/core/env/env.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/network/connectivity_service.dart';

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
    _ApiKeyInterceptor(),
    _ConnectivityInterceptor(connectivity),
    _ErrorInterceptor(),
    TalkerDioLogger(talker: talker),
  ]);

  return dio;
}

class _ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = Env.apiKey;
    handler.next(options);
  }
}

class _ConnectivityInterceptor extends Interceptor {
  _ConnectivityInterceptor(this._connectivity);
  final ConnectivityService _connectivity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connected = await _connectivity.isConnected();
    if (!connected) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const NetworkException(message: 'No internet connection'),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }
    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError =>
        NetworkException(message: err.message ?? 'Connection error'),
      DioExceptionType.badResponse => ServerException(
          message: err.message ?? 'Server error',
          statusCode: err.response?.statusCode ?? 0,
        ),
      _ => UnknownException(message: err.message ?? 'Unknown error'),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        type: err.type,
        response: err.response,
      ),
    );
  }
}
