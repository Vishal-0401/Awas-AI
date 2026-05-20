import { Router } from 'express';
import { PaymentController } from './payments.controller';
import { authGuard } from '../../common/guards/auth.guard';

const router = Router();
const paymentController = new PaymentController();

router.post('/charge', authGuard, paymentController.charge);
router.get('/history', authGuard, paymentController.getPaymentHistory);

export default router;