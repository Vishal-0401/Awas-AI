import { Router } from 'express';
import { NotificationController } from './notifications.controller';
import { authGuard } from '../../common/guards/auth.guard';

const router = Router();
const notificationController = new NotificationController();

router.get('/', authGuard, notificationController.getNotifications);
router.put('/:id/read', authGuard, notificationController.markAsRead);

export default router;