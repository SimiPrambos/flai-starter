import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';

/// Reusable [BoxDecoration]s. Getters, because sizes use ScreenUtil.
abstract final class AppDecorators {
  /// Bar pinned to the bottom of a screen (e.g. a primary-action footer):
  /// surface fill, hairline top border and a soft upward shadow.
  static BoxDecoration get persistentFooter => BoxDecoration(
    color: AppColors.surface,
    border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 12.r,
        offset: Offset(0, -2.r),
      ),
    ],
  );
}
