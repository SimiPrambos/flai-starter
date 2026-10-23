import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_theme.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppTheme.light', () {
    late ThemeData theme;

    Future<void> buildTheme(WidgetTester tester) => tester.pumpApp(
      Builder(
        builder: (_) {
          theme = AppTheme.light;
          return const SizedBox.shrink();
        },
      ),
      surfaceSize: const Size(375, 812),
    );

    testWidgets('uses Material 3 and the brand primary colors', (
      tester,
    ) async {
      await buildTheme(tester);

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.onPrimary, AppColors.onPrimary);
    });

    testWidgets('defines filled, outlined and icon button themes', (
      tester,
    ) async {
      await buildTheme(tester);
      const states = <WidgetState>{};

      final filled = theme.filledButtonTheme.style!;
      expect(filled.backgroundColor!.resolve(states), AppColors.primary);
      expect(filled.foregroundColor!.resolve(states), AppColors.onPrimary);
      final filledShape = filled.shape!.resolve(states)!;
      expect(
        (filledShape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(8),
      );

      final outlined = theme.outlinedButtonTheme.style!;
      expect(outlined.foregroundColor!.resolve(states), AppColors.primary);
      expect(
        outlined.side!.resolve(states),
        const BorderSide(color: AppColors.borderSubtle),
      );

      final icon = theme.iconButtonTheme.style!;
      expect(icon.fixedSize!.resolve(states), const Size.square(40));
    });

    testWidgets('input decoration uses semantic tokens', (tester) async {
      await buildTheme(tester);
      final input = theme.inputDecorationTheme;

      expect(input.filled, isTrue);
      expect(input.fillColor, AppColors.surface);
      expect(
        (input.enabledBorder! as OutlineInputBorder).borderSide.color,
        AppColors.borderSubtle,
      );
      expect(
        (input.focusedBorder! as OutlineInputBorder).borderSide.color,
        AppColors.primary,
      );
      expect(
        (input.errorBorder! as OutlineInputBorder).borderSide.color,
        AppColors.danger,
      );
      expect(input.hintStyle!.color, AppColors.textTertiary);
    });
  });
}
