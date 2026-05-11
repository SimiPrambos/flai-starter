import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/network/connectivity_service.dart';
import 'package:template_vgv_app/core/network/interceptors/connectivity_interceptor.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
    registerFallbackValue(RequestOptions());
  });

  late MockConnectivityService mockConnectivity;
  late ConnectivityInterceptor interceptor;
  late MockRequestInterceptorHandler handler;

  setUp(() {
    mockConnectivity = MockConnectivityService();
    interceptor = ConnectivityInterceptor(mockConnectivity);
    handler = MockRequestInterceptorHandler();
  });

  group('ConnectivityInterceptor.onRequest', () {
    test('forwards request when connected', () async {
      when(() => mockConnectivity.isConnected()).thenAnswer((_) async => true);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, handler);

      verify(() => handler.next(options)).called(1);
      verifyNever(() => handler.reject(any()));
    });

    test('rejects with NetworkException when disconnected', () async {
      when(() => mockConnectivity.isConnected()).thenAnswer((_) async => false);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, handler);

      final captured = verify(() => handler.reject(captureAny())).captured;
      final rejected = captured.single as DioException;
      expect(rejected.error, isA<NetworkException>());
      expect(
        (rejected.error! as NetworkException).message,
        'No internet connection',
      );
      verifyNever(() => handler.next(any()));
    });
  });
}
