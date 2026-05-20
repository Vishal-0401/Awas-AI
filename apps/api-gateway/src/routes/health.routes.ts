/**
 * Health Check Routes
 * 
 * System health monitoring and status endpoints.
 */

import { Router, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';

const router = Router();

/**
 * @route   GET /health
 * @desc    Basic health check
 * @access  Public
 */
router.get('/', (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    service: 'api-gateway',
    version: process.env.npm_package_version || '1.0.0',
  });
});

/**
 * @route   GET /health/ready
 * @desc    Readiness probe - checks if service is ready to accept traffic
 * @access  Public
 */
router.get('/ready', (req: Request, res: Response) => {
  // TODO: Add dependency health checks
  // - Database connectivity
  // - Redis connectivity
  // - Message queue connectivity
  
  res.status(StatusCodes.OK).json({
    success: true,
    status: 'ready',
    checks: {
      database: 'healthy',
      redis: 'healthy',
      messageQueue: 'healthy',
    },
    timestamp: new Date().toISOString(),
  });
});

/**
 * @route   GET /health/live
 * @desc    Liveness probe - checks if service is alive
 * @access  Public
 */
router.get('/live', (req: Request, res: Response) => {
  res.status(StatusCodes.OK).json({
    success: true,
    status: 'alive',
    timestamp: new Date().toISOString(),
  });
});

/**
 * @route   GET /health/detailed
 * @desc    Detailed system information
 * @access  Public (or Admin only in production)
 */
router.get('/detailed', (req: Request, res: Response) => {
  const memoryUsage = process.memoryUsage();
  
  res.status(StatusCodes.OK).json({
    success: true,
    status: 'healthy',
    timestamp: new Date().toISOString(),
    system: {
      uptime: process.uptime(),
      memory: {
        rss: memoryUsage.rss,
        heapTotal: memoryUsage.heapTotal,
        heapUsed: memoryUsage.heapUsed,
        external: memoryUsage.external,
      },
      platform: process.platform,
      nodeVersion: process.version,
      pid: process.pid,
    },
    environment: process.env.NODE_ENV || 'development',
    version: process.env.npm_package_version || '1.0.0',
  });
});

export { router as healthRoutes };