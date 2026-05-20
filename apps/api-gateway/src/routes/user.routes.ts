/**
 * User Routes
 * 
 * Customer profile management, addresses, and preferences.
 */

import { Router, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import { asyncHandler, ApiError } from '../middleware/errorHandler';
import { requireRole } from '../middleware/auth';

const router = Router();

// All routes require authentication
router.use(requireRole('customer', 'admin', 'super_admin'));

/**
 * @route   GET /api/v1/users/profile
 * @desc    Get user profile
 * @access  Private (Customer)
 */
router.get('/profile', asyncHandler(async (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      user: req.user,
      // TODO: Fetch full profile from database
    },
  });
}));

/**
 * @route   PUT /api/v1/users/profile
 * @desc    Update user profile
 * @access  Private (Customer)
 */
router.put('/profile', asyncHandler(async (req: Request, res: Response) => {
  const { firstName, lastName, email, preferredLanguage } = req.body;
  
  // TODO: Update user in database
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Profile updated successfully',
  });
}));

/**
 * @route   GET /api/v1/users/addresses
 * @desc    Get all saved addresses
 * @access  Private (Customer)
 */
router.get('/addresses', asyncHandler(async (req: Request, res: Response) => {
  // TODO: Fetch addresses from database
  
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      addresses: [],
    },
  });
}));

/**
 * @route   POST /api/v1/users/addresses
 * @desc    Add new address
 * @access  Private (Customer)
 */
router.post('/addresses', asyncHandler(async (req: Request, res: Response) => {
  const { type, label, addressLine1, city, state, pincode, latitude, longitude } = req.body;
  
  if (!addressLine1 || !city || !state || !pincode || !latitude || !longitude) {
    throw new ApiError('All address fields are required', StatusCodes.BAD_REQUEST, 'MISSING_FIELDS');
  }
  
  // TODO: Save address to database
  
  res.status(StatusCodes.CREATED).json({
    success: true,
    message: 'Address added successfully',
  });
}));

/**
 * @route   GET /api/v1/users/orders
 * @desc    Get user's order history
 * @access  Private (Customer)
 */
router.get('/orders', asyncHandler(async (req: Request, res: Response) => {
  const { page = 1, limit = 10, status } = req.query;
  
  // TODO: Fetch orders from database with pagination
  
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      orders: [],
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total: 0,
        totalPages: 0,
      },
    },
  });
}));

/**
 * @route   GET /api/v1/users/wallet
 * @desc    Get wallet balance and transactions
 * @access  Private (Customer)
 */
router.get('/wallet', asyncHandler(async (req: Request, res: Response) => {
  // TODO: Fetch wallet from database
  
  res.status(StatusCodes.OK).json({
    success: true,
    data: {
      balance: 0,
      pendingBalance: 0,
      transactions: [],
    },
  });
}));

/**
 * @route   POST /api/v1/users/wallet/add-money
 * @desc    Add money to wallet
 * @access  Private (Customer)
 */
router.post('/wallet/add-money', asyncHandler(async (req: Request, res: Response) => {
  const { amount, paymentMethod } = req.body;
  
  if (!amount || amount < 100) {
    throw new ApiError('Minimum amount is ₹100', StatusCodes.BAD_REQUEST, 'INVALID_AMOUNT');
  }
  
  // TODO: Process payment and add to wallet
  
  res.status(StatusCodes.OK).json({
    success: true,
    message: 'Money added to wallet',
    data: {
      orderId: 'order_' + Date.now(),
      amount,
    },
  });
}));

export { router as userRoutes };