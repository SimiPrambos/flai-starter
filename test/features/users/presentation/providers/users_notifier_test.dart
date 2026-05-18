import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
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

  PaginatedResult<UserEntity> page(
    List<UserEntity> items, {
    int current = 1,
    int total = 1,
  }) => PaginatedResult(items: items, currentPage: current, totalPages: total);

  group('UsersNotifier', () {
    test('build() returns users on success', () async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right(page([testUser])));

      final container = makeContainer();
      final result = await container.read(usersNotifierProvider.future);

      expect(result, [testUser]);
    });

    test('build() exposes hasMore from first page', () async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right(page([testUser], total: 2)));

      final container = makeContainer();
      await container.read(usersNotifierProvider.future);

      expect(container.read(usersNotifierProvider.notifier).hasMore, true);
    });

    test('build() throws Failure on repository error', () async {
      const failure = Failure.network(message: 'No connection');
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => left(failure));

      final container = makeContainer();

      await expectLater(
        container.read(usersNotifierProvider.future),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('refresh() re-fetches from page 1', () async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right(page([testUser])));

      final container = makeContainer();
      await container.read(usersNotifierProvider.future);

      await container.read(usersNotifierProvider.notifier).refresh();

      verify(() => mockRepo.getUsers(page: 1)).called(2);
    });

    test('loadMore() appends next page and updates hasMore', () async {
      final page2User = testUser.copyWith(id: 8);
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer(
        (_) async => right(page([testUser], total: 2)),
      );
      when(
        () => mockRepo.getUsers(page: 2),
      ).thenAnswer(
        (_) async => right(page([page2User], current: 2, total: 2)),
      );

      final container = makeContainer();
      await container.read(usersNotifierProvider.future);

      await container.read(usersNotifierProvider.notifier).loadMore();

      final combined = await container.read(usersNotifierProvider.future);
      expect(combined, [testUser, page2User]);
      expect(
        container.read(usersNotifierProvider.notifier).hasMore,
        false,
      );
    });

    test('loadMore() is no-op when hasMore is false', () async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right(page([testUser])));

      final container = makeContainer();
      await container.read(usersNotifierProvider.future);

      await container.read(usersNotifierProvider.notifier).loadMore();

      verifyNever(() => mockRepo.getUsers(page: 2));
    });
  });
}
