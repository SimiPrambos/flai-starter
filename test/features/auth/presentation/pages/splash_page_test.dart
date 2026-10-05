import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/auth/presentation/pages/splash_page.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('SplashPage', () {
    testWidgets('shows a centered loader', (tester) async {
      await tester.pumpApp(const SplashPage());
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(Center),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });
  });
}
