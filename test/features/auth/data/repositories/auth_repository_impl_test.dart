import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:template_vgv_app/features/auth/data/models/auth_model.dart';
import 'package:template_vgv_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';

class _MockDataSource extends MockAuthRemoteDataSource {
  Future<AuthModel> Function({required String email, required String password})?
  _loginImpl;

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) => _loginImpl != null
      ? _loginImpl!(email: email, password: password)
      : super.login(email: email, password: password);
}

void main() {
  late _MockDataSource mockDatasource;
  late AuthRepositoryImpl repo;

  setUp(() {
    mockDatasource = _MockDataSource();
    repo = AuthRepositoryImpl(mockDatasource);
  });

  group('AuthRepositoryImpl.login', () {
    test('returns Right with mapped entity on success', () async {
      const testEmail = 'test@example.com';
      mockDatasource._loginImpl =
          ({required String email, required String password}) async =>
              const AuthModel(token: 'test-token');

      final result = await repo.login(
        email: testEmail,
        password: 'password',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity, const AuthEntity(token: 'test-token')),
      );
    });

    test('returns Left(UnknownFailure) on unexpected exception', () async {
      mockDatasource._loginImpl =
          ({required String email, required String password}) =>
              Future.error(Exception('Unexpected'));

      final result = await repo.login(
        email: 'test@example.com',
        password: 'password',
      );

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
