import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/core/auth/session_notifier.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

/// Settings tab (shell branch 1). Signing out clears the session; the router
/// redirect then returns the user to `/login`.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            AppButton(
              label: l10n.settingsSignOut,
              variant: AppButtonVariant.outlined,
              icon: const Icon(Icons.logout),
              onPressed: () => unawaited(
                ref.read(sessionNotifierProvider.notifier).signOut(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
