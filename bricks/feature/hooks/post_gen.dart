import 'dart:io';
import 'package:mason/mason.dart';
import 'package:recase/recase.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final name = context.vars['name'] as String;
  final pascal = ReCase(name).pascalCase;
  final snake = ReCase(name).snakeCase;
  final appPackage = context.vars['app_package'] as String;

  // 1. Run build_runner
  final buildProgress = logger.progress('Running build_runner');
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

  // 2. Register route in app_router.dart
  final routerProgress = logger.progress('Registering route in app_router.dart');
  final routerFile = File('lib/core/router/app_router.dart');

  if (!routerFile.existsSync()) {
    routerProgress.fail('lib/core/router/app_router.dart not found');
    return;
  }

  var content = routerFile.readAsStringSync();

  final pageImport =
      "import 'package:$appPackage/features/$snake/presentation/pages/${snake}_page.dart';";
  final detailImport =
      "import 'package:$appPackage/features/$snake/presentation/pages/${snake}_detail_page.dart';";

  // Insert imports after the last features/ import line (keeps feature imports grouped)
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
        '$pageImport\n$detailImport\n' +
        content.substring(insertionPoint + 1);
  } else {
    // No existing features/ imports — fallback to after last import
    final lastImportIdx = content.lastIndexOf("import '");
    final endOfLastImport = content.indexOf('\n', lastImportIdx);
    content = content.substring(0, endOfLastImport + 1) +
        '$pageImport\n$detailImport\n' +
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

  // Append route classes at end of file
  final routeBlock = '''

@TypedGoRoute<${pascal}Route>(
  path: '/$snake',
  routes: [
    TypedGoRoute<${pascal}DetailRoute>(path: ':id'),
  ],
)
@immutable
class ${pascal}Route extends GoRouteData with _\$${pascal}Route {
  const ${pascal}Route();
  static const path = '/$snake';
  static const routeName = '$snake';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ${pascal}Page();
}

@immutable
class ${pascal}DetailRoute extends GoRouteData with _\$${pascal}DetailRoute {
  const ${pascal}DetailRoute({required this.id});
  static const path = ':id';
  static const routeName = '${snake}_detail';
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ${pascal}DetailPage(id: id);
}
''';

  content = '$content$routeBlock';
  routerFile.writeAsStringSync(content);
  routerProgress.complete('Route registered in app_router.dart');

  // 3. Run build_runner again to regenerate app_router.g.dart
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

  // 4. Print success
  logger.info('');
  logger.info('${lightGreen.wrap('✓')} Feature "$snake" scaffolded and wired.');
  logger.info('');
  logger.info(styleBold.wrap('Next steps:'));
  logger.info('');
  logger.info('1. Add API fields to ${snake}_model.dart and ${snake}_entity.dart');
  logger.info('2. Implement toEntity() in the model mapper extension');
  logger.info('3. Run: dart run build_runner build --delete-conflicting-outputs');
}
