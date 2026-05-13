import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/router/app_router.dart';

void main() {
  test('appRouterProvider creates a GoRouter', () {
    final talker = TalkerFlutter.init();
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(talker),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    expect(router, isA<GoRouter>());
  });
}
