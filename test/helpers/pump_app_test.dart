import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';

import 'pump_app.dart';

void main() {
  group('pumpApp', () {
    testWidgets('surfaceSize sets the logical screen size', (tester) async {
      late Size size;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            size = MediaQuery.sizeOf(context);
            return const SizedBox.shrink();
          },
        ),
        surfaceSize: const Size(375, 812),
      );

      expect(size, const Size(375, 812));
    });

    testWidgets('renders with AppTheme.light', (tester) async {
      late ColorScheme scheme;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            scheme = Theme.of(context).colorScheme;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(scheme.primary, AppColors.primary);
    });
  });

  group('suppressOverflowErrors', () {
    testWidgets('swallows RenderFlex overflow errors', (tester) async {
      suppressOverflowErrors();

      await tester.pumpApp(
        const Center(
          child: SizedBox(
            width: 10,
            child: Row(children: [SizedBox(width: 100)]),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
