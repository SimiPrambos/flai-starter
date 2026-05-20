import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:template_vgv_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:template_vgv_app/features/auth/domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
MockAuthRemoteDataSource mockAuthRemoteDataSource(
  MockAuthRemoteDataSourceRef ref,
) => const MockAuthRemoteDataSource();

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepositoryImpl(ref.watch(mockAuthRemoteDataSourceProvider));
