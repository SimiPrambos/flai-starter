import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker/talker.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';

void main() {
  test('talkerProvider creates a Talker instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final talker = container.read(talkerProvider);
    expect(talker, isA<Talker>());
  });
}
