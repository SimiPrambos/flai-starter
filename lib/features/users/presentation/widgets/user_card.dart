import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/shared/widgets/app_avatar.dart';

class UserCard extends StatelessWidget {
  const UserCard({required this.user, super.key});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm / 2,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => UserDetailRoute(id: user.id).go(context),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              AppAvatar(imageUrl: user.avatar, size: 48),
              Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName, style: AppTextStyles.titleMd),
                    Gap(AppSpacing.xs),
                    Text(user.email, style: AppTextStyles.labelSm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
