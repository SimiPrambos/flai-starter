import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  group('UserCard', () {
    const user = UserEntity(
      id: 7,
      email: 'michael.lawson@reqres.in',
      firstName: 'Michael',
      lastName: 'Lawson',
      avatar: 'https://reqres.in/img/faces/7-image.jpg',
    );

    testWidgets('renders user details', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: UserCard(user: user)),
      );

      expect(find.text('Michael Lawson'), findsOneWidget);
      expect(find.text('michael.lawson@reqres.in'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('builds avatar error widget', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: UserCard(user: user)),
      );

      final image = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      final context = tester.element(find.byType(CachedNetworkImage));

      await tester.pumpApp(
        Scaffold(
          body: image.errorWidget!(
            context,
            user.avatar,
            Exception('failed'),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('navigates to user detail on tap', (tester) async {
      var navigatedLocation = '';

      final router = GoRouter(
        initialLocation: UsersRoute.path,
        routes: [
          GoRoute(
            path: UsersRoute.path,
            builder: (context, state) =>
                const Scaffold(body: UserCard(user: user)),
            routes: [
              GoRoute(
                path: UserDetailRoute.path,
                builder: (context, state) {
                  navigatedLocation = state.uri.toString();
                  return const Scaffold(body: Text('Detail'));
                },
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, __) => MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(navigatedLocation, '/users/7');
    });
  });
}
