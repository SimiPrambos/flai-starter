import 'package:template_vgv_app/core/error/failures.dart';

sealed class AppException implements Exception {
  const AppException({required this.message});
  final String message;

  Failure toFailure() => switch (this) {
    final NetworkException e => Failure.network(message: e.message),
    final ServerException e => Failure.server(
      message: e.message,
      statusCode: e.statusCode,
    ),
    final UnknownException e => Failure.unknown(message: e.message),
  };
}

class NetworkException extends AppException {
  const NetworkException({required super.message});
}

class ServerException extends AppException {
  const ServerException({required super.message, required this.statusCode});
  final int statusCode;
}

class UnknownException extends AppException {
  const UnknownException({required super.message});
}
