import { Request, Response } from 'express';

export class NotificationController {
  async getNotifications(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      data: { notifications: [] },
    });
  }

  async markAsRead(req: Request, res: Response) {
    res.status(200).json({
      status: 'success',
      message: 'Notification marked as read',
    });
  }
}