import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller';
import { asyncHandler } from '../utils/asyncHandler';
import { validateBody } from '../middleware/validate';
import { googleLoginSchema, refreshSchema, sendOtpSchema, verifyOtpSchema } from '../validators/schemas';
import { otpRateLimiter } from '../middleware/rateLimit';

const router = Router();
const controller = new AuthController();

router.post('/send-otp', otpRateLimiter, validateBody(sendOtpSchema), asyncHandler(controller.sendOtp));
router.post('/verify-otp', validateBody(verifyOtpSchema), asyncHandler(controller.verifyOtp));
router.post('/google', validateBody(googleLoginSchema), asyncHandler(controller.google));
router.post('/refresh', validateBody(refreshSchema), asyncHandler(controller.refresh));
router.post('/logout', asyncHandler(controller.logout));

export default router;
