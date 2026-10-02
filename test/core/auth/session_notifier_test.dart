import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/auth/session_notifier.dart';
import 'package:template_vgv_app/core/auth/session_storage.dart';

class _ThrowingSessionStorage implements SessionStorage {
  @override
  Future<bool> read() async => throw StateError('storage unavailable');

  @override
  Future<void> write() async {}

  @override
  Future<void> clear() async {}
}

ProviderContainer _makeContainer(SessionStorage storage) => ProviderContainer(
  overrides: [sessionStorageProvider.overrideWithValue(storage)],
);

void main() {
  group('SessionNotifier', () {
    test('build returns false when storage is empty', () async {
      final container = _makeContainer(InMemorySessionStorage());
      addTearDown(container.dispose);

      expect(await container.read(sessionNotifierProvider.future), isFalse);
    });

    test('build returns true when a session is stored', () async {
      final container = _makeContainer(InMemorySessionStorage(signedIn: true));
      addTearDown(container.dispose);

      expect(await container.read(sessionNotifierProvider.future), isTrue);
    });

    test('signIn persists the session and sets state to true', () async {
      final storage = InMemorySessionStorage();
      final container = _makeContainer(storage);
      addTearDown(container.dispose);

      await container.read(sessionNotifierProvider.future);
      await container.read(sessionNotifierProvider.notifier).signIn();

      expect(container.read(sessionNotifierProvider).value, isTrue);
      expect(await storage.read(), isTrue);
    });

    test('signOut clears the session and sets state to false', () async {
      final storage = InMemorySessionStorage(signedIn: true);
      final container = _makeContainer(storage);
      addTearDown(container.dispose);

      await container.read(sessionNotifierProvider.future);
      await container.read(sessionNotifierProvider.notifier).signOut();

      expect(container.read(sessionNotifierProvider).value, isFalse);
      expect(await storage.read(), isFalse);
    });

    test('a storage failure surfaces as AsyncError', () async {
      final container = _makeContainer(_ThrowingSessionStorage());
      addTearDown(container.dispose);

      await expectLater(
        container.read(sessionNotifierProvider.future),
        throwsA(isA<StateError>()),
      );
      expect(container.read(sessionNotifierProvider).hasError, isTrue);
    });
  });
}
