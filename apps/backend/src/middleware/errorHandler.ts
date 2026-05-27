import { ErrorRequestHandler } from 'express';
import { ZodError } from 'zod';
import { AppError } from '../utils/AppError';

export const errorHandler: ErrorRequestHandler = (error, _req, res, _next) => {
  if (error instanceof ZodError) {
    res.status(400).json({
      success: false,
      message: 'Validation failed',
      data: null,
      error: { code: 'VALIDATION_ERROR', details: error.issues }
    });
    return;
  }

  if (error instanceof AppError) {
    res.status(error.statusCode).json({
      success: false,
      message: error.message,
      data: null,
      error: { code: error.code, details: null }
    });
    return;
  }

  console.error('[unhandled]', error);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    data: null,
    error: { code: 'INTERNAL_SERVER_ERROR', details: null }
  });
};
