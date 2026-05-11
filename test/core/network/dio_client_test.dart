import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/env/env.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/network/connectivity_service.dart';
import 'package:template_vgv_app/core/network/dio_client.dart';
import 'package:template_vgv_app/core/network/interceptors/api_key_interceptor.dart';
import 'package:template_vgv_app/core/network/interceptors/connectivity_interceptor.dart';
import 'package:template_vgv_app/core/network/interceptors/error_interceptor.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  test('dioClientProvider creates configured Dio instance', () {
    final talker = TalkerFlutter.init();
    final mockConnectivity = MockConnectivityService();

    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(talker),
        connectivityServiceProvider.overrideWithValue(mockConnectivity),
      ],
    );
    addTearDown(container.dispose);

    final dio = container.read(dioClientProvider);

    expect(dio, isA<Dio>());
    expect(dio.options.baseUrl, Env.baseUrl);
    expect(
      dio.interceptors.whereType<ApiKeyInterceptor>(),
      isNotEmpty,
    );
    expect(
      dio.interceptors.whereType<ConnectivityInterceptor>(),
      isNotEmpty,
    );
    expect(
      dio.interceptors.whereType<ErrorInterceptor>(),
      isNotEmpty,
    );
  });
}
