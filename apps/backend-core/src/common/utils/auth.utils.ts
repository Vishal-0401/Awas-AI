import jwt from 'jsonwebtoken';
import { config } from '../../config';
import { Role } from '@prisma/client';

export const generateToken = (userId: string, role: Role) => {
  return jwt.sign({ userId, role }, config.jwtAccessSecret, {
    expiresIn: config.jwtAccessExpiresIn,
  });
};

export const generateRefreshToken = (userId: string, role: Role) => {
  return jwt.sign({ userId, role }, config.jwtRefreshSecret, {
    expiresIn: config.jwtRefreshExpiresIn,
  });
};
