import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import swaggerUi from 'swagger-ui-express';
import yamljs from 'yamljs';
import { rateLimiter } from './common/middleware';
import { errorHandler } from './common/middleware/error.middleware';
import authRoutes from './modules/auth';
import userRoutes from './modules/users';
import workerRoutes from './modules/workers';
import bookingRoutes from './modules/bookings';
import jobRoutes from './modules/jobs';
import walletRoutes from './modules/wallet';
import paymentRoutes from './modules/payments';
import notificationRoutes from './modules/notifications';
import supportRoutes from './modules/support';
import telemetryRoutes from './modules/telemetry';
import adminRoutes from './modules/admin';

dotenv.config();

const app: Application = express();

const swaggerDocument = yamljs.load('./swagger.yaml');

// Security middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Rate limiting
app.use(rateLimiter);

// Health Check
app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({
    status: 'success',
    message: 'Backend Core Service is running.',
    timestamp: new Date().toISOString(),
  });
});

// Swagger Documentation
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// API Routes - v1
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/workers', workerRoutes);
app.use('/api/v1/bookings', bookingRoutes);
app.use('/api/v1/jobs', jobRoutes);
app.use('/api/v1/wallet', walletRoutes);
app.use('/api/v1/payments', paymentRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/support', supportRoutes);
app.use('/api/v1/telemetry', telemetryRoutes);
app.use('/api/v1/admin', adminRoutes);

// Global Error Handler
app.use(errorHandler);

export default app;
