import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/error/failures.dart';

void main() {
  group('NetworkException', () {
    test('is an AppException with correct message', () {
      const exception = NetworkException(message: 'No internet');
      expect(exception, isA<AppException>());
      expect(exception.message, 'No internet');
    });

    test('toFailure returns Failure.network', () {
      const exception = NetworkException(message: 'offline');
      expect(
        exception.toFailure(),
        const Failure.network(message: 'offline'),
      );
    });
  });

  group('ServerException', () {
    test('exposes message and statusCode', () {
      const exception = ServerException(
        message: 'Not found',
        statusCode: 404,
      );
      expect(exception, isA<AppException>());
      expect(exception.message, 'Not found');
      expect(exception.statusCode, 404);
    });

    test('toFailure returns Failure.server', () {
      const exception = ServerException(
        message: 'Not found',
        statusCode: 404,
      );
      expect(
        exception.toFailure(),
        const Failure.server(message: 'Not found', statusCode: 404),
      );
    });
  });

  group('UnknownException', () {
    test('is an AppException with correct message', () {
      const exception = UnknownException(message: 'Unexpected error');
      expect(exception, isA<AppException>());
      expect(exception.message, 'Unexpected error');
    });

    test('toFailure returns Failure.unknown', () {
      const exception = UnknownException(message: 'unexpected');
      expect(
        exception.toFailure(),
        const Failure.unknown(message: 'unexpected'),
      );
    });
  });
}
