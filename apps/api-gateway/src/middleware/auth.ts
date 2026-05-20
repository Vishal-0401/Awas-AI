/**
 * Authentication Middleware
 * 
 * JWT-based authentication with refresh token support,
 * role-based access control, and session management.
 */

import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { jwtConfig, isProduction } from '@awas-ai/config';
import { ApiError } from './errorHandler';
import { UserRole } from '@awas-ai/types';
import { logger } from '../utils/logger';

// Extend Express Request type
declare global {
  namespace Express {
    interface Request {
      user?: AuthUser;
    }
  }
}

// Auth user interface
export interface AuthUser {
  id: string;
  email: string;
  role: UserRole;
  iat?: number;
  exp?: number;
}

// Token payload interface
interface TokenPayload {
  id: string;
  email: string;
  role: UserRole;
  type: 'access' | 'refresh';
}

// Redis store for blacklisted tokens (for logout)
const blacklistedTokens = new Set<string>();

// Generate access token
export const generateAccessToken = (user: { id: string; email: string; role: UserRole }): string => {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
      type: 'access' as const,
    },
    jwtConfig.accessSecret,
    {
      expiresIn: jwtConfig.accessExpiry,
      issuer: jwtConfig.issuer,
    }
  );
};

// Generate refresh token
export const generateRefreshToken = (user: { id: string; email: string; role: UserRole }): string => {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
      type: 'refresh' as const,
    },
    jwtConfig.refreshSecret,
    {
      expiresIn: jwtConfig.refreshExpiry,
      issuer: jwtConfig.issuer,
    }
  );
};

// Verify token
export const verifyToken = (token: string): TokenPayload => {
  try {
    const decoded = jwt.verify(token, jwtConfig.accessSecret, {
      issuer: jwtConfig.issuer,
    }) as TokenPayload;
    
    return decoded;
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      throw new ApiError('Invalid token', 401, 'INVALID_TOKEN');
    }
    if (error instanceof jwt.TokenExpiredError) {
      throw new ApiError('Token expired', 401, 'TOKEN_EXPIRED');
    }
    throw error;
  }
};

// Verify refresh token
export const verifyRefreshToken = (token: string): TokenPayload => {
  try {
    const decoded = jwt.verify(token, jwtConfig.refreshSecret, {
      issuer: jwtConfig.issuer,
    }) as TokenPayload;
    
    if (decoded.type !== 'refresh') {
      throw new ApiError('Invalid token type', 401, 'INVALID_TOKEN_TYPE');
    }
    
    return decoded;
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      throw new ApiError('Invalid refresh token', 401, 'INVALID_REFRESH_TOKEN');
    }
    if (error instanceof jwt.TokenExpiredError) {
      throw new ApiError('Refresh token expired', 401, 'REFRESH_TOKEN_EXPIRED');
    }
    throw error;
  }
};

// Blacklist token (for logout)
export const blacklistToken = (token: string): void => {
  blacklistedTokens.add(token);
  
  // In production, store in Redis with TTL
  // await redis.setex(`blacklist:${jti}`, expiresIn, 'true');
};

// Check if token is blacklisted
export const isTokenBlacklisted = (token: string): boolean => {
  return blacklistedTokens.has(token);
  // In production, check Redis
  // return await redis.exists(`blacklist:${jti}`) === 1;
};

// Main authentication middleware
export const authMiddleware = (req: Request, res: Response, next: NextFunction): void => {
  // Skip authentication for public routes
  const publicRoutes = [
    '/api/v1/auth/login',
    '/api/v1/auth/register',
    '/api/v1/auth/verify-otp',
    '/api/v1/auth/refresh',
    '/api/v1/auth/logout',
    '/health',
    '/metrics',
    '/api-docs',
  ];
  
  if (publicRoutes.some(route => req.path.startsWith(route))) {
    return next();
  }
  
  try {
    // Extract token from Authorization header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new ApiError(
        'Access token is required',
        401,
        'MISSING_TOKEN'
      );
    }
    
    const token = authHeader.substring(7);
    
    // Check if token is blacklisted
    if (isTokenBlacklisted(token)) {
      throw new ApiError(
        'Token has been revoked',
        401,
        'TOKEN_REVOKED'
      );
    }
    
    // Verify token
    const decoded = verifyToken(token);
    
    // Attach user to request
    req.user = {
      id: decoded.id,
      email: decoded.email,
      role: decoded.role,
      iat: decoded.iat,
      exp: decoded.exp,
    };
    
    next();
  } catch (error) {
    next(error);
  }
};

// Role-based access control middleware
export const requireRole = (...roles: UserRole[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
      throw new ApiError('Authentication required', 401, 'AUTH_REQUIRED');
    }
    
    if (!roles.includes(req.user.role)) {
      logger.warn('Unauthorized access attempt', {
        userId: req.user.id,
        userRole: req.user.role,
        requiredRoles: roles,
        path: req.path,
        method: req.method,
      });
      
      throw new ApiError(
        'Insufficient permissions',
        403,
        'INSUFFICIENT_PERMISSIONS'
      );
    }
    
    next();
  };
};

// Optional authentication (doesn't fail if no token)
export const optionalAuth = (req: Request, res: Response, next: NextFunction): void => {
  try {
    const authHeader = req.headers.authorization;
    
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      
      if (!isTokenBlacklisted(token)) {
        const decoded = verifyToken(token);
        req.user = {
          id: decoded.id,
          email: decoded.email,
          role: decoded.role,
        };
      }
    }
  } catch (error) {
    // Silently fail for optional auth
  }
  
  next();
};

// Rate limit based on user role
export const roleBasedRateLimit = (limits: Record<UserRole, number>) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const userRole = req.user?.role || 'customer';
    const maxRequests = limits[userRole] || 100;
    
    // This would integrate with express-rate-limit
    // For now, just attach to request
    (req as any).rateLimit = maxRequests;
    
    next();
  };
};