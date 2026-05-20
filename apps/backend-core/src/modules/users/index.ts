import { Router } from 'express';
import { UserController } from './users.controller';
import { authGuard } from '../../common/guards/auth.guard';
import { validate } from '../../common/middleware/validate.middleware';
import { updateWorkerSchema } from '../../common/validators/schemas';

const router = Router();
const userController = new UserController();

router.get('/me', authGuard, userController.getProfile);
router.put('/me', authGuard, userController.updateProfile);

export default router;