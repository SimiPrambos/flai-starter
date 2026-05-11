import 'package:dio/dio.dart';
import 'package:template_vgv_app/core/env/env.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = Env.apiKey;
    handler.next(options);
  }
}
