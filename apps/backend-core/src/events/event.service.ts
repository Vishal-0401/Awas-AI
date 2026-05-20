import { EventEmitter } from 'events';
import { logger } from '../common/helpers/logger';

class AppEventEmitter extends EventEmitter {}

export const eventEmitter = new AppEventEmitter();

export const initializeEvents = () => {
  eventEmitter.on('booking.created', (booking: any) => {
    logger.info(`Booking created: ${booking.id}`);
  });

  eventEmitter.on('job.assigned', (job: any) => {
    logger.info(`Job assigned: ${job.id}`);
  });

  eventEmitter.on('payment.completed', (payment: any) => {
    logger.info(`Payment completed: ${payment.id}`);
  });
};