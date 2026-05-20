import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';
import 'package:template_vgv_app/features/auth/presentation/providers/login_notifier.dart';
import 'package:template_vgv_app/shared/widgets/async_value_widget.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: AsyncValueWidget<AuthEntity?>(
        value: ref.watch(loginNotifierProvider),
        data: (item) => _LoginContent(item: item),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({required this.item});
  final AuthEntity? item;

  @override
  Widget build(BuildContext context) {
    if (item == null) return const Center(child: Text('Please log in.'));
    return Center(child: Text('Token: ${item!.token}'));
  }
}
