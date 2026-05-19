import 'dart:io';
import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final name = context.vars['name'] as String;
  final pascal = ReCase(name).pascalCase;
  final snake = ReCase(name).snakeCase;
  final camel = ReCase(name).camelCase;
  final appPackage = context.vars['app_package'] as String;

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

  logger.info('');
  logger.info('${lightGreen.wrap('✓')} Feature "$snake" scaffolded.');
  logger.info('');
  logger.info(styleBold.wrap('Next steps:'));
  logger.info('');
  logger.info('1. Add API fields to ${snake}_model.dart and ${snake}_entity.dart');
  logger.info('2. Create lib/features/$snake/${snake}_providers.dart to wire the use case:');
  logger.info('');
  logger.info('''
   @riverpod
   Get${pascal}UseCase get${pascal}UseCase(Get${pascal}UseCaseRef ref) =>
       Get${pascal}UseCase(ref.watch(${camel}RepositoryProvider));
''');
  logger.info('3. Import it in ${snake}_notifier.dart and replace the fetchPage stub.');
  logger.info('4. Add route to lib/core/router/app_router.dart:');
  logger.info('');
  logger.info('''
   @TypedGoRoute<${pascal}Route>(path: '/$snake')
   @immutable
   class ${pascal}Route extends GoRouteData with _\$${pascal}Route {
     const ${pascal}Route();
     static const path = '/$snake';
     static const routeName = '$snake';

     @override
     Widget build(BuildContext context, GoRouterState state) =>
         const ${pascal}Page();
   }
''');
  logger.info('   Then run build_runner — \$appRoutes updates automatically.');
  logger.info('5. Run: melos check');
}
