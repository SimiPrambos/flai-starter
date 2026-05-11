import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/network/interceptors/api_key_interceptor.dart';

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  late ApiKeyInterceptor interceptor;
  late MockRequestInterceptorHandler handler;

  setUp(() {
    interceptor = ApiKeyInterceptor();
    handler = MockRequestInterceptorHandler();
  });

  test('adds x-api-key header and forwards request', () {
    final options = RequestOptions(path: '/test');

    interceptor.onRequest(options, handler);

    expect(options.headers['x-api-key'], isNotEmpty);
    verify(() => handler.next(options)).called(1);
  });
}
