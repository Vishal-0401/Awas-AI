import { AuthRepository } from './auth.repository';
import { generateToken, generateRefreshToken } from '../../common/utils/auth.utils';
import { AuthProvider, Role } from '@prisma/client';

export class AuthService {
  private authRepository = new AuthRepository();

  async googleLogin(idToken: string) {
    try {
      // Verify Google token using fetch
      const response = await fetch(`https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`);
      if (!response.ok) {
        throw new Error('Invalid Google token');
      }
      
      const payload = await response.json();
      const { sub: googleId, email, name, picture } = payload;

      let user = await this.authRepository.findUserByGoogleId(googleId);

      if (!user && email) {
        user = await this.authRepository.findUserByEmail(email);
        if (user) {
          user = await this.authRepository.updateUser(user.id, { googleId, authProvider: AuthProvider.GOOGLE });
        }
      }

      if (!user) {
        user = await this.authRepository.createUser({
          googleId,
          email,
          fullName: name,
          avatar: picture,
          authProvider: AuthProvider.GOOGLE,
          role: Role.CUSTOMER,
          isVerified: true, // Google emails are verified
        });
      }

      return this.generateAuthTokens(user.id, user.role);
    } catch (error) {
      throw new Error('Failed to authenticate with Google');
    }
  }

  async sendOtp(phone: string) {
    // Mock OTP logic
    return { message: 'OTP sent successfully', mockOtp: '123456' };
  }

  async verifyOtp(phone: string, otp: string) {
    if (otp !== '123456') {
      throw new Error('Invalid OTP');
    }

    let user = await this.authRepository.findUserByPhone(phone);
    if (!user) {
      user = await this.authRepository.createUser({
        phone,
        authProvider: AuthProvider.LOCAL,
        role: Role.CUSTOMER,
        isVerified: true,
      });
    }

    return this.generateAuthTokens(user.id, user.role);
  }

  async refreshToken(token: string) {
    const refreshTokenRecord = await this.authRepository.findRefreshToken(token);
    if (!refreshTokenRecord || refreshTokenRecord.expiresAt < new Date()) {
      throw new Error('Invalid or expired refresh token');
    }

    // Optional: Rotate refresh token
    await this.authRepository.deleteRefreshToken(token);

    return this.generateAuthTokens(refreshTokenRecord.user.id, refreshTokenRecord.user.role);
  }
  
  async logout(token: string) {
    await this.authRepository.deleteRefreshToken(token);
  }

  private async generateAuthTokens(userId: string, role: Role) {
    const accessToken = generateToken(userId, role);
    const refreshToken = generateRefreshToken(userId, role);
    
    // Save refresh token
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // 7 days from now
    
    await this.authRepository.saveRefreshToken(userId, refreshToken, expiresAt);

    return {
      accessToken,
      refreshToken,
      user: await this.authRepository.findUserById(userId)
    };
  }
}
