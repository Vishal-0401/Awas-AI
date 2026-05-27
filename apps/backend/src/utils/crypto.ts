import { createHash, randomBytes, randomInt, timingSafeEqual } from 'crypto';

export const generateOtp = (): string => randomInt(100000, 999999).toString();

export const hashSecret = async (value: string): Promise<string> => {
  const salt = randomBytes(16).toString('hex');
  const digest = createHash('sha256').update(`${salt}:${value}`).digest('hex');
  return `${salt}:${digest}`;
};

export const compareSecret = async (value: string, hash: string): Promise<boolean> => {
  const [salt, digest] = hash.split(':');
  if (!salt || !digest) return false;
  const candidate = createHash('sha256').update(`${salt}:${value}`).digest('hex');
  return timingSafeEqual(Buffer.from(candidate), Buffer.from(digest));
};
