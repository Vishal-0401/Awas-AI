/**
 * API Routes Index
 * 
 * Central routing configuration for all API v1 endpoints.
 */

import { Router } from 'express';
import { authRoutes } from './auth.routes';
import { userRoutes } from './user.routes';
import { workerRoutes } from './worker.routes';
import { jobRoutes } from './job.routes';
import { paymentRoutes } from './payment.routes';
import { aiRoutes } from './ai.routes';
import { notificationRoutes } from './notification.routes';
import { supportRoutes } from './support.routes';
import { adminRoutes } from './admin.routes';
import { healthRoutes } from './health.routes';
import { requireRole } from '../middleware/auth';

const router = Router();

// ============================================================================
// PUBLIC ROUTES
// ============================================================================

// Health check
router.use('/health', healthRoutes);

// Authentication (public)
router.use('/auth', authRoutes);

// ============================================================================
// PROTECTED ROUTES
// ============================================================================

// User routes (customer)
router.use('/users', userRoutes);

// Worker routes
router.use('/workers', workerRoutes);

// Job routes
router.use('/jobs', jobRoutes);

// Payment routes
router.use('/payments', paymentRoutes);

// AI routes
router.use('/ai', aiRoutes);

// Notification routes
router.use('/notifications', notificationRoutes);

// Support routes
router.use('/support', supportRoutes);

// ============================================================================
// ADMIN ROUTES (require admin role)
// ============================================================================

router.use('/admin', requireRole('admin', 'super_admin'), adminRoutes);

// ============================================================================
// 404 for unknown routes
// ============================================================================

router.all('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: {
      code: 'ROUTE_NOT_FOUND',
      message: `Route ${req.method} ${req.path} not found`,
    },
  });
});

export { router as routes };