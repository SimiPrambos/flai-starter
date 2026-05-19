import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_notifier.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/{{name.snakeCase()}}_providers.dart';

class _MockRepo extends Mock implements {{name.pascalCase()}}Repository {}

void main() {
  late _MockRepo mockRepo;

  const testEntity = {{name.pascalCase()}}Entity(id: 1);

  setUp(() => mockRepo = _MockRepo());

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [{{name.camelCase()}}RepositoryProvider.overrideWithValue(mockRepo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  PaginatedResult<{{name.pascalCase()}}Entity> page(
    List<{{name.pascalCase()}}Entity> items, {
    int current = 1,
    int total = 1,
  }) =>
      PaginatedResult(items: items, currentPage: current, totalPages: total);

  group('{{name.pascalCase()}}Notifier', () {
    test('build() returns entities on success', () async {
      when(() => mockRepo.get{{name.pascalCase()}}s(page: 1))
          .thenAnswer((_) async => right(page([testEntity])));

      final container = makeContainer();
      final result = await container.read({{name.camelCase()}}NotifierProvider.future);

      expect(result, [testEntity]);
    });

    test('build() throws Failure on repository error', () async {
      const failure = Failure.network(message: 'No connection');
      when(() => mockRepo.get{{name.pascalCase()}}s(page: 1))
          .thenAnswer((_) async => left(failure));

      final container = makeContainer();

      await expectLater(
        container.read({{name.camelCase()}}NotifierProvider.future),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}
