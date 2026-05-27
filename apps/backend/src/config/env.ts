import dotenv from 'dotenv';

dotenv.config();

const numberFromEnv = (key: string, fallback: number): number => {
  const raw = process.env[key];
  if (!raw) return fallback;
  const parsed = Number(raw);
  return Number.isFinite(parsed) ? parsed : fallback;
};

export const env = {
  nodeEnv: process.env.NODE_ENV ?? 'development',
  port: numberFromEnv('PORT', 3000),
  databaseUrl: process.env.DATABASE_URL ?? '',
  redisUrl: process.env.REDIS_URL ?? 'redis://localhost:6379',
  jwtAccessSecret: process.env.JWT_ACCESS_SECRET ?? process.env.JWT_SECRET ?? 'dev-access-secret',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET ?? process.env.JWT_SECRET ?? 'dev-refresh-secret',
  jwtAccessExpiresIn: process.env.JWT_EXPIRES_IN ?? '15m',
  jwtRefreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN ?? '30d',
  corsOrigin: process.env.CORS_ORIGIN ?? '*',
  socketCorsOrigin: process.env.SOCKET_CORS_ORIGIN ?? '*',
  otpTtlMinutes: numberFromEnv('OTP_TTL_MINUTES', 5),
  otpMaxAttempts: numberFromEnv('OTP_MAX_ATTEMPTS', 3),
  dispatchRadiusMeters: numberFromEnv('DISPATCH_RADIUS_METERS', 5000),
  enableMockOtp: (process.env.ENABLE_MOCK_OTP ?? 'true') === 'true',
  objectStorageBaseUrl: process.env.OBJECT_STORAGE_BASE_URL ?? 'http://localhost:3000/uploads'
} as const;

export type AppEnv = typeof env;
