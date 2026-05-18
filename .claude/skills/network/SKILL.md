---
name: flai-network
description: Use when adding API endpoints, configuring Dio, writing datasources, or reviewing interceptor order in this Flutter project. Covers dioClientProvider setup, Retrofit datasources, and model-to-entity mapping.
---

# Network

## Dio Setup (`dioClientProvider`)

Interceptor order is intentional — do not reorder:

1. **`ApiKeyInterceptor`** — injects `Env.apiKey` as `x-api-key` header
2. **`ConnectivityInterceptor`** — rejects offline requests with `NetworkException` before they hit the network
3. **`ErrorInterceptor`** — maps Dio error types to `AppException` subtypes
4. **`TalkerDioLogger`** — logs request/response/error details

> To add auth, create an `AuthInterceptor` that injects a Bearer token in
> `onRequest` and handles 401 redirects in `onError` via a `VoidCallback`
> (not a direct `GoRouter` dependency). Insert it before `ApiKeyInterceptor`.

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
