/**
 * Winston Logger Configuration
 * 
 * Production-grade logging with file rotation, JSON formatting, and log levels.
 */

import winston from 'winston';
import { config, isProduction } from '@awas-ai/config';

const { combine, timestamp, printf, colorize, json } = winston.format;

// Custom log format for development
const devFormat = printf(({ level, message, timestamp, ...metadata }) => {
  let msg = `${timestamp} [${level}]: ${message}`;
  
  if (Object.keys(metadata).length > 0) {
    msg += ` ${JSON.stringify(metadata)}`;
  }
  
  return msg;
});

// Define log levels based on environment
const logLevel = isProduction() ? config.LOG_LEVEL : 'debug';

// Create the logger instance
export const logger = winston.createLogger({
  level: logLevel,
  handleExceptions: true,
  handleRejections: true,
  
  // Default format
  format: combine(
    timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    isProduction() ? json() : devFormat
  ),
  
  // Transports - where to output logs
  transports: [
    // Console transport (always enabled)
    new winston.transports.Console({
      format: isProduction() 
        ? combine(timestamp(), json()) 
        : combine(colorize(), devFormat),
    }),
    
    // File transport for errors (production)
    ...(isProduction() ? [
      new winston.transports.File({
        filename: 'logs/error.log',
        level: 'error',
        maxsize: 5242880, // 5MB
        maxFiles: 5,
      }),
      new winston.transports.File({
        filename: 'logs/combined.log',
        maxsize: 5242880, // 5MB
        maxFiles: 5,
      }),
    ] : []),
  ],
});

// Add request context to logs
export const logWithContext = (
  level: 'info' | 'warn' | 'error' | 'debug',
  message: string,
  context: Record<string, unknown> = {}
) => {
  logger.log(level, message, context);
};

// Export commonly used log functions
export const logInfo = (message: string, context?: Record<string, unknown>) => {
  logWithContext('info', message, context);
};

export const logError = (message: string, error?: Error, context?: Record<string, unknown>) => {
  logWithContext('error', message, {
    ...context,
    error: error ? { message: error.message, stack: error.stack } : undefined,
  });
};

export const logWarn = (message: string, context?: Record<string, unknown>) => {
  logWithContext('warn', message, context);
};

export const logDebug = (message: string, context?: Record<string, unknown>) => {
  logWithContext('debug', message, context);
};