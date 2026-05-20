/**
 * AWAS-AI API Gateway
 * 
 * Main entry point for the API Gateway service.
 * Handles routing, authentication, rate limiting, and request distribution to microservices.
 */

import express, { Application, Request, Response, NextFunction } from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import morgan from 'morgan';
import cookieParser from 'cookie-parser';
import rateLimit from 'express-rate-limit';
import promClient from 'prom-client';

import { config, isProduction } from '@awas-ai/config';
import { logger } from './utils/logger';
import { errorHandler } from './middleware/errorHandler';
import { requestLogger } from './middleware/requestLogger';
import { authMiddleware } from './middleware/auth';
import { routes } from './routes';
import { socketHandler } from './socket';
import { metricsMiddleware } from './middleware/metrics';
import { healthCheck } from './routes/health';
import { swaggerSpec } from './utils/swagger';
import swaggerUi from 'swagger-ui-express';

// ============================================================================
// EXPRESS APPLICATION SETUP
// ============================================================================

const app: Application = express();
const httpServer = createServer(app);

// Socket.io setup with Redis adapter for horizontal scaling
const io = new Server(httpServer, {
  cors: {
    origin: config.SOCKET_CORS_ORIGINS.split(','),
    credentials: true,
  },
  transports: ['websocket', 'polling'],
  pingTimeout: 60000,
  pingInterval: 25000,
});

// ============================================================================
// PROMETHEUS METRICS SETUP
// ============================================================================

if (config.PROMETHEUS_ENABLED) {
  const collectDefaultMetrics = promClient.collectDefaultMetrics;
  collectDefaultMetrics({
    register: promClient.register,
    prefix: 'awas_gateway_',
    labels: {
      service: 'api-gateway',
      environment: config.NODE_ENV,
    },
  });

  // Custom metrics
  const httpRequestDuration = new promClient.Histogram({
    name: 'awas_gateway_http_request_duration_seconds',
    help: 'Duration of HTTP requests in seconds',
    labelNames: ['method', 'route', 'status_code'],
    buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10],
  });

  const activeConnections = new promClient.Gauge({
    name: 'awas_gateway_active_connections',
    help: 'Number of active WebSocket connections',
  });

  app.use(metricsMiddleware(httpRequestDuration));

  // Metrics endpoint
  app.get('/metrics', async (req: Request, res: Response) => {
    res.set('Content-Type', promClient.register.contentType);
    res.end(await promClient.register.metrics());
  });
}

// ============================================================================
// MIDDLEWARE SETUP
// ============================================================================

// Security headers
app.use(helmet(config.HELMET_ENABLED ? undefined : { contentSecurityPolicy: false }));

// CORS configuration
app.use(cors({
  origin: config.CORS_ORIGINS.split(','),
  credentials: config.CORS_CREDENTIALS,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-ID'],
}));

// Request parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());
app.use(compression());

// HTTP request logging
if (isProduction()) {
  app.use(morgan('combined', {
    stream: { write: (message: string) => logger.info(message.trim()) },
  }));
} else {
  app.use(morgan('dev'));
}

// Request ID and logging
app.use(requestLogger);

// Rate limiting
const limiter = rateLimit({
  windowMs: config.RATE_LIMIT_WINDOW_MS,
  max: config.RATE_LIMIT_MAX_REQUESTS,
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later.',
    },
  },
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);

// Health check endpoint (no auth required)
app.use('/health', healthCheck);

// API Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  explorer: true,
  customCss: '.swagger-ui .topbar { display: none }',
}));

// ============================================================================
// AUTHENTICATION MIDDLEWARE
// ============================================================================

// Apply auth middleware to all API routes except public ones
app.use('/api/', authMiddleware);

// ============================================================================
// API ROUTES
// ============================================================================

app.use('/api/v1', routes);

// ============================================================================
// SOCKET.IO SETUP
// ============================================================================

socketHandler(io);

// ============================================================================
// ERROR HANDLING
// ============================================================================

// 404 handler
app.use((req: Request, res: Response, next: NextFunction) => {
  res.status(404).json({
    success: false,
    error: {
      code: 'NOT_FOUND',
      message: `Route ${req.method} ${req.path} not found`,
    },
  });
});

// Global error handler
app.use(errorHandler);

// ============================================================================
// GRACEFUL SHUTDOWN
// ============================================================================

const gracefulShutdown = async (signal: string) => {
  logger.info(`Received ${signal}. Starting graceful shutdown...`);
  
  // Stop accepting new connections
  httpServer.close(() => {
    logger.info('HTTP server closed.');
  });

  // Disconnect socket.io clients
  io.close(() => {
    logger.info('Socket.io server closed.');
  });

  // Close database connections, Redis, etc.
  // await closeDatabaseConnections();
  // await closeRedisConnections();

  logger.info('Graceful shutdown completed.');
  process.exit(0);
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Handle uncaught exceptions
process.on('uncaughtException', (error: Error) => {
  logger.error('Uncaught Exception:', error);
  process.exit(1);
});

process.on('unhandledRejection', (reason: unknown, promise: Promise<unknown>) => {
  logger.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// ============================================================================
// SERVER START
// ============================================================================

const PORT = config.PORT || 3000;

httpServer.listen(PORT, () => {
  logger.info(`🚀 AWAS-AI API Gateway is running on port ${PORT}`);
  logger.info(`📚 API Documentation: http://localhost:${PORT}/api-docs`);
  logger.info(`🏥 Health Check: http://localhost:${PORT}/health`);
  logger.info(`📊 Metrics: http://localhost:${PORT}/metrics`);
  logger.info(`🌍 Environment: ${config.NODE_ENV}`);
});

export { app, httpServer, io };