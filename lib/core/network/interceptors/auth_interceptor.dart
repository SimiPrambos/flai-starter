import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:template_vgv_app/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage, this._router);

  final SecureStorageService _secureStorage;
  final GoRouter _router;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(
      key: SecureStorageKeys.accessToken,
    );
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.deleteAll();
      // TODO(auth): replace '/users' with '/login' once auth routes are added
      _router.go('/users');
    }
    handler.next(err);
  }
}
