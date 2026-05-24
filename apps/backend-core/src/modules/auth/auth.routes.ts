import { Router } from 'express';
import { AuthController } from './auth.controller';

const router = Router();
const authController = new AuthController();

router.post('/google', authController.googleLogin);
router.post('/send-otp', authController.sendOtp);
router.post('/verify-otp', authController.verifyOtp);
router.post('/refresh-token', authController.refreshToken);
router.post('/logout', authController.logout);

export const authRoutes = router;
