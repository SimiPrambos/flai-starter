import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_users_use_case.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockUserRepository mockRepo;
  late GetUsersUseCase useCase;

  const testUser = UserEntity(
    id: 1,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
  );

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = GetUsersUseCase(mockRepo);
  });

  group('GetUsersUseCase', () {
    test('returns PaginatedResult on success', () async {
      const paginated = PaginatedResult(
        items: [testUser],
        currentPage: 1,
        totalPages: 2,
      );
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right(paginated));

      final result = await useCase(page: 1);

      expect(result, right<Failure, PaginatedResult<UserEntity>>(paginated));
      verify(() => mockRepo.getUsers(page: 1)).called(1);
    });

    test('returns failure when repository fails', () async {
      const failure = Failure.network(message: 'No internet');
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(page: 1);

      expect(
        result,
        left<Failure, PaginatedResult<UserEntity>>(failure),
      );
    });

    test('delegates page param to repository', () async {
      when(() => mockRepo.getUsers(page: 2)).thenAnswer(
        (_) async => right(
          const PaginatedResult(items: [], currentPage: 2, totalPages: 2),
        ),
      );

      await useCase(page: 2);

      verify(() => mockRepo.getUsers(page: 2)).called(1);
    });
  });
}
