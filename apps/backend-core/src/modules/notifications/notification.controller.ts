import { Response } from 'express';
import { NotificationService } from './notification.service';
import { logger } from '../../common/helpers/logger';
import { ApiResponse } from '../../common/helpers/response';
import { markReadSchema } from '../../validators';
import { AuthRequest } from '../../common/middleware/auth.middleware';

export class NotificationController {
  private notificationService = new NotificationService();

  getNotifications = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const notifications = await this.notificationService.getUserNotifications(userId);
      return ApiResponse.success(res, 'Notifications fetched successfully', notifications);
    } catch (error: any) {
      logger.error('Get notifications error:', error);
      return ApiResponse.error(res, 'Failed to fetch notifications', [], 500);
    }
  };

  markAsRead = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user!.userId;
      const { notificationIds } = markReadSchema.parse(req.body);
      await this.notificationService.markAsRead(userId, notificationIds);
      return ApiResponse.success(res, 'Notifications marked as read');
    } catch (error: any) {
      logger.error('Mark read notifications error:', error);
      return ApiResponse.error(res, error.message || 'Update failed', error.errors || []);
    }
  };
}
