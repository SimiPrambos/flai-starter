import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/auth/session_storage.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/core/shell/app_shell_page.dart';
import 'package:template_vgv_app/features/auth/presentation/pages/login_page.dart';
import 'package:template_vgv_app/features/auth/presentation/pages/splash_page.dart';
import 'package:template_vgv_app/features/settings/presentation/pages/settings_page.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

import '../../helpers/fakes.dart';

const _testUser = UserEntity(
  id: 7,
  email: 'michael.lawson@reqres.in',
  firstName: 'Michael',
  lastName: 'Lawson',
  avatar: 'https://reqres.in/img/faces/7-image.jpg',
);

/// Session read that never completes, so the router stays on splash.
class _PendingSessionStorage implements SessionStorage {
  @override
  Future<bool> read() => Completer<bool>().future;

  @override
  Future<void> write() async {}

  @override
  Future<void> clear() async {}
}

class _ThrowingSessionStorage implements SessionStorage {
  @override
  Future<bool> read() async => throw StateError('storage unavailable');

  @override
  Future<void> write() async {}

  @override
  Future<void> clear() async {}
}

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
  late MockUserRepository mockRepo;
  late Talker talker;

  setUp(() {
    mockRepo = MockUserRepository();
    talker = TalkerFlutter.init();
    when(() => mockRepo.getUsers(page: 1)).thenAnswer(
      (_) async => right(
        const PaginatedResult(
          items: [_testUser],
          currentPage: 1,
          totalPages: 1,
        ),
      ),
    );
    when(
      () => mockRepo.getUserById(id: 7),
    ).thenAnswer((_) async => right(_testUser));
  });

  /// Pumps the real `appRouterProvider` with the given session storage.
  Future<void> pumpRouterApp(
    WidgetTester tester, {
    required SessionStorage storage,
  }) => tester.pumpWidget(
    ProviderScope(
      overrides: [
        talkerProvider.overrideWithValue(talker),
        userRepositoryProvider.overrideWithValue(mockRepo),
        sessionStorageProvider.overrideWithValue(storage),
      ],
      child: Consumer(
        builder: (_, ref, _) => _appWithRouter(ref.watch(appRouterProvider)),
      ),
    ),
  );

  test('appRouterProvider creates a GoRouter', () {
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(TalkerFlutter.init()),
        sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(appRouterProvider), isA<GoRouter>());
  });

  group('appRouter route builders', () {
    testWidgets('navigates to UsersPage at /users inside the shell', (
      tester,
    ) async {
      await pumpRouterApp(
        tester,
        storage: InMemorySessionStorage(signedIn: true),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UsersPage), findsOneWidget);
      expect(find.byType(AppShellPage), findsOneWidget);
    });

    testWidgets('navigates to UserDetailPage on user card tap', (
      tester,
    ) async {
      await pumpRouterApp(
        tester,
        storage: InMemorySessionStorage(signedIn: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserCard).first);
      await tester.pumpAndSettle();

      expect(find.byType(UserDetailPage), findsOneWidget);
      // Detail is pushed inside branch 0, so the tab bar stays visible.
      expect(find.byType(AppShellPage), findsOneWidget);
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
                  onPressed: () => const UsersRoute().push<void>(ctx),
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
                  onPressed: () => const UserDetailRoute(id: 7).push<void>(ctx),
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

  group('auth routes', () {
    testWidgets('shows SplashPage while the session is loading', (
      tester,
    ) async {
      await pumpRouterApp(tester, storage: _PendingSessionStorage());
      await tester.pump();

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('LoginRoute builds LoginPage', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
          ],
          child: _appWithRouter(
            GoRouter(initialLocation: LoginRoute.path, routes: $appRoutes),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });

  group('redirect', () {
    testWidgets('cold start without a session lands on LoginPage', (
      tester,
    ) async {
      await pumpRouterApp(tester, storage: InMemorySessionStorage());
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(AppShellPage), findsNothing);
    });

    testWidgets('cold start with a session skips login', (tester) async {
      await pumpRouterApp(
        tester,
        storage: InMemorySessionStorage(signedIn: true),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UsersPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('a storage failure is treated as signed out', (tester) async {
      await pumpRouterApp(tester, storage: _ThrowingSessionStorage());
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('signing in on LoginPage lands on UsersPage', (tester) async {
      final storage = InMemorySessionStorage();
      await pumpRouterApp(tester, storage: storage);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(find.byType(UsersPage), findsOneWidget);
      expect(await storage.read(), isTrue);
    });

    testWidgets('signing out from SettingsPage returns to LoginPage', (
      tester,
    ) async {
      final storage = InMemorySessionStorage(signedIn: true);
      await pumpRouterApp(tester, storage: storage);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(await storage.read(), isFalse);
    });
  });

  group('shell tabs', () {
    testWidgets('Settings tab shows SettingsPage', (tester) async {
      await pumpRouterApp(
        tester,
        storage: InMemorySessionStorage(signedIn: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(UsersPage), findsNothing);
    });

    testWidgets('switching tabs keeps the Users branch stack', (tester) async {
      await pumpRouterApp(
        tester,
        storage: InMemorySessionStorage(signedIn: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserCard).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();

      expect(find.byType(UserDetailPage), findsOneWidget);
    });

    testWidgets('re-tapping the active tab resets its branch', (tester) async {
      await pumpRouterApp(
        tester,
        storage: InMemorySessionStorage(signedIn: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(UserCard).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();

      expect(find.byType(UserDetailPage), findsNothing);
      expect(find.byType(UsersPage), findsOneWidget);
    });
  });

  group('route data', () {
    test('shell and branch data classes are const-constructible', () {
      expect(const AppShellRoute(), isA<AppShellRoute>());
      expect(const UsersBranch(), isA<UsersBranch>());
      expect(const SettingsBranch(), isA<SettingsBranch>());
    });

    test('auth and settings route constants', () {
      expect(SplashRoute.path, '/');
      expect(SplashRoute.routeName, 'splash');
      expect(LoginRoute.path, '/login');
      expect(LoginRoute.routeName, 'login');
      expect(SettingsRoute.path, '/settings');
      expect(SettingsRoute.routeName, 'settings');
    });
  });
}
