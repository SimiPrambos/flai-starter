import 'package:flutter/material.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';

/// Shown at `/` while `sessionNotifierProvider` restores the session.
///
/// It never navigates. Once the session resolves, the router's
/// `refreshListenable` fires and `resolveRedirect` moves the user to `/login`
/// or to the home tab.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors.background,
    body: Center(child: CircularProgressIndicator()),
  );
}
