{{#isList}}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/domain/entities/{{feature.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_notifier.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/presentation/widgets/{{name.snakeCase()}}_card.dart';
import 'package:{{app_package}}/shared/widgets/paginated_list_page.dart';

const _fake{{feature.pascalCase()}} = {{feature.pascalCase()}}Entity(id: 0);

class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read({{name.camelCase()}}NotifierProvider.notifier);
    return PaginatedListPage<{{feature.pascalCase()}}Entity>(
      title: '{{name.pascalCase()}}',
      value: ref.watch({{name.camelCase()}}NotifierProvider),
      itemBuilder: (item) => {{name.pascalCase()}}Card(item: item),
      skeletonItem: const {{name.pascalCase()}}Card(item: _fake{{feature.pascalCase()}}),
      onRefresh: notifier.refresh,
      onLoadMore: notifier.loadMore,
      hasMore: notifier.hasMore,
    );
  }
}
{{/isList}}
{{#isDetail}}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/domain/entities/{{feature.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_notifier.dart';
import 'package:{{app_package}}/shared/widgets/async_detail_scaffold.dart';

class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncDetailScaffold<{{feature.pascalCase()}}Entity>(
      title: '{{name.pascalCase()}}',
      value: ref.watch({{name.camelCase()}}NotifierProvider(id)),
      builder: (item) => _{{name.pascalCase()}}Content(item: item),
    );
  }
}

class _{{name.pascalCase()}}Content extends StatelessWidget {
  const _{{name.pascalCase()}}Content({required this.item});
  final {{feature.pascalCase()}}Entity item;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ID: ${item.id}'));
  }
}
{{/isDetail}}
{{#isSingle}}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/domain/entities/{{feature.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{feature.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_notifier.dart';
import 'package:{{app_package}}/shared/widgets/async_value_widget.dart';

class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{name.pascalCase()}}')),
      body: AsyncValueWidget<{{feature.pascalCase()}}Entity>(
        value: ref.watch({{name.camelCase()}}NotifierProvider),
        builder: (item) => _{{name.pascalCase()}}Content(item: item),
      ),
    );
  }
}

class _{{name.pascalCase()}}Content extends StatelessWidget {
  const _{{name.pascalCase()}}Content({required this.item});
  final {{feature.pascalCase()}}Entity item;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ID: ${item.id}'));
  }
}
{{/isSingle}}
{{#isStatic}}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{name.pascalCase()}}')),
      body: const Center(child: Text('{{name.pascalCase()}}')),
    );
  }
}
{{/isStatic}}
