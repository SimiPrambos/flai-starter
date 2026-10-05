# Auth — Changelog

## 2026-10-02 — Implemented
**Trigger:** Session gate + tab shell implemented
**Changed:** SplashPage, LoginPage (mock), session gate via SessionNotifier + resolveRedirect; spec moved to review. Every acceptance criterion is covered by a passing test, including the Indonesian strings (`pumpApp` gained an optional `locale` for this)
**Code affected:** lib/features/auth/presentation/pages/{splash_page,login_page}.dart, lib/core/auth/*, lib/core/router/{app_router,redirect_resolver}.dart
**Status:** applied

## 2026-10-02 — Initial spec
**Trigger:** Session gate + tab shell, simplified to a single signed-in flag
**Changed:** New feature: SplashPage (loader only), LoginPage (mock email + sign-in button), session gate via router redirect
**Code affected:** none yet — spec only
**Status:** applied
