import { Request, Response, NextFunction } from 'express';
import { redis } from '../../sockets/redis.client';

export const requestLogger = (req: Request, res: Response, next: NextFunction) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
};

export const rateLimiter = async (req: Request, res: Response, next: NextFunction) => {
  const ip = req.ip;
  const key = `rate-limit:${ip}`;
  const limit = 100;
  const window = 60;

  try {
    const current = await redis.incr(key);
    if (current === 1) {
      await redis.expire(key, window);
    }
    if (current > limit) {
      return res.status(429).json({
        status: 'error',
        message: 'Too many requests',
      });
    }
    next();
  } catch (error) {
    next();
  }
};

export const securityHeaders = (req: Request, res: Response, next: NextFunction) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  next();
};