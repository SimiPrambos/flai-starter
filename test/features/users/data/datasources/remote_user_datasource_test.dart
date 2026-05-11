import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/core/network/dio_client.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';

class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.body);

  final Object? body;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const responseJson = {
    'page': 3,
    'per_page': 6,
    'total': 12,
    'total_pages': 2,
    'data': [
      {
        'id': 7,
        'email': 'michael.lawson@reqres.in',
        'first_name': 'Michael',
        'last_name': 'Lawson',
        'avatar': 'https://reqres.in/img/faces/7-image.jpg',
      },
    ],
  };

  Dio dioWith(FakeHttpClientAdapter adapter) {
    return Dio(BaseOptions(baseUrl: 'https://api.example.test'))
      ..httpClientAdapter = adapter;
  }

  group('RemoteUserDataSource', () {
    test('uses dio client from provider', () {
      final dio = Dio();
      final container = ProviderContainer(
        overrides: [dioClientProvider.overrideWithValue(dio)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(remoteUserDataSourceProvider),
        isA<RemoteUserDataSource>(),
      );
    });

    test('fetches users with page query', () async {
      final adapter = FakeHttpClientAdapter(responseJson);
      final dataSource = RemoteUserDataSource(dioWith(adapter));

      final response = await dataSource.getUsers(3);

      expect(response.page, 3);
      expect(response.data.single.email, 'michael.lawson@reqres.in');
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/users');
      expect(adapter.requests.single.queryParameters, {'page': 3});
      expect(adapter.requests.single.responseType, ResponseType.json);
      expect(
        adapter.requests.single.baseUrl,
        'https://api.example.test',
      );
    });

    test('uses absolute base url override', () async {
      final adapter = FakeHttpClientAdapter(responseJson);
      final dataSource = RemoteUserDataSource(
        dioWith(adapter),
        baseUrl: 'https://override.example.test/api',
      );

      await dataSource.getUsers(3);

      expect(
        adapter.requests.single.baseUrl,
        'https://override.example.test/api',
      );
    });

    test('resolves relative base url override', () async {
      final adapter = FakeHttpClientAdapter(responseJson);
      final dataSource = RemoteUserDataSource(
        dioWith(adapter),
        baseUrl: 'v1',
      );

      await dataSource.getUsers(3);

      expect(adapter.requests.single.baseUrl, 'https://api.example.test/v1');
    });

    test('rethrows json parsing errors', () async {
      final adapter = FakeHttpClientAdapter({'page': 'invalid'});
      final dataSource = RemoteUserDataSource(dioWith(adapter));

      await expectLater(dataSource.getUsers(3), throwsA(isA<Object>()));
    });
  });
}
