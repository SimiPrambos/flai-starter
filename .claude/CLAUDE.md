# flai-starter

Flutter enterprise starter — Clean Architecture, Riverpod, GoRouter.

## Project Purpose

Reusable Flutter starter for future apps. The built-in example feature is `users`, backed by `reqres.in`. Treat it as a reference implementation for new features, not as one-off demo code.

## Stack

- State + DI: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- Routing: `go_router` with manual typed route classes/extensions
- Network: `dio`, `retrofit`, `connectivity_plus`
- Models: `freezed`, `json_serializable`
- Errors: `fpdart` `Either<Failure, T>`
- Env: `envied`
- Logging: `talker`, `talker_dio_logger`, `talker_flutter`, `talker_riverpod_logger`
- Observability: Firebase Core, Crashlytics, Analytics
- UI utilities: `gap`, `cached_network_image`, `skeletonizer`, `flutter_screenutil`

## Specialist Skills

Load the relevant skill before working in each area:

| Topic | Skill | When to load |
|---|---|---|
| Architecture & layers | @skills/architecture/SKILL.md | Adding features, checking imports |
| Navigation / routing | @skills/navigation/SKILL.md | Adding routes, screen navigation |
| Riverpod providers | @skills/riverpod/SKILL.md | Creating providers or notifiers |
| Error handling | @skills/error-handling/SKILL.md | Writing repos, handling failures |
| Network / API | @skills/network/SKILL.md | Adding endpoints, Dio config |
| Responsive UI | @skills/responsive-ui/SKILL.md | Writing widget dimensions |
| Loading skeletons | @skills/loading-states/SKILL.md | Adding loading placeholders |
| Theme & shared UI | @skills/theme/SKILL.md | Colors, text styles, spacing |
| Testing | @skills/testing/SKILL.md | Writing any test |
| Firebase & Talker | @skills/firebase-talker/SKILL.md | Logging, analytics, Crashlytics |
| Generated files | @skills/generated-files/SKILL.md | Build runner, env, constraints |
