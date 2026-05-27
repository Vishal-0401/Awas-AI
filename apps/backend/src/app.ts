import express, { Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import path from 'path';
import apiRoutes from './routes';
import { env } from './config/env';
import { requestContext } from './middleware/requestContext';
import { apiRateLimiter } from './middleware/rateLimit';
import { errorHandler } from './middleware/errorHandler';

export const createApp = (): express.Express => {
  const app = express();

  app.use(helmet({ crossOriginResourcePolicy: false }));
  app.use(cors({ origin: env.corsOrigin === '*' ? true : env.corsOrigin, credentials: true }));
  app.use(express.json({ limit: '2mb' }));
  app.use(express.urlencoded({ extended: true }));
  app.use(requestContext);
  app.use(apiRateLimiter);
  app.use('/uploads', express.static(path.resolve(process.cwd(), 'uploads')));

  app.get('/', (_req: Request, res: Response) => {
    res.json({
      success: true,
      message: 'AWAS Home API is running',
      data: {
        service: 'awas-home-backend',
        version: '1.0.0',
        environment: env.nodeEnv
      }
    });
  });

  app.get('/health', (_req: Request, res: Response) => {
    res.json({ success: true, message: 'healthy', data: { uptime: process.uptime() } });
  });

  app.use('/api/v1', apiRoutes);
  app.use(errorHandler);

  return app;
};
