import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_detail_skeleton.dart';
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

  setUp(() {
    mockRepo = MockUserRepository();
  });

  List<Override> overrides() => [
    userRepositoryProvider.overrideWithValue(mockRepo),
  ];

  group('UserDetailPage', () {
    test('can be constructed', () {
      final create = _identity(UserDetailPage.new);
      expect(create(id: 7), isA<UserDetailPage>());
    });

    testWidgets('shows skeleton while fetching', (tester) async {
      when(() => mockRepo.getUserById(id: 7)).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        return right(testUser);
      });

      await tester.pumpApp(
        const UserDetailPage(id: 7),
        overrides: overrides(),
      );

      expect(find.byType(UserDetailSkeleton), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('shows readable error message on failure', (tester) async {
      when(() => mockRepo.getUserById(id: 7)).thenAnswer(
        (_) async => left(const Failure.network(message: 'No internet')),
      );

      await tester.pumpApp(
        const UserDetailPage(id: 7),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.text('No internet'), findsOneWidget);
    });

    testWidgets('shows user details when user is found', (tester) async {
      when(() => mockRepo.getUserById(id: 7)).thenAnswer(
        (_) async => right(testUser),
      );

      await tester.pumpApp(
        const UserDetailPage(id: 7),
        overrides: overrides(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Michael Lawson'), findsOneWidget);
      expect(find.text('michael.lawson@reqres.in'), findsOneWidget);
      expect(find.text('#7'), findsOneWidget);
      expect(find.text('Michael'), findsOneWidget);
      expect(find.text('Lawson'), findsOneWidget);
    });
  });
}
