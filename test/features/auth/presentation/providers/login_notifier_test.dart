import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/auth/auth_providers.dart';
import 'package:template_vgv_app/features/auth/domain/entities/auth_entity.dart';
import 'package:template_vgv_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_vgv_app/features/auth/presentation/providers/login_notifier.dart';

class _MockRepo extends Mock implements AuthRepository {}

void main() {
  late _MockRepo mockRepo;

  const testEntity = AuthEntity(token: 'mock-token');

  setUp(() => mockRepo = _MockRepo());

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockRepo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('LoginNotifier', () {
    test('initial build() returns null (unauthenticated)', () async {
      final container = makeContainer();
      final result = await container.read(loginNotifierProvider.future);
      expect(result, isNull);
    });

    test('login() sets state to data with entity on success', () async {
      when(
        () => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => right(testEntity));

      final container = makeContainer();
      await container
          .read(loginNotifierProvider.notifier)
          .login(
            email: 'test@example.com',
            password: 'password',
          );

      final result = await container.read(loginNotifierProvider.future);
      expect(result, testEntity);
    });

    test('login() sets state to error on repository failure', () async {
      const failure = Failure.network(message: 'No connection');
      when(
        () => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => left(failure));

      final container = makeContainer();
      await container
          .read(loginNotifierProvider.notifier)
          .login(
            email: 'test@example.com',
            password: 'wrong',
          );

      final state = container.read(loginNotifierProvider);
      expect(state.hasError, true);
    });
  });
}
