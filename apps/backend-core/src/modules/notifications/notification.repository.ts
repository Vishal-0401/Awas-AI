import { PrismaClient, Notification, Prisma } from '@prisma/client';
import { prisma } from '../../server';

export class NotificationRepository {
  async findUserNotifications(userId: string): Promise<Notification[]> {
    return prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 50
    });
  }

  async markAsRead(userId: string, notificationIds: string[]): Promise<void> {
    await prisma.notification.updateMany({
      where: {
        userId,
        id: { in: notificationIds }
      },
      data: { isRead: true }
    });
  }
}
