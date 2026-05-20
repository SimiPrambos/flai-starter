# Feature: Auth (Login)
**Status:** in-progress

## Overview

Entry point untuk seluruh aplikasi LearnXpert LnD — Trainee Mobile. Trainee harus login dengan email dan password sebelum dapat mengakses Dashboard dan fitur lainnya. Sumber kebenaran PRD: `docs/prd.md` (semua AC mensyaratkan "Trainee opens the app and logs in successfully" sebagai precondition).

---

## Entity

| Field | Type   | Nullable | Notes                              |
|-------|--------|----------|------------------------------------|
| token | String | no       | Bearer token untuk request berikutnya |

---

## API

| Method | Endpoint     | Body                          | Response           |
|--------|--------------|-------------------------------|--------------------|
| POST   | /auth/login  | `{ email, password: String }` | `AuthSingleResponse` → `token: String` |

> **Status:** Endpoint TBD — saat ini pakai `MockAuthRemoteDataSource` (500ms delay, fake token). Ganti ke Retrofit `@RestApi` saat BE siap.

---

## UI States

### LoginPage (`/login`)

- **Idle:** Form dengan email field, password field (ada eye toggle show/hide), tombol Login aktif
- **Loading:** Tombol Login disabled, spinner `CircularProgressIndicator` di dalam tombol
- **Error:** SnackBar muncul dengan `failure.readableMessage` — form tetap terisi, user bisa retry
- **Success:** Navigate ke `/dashboard` via `DashboardRoute().go(context)` — replace (tidak ada back navigation ke login)

**Visual:**
- Background: `LinearGradient(#04040E → #1056D9, top → bottom)`
- Logo: `assets/images/logo_learn_expert.png` (224×88)
- Subtitle: "POWERED  BY  AJARI"
- Decoration bottom: `CustomPaint` arch pattern dari `decoration_bottom_login.svg`
- Footer: "©2026 LearnXpert LnD"

---

## Navigation

- **Entry:** `/login` — `initialLocation` di `appRouter`
- **Success:** `const DashboardRoute().go(context)` — menggantikan login di stack (tidak bisa back)
- **Tidak ada:** forgot password, register, SSO (belum di-scope PRD)

---

## Acceptance Criteria

- [ ] App dibuka → langsung tampil LoginPage (bukan UsersPage atau halaman lain)
- [ ] Email field menerima input dengan keyboard type email
- [ ] Password field default obscured; tap eye icon toggle show/hide
- [ ] Tap Login → tombol disabled + spinner selama proses
- [ ] Login sukses → navigate ke Dashboard, tidak bisa back ke LoginPage
- [ ] Login gagal → SnackBar tampil dengan pesan error, form tetap terisi
- [ ] Email dan password kosong saat submit → (validasi TBD, lihat Open Questions)

---

## Open Questions

- [ ] **Endpoint & response shape** — BE belum provide API spec. Ganti mock ke Retrofit saat tersedia. *(BE Team)*
- [ ] **Token storage** — token perlu disimpan untuk auto-login? `FlutterSecureStorage` sudah ada di dependencies tapi belum digunakan. *(Product Decision)*
- [ ] **Session management** — token expired → redirect ke login atau refresh? *(BE Team)*
- [ ] **Error mapping** — BE akan return error codes berbeda untuk "wrong password" vs "user not found"? Perlu `readableMessage` yang spesifik per kode. *(BE Team)*
- [ ] **Form validation** — apakah validasi client-side (email format, password min-length) diperlukan sebelum hit API? *(Product Decision)*
- [ ] **Auto-login** — apakah app harus skip login jika token masih valid? *(Product Decision)*
- [ ] **Logout flow** — belum ada implementasi logout. Di-scope di fitur mana? *(Product Decision)*
