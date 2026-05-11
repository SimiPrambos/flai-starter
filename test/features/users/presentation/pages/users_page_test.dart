import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card_shimmer.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';

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

  List<Override> overrides() => [
    userRepositoryProvider.overrideWithValue(mockRepo),
  ];

  group('UsersPage', () {
    testWidgets('shows shimmer while loading', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          return right([testUser]);
        },
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());

      expect(find.byType(UserCardShimmer), findsWidgets);

      // Drain the pending timer to avoid a leftover-timer assertion.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('shows user cards on success', (tester) async {
      when(
        () => mockRepo.getUsers(page: 1),
      ).thenAnswer((_) async => right([testUser]));

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
  });
}
