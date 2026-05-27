import rateLimit from 'express-rate-limit';

export const otpRateLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 5,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many OTP requests. Please wait before trying again.',
    data: null,
    error: { code: 'RATE_LIMITED', details: null }
  }
});

export const apiRateLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 180,
  standardHeaders: true,
  legacyHeaders: false
});
