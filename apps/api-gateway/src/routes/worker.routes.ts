/**
 * Worker Routes
 * 
 * Worker profile, KYC, availability, and earnings management.
 */

import { Router, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import { asyncHandler, ApiError } from '../middleware/errorHandler';
import { requireRole } from '../middleware/auth';

const router = Router();

// All routes require worker or admin role
router.use(requireRole('worker', 'admin', 'super_admin'));

/**
 * @route   GET /api/v1/workers/profile
 * @desc    Get worker profile
 * @access  Private (Worker)
 */
router.get('/profile', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: { user: req.user },
  });
}));

/**
 * @route   PUT /api/v1/workers/profile
 * @desc    Update worker profile
 * @access  Private (Worker)
 */
router.put('/profile', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Profile updated successfully',
  });
}));

/**
 * @route   GET /api/v1/workers/kyc/status
 * @desc    Get KYC verification status
 * @access  Private (Worker)
 */
router.get('/kyc/status', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: { status: 'pending', requiredDocuments: ['aadhaar', 'pan', 'police_verification'] },
  });
}));

/**
 * @route   POST /api/v1/workers/kyc/documents
 * @desc    Upload KYC documents
 * @access  Private (Worker)
 */
router.post('/kyc/documents', asyncHandler(async (req: Request, res: Response) => {
  const { type, documentNumber, frontImage, backImage } = req.body;
  
  if (!type || !frontImage) {
    throw new ApiError('Document type and front image are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Document uploaded for verification',
  });
}));

/**
 * @route   POST /api/v1/workers/status
 * @desc    Update worker online/offline status
 * @access  Private (Worker)
 */
router.post('/status', asyncHandler(async (req: Request, res: Response) => {
  const { status } = req.body;
  
  if (!['online', 'offline', 'available', 'busy'].includes(status)) {
    throw new ApiError('Invalid status', StatusCodes.BAD_REQUEST, 'INVALID_STATUS');
  }
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: `Status updated to ${status}`,
  });
}));

/**
 * @route   GET /api/v1/workers/earnings
 * @desc    Get earnings summary and history
 * @access  Private (Worker)
 */
router.get('/earnings', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      totalEarnings: 0,
      pendingSettlement: 0,
      settledAmount: 0,
      transactions: [],
    },
  });
}));

/**
 * @route   POST /api/v1/workers/earnings/withdraw
 * @desc    Request withdrawal to bank account
 * @access  Private (Worker)
 */
router.post('/earnings/withdraw', asyncHandler(async (req: Request, res: Response) => {
  const { amount } = req.body;
  
  if (!amount || amount < 100) {
    throw new ApiError('Minimum withdrawal amount is ₹100', StatusCodes.BAD_REQUEST, 'INVALID_AMOUNT');
  }
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Withdrawal request submitted',
    data: { withdrawalId: 'wd_' + Date.now(), amount },
  });
}));

/**
 * @route   GET /api/v1/workers/jobs
 * @desc    Get assigned jobs history
 * @access  Private (Worker)
 */
router.get('/jobs', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: { jobs: [], pagination: { page: 1, total: 0 } },
  });
}));

export { router as workerRoutes };