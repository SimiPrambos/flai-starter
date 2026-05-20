import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final type = context.vars['type'] as String;

  context.vars['isList'] = type == 'list';
  context.vars['isDetail'] = type == 'detail';
  context.vars['isSingle'] = type == 'single';
  context.vars['isStatic'] = type == 'static';
  context.vars['hasNotifier'] = type != 'static';
  context.vars['hasCard'] = type == 'list';
  context.vars['hasTest'] = type != 'static';
}
