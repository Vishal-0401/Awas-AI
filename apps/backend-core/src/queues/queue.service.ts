import { Queue, Worker, Processor } from 'bullmq';
import { redis } from '../sockets/redis.client';
import { logger } from '../common/helpers/logger';

export interface EmailJob {
  to: string;
  subject: string;
  template: string;
  data: any;
}

export interface NotificationJob {
  userId: string;
  title: string;
  body: string;
}

export const emailQueue = new Queue<EmailJob>('email', { connection: redis });
export const notificationQueue = new Queue<NotificationJob>('notification', { connection: redis });

export const emailProcessor: Processor<EmailJob> = async (job) => {
  logger.info(`Sending email to ${job.data.to}`);
  return Promise.resolve();
};

export const notificationProcessor: Processor<NotificationJob> = async (job) => {
  logger.info(`Sending notification to ${job.data.userId}`);
  return Promise.resolve();
};

export const initializeQueues = () => {
  new Worker<EmailJob>('email', emailProcessor, { connection: redis });
  new Worker<NotificationJob>('notification', notificationProcessor, { connection: redis });
  logger.info('Queues initialized');
};