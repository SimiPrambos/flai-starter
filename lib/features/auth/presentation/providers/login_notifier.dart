import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/auth/auth_providers.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<AuthEntity?> build() async => null;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    state = result.fold(
      // ignore: only_throw_errors // Failure is a sealed class; Riverpod wraps it in AsyncError.
      (failure) => throw failure,
      AsyncData.new,
    );
  }
}
