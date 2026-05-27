import { Request, Response } from 'express';
import { notificationRepository } from '../repositories/store';
import { NotFoundAppError } from '../utils/AppError';
import { ok } from '../utils/response';

export class NotificationController {
  list = async (req: Request, res: Response): Promise<void> => {
    ok(res, notificationRepository.listByUser(req.user!.id));
  };

  read = async (req: Request, res: Response): Promise<void> => {
    const notification = notificationRepository.markRead(req.params.id as string);
    if (!notification || notification.userId !== req.user!.id) throw new NotFoundAppError('Notification not found');
    ok(res, notification, 'Notification marked read');
  };
}
