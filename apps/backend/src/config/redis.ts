import { createClient, RedisClientType } from 'redis';
import { env } from './env';

let redisClient: RedisClientType | null = null;

export const getRedisClient = async (): Promise<RedisClientType | null> => {
  if (redisClient?.isOpen) return redisClient;

  try {
    redisClient = createClient({ url: env.redisUrl });
    redisClient.on('error', (error) => {
      console.warn('[redis] unavailable:', error.message);
    });
    await redisClient.connect();
    return redisClient;
  } catch (error) {
    console.warn('[redis] disabled:', error instanceof Error ? error.message : String(error));
    redisClient = null;
    return null;
  }
};

export const closeRedisClient = async (): Promise<void> => {
  if (redisClient?.isOpen) await redisClient.quit();
};
