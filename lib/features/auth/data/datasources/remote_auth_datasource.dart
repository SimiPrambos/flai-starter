import 'package:template_vgv_app/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
  });
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  const MockAuthRemoteDataSource();

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return AuthModel(token: 'mock-token-${email.hashCode.abs()}');
  }
}
