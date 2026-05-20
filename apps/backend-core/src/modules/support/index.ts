import { Router } from 'express';
import { SupportController } from './support.controller';
import { authGuard } from '../../common/guards/auth.guard';

const router = Router();
const supportController = new SupportController();

router.post('/tickets', authGuard, supportController.createTicket);
router.get('/tickets', authGuard, supportController.getTickets);

export default router;