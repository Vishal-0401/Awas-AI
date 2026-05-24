import { createClient, RedisClientType } from 'redis';

export class RedisService {
  private static instance: RedisClientType | null = null;

  static getInstance(): RedisClientType {
    if (!this.instance) {
      this.instance = createClient({
        url: process.env.REDIS_URL || 'redis://localhost:6379',
      });

      this.instance.on('error', (err) => {
        console.log('Redis not available:', err.message);
      });

      // Prevent app crash if Redis is unavailable
      this.instance.connect().catch((err) => {
        console.log('Skipping Redis connection:', err.message);
      });
    }

    return this.instance;
  }
}