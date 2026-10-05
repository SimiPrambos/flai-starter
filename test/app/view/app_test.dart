import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:template_vgv_app/app/view/app.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';

void main() {
  group('App', () {
    Future<void> pumpSubject(WidgetTester tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: Align(alignment: Alignment.topCenter, child: TextField()),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appRouterProvider.overrideWithValue(router)],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('applies AppTheme.light and hides the debug banner', (
      tester,
    ) async {
      await pumpSubject(tester);

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, isFalse);
      expect(app.theme?.colorScheme.primary, AppColors.primary);
      expect(app.theme?.filledButtonTheme.style, isNotNull);
    });

    testWidgets('tapping outside a focused field removes focus', (
      tester,
    ) async {
      await pumpSubject(tester);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue);

      await tester.tapAt(const Offset(400, 500));
      await tester.pump();

      expect(editable.focusNode.hasFocus, isFalse);
    });
  });
}
