import 'dart:io';
import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final feature = context.vars['feature'] as String;
  final name = context.vars['name'] as String;
  final type = context.vars['type'] as String;
  final appPackage = context.vars['app_package'] as String;

  final namePascal = ReCase(name).pascalCase;
  final nameSnake = ReCase(name).snakeCase;
  final featureSnake = ReCase(feature).snakeCase;
  final hasNotifier = type != 'static';
  final hasCard = type == 'list';

  // Step 0: dart format all generated files to fix trailing whitespace /
  // leading blank lines produced by mustache section rendering.
  final filesToFormat = [
    'lib/features/$featureSnake/presentation/pages/${nameSnake}_page.dart',
    if (hasNotifier)
      'lib/features/$featureSnake/presentation/providers/${nameSnake}_notifier.dart',
    if (hasCard)
      'lib/features/$featureSnake/presentation/widgets/${nameSnake}_card.dart',
    if (hasNotifier)
      'test/features/$featureSnake/presentation/providers/${nameSnake}_notifier_test.dart',
  ];
  await Process.run('dart', ['format', ...filesToFormat]);

  // Step 1: build_runner for notifier codegen (skip for static — no notifier)
  if (hasNotifier) {
    final buildProgress = logger.progress('Running build_runner (notifier)');
    final buildResult = await Process.run(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    );
    if (buildResult.exitCode != 0) {
      buildProgress.fail('build_runner failed');
      logger.err(buildResult.stderr.toString());
      return;
    }
    buildProgress.complete('build_runner done');
  }

  // Step 2: register route in app_router.dart
  final routerProgress = logger.progress('Registering route in app_router.dart');
  final routerFile = File('lib/core/router/app_router.dart');

  if (!routerFile.existsSync()) {
    routerProgress.fail('lib/core/router/app_router.dart not found');
    return;
  }

  var content = routerFile.readAsStringSync();

  final pageImport =
      "import 'package:$appPackage/features/$featureSnake/presentation/pages/${nameSnake}_page.dart';";

  // Insert import after the last features/ import line
  final featuresPattern = "import 'package:$appPackage/features/";
  var insertionPoint = -1;
  var searchIdx = 0;
  while (true) {
    final idx = content.indexOf(featuresPattern, searchIdx);
    if (idx == -1) break;
    insertionPoint = content.indexOf('\n', idx);
    searchIdx = insertionPoint + 1;
  }

  if (insertionPoint != -1) {
    content = content.substring(0, insertionPoint + 1) +
        '$pageImport\n' +
        content.substring(insertionPoint + 1);
  } else {
    final lastImportIdx = content.lastIndexOf("import '");
    final endOfLastImport = content.indexOf('\n', lastImportIdx);
    content = content.substring(0, endOfLastImport + 1) +
        '$pageImport\n' +
        content.substring(endOfLastImport + 1);
  }

  // Re-sort features/ import lines to satisfy directives_ordering lint
  final allLines = content.split('\n');
  final featuresImportLines = allLines
      .where((l) => l.startsWith("import 'package:$appPackage/features/"))
      .toList()
    ..sort();
  var featuresImportIdx = 0;
  content = allLines.map((line) {
    if (line.startsWith("import 'package:$appPackage/features/")) {
      return featuresImportLines[featuresImportIdx++];
    }
    return line;
  }).join('\n');

  // Build route class based on type
  final String routeBlock;
  if (type == 'detail') {
    routeBlock = '''

@TypedGoRoute<${namePascal}Route>(path: '/$nameSnake/:id')
@immutable
class ${namePascal}Route extends GoRouteData with _\$${namePascal}Route {
  const ${namePascal}Route({required this.id});
  static const path = '/$nameSnake/:id';
  static const routeName = '$nameSnake';
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ${namePascal}Page(id: id);
}
''';
  } else {
    routeBlock = '''

@TypedGoRoute<${namePascal}Route>(path: '/$nameSnake')
@immutable
class ${namePascal}Route extends GoRouteData with _\$${namePascal}Route {
  const ${namePascal}Route();
  static const path = '/$nameSnake';
  static const routeName = '$nameSnake';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ${namePascal}Page();
}
''';
  }

  content = '$content$routeBlock';
  routerFile.writeAsStringSync(content);
  routerProgress.complete('Route registered in app_router.dart');

  // Step 3: rebuild app_router.g.dart
  final routerBuildProgress = logger.progress('Regenerating app_router.g.dart');
  final routerBuildResult = await Process.run(
    'dart',
    ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
  );
  if (routerBuildResult.exitCode != 0) {
    routerBuildProgress.fail('build_runner failed for router');
    logger.err(routerBuildResult.stderr.toString());
    return;
  }
  routerBuildProgress.complete('app_router.g.dart updated');

  logger.info('');
  logger.info(
    '${lightGreen.wrap('✓')} "$nameSnake" ($type) added to feature "$featureSnake".',
  );
  logger.info('');
  if (type == 'single') {
    logger.info(
      styleBold.wrap(
        'Note: single type calls get${ReCase(feature).pascalCase}ById(id: 0) as a placeholder.',
      ),
    );
    logger.info(
      'Update the notifier to call the correct endpoint for this singleton resource.',
    );
  }
}
