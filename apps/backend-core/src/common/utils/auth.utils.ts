import jwt from 'jsonwebtoken';
import { config } from '../../config';
import { Role } from '@prisma/client';

export const generateToken = (userId: string, role: Role) => {
  return jwt.sign({ userId, role }, config.jwtSecret, {
    expiresIn: config.jwtExpiresIn,
  });
};

export const generateRefreshToken = (userId: string, role: Role) => {
  return jwt.sign({ userId, role }, config.jwtSecret, {
    expiresIn: config.jwtRefreshExpiresIn,
  });
};

export const hashPassword = async (password: string): Promise<string> => {
  const bcrypt = await import('bcryptjs');
  return bcrypt.hash(password, 10);
};

export const comparePassword = async (password: string, hash: string): Promise<boolean> => {
  const bcrypt = await import('bcryptjs');
  return bcrypt.compare(password, hash);
};