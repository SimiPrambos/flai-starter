# Auth — Changelog

## 2026-10-02 — Implemented
**Trigger:** Back-port E executed
**Changed:** SplashPage, LoginPage (mock), session gate via SessionNotifier + resolveRedirect; spec moved to review. Acceptance criteria covered by passing tests are ticked; the l10n criterion stays open because tests assert only EN strings for the login page (ID is not asserted)
**Code affected:** lib/features/auth/presentation/pages/{splash_page,login_page}.dart, lib/core/auth/*, lib/core/router/{app_router,redirect_resolver}.dart
**Status:** applied

## 2026-10-02 — Initial spec
**Trigger:** Back-port E (session gate + tab shell) from a downstream project, simplified to a single signed-in flag
**Changed:** New feature: SplashPage (loader only), LoginPage (mock email + sign-in button), session gate via router redirect
**Code affected:** none yet — spec only
**Status:** applied
