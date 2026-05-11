import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockUserRepository mockRepo;

  const testUser = UserEntity(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  setUp(() {
    mockRepo = MockUserRepository();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('UsersNotifier', () {
    test('build() returns users on success', () async {
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => right([testUser]));

      final container = makeContainer();
      final result = await container.read(usersNotifierProvider.future);

      expect(result, [testUser]);
    });

    test('build() throws Failure on repository error', () async {
      const failure = Failure.network(message: 'No connection');
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => left(failure));

      final container = makeContainer();

      await expectLater(
        container.read(usersNotifierProvider.future),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('refresh() re-fetches users', () async {
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => right([testUser]));

      final container = makeContainer();
      await container.read(usersNotifierProvider.future);

      await container.read(usersNotifierProvider.notifier).refresh();

      verify(() => mockRepo.getUsers(page: 1)).called(2);
    });
  });
}
