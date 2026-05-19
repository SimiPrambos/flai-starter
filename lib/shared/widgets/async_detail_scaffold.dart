import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/shared/widgets/async_value_widget.dart';

class AsyncDetailScaffold<T> extends StatelessWidget {
  const AsyncDetailScaffold({
    required this.title,
    required this.value,
    required this.builder,
    this.skeleton,
    this.actions,
    super.key,
  });

  final String title;
  final AsyncValue<T> value;
  final Widget Function(T) builder;
  final Widget? skeleton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: AsyncValueWidget<T>(
        value: value,
        loading: skeleton,
        data: builder,
      ),
    );
  }
}
