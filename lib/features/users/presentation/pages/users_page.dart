import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card_shimmer.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(usersNotifierProvider.notifier).refresh(),
        child: usersAsync.when(
          loading: () => ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) => const UserCardShimmer(),
          ),
          error: (error, _) {
            final message = error is Failure
                ? error.readableMessage
                : error.toString();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: AppTextStyles.bodyMd,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.md),
                    AppButton(
                      label: 'Retry',
                      onPressed: () =>
                          ref.read(usersNotifierProvider.notifier).refresh(),
                    ),
                  ],
                ),
              ),
            );
          },
          data: (users) => ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: users.length,
            itemBuilder: (_, i) => UserCard(user: users[i]),
          ),
        ),
      ),
    );
  }
}
