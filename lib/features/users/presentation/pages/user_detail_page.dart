import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/user_by_id_notifier.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_detail_skeleton.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/async_value_widget.dart';

class UserDetailPage extends ConsumerWidget {
  const UserDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdNotifierProvider(id));
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.userDetailPageTitle)),
      body: AsyncValueWidget<UserEntity>(
        value: userAsync,
        loading: const UserDetailSkeleton(),
        data: (user) => _UserDetailContent(user: user),
      ),
    );
  }
}

class _UserDetailContent extends StatelessWidget {
  const _UserDetailContent({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Gap(AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(60.r),
            child: CachedNetworkImage(
              imageUrl: user.avatar,
              width: 120.w,
              height: 120.w,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 120.w,
                height: 120.w,
                color: AppColors.skeletonBase,
              ),
              errorWidget: (_, _, _) => Container(
                width: 120.w,
                height: 120.w,
                color: AppColors.skeletonBase,
                child: Icon(
                  Icons.person,
                  size: 60.r,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Gap(AppSpacing.lg),
          Text(user.fullName, style: AppTextStyles.displayLg),
          Gap(AppSpacing.xs),
          Text(user.email, style: AppTextStyles.labelSm),
          Gap(AppSpacing.xl),
          const Divider(),
          Gap(AppSpacing.md),
          _InfoRow(label: l10n.userFieldId, value: '#${user.id}'),
          _InfoRow(label: l10n.userFieldFirstName, value: user.firstName),
          _InfoRow(label: l10n.userFieldLastName, value: user.lastName),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.labelSm),
          Text(value, style: AppTextStyles.bodyMd),
        ],
      ),
    );
  }
}
