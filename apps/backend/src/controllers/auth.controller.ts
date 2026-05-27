import { Request, Response } from 'express';
import { authService } from '../services/auth.service';
import { created, ok } from '../utils/response';

export class AuthController {
  sendOtp = async (req: Request, res: Response): Promise<void> => {
    created(res, await authService.sendOtp({ ...req.body, ipAddress: req.ip }), 'OTP sent');
  };

  verifyOtp = async (req: Request, res: Response): Promise<void> => {
    ok(res, await authService.verifyOtp(req.body), 'OTP verified');
  };

  google = async (req: Request, res: Response): Promise<void> => {
    ok(res, await authService.googleLogin(req.body), 'Google login successful');
  };

  refresh = async (req: Request, res: Response): Promise<void> => {
    ok(res, await authService.refresh(req.body.refreshToken), 'Token refreshed');
  };

  logout = async (req: Request, res: Response): Promise<void> => {
    await authService.logout(req.body.refreshToken as string | undefined);
    ok(res, { loggedOut: true }, 'Logged out');
  };
}
