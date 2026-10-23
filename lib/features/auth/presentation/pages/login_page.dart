import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/auth/session_notifier.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';
import 'package:template_vgv_app/shared/widgets/app_text_field.dart';

/// Mock sign-in screen.
///
/// The `auth` feature has no data or domain layer yet: the button only flips
/// the session flag, and the router redirect then moves the user to the home
/// tab. To swap in a real auth backend:
///
/// 1. Run `melos make-domain -- --name auth` and
///    `melos make-data -- --name auth`, then add
///    `login({required String email, required String password})`
///    returning `Either<Failure, Unit>` to `AuthRepository`.
/// 2. Add a `LoginNotifier` (`AsyncNotifier<void>`) that calls the repository
///    and stores the token with `SecureStorageService`
///    (`SecureStorageKeys.accessToken`).
/// 3. Keep the fields in a `ConsumerStatefulWidget` with
///    `TextEditingController`s, call the notifier from the button, and on
///    success call `ref.read(sessionNotifierProvider.notifier).signIn()`.
///    Show `failure.readableMessage` on error.
///
/// Never navigate from here; the redirect does it.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              label: l10n.loginEmailLabel,
              keyboardType: TextInputType.emailAddress,
            ),
            Gap(AppSpacing.lg),
            AppButton(
              label: l10n.loginSubmit,
              onPressed: () => unawaited(
                ref.read(sessionNotifierProvider.notifier).signIn(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
