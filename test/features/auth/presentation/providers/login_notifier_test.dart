import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/auth/auth_providers.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';
import 'package:template_vgv_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_vgv_app/features/auth/presentation/providers/login_notifier.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = _MockAuthRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(mockRepo),
    ],
  );

  group('LoginNotifier', () {
    const email = 'test@example.com';
    const password = 'secret';

    test('initial state is AsyncData(null)', () {
      final container = makeContainer();
      addTearDown(container.dispose);
      expect(
        container.read(loginNotifierProvider),
        equals(const AsyncData<void>(null)),
      );
    });

    test('login success → state becomes AsyncData(null)', () async {
      when(
        () => mockRepo.login(email: email, password: password),
      ).thenAnswer((_) async => right(const AuthEntity(token: 'tok')));

      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(loginNotifierProvider.notifier);

      await notifier.login(email: email, password: password);

      expect(
        container.read(loginNotifierProvider),
        equals(const AsyncData<void>(null)),
      );
    });

    test('login failure → state becomes AsyncError', () async {
      when(() => mockRepo.login(email: email, password: password)).thenAnswer(
        (_) async => left(const Failure.unknown(message: 'err')),
      );

      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(loginNotifierProvider.notifier);

      await notifier.login(email: email, password: password);

      expect(container.read(loginNotifierProvider), isA<AsyncError<void>>());
    });
  });
}
