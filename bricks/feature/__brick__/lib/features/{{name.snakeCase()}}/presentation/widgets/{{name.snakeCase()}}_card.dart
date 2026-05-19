import 'package:flutter/material.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';

class {{name.pascalCase()}}Card extends StatelessWidget {
  const {{name.pascalCase()}}Card({required this.item, super.key});
  final {{name.pascalCase()}}Entity item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('ID: ${item.id}'),
    );
  }
}
