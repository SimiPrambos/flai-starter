import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_user_by_id_use_case.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockUserRepository mockRepo;
  late GetUserByIdUseCase useCase;

  const testUser = UserEntity(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = GetUserByIdUseCase(mockRepo);
  });

  group('GetUserByIdUseCase', () {
    test('returns user on success', () async {
      when(
        () => mockRepo.getUserById(id: 7),
      ).thenAnswer((_) async => right(testUser));

      final result = await useCase(id: 7);

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (u) => expect(u, testUser));
      verify(() => mockRepo.getUserById(id: 7)).called(1);
    });

    test('propagates failure from repository', () async {
      const failure = Failure.network(message: 'No internet');
      when(
        () => mockRepo.getUserById(id: 7),
      ).thenAnswer((_) async => left(failure));

      final result = await useCase(id: 7);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
