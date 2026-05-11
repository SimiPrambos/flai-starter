# Flutter Enterprise Stack Migration — VGV Template

**Date:** 2026-05-11
**Scope:** Complete rewrite VGV template dari Bloc → Riverpod + Clean Architecture

---

## Overview

Migrasi template VGV dari Bloc/Cubit ke stack enterprise 2026. Counter feature dihapus, diganti **users list** sebagai contoh feature yang mendemonstrasikan seluruh layer clean architecture. Tidak ada auth/login — langsung fetch dan tampilkan list user dari reqres.in.

---

## API

| | |
|---|---|
| Base URL | `https://reqres.in/api` |
| API Key | `free_user_3DZF3qZYzM22ep6mUq6s8UTdhFz` |
| Header | `x-api-key: <api_key>` |
| Endpoint | `GET /users?page={page}` |

Response shape:
```json
{
  "page": 1,
  "per_page": 6,
  "total": 12,
  "total_pages": 2,
  "data": [
    {
      "id": 7,
      "email": "michael.lawson@reqres.in",
      "first_name": "Michael",
      "last_name": "Lawson",
      "avatar": "https://reqres.in/img/faces/7-image.jpg"
    }
  ]
}
```

---

## Stack

| Category | Package | Versi |
|---|---|---|
| State + DI | `flutter_riverpod`, `riverpod_annotation` | `^2.6.1` |
| Navigation | `go_router` | `^14.6.1` |
| Network | `dio`, `retrofit` | `^5.7.0`, `^4.4.1` |
| Model | `freezed_annotation`, `json_annotation` | `^2.4.4`, `^4.9.0` |
| Error handling | `fpdart` | `^1.1.0` |
| Storage | `shared_preferences`, `flutter_secure_storage` | `^2.3.2`, `^9.2.2` |
| Env config | `envied` | `^0.5.4+1` |
| Logging | `talker`, `talker_dio_logger`, `talker_flutter` | `^4.4.1` |
| Connectivity | `connectivity_plus` | `^6.1.0` |
| UI utilities | `gap`, `cached_network_image`, `flutter_svg`, `shimmer`, `lottie` | per Excel |
| i18n | `intl` | `^0.19.0` |

**Dev dependencies:** `riverpod_generator ^2.6.3`, `retrofit_generator ^9.1.6`, `freezed ^2.5.7`, `json_serializable ^6.8.0`, `envied_generator ^0.5.4+1`, `build_runner ^2.4.13`, `very_good_analysis ^6.0.0`, `mocktail ^1.0.4`

**Dihapus:** `bloc`, `flutter_bloc`, `bloc_lint`, `bloc_test`, `bloc_tools`

---

## Architecture

Clean Architecture dengan aturan: `presentation → domain ← data`. Domain tidak boleh import siapapun selain Dart murni + fpdart.

```
lib/
├── bootstrap.dart
├── main_development.dart
├── main_staging.dart
├── main_production.dart
│
├── core/
│   ├── error/
│   │   ├── failures.dart          # @freezed sealed Failure
│   │   └── exceptions.dart        # sealed AppException
│   ├── network/
│   │   ├── dio_client.dart        # Dio singleton + interceptor chain
│   │   └── connectivity_service.dart  # connectivity_plus wrapper
│   ├── router/
│   │   └── app_router.dart        # GoRouter config
│   ├── storage/
│   │   ├── secure_storage.dart    # FlutterSecureStorage wrapper
│   │   └── preferences_service.dart  # SharedPreferences wrapper
│   ├── logging/
│   │   └── talker_provider.dart   # @Riverpod(keepAlive: true) Talker singleton
│   ├── env/
│   │   └── env.dart               # @Envied — BASE_URL, API_KEY
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       ├── app_spacing.dart
│       └── app_assets.dart
│
├── shared/
│   └── widgets/
│       ├── app_button.dart        # Filled/outlined/ghost variants
│       ├── app_text_field.dart    # Label, hint, prefix, suffix, validator
│       └── async_value_widget.dart  # Handle AsyncLoading/AsyncError/AsyncData
│
├── features/
│   └── users/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── remote_user_datasource.dart   # Retrofit @RestApi
│       │   ├── models/
│       │   │   ├── user_model.dart               # @freezed + @JsonSerializable
│       │   │   └── users_response.dart           # wrapper page + data[]
│       │   └── repositories/
│       │       └── user_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_entity.dart              # @freezed, pure domain
│       │   ├── repositories/
│       │   │   └── user_repository.dart          # abstract interface
│       │   └── usecases/
│       │       └── get_users_use_case.dart
│       └── presentation/
│           ├── pages/
│           │   └── users_page.dart
│           ├── providers/
│           │   └── users_notifier.dart           # @riverpod AsyncNotifier
│           └── widgets/
│               ├── user_card.dart
│               └── user_card_shimmer.dart
│
└── l10n/
    ├── arb/
    │   ├── app_en.arb
    │   └── app_id.arb
    └── l10n.dart
```

---

## Core Layer

### error/failures.dart
```dart
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.server({required String message, required int statusCode}) = ServerFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;
}
```

### error/exceptions.dart
```dart
sealed class AppException implements Exception {}
class NetworkException extends AppException { final String message; ... }
class ServerException extends AppException { final int statusCode; final String message; ... }
```

AppException mempunyai method `toFailure()` → `Failure`.

### network/dio_client.dart
Interceptor chain (urutan):
1. `ApiKeyInterceptor` — inject `x-api-key` header ke setiap request dari `Env.apiKey`
2. `ErrorInterceptor` — tangkap `DioException` → map ke `AppException`
3. `TalkerDioLogger` — log semua request/response/error

### network/connectivity_service.dart
Wrapper `connectivity_plus`. Expose `Future<bool> isConnected()`. Dipakai di `ErrorInterceptor` — kalau offline, throw `NetworkException` sebelum request dikirim.

### router/app_router.dart
Single route untuk template: `/` → `UsersPage`. GoRouter pakai `ProviderScope`-aware constructor via `ref`.

### storage/secure_storage.dart
```dart
class SecureStorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
}
```

### storage/preferences_service.dart
Wrapper `SharedPreferences` untuk data non-sensitif (theme mode, language, onboarding flag).

### logging/talker_provider.dart
```dart
@Riverpod(keepAlive: true)
Talker talker(Ref ref) => TalkerFlutter.init();
```

### env/env.dart
```dart
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static final String apiKey = _Env.apiKey;
}
```

`.env` di-gitignore. Template menyertakan `.env.example`:
```
BASE_URL=https://reqres.in/api
API_KEY=free_user_3DZF3qZYzM22ep6mUq6s8UTdhFz
```

### theme/
- `AppColors` — primary, secondary, error, background, surface, onSurface
- `AppTextStyles` — displayLg, titleMd, bodyMd, labelSm
- `AppSpacing` — xs=4, sm=8, md=16, lg=24, xl=32
- `AppAssets` — path string untuk images + icons

---

## Users Feature

### Domain

**UserEntity:**
```dart
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required String avatar,
  }) = _UserEntity;
}
```

**UserRepository interface:**
```dart
abstract interface class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({required int page});
}
```

**GetUsersUseCase:**
```dart
class GetUsersUseCase {
  Future<Either<Failure, List<UserEntity>>> call({required int page});
}
```

### Data

**UserModel:** `@freezed + @JsonSerializable`, fields: `id`, `email`, `firstName` (`first_name`), `lastName` (`last_name`), `avatar`.

Extension mapper:
```dart
extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id, email: email,
    firstName: firstName, lastName: lastName, avatar: avatar,
  );
}
```

**UsersResponse:** `@freezed + @JsonSerializable`, fields: `page`, `perPage`, `total`, `totalPages`, `data: List<UserModel>`.

**RemoteUserDataSource (Retrofit):**
```dart
@RestApi()
abstract class RemoteUserDataSource {
  factory RemoteUserDataSource(Dio dio, {String baseUrl});

  @GET('/users')
  Future<UsersResponse> getUsers(@Query('page') int page);
}
```

**UserRepositoryImpl:**
- Inject `RemoteUserDataSource`
- `getUsers()` → panggil datasource → map `List<UserModel>` ke `List<UserEntity>` → return `right(entities)`
- Catch `AppException` → return `left(exception.toFailure())`

### Presentation

**UsersNotifier:**
```dart
@riverpod
class UsersNotifier extends _$UsersNotifier {
  int _page = 1;

  @override
  Future<List<UserEntity>> build() async {
    return _fetchPage(_page);
  }

  Future<void> loadNextPage() async { ... }
  Future<void> refresh() async { ... }

  Future<List<UserEntity>> _fetchPage(int page) async {
    final result = await ref.read(getUsersUseCaseProvider).call(page: page);
    return result.fold(
      (failure) => throw failure,
      (users) => users,
    );
  }
}
```

**UsersPage:** `ConsumerWidget`
- Watch `usersNotifierProvider` → `AsyncValue<List<UserEntity>>`
- Loading → tampilkan `UserCardShimmer` (6 item) via `shimmer`
- Error → tampilkan `ErrorState` dengan pesan + tombol retry
- Data → `ListView.builder` dengan `UserCard`
- Tombol load next page / pull-to-refresh

**UserCard:** Tampilkan avatar (`CachedNetworkImage`), nama lengkap, email. Pakai `Gap(AppSpacing.sm)` untuk spacing.

**UserCardShimmer:** `Shimmer.fromColors` dengan placeholder layout yang sama seperti `UserCard`.

---

## bootstrap.dart

```dart
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  final talker = TalkerFlutter.init();

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  runApp(
    ProviderScope(
      overrides: [talkerProvider.overrideWithValue(talker)],
      child: await builder(),
    ),
  );
}
```

---

## Testing

```
test/
├── core/
│   └── network/
│       └── dio_client_test.dart              # interceptor behavior
├── features/
│   └── users/
│       ├── data/
│       │   └── repositories/
│       │       └── user_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── get_users_use_case_test.dart
│       └── presentation/
│           ├── providers/
│           │   └── users_notifier_test.dart
│           └── pages/
│               └── users_page_test.dart
└── helpers/
    ├── pump_app.dart    # wrap dengan ProviderScope + MaterialApp
    └── fakes.dart       # mocktail Fake untuk UserRepository, datasource
```

**Strategi:**
- UseCase → pure unit test, mock `UserRepository` dengan mocktail
- Repository → mock `RemoteUserDataSource`
- Notifier → `ProviderContainer` dengan `overrides: [userRepositoryProvider.overrideWith(...)]`
- Widget → `pumpApp()` helper yang wrap dengan `ProviderScope + overrides`

---

## Keputusan Desain

| Topik | Keputusan | Alasan |
|---|---|---|
| Example feature | Users list (bukan auth) | Langsung demo stack tanpa perlu backend auth |
| API | reqres.in + API key via envied | Free, stabil, ada avatar untuk demo cached_network_image |
| State management | Riverpod codegen | Type-safe, sekaligus DI, standard 2026 |
| Local DB | Tidak dimasukkan | Tidak relevan untuk contoh read-only list |
| l10n | Pertahankan, ganti ES → ID | Tetap siap multi-bahasa |
| Error | fpdart Either | Paksa handle kedua case di compile time |
| Logging | Talker | Ganti AppBlocObserver, ada UI viewer |
| Approach | Complete rewrite | Template masih sangat sederhana, tidak ada yang perlu dipertahankan |
