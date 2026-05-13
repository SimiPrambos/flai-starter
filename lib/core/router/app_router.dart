import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/features/users/presentation/pages/user_detail_page.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Route definitions
// ---------------------------------------------------------------------------

class UsersRoute extends GoRouteData {
  const UsersRoute();

  static const path = '/users';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UsersPage();
}

class UserDetailRoute extends GoRouteData {
  const UserDetailRoute({required this.id});

  static const path = ':id';

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      UserDetailPage(id: id);
}

// ---------------------------------------------------------------------------
// Navigation extensions  (type-safe — never use context.go('/string') directly)
// ---------------------------------------------------------------------------

extension UsersRouteX on UsersRoute {
  void go(BuildContext context) => context.go(UsersRoute.path);
  void push(BuildContext context) => context.push(UsersRoute.path);
}

extension UserDetailRouteX on UserDetailRoute {
  String get _location => '${UsersRoute.path}/$id';
  void go(BuildContext context) => context.go(_location);
  void push(BuildContext context) => context.push(_location);
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final talker = ref.watch(talkerProvider);
  return GoRouter(
    initialLocation: UsersRoute.path,
    observers: [TalkerRouteObserver(talker)],
    routes: [
      GoRoute(
        path: UsersRoute.path,
        builder: (context, state) => const UsersRoute().build(context, state),
        routes: [
          GoRoute(
            path: UserDetailRoute.path,
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return UserDetailRoute(id: id).build(context, state);
            },
          ),
        ],
      ),
    ],
  );
}
