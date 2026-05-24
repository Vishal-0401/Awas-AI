/**
 * AWAS-AI Dispatch Service
 * =========================
 * Uber-like worker dispatch engine with Redis geo-spatial indexing.
 * Handles real-time worker location tracking and job assignment.
 */

import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import helmet from 'helmet';
import { config } from '@awas-ai/config';
import { logger } from './utils/logger';

import { DispatchEngine } from './services/dispatch.engine';// Mock socket handlers until the module is created
const setupSocketHandlers = (io: Server) => {
  logger.info('Setting up socket handlers...');
};
const app = express();
const server = createServer(app);

// Socket.io setup with CORS
const io = new Server(server, {
  cors: {
    origin: config.ALLOWED_ORIGINS,
    methods: ['GET', 'POST'],
    credentials: true,
  },
  transports: ['websocket', 'polling'],
});

// Middleware
app.use(helmet());
app.use(cors({ origin: config.ALLOWED_ORIGINS }));
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'dispatch-service',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
  res.json({
    activeWorkers: DispatchEngine.getActiveWorkerCount(),
    pendingJobs: DispatchEngine.getPendingJobCount(),
    uptime: process.uptime(),
  });
});

// Initialize services
async function bootstrap() {
  try {
    // Initialize Redis
    async function bootstrap() {
  try {
    // Initialize Redis
    RedisService.getInstance();
    logger.info('Redis initialized');

    // Initialize dispatch engine
    await DispatchEngine.initialize();
    logger.info('Dispatch engine initialized');

    // Setup Socket.io handlers
    setupSocketHandlers(io);
    logger.info('Socket.io handlers configured');

    // Start server
    const port = config.PORT || 3001;

    server.listen(port, '0.0.0.0', () => {
      logger.info(`Dispatch service listening on port ${port}`);
    });

    // Graceful shutdown
    process.on('SIGTERM', async () => {
      logger.info('SIGTERM received, shutting down gracefully');

      server.close(async () => {
        try {
          const redis = RedisService.getInstance();

          if (redis?.disconnect) {
            await redis.disconnect();
          }

          logger.info('Redis disconnected');
        } catch (error) {
          logger.error('Redis shutdown error', error);
        }

        process.exit(0);
      });
    });

  } catch (error) {
    logger.error('Failed to bootstrap dispatch service', error);
    process.exit(1);
  }
}

    logger.info('Redis connected successfully');

    // Initialize dispatch engine
    await DispatchEngine.initialize();
    logger.info('Dispatch engine initialized');

    // Setup Socket.io handlers
    setupSocketHandlers(io);
    logger.info('Socket.io handlers configured');

    // Start server
    const port = config.PORT || 3001;
    server.listen(port, '0.0.0.0', () => {
      logger.info(`Dispatch service listening on port ${port}`);
    });

    // Graceful shutdown
    process.on('SIGTERM', () => {
      logger.info('SIGTERM received, shutting down gracefully');
      server.close(() => {
        RedisService.getInstance().disconnect();
        process.exit(0);
      });
    });

  } catch (error) {
    logger.error('Failed to bootstrap dispatch service', error);
    process.exit(1);
  }
}

bootstrap();

export { app, server, io };