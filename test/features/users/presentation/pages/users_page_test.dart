import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';

T _identity<T>(T value) => value;

void main() {
  late MockUserRepository mockRepo;

  const testUser = UserEntity(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  final manyUsers = List.generate(
    20,
    (index) => UserEntity(
      id: index,
      email: 'user$index@reqres.in',
      firstName: 'User',
      lastName: '$index',
      avatar: 'https://reqres.in/img/faces/$index-image.jpg',
    ),
  );

  setUp(() {
    mockRepo = MockUserRepository();
  });

  List<Override> overrides() => [
    userRepositoryProvider.overrideWithValue(mockRepo),
  ];

  PaginatedResult<UserEntity> singlePage(List<UserEntity> items) =>
      PaginatedResult(items: items, currentPage: 1, totalPages: 1);

  group('UsersPage', () {
    test('can be constructed', () {
      final createPage = _identity(UsersPage.new);

      expect(createPage(), isA<UsersPage>());
    });

    testWidgets('shows skeleton while loading', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          return right(singlePage([testUser]));
        },
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Michael Lawson'), findsNothing);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('shows user cards on success', (tester) async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right(singlePage([testUser])));

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      expect(find.byType(UserCard), findsOneWidget);
      expect(find.text('Michael Lawson'), findsOneWidget);
    });

    testWidgets('shows error message and retry button on failure', (
      tester,
    ) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async => left(const Failure.network(message: 'No internet')),
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      expect(find.text('No internet'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows non-failure error message', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenThrow(Exception('Boom'));

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      expect(find.text('Exception: Boom'), findsOneWidget);
    });

    testWidgets('retries from error state', (tester) async {
      var calls = 0;
      when(() => mockRepo.getUsers(page: 1)).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          return left(const Failure.network(message: 'No internet'));
        }
        return right(singlePage([testUser]));
      });

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Michael Lawson'), findsOneWidget);
      verify(() => mockRepo.getUsers(page: 1)).called(2);
    });

    testWidgets('pull to refresh re-fetches users', (tester) async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer(
        (_) async => right(
          PaginatedResult(items: manyUsers, currentPage: 1, totalPages: 3),
        ),
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      verify(() => mockRepo.getUsers(page: 1)).called(2);
    });

    testWidgets('shows load more button when hasMore is true', (tester) async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer(
        (_) async => right(
          const PaginatedResult(
            items: [testUser],
            currentPage: 1,
            totalPages: 2,
          ),
        ),
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      expect(find.text('Load More'), findsOneWidget);
    });

    testWidgets('tapping load more fetches page 2', (tester) async {
      final page2User = testUser.copyWith(id: 8, firstName: 'Janet');
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer(
        (_) async => right(
          const PaginatedResult(
            items: [testUser],
            currentPage: 1,
            totalPages: 2,
          ),
        ),
      );
      when(
        () => mockRepo.getUsers(page: 2),
      ).thenAnswer(
        (_) async => right(
          PaginatedResult(items: [page2User], currentPage: 2, totalPages: 2),
        ),
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Load More'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.getUsers(page: 2)).called(1);
      expect(find.byType(UserCard), findsNWidgets(2));
      expect(find.text('Load More'), findsNothing);
    });
  });
}
