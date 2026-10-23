import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/storage/secure_storage.dart';

part 'session_storage.g.dart';

/// Persists whether a user is signed in.
///
/// One flag, no tokens, no roles. A real auth backend stores its token next
/// to this flag through `SecureStorageService`.
abstract interface class SessionStorage {
  Future<bool> read();
  Future<void> write();
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  const SecureSessionStorage(this._storage);

  final SecureStorageService _storage;

  @override
  Future<bool> read() async =>
      await _storage.read(key: SecureStorageKeys.sessionActive) == 'true';

  @override
  Future<void> write() =>
      _storage.write(key: SecureStorageKeys.sessionActive, value: 'true');

  @override
  Future<void> clear() => _storage.delete(key: SecureStorageKeys.sessionActive);
}

/// In-memory implementation for tests.
class InMemorySessionStorage implements SessionStorage {
  InMemorySessionStorage({bool signedIn = false}) : _active = signedIn;

  bool _active;

  @override
  Future<bool> read() async => _active;

  @override
  Future<void> write() async => _active = true;

  @override
  Future<void> clear() async => _active = false;
}

@Riverpod(keepAlive: true)
SessionStorage sessionStorage(Ref ref) =>
    SecureSessionStorage(ref.watch(secureStorageProvider));
