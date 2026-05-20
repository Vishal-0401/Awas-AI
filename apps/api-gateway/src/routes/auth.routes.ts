/**
 * Authentication Routes
 * 
 * Handles user registration, login, OTP verification, and token management.
 */

import { Router, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import { asyncHandler, ApiError } from '../middleware/errorHandler';
import { generateAccessToken, generateRefreshToken, verifyRefreshToken, blacklistToken } from '../middleware/auth';
import { logger } from '../utils/logger';

const router = Router();

// ============================================================================
// ROUTE DEFINITIONS
// ============================================================================

/**
 * @route   POST /api/v1/auth/send-otp
 * @desc    Send OTP to phone number for authentication
 * @access  Public
 */
router.post('/send-otp', asyncHandler(async (req: Request, res: Response) => {
  const { phone } = req.body;
  
  if (!phone) {
    throw new ApiError('Phone number is required', StatusCodes.BAD_REQUEST, 'MISSING_PHONE');
  }
  
  // TODO: Integrate with SMS service
  // 1. Generate 6-digit OTP
  // 2. Store in Redis with 5-minute TTL
  // 3. Send via SMS provider (Twilio/Msg91/TextLocal)
  
  logger.info('OTP sent', { phone });
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'OTP sent successfully',
    data: {
      expiresIn: 300, // 5 minutes
    },
  });
}));

/**
 * @route   POST /api/v1/auth/verify-otp
 * @desc    Verify OTP and return JWT tokens
 * @access  Public
 */
router.post('/verify-otp', asyncHandler(async (req: Request, res: Response) => {
  const { phone, otp, firstName, lastName, email } = req.body;
  
  if (!phone || !otp) {
    throw new ApiError('Phone and OTP are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  // TODO: Verify OTP from Redis
  // 1. Check if OTP matches
  // 2. Check if OTP is not expired
  // 3. Delete OTP from Redis
  
  // TODO: Check if user exists
  // If new user, create account with provided details
  
  // Generate tokens
  const user = {
    id: 'user_' + Date.now(), // Replace with actual user ID
    email: email || `${phone}@awas-ai.com`,
    phone,
    role: 'customer' as const,
    firstName: firstName || 'User',
    lastName: lastName || '',
  };
  
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);
  
  logger.info('User authenticated', { userId: user.id, phone });
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Authentication successful',
    data: {
      user: {
        id: user.id,
        email: user.email,
        phone: user.phone,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      },
      tokens: {
        accessToken,
        refreshToken,
        expiresIn: 900, // 15 minutes
      },
    },
  });
}));

/**
 * @route   POST /api/v1/auth/refresh
 * @desc    Refresh access token using refresh token
 * @access  Public
 */
router.post('/refresh', asyncHandler(async (req: Request, res: Response) => {
  const { refreshToken } = req.body;
  
  if (!refreshToken) {
    throw new ApiError('Refresh token is required', StatusCodes.BAD_REQUEST, 'MISSING_REFRESH_TOKEN');
  }
  
  // Verify refresh token
  const decoded = verifyRefreshToken(refreshToken);
  
  // Generate new access token
  const newAccessToken = generateAccessToken({
    id: decoded.id,
    email: decoded.email,
    role: decoded.role,
  });
  
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      accessToken: newAccessToken,
      expiresIn: 900, // 15 minutes
    },
  });
}));

/**
 * @route   POST /api/v1/auth/logout
 * @desc    Logout user and blacklist tokens
 * @access  Private
 */
router.post('/logout', asyncHandler(async (req: Request, res: Response) => {
  const { refreshToken } = req.body;
  const accessToken = req.headers.authorization?.substring(7);
  
  // Blacklist access token
  if (accessToken) {
    blacklistToken(accessToken);
  }
  
  // Blacklist refresh token
  if (refreshToken) {
    blacklistToken(refreshToken);
  }
  
  // TODO: Also blacklist in Redis for distributed systems
  
  logger.info('User logged out', { userId: req.user?.id });
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Logged out successfully',
  });
}));

/**
 * @route   POST /api/v1/auth/register/worker
 * @desc    Register as a worker
 * @access  Public
 */
router.post('/register/worker', asyncHandler(async (req: Request, res: Response) => {
  const { phone, email, firstName, lastName, categories, experience } = req.body;
  
  if (!phone || !firstName || !categories) {
    throw new ApiError('Phone, name, and service categories are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  // TODO: Create worker account
  // 1. Create user with worker role
  // 2. Create worker profile
  // 3. Send welcome SMS/email
  // 4. Trigger KYC flow
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Worker registration initiated. Please complete KYC verification.',
    data: {
      nextSteps: [
        'Complete KYC verification',
        'Upload documents (Aadhaar, PAN)',
        'Add bank account details',
        'Set service areas',
      ],
    },
  });
}));

/**
 * @route   GET /api/v1/auth/me
 * @desc    Get current user profile
 * @access  Private
 */
router.get('/me', asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    throw new ApiError('Authentication required', StatusCodes.UNAUTHORIZED, 'AUTH_REQUIRED');
  }
  
  // TODO: Fetch full user profile from database
  
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      user: req.user,
      // Add more profile details from database
    },
  });
}));

export { router as authRoutes };