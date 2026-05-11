import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';

void main() {
  group('NetworkException', () {
    test('is an AppException with correct message', () {
      const exception = NetworkException(message: 'No internet');
      expect(exception, isA<AppException>());
      expect(exception.message, 'No internet');
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
  });

  group('UnknownException', () {
    test('is an AppException with correct message', () {
      const exception = UnknownException(message: 'Unexpected error');
      expect(exception, isA<AppException>());
      expect(exception.message, 'Unexpected error');
    });
  });
}
