import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/network/interceptors/error_interceptor.dart';

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
  });

  late ErrorInterceptor interceptor;
  late MockErrorInterceptorHandler handler;

  setUp(() {
    interceptor = ErrorInterceptor();
    handler = MockErrorInterceptorHandler();
  });

  DioException makeDioException({
    required DioExceptionType type,
    String? message,
    Response<dynamic>? response,
  }) => DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: type,
    message: message,
    response: response,
  );

  DioException capturedRejection(DioExceptionType type, {String? message}) {
    interceptor.onError(
      makeDioException(type: type, message: message),
      handler,
    );
    final captured = verify(() => handler.reject(captureAny())).captured;
    return captured.single as DioException;
  }

  group('ErrorInterceptor.onError', () {
    test('maps connectionTimeout to NetworkException', () {
      final rejected = capturedRejection(DioExceptionType.connectionTimeout);
      expect(rejected.error, isA<NetworkException>());
    });

    test('maps receiveTimeout to NetworkException', () {
      final rejected = capturedRejection(DioExceptionType.receiveTimeout);
      expect(rejected.error, isA<NetworkException>());
    });

    test('maps sendTimeout to NetworkException', () {
      final rejected = capturedRejection(DioExceptionType.sendTimeout);
      expect(rejected.error, isA<NetworkException>());
    });

    test('maps connectionError to NetworkException', () {
      final rejected = capturedRejection(DioExceptionType.connectionError);
      expect(rejected.error, isA<NetworkException>());
    });

    test('maps badResponse to ServerException with statusCode', () {
      final response = Response<void>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 404,
      );
      interceptor.onError(
        makeDioException(
          type: DioExceptionType.badResponse,
          response: response,
        ),
        handler,
      );
      final captured = verify(() => handler.reject(captureAny())).captured;
      final rejected = captured.single as DioException;
      expect(rejected.error, isA<ServerException>());
      expect((rejected.error! as ServerException).statusCode, 404);
    });

    test('maps unknown type to UnknownException', () {
      final rejected = capturedRejection(DioExceptionType.unknown);
      expect(rejected.error, isA<UnknownException>());
    });

    test('uses fallback message when err.message is null', () {
      final rejected = capturedRejection(DioExceptionType.connectionError);
      expect(
        (rejected.error! as NetworkException).message,
        'Connection error',
      );
    });
  });
}
