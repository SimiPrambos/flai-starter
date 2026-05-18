---
name: flai-network
description: Use when adding API endpoints, configuring Dio, writing datasources, or reviewing interceptor order in this Flutter project. Covers dioClientProvider setup, Retrofit datasources, and model-to-entity mapping.
---

# Network

## Dio Setup (`dioClientProvider`)

Interceptor order is intentional — do not reorder:

1. **API key interceptor** — injects `Env.apiKey` as `x-api-key` header
2. **Connectivity/error interceptor** — maps offline, timeout, server, unknown failures into `AppException`
3. **`TalkerDioLogger`** — logs request/response/error details

## Datasources

Retrofit API interfaces go in `data/datasources/`. Annotate with `@RestApi`.

```dart
@RestApi()
abstract class UserRemoteDataSource {
  factory UserRemoteDataSource(Dio dio) = _UserRemoteDataSource;

  @GET('/users')
  Future<UserListResponse> getUsers(@Query('page') int page);
}
```

## Models vs Entities

- `data/models/` — Freezed/JSON models matching the API shape (`@JsonSerializable`)
- `domain/entities/` — pure Dart entities
- Mapper extension in `data/` converts model → entity before data leaves the repository

```dart
extension UserModelMapper on UserModel {
  User toEntity() => User(id: id, name: name, email: email);
}
```

## Env Access

`Env.baseUrl`, `Env.apiKey` — defined in `.env` (git-ignored), generated via `@Envied`.

## After Changing Datasource or Models

```sh
dart run build_runner build --delete-conflicting-outputs
```
