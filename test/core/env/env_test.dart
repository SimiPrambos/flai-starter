import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/env/env.dart';

void main() {
  group('Env', () {
    test('baseUrl is not empty', () {
      expect(Env.baseUrl, isNotEmpty);
    });

    test('apiKey is not empty', () {
      expect(Env.apiKey, isNotEmpty);
    });
  });
}
