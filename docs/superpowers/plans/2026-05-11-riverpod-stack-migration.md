# Riverpod Stack Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate VGV Flutter template dari Bloc ke Riverpod + Clean Architecture dengan users list sebagai contoh feature.

**Architecture:** Clean Architecture (presentation → domain ← data). Feature-first folder structure di bawah `lib/features/`. Core infrastructure di `lib/core/`. Domain layer pure Dart, tidak boleh import Flutter atau data layer.

**Tech Stack:** flutter_riverpod (codegen), go_router, dio + retrofit, freezed + fpdart, envied, talker, connectivity_plus, shimmer, cached_network_image, mocktail.

---

## File Map

```
lib/
├── bootstrap.dart                                          MOD
├── main_development.dart                                   MOD
├── main_staging.dart                                       MOD
├── main_production.dart                                    MOD
├── app/
│   ├── app.dart                                            MOD
│   └── view/app.dart                                       MOD
├── core/
│   ├── error/
│   │   ├── exceptions.dart                                 NEW
│   │   └── failures.dart                                   NEW
│   ├── logging/
│   │   └── talker_provider.dart                            NEW
│   ├── env/
│   │   └── env.dart                                        NEW
│   ├── network/
│   │   ├── connectivity_service.dart                       NEW
│   │   └── dio_client.dart                                 NEW
│   ├── storage/
│   │   ├── secure_storage.dart                             NEW
│   │   └── preferences_service.dart                        NEW
│   ├── router/
│   │   └── app_router.dart                                 NEW
│   └── theme/
│       ├── app_colors.dart                                 NEW
│       ├── app_text_styles.dart                            NEW
│       ├── app_spacing.dart                                NEW
│       └── app_assets.dart                                 NEW
├── shared/
│   └── widgets/
│       ├── async_value_widget.dart                         NEW
│       ├── app_button.dart                                 NEW
│       └── app_text_field.dart                             NEW
├── features/
│   └── users/
│       ├── domain/
│       │   ├── entities/user_entity.dart                   NEW
│       │   ├── repositories/user_repository.dart           NEW
│       │   └── usecases/get_users_use_case.dart            NEW
│       ├── data/
│       │   ├── models/user_model.dart                      NEW
│       │   ├── models/users_response.dart                  NEW
│       │   ├── datasources/remote_user_datasource.dart     NEW
│       │   └── repositories/user_repository_impl.dart      NEW
│       └── presentation/
│           ├── providers/users_notifier.dart               NEW
│           ├── widgets/user_card.dart                      NEW
│           ├── widgets/user_card_shimmer.dart              NEW
│           └── pages/users_page.dart                       NEW
└── l10n/
    ├── arb/app_en.arb                                      MOD
    ├── arb/app_id.arb                                      NEW
    └── arb/app_es.arb                                      DELETE

test/
├── helpers/
│   ├── pump_app.dart                                       NEW
│   └── fakes.dart                                         NEW
└── features/users/
    ├── domain/usecases/get_users_use_case_test.dart        NEW
    ├── data/repositories/user_repository_impl_test.dart    NEW
    ├── presentation/providers/users_notifier_test.dart     NEW
    └── presentation/pages/users_page_test.dart            NEW
```

---

## Task 1: Cleanup + Project Setup

**Files:**
- Modify: `pubspec.yaml`
- Modify: `analysis_options.yaml`
- Delete: `lib/counter/` (entire dir)
- Delete: `test/counter/` (entire dir)
- Delete: `test/app/view/app_test.dart`
- Create: `.env`
- Create: `.env.example`
- Modify: `.gitignore`

- [ ] **Step 1: Hapus counter feature dan tes lama**

```bash
rm -rf lib/counter
rm -rf test/counter
rm -f test/app/view/app_test.dart
```

- [ ] **Step 2: Tulis ulang `pubspec.yaml`**

```yaml
name: template_vgv_app
description: Flutter enterprise template — Clean Architecture, Riverpod, GoRouter
version: 1.0.0+1
publish_to: none

environment:
  sdk: ^3.8.0
  flutter: ^3.29.0

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management & DI
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Navigation
  go_router: ^14.6.1

  # Networking
  dio: ^5.7.0
  retrofit: ^4.4.1

  # Serialization & Models
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Error Handling
  fpdart: ^1.1.0

  # Storage
  shared_preferences: ^2.3.2
  flutter_secure_storage: ^9.2.2

  # Environment Config
  envied: ^0.5.4+1

  # Logging
  talker: ^4.4.1
  talker_dio_logger: ^4.4.1
  talker_flutter: ^4.4.1

  # Connectivity
  connectivity_plus: ^6.1.0

  # UI Utilities
  gap: ^3.0.1
  cached_network_image: ^3.4.1
  flutter_svg: ^2.0.10+1
  shimmer: ^3.0.0
  lottie: ^3.1.2

  # i18n
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.3
  retrofit_generator: ^9.1.6
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  envied_generator: ^0.5.4+1

  # Linting
  very_good_analysis: ^6.0.0

  # Testing
  mocktail: ^1.0.4

flutter:
  generate: true
  uses-material-design: true
```

- [ ] **Step 3: Tulis ulang `analysis_options.yaml`**

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - lib/l10n/gen/**
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    public_member_api_docs: false
```

- [ ] **Step 4: Tambah `.env` dan `.env.example`**

Buat `.env` (tidak di-commit):
```
BASE_URL=https://reqres.in/api
API_KEY=free_user_3DZF3qZYzM22ep6mUq6s8UTdhFz
```

Buat `.env.example` (di-commit):
```
BASE_URL=https://reqres.in/api
API_KEY=your_api_key_here
```

- [ ] **Step 5: Tambah `.env` ke `.gitignore`**

Tambahkan di bawah file `.gitignore` yang ada:
```
# Environment
.env
lib/core/env/env.g.dart
```

- [ ] **Step 6: Install dependencies**

```bash
flutter pub get
```

Expected: resolves semua packages tanpa error.

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock analysis_options.yaml .env.example .gitignore
git commit -m "chore: migrate from bloc to riverpod stack, clean project setup"
```

---

## Task 2: Core — Error Layer

**Files:**
- Create: `lib/core/error/exceptions.dart`
- Create: `lib/core/error/failures.dart`

- [ ] **Step 1: Buat `lib/core/error/exceptions.dart`**

```dart
sealed class AppException implements Exception {
  const AppException({required this.message});
  final String message;
}

class NetworkException extends AppException {
  const NetworkException({required super.message});
}

class ServerException extends AppException {
  const ServerException({required super.message, required this.statusCode});
  final int statusCode;
}

class UnknownException extends AppException {
  const UnknownException({required super.message});
}
```

- [ ] **Step 2: Buat `lib/core/error/failures.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.server({
    required String message,
    required int statusCode,
  }) = ServerFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;
}

extension FailureMessage on Failure {
  String get readableMessage => when(
        network: (msg) => msg,
        server: (msg, _) => msg,
        unknown: (msg) => msg,
      );
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/core/error/
git commit -m "feat: add core error layer — AppException and Failure sealed classes"
```

---

## Task 3: Core — Logging + Env

**Files:**
- Create: `lib/core/logging/talker_provider.dart`
- Create: `lib/core/env/env.dart`

- [ ] **Step 1: Buat `lib/core/logging/talker_provider.dart`**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'talker_provider.g.dart';

@Riverpod(keepAlive: true)
Talker talker(TalkerRef ref) => TalkerFlutter.init();
```

- [ ] **Step 2: Buat `lib/core/env/env.dart`**

```dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'API_KEY')
  static final String apiKey = _Env.apiKey;
}
```

- [ ] **Step 3: Jalankan build_runner untuk generate env.g.dart + talker_provider.g.dart**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `lib/core/env/env.g.dart` dan `lib/core/logging/talker_provider.g.dart` terbentuk tanpa error.

- [ ] **Step 4: Commit**

```bash
git add lib/core/logging/ lib/core/env/
git commit -m "feat: add talker logging provider and envied env config"
```

---

## Task 4: Core — Theme

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_text_styles.dart`
- Create: `lib/core/theme/app_spacing.dart`
- Create: `lib/core/theme/app_assets.dart`

- [ ] **Step 1: Buat `lib/core/theme/app_colors.dart`**

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  static const error = Color(0xFFEF4444);
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF111827);
  static const onSurfaceVariant = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E7EB);
  static const shimmerBase = Color(0xFFE5E7EB);
  static const shimmerHighlight = Color(0xFFF3F4F6);
}
```

- [ ] **Step 2: Buat `lib/core/theme/app_text_styles.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  static const displayLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    height: 1.25,
  );
  static const titleMd = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.4,
  );
  static const bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.5,
  );
  static const labelSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
    height: 1.33,
  );
}
```

- [ ] **Step 3: Buat `lib/core/theme/app_spacing.dart`**

```dart
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
```

- [ ] **Step 4: Buat `lib/core/theme/app_assets.dart`**

```dart
abstract final class AppAssets {
  static const _images = 'assets/images';
  static const _icons = 'assets/icons';
  static const _animations = 'assets/animations';

  static const logoFull = '$_images/logo.png';
  static const icHome = '$_icons/ic_home.svg';
  static const animEmpty = '$_animations/empty.json';
  static const animError = '$_animations/error.json';
}
```

- [ ] **Step 5: Commit**

```bash
git add lib/core/theme/
git commit -m "feat: add design system tokens — colors, text styles, spacing, assets"
```

---

## Task 5: Core — Storage

**Files:**
- Create: `lib/core/storage/secure_storage.dart`
- Create: `lib/core/storage/preferences_service.dart`

- [ ] **Step 1: Buat `lib/core/storage/secure_storage.dart`**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

@Riverpod(keepAlive: true)
SecureStorageService secureStorage(SecureStorageRef ref) =>
    SecureStorageService();

class SecureStorageService {
  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  final FlutterSecureStorage _storage;

  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  Future<String?> read({required String key}) => _storage.read(key: key);

  Future<void> delete({required String key}) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();
}

abstract final class SecureStorageKeys {
  static const accessToken = 'access_token';
}
```

- [ ] **Step 2: Buat `lib/core/storage/preferences_service.dart`**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

@Riverpod(keepAlive: true)
Future<PreferencesService> preferencesService(PreferencesServiceRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PreferencesService(prefs);
}

class PreferencesService {
  const PreferencesService(this._prefs);
  final SharedPreferences _prefs;

  Future<bool> setBool({required String key, required bool value}) =>
      _prefs.setBool(key, value);

  bool? getBool({required String key}) => _prefs.getBool(key);

  Future<bool> setString({required String key, required String value}) =>
      _prefs.setString(key, value);

  String? getString({required String key}) => _prefs.getString(key);
}

abstract final class PrefsKeys {
  static const isDarkMode = 'is_dark_mode';
  static const languageCode = 'language_code';
}
```

- [ ] **Step 3: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `secure_storage.g.dart` dan `preferences_service.g.dart` terbentuk.

- [ ] **Step 4: Commit**

```bash
git add lib/core/storage/
git commit -m "feat: add secure storage and shared preferences services"
```

---

## Task 6: Core — Network

**Files:**
- Create: `lib/core/network/connectivity_service.dart`
- Create: `lib/core/network/dio_client.dart`

- [ ] **Step 1: Buat `lib/core/network/connectivity_service.dart`**

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(ConnectivityServiceRef ref) =>
    ConnectivityService();

class ConnectivityService {
  final _connectivity = Connectivity();

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(
        (results) => results.any((r) => r != ConnectivityResult.none),
      );
}
```

- [ ] **Step 2: Buat `lib/core/network/dio_client.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:template_vgv_app/core/env/env.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';
import 'package:template_vgv_app/core/network/connectivity_service.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(DioClientRef ref) {
  final talker = ref.watch(talkerProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.addAll([
    _ApiKeyInterceptor(),
    _ConnectivityInterceptor(connectivity),
    _ErrorInterceptor(),
    TalkerDioLogger(talker: talker),
  ]);

  return dio;
}

class _ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = Env.apiKey;
    handler.next(options);
  }
}

class _ConnectivityInterceptor extends Interceptor {
  _ConnectivityInterceptor(this._connectivity);
  final ConnectivityService _connectivity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connected = await _connectivity.isConnected();
    if (!connected) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const NetworkException(message: 'No internet connection'),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }
    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError =>
        NetworkException(message: err.message ?? 'Connection error'),
      DioExceptionType.badResponse => ServerException(
          message: err.message ?? 'Server error',
          statusCode: err.response?.statusCode ?? 0,
        ),
      _ => UnknownException(message: err.message ?? 'Unknown error'),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        type: err.type,
        response: err.response,
      ),
    );
  }
}
```

- [ ] **Step 3: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `connectivity_service.g.dart` dan `dio_client.g.dart` terbentuk.

- [ ] **Step 4: Commit**

```bash
git add lib/core/network/
git commit -m "feat: add dio client with api key, connectivity, and error interceptors"
```

---

## Task 7: Core — Router + Shared Widgets

**Files:**
- Create: `lib/core/router/app_router.dart`
- Create: `lib/shared/widgets/async_value_widget.dart`
- Create: `lib/shared/widgets/app_button.dart`
- Create: `lib/shared/widgets/app_text_field.dart`

- [ ] **Step 1: Buat `lib/core/router/app_router.dart`**

```dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/users',
    routes: [
      GoRoute(
        path: '/users',
        builder: (context, state) => const UsersPage(),
      ),
    ],
  );
}
```

- [ ] **Step 2: Buat `lib/shared/widgets/async_value_widget.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stack)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => loading ?? const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          error?.call(e, st) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                e.toString(),
                style: AppTextStyles.bodyMd,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      data: data,
    );
  }
}
```

- [ ] **Step 3: Buat `lib/shared/widgets/app_button.dart`**

```dart
import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(label)],
              )
            : Text(label);

    final effectiveOnPressed = isLoading ? null : onPressed;

    return switch (variant) {
      AppButtonVariant.filled =>
        FilledButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.outlined =>
        OutlinedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.ghost =>
        TextButton(onPressed: effectiveOnPressed, child: child),
    };
  }
}
```

- [ ] **Step 4: Buat `lib/shared/widgets/app_text_field.dart`**

```dart
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
```

- [ ] **Step 5: Run build_runner untuk router**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `app_router.g.dart` terbentuk.

- [ ] **Step 6: Commit**

```bash
git add lib/core/router/ lib/shared/
git commit -m "feat: add go_router config and shared widgets"
```

---

## Task 8: Users — Domain Layer

**Files:**
- Create: `lib/features/users/domain/entities/user_entity.dart`
- Create: `lib/features/users/domain/repositories/user_repository.dart`
- Create: `lib/features/users/domain/usecases/get_users_use_case.dart`
- Create: `test/helpers/fakes.dart`
- Create: `test/features/users/domain/usecases/get_users_use_case_test.dart`

- [ ] **Step 1: Buat `lib/features/users/domain/entities/user_entity.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required String avatar,
  }) = _UserEntity;

  const UserEntity._();

  String get fullName => '$firstName $lastName';
}
```

- [ ] **Step 2: Buat `lib/features/users/domain/repositories/user_repository.dart`**

```dart
import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({required int page});
}
```

- [ ] **Step 3: Buat `lib/features/users/domain/usecases/get_users_use_case.dart`**

> Sengaja tidak ada provider di sini dulu — provider akan ditambahkan di Task 9 setelah `user_repository_impl.dart` ada. Ini menjaga domain layer bebas dari import data layer.

```dart
import 'package:fpdart/fpdart.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);
  final UserRepository _repository;

  Future<Either<Failure, List<UserEntity>>> call({required int page}) =>
      _repository.getUsers(page: page);
}
```

- [ ] **Step 4: Run build_runner untuk generate freezed**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `user_entity.freezed.dart` terbentuk.

- [ ] **Step 5: Buat `test/helpers/fakes.dart`**

```dart
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}
class MockRemoteUserDataSource extends Mock implements RemoteUserDataSource {}

class FakeUserRepository extends Fake implements UserRepository {}
```

- [ ] **Step 6: Tulis failing test untuk GetUsersUseCase**

Buat `test/features/users/domain/usecases/get_users_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_users_use_case.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockUserRepository mockRepo;
  late GetUsersUseCase useCase;

  const testUser = UserEntity(
    id: 1,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/1-image.jpg',
  );

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = GetUsersUseCase(mockRepo);
  });

  group('GetUsersUseCase', () {
    test('returns list of users on success', () async {
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => right([testUser]));

      final result = await useCase(page: 1);

      expect(result, right([testUser]));
      verify(() => mockRepo.getUsers(page: 1)).called(1);
    });

    test('returns failure when repository fails', () async {
      const failure = Failure.network(message: 'No internet');
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => left(failure));

      final result = await useCase(page: 1);

      expect(result, left(failure));
    });

    test('delegates page param to repository', () async {
      when(() => mockRepo.getUsers(page: 2))
          .thenAnswer((_) async => right([]));

      await useCase(page: 2);

      verify(() => mockRepo.getUsers(page: 2)).called(1);
    });
  });
}
```

- [ ] **Step 7: Jalankan test — expected PASS**

```bash
flutter test test/features/users/domain/usecases/get_users_use_case_test.dart
```

Expected: semua 3 tests PASS. Domain layer murni, tidak ada dependency ke data layer.

- [ ] **Step 8: Commit**

```bash
git add lib/features/users/domain/ test/helpers/fakes.dart test/features/users/domain/
git commit -m "feat: add users domain layer — entity, repository interface, and use case"
```

---

## Task 9: Users — Data Layer

**Files:**
- Create: `lib/features/users/data/models/user_model.dart`
- Create: `lib/features/users/data/models/users_response.dart`
- Create: `lib/features/users/data/datasources/remote_user_datasource.dart`
- Create: `lib/features/users/data/repositories/user_repository_impl.dart`
- Create: `test/features/users/data/repositories/user_repository_impl_test.dart`

- [ ] **Step 1: Buat `lib/features/users/data/models/user_model.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String avatar,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatar: avatar,
      );
}
```

- [ ] **Step 2: Buat `lib/features/users/data/models/users_response.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';

part 'users_response.freezed.dart';
part 'users_response.g.dart';

@freezed
class UsersResponse with _$UsersResponse {
  const factory UsersResponse({
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<UserModel> data,
  }) = _UsersResponse;

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);
}
```

- [ ] **Step 3: Buat `lib/features/users/data/datasources/remote_user_datasource.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/network/dio_client.dart';
import 'package:template_vgv_app/features/users/data/models/users_response.dart';

part 'remote_user_datasource.g.dart';

@riverpod
RemoteUserDataSource remoteUserDataSource(RemoteUserDataSourceRef ref) =>
    RemoteUserDataSource(ref.watch(dioClientProvider));

@RestApi()
abstract class RemoteUserDataSource {
  factory RemoteUserDataSource(Dio dio, {String baseUrl}) =
      _RemoteUserDataSource;

  @GET('/users')
  Future<UsersResponse> getUsers(@Query('page') int page);
}
```

- [ ] **Step 4: Buat `lib/features/users/data/repositories/user_repository_impl.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/error/exceptions.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/datasources/remote_user_datasource.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

part 'user_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepositoryImpl(ref.watch(remoteUserDataSourceProvider));

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._datasource);
  final RemoteUserDataSource _datasource;

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    required int page,
  }) async {
    try {
      final response = await _datasource.getUsers(page);
      final entities = response.data.map((m) => m.toEntity()).toList();
      return right(entities);
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is NetworkException) {
        return left(Failure.network(message: appException.message));
      }
      if (appException is ServerException) {
        return left(
          Failure.server(
            message: appException.message,
            statusCode: appException.statusCode,
          ),
        );
      }
      return left(Failure.unknown(message: e.message ?? 'Unknown error'));
    } catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
```

- [ ] **Step 5: Tambahkan provider ke `lib/features/users/domain/usecases/get_users_use_case.dart`**

Sekarang `user_repository_impl.dart` sudah ada, tambahkan provider dan import yang dibutuhkan:

```dart
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/repositories/user_repository.dart';

part 'get_users_use_case.g.dart';

@riverpod
GetUsersUseCase getUsersUseCase(GetUsersUseCaseRef ref) =>
    GetUsersUseCase(ref.watch(userRepositoryProvider));

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);
  final UserRepository _repository;

  Future<Either<Failure, List<UserEntity>>> call({required int page}) =>
      _repository.getUsers(page: page);
}
```

- [ ] **Step 6: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `user_model.freezed.dart`, `user_model.g.dart`, `users_response.freezed.dart`, `users_response.g.dart`, `remote_user_datasource.g.dart`, `user_repository_impl.g.dart`, `get_users_use_case.g.dart` terbentuk.

- [ ] **Step 7: Tulis test untuk UserRepositoryImpl**

Buat `test/features/users/data/repositories/user_repository_impl_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/models/user_model.dart';
import 'package:template_vgv_app/features/users/data/models/users_response.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockRemoteUserDataSource mockDatasource;
  late UserRepositoryImpl repo;

  const testModel = UserModel(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  final testResponse = UsersResponse(
    page: 1,
    perPage: 6,
    total: 12,
    totalPages: 2,
    data: [testModel],
  );

  setUp(() {
    mockDatasource = MockRemoteUserDataSource();
    repo = UserRepositoryImpl(mockDatasource);
  });

  group('UserRepositoryImpl.getUsers', () {
    test('returns mapped entities on success', () async {
      when(() => mockDatasource.getUsers(1))
          .thenAnswer((_) async => testResponse);

      final result = await repo.getUsers(page: 1);

      expect(result.isRight(), true);
      final users = result.getOrElse((_) => []);
      expect(users.length, 1);
      expect(users.first.email, 'michael.lawson@reqres.in');
      expect(users.first.fullName, 'Michael Lawson');
    });

    test('returns NetworkFailure on NetworkException', () async {
      when(() => mockDatasource.getUsers(1)).thenThrow(
        Exception('NetworkException'),
      );

      final result = await repo.getUsers(page: 1);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
```

- [ ] **Step 8: Jalankan domain + data tests**

```bash
flutter test test/features/users/domain/usecases/get_users_use_case_test.dart
flutter test test/features/users/data/repositories/user_repository_impl_test.dart
```

Expected: semua tests PASS.

- [ ] **Step 9: Commit**

```bash
git add lib/features/users/data/ test/features/users/data/
git commit -m "feat: add users data layer — models, retrofit datasource, repository impl"
```

---

## Task 10: Users — Presentation (Notifier + UI)

**Files:**
- Create: `lib/features/users/presentation/providers/users_notifier.dart`
- Create: `lib/features/users/presentation/widgets/user_card.dart`
- Create: `lib/features/users/presentation/widgets/user_card_shimmer.dart`
- Create: `lib/features/users/presentation/pages/users_page.dart`
- Create: `test/helpers/pump_app.dart`
- Create: `test/features/users/presentation/providers/users_notifier_test.dart`
- Create: `test/features/users/presentation/pages/users_page_test.dart`

- [ ] **Step 1: Buat `lib/features/users/presentation/providers/users_notifier.dart`**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/domain/usecases/get_users_use_case.dart';

part 'users_notifier.g.dart';

@riverpod
class UsersNotifier extends _$UsersNotifier {
  @override
  Future<List<UserEntity>> build() => _fetch(page: 1);

  Future<List<UserEntity>> _fetch({required int page}) async {
    final result = await ref.read(getUsersUseCaseProvider).call(page: page);
    return result.fold(
      (failure) => throw failure,
      (users) => users,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
```

- [ ] **Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `users_notifier.g.dart` terbentuk.

- [ ] **Step 3: Buat `lib/features/users/presentation/widgets/user_card.dart`**

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm / 2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: user.avatar,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 48,
                  height: 48,
                  color: AppColors.shimmerBase,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  color: AppColors.shimmerBase,
                  child: const Icon(Icons.person, color: AppColors.onSurfaceVariant),
                ),
              ),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullName, style: AppTextStyles.titleMd),
                  const Gap(AppSpacing.xs),
                  Text(user.email, style: AppTextStyles.labelSm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Buat `lib/features/users/presentation/widgets/user_card_shimmer.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';

class UserCardShimmer extends StatelessWidget {
  const UserCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm / 2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, color: Colors.white),
                    const Gap(AppSpacing.xs),
                    Container(
                      height: 12,
                      width: 140,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Buat `lib/features/users/presentation/pages/users_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card_shimmer.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final usersAsync = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.usersPageTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(usersNotifierProvider.notifier).refresh(),
        child: usersAsync.when(
          loading: () => ListView.builder(
            itemCount: 6,
            itemBuilder: (_, __) => const UserCardShimmer(),
          ),
          error: (error, _) {
            final message = error is Failure
                ? error.readableMessage
                : error.toString();
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: AppTextStyles.bodyMd,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.md),
                    AppButton(
                      label: l10n.errorRetry,
                      onPressed: () =>
                          ref.read(usersNotifierProvider.notifier).refresh(),
                    ),
                  ],
                ),
              ),
            );
          },
          data: (users) => ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: users.length,
            itemBuilder: (_, i) => UserCard(user: users[i]),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Buat `test/helpers/pump_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_vgv_app/l10n/gen/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Buat `test/features/users/presentation/providers/users_notifier_test.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/providers/users_notifier.dart';
import '../../../../helpers/fakes.dart';

void main() {
  late MockUserRepository mockRepo;

  const testUser = UserEntity(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  setUp(() {
    mockRepo = MockUserRepository();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('UsersNotifier', () {
    test('build() returns users on success', () async {
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => right([testUser]));

      final container = makeContainer();
      final result = await container.read(usersNotifierProvider.future);

      expect(result, [testUser]);
    });

    test('build() throws Failure on repository error', () async {
      const failure = Failure.network(message: 'No connection');
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => left(failure));

      final container = makeContainer();

      await expectLater(
        container.read(usersNotifierProvider.future),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('refresh() re-fetches users', () async {
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => right([testUser]));

      final container = makeContainer();
      await container.read(usersNotifierProvider.future);

      await container.read(usersNotifierProvider.notifier).refresh();

      verify(() => mockRepo.getUsers(page: 1)).called(2);
    });
  });
}
```

- [ ] **Step 8: Buat `test/features/users/presentation/pages/users_page_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_vgv_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:template_vgv_app/features/users/domain/entities/user_entity.dart';
import 'package:template_vgv_app/features/users/presentation/pages/users_page.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card.dart';
import 'package:template_vgv_app/features/users/presentation/widgets/user_card_shimmer.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockUserRepository mockRepo;

  const testUser = UserEntity(
    id: 7,
    email: 'michael.lawson@reqres.in',
    firstName: 'Michael',
    lastName: 'Lawson',
    avatar: 'https://reqres.in/img/faces/7-image.jpg',
  );

  setUp(() {
    mockRepo = MockUserRepository();
  });

  List<Override> overrides() => [
        userRepositoryProvider.overrideWithValue(mockRepo),
      ];

  group('UsersPage', () {
    testWidgets('shows shimmer while loading', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          return right([testUser]);
        },
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());

      expect(find.byType(UserCardShimmer), findsWidgets);
    });

    testWidgets('shows user cards on success', (tester) async {
      when(() => mockRepo.getUsers(page: 1))
          .thenAnswer((_) async => right([testUser]));

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pump();

      expect(find.byType(UserCard), findsOneWidget);
      expect(find.text('Michael Lawson'), findsOneWidget);
    });

    testWidgets('shows error and retry button on failure', (tester) async {
      when(() => mockRepo.getUsers(page: 1)).thenAnswer(
        (_) async => left(const Failure.network(message: 'No internet')),
      );

      await tester.pumpApp(const UsersPage(), overrides: overrides());
      await tester.pump();

      expect(find.text('No internet'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 9: Jalankan semua presentation tests**

```bash
flutter test test/features/users/presentation/
```

Expected: semua PASS.

- [ ] **Step 10: Commit**

```bash
git add lib/features/users/presentation/ test/helpers/ test/features/users/presentation/
git commit -m "feat: add users presentation layer — notifier, shimmer, card, page + tests"
```

---

## Task 11: App Wiring — Bootstrap + App + Main

**Files:**
- Modify: `lib/bootstrap.dart`
- Modify: `lib/app/view/app.dart`
- Modify: `lib/app/app.dart`
- Modify: `lib/main_development.dart`
- Modify: `lib/main_staging.dart`
- Modify: `lib/main_production.dart`

- [ ] **Step 1: Tulis ulang `lib/bootstrap.dart`**

```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:template_vgv_app/core/logging/talker_provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  final talker = TalkerFlutter.init();

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  runApp(
    ProviderScope(
      overrides: [
        talkerProvider.overrideWithValue(talker),
      ],
      child: await builder(),
    ),
  );
}
```

- [ ] **Step 2: Tulis ulang `lib/app/view/app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/l10n/gen/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Template',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
```

- [ ] **Step 3: Tulis ulang `lib/app/app.dart`**

```dart
export 'view/app.dart';
```

- [ ] **Step 4: Update ketiga main files**

`lib/main_development.dart`:
```dart
import 'package:template_vgv_app/app/app.dart';
import 'package:template_vgv_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
```

`lib/main_staging.dart`:
```dart
import 'package:template_vgv_app/app/app.dart';
import 'package:template_vgv_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
```

`lib/main_production.dart`:
```dart
import 'package:template_vgv_app/app/app.dart';
import 'package:template_vgv_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
```

- [ ] **Step 5: Commit**

```bash
git add lib/bootstrap.dart lib/app/ lib/main_development.dart lib/main_staging.dart lib/main_production.dart
git commit -m "feat: wire up bootstrap with Riverpod ProviderScope and GoRouter app"
```

---

## Task 12: l10n Update

**Files:**
- Modify: `lib/l10n/arb/app_en.arb`
- Create: `lib/l10n/arb/app_id.arb`
- Delete: `lib/l10n/arb/app_es.arb`

- [ ] **Step 1: Tulis ulang `lib/l10n/arb/app_en.arb`**

```json
{
  "@@locale": "en",
  "appTitle": "Flutter Template",
  "@appTitle": {
    "description": "App title"
  },
  "usersPageTitle": "Users",
  "@usersPageTitle": {
    "description": "Title of the users list page"
  },
  "errorRetry": "Retry",
  "@errorRetry": {
    "description": "Label for retry button"
  },
  "loadingLabel": "Loading...",
  "@loadingLabel": {
    "description": "Loading state label"
  }
}
```

- [ ] **Step 2: Buat `lib/l10n/arb/app_id.arb`**

```json
{
  "@@locale": "id",
  "appTitle": "Template Flutter",
  "usersPageTitle": "Pengguna",
  "errorRetry": "Coba Lagi",
  "loadingLabel": "Memuat..."
}
```

- [ ] **Step 3: Hapus file Spanyol**

```bash
rm lib/l10n/arb/app_es.arb
```

- [ ] **Step 4: Generate l10n**

```bash
flutter gen-l10n
```

Expected: `lib/l10n/gen/app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_id.dart` terbentuk tanpa error.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n/
git commit -m "feat: update l10n — replace Spanish with Indonesian, update strings for users template"
```

---

## Task 13: Final Build + All Tests

- [ ] **Step 1: Run build_runner sekali lagi (full)**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: selesai tanpa error. Semua `.g.dart` dan `.freezed.dart` sudah ada.

- [ ] **Step 2: Analyze**

```bash
flutter analyze
```

Expected: `No issues found!` atau hanya info-level warnings.

- [ ] **Step 3: Jalankan semua tests**

```bash
flutter test
```

Expected: semua tests PASS.

- [ ] **Step 4: Build check (development)**

```bash
flutter build apk --debug --flavor development -t lib/main_development.dart 2>&1 | tail -5
```

Expected: `Built build/app/outputs/flutter-apk/app-development-debug.apk`

> Note: Kalau tidak ada flavor config di android, build dengan:
> ```bash
> flutter build apk --debug -t lib/main_development.dart
> ```

- [ ] **Step 5: Final commit**

```bash
git add .
git commit -m "chore: complete riverpod stack migration — clean arch, users feature, full tests"
```

---

## Catatan Penting

### Code Generation
Semua file dengan `part '*.g.dart'` atau `part '*.freezed.dart'` butuh:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Jalankan setiap selesai membuat file dengan annotation `@riverpod`, `@freezed`, `@JsonSerializable`, `@RestApi`, atau `@Envied`.

### Dependency Injection Chain
```
talkerProvider (keepAlive)
    ↓
dioClientProvider (keepAlive)
    ↓
remoteUserDataSourceProvider
    ↓
userRepositoryProvider (keepAlive)
    ↓
getUsersUseCaseProvider
    ↓
usersNotifierProvider
```

### Import Aturan
- `domain/` tidak boleh import dari `data/`
- `presentation/` boleh import dari `domain/` tapi tidak dari `data/models/`
- `presentation/providers/` boleh import dari `data/repositories/` hanya untuk provider definition (DI)

### Test Override Pattern
Untuk test yang butuh override provider:
```dart
ProviderContainer(
  overrides: [userRepositoryProvider.overrideWithValue(mockRepo)],
)
```
Semua provider di atas `userRepositoryProvider` (datasource, dio, talker) ikut ter-replace otomatis.
