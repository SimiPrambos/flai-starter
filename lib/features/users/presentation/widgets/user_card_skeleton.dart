import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';

class UserCardSkeleton extends StatelessWidget {
  const UserCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: const ShimmerEffect(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        duration: Duration(milliseconds: 1200),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm / 2,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Bone.circle(size: 48.w),
              Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(width: double.infinity, fontSize: 14.sp),
                    Gap(AppSpacing.xs),
                    Bone.text(width: 140.w, fontSize: 12.sp),
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
