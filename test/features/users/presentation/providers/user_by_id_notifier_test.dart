import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/user_by_id_notifier.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';
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

  group('UserByIdNotifier', () {
    test('build() returns user on success', () async {
      when(
        () => mockRepo.getUserById(id: 7),
      ).thenAnswer((_) async => right(testUser));

      final container = makeContainer();
      final result = await container.read(userByIdNotifierProvider(7).future);

      expect(result, testUser);
    });

    test('build() throws Failure on repository error', () async {
      const failure = Failure.network(message: 'No connection');
      when(
        () => mockRepo.getUserById(id: 7),
      ).thenAnswer((_) async => left(failure));

      final container = makeContainer();

      await expectLater(
        container.read(userByIdNotifierProvider(7).future),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}
