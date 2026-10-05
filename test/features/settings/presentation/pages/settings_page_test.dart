import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/auth/session_notifier.dart';
import 'package:template_vgv_app/core/auth/session_storage.dart';
import 'package:template_vgv_app/features/settings/presentation/pages/settings_page.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('SettingsPage', () {
    testWidgets('renders title and sign-out button', (tester) async {
      await tester.pumpApp(
        const SettingsPage(),
        overrides: [
          sessionStorageProvider.overrideWithValue(
            InMemorySessionStorage(signedIn: true),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Sign out'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('renders Indonesian strings for the id locale', (tester) async {
      await tester.pumpApp(
        const SettingsPage(),
        overrides: [
          sessionStorageProvider.overrideWithValue(
            InMemorySessionStorage(signedIn: true),
          ),
        ],
        locale: const Locale('id'),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Pengaturan'), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Keluar'), findsOneWidget);
    });

    testWidgets('tapping sign out clears the session', (tester) async {
      final storage = InMemorySessionStorage(signedIn: true);
      await tester.pumpApp(
        const SettingsPage(),
        overrides: [sessionStorageProvider.overrideWithValue(storage)],
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(SettingsPage)),
      );
      await container.read(sessionNotifierProvider.future);

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(await storage.read(), isFalse);
      expect(container.read(sessionNotifierProvider).value, isFalse);
    });
  });
}
