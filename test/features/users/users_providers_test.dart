import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_users_use_case.dart';
import 'package:template_vgv_app/features/users/users_providers.dart';

import '../../helpers/fakes.dart';

void main() {
  group('users providers', () {
    test('userRepositoryProvider creates repository implementation', () {
      final container = ProviderContainer(
        overrides: [
          remoteUserDataSourceProvider.overrideWithValue(
            MockRemoteUserDataSource(),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(userRepositoryProvider), isA<UserRepositoryImpl>());
    });

    test('getUsersUseCaseProvider creates use case', () {
      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(MockUserRepository()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(getUsersUseCaseProvider), isA<GetUsersUseCase>());
    });
  });
}
