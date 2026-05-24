# TODO.md

## Authentication system (Firebase Phone OTP + Password login)

### Backend (apps/backend-core)
- [ ] Update `apps/backend-core/src/prisma/schema.prisma`:
  - [ ] add `passwordHash` and `lastLoginAt` to `User`
  - [ ] add `OtpSession` model for `otp_sessions`
- [ ] Implement Firebase Admin support:
  - [ ] create `apps/backend-core/src/modules/auth/firebase.service.ts`
- [ ] Implement OTP session service:
  - [ ] create `apps/backend-core/src/modules/auth/otp.service.ts`
- [ ] Replace mock OTP in `apps/backend-core/src/modules/auth/auth.service.ts` with real Flow A:
  - [ ] `POST /auth/send-otp` creates otp session + rate limits
  - [ ] `POST /auth/verify-otp` verifies `{ phone, verificationId, smsCode }` using Firebase Admin
  - [ ] checks user existence and returns profileIncomplete vs authenticated
- [ ] Add endpoints:
  - [ ] `POST /auth/complete-profile`
  - [ ] `POST /auth/login` (bcrypt)
- [ ] Update controllers + routes + validators:
  - [ ] add new Zod schemas for verify/login/complete-profile payloads
  - [ ] update `auth.controller.ts` + `auth.routes.ts`

### Flutter (apps/customer-app)
- [ ] Add Firebase Phone Auth integration (phone->verificationId->smsCode)
- [ ] Update `OtpScreen` to call backend verify endpoint with `{ phone, verificationId, smsCode }`
- [ ] Implement resend code logic
- [ ] Add `CompleteProfileScreen` + connect to `/auth/complete-profile`
- [ ] Add `PasswordLoginScreen` + connect to `/auth/login`
- [ ] Update `AuthService` + `AuthNotifier` for:
  - [ ] profileIncomplete handling
  - [ ] token persistence + refresh
  - [ ] logout
- [ ] Update routing (route_paths/routes/router)

### End-to-end validation
- [ ] Run Prisma migrate
- [ ] Start backend and test:
  - [ ] OTP login for new user -> complete profile -> JWT issued
  - [ ] OTP login for existing user -> JWT issued
  - [ ] Password login works
- [ ] Start Flutter and test same end-to-end flows

