/**
 * AWAS-AI Shared Configuration
 * 
 * Centralized configuration management for all AWAS-AI services.
 * Uses Zod for runtime validation and dotenv for environment variables.
 */

import dotenv from 'dotenv';
import { z } from 'zod';

// Load environment variables
dotenv.config();

// ============================================================================
// ENVIRONMENT SCHEMA VALIDATION
// ============================================================================

const EnvironmentSchema = z.object({
  // Node
  NODE_ENV: z.enum(['development', 'staging', 'production', 'test']).default('development'),
  PORT: z.string().transform(Number).default('3000'),
  
  // Database
  DATABASE_URL: z.string().url(),
  DATABASE_POOL_SIZE: z.string().transform(Number).default('20'),
  DATABASE_CONNECTION_TIMEOUT: z.string().transform(Number).default('30000'),
  
  // Redis
  REDIS_HOST: z.string().default('localhost'),
  REDIS_PORT: z.string().transform(Number).default('6379'),
  REDIS_PASSWORD: z.string().optional(),
  REDIS_DB: z.string().transform(Number).default('0'),
  REDIS_CLUSTER_ENABLED: z.string().transform((v) => v === 'true').default('false'),
  REDIS_CLUSTER_NODES: z.string().optional(),
  
  // JWT
  JWT_ACCESS_SECRET: z.string(),
  JWT_REFRESH_SECRET: z.string(),
  JWT_ACCESS_EXPIRY: z.string().default('15m'),
  JWT_REFRESH_EXPIRY: z.string().default('7d'),
  JWT_ISSUER: z.string().default('awas-ai'),
  
  // API Keys
  RAZORPAY_KEY_ID: z.string().optional(),
  RAZORPAY_KEY_SECRET: z.string().optional(),
  RAZORPAY_WEBHOOK_SECRET: z.string().optional(),
  
  // Firebase
  FIREBASE_PROJECT_ID: z.string().optional(),
  FIREBASE_CLIENT_EMAIL: z.string().optional(),
  FIREBASE_PRIVATE_KEY: z.string().optional(),
  
  // Storage
  AWS_ACCESS_KEY_ID: z.string().optional(),
  AWS_SECRET_ACCESS_KEY: z.string().optional(),
  AWS_REGION: z.string().default('ap-south-1'),
  AWS_S3_BUCKET: z.string().optional(),
  
  CLOUDINARY_CLOUD_NAME: z.string().optional(),
  CLOUDINARY_API_KEY: z.string().optional(),
  CLOUDINARY_API_SECRET: z.string().optional(),
  
  // Maps
  GOOGLE_MAPS_API_KEY: z.string().optional(),
  GOOGLE_MAPS_PLATFORM: z.string().default('IN'),
  
  // AI Service
  AI_SERVICE_URL: z.string().default('http://localhost:5000'),
  AI_SERVICE_TIMEOUT: z.string().transform(Number).default('30000'),
  
  // Socket.io
  SOCKET_CORS_ORIGINS: z.string().default('*'),
  SOCKET_REDIS_ADAPTER: z.string().transform((v) => v === 'true').default('false'),
  
  // Kafka
  KAFKA_BROKERS: z.string().optional(),
  KAFKA_CLIENT_ID: z.string().default('awas-ai'),
  KAFKA_SSL: z.string().transform((v) => v === 'true').default('false'),
  KAFKA_SASL_MECHANISM: z.string().optional(),
  KAFKA_SASL_USERNAME: z.string().optional(),
  KAFKA_SASL_PASSWORD: z.string().optional(),
  
  // Monitoring
  PROMETHEUS_ENABLED: z.string().transform((v) => v === 'true').default('false'),
  PROMETHEUS_PORT: z.string().transform(Number).default('9090'),
  SENTRY_DSN: z.string().optional(),
  SENTRY_ENVIRONMENT: z.string().optional(),
  LOG_LEVEL: z.enum(['error', 'warn', 'info', 'debug', 'trace']).default('info'),
  
  // Rate Limiting
  RATE_LIMIT_WINDOW_MS: z.string().transform(Number).default('900000'), // 15 minutes
  RATE_LIMIT_MAX_REQUESTS: z.string().transform(Number).default('100'),
  
  // CORS
  CORS_ORIGINS: z.string().default('*'),
  CORS_CREDENTIALS: z.string().transform((v) => v === 'true').default('true'),
  
  // Security
  BCRYPT_ROUNDS: z.string().transform(Number).default('12'),
  HELMET_ENABLED: z.string().transform((v) => v === 'true').default('true'),
  
  // File Upload
  MAX_FILE_SIZE_MB: z.string().transform(Number).default('10'),
  ALLOWED_FILE_TYPES: z.string().default('image/jpeg,image/png,image/webp,application/pdf'),
  
  // SMS Provider
  SMS_PROVIDER: z.enum(['twilio', 'msg91', 'textlocal']).default('msg91'),
  TWILIO_ACCOUNT_SID: z.string().optional(),
  TWILIO_AUTH_TOKEN: z.string().optional(),
  TWILIO_PHONE_NUMBER: z.string().optional(),
  MSG91_AUTH_KEY: z.string().optional(),
  TEXTLOCAL_API_KEY: z.string().optional(),
  
  // Email Provider
  EMAIL_PROVIDER: z.enum(['ses', 'sendgrid', 'smtp']).default('smtp'),
  SES_ACCESS_KEY: z.string().optional(),
  SES_SECRET_KEY: z.string().optional(),
  SES_REGION: z.string().default('ap-south-1'),
  SENDGRID_API_KEY: z.string().optional(),
  SMTP_HOST: z.string().optional(),
  SMTP_PORT: z.string().transform(Number).default('587'),
  SMTP_USER: z.string().optional(),
  SMTP_PASS: z.string().optional(),
  EMAIL_FROM: z.string().default('noreply@awas-ai.com'),
  
  // Feature Flags
  ENABLE_AI_DIAGNOSTICS: z.string().transform((v) => v === 'true').default('true'),
  ENABLE_PREDICTIVE_MAINTENANCE: z.string().transform((v) => v === 'true').default('true'),
  ENABLE_ESCROW: z.string().transform((v) => v === 'true').default('true'),
  ENABLE_WALLET: z.string().transform((v) => v === 'true').default('true'),
  ENABLE_SUBSCRIPTIONS: z.string().transform((v) => v === 'true').default('false'),
  ENABLE_INSURANCE: z.string().transform((v) => v === 'true').default('false'),
  ENABLE_ONDC: z.string().transform((v) => v === 'true').default('false'),
  
  // ONDC
  ONDC_SUBSCRIBER_ID: z.string().optional(),
  ONDC_UNIQUE_KEY_ID: z.string().optional(),
  ONDC_PRIVATE_KEY: z.string().optional(),
  ONDC_PUBLIC_KEY: z.string().optional(),
  ONDC_GATEWAY_URL: z.string().optional(),
  
  // Dispatch
  DISPATCH_RADIUS_KM: z.string().transform(Number).default('10'),
  DISPATCH_MAX_WORKERS: z.string().transform(Number).default('10'),
  DISPATCH_OFFER_EXPIRY_SECONDS: z.string().transform(Number).default('30'),
  DISPATCH_JOB_TIMEOUT_MINUTES: z.string().transform(Number).default('30'),
  
  // Worker Location
  WORKER_LOCATION_UPDATE_INTERVAL_SECONDS: z.string().transform(Number).default('5'),
  WORKER_LOCATION_ACCURACY_THRESHOLD_METERS: z.string().transform(Number).default('100'),
  
  // OTP
  OTP_LENGTH: z.string().transform(Number).default('6'),
  OTP_EXPIRY_MINUTES: z.string().transform(Number).default('5'),
  OTP_MAX_ATTEMPTS: z.string().transform(Number).default('3'),
  
  // Base URLs
  API_BASE_URL: z.string().default('http://localhost:3000'),
  ADMIN_BASE_URL: z.string().default('http://localhost:3001'),
  CUSTOMER_APP_BASE_URL: z.string().default('awas-ai://'),
  WORKER_APP_BASE_URL: z.string().default('awas-ai-worker://'),
});

export type Environment = z.infer<typeof EnvironmentSchema>;

// ============================================================================
// CONFIGURATION VALIDATION & EXPORT
// ============================================================================

function validateEnvironment(): Environment {
  const result = EnvironmentSchema.safeParse(process.env);
  
  if (!result.success) {
    console.error('❌ Invalid environment variables:');
    console.error(result.error.format());
    process.exit(1);
  }
  
  return result.data;
}

export const config = validateEnvironment();

// ============================================================================
// SERVICE-SPECIFIC CONFIGURATIONS
// ============================================================================

export const databaseConfig = {
  url: config.DATABASE_URL,
  poolSize: config.DATABASE_POOL_SIZE,
  connectionTimeout: config.DATABASE_CONNECTION_TIMEOUT,
};

export const redisConfig = {
  host: config.REDIS_HOST,
  port: config.REDIS_PORT,
  password: config.REDIS_PASSWORD,
  db: config.REDIS_DB,
  clusterEnabled: config.REDIS_CLUSTER_ENABLED,
  clusterNodes: config.REDIS_CLUSTER_NODES?.split(',').map((node) => {
    const [host, port] = node.split(':');
    return { host, port: parseInt(port, 10) };
  }),
};

export const jwtConfig = {
  accessSecret: config.JWT_ACCESS_SECRET,
  refreshSecret: config.JWT_REFRESH_SECRET,
  accessExpiry: config.JWT_ACCESS_EXPIRY,
  refreshExpiry: config.JWT_REFRESH_EXPIRY,
  issuer: config.JWT_ISSUER,
};

export const paymentConfig = {
  razorpay: {
    keyId: config.RAZORPAY_KEY_ID,
    keySecret: config.RAZORPAY_KEY_SECRET,
    webhookSecret: config.RAZORPAY_WEBHOOK_SECRET,
  },
};

export const firebaseConfig = {
  projectId: config.FIREBASE_PROJECT_ID,
  clientEmail: config.FIREBASE_CLIENT_EMAIL,
  privateKey: config.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
};

export const storageConfig = {
  aws: {
    accessKeyId: config.AWS_ACCESS_KEY_ID,
    secretAccessKey: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION,
    s3Bucket: config.AWS_S3_BUCKET,
  },
  cloudinary: {
    cloudName: config.CLOUDINARY_CLOUD_NAME,
    apiKey: config.CLOUDINARY_API_KEY,
    apiSecret: config.CLOUDINARY_API_SECRET,
  },
};

export const mapsConfig = {
  googleMaps: {
    apiKey: config.GOOGLE_MAPS_API_KEY,
    platform: config.GOOGLE_MAPS_PLATFORM,
  },
};

export const aiServiceConfig = {
  url: config.AI_SERVICE_URL,
  timeout: config.AI_SERVICE_TIMEOUT,
};

export const socketConfig = {
  corsOrigins: config.SOCKET_CORS_ORIGINS.split(','),
  redisAdapter: config.SOCKET_REDIS_ADAPTER,
};

export const kafkaConfig = {
  brokers: config.KAFKA_BROKERS?.split(','),
  clientId: config.KAFKA_CLIENT_ID,
  ssl: config.KAFKA_SSL,
  sasl: config.KAFKA_SASL_MECHANISM
    ? {
        mechanism: config.KAFKA_SASL_MECHANISM,
        username: config.KAFKA_SASL_USERNAME,
        password: config.KAFKA_SASL_PASSWORD,
      }
    : undefined,
};

export const monitoringConfig = {
  prometheus: {
    enabled: config.PROMETHEUS_ENABLED,
    port: config.PROMETHEUS_PORT,
  },
  sentry: {
    dsn: config.SENTRY_DSN,
    environment: config.SENTRY_ENVIRONMENT || config.NODE_ENV,
  },
  logLevel: config.LOG_LEVEL,
};

export const rateLimitConfig = {
  windowMs: config.RATE_LIMIT_WINDOW_MS,
  maxRequests: config.RATE_LIMIT_MAX_REQUESTS,
};

export const corsConfig = {
  origins: config.CORS_ORIGINS.split(','),
  credentials: config.CORS_CREDENTIALS,
};

export const securityConfig = {
  bcryptRounds: config.BCRYPT_ROUNDS,
  helmetEnabled: config.HELMET_ENABLED,
};

export const uploadConfig = {
  maxFileSize: config.MAX_FILE_SIZE_MB * 1024 * 1024, // Convert to bytes
  allowedFileTypes: config.ALLOWED_FILE_TYPES.split(','),
};

export const smsConfig = {
  provider: config.SMS_PROVIDER,
  twilio: {
    accountSid: config.TWILIO_ACCOUNT_SID,
    authToken: config.TWILIO_AUTH_TOKEN,
    phoneNumber: config.TWILIO_PHONE_NUMBER,
  },
  msg91: {
    authKey: config.MSG91_AUTH_KEY,
  },
  textlocal: {
    apiKey: config.TEXTLOCAL_API_KEY,
  },
};

export const emailConfig = {
  provider: config.EMAIL_PROVIDER,
  from: config.EMAIL_FROM,
  ses: {
    accessKey: config.SES_ACCESS_KEY,
    secretKey: config.SES_SECRET_KEY,
    region: config.SES_REGION,
  },
  sendgrid: {
    apiKey: config.SENDGRID_API_KEY,
  },
  smtp: {
    host: config.SMTP_HOST,
    port: config.SMTP_PORT,
    user: config.SMTP_USER,
    pass: config.SMTP_PASS,
  },
};

export const featureFlags = {
  aiDiagnostics: config.ENABLE_AI_DIAGNOSTICS,
  predictiveMaintenance: config.ENABLE_PREDICTIVE_MAINTENANCE,
  escrow: config.ENABLE_ESCROW,
  wallet: config.ENABLE_WALLET,
  subscriptions: config.ENABLE_SUBSCRIPTIONS,
  insurance: config.ENABLE_INSURANCE,
  ondc: config.ENABLE_ONDC,
};

export const ondcConfig = {
  subscriberId: config.ONDC_SUBSCRIBER_ID,
  uniqueKeyId: config.ONDC_UNIQUE_KEY_ID,
  privateKey: config.ONDC_PRIVATE_KEY,
  publicKey: config.ONDC_PUBLIC_KEY,
  gatewayUrl: config.ONDC_GATEWAY_URL,
};

export const dispatchConfig = {
  radiusKm: config.DISPATCH_RADIUS_KM,
  maxWorkers: config.DISPATCH_MAX_WORKERS,
  offerExpirySeconds: config.DISPATCH_OFFER_EXPIRY_SECONDS,
  jobTimeoutMinutes: config.DISPATCH_JOB_TIMEOUT_MINUTES,
};

export const workerLocationConfig = {
  updateIntervalSeconds: config.WORKER_LOCATION_UPDATE_INTERVAL_SECONDS,
  accuracyThresholdMeters: config.WORKER_LOCATION_ACCURACY_THRESHOLD_METERS,
};

export const otpConfig = {
  length: config.OTP_LENGTH,
  expiryMinutes: config.OTP_EXPIRY_MINUTES,
  maxAttempts: config.OTP_MAX_ATTEMPTS,
};

export const baseUrls = {
  api: config.API_BASE_URL,
  admin: config.ADMIN_BASE_URL,
  customerApp: config.CUSTOMER_APP_BASE_URL,
  workerApp: config.WORKER_APP_BASE_URL,
};

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

export function isProduction(): boolean {
  return config.NODE_ENV === 'production';
}

export function isDevelopment(): boolean {
  return config.NODE_ENV === 'development';
}

export function isStaging(): boolean {
  return config.NODE_ENV === 'staging';
}

export function isTest(): boolean {
  return config.NODE_ENV === 'test';
}

export default config;