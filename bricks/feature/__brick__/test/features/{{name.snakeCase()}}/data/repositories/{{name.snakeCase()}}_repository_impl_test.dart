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

  group('{{name.pascalCase()}}RepositoryImpl.get{{name.pascalCase()}}s', () {
    const listJson = <String, dynamic>{
      'page': 1,
      'total_pages': 1,
      'data': <dynamic>[<String, dynamic>{'id': 1}],
    };

    test('returns right with mapped entities on success', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}s(1))
          .thenAnswer((_) async => listJson);

      final result = await repo.get{{name.pascalCase()}}s(page: 1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (p) => expect(p.items.first.id, 1),
      );
    });

    test('returns Left(NetworkFailure) on NetworkException', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}s(1))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: const NetworkException(message: 'No internet'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repo.get{{name.pascalCase()}}s(page: 1);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(UnknownFailure) on unexpected exception', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}s(1))
          .thenThrow(Exception('Oops'));

      final result = await repo.get{{name.pascalCase()}}s(page: 1);

      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('{{name.pascalCase()}}RepositoryImpl.get{{name.pascalCase()}}ById', () {
    const singleJson = <String, dynamic>{
      'data': <String, dynamic>{'id': 1},
    };

    test('returns right with mapped entity on success', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}(1))
          .thenAnswer((_) async => singleJson);

      final result = await repo.get{{name.pascalCase()}}ById(id: 1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (e) => expect(e.id, 1),
      );
    });

    test('returns Left(ServerFailure) on 404', () async {
      when(() => mockDatasource.get{{name.pascalCase()}}(999))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: const ServerException(message: 'Not found', statusCode: 404),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repo.get{{name.pascalCase()}}ById(id: 999);

      result.fold(
        (f) {
          expect(f, isA<ServerFailure>());
          expect((f as ServerFailure).statusCode, 404);
        },
        (_) => fail('Expected Left'),
      );
    });
  });
}
