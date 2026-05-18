import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';

class UserDetailSkeleton extends StatelessWidget {
  const UserDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Gap(AppSpacing.lg),
            Bone.circle(size: 120.r),
            Gap(AppSpacing.lg),
            Bone.text(width: 180.r),
            Gap(AppSpacing.xs),
            Bone.text(width: 140.r),
            Gap(AppSpacing.xl),
            const Divider(),
            Gap(AppSpacing.md),
            const Bone.multiText(lines: 3),
          ],
        ),
      ),
    );
  }
}
