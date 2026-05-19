import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_notifier.dart';

class {{name.pascalCase()}}Page extends ConsumerWidget {
  const {{name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({{name.camelCase()}}NotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('{{name.pascalCase()}}')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index].id.toString()),
          ),
        ),
      ),
    );
  }
}
