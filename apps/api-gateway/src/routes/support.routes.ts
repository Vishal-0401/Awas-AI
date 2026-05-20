/**
 * Support Routes
 * 
 * Support tickets and dispute management.
 */

import { Router, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import { asyncHandler, ApiError } from '../middleware/errorHandler';

const router = Router();

/**
 * @route   POST /api/v1/support/tickets
 * @desc    Create a new support ticket
 * @access  Private
 */
router.post('/tickets', asyncHandler(async (req: Request, res: Response) => {
  const { category, priority, subject, description, jobId } = req.body;
  
  if (!category || !subject || !description) {
    throw new ApiError('Category, subject, and description are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Support ticket created',
    data: {
      ticketId: 'TKT-' + Date.now(),
      status: 'open',
    },
  });
}));

/**
 * @route   GET /api/v1/support/tickets
 * @desc    Get all support tickets
 * @access  Private
 */
router.get('/tickets', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: { tickets: [], pagination: { page: 1, total: 0 } },
  });
}));

/**
 * @route   GET /api/v1/support/tickets/:id
 * @desc    Get ticket details with messages
 * @access  Private
 */
router.get('/tickets/:id', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: { ticket: {}, messages: [] },
  });
}));

/**
 * @route   POST /api/v1/support/tickets/:id/message
 * @desc    Send message in ticket
 * @access  Private
 */
router.post('/tickets/:id/message', asyncHandler(async (req: Request, res: Response) => {
  const { message, attachments } = req.body;
  
  if (!message) {
    throw new ApiError('Message is required', StatusCodes.BAD_REQUEST, 'MISSING_MESSAGE');
  }
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Message sent',
  });
}));

/**
 * @route   POST /api/v1/support/disputes
 * @desc    Raise a dispute
 * @access  Private
 */
router.post('/disputes', asyncHandler(async (req: Request, res: Response) => {
  const { jobId, type, description, evidence } = req.body;
  
  if (!jobId || !type || !description) {
    throw new ApiError('Job ID, type, and description are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Dispute raised successfully',
    data: {
      disputeId: 'DIS-' + Date.now(),
      status: 'under_review',
    },
  });
}));

export { router as supportRoutes };