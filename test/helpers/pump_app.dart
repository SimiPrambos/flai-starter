import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/theme/app_theme.dart';
import 'package:template_vgv_app/l10n/l10n.dart';

/// Suppresses RenderFlex overflow assertions in widget tests.
///
/// Call at the start of a test body (after `testWidgets` installs its own
/// error handler) when the production layout is correct but a tight test
/// viewport triggers overflow. Every other error is still reported.
void suppressOverflowErrors() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

extension PumpApp on WidgetTester {
  /// Pumps [widget] inside ProviderScope, ScreenUtilInit (375×812 design
  /// size), localization delegates and MaterialApp.
  ///
  /// Pass [surfaceSize] to fix the logical screen size. The device pixel
  /// ratio is forced to 1.0, so with `Size(375, 812)` every `x.r == x`.
  /// Both values are reset in teardown.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    Size? surfaceSize,
  }) {
    if (surfaceSize != null) {
      view
        ..physicalSize = surfaceSize
        ..devicePixelRatio = 1;
      addTearDown(view.resetPhysicalSize);
      addTearDown(view.resetDevicePixelRatio);
    }
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, _) => MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}
