import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

const _fakeUser = UserEntity(
  id: 0,
  email: 'placeholder@email.com',
  firstName: 'First Name',
  lastName: 'Last Name',
  avatar: '',
);

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersNotifierProvider);
    final notifier = ref.read(usersNotifierProvider.notifier);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.usersPageTitle)),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: usersAsync.when(
          skipLoadingOnReload: true,
          loading: () => Skeletonizer(
            effect: const ShimmerEffect(
              baseColor: AppColors.skeletonBase,
              highlightColor: AppColors.skeletonHighlight,
              duration: Duration(milliseconds: 1200),
            ),
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (_, _) => const UserCard(user: _fakeUser),
            ),
          ),
          error: (error, _) {
            final message = error is Failure
                ? error.readableMessage
                : error.toString();
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
                      label: l10n.errorRetry,
                      onPressed: notifier.refresh,
                    ),
                  ],
                ),
              ),
            );
          },
          data: (users) {
            final isLoadingMore =
                usersAsync.isLoading && usersAsync.valueOrNull != null;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: users.length + 1,
              itemBuilder: (_, i) {
                if (i < users.length) return UserCard(user: users[i]);
                if (isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (notifier.hasMore) {
                  return Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: AppButton(
                      label: l10n.loadMore,
                      onPressed: notifier.loadMore,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
