import { NextFunction, Request, Response } from 'express';
import logger from './logger';

export class AppError extends Error {


  statusCode: number;
  isOperational: boolean;

  constructor(message: string, statusCode: number = 500) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler = (
  err: AppError,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  logger.error(err.stack);

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  // Standardized JSON error schema
  res.status(statusCode).json({
    success: false,
    message,
    error: {
      code: statusCode,
      details:
        process.env.NODE_ENV === 'development' ? err.stack : undefined,
    },
  });
};


