/**
 * Global Error Handler Middleware
 * 
 * Centralized error handling with proper HTTP status codes,
 * error logging, and user-friendly error messages.
 */

import { Request, Response, NextFunction } from 'express';
import { StatusCodes } from 'http-status-codes';
import { logger } from '../utils/logger';

// Custom error class for API errors
export class ApiError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  public readonly isOperational: boolean;

  constructor(
    message: string,
    statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR,
    code: string = 'INTERNAL_ERROR',
    isOperational: boolean = true
  ) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
    
    Error.captureStackTrace(this, this.constructor);
  }
}

// Error response interface
interface ErrorResponse {
  success: boolean;
  error: {
    code: string;
    message: string;
    details?: Record<string, unknown>;
    stack?: string;
  };
  metadata?: {
    requestId: string;
    timestamp: string;
  };
}

// Handle validation errors from express-validator
const handleValidationError = (err: any): ErrorResponse => {
  const errors = err.array();
  
  return {
    success: false,
    error: {
      code: 'VALIDATION_ERROR',
      message: 'Request validation failed',
      details: errors.reduce((acc: Record<string, string[]>, error: any) => {
        if (!acc[error.path]) {
          acc[error.path] = [];
        }
        acc[error.path].push(error.msg);
        return acc;
      }, {}),
    },
    metadata: {
      requestId: (err as any).requestId || 'unknown',
      timestamp: new Date().toISOString(),
    },
  };
};

// Handle JWT errors
const handleJWTError = (err: any): ErrorResponse => {
  return {
    success: false,
    error: {
      code: 'AUTH_ERROR',
      message: 'Invalid or expired authentication token',
    },
    metadata: {
      requestId: (err as any).requestId || 'unknown',
      timestamp: new Date().toISOString(),
    },
  };
};

// Handle duplicate key errors (MongoDB/MySQL)
const handleDuplicateKeyError = (err: any): ErrorResponse => {
  const keyValue = Object.values(err.keyValue || {})[0];
  
  return {
    success: false,
    error: {
      code: 'DUPLICATE_ENTRY',
      message: `A record with this ${Object.keys(err.keyValue || {})[0]} already exists`,
      details: { value: keyValue },
    },
    metadata: {
      requestId: (err as any).requestId || 'unknown',
      timestamp: new Date().toISOString(),
    },
  };
};

// Global error handler middleware
export const errorHandler = (
  err: Error | ApiError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const requestId = req.headers['x-request-id'] as string || 'unknown';
  
  // Log the error
  logger.error('Error occurred:', err, {
    requestId,
    method: req.method,
    path: req.path,
    userId: (req as any).user?.id,
  });

  let response: ErrorResponse;

  // Handle specific error types
  if (err instanceof ApiError) {
    response = {
      success: false,
      error: {
        code: err.code,
        message: err.message,
      },
      metadata: {
        requestId,
        timestamp: new Date().toISOString(),
      },
    };
    
    res.status(err.statusCode).json(response);
    return;
  }

  // Handle express-validator errors
  if (err.name === 'ValidationError') {
    response = handleValidationError(err);
    res.status(StatusCodes.BAD_REQUEST).json(response);
    return;
  }

  // Handle JWT errors
  if (err.name === 'JsonWebTokenError' || err.name === 'JwtMalformedError') {
    response = handleJWTError(err);
    res.status(StatusCodes.UNAUTHORIZED).json(response);
    return;
  }

  // Handle duplicate key errors
  if (err.name === 'PrismaClientKnownRequestError' && (err as any).code === 'P2002') {
    response = handleDuplicateKeyError(err);
    res.status(StatusCodes.CONFLICT).json(response);
    return;
  }

  // Handle connection errors
  if (err.message.includes('ECONNREFUSED')) {
    response = {
      success: false,
      error: {
        code: 'SERVICE_UNAVAILABLE',
        message: 'A required service is currently unavailable',
      },
      metadata: {
        requestId,
        timestamp: new Date().toISOString(),
      },
    };
    
    res.status(StatusCodes.SERVICE_UNAVAILABLE).json(response);
    return;
  }

  // Default: Internal server error
  response = {
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: process.env.NODE_ENV === 'production' 
        ? 'An unexpected error occurred' 
        : err.message,
      ...(process.env.NODE_ENV !== 'production' && { stack: err.stack }),
    },
    metadata: {
      requestId,
      timestamp: new Date().toISOString(),
    },
  };

  res.status(StatusCodes.INTERNAL_SERVER_ERROR).json(response);
};

// Async wrapper to catch errors in async route handlers
export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<void>
) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};