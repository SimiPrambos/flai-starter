import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:template_vgv_app/features/auth/data/models/auth_model.dart';
import 'package:template_vgv_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';

class _MockDatasource extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockDatasource datasource;
  late AuthRepositoryImpl repo;

  const email = 'test@example.com';
  const password = 'secret';
  const model = AuthModel(token: 'tok123');

  setUp(() {
    datasource = _MockDatasource();
    repo = AuthRepositoryImpl(datasource);
  });

  group('login', () {
    test('returns AuthEntity on success', () async {
      when(
        () => datasource.login(email: email, password: password),
      ).thenAnswer((_) async => model);

      final result = await repo.login(email: email, password: password);

      expect(
        result,
        equals(right<Failure, AuthEntity>(const AuthEntity(token: 'tok123'))),
      );
    });

    test('returns Failure on exception', () async {
      when(
        () => datasource.login(email: email, password: password),
      ).thenThrow(Exception('network error'));

      final result = await repo.login(email: email, password: password);

      result.fold(
        (f) => expect(f, isA<Failure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
