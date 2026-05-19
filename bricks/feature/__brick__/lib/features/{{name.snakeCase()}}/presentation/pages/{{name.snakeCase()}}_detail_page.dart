import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_by_id_notifier.dart';
import 'package:{{app_package}}/shared/widgets/async_detail_scaffold.dart';

class {{name.pascalCase()}}DetailPage extends ConsumerWidget {
  const {{name.pascalCase()}}DetailPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncDetailScaffold<{{name.pascalCase()}}Entity>(
      title: '{{name.pascalCase()}} Detail',
      value: ref.watch({{name.camelCase()}}ByIdNotifierProvider(id)),
      builder: (item) => _{{name.pascalCase()}}DetailContent(item: item),
    );
  }
}

class _{{name.pascalCase()}}DetailContent extends StatelessWidget {
  const _{{name.pascalCase()}}DetailContent({required this.item});
  final {{name.pascalCase()}}Entity item;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('ID: ${item.id}'));
  }
}
