import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_decorators.dart';

import '../../helpers/pump_app.dart';

void main() {
  const surface = Size(375, 812);

  group('AppColors semantic tokens', () {
    test('every non-effect token is opaque', () {
      const tokens = [
        AppColors.success,
        AppColors.successContainer,
        AppColors.warning,
        AppColors.warningContainer,
        AppColors.danger,
        AppColors.dangerContainer,
        AppColors.surfaceSubtle,
        AppColors.infoSurface,
        AppColors.borderSubtle,
        AppColors.textTertiary,
        AppColors.onSurfaceDim,
      ];
      for (final color in tokens) {
        expect(color.a, 1);
      }
    });

    test('shadow is translucent', () {
      expect(AppColors.shadow.a, lessThan(1));
    });

    test('status containers differ from their base color', () {
      expect(AppColors.successContainer, isNot(AppColors.success));
      expect(AppColors.warningContainer, isNot(AppColors.warning));
      expect(AppColors.dangerContainer, isNot(AppColors.danger));
    });

    test('brand values are unchanged', () {
      expect(AppColors.primary, const Color(0xFF6366F1));
      expect(AppColors.onPrimary, const Color(0xFFFFFFFF));
      expect(AppColors.surface, const Color(0xFFFFFFFF));
    });
  });

  group('AppDecorators.persistentFooter', () {
    testWidgets('has a top hairline, surface fill and upward shadow', (
      tester,
    ) async {
      late BoxDecoration decoration;

      await tester.pumpApp(
        Builder(
          builder: (_) {
            decoration = AppDecorators.persistentFooter;
            return const SizedBox.shrink();
          },
        ),
        surfaceSize: surface,
      );

      final border = decoration.border! as Border;
      expect(border.top.color, AppColors.borderSubtle);
      expect(border.bottom, BorderSide.none);
      expect(decoration.color, AppColors.surface);
      expect(decoration.boxShadow!.single.color, AppColors.shadow);
      expect(decoration.boxShadow!.single.blurRadius, 12);
      expect(decoration.boxShadow!.single.offset, const Offset(0, -2));
    });
  });
}
