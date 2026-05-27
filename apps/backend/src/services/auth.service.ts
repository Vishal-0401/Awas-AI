import { randomUUID } from 'crypto';
import { env } from '../config/env';
import { OtpPurpose, UserDto } from '../dto/domain';
import { compareSecret, generateOtp, hashSecret } from '../utils/crypto';
import { ConflictAppError, NotFoundAppError, UnauthorizedAppError, ValidationAppError } from '../utils/AppError';
import { signAccessToken, signRefreshToken, verifyRefreshToken } from '../utils/jwt';
import { otpRepository, tokenRepository, userRepository } from '../repositories/store';

export interface AuthResult {
  accessToken: string;
  refreshToken: string;
  user: UserDto;
  isProfileComplete: boolean;
}

class AuthService {
  async sendOtp(input: { phone?: string; email?: string; purpose?: OtpPurpose; ipAddress?: string; deviceId?: string }): Promise<{ otpSessionId: string; expiresIn: number; resendAfter: number; debugOtp?: string }> {
    if (!input.phone && !input.email) throw new ValidationAppError('Phone or email is required');

    const otp = env.enableMockOtp ? '123456' : generateOtp();
    const otpHash = await hashSecret(otp);
    const expiresAt = new Date(Date.now() + env.otpTtlMinutes * 60 * 1000).toISOString();
    const session = otpRepository.save({
      id: randomUUID(),
      phone: input.phone,
      email: input.email,
      purpose: input.purpose ?? 'LOGIN',
      otpHash,
      status: 'PENDING',
      attempts: 0,
      expiresAt,
      ipAddress: input.ipAddress,
      deviceId: input.deviceId,
      createdAt: new Date().toISOString()
    });

    return {
      otpSessionId: session.id,
      expiresIn: env.otpTtlMinutes * 60,
      resendAfter: 30,
      debugOtp: env.nodeEnv === 'production' ? undefined : otp
    };
  }

  async verifyOtp(input: { otpSessionId?: string; phone?: string; email?: string; otp: string; purpose?: OtpPurpose }): Promise<AuthResult> {
    const session = input.otpSessionId
      ? otpRepository.findById(input.otpSessionId)
      : otpRepository.findLatestPending({ phone: input.phone, email: input.email }, input.purpose ?? 'LOGIN');

    if (!session) throw new NotFoundAppError('OTP session not found');
    if (session.status !== 'PENDING') throw new ConflictAppError('OTP session is not pending');
    if (new Date(session.expiresAt).getTime() < Date.now()) {
      session.status = 'EXPIRED';
      otpRepository.save(session);
      throw new UnauthorizedAppError('OTP expired');
    }
    if (session.attempts >= env.otpMaxAttempts) {
      session.status = 'LOCKED';
      otpRepository.save(session);
      throw new UnauthorizedAppError('OTP attempts exceeded');
    }

    const matches = await compareSecret(input.otp, session.otpHash);
    session.attempts += 1;
    if (!matches) {
      otpRepository.save(session);
      throw new UnauthorizedAppError('Invalid OTP');
    }

    session.status = 'VERIFIED';
    session.verifiedAt = new Date().toISOString();
    otpRepository.save(session);

    const user = userRepository.upsertLocal({ phone: session.phone, email: session.email });
    userRepository.updateProfile(user.id, { isProfileComplete: user.isProfileComplete });
    return this.issueTokens(user);
  }

  async googleLogin(input: { idToken: string }): Promise<AuthResult> {
    if (input.idToken.length < 8) throw new UnauthorizedAppError('Invalid Google token');
    const googleId = `google_${Buffer.from(input.idToken).toString('base64url').slice(0, 18)}`;
    const existing = userRepository.findByGoogleId(googleId);
    const user =
      existing ??
      userRepository.save({
        id: randomUUID(),
        fullName: 'Google User',
        email: `google-${googleId}@example.local`,
        googleId,
        authProvider: 'GOOGLE',
        role: 'CUSTOMER',
        isVerified: true,
        isProfileComplete: false,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      });
    return this.issueTokens(user);
  }

  async refresh(refreshToken: string): Promise<AuthResult> {
    const payload = verifyRefreshToken(refreshToken);
    if (!payload.tokenFamily) throw new UnauthorizedAppError('Invalid refresh token');
    const tokenRecord = tokenRepository.findById(payload.jti ?? '');
    if (!tokenRecord || tokenRecord.revokedAt) {
      tokenRepository.revokeFamily(payload.tokenFamily);
      throw new UnauthorizedAppError('Refresh token reuse detected');
    }
    const validSecret = await compareSecret(refreshToken, tokenRecord.tokenHash);
    if (!validSecret) {
      tokenRepository.revokeFamily(payload.tokenFamily);
      throw new UnauthorizedAppError('Invalid refresh token');
    }
    tokenRepository.revoke(tokenRecord.id);
    const user = userRepository.findById(payload.sub);
    if (!user) throw new UnauthorizedAppError('User no longer exists');
    return this.issueTokens(user, payload.tokenFamily);
  }

  async logout(refreshToken?: string): Promise<void> {
    if (!refreshToken) return;
    const payload = verifyRefreshToken(refreshToken);
    if (payload.tokenFamily) tokenRepository.revokeFamily(payload.tokenFamily);
  }

  private async issueTokens(user: UserDto, existingFamily?: string): Promise<AuthResult> {
    const tokenFamily = existingFamily ?? randomUUID();
    const refreshId = randomUUID();
    const accessToken = signAccessToken({ sub: user.id, role: user.role, tokenFamily });
    const refreshToken = signRefreshToken({ sub: user.id, role: user.role, tokenFamily, tokenId: refreshId });
    tokenRepository.save({
      id: refreshId,
      tokenHash: await hashSecret(refreshToken),
      userId: user.id,
      tokenFamily,
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
      createdAt: new Date().toISOString()
    });
    return { accessToken, refreshToken, user, isProfileComplete: user.isProfileComplete };
  }
}

export const authService = new AuthService();
