import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_user_by_id_use_case.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_users_use_case.dart';

export 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart'
    show userRepositoryProvider;

part 'users_providers.g.dart';

@riverpod
GetUsersUseCase getUsersUseCase(GetUsersUseCaseRef ref) =>
    GetUsersUseCase(ref.watch(userRepositoryProvider));

@riverpod
GetUserByIdUseCase getUserByIdUseCase(GetUserByIdUseCaseRef ref) =>
    GetUserByIdUseCase(ref.watch(userRepositoryProvider));
