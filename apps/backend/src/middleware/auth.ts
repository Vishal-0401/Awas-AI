import { NextFunction, Request, Response } from 'express';
import { UserRole } from '../dto/domain';
import { ForbiddenAppError, UnauthorizedAppError } from '../utils/AppError';
import { verifyAccessToken } from '../utils/jwt';
import { userRepository } from '../repositories/store';

declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        role: UserRole;
      };
    }
  }
}

export const authenticate = (req: Request, _res: Response, next: NextFunction): void => {
  const header = req.header('authorization');
  if (!header?.startsWith('Bearer ')) {
    throw new UnauthorizedAppError('Missing bearer token');
  }

  const token = header.slice('Bearer '.length);
  try {
    const payload = verifyAccessToken(token);
    const user = userRepository.findById(payload.sub);
    if (!user) throw new UnauthorizedAppError('Invalid token user');
    req.user = { id: user.id, role: user.role };
    next();
  } catch (error) {
    if (error instanceof UnauthorizedAppError) throw error;
    throw new UnauthorizedAppError('Invalid or expired token');
  }
};

export const requireRoles = (...roles: UserRole[]) => {
  return (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.user) throw new UnauthorizedAppError('Authentication required');
    if (!roles.includes(req.user.role)) throw new ForbiddenAppError('Insufficient permissions');
    next();
  };
};
