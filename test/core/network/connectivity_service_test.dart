import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/network/connectivity_service.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late ConnectivityService service;

  setUp(() {
    mockConnectivity = MockConnectivity();
    service = ConnectivityService(connectivity: mockConnectivity);
  });

  group('ConnectivityService.isConnected', () {
    test('returns true when at least one result is not none', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      expect(await service.isConnected(), isTrue);
    });

    test('returns false when all results are none', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      expect(await service.isConnected(), isFalse);
    });
  });

  group('ConnectivityService.onConnectivityChanged', () {
    test('emits true when connected', () async {
      when(
        () => mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => Stream.value([ConnectivityResult.mobile]));

      expect(await service.onConnectivityChanged.first, isTrue);
    });

    test('emits false when disconnected', () async {
      when(
        () => mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => Stream.value([ConnectivityResult.none]));

      expect(await service.onConnectivityChanged.first, isFalse);
    });
  });

  group('connectivityServiceProvider', () {
    test('creates ConnectivityService via provider', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(connectivityServiceProvider),
        isA<ConnectivityService>(),
      );
    });

    test('uses default Connectivity when none provided', () {
      expect(ConnectivityService(), isA<ConnectivityService>());
    });
  });
}
