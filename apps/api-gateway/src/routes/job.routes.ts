/**
 * Job Routes
 * 
 * Job creation, tracking, and management.
 */

import { Router, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import { asyncHandler, ApiError } from '../middleware/errorHandler';

const router = Router();

/**
 * @route   POST /api/v1/jobs
 * @desc    Create a new job
 * @access  Private (Customer)
 */
router.post('/', asyncHandler(async (req: Request, res: Response) => {
  const { serviceType, addressId, scheduledAt, priority, description } = req.body;
  
  if (!serviceType || !addressId) {
    throw new ApiError('Service type and address are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Job created successfully',
    data: {
      jobId: 'AWAS-' + Date.now(),
      status: 'searching',
      estimatedTime: 15,
    },
  });
}));

/**
 * @route   GET /api/v1/jobs/:id
 * @desc    Get job details
 * @access  Private
 */
router.get('/:id', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: { job: {} },
  });
}));

/**
 * @route   POST /api/v1/jobs/:id/cancel
 * @desc    Cancel a job
 * @access  Private
 */
router.post('/:id/cancel', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Job cancelled successfully',
  });
}));

/**
 * @route   POST /api/v1/jobs/:id/review
 * @desc    Submit review for completed job
 * @access  Private (Customer)
 */
router.post('/:id/review', asyncHandler(async (req: Request, res: Response) => {
  const { rating, comment, categories } = req.body;
  
  if (!rating || rating < 1 || rating > 5) {
    throw new ApiError('Rating must be between 1 and 5', StatusCodes.BAD_REQUEST, 'INVALID_RATING');
  }
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Review submitted successfully',
  });
}));

/**
 * @route   POST /api/v1/jobs/:id/dispute
 * @desc    Raise a dispute for a job
 * @access  Private (Customer or Worker)
 */
router.post('/:id/dispute', asyncHandler(async (req: Request, res: Response) => {
  const { type, description, evidence } = req.body;
  
  if (!type || !description) {
    throw new ApiError('Dispute type and description are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Dispute raised successfully',
    data: { disputeId: 'DIS-' + Date.now() },
  });
}));

export { router as jobRoutes };