# Template VGV App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Flutter enterprise template — [Very Good CLI][very_good_cli_link] + **Riverpod + Clean Architecture**.

Showcases a **users list** from [reqres.in](https://reqres.in) as an example feature covering all architecture layers: data, domain, and presentation.

---

## Tech Stack

| Category | Package |
|---|---|
| State + DI | `flutter_riverpod`, `riverpod_annotation` (codegen) |
| Navigation | `go_router` |
| Network | `dio`, `retrofit` |
| Model | `freezed_annotation`, `json_annotation` |
| Error handling | `fpdart` (Either) |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Env config | `envied` |
| Logging | `talker`, `talker_dio_logger`, `talker_flutter` |
| Connectivity | `connectivity_plus` |
| UI utilities | `gap`, `cached_network_image`, `shimmer` |

---

## Getting Started 🚀

### Environment Setup

Copy `.env.example` to `.env` and fill in the values:

```sh
cp .env.example .env
```

```
BASE_URL=https://reqres.in/api
API_KEY=free_user_3DZF3qZYzM22ep6mUq6s8UTdhFz
```

### Code Generation

```sh
dart run build_runner build --delete-conflicting-outputs
```

### Flavors

This project contains 3 flavors:

- development
- staging
- production

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Template VGV App works on iOS, Android, Web, and Windows._

---

## Architecture 🏗️

Clean Architecture with dependency rule: `presentation → domain ← data`.  
The domain layer must stay pure Dart + `fpdart` — no Flutter or data layer imports allowed.

```
lib/
├── core/
│   ├── error/          # Failure (freezed sealed) + AppException
│   ├── network/        # Dio client, interceptors, connectivity service
│   ├── router/         # GoRouter config
│   ├── storage/        # SecureStorage + SharedPreferences wrappers
│   ├── logging/        # Talker provider
│   ├── env/            # Envied — BASE_URL, API_KEY
│   └── theme/          # AppColors, AppTextStyles, AppSpacing, AppAssets
├── shared/
│   └── widgets/        # AppButton, AppTextField, AsyncValueWidget
└── features/
    └── users/
        ├── data/         # Retrofit datasource, freezed models, repository impl
        ├── domain/       # UserEntity, UserRepository interface, GetUsersUseCase
        └── presentation/ # UsersNotifier, UsersPage, UserCard, UserCardShimmer
```

---

## Running Tests 🧪

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report:

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

### Testing Strategy

| Layer | Approach |
|---|---|
| UseCase | Pure unit test, mock `UserRepository` with mocktail |
| Repository | Mock `RemoteUserDataSource` |
| Notifier | `ProviderContainer` with `overrides` |
| Widget | `pumpApp()` helper — wraps `ProviderScope + MaterialApp` |

---

## Working with Translations 🌐

This project supports **English** and **Bahasa Indonesia**.

### Adding Strings

Open `lib/l10n/arb/app_en.arb` and add a new key/value pair:

```arb
{
    "@@locale": "en",
    "usersPageTitle": "Users",
    "@usersPageTitle": {
        "description": "Title shown in the AppBar of the Users Page"
    }
}
```

Add the corresponding translation in `app_id.arb`:

```arb
{
    "@@locale": "id",
    "usersPageTitle": "Pengguna"
}
```

### File Structure

```
lib/l10n/arb/
├── app_en.arb
└── app_id.arb
```

### Adding a New Locale

Update the `CFBundleLocalizations` array in `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>id</string>
</array>
```

### Generating Translations

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

---

[coverage_badge]: coverage_badge.svg
[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
