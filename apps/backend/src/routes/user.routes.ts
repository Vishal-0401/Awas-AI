import { Router } from 'express';
import { UserController } from '../controllers/user.controller';
import { authenticate, requireRoles } from '../middleware/auth';
import { validateBody } from '../middleware/validate';
import { addressSchema, completeProfileSchema, profileSchema } from '../validators/schemas';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new UserController();

router.use(authenticate, requireRoles('CUSTOMER', 'WORKER', 'ADMIN'));
router.get('/me', asyncHandler(controller.me));
router.patch('/me', validateBody(profileSchema), asyncHandler(controller.updateMe));
router.post('/me/complete-profile', validateBody(completeProfileSchema), asyncHandler(controller.completeProfile));
router.get('/addresses', asyncHandler(controller.listAddresses));
router.post('/addresses', validateBody(addressSchema), asyncHandler(controller.createAddress));
router.delete('/addresses/:id', asyncHandler(controller.deleteAddress));

export default router;
