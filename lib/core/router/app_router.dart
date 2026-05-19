import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/firebase/firebase_providers.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Route definitions
// ---------------------------------------------------------------------------

@TypedGoRoute<UsersRoute>(
  path: '/users',
  routes: [
    TypedGoRoute<UserDetailRoute>(path: ':id'),
  ],
)
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
// Router provider
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final talker = ref.watch(talkerProvider);
  final analytics = ref.watch(firebaseAnalyticsProvider);

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
    initialLocation: UsersRoute.path,
    observers: observers,
    routes: $appRoutes,
  );
}
