import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
            Gap(AppSpacing.md),
            AppButton(
              label: context.l10n.errorRetry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
