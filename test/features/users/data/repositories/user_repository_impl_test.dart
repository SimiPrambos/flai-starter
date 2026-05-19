import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/common/paginated_result.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/data/models/user_single_response.dart';
import 'package:template_vgv_app/features/users/data/models/users_response.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockRemoteUserDataSource mockDatasource;
  late UserRepositoryImpl repo;

  const testModel = UserModel(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  setUp(() {
    mockDatasource = MockRemoteUserDataSource();
    repo = UserRepositoryImpl(mockDatasource);
  });

  group('UserRepositoryImpl.getUsers', () {
    test('returns PaginatedResult with mapped entities on success', () async {
      const testResponse = UsersResponse(
        page: 1,
        perPage: 6,
        total: 12,
        totalPages: 2,
        data: [testModel],
      );
      when(
        () => mockDatasource.getUsers(1),
      ).thenAnswer((_) async => testResponse);

      final result = await repo.getUsers(page: 1);

      expect(result.isRight(), true);
      final paginated = result.getOrElse(
        (_) => const PaginatedResult(items: [], currentPage: 1, totalPages: 1),
      );
      expect(paginated.items.length, 1);
      expect(paginated.items.first.email, 'michael.lawson@reqres.in');
      expect(paginated.items.first.fullName, 'Michael Lawson');
      expect(paginated.currentPage, 1);
      expect(paginated.totalPages, 2);
      expect(paginated.hasMore, true);
    });

    test('returns UnknownFailure when unexpected exception occurs', () async {
      when(() => mockDatasource.getUsers(1)).thenThrow(Exception('Unexpected'));

      final result = await repo.getUsers(page: 1);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'returns NetworkFailure when NetworkException in DioException',
      () async {
        when(() => mockDatasource.getUsers(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            error: const NetworkException(message: 'No internet connection'),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await repo.getUsers(page: 1);

        expect(result.isLeft(), true);
        result.fold(
          (f) {
            expect(f, isA<NetworkFailure>());
            expect(
              (f as NetworkFailure).message,
              'No internet connection',
            );
          },
          (_) => fail('Expected Left'),
        );
      },
    );

    test(
      'returns ServerFailure when ServerException in DioException',
      () async {
        when(() => mockDatasource.getUsers(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            error: const ServerException(message: 'Not found', statusCode: 404),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repo.getUsers(page: 1);

        expect(result.isLeft(), true);
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
      'returns UnknownFailure when DioException has no app exception',
      () async {
        when(() => mockDatasource.getUsers(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            message: 'Something went wrong',
          ),
        );

        final result = await repo.getUsers(page: 1);

        expect(result.isLeft(), true);
        result.fold(
          (f) {
            expect(f, isA<UnknownFailure>());
            expect((f as UnknownFailure).message, 'Something went wrong');
          },
          (_) => fail('Expected Left'),
        );
      },
    );
  });

  group('UserRepositoryImpl.getUserById', () {
    test('returns mapped entity on success', () async {
      const testResponse = UserSingleResponse(data: testModel);
      when(
        () => mockDatasource.getUser(7),
      ).thenAnswer((_) async => testResponse);

      final result = await repo.getUserById(id: 7);

      expect(result.isRight(), true);
      final user = result.getOrElse((_) => throw Exception('Expected Right'));
      expect(user.id, 7);
      expect(user.email, 'michael.lawson@reqres.in');
      expect(user.fullName, 'Michael Lawson');
    });

    test(
      'returns NetworkFailure when NetworkException in DioException',
      () async {
        when(() => mockDatasource.getUser(7)).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            error: const NetworkException(message: 'No internet'),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await repo.getUserById(id: 7);

        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );

    test('returns ServerFailure on 404', () async {
      when(() => mockDatasource.getUser(999)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: const ServerException(message: 'Not found', statusCode: 404),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repo.getUserById(id: 999);

      expect(result.isLeft(), true);
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
