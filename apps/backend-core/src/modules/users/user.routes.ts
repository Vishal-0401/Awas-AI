import { Router } from 'express';
import { UserController } from './user.controller';
import { authenticate } from '../../common/middleware/auth.middleware';

const router = Router();
const userController = new UserController();

router.use(authenticate);

router.get('/me', userController.getProfile);
router.put('/me', userController.updateProfile);
router.post('/address', userController.addAddress);
router.get('/addresses', userController.getAddresses);

export const userRoutes = router;
