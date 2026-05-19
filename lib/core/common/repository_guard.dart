import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/error/failures.dart';

mixin RepositoryGuard {
  Future<Either<Failure, T>> guardRequest<T>(Future<T> Function() call) async {
    try {
      return right(await call());
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) return left(appException.toFailure());
      return left(Failure.unknown(message: e.message ?? 'Unknown error'));
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
