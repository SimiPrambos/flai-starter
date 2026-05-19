import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/paginated_list_page.dart';

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
    final notifier = ref.read(usersNotifierProvider.notifier);
    return PaginatedListPage<UserEntity>(
      title: context.l10n.usersPageTitle,
      value: ref.watch(usersNotifierProvider),
      itemBuilder: (user) => UserCard(user: user),
      skeletonItem: const UserCard(user: _fakeUser),
      onRefresh: notifier.refresh,
      onLoadMore: notifier.loadMore,
      hasMore: notifier.hasMore,
    );
  }
}
