import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/auth/session_notifier.dart';
import 'package:template_vgv_app/core/auth/session_storage.dart';
import 'package:template_vgv_app/features/auth/presentation/pages/login_page.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';
import 'package:template_vgv_app/shared/widgets/app_text_field.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    testWidgets('renders title, email field and sign-in button', (
      tester,
    ) async {
      await tester.pumpApp(
        const LoginPage(),
        overrides: [
          sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Sign in'), findsOneWidget);
      expect(find.widgetWithText(AppTextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Sign in'), findsOneWidget);
    });

    testWidgets('tapping sign in persists the session', (tester) async {
      final storage = InMemorySessionStorage();
      await tester.pumpApp(
        const LoginPage(),
        overrides: [sessionStorageProvider.overrideWithValue(storage)],
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(LoginPage)),
      );
      // Mirror production: the router has already restored the session.
      await container.read(sessionNotifierProvider.future);

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(await storage.read(), isTrue);
      expect(container.read(sessionNotifierProvider).value, isTrue);
    });
  });
}
