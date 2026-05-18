import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('AppButton', () {
    Future<void> pumpButton(
      WidgetTester tester,
      AppButton button,
    ) {
      return tester.pumpApp(
        Scaffold(body: Center(child: button)),
      );
    }

    testWidgets('renders filled button and handles tap', (tester) async {
      var pressed = false;

      await pumpButton(
        tester,
        AppButton(
          label: 'Save',
          onPressed: () => pressed = true,
        ),
      );

      await tester.tap(find.byType(FilledButton));

      expect(find.text('Save'), findsOneWidget);
      expect(pressed, isTrue);
    });

    testWidgets('renders icon with label', (tester) async {
      await pumpButton(
        tester,
        AppButton(
          label: 'Add',
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('renders outlined variant', (tester) async {
      await pumpButton(
        tester,
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.outlined,
          onPressed: () {},
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders ghost variant', (tester) async {
      await pumpButton(
        tester,
        AppButton(
          label: 'Skip',
          variant: AppButtonVariant.ghost,
          onPressed: () {},
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('shows loading indicator and disables tap', (tester) async {
      var pressed = false;

      await pumpButton(
        tester,
        AppButton(
          label: 'Save',
          isLoading: true,
          onPressed: () => pressed = true,
        ),
      );

      await tester.tap(find.byType(FilledButton));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);
      expect(pressed, isFalse);
    });
  });
}
