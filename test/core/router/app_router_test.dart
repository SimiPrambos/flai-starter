import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import '../../helpers/fakes.dart';

const _testUser = UserEntity(
  id: 7,
  email: 'michael.lawson@reqres.in',
  firstName: 'Michael',
  lastName: 'Lawson',
  avatar: 'https://reqres.in/img/faces/7-image.jpg',
);

Widget _appWithRouter(GoRouter router) => ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (_, _) => MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  ),
);

void main() {
  test('appRouterProvider creates a GoRouter', () {
    final talker = TalkerFlutter.init();
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(talker),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    expect(router, isA<GoRouter>());
  });

  group('appRouter route builders', () {
    late MockUserRepository mockRepo;
    late Talker talker;

    setUp(() {
      mockRepo = MockUserRepository();
      talker = TalkerFlutter.init();
    });

    testWidgets('navigates to UsersPage at /users', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async => right(
          const PaginatedResult(items: [], currentPage: 1, totalPages: 1),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            talkerProvider.overrideWithValue(talker),
            userRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: Consumer(
            builder: (_, ref, _) =>
                _appWithRouter(ref.watch(appRouterProvider)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UsersPage), findsOneWidget);
    });

    testWidgets('navigates to UserDetailPage on user card tap', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async => right(
          const PaginatedResult(
            items: [_testUser],
            currentPage: 1,
            totalPages: 1,
          ),
        ),
      );
      when(() => mockRepo.getUserById(id: 7)).thenAnswer(
        (_) async => right(_testUser),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            talkerProvider.overrideWithValue(talker),
            userRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: Consumer(
            builder: (_, ref, _) =>
                _appWithRouter(ref.watch(appRouterProvider)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(UserDetailPage), findsOneWidget);
    });
  });

  group('UsersRouteX', () {
    testWidgets('go navigates to /users', (tester) async {
      var location = '';
      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () => const UsersRoute().go(ctx),
                  child: const Text('go'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: UsersRoute.path,
            builder: (context, state) {
              location = state.uri.toString();
              return const Scaffold(body: Text('users'));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();

      expect(location, UsersRoute.path);
    });

    testWidgets('push navigates to /users', (tester) async {
      var location = '';
      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () => const UsersRoute().push(ctx),
                  child: const Text('push'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: UsersRoute.path,
            builder: (context, state) {
              location = state.uri.toString();
              return const Scaffold(body: Text('users'));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      expect(location, UsersRoute.path);
    });
  });

  group('UserDetailRouteX', () {
    testWidgets('push navigates to /users/:id', (tester) async {
      var location = '';
      final router = GoRouter(
        initialLocation: UsersRoute.path,
        routes: [
          GoRoute(
            path: UsersRoute.path,
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () => const UserDetailRoute(id: 7).push(ctx),
                  child: const Text('push'),
                ),
              ),
            ),
            routes: [
              GoRoute(
                path: UserDetailRoute.path,
                builder: (context, state) {
                  location = state.uri.toString();
                  return const Scaffold(body: Text('detail'));
                },
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      expect(location, '/users/7');
    });
  });
}
