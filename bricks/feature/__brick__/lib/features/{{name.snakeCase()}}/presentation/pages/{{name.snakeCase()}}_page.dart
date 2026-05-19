import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_notifier.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/presentation/widgets/{{name.snakeCase()}}_card.dart';
import 'package:{{app_package}}/shared/widgets/paginated_list_page.dart';

const _fake{{name.pascalCase()}} = {{name.pascalCase()}}Entity(id: 0);

class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read({{name.camelCase()}}NotifierProvider.notifier);
    return PaginatedListPage<{{name.pascalCase()}}Entity>(
      title: '{{name.pascalCase()}}',
      value: ref.watch({{name.camelCase()}}NotifierProvider),
      itemBuilder: (item) => {{name.pascalCase()}}Card(item: item),
      skeletonItem: const {{name.pascalCase()}}Card(item: _fake{{name.pascalCase()}}),
      onRefresh: notifier.refresh,
      onLoadMore: notifier.loadMore,
      hasMore: notifier.hasMore,
    );
  }
}
