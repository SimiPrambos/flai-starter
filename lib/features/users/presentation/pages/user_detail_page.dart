import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';

class UserDetailPage extends ConsumerWidget {
  const UserDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Failed to load user')),
        data: (users) {
          final user = users.where((u) => u.id == id).firstOrNull;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

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
                      color: AppColors.shimmerBase,
                    ),
                    errorWidget: (_, _, _) => Container(
                      width: 120.w,
                      height: 120.w,
                      color: AppColors.shimmerBase,
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
                _InfoRow(label: 'ID', value: '#${user.id}'),
                _InfoRow(label: 'First Name', value: user.firstName),
                _InfoRow(label: 'Last Name', value: user.lastName),
              ],
            ),
          );
        },
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
