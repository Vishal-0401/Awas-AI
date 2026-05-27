import { Router } from 'express';
import { WalletController } from '../controllers/wallet.controller';
import { authenticate, requireRoles } from '../middleware/auth';
import { validateBody } from '../middleware/validate';
import { topUpSchema } from '../validators/schemas';
import { asyncHandler } from '../utils/asyncHandler';

const router = Router();
const controller = new WalletController();

router.use(authenticate, requireRoles('CUSTOMER'));
router.get('/', asyncHandler(controller.get));
router.get('/transactions', asyncHandler(controller.transactions));
router.post('/top-up', validateBody(topUpSchema), asyncHandler(controller.topUp));

export default router;
