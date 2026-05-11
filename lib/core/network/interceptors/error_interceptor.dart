import 'package:dio/dio.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError => NetworkException(
        message: err.message ?? 'Connection error',
      ),
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
