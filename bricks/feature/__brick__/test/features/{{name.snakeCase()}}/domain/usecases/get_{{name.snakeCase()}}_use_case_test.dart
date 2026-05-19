import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{app_package}}/core/common/paginated_result.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}_entity.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/domain/usecases/get_{{name.snakeCase()}}_use_case.dart';

class _MockRepo extends Mock implements {{name.pascalCase()}}Repository {}

void main() {
  late _MockRepo mockRepo;
  late Get{{name.pascalCase()}}UseCase useCase;

  setUp(() {
    mockRepo = _MockRepo();
    useCase = Get{{name.pascalCase()}}UseCase(mockRepo);
  });

  test('delegates to repository', () async {
    const paginated = PaginatedResult<{{name.pascalCase()}}Entity>(
      items: [],
      currentPage: 1,
      totalPages: 1,
    );
    when(() => mockRepo.get{{name.pascalCase()}}(page: 1))
        .thenAnswer((_) async => right(paginated));

    final result = await useCase.call(page: 1);

    expect(result.isRight(), true);
    verify(() => mockRepo.get{{name.pascalCase()}}(page: 1)).called(1);
  });

  test('propagates failure from repository', () async {
    when(() => mockRepo.get{{name.pascalCase()}}(page: 1))
        .thenAnswer((_) async => left(const Failure.network(message: 'err')));

    final result = await useCase.call(page: 1);

    expect(result.isLeft(), true);
  });
}
