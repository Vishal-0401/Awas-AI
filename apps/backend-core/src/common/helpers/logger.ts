import winston from 'winston';

const { combine, timestamp, label, printf, colorize, errors } = winston.format;

const logFormat = printf(({ level, message, label, timestamp, stack }) => {
  return `${timestamp} [${label}] ${level}: ${stack || message}`;
});

export const logger = winston.createLogger({
  format: combine(
    label({ label: 'backend-core' }),
    timestamp(),
    errors({ stack: true }),
    logFormat
  ),
  transports: [
    new winston.transports.Console({
      format: combine(colorize(), logFormat),
    }),
  ],
});