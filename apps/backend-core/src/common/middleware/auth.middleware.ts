import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../../config';
import { logger } from '../helpers/logger';

export type AuthUser = {
  userId: string;
  role: string;
};

export interface AuthRequest extends Request {
  authUser?: AuthUser;
}

export const authenticate = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        status: 'error',
        message: 'Unauthorized',
      });
    }

    const token = authHeader.split(' ')[1];

    const decoded = jwt.verify(
      token,
      config.jwtAccessSecret as string,
    ) as AuthUser;

    req.authUser = decoded;

    next();
  } catch (error) {
    logger.error('Authentication error:', error);

    return res.status(401).json({
      status: 'error',
      message: 'Invalid or expired token',
    });
  }
};

export const requireRole = (roles: string[]) => {
  return (
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ) => {
    if (!req.authUser || !roles.includes(req.authUser.role)) {
      return res.status(403).json({
        status: 'error',
        message: 'Forbidden',
      });
    }

    next();
  };
};