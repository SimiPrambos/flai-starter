# 001. Single signed-in flag instead of roles

**Date:** 2026-10-02
**Status:** accepted

## Decision
The starter gates routing on one persisted boolean (`SessionNotifier`), not on a role enum.

## Why
Most apps built from the starter start with one audience. A boolean keeps the redirect to three rules and the shell to one `TabConfig` list. The multi-role pattern is documented in the `flai-auth-navigation` skill ("Extending to roles"), so it can be added later without reworking the router.

## Rejected alternatives
- Role enum with one shell per role — every consumer would have to delete a role picker and a second shell they do not need.
- Deriving "signed in" from an access-token read — couples routing to an auth backend the starter does not have.
