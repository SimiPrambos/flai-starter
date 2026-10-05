import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/auth/session_storage.dart';

part 'session_notifier.g.dart';

/// App-wide signed-in flag.
///
/// `appRouter` listens to this provider and re-runs its redirect on every
/// change, so callers never navigate after [signIn] or [signOut].
@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  @override
  Future<bool> build() => ref.watch(sessionStorageProvider).read();

  Future<void> signIn() async {
    await ref.read(sessionStorageProvider).write();
    state = const AsyncData(true);
  }

  Future<void> signOut() async {
    await ref.read(sessionStorageProvider).clear();
    state = const AsyncData(false);
  }
}
