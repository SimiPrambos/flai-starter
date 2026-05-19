import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;

  final progress = logger.progress('Running build_runner');
  final result = await Process.run(
    'dart',
    ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
  );
  if (result.exitCode != 0) {
    progress.fail('build_runner failed');
    logger.err(result.stderr.toString());
    return;
  }
  progress.complete('build_runner done');

  final name = context.vars['name'] as String;
  logger.info('');
  logger.info('${lightGreen.wrap('✓')} Data layer for "$name" scaffolded.');
  logger.info('');
  logger.info(styleBold.wrap('Next steps:'));
  logger.info('1. Add API fields to ${name}_model.dart and ${name}_entity.dart');
  logger.info('2. Implement toEntity() in the model mapper extension');
  logger.info('3. Run: melos make-presentation -- --feature $name --name ... --type ...');
}
