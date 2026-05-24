import cors from 'cors';
import dotenv from 'dotenv';
import express, { Application } from 'express';
import helmet from 'helmet';
import swaggerUi from 'swagger-ui-express';
import yamljs from 'yamljs';
import { rateLimiter } from './common/middleware';
import { errorHandler } from './common/middleware/error.middleware';
import aiRoutes from './modules/ai';
import trackingRoutes from './modules/tracking';
import adminRoutes from './modules/admin';
import authRoutes from './modules/auth';
import bookingRoutes from './modules/bookings';
import jobRoutes from './modules/jobs';
import notificationRoutes from './modules/notifications';
import paymentRoutes from './modules/payments';
import supportRoutes from './modules/support';
import telemetryRoutes from './modules/telemetry';
import userRoutes from './modules/users';
import walletRoutes from './modules/wallet';
import workerRoutes from './modules/workers';
import { healthRoutes } from './routes/health.routes';

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
app.use('/health', healthRoutes);

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
app.use('/api/v1/ai', aiRoutes);
app.use('/api/v1/tracking', trackingRoutes);
app.use('/api/v1/admin', adminRoutes);


// Global Error Handler
app.use(errorHandler);

export default app;
