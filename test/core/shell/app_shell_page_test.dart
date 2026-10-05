import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:template_vgv_app/core/shell/app_shell_page.dart';
import 'package:template_vgv_app/core/shell/tab_config.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/l10n/l10n.dart';

GoRouter _router(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShellPage(navigationShell: navigationShell, tabs: kAppTabs),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/a',
              builder: (_, _) => const Text('page-a'),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (_, _) => const Text('detail-a'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/b', builder: (_, _) => const Text('page-b')),
          ],
        ),
      ],
    ),
  ],
);

Future<void> _pumpShell(
  WidgetTester tester,
  String initialLocation, {
  Locale? locale,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp.router(
        routerConfig: _router(initialLocation),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AppShellPage', () {
    testWidgets('renders every tab with its l10n label and icon', (
      tester,
    ) async {
      await _pumpShell(tester, '/a');

      expect(find.text('page-a'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('uses Indonesian labels for the id locale', (tester) async {
      await _pumpShell(tester, '/a', locale: const Locale('id'));

      expect(find.text('Pengguna'), findsOneWidget);
      expect(find.text('Pengaturan'), findsOneWidget);
    });

    testWidgets('highlights the active tab with theme tokens', (tester) async {
      await _pumpShell(tester, '/a');

      final active = tester.widget<Icon>(find.byIcon(Icons.people_outline));
      final inactive = tester.widget<Icon>(
        find.byIcon(Icons.settings_outlined),
      );
      expect(active.color, AppColors.primary);
      expect(inactive.color, AppColors.onSurfaceDim);
    });

    testWidgets('tapping another tab switches branch', (tester) async {
      await _pumpShell(tester, '/a');

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.text('page-b'), findsOneWidget);
      expect(find.text('page-a'), findsNothing);
      final active = tester.widget<Icon>(find.byIcon(Icons.settings_outlined));
      expect(active.color, AppColors.primary);
    });

    testWidgets('switching tabs keeps the previous branch stack', (
      tester,
    ) async {
      await _pumpShell(tester, '/a/detail');
      expect(find.text('detail-a'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();

      expect(find.text('detail-a'), findsOneWidget);
    });

    testWidgets('re-tapping the active tab resets its branch', (tester) async {
      await _pumpShell(tester, '/a/detail');

      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();

      expect(find.text('page-a'), findsOneWidget);
      expect(find.text('detail-a'), findsNothing);
    });
  });
}
