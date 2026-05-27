import { Router } from 'express';
import { NotificationController } from '../controllers/notification.controller';
import { authenticate } from '../middleware/auth';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new NotificationController();

router.use(authenticate);
router.get('/', asyncHandler(controller.list));
router.patch('/:id/read', asyncHandler(controller.read));

export default router;
