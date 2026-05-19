import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{app_package}}/core/error/exceptions.dart';
import 'package:{{app_package}}/core/error/failures.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/datasources/remote_{{name.snakeCase()}}_datasource.dart';
import 'package:{{app_package}}/features/{{name.snakeCase()}}/data/repositories/{{name.snakeCase()}}_repository_impl.dart';

class _MockDataSource extends Mock implements Remote{{name.pascalCase()}}DataSource {}

void main() {
  late _MockDataSource mockDatasource;
  late {{name.pascalCase()}}RepositoryImpl repo;

  setUp(() {
    mockDatasource = _MockDataSource();
    repo = {{name.pascalCase()}}RepositoryImpl(mockDatasource);
  });

  group('{{name.pascalCase()}}RepositoryImpl.get{{name.pascalCase()}}', () {
    test('returns right on success', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}(1))
          .thenAnswer((_) async => []);

      final result = await repo.get{{name.pascalCase()}}(page: 1);

      expect(result.isRight(), true);
    });

    test(
        'returns NetworkFailure when NetworkException in DioException',
        () async {
      when(() => mockDatasource.get{{name.pascalCase()}}(1)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: const NetworkException(message: 'No internet'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repo.get{{name.pascalCase()}}(page: 1);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns UnknownFailure on unexpected exception', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}(1))
          .thenThrow(Exception('Unexpected'));

      final result = await repo.get{{name.pascalCase()}}(page: 1);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
