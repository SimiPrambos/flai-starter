import 'package:flutter/material.dart';

/// Design color tokens. Widgets must read colors from here (or from
/// `Theme.of(context).colorScheme`), never from `Color(0x…)` literals.
abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  static const error = Color(0xFFEF4444);
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF111827);
  static const onSurfaceVariant = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E7EB);
  static const skeletonBase = Color(0xFFE5E7EB);
  static const skeletonHighlight = Color(0xFFF3F4F6);

  // Status
  static const success = Color(0xFF16A34A);
  static const successContainer = Color(0xFFDCFCE7);
  static const warning = Color(0xFFD97706);
  static const warningContainer = Color(0xFFFEF3C7);
  static const danger = Color(0xFFDC2626);
  static const dangerContainer = Color(0xFFFEE2E2);

  // Surfaces
  static const surfaceSubtle = Color(0xFFF3F4F6);
  static const infoSurface = Color(0xFFEEF2FF);

  // Borders and text
  static const borderSubtle = Color(0xFFEAECF0);
  static const textTertiary = Color(0xFF7D8590);
  static const onSurfaceDim = Color(0xFF4B5563);

  // Effects
  static const shadow = Color(0x14111827);
}
