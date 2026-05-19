import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';

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
  });
}
