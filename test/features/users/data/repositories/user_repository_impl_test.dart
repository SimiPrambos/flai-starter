import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/data/models/users_response.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockRemoteUserDataSource mockDatasource;
  late UserRepositoryImpl repo;

  const testModel = UserModel(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  setUp(() {
    mockDatasource = MockRemoteUserDataSource();
    repo = UserRepositoryImpl(mockDatasource);
  });

  group('UserRepositoryImpl.getUsers', () {
    test('returns mapped entities on success', () async {
      final testResponse = UsersResponse(
        page: 1,
        perPage: 6,
        total: 12,
        totalPages: 2,
        data: [testModel],
      );
      when(() => mockDatasource.getUsers(1))
          .thenAnswer((_) async => testResponse);

      final result = await repo.getUsers(page: 1);

      expect(result.isRight(), true);
      final users = result.getOrElse((_) => []);
      expect(users.length, 1);
      expect(users.first.email, 'michael.lawson@reqres.in');
      expect(users.first.fullName, 'Michael Lawson');
    });

    test('returns UnknownFailure when unexpected exception occurs', () async {
      when(() => mockDatasource.getUsers(1))
          .thenThrow(Exception('Unexpected'));

      final result = await repo.getUsers(page: 1);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
