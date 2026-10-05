import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/auth/session_storage.dart';
import 'package:template_vgv_app/core/storage/secure_storage.dart';

class _MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  group('SecureSessionStorage', () {
    late _MockSecureStorageService mockStorage;
    late SecureSessionStorage storage;

    setUp(() {
      mockStorage = _MockSecureStorageService();
      storage = SecureSessionStorage(mockStorage);
    });

    test('read returns false when nothing is stored', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);

      expect(await storage.read(), isFalse);
    });

    test('read returns true when "true" is stored', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'true');

      expect(await storage.read(), isTrue);
      verify(() => mockStorage.read(key: 'session_active')).called(1);
    });

    test('read returns false for any other stored value', () async {
      when(
        () => mockStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'yes');

      expect(await storage.read(), isFalse);
    });

    test('write stores "true" under session_active', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await storage.write();

      verify(
        () => mockStorage.write(key: 'session_active', value: 'true'),
      ).called(1);
    });

    test('clear deletes session_active', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      await storage.clear();

      verify(() => mockStorage.delete(key: 'session_active')).called(1);
    });
  });

  group('InMemorySessionStorage', () {
    test('read returns false by default', () async {
      expect(await InMemorySessionStorage().read(), isFalse);
    });

    test('signedIn: true starts with a session', () async {
      expect(await InMemorySessionStorage(signedIn: true).read(), isTrue);
    });

    test('write then read returns true', () async {
      final storage = InMemorySessionStorage();
      await storage.write();
      expect(await storage.read(), isTrue);
    });

    test('clear removes the session', () async {
      final storage = InMemorySessionStorage(signedIn: true);
      await storage.clear();
      expect(await storage.read(), isFalse);
    });
  });

  group('sessionStorageProvider', () {
    test('defaults to SecureSessionStorage', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(sessionStorageProvider),
        isA<SecureSessionStorage>(),
      );
    });
  });
}
