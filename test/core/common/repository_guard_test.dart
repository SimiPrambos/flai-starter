import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/common/repository_guard.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/error/failures.dart';

class _Repo with RepositoryGuard {}

void main() {
  late _Repo repo;
  setUp(() => repo = _Repo());

  group('RepositoryGuard.guardRequest', () {
    test('returns Right on success', () async {
      final result = await repo.guardRequest(() async => 42);
      expect(result, right<Failure, int>(42));
    });

    test(
      'returns Left(NetworkFailure) on NetworkException in DioException',
      () async {
        final result = await repo.guardRequest<int>(() async {
          throw DioException(
            requestOptions: RequestOptions(),
            error: const NetworkException(message: 'No internet'),
            type: DioExceptionType.connectionError,
          );
        });
        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );

    test(
      'returns Left(ServerFailure) on ServerException in DioException',
      () async {
        final result = await repo.guardRequest<int>(() async {
          throw DioException(
            requestOptions: RequestOptions(),
            error: const ServerException(message: 'Not found', statusCode: 404),
            type: DioExceptionType.badResponse,
          );
        });
        result.fold(
          (f) {
            expect(f, isA<ServerFailure>());
            expect((f as ServerFailure).statusCode, 404);
          },
          (_) => fail('Expected Left'),
        );
      },
    );

    test(
      'returns Left(UnknownFailure) on DioException without AppException',
      () async {
        final result = await repo.guardRequest<int>(() async {
          throw DioException(requestOptions: RequestOptions(), message: 'Oops');
        });
        result.fold(
          (f) {
            expect(f, isA<UnknownFailure>());
            expect((f as UnknownFailure).message, 'Oops');
          },
          (_) => fail('Expected Left'),
        );
      },
    );

    test('returns Left(UnknownFailure) on non-Dio exception', () async {
      final result = await repo.guardRequest<int>(
        () async => throw Exception('Boom'),
      );
      result.fold(
        (f) {
          expect(f, isA<UnknownFailure>());
          expect((f as UnknownFailure).message, contains('Boom'));
        },
        (_) => fail('Expected Left'),
      );
    });
  });
}
