import { Router } from 'express';
import { ChatController } from '../controllers/chat.controller';
import { authenticate } from '../middleware/auth';
import { validateBody } from '../middleware/validate';
import { chatMessageSchema } from '../validators/schemas';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new ChatController();

router.use(authenticate);
router.get('/:conversationId/messages', asyncHandler(controller.list));
router.post('/:conversationId/messages', validateBody(chatMessageSchema), asyncHandler(controller.send));

export default router;
