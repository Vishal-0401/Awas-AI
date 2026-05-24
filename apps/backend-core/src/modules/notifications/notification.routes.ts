import { Router } from 'express';
import { NotificationController } from './notification.controller';
import { authenticate } from '../../common/middleware/auth.middleware';

const router = Router();
const notificationController = new NotificationController();

router.use(authenticate);

router.get('/', notificationController.getNotifications);
router.post('/read', notificationController.markAsRead);

export const notificationRoutes = router;
