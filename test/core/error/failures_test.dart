import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/error/failures.dart';

void main() {
  group('FailureMessage.readableMessage', () {
    test('NetworkFailure returns its message', () {
      const failure = Failure.network(message: 'No internet');
      expect(failure.readableMessage, 'No internet');
    });

    test('ServerFailure returns its message', () {
      const failure = Failure.server(
        message: 'Internal server error',
        statusCode: 500,
      );
      expect(failure.readableMessage, 'Internal server error');
    });

    test('UnknownFailure returns its message', () {
      const failure = Failure.unknown(message: 'Something went wrong');
      expect(failure.readableMessage, 'Something went wrong');
    });
  });
}
