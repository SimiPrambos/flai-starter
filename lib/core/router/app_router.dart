import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/auth/session_notifier.dart';
import 'package:template_vgv_app/core/firebase/firebase_providers.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/router/redirect_resolver.dart';
import 'package:template_vgv_app/core/shell/app_shell_page.dart';
import 'package:template_vgv_app/core/shell/tab_config.dart';
import 'package:template_vgv_app/features/auth/presentation/pages/login_page.dart';
import 'package:template_vgv_app/features/auth/presentation/pages/splash_page.dart';
import 'package:template_vgv_app/features/settings/presentation/pages/settings_page.dart';
import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Auth routes (outside the shell — no tab bar)
// ---------------------------------------------------------------------------

@TypedGoRoute<SplashRoute>(path: '/')
@immutable
class SplashRoute extends GoRouteData with _$SplashRoute {
  const SplashRoute();

  static const path = '/';
  static const routeName = 'splash';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData with _$LoginRoute {
  const LoginRoute();

  static const path = '/login';
  static const routeName = 'login';

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

// ---------------------------------------------------------------------------
// Signed-in shell — branch order MUST match kAppTabs
// ---------------------------------------------------------------------------

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<UsersBranch>(
      routes: [
        TypedGoRoute<UsersRoute>(
          path: '/users',
          routes: [
            TypedGoRoute<UserDetailRoute>(path: ':id'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsRoute>(path: '/settings'),
      ],
    ),
  ],
)
@immutable
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShellPage(navigationShell: navigationShell, tabs: kAppTabs);
}

class UsersBranch extends StatefulShellBranchData {
  const UsersBranch();
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

// ---------------------------------------------------------------------------
// Branch 0 — Users
// ---------------------------------------------------------------------------

@immutable
class UsersRoute extends GoRouteData with _$UsersRoute {
  const UsersRoute();

  static const path = '/users';
  static const routeName = 'users';

  @override
  Widget build(BuildContext context, GoRouterState state) => const UsersPage();
}

@immutable
class UserDetailRoute extends GoRouteData with _$UserDetailRoute {
  const UserDetailRoute({required this.id});

  static const path = ':id';
  static const routeName = 'user_detail';

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserDetailPage(id: id);
}

// ---------------------------------------------------------------------------
// Branch 1 — Settings
// ---------------------------------------------------------------------------

@immutable
class SettingsRoute extends GoRouteData with _$SettingsRoute {
  const SettingsRoute();

  static const path = '/settings';
  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final talker = ref.watch(talkerProvider);
  final analytics = ref.watch(firebaseAnalyticsProvider);
  final sessionListenable = _SessionChangeNotifier(ref);
  ref.onDispose(sessionListenable.dispose);

  final observers = <NavigatorObserver>[
    TalkerRouteObserver(talker),
    // coverage:ignore-start
    if (analytics != null)
      FirebaseAnalyticsObserver(
        analytics: analytics,
        onError: (error) => talker.handle(
          error,
          StackTrace.current,
          'Firebase Analytics route tracking failed',
        ),
      ),
    // coverage:ignore-end
  ];

  return GoRouter(
    initialLocation: SplashRoute.path,
    refreshListenable: sessionListenable,
    redirect: (context, state) {
      final session = ref.read(sessionNotifierProvider);
      // Stay on splash until the stored session has been read.
      if (session.isLoading) return null;
      return resolveRedirect(
        isSignedIn: session.valueOrNull ?? false,
        location: state.uri.path,
        loginPath: LoginRoute.path,
        splashPath: SplashRoute.path,
        homePath: UsersRoute.path,
      );
    },
    observers: observers,
    routes: $appRoutes,
  );
}

// ---------------------------------------------------------------------------
// Session listenable — re-runs `redirect` whenever the session changes
// ---------------------------------------------------------------------------

class _SessionChangeNotifier extends ChangeNotifier {
  _SessionChangeNotifier(Ref ref) {
    ref.listen(sessionNotifierProvider, (_, _) => notifyListeners());
  }
}
