import { NotificationRepository } from './notification.repository';

export class NotificationService {
  private notificationRepository = new NotificationRepository();

  async getUserNotifications(userId: string) {
    return this.notificationRepository.findUserNotifications(userId);
  }

  async markAsRead(userId: string, notificationIds: string[]) {
    return this.notificationRepository.markAsRead(userId, notificationIds);
  }
}
