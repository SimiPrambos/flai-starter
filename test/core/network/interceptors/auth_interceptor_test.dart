import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/network/interceptors/auth_interceptor.dart';
import 'package:template_vgv_app/core/storage/secure_storage.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockGoRouter extends Mock implements GoRouter {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
  });

  late MockSecureStorageService mockStorage;
  late MockGoRouter mockRouter;
  late AuthInterceptor interceptor;

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockRouter = MockGoRouter();
    interceptor = AuthInterceptor(mockStorage, mockRouter);
  });

  group('AuthInterceptor.onRequest', () {
    test('adds Authorization header when token exists', () async {
      when(
        () => mockStorage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => 'my-token');
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer my-token');
      verify(() => handler.next(options)).called(1);
    });

    test('does not add Authorization header when token is null', () async {
      when(
        () => mockStorage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => null);
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });

    test('does not add Authorization header when token is empty', () async {
      when(
        () => mockStorage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => '');
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });
  });

  group('AuthInterceptor.onError', () {
    test('clears storage and redirects on 401', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});
      when(() => mockRouter.go(any())).thenReturn(null);
      final handler = MockErrorInterceptorHandler();
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      await interceptor.onError(err, handler);

      verify(() => mockStorage.deleteAll()).called(1);
      verify(() => mockRouter.go('/users')).called(1);
      verify(() => handler.next(err)).called(1);
    });

    test('forwards non-401 errors without side effects', () async {
      final handler = MockErrorInterceptorHandler();
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
        ),
      );

      await interceptor.onError(err, handler);

      verifyNever(() => mockStorage.deleteAll());
      verifyNever(() => mockRouter.go(any()));
      verify(() => handler.next(err)).called(1);
    });

    test('forwards errors with no response without side effects', () async {
      final handler = MockErrorInterceptorHandler();
      final err = DioException(requestOptions: RequestOptions(path: '/test'));

      await interceptor.onError(err, handler);

      verifyNever(() => mockStorage.deleteAll());
      verify(() => handler.next(err)).called(1);
    });
  });
}
