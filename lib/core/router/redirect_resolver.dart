/// Pure session-gate rules used by `appRouter`'s `redirect`.
///
/// - Signed out and not on [loginPath] → [loginPath].
/// - Signed in and on [loginPath] or [splashPath] → [homePath].
/// - Otherwise → `null` (stay).
///
/// Callers must not invoke this while the session is still loading; the
/// router returns `null` in that case so the splash stays visible.
String? resolveRedirect({
  required bool isSignedIn,
  required String location,
  required String loginPath,
  required String splashPath,
  required String homePath,
}) {
  if (!isSignedIn) return location == loginPath ? null : loginPath;
  if (location == loginPath || location == splashPath) return homePath;
  return null;
}
