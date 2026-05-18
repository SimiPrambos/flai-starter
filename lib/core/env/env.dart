// ignore_for_file: document_ignores
// ignore_for_file: undefined_identifier, uri_has_not_been_generated

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static final String apiKey = _Env.apiKey;
}
