import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { googleLoginSchema, sendOtpSchema, verifyOtpSchema, refreshTokenSchema } from '../../validators';

export class AuthController {
  private authService = new AuthService();

  googleLogin = async (req: Request, res: Response) => {
    try {
      const { idToken } = googleLoginSchema.parse(req.body);
      const result = await this.authService.googleLogin(idToken);
      return ApiResponse.success(res, 'Google login successful', result);
    } catch (error: any) {
      logger.error('Google login error:', error);
      return ApiResponse.error(res, error.message || 'Invalid request', error.errors || []);
    }
  };

  sendOtp = async (req: Request, res: Response) => {
    try {
      const { phone } = sendOtpSchema.parse(req.body);
      const result = await this.authService.sendOtp(phone);
      return ApiResponse.success(res, 'OTP sent successfully', result);
    } catch (error: any) {
      logger.error('Send OTP error:', error);
      return ApiResponse.error(res, error.message || 'Invalid request', error.errors || []);
    }
  };

  verifyOtp = async (req: Request, res: Response) => {
    try {
      const { phone, otp } = verifyOtpSchema.parse(req.body);
      const result = await this.authService.verifyOtp(phone, otp);
      return ApiResponse.success(res, 'OTP verified successfully', result);
    } catch (error: any) {
      logger.error('Verify OTP error:', error);
      return ApiResponse.error(res, error.message || 'Invalid credentials', error.errors || [], 401);
    }
  };

  refreshToken = async (req: Request, res: Response) => {
    try {
      const { refreshToken } = refreshTokenSchema.parse(req.body);
      const result = await this.authService.refreshToken(refreshToken);
      return ApiResponse.success(res, 'Token refreshed successfully', result);
    } catch (error: any) {
      logger.error('Refresh token error:', error);
      return ApiResponse.error(res, error.message || 'Invalid token', error.errors || [], 401);
    }
  };

  logout = async (req: Request, res: Response) => {
    try {
      const { refreshToken } = req.body;
      if (refreshToken) {
        await this.authService.logout(refreshToken);
      }
      return ApiResponse.success(res, 'Logged out successfully');
    } catch (error: any) {
      logger.error('Logout error:', error);
      return ApiResponse.error(res, 'Logout failed', error.errors || [], 500);
    }
  };
}
