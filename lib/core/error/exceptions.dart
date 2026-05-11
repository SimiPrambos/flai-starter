sealed class AppException implements Exception {
  const AppException({required this.message});
  final String message;
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
