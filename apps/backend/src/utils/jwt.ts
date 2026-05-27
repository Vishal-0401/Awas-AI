import jwt, { SignOptions } from 'jsonwebtoken';
import { env } from '../config/env';
import { UserRole } from '../dto/domain';

export interface JwtUserPayload {
  sub: string;
  role: UserRole;
  tokenFamily?: string;
  tokenId?: string;
}

export interface JwtPayload extends JwtUserPayload {
  jti?: string;
  iat: number;
  exp: number;
}

const sign = (payload: JwtUserPayload, secret: string, expiresIn: string): string => {
  const { tokenId, ...claims } = payload;
  const options: SignOptions = { expiresIn: expiresIn as SignOptions['expiresIn'] };
  if (tokenId) options.jwtid = tokenId;
  return jwt.sign(claims, secret, options);
};

export const signAccessToken = (payload: JwtUserPayload): string =>
  sign(payload, env.jwtAccessSecret, env.jwtAccessExpiresIn);

export const signRefreshToken = (payload: JwtUserPayload): string =>
  sign(payload, env.jwtRefreshSecret, env.jwtRefreshExpiresIn);

export const verifyAccessToken = (token: string): JwtPayload =>
  jwt.verify(token, env.jwtAccessSecret) as JwtPayload;

export const verifyRefreshToken = (token: string): JwtPayload =>
  jwt.verify(token, env.jwtRefreshSecret) as JwtPayload;
